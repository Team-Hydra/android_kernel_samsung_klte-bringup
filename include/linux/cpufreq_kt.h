#include <linux/cpufreq.h>
#include <linux/cpu.h>

extern unsigned int vfreq_lock;

extern unsigned int isenable_oc;
extern unsigned int isBooted;

extern unsigned int model_type;

extern void set_screen_on_off_mhz(bool onoff);

extern void cpufreq_gov_suspend(void);
extern void cpufreq_gov_resume(void);

extern bool gkt_work_isinitd;
extern struct work_struct gkt_online_work;
extern struct workqueue_struct *gkt_wq;

extern void __ref gkt_online_work_fn(struct work_struct *work);
extern void gkt_work_init(void);
extern void gkt_boost_cpu_call(bool change_screen_state, bool boost_for_button);

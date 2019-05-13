Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABBD31B2BB
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 11:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbfEMJTY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 05:19:24 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:38105 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727576AbfEMJTY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 05:19:24 -0400
Received: by mail-ot1-f67.google.com with SMTP id s19so11065497otq.5;
        Mon, 13 May 2019 02:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ujdVx8/hOHAXTn+/pwv56Do81M/Ae/T+j37v3szZuZA=;
        b=r+7/Uj5OgiHJVo6bYPKFZntd8/2VvY01FDvmq94a5OmI7/EDko/mWs3R7zpIVFzQQP
         q3THuGsvjz0uYA6obt5vr1XQJX0c556O3TL2ED9WIGp2pIwKF08tee53h+fFSI4XacqW
         r/kfdp4bZckqQCwloqhwpagPU4QTsH3hAhrMlt5HP3af5BYaCjHyRzdbq/ybTEURP43y
         gCzAv5R8tPF5ABx6gWQectJCPEmIr2wgHMPsafq9MAQ4GlYq+pXN6NTT6Scq/KT3QcuT
         vXyWSoGbVVgBtz55/+NbMCFDwxd6fPsMZBAI5EUGIl1pZhFZNOQIpXu0kboMdKxMUH3l
         I58g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ujdVx8/hOHAXTn+/pwv56Do81M/Ae/T+j37v3szZuZA=;
        b=YO90CznyKh/iDvst1CwSVmss2ZCEzR1DIWbuq6AVl0aV93tH24t6cWuPPWxELEoIvC
         nLmC34a3f1xYOFrHxODBGllMNn9A0i765kVDvitdxw5aTMoFkzvbO+ZEjTkXY6nyEt0K
         VZgD83qD+uVqJZ+jnjw35Dahp68MvLdVxCVR0dQZVmlAPSckFAHZzR7J+zdIyOFyV8Ei
         Gdo80utiu0l2y7zvtx8gPUA/bEWMbYKX73//ei0m1dEf2lrIewNPDSHyPu22QVMeygxy
         A92zRFTAbyfohOtKVMHJeqNcpwqTt6atFT+gbvX/+doMGK3D6snF2748Kv5YipZd3drK
         lEGA==
X-Gm-Message-State: APjAAAVU1FemMp8FFm24jEdKEeGGzYzAro6VymSG3Ap9n0x4miWgifn/
        hwd+b7mnBnpuKnEiSZXseJ+yV4bBn5wAZIr/mjE=
X-Google-Smtp-Source: APXvYqygNFs08oY/relMZpc/d09rofQMTkf7ccwOd7iCguFZlNc7h56VryKgAP6n9gMXy3DbSMnkFlg0/vX11zr1TXE=
X-Received: by 2002:a05:6830:1389:: with SMTP id d9mr30479otq.329.1557739162822;
 Mon, 13 May 2019 02:19:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190507185647.GA29409@amt.cnet>
In-Reply-To: <20190507185647.GA29409@amt.cnet>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 13 May 2019 17:20:37 +0800
Message-ID: <CANRm+Cx8zCDG6Oz1m9eukkmx_uVFYcQOdMwZrHwsQcbLm_kuPA@mail.gmail.com>
Subject: Re: [PATCH] sched: introduce configurable delay before entering idle
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm-devel <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Bandan Das <bsd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 May 2019 at 02:57, Marcelo Tosatti <mtosatti@redhat.com> wrote:
>
>
> Certain workloads perform poorly on KVM compared to baremetal
> due to baremetal's ability to perform mwait on NEED_RESCHED
> bit of task flags (therefore skipping the IPI).

KVM supports expose mwait to the guest, if it can solve this?

Regards,
Wanpeng Li

>
> This patch introduces a configurable busy-wait delay before entering the
> architecture delay routine, allowing wakeup IPIs to be skipped
> (if the IPI happens in that window).
>
> The real-life workload which this patch improves performance
> is SAP HANA (by 5-10%) (for which case setting idle_spin to 30
> is sufficient).
>
> This patch improves the attached server.py and client.py example
> as follows:
>
> Host:                           31.814230202231556
> Guest:                          38.17718765199993       (83 %)
> Guest, idle_spin=50us:          33.317709898000004      (95 %)
> Guest, idle_spin=220us:         32.27826551499999       (98 %)
>
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
>
> ---
>  kernel/sched/idle.c |   86 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 86 insertions(+)
>
> diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
> index f5516bae0c1b..bca7656a7ea0 100644
> --- a/kernel/sched/idle.c
> +++ b/kernel/sched/idle.c
> @@ -216,6 +216,29 @@ static void cpuidle_idle_call(void)
>         rcu_idle_exit();
>  }
>
> +static unsigned int spin_before_idle_us;
>
> +static void do_spin_before_idle(void)
> +{
> +       ktime_t now, end_spin;
> +
> +       now = ktime_get();
> +       end_spin = ktime_add_ns(now, spin_before_idle_us*1000);
> +
> +       rcu_idle_enter();
> +       local_irq_enable();
> +       stop_critical_timings();
> +
> +       do {
> +               cpu_relax();
> +               now = ktime_get();
> +       } while (!tif_need_resched() && ktime_before(now, end_spin));
> +
> +       start_critical_timings();
> +       rcu_idle_exit();
> +       local_irq_disable();
> +}
> +
>  /*
>   * Generic idle loop implementation
>   *
> @@ -259,6 +282,8 @@ static void do_idle(void)
>                         tick_nohz_idle_restart_tick();
>                         cpu_idle_poll();
>                 } else {
> +                       if (spin_before_idle_us)
> +                               do_spin_before_idle();
>                         cpuidle_idle_call();
>                 }
>                 arch_cpu_idle_exit();
> @@ -465,3 +490,64 @@ const struct sched_class idle_sched_class = {
>         .switched_to            = switched_to_idle,
>         .update_curr            = update_curr_idle,
>  };
> +
> +
> +static ssize_t store_idle_spin(struct kobject *kobj,
> +                              struct kobj_attribute *attr,
> +                              const char *buf, size_t count)
> +{
> +       unsigned int val;
> +
> +       if (kstrtouint(buf, 10, &val) < 0)
> +               return -EINVAL;
> +
> +       if (val > USEC_PER_SEC)
> +               return -EINVAL;
> +
> +       spin_before_idle_us = val;
> +       return count;
> +}
> +
> +static ssize_t show_idle_spin(struct kobject *kobj,
> +                             struct kobj_attribute *attr,
> +                             char *buf)
> +{
> +       ssize_t ret;
> +
> +       ret = sprintf(buf, "%d\n", spin_before_idle_us);
> +
> +       return ret;
> +}
> +
> +static struct kobj_attribute idle_spin_attr =
> +       __ATTR(idle_spin, 0644, show_idle_spin, store_idle_spin);
> +
> +static struct attribute *sched_attrs[] = {
> +       &idle_spin_attr.attr,
> +       NULL,
> +};
> +
> +static const struct attribute_group sched_attr_group = {
> +       .attrs = sched_attrs,
> +};
> +
> +static struct kobject *sched_kobj;
> +
> +static int __init sched_sysfs_init(void)
> +{
> +       int error;
> +
> +       sched_kobj = kobject_create_and_add("sched", kernel_kobj);
> +       if (!sched_kobj)
> +               return -ENOMEM;
> +
> +       error = sysfs_create_group(sched_kobj, &sched_attr_group);
> +       if (error)
> +               goto err;
> +       return 0;
> +
> +err:
> +       kobject_put(sched_kobj);
> +       return error;
> +}
> +postcore_initcall(sched_sysfs_init);

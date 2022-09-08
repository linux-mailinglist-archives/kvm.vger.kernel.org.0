Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22B515B2698
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 21:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbiIHTP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 15:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiIHTPY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 15:15:24 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4232374E29;
        Thu,  8 Sep 2022 12:15:23 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id t3so13786688ply.2;
        Thu, 08 Sep 2022 12:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=YHnvyDtge2bDMZCHRPm32H8ARMZYnaM9vFyOk1RCgm8=;
        b=IhF/5QBj7WQlQU/W89KkP51CbnOxpPC2/mmJkNa8i+KZK46QjfKrzL+FbCKdZb+z5W
         zYPEN/yi1BfBnOL/ARfTcDPr1wxcBorVtB+0vVqM3myv3bzDBZAkmS919Z+QJnn7kR3W
         ToMMmYoZCvVW160AjxJNSyE5doDbaYCDsgFJ3UmBuiCbFKpif8CRtIDPIsDVCAonvmc4
         2Z0vYiyF9HNB+tlYDD29cFvy+HA2GewWq4RHP9WfwJv8XxHEYCGTBdUHVnoPo4RmO7Ts
         Q3lF3EKAwxJCXdFecNH4y4nAMp/JQILgb0rIvhleNanDlT1QKWOt9NvD8cw1jmqGrV7r
         Sz7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=YHnvyDtge2bDMZCHRPm32H8ARMZYnaM9vFyOk1RCgm8=;
        b=giymR5QqTfWak6/9og31prdZw7iSuQhMYsV8+TI2eRRsCKGMPsMiKdyjxWnUZg2Cpf
         d26kpV14z6IZUcZuFvTKJx+GsFcKNxv4fHa6WDDcTWSE/Q3v8peCOwxIc4Mrevm2RZ94
         E+OY/XpU/IOYnlExO8Sa/afPXva+W/pzSSngrcj3Efhc/Xhxdwt4LyxvXzxbCP5OOruX
         s/gHv1RoQ/73KsbrUnhh9t/PfqOt366I0k3sx5hbw7X0A5opb0gERIeGCSVXMZP6pxeS
         0wj2RfAz4bWs+iYcfBPmf1w+CpswhZIAHtGfNs9Ub3Al1n/sbSnFhrK9QL3ojHipGAbd
         KVKQ==
X-Gm-Message-State: ACgBeo2l/B5fG25Da7+JKjuOXED3e+lUUDTYKqm9f2pnCFSPMhA7W3ST
        FXQrQ2j8j8foK83Ibr6+ghg=
X-Google-Smtp-Source: AA6agR72v/cOfySC/mUUrrmMeYykkaeiOnKAj9Q6cCxt54+ZAUoMaPiSDQEWjyzQLw1WyAXpje4ULA==
X-Received: by 2002:a17:903:2309:b0:176:de48:e940 with SMTP id d9-20020a170903230900b00176de48e940mr10272559plh.15.1662664522664;
        Thu, 08 Sep 2022 12:15:22 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id bf10-20020a170902b90a00b00172ff99d0afsm14977203plb.140.2022.09.08.12.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 12:15:21 -0700 (PDT)
Date:   Thu, 8 Sep 2022 12:15:20 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     isaku.yamahata@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        isaku.yamahata@gmail.com, Kai Huang <kai.huang@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v3 14/22] KVM: Move out KVM arch PM hooks and hardware
 enable/disable logic
Message-ID: <20220908191520.GD470011@ls.amr.corp.intel.com>
References: <cover.1662084396.git.isaku.yamahata@intel.com>
 <1c0165a7d2dd22810d9ae2cf8cf474a2e6dcb6d7.1662084396.git.isaku.yamahata@intel.com>
 <20220906074358.hwchunz6vdxefzb6@yy-desk-7060>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220906074358.hwchunz6vdxefzb6@yy-desk-7060>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 06, 2022 at 03:43:58PM +0800,
Yuan Yao <yuan.yao@linux.intel.com> wrote:

> On Thu, Sep 01, 2022 at 07:17:49PM -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> > To make clear that those files are default implementation that KVM/x86 (and
> > other KVM arch in future) will override them, split out those into a single
> > file. Once conversions for all kvm archs are done, the file will be
> > deleted.  kvm_arch_pre_hardware_unsetup() is introduced to avoid cross-arch
> > code churn for now.  Once it's settled down,
> > kvm_arch_pre_hardware_unsetup() can be merged into
> > kvm_arch_hardware_unsetup() in each arch code.
> >
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  include/linux/kvm_host.h |   1 +
> >  virt/kvm/kvm_arch.c      | 103 ++++++++++++++++++++++-
> >  virt/kvm/kvm_main.c      | 172 +++++----------------------------------
> >  3 files changed, 124 insertions(+), 152 deletions(-)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index f78364e01ca9..60f4ae9d6f48 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1437,6 +1437,7 @@ static inline void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
> >  int kvm_arch_hardware_enable(void);
> >  void kvm_arch_hardware_disable(void);
> >  int kvm_arch_hardware_setup(void *opaque);
> > +void kvm_arch_pre_hardware_unsetup(void);
> >  void kvm_arch_hardware_unsetup(void);
> >  int kvm_arch_check_processor_compat(void);
> >  int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
> > diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
> > index 0eac996f4981..0648d4463d9e 100644
> > --- a/virt/kvm/kvm_arch.c
> > +++ b/virt/kvm/kvm_arch.c
> > @@ -6,49 +6,148 @@
> >   * Author:
> >   *   Isaku Yamahata <isaku.yamahata@intel.com>
> >   *                  <isaku.yamahata@gmail.com>
> > + *
> > + * TODO: Delete this file once the conversion of all KVM arch is done.
> >   */
> >
> >  #include <linux/kvm_host.h>
> >
> > +static cpumask_t cpus_hardware_enabled = CPU_MASK_NONE;
> > +static atomic_t hardware_enable_failed;
> > +
> >  __weak int kvm_arch_post_init_vm(struct kvm *kvm)
> >  {
> >  	return 0;
> >  }
> >
> > +static void hardware_enable_nolock(void *caller_name)
> > +{
> > +	int cpu = raw_smp_processor_id();
> > +	int r;
> > +
> > +	WARN_ON_ONCE(preemptible());
> > +
> > +	if (cpumask_test_cpu(cpu, &cpus_hardware_enabled))
> > +		return;
> > +
> > +	cpumask_set_cpu(cpu, &cpus_hardware_enabled);
> > +
> > +	r = kvm_arch_hardware_enable();
> > +
> > +	if (r) {
> > +		cpumask_clear_cpu(cpu, &cpus_hardware_enabled);
> > +		atomic_inc(&hardware_enable_failed);
> > +		pr_warn("kvm: enabling virtualization on CPU%d failed during %s()\n",
> > +			cpu, (const char *)caller_name);
> > +	}
> > +}
> > +
> > +static void hardware_disable_nolock(void *junk)
> > +{
> > +	int cpu = raw_smp_processor_id();
> > +
> > +	WARN_ON_ONCE(preemptible());
> > +
> > +	if (!cpumask_test_cpu(cpu, &cpus_hardware_enabled))
> > +		return;
> > +	cpumask_clear_cpu(cpu, &cpus_hardware_enabled);
> > +	kvm_arch_hardware_disable();
> > +}
> > +
> > +__weak void kvm_arch_pre_hardware_unsetup(void)
> > +{
> > +	on_each_cpu(hardware_disable_nolock, NULL, 1);
> > +}
> > +
> >  /*
> >   * Called after the VM is otherwise initialized, but just before adding it to
> >   * the vm_list.
> >   */
> >  __weak int kvm_arch_add_vm(struct kvm *kvm, int usage_count)
> >  {
> > -	return kvm_arch_post_init_vm(kvm);
> > +	int r = 0;
> > +
> > +	if (usage_count != 1)
> > +		return 0;
> > +
> > +	atomic_set(&hardware_enable_failed, 0);
> > +	on_each_cpu(hardware_enable_nolock, (void *)__func__, 1);
> 
> 
> This function is called in kvm_create_vm:
> 
>  kvm_create_vm {
>  ...
>    enable_hardware_all()
>  ...
>    kvm_arch_add_vm()
>  ...
> }
> 
> so don't need on_each_cpu(enable_hardware_nolock) here, or the
> enable_hardware_all() shuold be removed from kvm_create_vm().


Yes, it's removed. Please notice the following hunk.

@@ -1196,10 +1191,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
      if (r)
              goto out_err_no_arch_destroy_vm;

-     r = hardware_enable_all();
-     if (r)
-             goto out_err_no_disable;
-
 #ifdef CONFIG_HAVE_KVM_IRQFD
      INIT_HLIST_HEAD(&kvm->irq_ack_notifier_list);
 #endif
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

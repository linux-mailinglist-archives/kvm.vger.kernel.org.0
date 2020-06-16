Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A7B1FA959
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 09:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgFPHAt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 03:00:49 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45309 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726091AbgFPHAl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Jun 2020 03:00:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592290838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FTWGiEqxbtnl7ib3O5+JRusE5qrGMfJO+4/itj4GaBU=;
        b=F00Yvg95PHAjZFN1EMmIIzesZD8eW+ZpyLYn5C6qB5vTPjtScAbKApcB/KJJU+btG7HICm
        lvLvRoa+BgOmtZeG2oS0AgDCy5RM/dTKpyiq7O+LJBSmxQ23AsSGOWzJRNX8+/eq4FxJR9
        0tANik5K7EWGk5HUHH/WINonvxc0AQY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-QrIPxlgWO_-FZm5MuIwQFA-1; Tue, 16 Jun 2020 03:00:13 -0400
X-MC-Unique: QrIPxlgWO_-FZm5MuIwQFA-1
Received: by mail-ej1-f69.google.com with SMTP id ch1so8917122ejb.18
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 00:00:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=FTWGiEqxbtnl7ib3O5+JRusE5qrGMfJO+4/itj4GaBU=;
        b=sp3RwG3HzsnyFKGr22uYehjb26jdIkLVC2V0ICHUc2n3Jymf+6ig65tSBdHICmMcnR
         bfTfIQ2JkIDg+BXQnomh6c4AgHIFZnOiZfzz54ECghnJFvnRU4TAt/BDkD+O4IHc56vp
         K7zUmQfUiPm4gx5K61Kk4d6OdZf5W7rTAyLOLudhm5j7bxvfWb7pZ8Sy8oWgvDtsRxLP
         5FQFbu6v8Sy1ilXQBo7esQgG25BXgpxjrO+jzkNYgFx+YQ1eBra7PY29iL3wyJd1j86X
         i3c99D9WH4Mz2HctEsrVVvqN2FQnlJflVSF7Lc23p1cBAGc5sD1AOtCV8G0zxD9Cjpnj
         uGtA==
X-Gm-Message-State: AOAM532kx8mbzb9j8th7YmW0TluYEFD06jq52ltE9WcGjwjnL4ZxAG0t
        HMw2CKVlJuSewi3+e3+Qn9rgxDPwVGTUrqiHgtETTA70ZUEUDXt7m3ESEAd1LyJEkB6Ch8r6YjG
        O4hu0dsJleZqx
X-Received: by 2002:a17:906:3456:: with SMTP id d22mr1382219ejb.358.1592290811628;
        Tue, 16 Jun 2020 00:00:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzHASPyt1T3FV2KIG7bReUaRse2T1c+PUm0fSgKofbCrqv4QYHbL7TxSd8mj9c5Uv1FQCbzdw==
X-Received: by 2002:a17:906:3456:: with SMTP id d22mr1382194ejb.358.1592290811377;
        Tue, 16 Jun 2020 00:00:11 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id a62sm9463779edf.38.2020.06.16.00.00.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 00:00:10 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kernel test robot <lkp@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>
Subject: Re: [kvm:kvm-async-pf-int-5.8 3/6] arch/x86/kernel/kvm.c:330:6: warning: Variable 'pa' is reassigned a value before the old one has been used.
In-Reply-To: <202006161327.d4RqWvaG%lkp@intel.com>
References: <202006161327.d4RqWvaG%lkp@intel.com>
Date:   Tue, 16 Jun 2020 09:00:09 +0200
Message-ID: <87h7vbijgm.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kernel test robot <lkp@intel.com> writes:

> tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-async-pf-int-5.8
> head:   62a9576cc07b7dcba951aaa00d6a55933c49367e
> commit: b1d405751cd5792856b1b8333aafaca6bf09ccbb [3/6] KVM: x86: Switch KVM guest to using interrupts for page ready APF delivery
> compiler: gcc-9 (Debian 9.3.0-13) 9.3.0
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
>
> cppcheck warnings: (new ones prefixed by >>)
>
>>> arch/x86/kernel/kvm.c:330:6: warning: Variable 'pa' is reassigned a value before the old one has been used. [redundantAssignment]
>      pa = slow_virt_to_phys(this_cpu_ptr(&apf_reason));
>         ^
>    arch/x86/kernel/kvm.c:326:0: note: Variable 'pa' is reassigned a value before the old one has been used.
>      u64 pa = slow_virt_to_phys(this_cpu_ptr(&apf_reason));
>    ^
>    arch/x86/kernel/kvm.c:330:6: note: Variable 'pa' is reassigned a value before the old one has been used.
>      pa = slow_virt_to_phys(this_cpu_ptr(&apf_reason));
>         ^
>
> vim +/pa +330 arch/x86/kernel/kvm.c
>
> ab9cf4996bb989 Michael S. Tsirkin 2012-06-24  322  
> ed3cf15271fa15 Nicholas Krause    2015-05-20  323  static void kvm_guest_cpu_init(void)
> fd10cde9294f73 Gleb Natapov       2010-10-14  324  {
> b1d405751cd579 Vitaly Kuznetsov   2020-05-25  325  	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_INT) && kvmapf) {
> b1d405751cd579 Vitaly Kuznetsov   2020-05-25  326  		u64 pa = slow_virt_to_phys(this_cpu_ptr(&apf_reason));

Leftover from previous version, this should just be 'u64 pa;'

> ef68017eb5704e Andy Lutomirski    2020-02-28  327  
> ef68017eb5704e Andy Lutomirski    2020-02-28  328  		WARN_ON_ONCE(!static_branch_likely(&kvm_async_pf_enabled));
> ef68017eb5704e Andy Lutomirski    2020-02-28  329  
> ef68017eb5704e Andy Lutomirski    2020-02-28 @330  		pa = slow_virt_to_phys(this_cpu_ptr(&apf_reason));
> b1d405751cd579 Vitaly Kuznetsov   2020-05-25  331  		pa |= KVM_ASYNC_PF_ENABLED | KVM_ASYNC_PF_DELIVERY_AS_INT;
> 52a5c155cf79f1 Wanpeng Li         2017-07-13  332  
> fe2a3027e74e40 Radim Krčmář       2018-02-01  333  		if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_VMEXIT))
> fe2a3027e74e40 Radim Krčmář       2018-02-01  334  			pa |= KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT;
> fe2a3027e74e40 Radim Krčmář       2018-02-01  335  
> b1d405751cd579 Vitaly Kuznetsov   2020-05-25  336  		wrmsrl(MSR_KVM_ASYNC_PF_INT, HYPERVISOR_CALLBACK_VECTOR);
> b1d405751cd579 Vitaly Kuznetsov   2020-05-25  337  
> 52a5c155cf79f1 Wanpeng Li         2017-07-13  338  		wrmsrl(MSR_KVM_ASYNC_PF_EN, pa);
> 89cbc76768c2fa Christoph Lameter  2014-08-17  339  		__this_cpu_write(apf_reason.enabled, 1);
> 6bca69ada4bc20 Thomas Gleixner    2020-03-07  340  		pr_info("KVM setup async PF for cpu %d\n", smp_processor_id());
> fd10cde9294f73 Gleb Natapov       2010-10-14  341  	}
> d910f5c1064d7f Glauber Costa      2011-07-11  342  
> ab9cf4996bb989 Michael S. Tsirkin 2012-06-24  343  	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI)) {
> ab9cf4996bb989 Michael S. Tsirkin 2012-06-24  344  		unsigned long pa;
> 6bca69ada4bc20 Thomas Gleixner    2020-03-07  345  
> ab9cf4996bb989 Michael S. Tsirkin 2012-06-24  346  		/* Size alignment is implied but just to make it explicit. */
> ab9cf4996bb989 Michael S. Tsirkin 2012-06-24  347  		BUILD_BUG_ON(__alignof__(kvm_apic_eoi) < 4);
> 89cbc76768c2fa Christoph Lameter  2014-08-17  348  		__this_cpu_write(kvm_apic_eoi, 0);
> 89cbc76768c2fa Christoph Lameter  2014-08-17  349  		pa = slow_virt_to_phys(this_cpu_ptr(&kvm_apic_eoi))
> 5dfd486c4750c9 Dave Hansen        2013-01-22  350  			| KVM_MSR_ENABLED;
> ab9cf4996bb989 Michael S. Tsirkin 2012-06-24  351  		wrmsrl(MSR_KVM_PV_EOI_EN, pa);
> ab9cf4996bb989 Michael S. Tsirkin 2012-06-24  352  	}
> ab9cf4996bb989 Michael S. Tsirkin 2012-06-24  353  
> d910f5c1064d7f Glauber Costa      2011-07-11  354  	if (has_steal_clock)
> d910f5c1064d7f Glauber Costa      2011-07-11  355  		kvm_register_steal_time();
> fd10cde9294f73 Gleb Natapov       2010-10-14  356  }
> fd10cde9294f73 Gleb Natapov       2010-10-14  357  
>
> :::::: The code at line 330 was first introduced by commit
> :::::: ef68017eb5704eb2b0577c3aa6619e13caf2b59f x86/kvm: Handle async page faults directly through do_page_fault()
>
> :::::: TO: Andy Lutomirski <luto@kernel.org>
> :::::: CC: Thomas Gleixner <tglx@linutronix.de>
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
>

-- 
Vitaly


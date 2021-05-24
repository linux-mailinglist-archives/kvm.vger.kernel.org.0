Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B7038E235
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 10:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbhEXIXP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 04:23:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22736 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232279AbhEXIXO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 04:23:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621844506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uxHLbW472ZdWlqCcIodXanbrmmQ0DbKZfun6OXT73oc=;
        b=NevwByp/87BBPIUFvG35uAo1jWmCwdvxSlpkjoFW9yyACoHSdfbW3p4VNiTpk6LnHYffBU
        POA/ABJTqdepHkjdZfDYay47LSZe0L805oIcCG9IaYnYKYSaE/w3kRTdAJwHQPZnz6LSCT
        AKI91oGc0hY2XkMhPLwPBiffJIqpYYY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-E0ouvWRPO5i1YDGKLX4V2A-1; Mon, 24 May 2021 04:21:44 -0400
X-MC-Unique: E0ouvWRPO5i1YDGKLX4V2A-1
Received: by mail-wr1-f70.google.com with SMTP id 22-20020adf82960000b02901115ae2f734so12728157wrc.5
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 01:21:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=uxHLbW472ZdWlqCcIodXanbrmmQ0DbKZfun6OXT73oc=;
        b=XRXKUvTjMiW0hPm+kcf85DSUuisdOgAQYSpMuqiPlljKfmPiP1bhg26Wsr9t+EAKKX
         gbv2ryDYNsqpwqJCHYwhBBYqXGw3m+B9Tijy3/e/ZcK4omHOR05kCtXG488wDOPw+jJU
         NNR//oJyfZUVbAMC8Od08+t+/3YLScgE0G60k1cZy90E+ZSe6ZOWgC8qGeCEuSvqr7/p
         gLcgIb2AGdg8iH2afrHfEC3ZsFXnax4WT3JIXcwrE8lepDYPlHaGLxzoVcKJ5FhVbKlo
         6yDn4KgQrOH6nvSHB3RGS7Rw1X5Lnq8d/F5RNNj3amkscgxupPwaDlLUAUwvwNCQFXZT
         agTg==
X-Gm-Message-State: AOAM530F6ZZfQu/PD9RWKADZIS2TPjWwxuJB79aIPB1qC3/y36zQNPoh
        ulvw/axF3bizHVLx4SqG+omvKmv2GvtdBeXURi4Gs0/yxz3N1eEkyNKXtwSZOgTkAr8KAWbEoAM
        nI8vD5DpbH19T
X-Received: by 2002:adf:d221:: with SMTP id k1mr21133929wrh.298.1621844503103;
        Mon, 24 May 2021 01:21:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz49DvDObSGAsM3eDwpLLTm7kZPVR87IHL1HQ8f2JI4p1CiWYoflcq0xZBX0D1ObC66rEUYrw==
X-Received: by 2002:adf:d221:: with SMTP id k1mr21133917wrh.298.1621844502923;
        Mon, 24 May 2021 01:21:42 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id b10sm13420910wrr.27.2021.05.24.01.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 01:21:42 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Liang Li <liliang324@gmail.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Tianyu.Lan@microsoft.com
Subject: Re: About the performance of hyper-v
In-Reply-To: <CA+2MQi-OK5zK_sBtm8k-nnqVPQTSzE1UVTEfQ4KBChMHc=Npzg@mail.gmail.com>
References: <CA+2MQi-_06J1cmLhKAmV1vkPEnvDx6+bOnK06OciYmdymaNruw@mail.gmail.com>
 <87cztmkdlp.fsf@vitty.brq.redhat.com>
 <CA+2MQi_LG57KRRFjMR_zPvJBDaH4z16S5J=c+U+-Ss_Z71Ax7g@mail.gmail.com>
 <87y2c8iia0.fsf@vitty.brq.redhat.com>
 <CA+2MQi-OK5zK_sBtm8k-nnqVPQTSzE1UVTEfQ4KBChMHc=Npzg@mail.gmail.com>
Date:   Mon, 24 May 2021 10:21:41 +0200
Message-ID: <87k0no4k4q.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Liang Li <liliang324@gmail.com> writes:

>> >> > Analyze events for all VMs, all VCPUs:
>> >> >              VM-EXIT    Samples  Samples%     Time%    Min Time    Max
>> >> > Time         Avg time
>> >> >   EXTERNAL_INTERRUPT     471831    59.89%    68.58%      0.64us
>> >> > 65.42us      2.34us ( +-   0.11% )
>> >> >            MSR_WRITE     238932    30.33%    23.07%      0.48us
>> >> > 41.05us      1.56us ( +-   0.14% )
>> >> >
>> >> > Total Samples:787803, Total events handled time:1611193.84us.
>> >> >
>> >> > I tried turning off hyper-v for the same workload and repeat the test,
>> >> > the overall virtualization overhead reduced by about of 50%:
>> >> >
>> >> > -------
>> >> >
>> >> > Analyze events for all VMs, all VCPUs:
>> >> >
>> >> >              VM-EXIT    Samples  Samples%     Time%    Min Time    Max
>> >> > Time         Avg time
>> >> >           APIC_WRITE     255152    74.43%    50.72%      0.49us
>> >> > 50.01us      1.42us ( +-   0.14% )
>> >> >        EPT_MISCONFIG      39967    11.66%    40.58%      1.55us
>> >> > 686.05us      7.27us ( +-   0.43% )
>> >> >            DR_ACCESS      35003    10.21%     4.64%      0.32us
>> >> > 40.03us      0.95us ( +-   0.32% )
>> >> >   EXTERNAL_INTERRUPT       6622     1.93%     2.08%      0.70us
>> >> > 57.38us      2.25us ( +-   1.42% )
>> >> >
>> >> > Total Samples:342788, Total events handled time:715695.62us.
>> >> >
>> >> > For this scenario,  hyper-v works really bad.  stimer works better
>> >> > than hpet, but on the other hand, it relies on SynIC which has
>> >> > negative effects for IPI intensive workloads.
>> >> > Do you have any plans for improvement?
>> >> >
>> >>
>> >> Hey,
>> >>
>> >> the above can be caused by the fact that when 'hv-synic' is enabled, KVM
>> >> automatically disables APICv and this can explain the overhead and the
>> >> fact that you're seeing more vmexits. KVM disables APICv because SynIC's
>> >> 'AutoEOI' feature is incompatible with it. We can, however, tell Windows
>> >> to not use AutoEOI ('Recommend deprecating AutoEOI' bit) and only
>> >> inhibit APICv if the recommendation was ignored. This is implemented in
>> >> the following KVM patch series:
>> >> https://lore.kernel.org/kvm/20210518144339.1987982-1-vkuznets@redhat.com/
>> >>
>> >> It will, however, require a new 'hv-something' flag to QEMU. For now, it
>> >> can be tested with 'hv-passthrough'.
>> >>
>> >> It would be great if you could give it a spin!
>> >>
>> >> --
>> >> Vitaly
>> >
>> > It's great to know that you already have a solution for this. :)
>> >
>> > By the way,  is there any requirement for the version of windows or
>> > windows updates for the new feature to work?
>>
>> AFAIR, 'Recommend deprecating AutoEOI' bit appeared in WS2012 so I'd
>> expect WS2008 to ignore it completely (and thus SynIC will always be
>> disabling APICv for it).
>>
>
> Hi Vitaly,
>       I tried your patchset and found it's not helpful to reduce the
> virtualization overhead.
> here are some perfdata with the same workload
>
> ===============================
> Analyze events for all VMs, all VCPUs:
>              VM-EXIT    Samples  Samples%     Time%    Min Time    Max
> Time         Avg time
>            MSR_WRITE     924045    89.96%    81.10%      0.42us
> 68.42us      1.26us ( +-   0.07% )
>            DR_ACCESS      44669     4.35%     2.36%      0.32us
> 50.74us      0.76us ( +-   0.32% )
>   EXTERNAL_INTERRUPT      29809     2.90%     6.42%      0.66us
> 70.75us      3.10us ( +-   0.54% )
>               VMCALL      17819     1.73%     5.21%      0.75us
> 15.64us      4.20us ( +-   0.33%
>
> Total Samples:1027227, Total events handled time:1436343.94us.
> ===============================
>
> The result shows the overhead increased.  enable the apicv can help to
> reduce the vm-exit
> caused by interrupt injection, but on the other side, there are a lot
> of vm-exit caused by APIC_EOI.
>
> When turning off the hyper-v and using the kvm apicv, there is no such
> overhead. 

I think I know what's happening. We've asked Windows to use synthetic
MSRs to access APIC (HV_APIC_ACCESS_RECOMMENDED) and this can't be
accelerated in hardware.

Could you please try the following hack (KVM):

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c8f2592ccc99..66ee85a83e9a 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -145,6 +145,13 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
                                           vcpu->arch.ia32_misc_enable_msr &
                                           MSR_IA32_MISC_ENABLE_MWAIT);
        }
+
+       /* Dirty hack: force HV_DEPRECATING_AEOI_RECOMMENDED. Not to be merged! */
+       best = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_ENLIGHTMENT_INFO, 0);
+       if (best) {
+               best->eax &= ~HV_X64_APIC_ACCESS_RECOMMENDED;
+               best->eax |= HV_DEPRECATING_AEOI_RECOMMENDED;
+       }
 }
 EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
 
> It seems turning on hyper V related features is not always the best
> choice for a windows guest.

Generally it is, we'll just need to make QEMU smarter when setting
'recommendation' bits.

-- 
Vitaly


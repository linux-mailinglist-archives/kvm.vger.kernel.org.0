Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E03551C536B
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 12:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbgEEKiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 06:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728238AbgEEKiZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 06:38:25 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD099C061A0F;
        Tue,  5 May 2020 03:38:24 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id u127so1766678wmg.1;
        Tue, 05 May 2020 03:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qdvXRHV49KZiDqe+v5s5lVLMQu37AOtnKETx3EmPlpw=;
        b=JsnoShICFFrQ+8QGcwDk46zqHVdYbrUXy1Kuqe88AnIJvMaDQS0DCTcKsxE6fhFReW
         57z/KFzZ7ekwcmU2d8eXW1VXVgATQY3Nvb3yPL8DS36EpxlqT108jdaytJxeCZFtPPaw
         vEe8tNqpptRhIviRvVfY/+FNvmKw32ihJOu0xytvKNX4Gec7HFKo8OAcQctF1czpUHrF
         qwQbpXNJa+/o/sXtLTppmsJ3zS7pI3TdrFaoJZ2yD3WrCdRbx42Y/r23sE0XjZ+kzejN
         jF/gM38m1tFxPtoVMdB00che32EOCtk0gQ5OhQFiC3PteM6+Fb9K/J2oQhlWpSBrU3fH
         V9Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qdvXRHV49KZiDqe+v5s5lVLMQu37AOtnKETx3EmPlpw=;
        b=j7xYFiQO2VZMEuLZrUmuT9S0XLufe99EBVl8lyUCxBs+bcUVZvDMyO3hfEq5OVMCNB
         IjxHZL3OGXEKTIzihHy/D1OnUU2lC+MDWSC6QQjE3Wa66mzolnuCtLvMPfO2qVfMVQdi
         38dfSffG6JpTO3wVcWK4g5/uXbAhTD85H6/KtIE6sTpLC8/wCBsU34X2pHkty4sv/pAn
         /DX2ORi65XGeQTwgBY9JxmCVha3JyqbyTBwOOdIeYg0hsAKs567Jjbo7mXck8ZZH3T1m
         iEk7SA9IvFopvvE2N3FBB4xFmB8wkK9Aa7Jy6+9nvWyaQJLldg0hj/Uot2J+R/GtokCo
         fbQw==
X-Gm-Message-State: AGi0PuZJci0nmWy3A/sGqzwlWNPpiMfaQh0pqalzZFfQnvECbXF/cyOn
        Eabcy5IsCI19FYoTrm3ggZNl2Bm6dz8=
X-Google-Smtp-Source: APiQypKGXYuyWK4FBwaqWCWPuo5VBCJNcCtPeJ1uRgXzanGAsJ2MSY9D794RDIm0MYPfDiHcgi850g==
X-Received: by 2002:a1c:7d04:: with SMTP id y4mr2740141wmc.10.1588675103469;
        Tue, 05 May 2020 03:38:23 -0700 (PDT)
Received: from jondnuc (IGLD-84-229-154-20.inter.net.il. [84.229.154.20])
        by smtp.gmail.com with ESMTPSA id k9sm2625894wrd.17.2020.05.05.03.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 03:38:22 -0700 (PDT)
Date:   Tue, 5 May 2020 13:38:21 +0300
From:   Jon Doron <arilou@gmail.com>
To:     Roman Kagan <rvkagan@yandex-team.ru>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v2 0/1] x86/kvm/hyper-v: Add support to SYNIC exit on EOM
Message-ID: <20200505103821.GB2862@jondnuc>
References: <20200416083847.1776387-1-arilou@gmail.com>
 <20200416120040.GA3745197@rvkaganb>
 <20200416125430.GL7606@jondnuc>
 <20200417104251.GA3009@rvkaganb>
 <20200418064127.GB1917435@jondnuc>
 <20200424133742.GA2439920@rvkaganb>
 <20200425061637.GF1917435@jondnuc>
 <20200503191900.GA389956@rvkaganb>
 <87a72nelup.fsf@vitty.brq.redhat.com>
 <20200505080158.GA400685@rvkaganb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200505080158.GA400685@rvkaganb>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/05/2020, Roman Kagan wrote:
>On Mon, May 04, 2020 at 05:55:10PM +0200, Vitaly Kuznetsov wrote:
>> Roman Kagan <rvkagan@yandex-team.ru> writes:
>>
>> > On Sat, Apr 25, 2020 at 09:16:37AM +0300, Jon Doron wrote:
>> >
>> >> If that's indeed the case then probably the only thing needs fixing in my
>> >> scenario is in QEMU where it should not really care for the SCONTROL if it's
>> >> enabled or not.
>> >
>> > Right.  However, even this shouldn't be necessary as SeaBIOS from that
>> > branch would enable SCONTROL and leave it that way when passing the
>> > control over to the bootloader, so, unless something explicitly clears
>> > SCONTROL, it should remain set thereafter.  I'd rather try going ahead
>> > with that scheme first, because making QEMU ignore SCONTROL appears to
>> > violate the spec.
>>
>> FWIW, I just checked 'genuine' Hyper-V 2016 with
>>
>> diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
>> index fd51bac11b46..c5ea759728d9 100644
>> --- a/arch/x86/hyperv/hv_init.c
>> +++ b/arch/x86/hyperv/hv_init.c
>> @@ -314,10 +314,14 @@ void __init hyperv_init(void)
>>         u64 guest_id, required_msrs;
>>         union hv_x64_msr_hypercall_contents hypercall_msr;
>>         int cpuhp, i;
>> +       u64 val;
>>
>>         if (x86_hyper_type != X86_HYPER_MS_HYPERV)
>>                 return;
>>
>> +       hv_get_synic_state(val);
>> +       printk("Hyper-V: SCONTROL state: %llx\n", val);
>> +
>>         /* Absolutely required MSRs */
>>         required_msrs = HV_X64_MSR_HYPERCALL_AVAILABLE |
>>                 HV_X64_MSR_VP_INDEX_AVAILABLE;
>
>Thanks for having done this check!
>
>> and it seems the default state of HV_X64_MSR_SCONTROL is '1', we should
>> probably do the same.
>
>This is the state the OS sees, after the firmware.  You'd see the same
>with QEMU/KVM if you used Hyper-V-aware SeaBIOS or OVMF.
>
>> Is there any reason to *not* do this in KVM when
>> KVM_CAP_HYPERV_SYNIC[,2] is enabled?
>
>Yes there is: quoting Hyper-V TLFS v6.0 11.8.1:
>
>  At virtual processor creation time and upon processor reset, the value
>  of this SCONTROL (SynIC control register) is 0x0000000000000000. Thus,
>  message queuing and event flag notifications will be disabled.
>
>And, even if we decide to violate the spec it's better done in
>userspace, loading the initial value and adjusting the synic state at
>vcpu reset.
>
>However leaving it up to the guest (firmware or OS) looks more natural
>to me.
>
>Thanks,
>Roman.

I under where you are coming from in the idea of leaving it to the OS 
but I think in this specific case it does not make much sense, after all 
HyperV has it's own proprietary BIOS which Windows assumes has setup 
some of the MSRs, since we dont have that BIOS we need to "emulate" it's 
behaviour.

I also feel like the best approach should be in QEMU in case VMBus 
device exists it will also setup the SCONTROL to ENABLED, this way you 
are not bound to have a special BIOS in case you have decided to use 
HyperV advanced features like VMBus.

Cheers,
-- Jon.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F4C30D581
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 09:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232665AbhBCIqy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 03:46:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34827 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232238AbhBCIqw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 03:46:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612341926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x4plXTchef/sBjwOoHTzN6rEMhC93if4hIo33GzIkps=;
        b=Ih00+5TqUnULPrA+I3TOOZ7W7HLrb+5uWkScCYy28LEe/hFTDMNn4+kjARcyE8+DfmbDT5
        CvfWYanX3gk6mW/NbOI8El49Qia+PWOHLRnwugIq4r6ATp+VzbkBLd5RY9qzxR9IJ5eEvf
        qXdVM80kebl3Mo1qMArrwQu4wuddi74=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-W8ZfPZk4Nsi4vGO-_cKe0Q-1; Wed, 03 Feb 2021 03:45:24 -0500
X-MC-Unique: W8ZfPZk4Nsi4vGO-_cKe0Q-1
Received: by mail-ej1-f69.google.com with SMTP id le12so11582502ejb.13
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 00:45:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=x4plXTchef/sBjwOoHTzN6rEMhC93if4hIo33GzIkps=;
        b=fX603xuMIQUHIbvbPDDLy+EKS/qaZgf68oZuIpwXsJJ5dNE74AuO0Yl7lhuaQ1ePLe
         3ejNrvPR+999ezHy8yZe133JcWAXSU2KH+6GQ9O473YXQgwELOLctuDiUv1TMBkVAQbT
         MKp9ckn+dXcxLDYV1MRjfJB4EKQaNS6d8zWzIiqxwpQf8dRasb0qiFDrL4v0MT3cDBw9
         jHFGTZeYzMsb03s+8xL5p2/juKSwoxXP3jZ2TqVJ4DwdMOxLlC09xqg9OYHgITm3q0CV
         1wMdbmspfuXpMpcr1tPyKGrFo2IXXuk5ebDxR6BpycpG2x1GmoL62ab1x5DtFxQIgpK1
         iuVw==
X-Gm-Message-State: AOAM532ms4rBYP17BweXz27+6VsEb05aIV7418ziHbDhsttEBrfjLu9c
        AGKs9L0EJPmnnKMe9qGTLobmXdXKe/nR9QnCIXxi0TuINwOKVv/JkrMqYorFGfeuAkUU/OGU++Q
        ys6KtBFx4ouyj
X-Received: by 2002:a17:906:c9d8:: with SMTP id hk24mr2228954ejb.468.1612341923370;
        Wed, 03 Feb 2021 00:45:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwgGBhPglx70yG4qONPwtTbv4doAdwIN5R7Hi+EcUvxTOQKKD4miBMOBmhfn3oy++u2/cf/bw==
X-Received: by 2002:a17:906:c9d8:: with SMTP id hk24mr2228940ejb.468.1612341923184;
        Wed, 03 Feb 2021 00:45:23 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id a10sm674399ejk.75.2021.02.03.00.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 00:45:22 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     chang.seok.bae@intel.com, kvm@vger.kernel.org, robert.hu@intel.com,
        pbonzini@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
Subject: Re: [RFC PATCH 03/12] kvm/vmx: Introduce the new tertiary
 processor-based VM-execution controls
In-Reply-To: <8310773354ce83691afae0e463e42ecf5cc572f5.camel@linux.intel.com>
References: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
 <1611565580-47718-4-git-send-email-robert.hu@linux.intel.com>
 <87czxt4amd.fsf@vitty.brq.redhat.com>
 <8310773354ce83691afae0e463e42ecf5cc572f5.camel@linux.intel.com>
Date:   Wed, 03 Feb 2021 09:45:21 +0100
Message-ID: <87bld1pmji.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Robert Hoo <robert.hu@linux.intel.com> writes:

> On Mon, 2021-01-25 at 10:41 +0100, Vitaly Kuznetsov wrote:
>> Robert Hoo <robert.hu@linux.intel.com> writes:
>> We'll have to do something about Enlightened VMCS I believe. In
>> theory,
>> when eVMCS is in use, 'CPU_BASED_ACTIVATE_TERTIARY_CONTROLS' should
>> not
>> be exposed, e.g. when KVM hosts a EVMCS enabled guest the control
>> should
>> be filtered out. Something like (completely untested):
>> 
>> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
>> index 41f24661af04..c44ff05f3235 100644
>> --- a/arch/x86/kvm/vmx/evmcs.c
>> +++ b/arch/x86/kvm/vmx/evmcs.c
>> @@ -299,6 +299,7 @@ const unsigned int nr_evmcs_1_fields =
>> ARRAY_SIZE(vmcs_field_to_evmcs_1);
>>  
>>  __init void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf)
>>  {
>> +       vmcs_conf->cpu_based_exec_ctrl &=
>> ~EVMCS1_UNSUPPORTED_EXEC_CTRL;
>>         vmcs_conf->pin_based_exec_ctrl &=
>> ~EVMCS1_UNSUPPORTED_PINCTRL;
>>         vmcs_conf->cpu_based_2nd_exec_ctrl &=
>> ~EVMCS1_UNSUPPORTED_2NDEXEC;
>>  
>> diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
>> index bd41d9462355..bf2c5e7a4a8f 100644
>> --- a/arch/x86/kvm/vmx/evmcs.h
>> +++ b/arch/x86/kvm/vmx/evmcs.h
>> @@ -50,6 +50,7 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
>>   */
>>  #define EVMCS1_UNSUPPORTED_PINCTRL (PIN_BASED_POSTED_INTR | \
>>                                     PIN_BASED_VMX_PREEMPTION_TIMER)
>> +#define EVMCS1_UNSUPPORTED_EXEC_CTRL
>> (CPU_BASED_ACTIVATE_TERTIARY_CONTROLS)
>>  #define
>> EVMCS1_UNSUPPORTED_2NDEXEC                                     \
>>         (SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY
>> |                         \
>>          SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES
>> |                      \
>> 
>> should do the job I think.
>> 
> Hi Vitaly,
>
> I'm going to incorporate above patch in my next version. Shall I have
> it your signed-off-by?
> [setup_vmcs_config: filter out tertiary control when using eVMCS]
> signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

You can just incorporate it into your patch or, in case you want to have
it separate, feel free just add a 'Suggested-by: Vitaly Kuznetsov
<vkuznets@redhat.com>' tag.

Thanks!

-- 
Vitaly


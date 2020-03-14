Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 627871859B1
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 04:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgCODcj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Mar 2020 23:32:39 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:37761 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbgCODci (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Mar 2020 23:32:38 -0400
Received: by mail-ed1-f65.google.com with SMTP id b23so17490661edx.4;
        Sat, 14 Mar 2020 20:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2k/FWhwnxSmRyvkYX/addpqZAvvD/zc/fmTTZk2KfTg=;
        b=IiTYEo9sQU3SJruOebAutscq7dbKBvfhkn3R5mw7EDPR2Sqlrn3wTQMSALZ+Uaam7K
         5iMgr7cPHPXworFSjRk69JMzFZUiutV7QVAY8bWp1ZY2yC/vtOBwqaLQ5X9Uul6fjp78
         GEZuSjgAaLuc+99oNf8ZoBNN3u4VNy4mMl8I8ZVfFrksDtDuMpQ/9dlGvpbH1oCcgR58
         WujcnofzwgXwyh/D1tS/W5Wd2nXCOUZ0Jsg9R6cUsmQ3guLGWQixhrvGRDg8XrwG37PW
         QiBQUOVHYVRKYCABPxNJCkIeTLow2koe9AM2rXzHxCH9mTYHDXsRtFbiNYB0JmBUuIUU
         SODg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2k/FWhwnxSmRyvkYX/addpqZAvvD/zc/fmTTZk2KfTg=;
        b=h3G9EzAxBkFEtwNavT0fblr3hU4MLNaaxHlceJjmcJOLPXrSszOdP1DN5y7hKB64nJ
         sfs9FVRpZAuf1OBdc3DOCybumDhG4C3eCWD/AwdiNJ9S1AfUzoYQbQFDGAIDfLIe0LPj
         yfBJ0XyNuTBR4UYW2R5TPRpp64j1csTheGvTsBaYyV2wddNTy9f9CZAmnUTF2IOgq1BN
         snvjkINk+vfiVGRGjOLvODf2ioyGQ2MCujb9+UT638dt8JZG8IxUQqPZdhQqOhtrob7Y
         j2Fz1T1p0wx+JAoUbwDbS8Xmlho99YtwXaOH8t2l3gcfwwfoMY2w2DjIMI1wGAZex1Vq
         J+Zw==
X-Gm-Message-State: ANhLgQ0ot7WC4Nx8Xcmycfz+caCsFIQ8GSfqCrieB9GpRYSt0qOpI8d/
        qr5UOD5jalFDwj9KRDxqC9sOk20a03U=
X-Google-Smtp-Source: ADFU+vuKsq+WEtB5MHCLDZ2FmbzoJHHzISseL9CuIYL9j3TSemupcSx5bJsmtyAJiaBJkowVKDtXLQ==
X-Received: by 2002:a5d:49d2:: with SMTP id t18mr20783550wrs.279.1584161094000;
        Fri, 13 Mar 2020 21:44:54 -0700 (PDT)
Received: from jondnuc (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id q3sm18455477wmj.38.2020.03.13.21.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 21:44:53 -0700 (PDT)
Date:   Sat, 14 Mar 2020 06:44:51 +0200
From:   Jon Doron <arilou@gmail.com>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>
Subject: Re: [PATCH v5 2/5] x86/hyper-v: Add synthetic debugger definitions
Message-ID: <20200314044451.GA15879@jondnuc>
References: <20200313132034.132315-1-arilou@gmail.com>
 <20200313132034.132315-3-arilou@gmail.com>
 <MW2PR2101MB10521050158699C7C96613F5D7FA0@MW2PR2101MB1052.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB10521050158699C7C96613F5D7FA0@MW2PR2101MB1052.namprd21.prod.outlook.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/03/2020, Michael Kelley wrote:
>From: Jon Doron <arilou@gmail.com> Sent: Friday, March 13, 2020 6:21 AM
>>
>> Hyper-V synthetic debugger has two modes, one that uses MSRs and
>> the other that use Hypercalls.
>>
>> Add all the required definitions to both types of synthetic debugger
>> interface.
>>
>> Some of the required new CPUIDs and MSRs are not documented in the TLFS
>> so they are in hyperv.h instead.
>>
>> Signed-off-by: Jon Doron <arilou@gmail.com>
>> ---
>>  arch/x86/include/asm/hyperv-tlfs.h |  6 ++++++
>>  arch/x86/kvm/hyperv.h              | 22 ++++++++++++++++++++++
>>  2 files changed, 28 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
>> index 92abc1e42bfc..671ce2a39d4b 100644
>> --- a/arch/x86/include/asm/hyperv-tlfs.h
>> +++ b/arch/x86/include/asm/hyperv-tlfs.h
>> @@ -131,6 +131,8 @@
>>  #define HV_FEATURE_FREQUENCY_MSRS_AVAILABLE		BIT(8)
>>  /* Crash MSR available */
>>  #define HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE		BIT(10)
>> +/* Support for debug MSRs available */
>> +#define HV_FEATURE_DEBUG_MSRS_AVAILABLE			BIT(11)
>>  /* stimer Direct Mode is available */
>>  #define HV_STIMER_DIRECT_MODE_AVAILABLE			BIT(19)
>>
>> @@ -376,6 +378,9 @@ struct hv_tsc_emulation_status {
>>  #define HVCALL_SEND_IPI_EX			0x0015
>>  #define HVCALL_POST_MESSAGE			0x005c
>>  #define HVCALL_SIGNAL_EVENT			0x005d
>> +#define HVCALL_POST_DEBUG_DATA			0x0069
>> +#define HVCALL_RETRIEVE_DEBUG_DATA		0x006a
>> +#define HVCALL_RESET_DEBUG_SESSION		0x006b
>>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
>>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
>>
>> @@ -419,6 +424,7 @@ enum HV_GENERIC_SET_FORMAT {
>>  #define HV_STATUS_INVALID_HYPERCALL_INPUT	3
>>  #define HV_STATUS_INVALID_ALIGNMENT		4
>>  #define HV_STATUS_INVALID_PARAMETER		5
>> +#define HV_STATUS_OPERATION_DENIED		8
>>  #define HV_STATUS_INSUFFICIENT_MEMORY		11
>>  #define HV_STATUS_INVALID_PORT_ID		17
>>  #define HV_STATUS_INVALID_CONNECTION_ID		18
>> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
>> index 757cb578101c..56bc3416b62f 100644
>> --- a/arch/x86/kvm/hyperv.h
>> +++ b/arch/x86/kvm/hyperv.h
>> @@ -23,6 +23,28 @@
>>
>>  #include <linux/kvm_host.h>
>>
>> +/* These defines are required by KDNet and they are not part of Hyper-V TLFS */
>
>I'm looking for a bit more info in the comment so that it's clear that the
>synthetic debugger functionality is not committed to be available going
>forward. Perhaps something along the lines of:
>
>/* The #defines related to the synthetic debugger are required by KDNet, but
> * they are not documented in the Hyper-V TLFS because the synthetic debugger
> * functionality has been deprecated and is subject to removal in future versions
> * of Windows.
> */
>
>But with that additional comment text,
>
>Reviewed-by: Michael Kelley <mikelley@microsoft.com>
>

Sure thing, but one quick question I have noticed that in the 6.0 TLFS 
the bit indicating the DEBUG_MSRS are available is still documented is 
that intentional or a juss a miss?

Cheers,
-- Jon.

>> +#define HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS	0x40000080
>> +#define HYPERV_CPUID_SYNDBG_INTERFACE			0x40000081
>> +#define HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES	0x40000082
>> +
>> +/*
>> + * Hyper-V synthetic debugger platform capabilities
>> + * These are HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX bits.
>> + */
>> +#define HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING	BIT(1)
>> +
>> +/* Hyper-V Synthetic debug options MSR */
>> +#define HV_X64_MSR_SYNDBG_CONTROL		0x400000F1
>> +#define HV_X64_MSR_SYNDBG_STATUS		0x400000F2
>> +#define HV_X64_MSR_SYNDBG_SEND_BUFFER		0x400000F3
>> +#define HV_X64_MSR_SYNDBG_RECV_BUFFER		0x400000F4
>> +#define HV_X64_MSR_SYNDBG_PENDING_BUFFER	0x400000F5
>> +#define HV_X64_MSR_SYNDBG_OPTIONS		0x400000FF
>> +
>> +/* Hyper-V HV_X64_MSR_SYNDBG_OPTIONS bits */
>> +#define HV_X64_SYNDBG_OPTION_USE_HCALLS		BIT(2)
>> +
>>  static inline struct kvm_vcpu_hv *vcpu_to_hv_vcpu(struct kvm_vcpu *vcpu)
>>  {
>>  	return &vcpu->arch.hyperv;
>> --
>> 2.24.1
>

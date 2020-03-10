Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7A317EF08
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 04:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgCJDY6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 23:24:58 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39505 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgCJDY5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 23:24:57 -0400
Received: by mail-wm1-f66.google.com with SMTP id f7so289234wml.4;
        Mon, 09 Mar 2020 20:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=E0fqRr5Yg5Rog0ZHXojA52L6V6W/KCENIrpBvX+K4HE=;
        b=KBwnspT50mZwUCDnF6V/FoNvFhmg4Sg7pBdCP4uoaRJJhnK/xQ3LuQxnp7uU1O+BQ5
         k0ysmZRyCKQvzoV2K+hc9g401rZpqV0fEQ+T2b/2bOcRzeAb/xxQGY0ndDCXtDk6xW70
         WK3z9y/hrEQtGcTqSuSIbfTKhOiweWA/kKW2FUs3HcGiM0BRiNzIBWOutiVb2B5mZTho
         WY4DL2u4KCYWjGbVzYbBhDOkw+DngZs25HWJhVzpNpQey6RkRBkDC/Xuo4ZL4cERXhMv
         +QIvsqfzjGl0aw9YPJSH+MxAWMUy6CdIbvfOsw0I/5WUT/FjlvcVnYlyekg5o5+1s4Ct
         4d0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E0fqRr5Yg5Rog0ZHXojA52L6V6W/KCENIrpBvX+K4HE=;
        b=ImP+u/0tW1rzprcUIMuIXVNZeIOwcLrjT8nON95oO1UzQp5GQIO0cxIQmq9OLd42CC
         Zj3eZiZS7QljFwi2zsJbAW+uL/873pZDLoqeO0rrNCwhnNNJWJc+RRw/FBM/CmJsOZ1L
         xu0EwIB7qSNZ2Oa50wRKdwxbIeKdZMEgi0k1IQOdXMA837FXD87olmLKm1oqEfsdhoTh
         FAuM4OXkE4GVXoMSxHzNMH80MX1jNGMMo2aNsq+n98DKcIgBI+c96cZPxaXWP812MXl8
         EnlFr8U7hrC/eVW902XXgyFsUcFfU0UBjZHHq3TU5RVBMDwb+yNCJ6qasG5loLuGcA/c
         4RJg==
X-Gm-Message-State: ANhLgQ2brnWkKeLcgy+s9Jx7IYxygyMiLq4wCqaOxUqUNE08EwmcmaC/
        uOORSYnolY89ToXi2eXaLAY=
X-Google-Smtp-Source: ADFU+vuI6NrJ/IWJ+fmWwO1eXeeRqpnpvgr9UtjAy2DHyXR5QHDB6QiC2zHIuX7c7nL6f75ckFPSNA==
X-Received: by 2002:a1c:f707:: with SMTP id v7mr2485108wmh.121.1583810694970;
        Mon, 09 Mar 2020 20:24:54 -0700 (PDT)
Received: from jondnuc (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id h10sm2219216wml.18.2020.03.09.20.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 20:24:54 -0700 (PDT)
Date:   Tue, 10 Mar 2020 05:24:53 +0200
From:   Jon Doron <arilou@gmail.com>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>
Subject: Re: [PATCH v4 2/5] x86/hyper-v: Add synthetic debugger definitions
Message-ID: <20200310032453.GC3755153@jondnuc>
References: <20200309182017.3559534-1-arilou@gmail.com>
 <20200309182017.3559534-3-arilou@gmail.com>
 <DM5PR2101MB104761F98A44ACB77DA5B414D7FE0@DM5PR2101MB1047.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <DM5PR2101MB104761F98A44ACB77DA5B414D7FE0@DM5PR2101MB1047.namprd21.prod.outlook.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/03/2020, Michael Kelley wrote:
>From: Jon Doron <arilou@gmail.com> Sent: Monday, March 9, 2020 11:20 AM
>>
>> Hyper-V synthetic debugger has two modes, one that uses MSRs and
>> the other that use Hypercalls.
>>
>> Add all the required definitions to both types of synthetic debugger
>> interface.
>>
>> Signed-off-by: Jon Doron <arilou@gmail.com>
>
>I got some additional details from the Hyper-V team about the Hyper-V
>synthetic debugger functionality.  Starting with Windows 10 and Windows
>Server 2016, KDNET is built-in to the Windows OS.  So when these and later
>Windows versions are running as a guest on KVM, the synthetic debugger
>support should not be needed.  It would only be needed for older Windows
>versions (Windows 8.1, Windows Server 2012 R2, and earlier) that lack a
>built-in KDNET.  Given the age of these Windows versions, I'm wondering
>whether having KVM try to emulate Hyper-V's synthetic debugging support
>is worthwhile.  While the synthetic debugger support is still present in
>current Windows releases along with the built-in KDNET, it is a legacy feature
>that is subject to being removed at any time in a future release.  Also, the
>debug hypercalls are only offered to the parent partition, so they are
>undocumented in the TLFS and the interfaces are subject to change at any
>time.
>
>Given the situation, I would rather not have the MSR and CPUID leaf definitions
>added to hyperv-tlfs.h.  But maybe I'm misunderstanding what you are trying
>to accomplish.  Is there a bigger picture of what the goals are for adding the
>synthetic debugger support?
>
>Michael
>

Hi Michael, thank you for getting back on this, the goal of this is to 
allow fast kernel debugging mainly for the older OSs, without the 
synthetic kernel debugger you must opt-in to serial which is pretty 
"painful" when it comes to debugging.

With that said it sounds like I need to look into setting up KDNet with 
KVM, might be trivial I have not tried it yet, but in general KDNet 
support only a small set of network adapters.
(https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/supported-ethernet-nics-for-network-kernel-debugging-in-windows-8-1)

As for the hypercalls, it's just something I ran into, I dont mind 
dropping off the hypercall interface (since the MSRs are way faster and 
simpler anyway, as I dont need to deal with UDP encapsulation.

In case you end up insisting I'll remove the MSR and CPUID leaf 
definitions what would be the workaround to implement the syndbg functionality?

Thanks,
-- Jon.

>> ---
>>  arch/x86/include/asm/hyperv-tlfs.h | 26 ++++++++++++++++++++++++++
>>  1 file changed, 26 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
>> index 92abc1e42bfc..12596da95a53 100644
>> --- a/arch/x86/include/asm/hyperv-tlfs.h
>> +++ b/arch/x86/include/asm/hyperv-tlfs.h
>> @@ -33,6 +33,9 @@
>>  #define HYPERV_CPUID_ENLIGHTMENT_INFO		0x40000004
>>  #define HYPERV_CPUID_IMPLEMENT_LIMITS		0x40000005
>>  #define HYPERV_CPUID_NESTED_FEATURES		0x4000000A
>> +#define HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS	0x40000080
>> +#define HYPERV_CPUID_SYNDBG_INTERFACE			0x40000081
>> +#define HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES	0x40000082
>>
>>  #define HYPERV_HYPERVISOR_PRESENT_BIT		0x80000000
>>  #define HYPERV_CPUID_MIN			0x40000005
>> @@ -131,6 +134,8 @@
>>  #define HV_FEATURE_FREQUENCY_MSRS_AVAILABLE		BIT(8)
>>  /* Crash MSR available */
>>  #define HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE		BIT(10)
>> +/* Support for debug MSRs available */
>> +#define HV_FEATURE_DEBUG_MSRS_AVAILABLE			BIT(11)
>>  /* stimer Direct Mode is available */
>>  #define HV_STIMER_DIRECT_MODE_AVAILABLE			BIT(19)
>>
>> @@ -194,6 +199,12 @@
>>  #define HV_X64_NESTED_GUEST_MAPPING_FLUSH		BIT(18)
>>  #define HV_X64_NESTED_MSR_BITMAP			BIT(19)
>>
>> +/*
>> + * Hyper-V synthetic debugger platform capabilities
>> + * These are HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX bits.
>> + */
>> +#define HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING	BIT(1)
>> +
>>  /* Hyper-V specific model specific registers (MSRs) */
>>
>>  /* MSR used to identify the guest OS. */
>> @@ -267,6 +278,17 @@
>>  /* Hyper-V guest idle MSR */
>>  #define HV_X64_MSR_GUEST_IDLE			0x400000F0
>>
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
>>  /* Hyper-V guest crash notification MSR's */
>>  #define HV_X64_MSR_CRASH_P0			0x40000100
>>  #define HV_X64_MSR_CRASH_P1			0x40000101
>> @@ -376,6 +398,9 @@ struct hv_tsc_emulation_status {
>>  #define HVCALL_SEND_IPI_EX			0x0015
>>  #define HVCALL_POST_MESSAGE			0x005c
>>  #define HVCALL_SIGNAL_EVENT			0x005d
>> +#define HVCALL_POST_DEBUG_DATA			0x0069
>> +#define HVCALL_RETRIEVE_DEBUG_DATA		0x006a
>> +#define HVCALL_RESET_DEBUG_SESSION		0x006b
>>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
>>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
>>
>> @@ -419,6 +444,7 @@ enum HV_GENERIC_SET_FORMAT {
>>  #define HV_STATUS_INVALID_HYPERCALL_INPUT	3
>>  #define HV_STATUS_INVALID_ALIGNMENT		4
>>  #define HV_STATUS_INVALID_PARAMETER		5
>> +#define HV_STATUS_OPERATION_DENIED		8
>>  #define HV_STATUS_INSUFFICIENT_MEMORY		11
>>  #define HV_STATUS_INVALID_PORT_ID		17
>>  #define HV_STATUS_INVALID_CONNECTION_ID		18
>> --
>> 2.24.1
>

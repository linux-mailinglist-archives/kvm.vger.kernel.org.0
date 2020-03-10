Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A95F517EFAA
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 05:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgCJE2S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 00:28:18 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41711 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbgCJE2R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 00:28:17 -0400
Received: by mail-wr1-f67.google.com with SMTP id s14so407152wrt.8;
        Mon, 09 Mar 2020 21:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y8kTMlcE79x/5OdhRuwSFaas+ZW3QR9ZmYypssaO+zI=;
        b=Mwi2KCH+AA9S7T3JkDky7s4PVlrykipsM3XiAaVkyWMaNJ+3FXMLrH0tMx5kBzYjoA
         PamoObNjhqSP1SckbvxfqWrTz1QdomIVRVwkFzT8ScncQBecTmJu/Y0n5C32S6FVodXY
         bX1inlpFpksFuKuX5j+LThBTs0guGIAq70c1veukyA8QuIJdcdVzft5xYvnS1IrbGS8x
         8Ad2nOfoJt5vPunShfvX3Ov2eAMzjPKeL0DopsnfTyvhglQre9rOa4p03M/0qQdrXUdR
         X49AhCe0ZZyjkUlJfrHFyLD2mkzXCJHsr7dUZrk3MHzagtN5l161T07FSx+egW2E3Q/M
         lXZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y8kTMlcE79x/5OdhRuwSFaas+ZW3QR9ZmYypssaO+zI=;
        b=h9zZOvOaY7eXw9rQ4DKK/e/Aqea0fZC0HnIogO8bfTIrcLQ3LxgpLqRJqBD6qoQMlc
         XQhm0/NMZZrtjJTB4B0Ff2SSimEyVu2fST/jXsjuR6ikiz4O2v8tfNdv2Yx/i9HoHSR7
         Aj85RTc87a0cbAocQL8F7/XJtUeEL40mZGXWMb4BBuRGyCd22WhXUGk3FQ2XWwGqBQoZ
         MLup/qp0RMrjHqYv2ZX/XMBctsTGwjD81n8b7R8CAXEACxXwv/yfvYq3XtbqWQ2owYso
         LA/NZZPZw4X7Bkb3EY7Z7zkjLIv0+gZDc9nkZENi54FhGwHDueWSaF1dkkBp+zS314ye
         HpKw==
X-Gm-Message-State: ANhLgQ3uZnzaEqX0/WZqvaOH+yYqdMogrF5FjcXmq2TnBAv9aYypeXpA
        ytIJVt2l68Z6q3HQG/ygDko=
X-Google-Smtp-Source: ADFU+vtHn99lYHecqFOPk/GNxwZM2cKgVI6MVaOOB8OX6IoFNtyJBeNf2Vd0hMH9NGH8osXrBBqtow==
X-Received: by 2002:adf:eb0a:: with SMTP id s10mr24527403wrn.405.1583814493725;
        Mon, 09 Mar 2020 21:28:13 -0700 (PDT)
Received: from jondnuc (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id k18sm14347720wru.94.2020.03.09.21.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 21:28:13 -0700 (PDT)
Date:   Tue, 10 Mar 2020 06:28:11 +0200
From:   Jon Doron <arilou@gmail.com>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>
Subject: Re: [PATCH v4 2/5] x86/hyper-v: Add synthetic debugger definitions
Message-ID: <20200310042811.GE3755153@jondnuc>
References: <20200309182017.3559534-1-arilou@gmail.com>
 <20200309182017.3559534-3-arilou@gmail.com>
 <DM5PR2101MB104761F98A44ACB77DA5B414D7FE0@DM5PR2101MB1047.namprd21.prod.outlook.com>
 <20200310032453.GC3755153@jondnuc>
 <MW2PR2101MB10522800EB048383C227F556D7FF0@MW2PR2101MB1052.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB10522800EB048383C227F556D7FF0@MW2PR2101MB1052.namprd21.prod.outlook.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/03/2020, Michael Kelley wrote:
>From: Jon Doron <arilou@gmail.com>  Sent: Monday, March 9, 2020 8:25 PM
>>
>> On 09/03/2020, Michael Kelley wrote:
>> >From: Jon Doron <arilou@gmail.com> Sent: Monday, March 9, 2020 11:20 AM
>> >>
>> >> Hyper-V synthetic debugger has two modes, one that uses MSRs and
>> >> the other that use Hypercalls.
>> >>
>> >> Add all the required definitions to both types of synthetic debugger
>> >> interface.
>> >>
>> >> Signed-off-by: Jon Doron <arilou@gmail.com>
>> >
>> >I got some additional details from the Hyper-V team about the Hyper-V
>> >synthetic debugger functionality.  Starting with Windows 10 and Windows
>> >Server 2016, KDNET is built-in to the Windows OS.  So when these and later
>> >Windows versions are running as a guest on KVM, the synthetic debugger
>> >support should not be needed.  It would only be needed for older Windows
>> >versions (Windows 8.1, Windows Server 2012 R2, and earlier) that lack a
>> >built-in KDNET.  Given the age of these Windows versions, I'm wondering
>> >whether having KVM try to emulate Hyper-V's synthetic debugging support
>> >is worthwhile.  While the synthetic debugger support is still present in
>> >current Windows releases along with the built-in KDNET, it is a legacy feature
>> >that is subject to being removed at any time in a future release.  Also, the
>> >debug hypercalls are only offered to the parent partition, so they are
>> >undocumented in the TLFS and the interfaces are subject to change at any
>> >time.
>> >
>> >Given the situation, I would rather not have the MSR and CPUID leaf definitions
>> >added to hyperv-tlfs.h.  But maybe I'm misunderstanding what you are trying
>> >to accomplish.  Is there a bigger picture of what the goals are for adding the
>> >synthetic debugger support?
>> >
>> >Michael
>> >
>>
>> Hi Michael, thank you for getting back on this, the goal of this is to
>> allow fast kernel debugging mainly for the older OSs, without the
>> synthetic kernel debugger you must opt-in to serial which is pretty
>> "painful" when it comes to debugging.
>
>OK, so you really are targeting the older Windows OS versions.
>

Right. :)

>>
>> With that said it sounds like I need to look into setting up KDNet with
>> KVM, might be trivial I have not tried it yet, but in general KDNet
>> support only a small set of network adapters.
>> (https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/supported-ethernet-nics-for-network-kernel-debugging-in-windows-8-1)
>>
>
>I don't know my vendor IDs and device IDs very well.  Are there
>commonly used network adapters that aren't on the list?  I'm asking
>just out of curiosity ....
>

Well I did further look into this now and it seems like the e1000e 
should work did find a recent case which indicates there was an issue 
until not too long ago:
https://bugzilla.redhat.com/show_bug.cgi?id=1787142

I'll try to bring up a setup with the latest Win10 and see if I can 
configure it for kernel debugging via e1000e nic.

>> As for the hypercalls, it's just something I ran into, I dont mind
>> dropping off the hypercall interface (since the MSRs are way faster and
>> simpler anyway, as I dont need to deal with UDP encapsulation.
>>
>> In case you end up insisting I'll remove the MSR and CPUID leaf
>> definitions what would be the workaround to implement the syndbg functionality?
>
>I'm flexible, and trying to not be a pain-in-the-neck. :-)  What would
>the KVM guys think about putting the definitions in a KVM specific
>#include file, and clearly marking them as deprecated, mostly
>undocumented, and used only to support debugging old Windows
>versions?
>
>Michael
>
>>
>> Thanks,
>> -- Jon.
>>
>> >> ---
>> >>  arch/x86/include/asm/hyperv-tlfs.h | 26 ++++++++++++++++++++++++++
>> >>  1 file changed, 26 insertions(+)
>> >>
>> >> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
>> >> index 92abc1e42bfc..12596da95a53 100644
>> >> --- a/arch/x86/include/asm/hyperv-tlfs.h
>> >> +++ b/arch/x86/include/asm/hyperv-tlfs.h
>> >> @@ -33,6 +33,9 @@
>> >>  #define HYPERV_CPUID_ENLIGHTMENT_INFO		0x40000004
>> >>  #define HYPERV_CPUID_IMPLEMENT_LIMITS		0x40000005
>> >>  #define HYPERV_CPUID_NESTED_FEATURES		0x4000000A
>> >> +#define HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS	0x40000080
>> >> +#define HYPERV_CPUID_SYNDBG_INTERFACE			0x40000081
>> >> +#define HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES	0x40000082
>> >>
>> >>  #define HYPERV_HYPERVISOR_PRESENT_BIT		0x80000000
>> >>  #define HYPERV_CPUID_MIN			0x40000005
>> >> @@ -131,6 +134,8 @@
>> >>  #define HV_FEATURE_FREQUENCY_MSRS_AVAILABLE		BIT(8)
>> >>  /* Crash MSR available */
>> >>  #define HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE		BIT(10)
>> >> +/* Support for debug MSRs available */
>> >> +#define HV_FEATURE_DEBUG_MSRS_AVAILABLE			BIT(11)
>> >>  /* stimer Direct Mode is available */
>> >>  #define HV_STIMER_DIRECT_MODE_AVAILABLE			BIT(19)
>> >>
>> >> @@ -194,6 +199,12 @@
>> >>  #define HV_X64_NESTED_GUEST_MAPPING_FLUSH		BIT(18)
>> >>  #define HV_X64_NESTED_MSR_BITMAP			BIT(19)
>> >>
>> >> +/*
>> >> + * Hyper-V synthetic debugger platform capabilities
>> >> + * These are HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX bits.
>> >> + */
>> >> +#define HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING	BIT(1)
>> >> +
>> >>  /* Hyper-V specific model specific registers (MSRs) */
>> >>
>> >>  /* MSR used to identify the guest OS. */
>> >> @@ -267,6 +278,17 @@
>> >>  /* Hyper-V guest idle MSR */
>> >>  #define HV_X64_MSR_GUEST_IDLE			0x400000F0
>> >>
>> >> +/* Hyper-V Synthetic debug options MSR */
>> >> +#define HV_X64_MSR_SYNDBG_CONTROL		0x400000F1
>> >> +#define HV_X64_MSR_SYNDBG_STATUS		0x400000F2
>> >> +#define HV_X64_MSR_SYNDBG_SEND_BUFFER		0x400000F3
>> >> +#define HV_X64_MSR_SYNDBG_RECV_BUFFER		0x400000F4
>> >> +#define HV_X64_MSR_SYNDBG_PENDING_BUFFER	0x400000F5
>> >> +#define HV_X64_MSR_SYNDBG_OPTIONS		0x400000FF
>> >> +
>> >> +/* Hyper-V HV_X64_MSR_SYNDBG_OPTIONS bits */
>> >> +#define HV_X64_SYNDBG_OPTION_USE_HCALLS		BIT(2)
>> >> +
>> >>  /* Hyper-V guest crash notification MSR's */
>> >>  #define HV_X64_MSR_CRASH_P0			0x40000100
>> >>  #define HV_X64_MSR_CRASH_P1			0x40000101
>> >> @@ -376,6 +398,9 @@ struct hv_tsc_emulation_status {
>> >>  #define HVCALL_SEND_IPI_EX			0x0015
>> >>  #define HVCALL_POST_MESSAGE			0x005c
>> >>  #define HVCALL_SIGNAL_EVENT			0x005d
>> >> +#define HVCALL_POST_DEBUG_DATA			0x0069
>> >> +#define HVCALL_RETRIEVE_DEBUG_DATA		0x006a
>> >> +#define HVCALL_RESET_DEBUG_SESSION		0x006b
>> >>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
>> >>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
>> >>
>> >> @@ -419,6 +444,7 @@ enum HV_GENERIC_SET_FORMAT {
>> >>  #define HV_STATUS_INVALID_HYPERCALL_INPUT	3
>> >>  #define HV_STATUS_INVALID_ALIGNMENT		4
>> >>  #define HV_STATUS_INVALID_PARAMETER		5
>> >> +#define HV_STATUS_OPERATION_DENIED		8
>> >>  #define HV_STATUS_INSUFFICIENT_MEMORY		11
>> >>  #define HV_STATUS_INVALID_PORT_ID		17
>> >>  #define HV_STATUS_INVALID_CONNECTION_ID		18
>> >> --
>> >> 2.24.1
>> >

Thanks,
-- Jon.

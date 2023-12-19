Return-Path: <kvm+bounces-4774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A77D8182BA
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 08:57:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 016C41F263FD
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 07:57:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A99717982;
	Tue, 19 Dec 2023 07:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QggziDrV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99986168C5;
	Tue, 19 Dec 2023 07:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702972620; x=1734508620;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7QZAN2TgmiaT+CnQk4h1E8Xg1rL7yUVfPvqjbeyoFus=;
  b=QggziDrVVQ+Z+U0j5+TPO8MY3DiBK+uA+QK2iOqbTQfo3GR0/fJL5aPC
   Ebyn4OcRP8pDB5ITetf/9nWBYHCfwLBIVDtFai+hiDJbfbWnCFshDXOPJ
   OWqTdml2m0O2ELCPCMsB6nMF7YD5ewp2XyOehdVzgLR2HMe6TQhd7Lcta
   KMQVDq1PipPtRHADQ6LiDnPM2EH8rjpw15Z2rbF++SDILFonwqoJSqbhK
   BYVitnb2XhSUhKXy8c/ajZOvbVXaLltnMf37jMHNWxOZT5GlPs2IZqD7r
   UMcgru7EbZwY8atJzlGJnko1ySzNV4u14FZ/25qoYMhEi3iyJqpU6kCi2
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10928"; a="8994329"
X-IronPort-AV: E=Sophos;i="6.04,287,1695711600"; 
   d="scan'208";a="8994329"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2023 23:56:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10928"; a="846252720"
X-IronPort-AV: E=Sophos;i="6.04,287,1695711600"; 
   d="scan'208";a="846252720"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.8.39]) ([10.93.8.39])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2023 23:56:55 -0800
Message-ID: <fbdfd2f6-9f45-49ca-aab4-c7fa9dd003f5@intel.com>
Date: Tue, 19 Dec 2023 15:56:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] KVM: x86: Make the hardcoded APIC bus frequency vm
 variable
To: Jim Mattson <jmattson@google.com>,
 Isaku Yamahata <isaku.yamahata@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, isaku.yamahata@intel.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
 Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
 Vishal Annapurve <vannapurve@google.com>
References: <cover.1699936040.git.isaku.yamahata@intel.com>
 <1c12f378af7de16d7895f8badb18c3b1715e9271.1699936040.git.isaku.yamahata@intel.com>
 <938efd3cfcb25d828deab0cc0ba797177cc69602.camel@redhat.com>
 <ZXo54VNuIqbMsYv-@google.com>
 <aa7aa5ea5b112a0ec70c6276beb281e19c052f0e.camel@redhat.com>
 <ZXswR04H9Tl7xlyj@google.com>
 <20231219014045.GA2639779@ls.amr.corp.intel.com>
 <CALMp9eRgWct3bb5en0=geT0HmMemipkzXkjL9kmEAV+1yJg-pw@mail.gmail.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CALMp9eRgWct3bb5en0=geT0HmMemipkzXkjL9kmEAV+1yJg-pw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/19/2023 11:53 AM, Jim Mattson wrote:
> On Mon, Dec 18, 2023 at 5:40 PM Isaku Yamahata
> <isaku.yamahata@linux.intel.com> wrote:
>>
>> On Thu, Dec 14, 2023 at 08:41:43AM -0800,
>> Sean Christopherson <seanjc@google.com> wrote:
>>
>>> On Thu, Dec 14, 2023, Maxim Levitsky wrote:
>>>> On Wed, 2023-12-13 at 15:10 -0800, Sean Christopherson wrote:
>>>>> Upstream KVM's non-TDX behavior is fine, because KVM doesn't advertise support
>>>>> for CPUID 0x15, i.e. doesn't announce to host userspace that it's safe to expose
>>>>> CPUID 0x15 to the guest.  Because TDX makes exposing CPUID 0x15 mandatory, KVM
>>>>> needs to be taught to correctly emulate the guest's APIC bus frequency, a.k.a.
>>>>> the TDX guest core crystal frequency of 25Mhz.
>>>>
>>>> I assume that TDX doesn't allow to change the CPUID 0x15 leaf.
>>>
>>> Correct.  I meant to call that out below, but left my sentence half-finished.  It
>>> was supposed to say:
>>>
>>>    I halfheartedly floated the idea of "fixing" the TDX module/architecture to either
>>>    use 1Ghz as the base frequency or to allow configuring the base frequency
>>>    advertised to the guest.
>>>
>>>>> I halfheartedly floated the idea of "fixing" the TDX module/architecture to either
>>>>> use 1Ghz as the base frequency (off list), but it definitely isn't a hill worth
>>>>> dying on since the KVM changes are relatively simple.
>>>>>
>>>>> https://lore.kernel.org/all/ZSnIKQ4bUavAtBz6@google.com
>>>>>
>>>>
>>>> Best regards,
>>>>      Maxim Levitsky
>>
>> The followings are the updated version of the commit message.
>>
>>
>> KVM: x86: Make the hardcoded APIC bus frequency VM variable
>>
>> The TDX architecture hard-codes the APIC bus frequency to 25MHz in the
>> CPUID leaf 0x15.  The
>> TDX mandates it to be exposed and doesn't allow the VMM to override
>> its value.  The KVM APIC timer emulation hard-codes the frequency to
>> 1GHz.  It doesn't unconditionally enumerate it to the guest unless the
>> user space VMM sets the CPUID leaf 0x15 by KVM_SET_CPUID.
>>
>> If the CPUID leaf 0x15 is enumerated, the guest kernel uses it as the
>> APIC bus frequency.  If not, the guest kernel measures the frequency
>> based on other known timers like the ACPI timer or the legacy PIT.
>> The TDX guest kernel gets timer interrupt more times by 1GHz / 25MHz.
>>
>> To ensure that the guest doesn't have a conflicting view of the APIC
>> bus frequency, allow the userspace to tell KVM to use the same
>> frequency that TDX mandates instead of the default 1Ghz.
>>
>> There are several options to address this.
>> 1. Make the KVM able to configure APIC bus frequency (This patch).
>>     Pros: It resembles the existing hardware.  The recent Intel CPUs
>>     adapts 25MHz.
>>     Cons: Require the VMM to emulate the APIC timer at 25MHz.
>> 2. Make the TDX architecture enumerate CPUID 0x15 to configurable
>>     frequency or not enumerate it.
>>     Pros: Any APIC bus frequency is allowed.
>>     Cons: Deviation from the real hardware.
>> 3. Make the TDX guest kernel use 1GHz when it's running on KVM.
>>     Cons: The kernel ignores CPUID leaf 0x15.
> 
> 4. Change CPUID.15H under TDX to report the crystal clock frequency as 1 GHz.

This will have an impact on TSC frequency. Core crystal clock frequency 
is also used to calculate TSC frequency.

> Pro: This has been the virtual APIC frequency for KVM guests for 13 years.
> Pro: This requires changing only one hard-coded constant in TDX.
> 
> I see no compelling reason to complicate KVM with support for
> configurable APIC frequencies, and I see no advantages to doing so.

I'm wondering what's the attitude of KVM community to provide support 
CPUID leaf 0x15? Even KVM decides to never advertise CPUID 0x15 in 
GET_SUPPORTED_CPUID, hard-coded APIC frequency puts additional 
limitation when userspace want to emualte CPUID 0x15




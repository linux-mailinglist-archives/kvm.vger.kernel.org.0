Return-Path: <kvm+bounces-4977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DB0981AE7D
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 06:44:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 85E38B20D0A
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 05:44:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2E83B64A;
	Thu, 21 Dec 2023 05:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bGSLQiL7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9FC9474;
	Thu, 21 Dec 2023 05:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703137452; x=1734673452;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DOhqaaZH2dT+iXC4jpHjes5pDXfhC5Scg+dxWY3l8CI=;
  b=bGSLQiL7ldVGSujLqmiw4DgD0g24vezZ07xTQV6nkS8IYJ/HwzVHV9gN
   R+3OB2t8jMjG73ZC4cHNgPRhuD97UBpVEygFXfn9VDym9M3QKmxzYxPWp
   fhqHrGyBtRRlg7KZ2xrVTXxMgPBHFBlFx2QysMIRVPmYTvdMqB7LFk82+
   9J1WEsN9417y0TuHmCBcVb7lZo3KZOfM8UnAK6hJ/MC0PV9UgxCS9KtS+
   U0dyOOG0tUPL8uU5cwCQVHzbMDXWqeh5rAwIyRGgWPpKm/Vr8XNdw2kqj
   dzruTqrcp2Oors6a63tcYtCE+B9dDhldWLS/YrviKkQ1As2YBE8mh/kRK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="376074532"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="376074532"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2023 21:44:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="949798389"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="949798389"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.12.199]) ([10.93.12.199])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2023 21:44:07 -0800
Message-ID: <5cf35021-c81f-43e3-9d0d-69604fc4fa59@intel.com>
Date: Thu, 21 Dec 2023 13:44:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] KVM: x86: Make the hardcoded APIC bus frequency vm
 variable
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Isaku Yamahata <isaku.yamahata@linux.intel.com>
Cc: Jim Mattson <jmattson@google.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 isaku.yamahata@intel.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Vishal Annapurve <vannapurve@google.com>
References: <cover.1699936040.git.isaku.yamahata@intel.com>
 <1c12f378af7de16d7895f8badb18c3b1715e9271.1699936040.git.isaku.yamahata@intel.com>
 <938efd3cfcb25d828deab0cc0ba797177cc69602.camel@redhat.com>
 <ZXo54VNuIqbMsYv-@google.com>
 <aa7aa5ea5b112a0ec70c6276beb281e19c052f0e.camel@redhat.com>
 <ZXswR04H9Tl7xlyj@google.com>
 <20231219014045.GA2639779@ls.amr.corp.intel.com>
 <CALMp9eRgWct3bb5en0=geT0HmMemipkzXkjL9kmEAV+1yJg-pw@mail.gmail.com>
 <20231219081104.GB2639779@ls.amr.corp.intel.com>
 <ZYNlhKCcOHgjTcFZ@google.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZYNlhKCcOHgjTcFZ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/21/2023 6:07 AM, Sean Christopherson wrote:
> On Tue, Dec 19, 2023, Isaku Yamahata wrote:
>> On Mon, Dec 18, 2023 at 07:53:45PM -0800, Jim Mattson <jmattson@google.com> wrote:
>>>> There are several options to address this.
>>>> 1. Make the KVM able to configure APIC bus frequency (This patch).
>>>>     Pros: It resembles the existing hardware.  The recent Intel CPUs
>>>>     adapts 25MHz.
>>>>     Cons: Require the VMM to emulate the APIC timer at 25MHz.
>>>> 2. Make the TDX architecture enumerate CPUID 0x15 to configurable
>>>>     frequency or not enumerate it.
>>>>     Pros: Any APIC bus frequency is allowed.
>>>>     Cons: Deviation from the real hardware.
> 
> I don't buy this as a valid Con.  TDX is one gigantic deviation from real hardware,
> and since TDX obviously can't guarantee the APIC timer is emulated at the correct
> frequency, there can't possibly be any security benefits.  If this were truly a
> Con that anyone cared about, we would have gotten patches to "fix" KVM a long time
> ago.
> 
> If the TDX module wasn't effectively hardware-defined software, i.e. was actually
> able to adapt at the speed of software, then fixing this in TDX would be a complete
> no-brainer.
> 
> The KVM uAPI required to play nice is relatively minor, so I'm not totally opposed
> to adding it.  But I totally agree with Jim that forcing KVM to change 13+ years
> of behavior just because someone at Intel decided that 25MHz was a good number is
> ridiculous.

I believe 25MHz was chosen because it's the value from hardware that 
supports TDX and it is not going to change for the following known 
generations that support TDX.

It's mainly the core crystal frequency. Yes, it also represents the APIC 
frequency when it's enumerated in CPUID 0x15. However, it also relates 
other things, like intel-pt MTC Freq. If it is configured to other value 
different from hardware, I think it will break the correctness of 
INTEL-PT MTC packets in TDs.

>>>> 3. Make the TDX guest kernel use 1GHz when it's running on KVM.
>>>>     Cons: The kernel ignores CPUID leaf 0x15.
>>>
>>> 4. Change CPUID.15H under TDX to report the crystal clock frequency as 1 GHz.
>>> Pro: This has been the virtual APIC frequency for KVM guests for 13 years.
>>> Pro: This requires changing only one hard-coded constant in TDX.
>>>
>>> I see no compelling reason to complicate KVM with support for
>>> configurable APIC frequencies, and I see no advantages to doing so.
>>
>> Because TDX isn't specific to KVM, it should work with other VMM technologies.
>> If we'd like to go for this route, the frequency would be configurable.  What
>> frequency should be acceptable securely is obscure.  25MHz has long history with
>> the real hardware.
> 



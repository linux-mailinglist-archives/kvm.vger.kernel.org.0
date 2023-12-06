Return-Path: <kvm+bounces-3719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8F8A807568
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 17:41:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 56560B20B0A
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 16:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F4B2482E1;
	Wed,  6 Dec 2023 16:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="h5nzkQNQ"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4CD6ED47;
	Wed,  6 Dec 2023 08:41:18 -0800 (PST)
Received: from [192.168.4.26] (unknown [47.186.13.91])
	by linux.microsoft.com (Postfix) with ESMTPSA id 9333C20B74C0;
	Wed,  6 Dec 2023 08:41:15 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9333C20B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1701880877;
	bh=kHlojawRkHSQzesoLwKgfjTuxP60iVUKEMogJbbgpvk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=h5nzkQNQJ8Hkz9bfJUOKRk94jCH5u+61xKvm7uHbxDDbh9IZdWwgEbKwTn78PkoLZ
	 V/SvaTVRXbbegDsONVIBC1/e+Ph1euNy4EsDx3Olm8uf4UsqwQwJOXfeBOjvjh60yW
	 V40mz9ekf0xV/7t/xQurUWeNCSJJTn4OO98i49pg=
Message-ID: <db9c5049-70b5-4261-b7e8-cd371c50aaea@linux.microsoft.com>
Date: Wed, 6 Dec 2023 10:41:14 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 17/19] heki: x86: Update permissions counters
 during text patching
Content-Language: en-US
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "peterz@infradead.org" <peterz@infradead.org>
Cc: "ssicleru@bitdefender.com" <ssicleru@bitdefender.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, "mic@digikod.net"
 <mic@digikod.net>, "marian.c.rotariu@gmail.com"
 <marian.c.rotariu@gmail.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "wei.liu@kernel.org" <wei.liu@kernel.org>,
 "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "tgopinath@microsoft.com" <tgopinath@microsoft.com>,
 "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "jgowans@amazon.com" <jgowans@amazon.com>,
 "ztarkhani@microsoft.com" <ztarkhani@microsoft.com>,
 "mdontu@bitdefender.com" <mdontu@bitdefender.com>,
 "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
 "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
 "jamorris@linux.microsoft.com" <jamorris@linux.microsoft.com>,
 "seanjc@google.com" <seanjc@google.com>,
 "vkuznets@redhat.com" <vkuznets@redhat.com>,
 "Andersen, John S" <john.s.andersen@intel.com>,
 "yu.c.zhang@linux.intel.com" <yu.c.zhang@linux.intel.com>,
 "nicu.citu@icloud.com" <nicu.citu@icloud.com>,
 "keescook@chromium.org" <keescook@chromium.org>,
 "Graf, Alexander" <graf@amazon.com>,
 "wanpengli@tencent.com" <wanpengli@tencent.com>,
 "dev@lists.cloudhypervisor.org" <dev@lists.cloudhypervisor.org>,
 "will@kernel.org" <will@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
 "hpa@zytor.com" <hpa@zytor.com>,
 "linux-security-module@vger.kernel.org"
 <linux-security-module@vger.kernel.org>,
 "yuanyu@google.com" <yuanyu@google.com>,
 "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
 "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
 "quic_tsoni@quicinc.com" <quic_tsoni@quicinc.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
References: <20231113022326.24388-1-mic@digikod.net>
 <20231113022326.24388-18-mic@digikod.net>
 <20231113081929.GA16138@noisy.programming.kicks-ass.net>
 <a52d8885-43cc-4a4e-bb47-9a800070779e@linux.microsoft.com>
 <20231127200841.GZ3818@noisy.programming.kicks-ass.net>
 <ea63ae4e-e8ea-4fbf-9383-499e14de2f5e@linux.microsoft.com>
 <4103d68b07bb382e434cdaf19ab1986f9079b0bb.camel@intel.com>
From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <4103d68b07bb382e434cdaf19ab1986f9079b0bb.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 11/30/23 18:45, Edgecombe, Rick P wrote:
> On Wed, 2023-11-29 at 15:07 -0600, Madhavan T. Venkataraman wrote:
>> Threat Model
>> ------------
>>
>> In the threat model in Heki, the attacker is a user space attacker
>> who exploits
>> a kernel vulnerability to gain more privileges or bypass the kernel's
>> access
>> control and self-protection mechanisms. 
>>
>> In the context of the guest page table, one of the things that the
>> threat model translates
>> to is a hacker gaining access to a guest page with RWX permissions.
>> E.g., by adding execute
>> permissions to a writable page or by adding write permissions to an
>> executable page.
>>
>> Today, the permissions for a guest page in the extended page table
>> are RWX by
>> default. So, if a hacker manages to establish RWX for a page in the
>> guest page
>> table, then that is all he needs to do some damage.
> 
> I had a few random comments from watching the plumbers talk online:
> 
> Is there really a big difference between a page that is RWX, and a RW
> page that is about to become RX? I realize that there is an addition of
> timing, but when executable code is getting loaded it can be written to
> then and later executed. I think that gap could be addressed in two
> different ways, both pretty difficult:
>  1. Verifying the loaded code before it gets marked 
>     executable. This is difficult because the kernel does lots of 
>     tweaks on the code it is loading (alternatives, etc). It can't 
>     just check a signature.
>  2. Loading the code in a protected environment. In this model the 
>     (for example) module signature would be checked, then the code 
>     would be loaded in some sort of protected environment. This way 
>     integrity of the loaded code would be enforced. But extracting 
>     module loading into a separate domain would be difficult. 
>     Various scattered features all have their hands in the loading.
> 
> Secondly, I wonder if another way to look at the memory parts of HEKI
> could be that this is a way to protect certain page table bits from
> stay writes. The RWX bits in the EPT are not directly writable, so more
> steps are needed to change things than just a stray write (instead the
> helpers involved in the operations need to be called). If that is a
> fair way of looking at it, then I wonder how HEKI compares to a
> solution like this security-wise:
> https://lore.kernel.org/lkml/20210830235927.6443-1-rick.p.edgecombe@intel.com/
> 
> Functional-wise it had the benefit of working on bare metal and
> supporting the normal kernel features.

Thanks for the comments. I will think about what you have said and will respond
soon.

Madhavan


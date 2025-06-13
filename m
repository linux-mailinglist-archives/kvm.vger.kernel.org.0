Return-Path: <kvm+bounces-49532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A9EBAD976B
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 23:39:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 12382189DFC5
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 21:39:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46AC828D8EA;
	Fri, 13 Jun 2025 21:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="b1GzwnCI"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C6E25393B;
	Fri, 13 Jun 2025 21:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749850766; cv=none; b=Z8RQJTAeNcWBazWhh8E/WskR1IVfKCfwIhT/npusx2gjWCX5PE6ZPxXUDJnuagmCiThJsEj8DXAsTxEj/PalmeGei5HkxYEHZYWUPi+n2zbKoq4r8y12+iSJGGgRtcw3H0l4FjUD4yv84VPF2VF0QHdPLDkuq07VQoiP2naeHOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749850766; c=relaxed/simple;
	bh=dd5YllNw3LiDL+FK0LS1lk/yrXXaTOqxnyryj86SIKQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V+5ER7GkWBeCBCoGLkqPVLCO0fOJd9vGc5cfMbVTWoGFjqng2gwQm6GGzR1TjnEny6hbLQv6V4SQYxm7lvWumBVf+Xittgd+FzvJJgk0nqoRdZ0zGkPfbL37QSZbL5KGTI07qm+ikNFUx6NHykqcBFQ6Tn5wgfKF7dwAV2ukqv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=b1GzwnCI; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55DLcahi3958308
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 13 Jun 2025 14:38:37 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55DLcahi3958308
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1749850720;
	bh=wzkE3kgI5Av/aAIbr36C6n1BwVjfhYQH2jljupg13ag=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=b1GzwnCIgYQQs2+eR9/+9fjYiOWtIpDw6y8LuSnDjMIiLjQHdu5atNFwFgGCYIJ+j
	 l5J+gBR5cA/nsADAwKWhgtXV7rOqgXHBlEjotdPLOeRX04XhLrqJyO/OtH/K20c/7F
	 qZ8iJpiK1dbKyp1Ewus7a4mR2rE1+w9l+s0iLZJ/Xyyd9RjEFx2Uh0cZh406qhdUYJ
	 kpSGIA2Ho56YA2gZAlBs1v8aIYQCnXshL60iUtmt3vzV3Btpc7SBuevH1LsxnrHG39
	 auAMZ7UeqEmn8b0XVrwTqWr1KU7UT+9UcXUe+iCc9uSLX6SiHrEwvEHMWDIk4FkNr+
	 9td15WLkLNxtw==
Message-ID: <06d93a19-ebc1-418b-becd-225caac76baf@zytor.com>
Date: Fri, 13 Jun 2025 14:38:35 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/3] x86/traps: Move DR7_RESET_VALUE to
 <uapi/asm/debugreg.h>
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        peterz@infradead.org, brgerst@gmail.com, tony.luck@intel.com,
        fenghuay@nvidia.com
References: <20250613070118.3694407-1-xin@zytor.com>
 <20250613070118.3694407-2-xin@zytor.com> <aEwzQ9vIcaZPtDsw@google.com>
 <00358cf3-e59a-4a5f-8cfd-06a174da72b4@zytor.com>
 <aEyEA6hXGeiN-0jp@google.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 xsDNBGUPz1cBDACS/9yOJGojBFPxFt0OfTWuMl0uSgpwk37uRrFPTTLw4BaxhlFL0bjs6q+0
 2OfG34R+a0ZCuj5c9vggUMoOLdDyA7yPVAJU0OX6lqpg6z/kyQg3t4jvajG6aCgwSDx5Kzg5
 Rj3AXl8k2wb0jdqRB4RvaOPFiHNGgXCs5Pkux/qr0laeFIpzMKMootGa4kfURgPhRzUaM1vy
 bsMsL8vpJtGUmitrSqe5dVNBH00whLtPFM7IbzKURPUOkRRiusFAsw0a1ztCgoFczq6VfAVu
 raTye0L/VXwZd+aGi401V2tLsAHxxckRi9p3mc0jExPc60joK+aZPy6amwSCy5kAJ/AboYtY
 VmKIGKx1yx8POy6m+1lZ8C0q9b8eJ8kWPAR78PgT37FQWKYS1uAroG2wLdK7FiIEpPhCD+zH
 wlslo2ETbdKjrLIPNehQCOWrT32k8vFNEMLP5G/mmjfNj5sEf3IOKgMTMVl9AFjsINLHcxEQ
 6T8nGbX/n3msP6A36FDfdSEAEQEAAc0WWGluIExpIDx4aW5Aenl0b3IuY29tPsLBDQQTAQgA
 NxYhBIUq/WFSDTiOvUIqv2u9DlcdrjdRBQJlD89XBQkFo5qAAhsDBAsJCAcFFQgJCgsFFgID
 AQAACgkQa70OVx2uN1HUpgv/cM2fsFCQodLArMTX5nt9yqAWgA5t1srri6EgS8W3F+3Kitge
 tYTBKu6j5BXuXaX3vyfCm+zajDJN77JHuYnpcKKr13VcZi1Swv6Jx1u0II8DOmoDYLb1Q2ZW
 v83W55fOWJ2g72x/UjVJBQ0sVjAngazU3ckc0TeNQlkcpSVGa/qBIHLfZraWtdrNAQT4A1fa
 sWGuJrChBFhtKbYXbUCu9AoYmmbQnsx2EWoJy3h7OjtfFapJbPZql+no5AJ3Mk9eE5oWyLH+
 QWqtOeJM7kKvn/dBudokFSNhDUw06e7EoVPSJyUIMbYtUO7g2+Atu44G/EPP0yV0J4lRO6EA
 wYRXff7+I1jIWEHpj5EFVYO6SmBg7zF2illHEW31JAPtdDLDHYcZDfS41caEKOQIPsdzQkaQ
 oW2hchcjcMPAfyhhRzUpVHLPxLCetP8vrVhTvnaZUo0xaVYb3+wjP+D5j/3+hwblu2agPsaE
 vgVbZ8Fx3TUxUPCAdr/p73DGg57oHjgezsDNBGUPz1gBDAD4Mg7hMFRQqlzotcNSxatlAQNL
 MadLfUTFz8wUUa21LPLrHBkUwm8RujehJrzcVbPYwPXIO0uyL/F///CogMNx7Iwo6by43KOy
 g89wVFhyy237EY76j1lVfLzcMYmjBoTH95fJC/lVb5Whxil6KjSN/R/y3jfG1dPXfwAuZ/4N
 cMoOslWkfZKJeEut5aZTRepKKF54T5r49H9F7OFLyxrC/uI9UDttWqMxcWyCkHh0v1Di8176
 jjYRNTrGEfYfGxSp+3jYL3PoNceIMkqM9haXjjGl0W1B4BidK1LVYBNov0rTEzyr0a1riUrp
 Qk+6z/LHxCM9lFFXnqH7KWeToTOPQebD2B/Ah5CZlft41i8L6LOF/LCuDBuYlu/fI2nuCc8d
 m4wwtkou1Y/kIwbEsE/6RQwRXUZhzO6llfoN96Fczr/RwvPIK5SVMixqWq4QGFAyK0m/1ap4
 bhIRrdCLVQcgU4glo17vqfEaRcTW5SgX+pGs4KIPPBE5J/ABD6pBnUUAEQEAAcLA/AQYAQgA
 JhYhBIUq/WFSDTiOvUIqv2u9DlcdrjdRBQJlD89ZBQkFo5qAAhsMAAoJEGu9DlcdrjdR4C0L
 /RcjolEjoZW8VsyxWtXazQPnaRvzZ4vhmGOsCPr2BPtMlSwDzTlri8BBG1/3t/DNK4JLuwEj
 OAIE3fkkm+UG4Kjud6aNeraDI52DRVCSx6xff3bjmJsJJMb12mWglN6LjdF6K+PE+OTJUh2F
 dOhslN5C2kgl0dvUuevwMgQF3IljLmi/6APKYJHjkJpu1E6luZec/lRbetHuNFtbh3xgFIJx
 2RpgVDP4xB3f8r0I+y6ua+p7fgOjDLyoFjubRGed0Be45JJQEn7A3CSb6Xu7NYobnxfkwAGZ
 Q81a2XtvNS7Aj6NWVoOQB5KbM4yosO5+Me1V1SkX2jlnn26JPEvbV3KRFcwV5RnDxm4OQTSk
 PYbAkjBbm+tuJ/Sm+5Yp5T/BnKz21FoCS8uvTiziHj2H7Cuekn6F8EYhegONm+RVg3vikOpn
 gao85i4HwQTK9/D1wgJIQkdwWXVMZ6q/OALaBp82vQ2U9sjTyFXgDjglgh00VRAHP7u1Rcu4
 l75w1xInsg==
In-Reply-To: <aEyEA6hXGeiN-0jp@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/13/2025 1:03 PM, Sean Christopherson wrote:
> On Fri, Jun 13, 2025, Xin Li wrote:
>> On 6/13/2025 7:18 AM, Sean Christopherson wrote:
>>> On Fri, Jun 13, 2025, Xin Li (Intel) wrote:
>>>> Move DR7_RESET_VALUE to <uapi/asm/debugreg.h> to prepare to write DR7
>>>> with DR7_RESET_VALUE at boot time.
>>>
>>> Alternatively, what about dropping DR7_RESET_VALUE,  moving KVM's DR6 and DR7
>>> #defines out of arch/x86/include/asm/kvm_host.h, and then using DR7_FIXED_1?
>>
>> We definitely should do it, I see quite a few architectural definitions
>> are in KVM only headers (the native FRED patches needed to reuse the event
>> types that were previously VMX-specific and moved them out of KVM
>> headers).
>>
>> Because there is an UAPI header, we probably don't want to remove
>> definitions from it?
> 
> What #defines are in which uapi header?

arch/x86/include/uapi/asm/debugreg.h has:

#define DR_BUS_LOCK     (0x800)         /* bus_lock */
#define DR_STEP         (0x4000)        /* single-step */
#define DR_SWITCH       (0x8000)        /* task switch */

And arch/x86/include/asm/kvm_host.h also has:

#define DR6_BUS_LOCK   (1 << 11)
#define DR6_BD          (1 << 13)
#define DR6_BS          (1 << 14)
#define DR6_BT          (1 << 15)
#define DR6_RTM         (1 << 16)

Duplicated definitions for the same DR6 bits.


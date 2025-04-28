Return-Path: <kvm+bounces-44522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FC5EA9E80A
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 08:13:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CE083AC677
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 06:13:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 444F71BFE00;
	Mon, 28 Apr 2025 06:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="GWHX7yt4"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0B08F77;
	Mon, 28 Apr 2025 06:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745820798; cv=none; b=ibRPug1fRr13gKTWsjOUnIvxFvhIFqct6nWFcrkkA8+qhKh9r0eJiS5FvMW44g+OKcITZu9lA6kLdZEm8Cbjj/KwZPoCjMpCT6AAX8UkViOYYGHYOzVPyQmNBlfafgsTn070LS65q11H+CLmywtRYsHbyGcQDkOM5r8OXpqhXCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745820798; c=relaxed/simple;
	bh=uSinJXX141VDpRj0NJMHn0sNYk3ounLPrxE0I485AnM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Eltb45jolW7VPZ2574+/85Oo54RYnHupQ8h0wIcsWOVdavN5QDQIwZ5GSFbPWOGS+Tj2Zhb8g+YhkBhD+lCNU5UcfxSIEU2HgNBFhK9jSjuHeWirT/BrTN1DHcV91S4hd3YcbS6bx5ZIuNgoG8lgwUfZ83K3UlOT6kClCI9vFrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=GWHX7yt4; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53S6Cagf3004227
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Sun, 27 Apr 2025 23:12:36 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53S6Cagf3004227
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745820758;
	bh=xKP2Zrh6yW8Ady/8TpHmZraikp5mGbEP9+lzght28ng=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=GWHX7yt4WEzEtf7RsGgQoXXVHdHLYcsnAJTVzpCYMTnmHRw7TjROkpOgKc8rE+dGP
	 Otp8sx97Mp/JMnnzCi8PvemkvC7G2xMOD+BYST/DPP544q/IKCzbZJYK4zeQwdI+iB
	 nSjkD/WE5aR0o7VND8v/xun6uqOF6/Q0jexc7NLo1+4HiuvkaMrrNUtvzmfQ1kq6Yn
	 kiJ17T5XXdYmOjV6d1+qo5/w3pWaRmA1fGhiLiNwY9vRnqnErl+5McULvkocnQHWHr
	 ZTudD2tB03BtfEG9FjGfJvKVuVrmrQC0zv1qoWDiB0eXVFpk6PvkWsP98EQLzVt59E
	 8QtDbAIGG9oFg==
Message-ID: <87f97718-b105-4385-bfd5-86d7b2e0174b@zytor.com>
Date: Sun, 27 Apr 2025 23:12:35 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/7] x86/fpu/xstate: Differentiate default features for
 host and guest FPUs
From: Xin Li <xin@zytor.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "ebiggers@google.com" <ebiggers@google.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Spassov, Stanislav" <stanspas@amazon.de>,
        "levymitchell0@gmail.com" <levymitchell0@gmail.com>,
        "samuel.holland@sifive.com" <samuel.holland@sifive.com>,
        "Li, Xin3" <xin3.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yang, Weijiang" <weijiang.yang@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "john.allen@amd.com" <john.allen@amd.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        "vigbalas@amd.com" <vigbalas@amd.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "hpa@zytor.com"
 <hpa@zytor.com>, "bp@alien8.de" <bp@alien8.de>,
        "aruna.ramakrishna@oracle.com" <aruna.ramakrishna@oracle.com>,
        "x86@kernel.org" <x86@kernel.org>
References: <20250410072605.2358393-1-chao.gao@intel.com>
 <20250410072605.2358393-4-chao.gao@intel.com>
 <f53bea9b13bd8351dc9bba5e443d5e4f4934555d.camel@intel.com>
 <aAtG13wd35yMNahd@intel.com>
 <4a4b1f18d585c7799e5262453e4cfa2cf47c3175.camel@intel.com>
 <66b3ac69-447c-433f-a907-da20241d55ed@zytor.com>
Content-Language: en-US
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
In-Reply-To: <66b3ac69-447c-433f-a907-da20241d55ed@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/27/2025 10:51 PM, Xin Li wrote:
> On 4/25/2025 9:09 AM, Edgecombe, Rick P wrote:
>>>    And that will create a bit of a
>>>   :snafu if Linux does gain support for SSS.
>>>
>>> *:https://lore.kernel.org/kvm/ZM1jV3UPL0AMpVDI@google.com/
>> I chatted with Xin about this a few weeks ago. It sounds like FRED 
>> bare metal
>> SSS will not need CET_S state, but it wasn't 100% clear.
> 
> FRED reuses one CET_S MSR IA32_PL0_SSP, and give it an alias
> IA32_FRED_SSP0.

Native use of IA32_FRED_SSP0 is very much like IA32_FRED_RSP0:

1) Both are per-task constants.

2) Both are only used for delivering events when running userspace.


IA32_FRED_RSP0 is set on return to userspace:

https://web.git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fe85ee391966c4cf3bfe1c405314e894c951f521


I suppose we'll likely apply the same approach to IA32_FRED_SSP0 if we
plan to enable SSS for the kernel.  This won't add any extra maintenance
cost, as both x86 and KVM maintainers are well aware.

Thanks!
     Xin


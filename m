Return-Path: <kvm+bounces-43266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F34D2A88A8C
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 19:59:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0857317452F
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 17:59:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EFB3289357;
	Mon, 14 Apr 2025 17:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="OvSSxGHc"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC93F1A08AB;
	Mon, 14 Apr 2025 17:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744653561; cv=none; b=ZzLJtcmRk2+QLVIwhIAQcdJDCnNBNqKS3DW9I71hZCzh/7U63qz0LUmGHGtjheL1zRqspl4yAuax1MKuAxcmnpmMLUEnO0nmrJWeZsRlAuaDlPooKy6RQsZRLXgrTuqHjPaa+epDDAZNLz1A5TKk7haqlX0yrGMauc4FcbOUVJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744653561; c=relaxed/simple;
	bh=izHoMpjiDMEPcNnJKy/EPdzd29yVBe0tWK63jGCJu1M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RhoXzD10VugpkdXxByy8eoUbuO4tR5Wxf5pRMUGOGazXHJ5/JZfIIDCnsQng0Fg6QSdAhwGte+rHV4Vyjv1MwkL1sO1CeAy038E9OTRZ78ZOJjoG55qtRGVn2P3mKBma8XGMIxA4NKC3n7igkEYd8SlDwA/Gs88lR9ee6aH+SNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=OvSSxGHc; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53EHxDr72308244
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 14 Apr 2025 10:59:15 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53EHxDr72308244
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1744653555;
	bh=p4lhl3SeNve08MUw1GRBS2FETk4fVhCOs/fGiDb9eW4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OvSSxGHc5YBn+D0+RJiBGNfTLRJTg2TxHIAFv7wpUgwlTQf2QC+J5AdRUMEMZxDDG
	 rmVzV5dgbGeILeguDEe/S6vytJzVDCr3+CuOGbjQ7S73vU60Um+ecZO+zDlw9GrtgN
	 QqQBkh61qbhhwEf4n0jsrsuliOIPidtxWqJYKarsEN6+8/4rDNMQLjOXiAcLuCnRhd
	 I7kt2XwCQ017eo6BzYMAK0XJ/2twgpI72QkiU9E/MbFA6zROi42JiZCYMX7Mp3zAO2
	 I8Zh62sf9bRboagIVItnHBiAxO1IrX7vr36qIRGoU1gk7YGbU2ZM247wV2Wa/d+Tr+
	 6k7+cojOyyDTQ==
Message-ID: <ab422dd6-94aa-4da7-9f92-fe358bae8ed5@zytor.com>
Date: Mon, 14 Apr 2025 10:59:12 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] Documentation: kvm: Fix a section number
To: Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com
References: <20250414165146.2279450-1-xin@zytor.com>
 <87sema8yhy.fsf@trenco.lwn.net>
 <747d9d7d-c500-46f0-b0f8-a157dc7524ad@zytor.com>
 <87o6wy8who.fsf@trenco.lwn.net>
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
In-Reply-To: <87o6wy8who.fsf@trenco.lwn.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/14/2025 10:48 AM, Jonathan Corbet wrote:
> Xin Li <xin@zytor.com> writes:
> 
>> On 4/14/2025 10:05 AM, Jonathan Corbet wrote:
>>>> -7.37 KVM_CAP_ARM_WRITABLE_IMP_ID_REGS
>>>> +7.42 KVM_CAP_ARM_WRITABLE_IMP_ID_REGS
>>>>    -------------------------------------
>>> The fix seems fine but ... I have to ask ... do the section numbers buy
>>> anything here?  We have a documentation system that can do nice
>>> cross-references when needed, so I'm not sure that these numbers add
>>> anything other than a bit of manual maintenance hassle.
>>
>> So you prefer to get rid of the section numbering?
>>
>> Looks it makes it simpler to maintain the documentation.  But that would
>> anyway be another serial patches, right?
> 
> *I* would prefer it, but that call is really up to the KVM folks, not
> me.  Their preference far outweighs mine on this ... I'm just venting :)

/facepalm


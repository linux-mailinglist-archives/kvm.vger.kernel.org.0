Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F5522038C
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 06:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgGOET6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 00:19:58 -0400
Received: from terminus.zytor.com ([198.137.202.136]:58911 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728548AbgGOETm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 00:19:42 -0400
Received: from [IPv6:2607:fb90:86aa:c3d1:98d1:b804:417e:dfd0] ([IPv6:2607:fb90:86aa:c3d1:98d1:b804:417e:dfd0])
        (authenticated bits=0)
        by mail.zytor.com (8.15.2/8.15.2) with ESMTPSA id 06F4IkNn3694318
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Tue, 14 Jul 2020 21:18:47 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 06F4IkNn3694318
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2020062301; t=1594786728;
        bh=GyDpl2vFDnvV7p1dzIy8pnaKCty78BASZHAAdM32od0=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=Ys6oiqdb2TxPD8sWGkgID7lTc9Y9vTkG+N22y0Tn42ImUz+AMF13iSVJv+KXbVgLt
         fDmHJR8u6yeuZUm0IEQe+r0//vzK84GyzKBjGpB9XHtFlJ+qlPJmP1PkBTfnAgeF4t
         8JgmooE1AQkw2BKksaeqoBfKA65hhnD67axrNZxwrOXv2e/omxHX0kKWWDjpDpSN8u
         PiExThT5OQUFH9qJiv6MfnXXDpYdbO9n4T/n5YCOsdFLrxE7C/MX57JihHGqLz4pt4
         g1QJ09w/obNU5px8FgYtJ72RbjVoPJ3aKEpC7o1eB7ZOLsxu0ses9+G83I8hRMF5BL
         W4KaOSRlGMhzg==
Date:   Tue, 14 Jul 2020 21:18:34 -0700
User-Agent: K-9 Mail for Android
In-Reply-To: <e24f5802-5187-956c-80ad-a4cc8f66a261@intel.com>
References: <1594088183-7187-1-git-send-email-cathy.zhang@intel.com> <1594088183-7187-4-git-send-email-cathy.zhang@intel.com> <20200714030047.GA12592@linux.intel.com> <80d91e21-6509-ff70-fb5a-5c042f6ea588@intel.com> <3EFFDE4B-7844-4BB3-A824-487EE8359376@zytor.com> <e24f5802-5187-956c-80ad-a4cc8f66a261@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 3/4] x86: Expose SERIALIZE for supported cpuid
To:     "Zhang, Cathy" <cathy.zhang@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
CC:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de,
        ricardo.neri-calderon@linux.intel.com, kyung.min.park@intel.com,
        jpoimboe@redhat.com, gregkh@linuxfoundation.org,
        ak@linux.intel.com, dave.hansen@intel.com, tony.luck@intel.com,
        ravi.v.shankar@intel.com
From:   hpa@zytor.com
Message-ID: <17B83AD0-C4E9-451C-A691-DBB8B85C1533@zytor.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On July 14, 2020 5:03:31 PM PDT, "Zhang, Cathy" <cathy=2Ezhang@intel=2Ecom>=
 wrote:
>On 7/15/2020 7:05 AM, hpa@zytor=2Ecom wrote:
>> On July 14, 2020 3:42:08 PM PDT, "Zhang, Cathy"
><cathy=2Ezhang@intel=2Ecom> wrote:
>>> On 7/14/2020 11:00 AM, Sean Christopherson wrote:
>>>> On Tue, Jul 07, 2020 at 10:16:22AM +0800, Cathy Zhang wrote:
>>>>> SERIALIZE instruction is supported by intel processors,
>>>>> like Sapphire Rapids=2E Expose it in KVM supported cpuid=2E
>>>> Providing at least a rough overview of the instruction, e=2Eg=2E its
>>> enumeration,
>>>> usage, fault rules, controls, etc=2E=2E=2E would be nice=2E  In isola=
tion,
>>> the
>>>> changelog isn't remotely helpful in understanding the correctness
>of
>>> the
>>>> patch=2E
>>> Thanks Sean! Add it in the next version=2E
>>>>> Signed-off-by: Cathy Zhang <cathy=2Ezhang@intel=2Ecom>
>>>>> ---
>>>>>    arch/x86/kvm/cpuid=2Ec | 3 ++-
>>>>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/arch/x86/kvm/cpuid=2Ec b/arch/x86/kvm/cpuid=2Ec
>>>>> index 8a294f9=2E=2Ee603aeb 100644
>>>>> --- a/arch/x86/kvm/cpuid=2Ec
>>>>> +++ b/arch/x86/kvm/cpuid=2Ec
>>>>> @@ -341,7 +341,8 @@ void kvm_set_cpu_caps(void)
>>>>>    	kvm_cpu_cap_mask(CPUID_7_EDX,
>>>>>    		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
>>>>>    		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
>>>>> -		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM)
>>>>> +		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
>>>>> +		F(SERIALIZE)
>>>>>    	);
>>>>>   =20
>>>>>    	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software=2E
>*/
>>>>> --=20
>>>>> 1=2E8=2E3=2E1
>>>>>
>> At least that one is easy: SERIALIZE is architecturally a NOP, but
>with hard serialization, like CPUID or IRET=2E
>SERIALIZE does not modify registers, arithmetic flags or memory, which=20
>is different with CPUID=2E

That's what I meant with it being an architectural NOP=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E

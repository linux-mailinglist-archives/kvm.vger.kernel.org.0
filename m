Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E22EA447D
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2019 14:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbfHaMp7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Aug 2019 08:45:59 -0400
Received: from mout.web.de ([212.227.15.3]:40971 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbfHaMp7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 31 Aug 2019 08:45:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1567255548;
        bh=RvSX8wmVV1/t3wO4yIQ9ggSMLb96cyp/995C5cCbU+o=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=fpZuw5L/suAJspers1coX5lK04mQGStOFEWizxe/zXL5C511qt7m4EX0zi4eqjlbN
         ISaCemcz/7/q7nekhifRFMXCAgPO+vaJntvjcysHW4Cpl9AAFeIULzVfmHfH9pzlct
         4N8pm6WTHMMCIHmu0geaQ+rDB3hDeDZl2dVSZ7LY=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [10.0.0.32] ([85.71.157.74]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MGiLB-1hztsr2ZJR-00DVQz; Sat, 31
 Aug 2019 14:45:48 +0200
Subject: Re: [PATCH] kvm: Nested KVM MMUs need PAE root too
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <87lfvl5f28.fsf@debian> <87lfvgm8a9.fsf@vitty.brq.redhat.com>
From:   Jiri Palecek <jpalecek@web.de>
Message-ID: <6aa83eaf-ca9c-74ea-1a62-98ccd0d516d7@web.de>
Date:   Sat, 31 Aug 2019 14:45:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87lfvgm8a9.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Provags-ID: V03:K1:475GRmwM4IQhxavcShXkrVZDVJz/hkrKtILQ3puEAFUDfqQ0lHN
 wZWBy1nrPjeL9Ic8Rl1Tqy9UOGxdJSB71VUbYpFcWK3Oq5PNwffzPx9Fl+j+m+8roaF2kZU
 ydljgeU64SAgOZrgfjYDkGFFnNQ37WHPJwbuK6Zfs33ieYg+S0eiFAacF3piiYybc+cgxdS
 0C5KV5ksYZI78IkFJNZOQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:T1V4KNvefUI=:YZtN897BazqKX1SY2ilZGY
 FsuzNfIrdj824z+niudDdvyhx3VXbvcbJt0GBq7QyW7ALVS9GcZI9Kj/BeQw/u2djGi9uK3N+
 HOGqYRpt8sx6KfrZLooOI2jPsE46YUB1fdDpQorgOuqCT4seVMKWal0OP1xPY0MqVEurYMMWu
 gvdMllSGQ7RwUqb1cM2FFHLncyxRMimB9ozUY7kqkploBobR/S/c11bLAcXqYKEapJ9KxJmra
 Nj2rqUs6HXutWahFaZvS9AMNCrqxULJZsbWFia++0kqxyLgFzfqWMVxTQzw6ZnmogTQsHTJfb
 +E4sCCUtdpcsRY4KijhkgW26cV85phQ6jlQNhXUaVgtpxSxiJ5SXoQVglBeBEoOU6qdkftQyM
 5FQHmgdJfLV+nSig/C2z0LP9pD7gGmfJthXwXm6/bEEowi5KTHH9OBkhpil25k7/9WW0wa+6d
 6JgJGnJ/uqg56AQK20aMcPFsINJFBj8gvo6RulYZH/tdNiACs2lg6SWjB4a4xz6160Lntbr6z
 1GkNxkUUZqczN95lZEU8y3OlB11+gUS8l5c7oUVONjbyWXcrFR1FXsUq2xIZNDzwzgR8SEVX4
 LnWZr54ROrWRk0fqp8myXAJbGT13/dUT1AfwyES2luLgkTtNPATrWeWOx64Xk5+gxORL8SrF4
 beI4fOI5JO8LeIRILEzxEDdnMtgM9PXyvsTkWSTZpW7srEGahzpQKbmw/UqDc63WWfBmx+MA0
 2X02CDoIDTKnVvkmy1bJTUpkXU0XZOtYH3ktgwTHZFoBdZZuCU0APOyG1cIBVjwatPzKbsnsf
 PvMs+PNOtj7txehBb5YjQ/9mPphFs+ZbXjY9NcQpKgMi4Hu0lqFVN3FzYJ4wFJy5ngR8HBAOk
 IQ81mPCQi6hX+YWHSJ8GZPSt5ypcqJUi9XKs2pI+y7YRCYOuxpDu9GWWhPn1bRVgcXKLIoy5L
 +Z4f4UlEV40DVxNzSC4MWIzTWmJ7yj40qYgclunjfwQ9U9b3vRq7gvKM/G/jisRB9Kb584x0x
 37zIPn9U3SaNAA934yD7YI/vDstf+KF8azXqXdUS5zU3I4QFDwyeiF2SO6yKpQG6vWQXFSVOI
 BPmrmIn0WwRThL1+Y+Agm/xpNPrMo5O3b1KFoHkJ7SKb9pOm7HzNhb5t9Poe3mn1yyL0PI1UP
 rnkHVanVd9saN9gd41SoRFkREyh9lsRAj2XSQsutVMshAFyQ==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello

On 26. 08. 19 14:16, Vitaly Kuznetsov wrote:
> Ji=C5=99=C3=AD Pale=C4=8Dek <jpalecek@web.de> writes:
>
>
>> The reason for this is that when setting up nested KVM instance,
>> arch.mmu is set to &arch.guest_mmu (while normally, it would be
>> &arch.root_mmu).
> MMU switch to guest_mmu happens when we're about to start L2 guest - and
> we switch back to root_mmu when we want to execute L1 again (e.g. after
> vmexit) so this is not a one-time thing ('when setting up nested KVM
> instance' makes me think so).
OK I'll rephrase it.
>
>> However, the initialization and allocation of
>> pae_root only creates it in root_mmu. KVM code (ie. in
>> mmu_alloc_shadow_roots) then accesses arch.mmu->pae_root, which is the
>> unallocated arch.guest_mmu->pae_root.
> Fixes: 14c07ad89f4d ("x86/kvm/mmu: introduce guest_mmu")
Thanks
>> This fix just allocates (and frees) pae_root in both guest_mmu and
>> root_mmu (and also lm_root if it was allocated). The allocation is
>> subject to previous restrictions ie. it won't allocate anything on
>> 64-bit and AFAIK not on Intel.
> Right, it is only NPT 32 bit which uses that (and it's definitely
> undertested).
>
>> See bug 203923 for details.
> Personally, I'd prefer this to be full link
> https://bugzilla.kernel.org/show_bug.cgi?id=3D203923
> as there are multiple bugzillas out threre.
Will do
>> Signed-off-by: Jiri Palecek <jpalecek@web.de>
>> Tested-by: Jiri Palecek <jpalecek@web.de>
> This is weird. I always thought "Signed-off-by" implies some form of
> testing (unless stated otherwise) :-)
Well, I thought it was quite common that someone authors a patch but
doesn't have means to test it. Anyway, after reading Kernel Newbies, I
added that to indicate that I did test it and if there's need to test
anything reasonably sized on this particualr configuration, I'm open for i=
t.
>
>
>> ---
>>   arch/x86/kvm/mmu.c | 30 ++++++++++++++++++++++--------
>>   1 file changed, 22 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 24843cf49579..efa8285bb56d 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -5646,7 +5647,19 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
>>   		vcpu->arch.guest_mmu.prev_roots[i] =3D KVM_MMU_ROOT_INFO_INVALID;
>>
>>   	vcpu->arch.nested_mmu.translate_gpa =3D translate_nested_gpa;
>> -	return alloc_mmu_pages(vcpu);
>> +
>> +	ret =3D alloc_mmu_pages(vcpu, &vcpu->arch.guest_mmu);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret =3D alloc_mmu_pages(vcpu, &vcpu->arch.root_mmu);
>> +	if (ret)
>> +		goto fail_allocate_root;
> (personal preference) here you're just jumping over 'return' so I'd
> prefer this to be written as:
>
>          ret =3D alloc_mmu_pages(vcpu, &vcpu->arch.root_mmu);
>          if (!ret)
>              return 0;
>
>          free_mmu_pages(&vcpu->arch.guest_mmu);
>          return ret;
>
> and no label/goto required.

OK I'll change it. However, I like the solution by Sean Christopherson mor=
e.


Regards

 =C2=A0=C2=A0=C2=A0 Jiri Palecek




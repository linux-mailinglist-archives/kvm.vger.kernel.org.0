Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1E41107399
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 14:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbfKVNq7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 08:46:59 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:25275 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726526AbfKVNq7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Nov 2019 08:46:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574430417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=wShAbidA/emogjpQGqwwkUqogmeQUcu3B7q0s7hQZnU=;
        b=VLEB3SgQEkJ6asauQU+3J/xyVPk3qTsr80gwUK8mDlJ0S254o384iydSFcTqFs3dUkDhjK
        dtIwSgL+GAhoXAW2R7CcnWetbPq32yWCGIrX/f9XDa7I/Qo9diy39h8QVVXijiONArnhT0
        5Zlqkqlvrst2fEeTAcQ9E1SR7QyXCUM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-Cu0AdHz1OB-xICreZX_p3Q-1; Fri, 22 Nov 2019 08:46:56 -0500
Received: by mail-wr1-f70.google.com with SMTP id q12so3947607wrr.3
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2019 05:46:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gzt1L/n/CikicBNsylvMPZnLGaruSKSA5V9vwS0/fT8=;
        b=FJ1eUXzowwjQ0PdNr4K7lPLwvkPfkCFzrnQGHXKskXbQYy4lsiNS/7kJbRdiIqwtUy
         Hv6MYB3uyhsRsH/vZ/qZqyJFEj4tfZJPVzMkx10nqpB55jLcw+PXLLOFo348qoTtM73a
         h3mwpm5NhUtx43c0qS1fntGIf6oOqhL2j246ov8r2l1WT0BOiHEes8GI1I9e32r/r4To
         fBQXiAezuAdFoRq/OB/Nim6Mu5oM/90JVPFhGzypr/msc8Hhnd9M0eMqZnEzIMf6w3Ay
         UTrjYDNDGqyvkxM2lpw8EG9nOIREp9+5WNBHvhO+zuSyFAoKhN3Slu2j2oYFaxrjYLaK
         CdwA==
X-Gm-Message-State: APjAAAVUMH3qzt4bWURCwNjOAOsTy1zrXU7d+aFx0lfr6CNtYZSKQuxL
        CwDK6o6Ya+TueNuu0wJgmsF6IZDxF0XiFmRvM1xFHtI0uS1rmUzo7p4TenYOq3qmGSInFdKUsEB
        GxLwU6BC6X/tl
X-Received: by 2002:a7b:ce92:: with SMTP id q18mr16842401wmj.164.1574430415132;
        Fri, 22 Nov 2019 05:46:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqwTUb0Ur15gvJMe16U4YlT7+OtSbysrzVj5n+ZUN0jXFBD6Hns7D88+ehqV4B2SNUlal8Q4Tw==
X-Received: by 2002:a7b:ce92:: with SMTP id q18mr16842372wmj.164.1574430414765;
        Fri, 22 Nov 2019 05:46:54 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:804c:6f01:8c0d:ce14? ([2001:b07:6468:f312:804c:6f01:8c0d:ce14])
        by smtp.gmail.com with ESMTPSA id c12sm2550850wro.96.2019.11.22.05.46.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Nov 2019 05:46:54 -0800 (PST)
Subject: Re: [PATCH 2/2] KVM x86: Mask memory encryption guest cpuid
To:     Brijesh Singh <brijesh.singh@amd.com>,
        Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20191121203344.156835-1-pgonda@google.com>
 <20191121203344.156835-3-pgonda@google.com>
 <d876b27b-9519-a0a0-55c2-62e57a783a7f@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <d945adcc-d548-1dc0-b43f-769a02d0cede@redhat.com>
Date:   Fri, 22 Nov 2019 14:46:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <d876b27b-9519-a0a0-55c2-62e57a783a7f@amd.com>
Content-Language: en-US
X-MC-Unique: Cu0AdHz1OB-xICreZX_p3Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/11/19 14:01, Brijesh Singh wrote:
>=20
> On 11/21/19 2:33 PM, Peter Gonda wrote:
>> Only pass through guest relevant CPUID information: Cbit location and
>> SEV bit. The kernel does not support nested SEV guests so the other data
>> in this CPUID leaf is unneeded by the guest.
>>
>> Suggested-by: Jim Mattson <jmattson@google.com>
>> Signed-off-by: Peter Gonda <pgonda@google.com>
>> Reviewed-by: Jim Mattson <jmattson@google.com>
>> ---
>>  arch/x86/kvm/cpuid.c | 8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 946fa9cb9dd6..6439fb1dbe76 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -780,8 +780,14 @@ static inline int __do_cpuid_func(struct kvm_cpuid_=
entry2 *entry, u32 function,
>>  =09=09break;
>>  =09/* Support memory encryption cpuid if host supports it */
>>  =09case 0x8000001F:
>> -=09=09if (!boot_cpu_has(X86_FEATURE_SEV))
>> +=09=09if (boot_cpu_has(X86_FEATURE_SEV)) {
>> +=09=09=09/* Expose only SEV bit and CBit location */
>> +=09=09=09entry->eax &=3D F(SEV);
>=20
>=20
> I know SEV-ES patches are not accepted yet, but can I ask to pass the
> SEV-ES bit in eax?

I think it shouldn't be passed, since KVM does not support SEV-ES.

Paolo

>=20
>> +=09=09=09entry->ebx &=3D GENMASK(5, 0);
>> +=09=09=09entry->edx =3D entry->ecx =3D 0;
>> +=09=09} else {
>>  =09=09=09entry->eax =3D entry->ebx =3D entry->ecx =3D entry->edx =3D 0;
>> +=09=09}
>>  =09=09break;
>>  =09/*Add support for Centaur's CPUID instruction*/
>>  =09case 0xC0000000:
>=20


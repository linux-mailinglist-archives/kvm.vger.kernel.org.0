Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A798F1A8C
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 16:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732195AbfKFP5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 10:57:23 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20755 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727231AbfKFP5U (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Nov 2019 10:57:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573055839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
        in-reply-to:in-reply-to:references:references:openpgp:openpgp:autocrypt:autocrypt;
        bh=4XBocO404UvJWNVCOgyaoQws+FJzp3wcDLJ3PBROiUg=;
        b=MSslsXKMipN6hH54dStADeoemxqMJawajsetUf39mzQHDXuThWeLe3tGBrBZ2wzR8mjZs0
        n1cj8w1qaHM+oqhGyKrxMxt1Qzm1OrIyOrlWWfxpz4em95Ao+TaHWmVLcy9BKRDks1ilQ1
        V/7r9xvcwgci7aBpzONdX1QJUT9lDhU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-etHT-JttOmWv7bYQ2r2Z_w-1; Wed, 06 Nov 2019 10:57:16 -0500
X-MC-Unique: etHT-JttOmWv7bYQ2r2Z_w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B7E2107ACC3;
        Wed,  6 Nov 2019 15:57:14 +0000 (UTC)
Received: from [10.18.17.163] (dhcp-17-163.bos.redhat.com [10.18.17.163])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0013A600D3;
        Wed,  6 Nov 2019 15:57:06 +0000 (UTC)
Subject: Re: [Patch v1 1/2] KVM: remember position in kvm->vcpus array
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, mtosatti@redhat.com, rkrcmar@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
References: <1573047398-7665-1-git-send-email-nitesh@redhat.com>
 <1573047398-7665-2-git-send-email-nitesh@redhat.com>
 <20191106144326.GA16249@linux.intel.com>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <58c040b7-ac4a-1d8e-3cd6-7d3aeb6ba4f1@redhat.com>
Date:   Wed, 6 Nov 2019 10:57:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191106144326.GA16249@linux.intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iR0hOeQ36LDK9x8KBMJOlrp4IugMqitvk"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iR0hOeQ36LDK9x8KBMJOlrp4IugMqitvk
Content-Type: multipart/mixed; boundary="ty28LAXe3TVfuOL18dtbmg3cPBr1cDIKB";
 protected-headers="v1"
From: Nitesh Narayan Lal <nitesh@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 mtosatti@redhat.com, rkrcmar@redhat.com, vkuznets@redhat.com,
 wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Message-ID: <58c040b7-ac4a-1d8e-3cd6-7d3aeb6ba4f1@redhat.com>
Subject: Re: [Patch v1 1/2] KVM: remember position in kvm->vcpus array
References: <1573047398-7665-1-git-send-email-nitesh@redhat.com>
 <1573047398-7665-2-git-send-email-nitesh@redhat.com>
 <20191106144326.GA16249@linux.intel.com>
In-Reply-To: <20191106144326.GA16249@linux.intel.com>

--ty28LAXe3TVfuOL18dtbmg3cPBr1cDIKB
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 11/6/19 9:43 AM, Sean Christopherson wrote:
> On Wed, Nov 06, 2019 at 08:36:37AM -0500, Nitesh Narayan Lal wrote:
>> From: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
>>
>> Fetching an index for any vcpu in kvm->vcpus array by traversing
>> the entire array everytime is costly.
>> This patch remembers the position of each vcpu in kvm->vcpus array
>> by storing it in vcpus_idx under kvm_vcpu structure.
>>
>> Signed-off-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
>> ---
>>  include/linux/kvm_host.h | 11 +++--------
>>  virt/kvm/kvm_main.c      |  5 ++++-
>>  2 files changed, 7 insertions(+), 9 deletions(-)
>>
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 719fc3e..31c4fde 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -266,7 +266,8 @@ struct kvm_vcpu {
>>  =09struct preempt_notifier preempt_notifier;
>>  #endif
>>  =09int cpu;
>> -=09int vcpu_id;
>> +=09int vcpu_id; /* id given by userspace at creation */
>> +=09int vcpus_idx; /* index in kvm->vcpus array */
> I'd probably prefer vcpu_idx or vcpu_index, but it's not a strong
> preference by any means.

Sure, I will probably replace it with vcpu_idx.

>
>>  =09int srcu_idx;
>>  =09int mode;
>>  =09u64 requests;
>> @@ -571,13 +572,7 @@ static inline struct kvm_vcpu *kvm_get_vcpu_by_id(s=
truct kvm *kvm, int id)
>> =20
>>  static inline int kvm_vcpu_get_idx(struct kvm_vcpu *vcpu)
>>  {
>> -=09struct kvm_vcpu *tmp;
>> -=09int idx;
>> -
>> -=09kvm_for_each_vcpu(idx, tmp, vcpu->kvm)
>> -=09=09if (tmp =3D=3D vcpu)
>> -=09=09=09return idx;
>> -=09BUG();
>> +=09return vcpu->vcpus_idx;
>>  }
>> =20
>>  #define kvm_for_each_memslot(memslot, slots)=09\
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 67ef3f2..24ab711 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -2673,7 +2673,10 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *k=
vm, u32 id)
>>  =09=09goto unlock_vcpu_destroy;
>>  =09}
>> =20
>> -=09BUG_ON(kvm->vcpus[atomic_read(&kvm->online_vcpus)]);
>> +=09vcpu->vcpus_idx =3D atomic_read(&kvm->online_vcpus);
>> +
> Nit: I'd omit this newline since the assignment and BUG_ON() are directly
> related.

Makes sense to me.

>
>> +=09BUG_ON(kvm->vcpus[vcpu->vcpus_idx]);
> The assignment to kvm->vcpus a few lines below should be updated to use
> the new index.

Ah yes.
Thanks for pointing this out.

>
>> +
>> =20
>>  =09/* Now it's all set up, let userspace reach it */
>>  =09kvm_get_kvm(kvm);
>> --=20
>> 1.8.3.1
>>
--=20
Nitesh


--ty28LAXe3TVfuOL18dtbmg3cPBr1cDIKB--

--iR0hOeQ36LDK9x8KBMJOlrp4IugMqitvk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl3C7VEACgkQo4ZA3AYy
oznJChAAn/49v6/9S+zOUVx2Ww8EkOcZ5HiYdrMpQC2Zyb47a6gYwNVonHdf0t2I
KTTMCygGVH7x4W5gcqyEaQ9XWCpjkDxZZbVsH+y4PD+T6Jk4ykawgbk+WfWhFUCl
Q3CN/59C5gUYuT025OVq7RRJTa7W4oQ1JGi+oZeQD+qK4LjhYA46SFFLAyz58wJ8
OmyRUA6Z6H027CerSEYmN7i6gpNpZGVFY7pnbe3YnQGY91+w3Vr6xlTtZD/zz4L0
mnJv+uuV6Yu6nYDdFgIMpYB7o8bP180BvxDQl4lVjvtkpV/SUIoEcOFOSqlotjFF
/0b1wPeGr2gJa0U6MRo/lmRZxJgPRiYXN1YSJyXQo1RqeK8VMZ//5MDyb0ke4Wfa
Ogd/9i2upKAVgXMuwscJ9/UtKo+vdARa0p2anYSDglnNqYQLEw1IYpsOGTqb5LA6
C3VnNwVjo5aoAHEfoPuDAcib8pTfNnsJ7Sm2hwkhGrnmZwxjOyp/U+MD4cbxG6v2
ntfnE8JIX9pU3D8tRnVlGtlmpGWjs4ZcWhikMl5UTPlMTzaobRua3wg2kG8PswRO
ywmb9YAl8rSsyZlbgE1rnXlSFn9mcI69BFEbiyFyCK/rb9oDRj+1UDefz/qeCQPY
DeJAkSesMCi8yBHYBmt1Qhtjmd6lJzlzS2jOgllhHbC7yZhZC6c=
=IwmN
-----END PGP SIGNATURE-----

--iR0hOeQ36LDK9x8KBMJOlrp4IugMqitvk--


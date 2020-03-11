Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF19B182188
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 20:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731013AbgCKTGM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 15:06:12 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29503 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730799AbgCKTGM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Mar 2020 15:06:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583953570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=4vRow86Hd2ZBIEcluwNv2v8O/2kX9pz0tfQuIM2Vv3g=;
        b=KtCeh1irR42aY1r2i4s0nD2Ze+SZUY+Jk3Yz6fgQ1H3uEbdrOE8jU0OkGlK1gZJTJDqsLC
        RWuv6kvLoKULjOQFn+GQffA9rlocCiB4HLWAI2Hp0pAJcAC9bty9sa/gL1tlpqm7CbnH1B
        ZtlfFbSx4FA0zxZMraAXEFDUfIcBdMw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120--n0kgix7NPSBEl50H2xOWQ-1; Wed, 11 Mar 2020 15:06:07 -0400
X-MC-Unique: -n0kgix7NPSBEl50H2xOWQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7116F1005509;
        Wed, 11 Mar 2020 19:06:06 +0000 (UTC)
Received: from [10.10.120.19] (ovpn-120-19.rdu2.redhat.com [10.10.120.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 29D148F364;
        Wed, 11 Mar 2020 19:06:02 +0000 (UTC)
Subject: Re: [Patch v1] KVM: x86: Initializing all kvm_lapic_irq fields
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mtosatti@redhat.com,
        vkuznets@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
References: <1583951685-202743-1-git-send-email-nitesh@redhat.com>
 <c4370fce-1bc7-3a82-91a7-37fcd013bd77@redhat.com>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <1ee122a6-7c6a-f630-ea38-9f78960b76be@redhat.com>
Date:   Wed, 11 Mar 2020 15:05:59 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <c4370fce-1bc7-3a82-91a7-37fcd013bd77@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4qb8WLNjq3ajil9xtH0BeNRe2tGFbwosw"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4qb8WLNjq3ajil9xtH0BeNRe2tGFbwosw
Content-Type: multipart/mixed; boundary="QX3AFwGDvJNzwG4cp2sIXiy3edNL1QisG"

--QX3AFwGDvJNzwG4cp2sIXiy3edNL1QisG
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 3/11/20 2:49 PM, Paolo Bonzini wrote:
> On 11/03/20 19:34, Nitesh Narayan Lal wrote:
>> Previously all fields of structure kvm_lapic_irq were not initialized
>> before it was passed to kvm_bitmap_or_dest_vcpus(). Which will cause
>> an issue when any of those fields are used for processing a request.
>> This patch initializes all the fields of kvm_lapic_irq based on the
>> values which are passed through the ioapic redirect_entry object.
> Can you explain better how the bug manifests itself?

For example not initializing the irq.msi_redir_hint field, could lead to a
situation where it carries garbage (non-zero) value.
This will lead to misbehavior of kvm_apic_map_get_dest_lapic() when it invo=
kes
the kvm_lowest_prio_delivery(), that will return true because of non-zero
msi_redir_hint field.
To be on the safe side, I thought of initializing other struct fields as we=
ll.

If the above explanation makes sense, I can include it in the patch
subject and send a second version of this patch?

>
> Thanks,
>
> Paolo
>
>> Fixes: 7ee30bc132c6("KVM: x86: deliver KVM IOAPIC scan request to target=
 vCPUs")
>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
>> ---
>>  arch/x86/kvm/ioapic.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
>> index 7668fed..3a8467d 100644
>> --- a/arch/x86/kvm/ioapic.c
>> +++ b/arch/x86/kvm/ioapic.c
>> @@ -378,12 +378,15 @@ static void ioapic_write_indirect(struct kvm_ioapi=
c *ioapic, u32 val)
>>  =09=09if (e->fields.delivery_mode =3D=3D APIC_DM_FIXED) {
>>  =09=09=09struct kvm_lapic_irq irq;
>> =20
>> -=09=09=09irq.shorthand =3D APIC_DEST_NOSHORT;
>>  =09=09=09irq.vector =3D e->fields.vector;
>>  =09=09=09irq.delivery_mode =3D e->fields.delivery_mode << 8;
>> -=09=09=09irq.dest_id =3D e->fields.dest_id;
>>  =09=09=09irq.dest_mode =3D
>>  =09=09=09    kvm_lapic_irq_dest_mode(!!e->fields.dest_mode);
>> +=09=09=09irq.level =3D 1;
>> +=09=09=09irq.trig_mode =3D e->fields.trig_mode;
>> +=09=09=09irq.shorthand =3D APIC_DEST_NOSHORT;
>> +=09=09=09irq.dest_id =3D e->fields.dest_id;
>> +=09=09=09irq.msi_redir_hint =3D false;
>>  =09=09=09bitmap_zero(&vcpu_bitmap, 16);
>>  =09=09=09kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
>>  =09=09=09=09=09=09 &vcpu_bitmap);
>>
--=20
Nitesh


--QX3AFwGDvJNzwG4cp2sIXiy3edNL1QisG--

--4qb8WLNjq3ajil9xtH0BeNRe2tGFbwosw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl5pNpcACgkQo4ZA3AYy
oznNVw//bf/rilGP0lQnt2uVyp8SPqfAN70HM/Q2mUHJjGNzfJz8G/YXs9FeTgkO
qek7aheW278l6TXlZSDu8TDt1vNFZ7tXS6bfKCS2GgSMQt7jhu+4GfpudqQStvMZ
nKeIZDEhiMNrAmERG3XqdTvzwiTjzdTfRn6QUpsx/GUBGbKC6GwIoAydqOj6/Ld4
BCVFakVnXeKDQwwlZDhj8DnQ9bSp7BwGCjptZw/TpYVpBGg/NqM1nE2Pya8yJtvA
zs11b22i6E1fRydDVwdjb5qspwgqXoRmw99WBvax0/WOPscp3UvT9C2rwT9pOaqJ
C6OcERCXRmgSDBHFlEEab9hViDPhBBhvl8obJVo/7Y354o5ySi1df+enN/yaWpc1
B5YQnohSP7fSMWowXcJvlzCEg/jds5onFlwIvCXWBmAvFHDo/R3XX+c7uHTfbuqa
3tIEzZwxuFr1B/h5FsRvdvdQ12B2jSqi9cZM8uKEq5IOb880JSRMubzYmV00n4kY
nOfRLCkyW3hmAgyqZSNxD27eOc9AsIbdlFBL9QQKW2IthBobE3KpKp/4yGbSab/+
JBqguvnoLs8SGGL894CfUdih5Tu5eDyFqXjpIdbTzK4j1mFthffh5ZwtlR0z13S+
cS8FCSyNlnw2zZ1FmUoagsM/RW3K3sbRSfsfLntT4yaBYBa9CZA=
=JuN2
-----END PGP SIGNATURE-----

--4qb8WLNjq3ajil9xtH0BeNRe2tGFbwosw--


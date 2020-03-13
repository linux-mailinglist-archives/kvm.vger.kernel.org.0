Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30A14184BEB
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 17:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgCMQBk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 12:01:40 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46254 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726442AbgCMQBk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Mar 2020 12:01:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584115298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=9dyZ7K2rhwKQQgjwbCly51G6/dMYHDMwfOJm9Sq3Un8=;
        b=Vi8xOEy6KeiUc82K/KcCs9KDCwMffOV2gVhmj+FF6M7nglJkwlLyY8cbinW3c+zYSmByye
        ZL/nJoZkf/D7Trh5PMCX/fvq3TKjVDRegw69G5I+lt0irS5NzmlJ+h0OT3bv0Wpb8UDFLf
        v0Q7a6Jga4YdJiu9y0+oJ8oT2LR2pL0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-S-cQ1d80Mu-XWtmZlGhrMw-1; Fri, 13 Mar 2020 12:01:31 -0400
X-MC-Unique: S-cQ1d80Mu-XWtmZlGhrMw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9232D101AF02;
        Fri, 13 Mar 2020 16:01:29 +0000 (UTC)
Received: from [10.10.121.252] (ovpn-121-252.rdu2.redhat.com [10.10.121.252])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E25860E3E;
        Fri, 13 Mar 2020 16:01:24 +0000 (UTC)
Subject: Re: [Patch v2] KVM: x86: Initializing all kvm_lapic_irq fields in
 ioapic_write_indirect
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mtosatti@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        pbonzini@redhat.com, peterx@redhat.com
References: <1584105384-4864-1-git-send-email-nitesh@redhat.com>
 <871rpwpesg.fsf@vitty.brq.redhat.com>
 <29c41f43-a8c6-3d72-8647-d46782094524@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <e20e4fb5-247c-a029-e09f-49f83f2f9d1a@redhat.com>
Date:   Fri, 13 Mar 2020 12:01:22 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <29c41f43-a8c6-3d72-8647-d46782094524@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gqLjDvFIIlKGCMD8h54mAIs0D2mHi2qsx"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gqLjDvFIIlKGCMD8h54mAIs0D2mHi2qsx
Content-Type: multipart/mixed; boundary="7wo6zBSqKPPCUgIaU05bLm4pPdamA7aME"

--7wo6zBSqKPPCUgIaU05bLm4pPdamA7aME
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 3/13/20 9:38 AM, Nitesh Narayan Lal wrote:
> On 3/13/20 9:25 AM, Vitaly Kuznetsov wrote:
>> Nitesh Narayan Lal <nitesh@redhat.com> writes:
>>
>>> Previously all fields of structure kvm_lapic_irq were not initialized
>>> before it was passed to kvm_bitmap_or_dest_vcpus(). Which will cause
>>> an issue when any of those fields are used for processing a request.
>>> For example not initializing the msi_redir_hint field before passing
>>> to the kvm_bitmap_or_dest_vcpus(), may lead to a misbehavior of
>>> kvm_apic_map_get_dest_lapic(). This will specifically happen when the
>>> kvm_lowest_prio_delivery() returns TRUE due to a non-zero garbage
>>> value of msi_redir_hint, which should not happen as the request belongs
>>> to APIC fixed delivery mode and we do not want to deliver the
>>> interrupt only to the lowest priority candidate.
>>>
>>> This patch initializes all the fields of kvm_lapic_irq based on the
>>> values of ioapic redirect_entry object before passing it on to
>>> kvm_bitmap_or_dest_vcpus().
>>>
>>> Fixes: 7ee30bc132c6("KVM: x86: deliver KVM IOAPIC scan request to targe=
t vCPUs")
>>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
>>> ---
>>>  arch/x86/kvm/ioapic.c | 7 +++++--
>>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
>>> index 7668fed..3a8467d 100644
>>> --- a/arch/x86/kvm/ioapic.c
>>> +++ b/arch/x86/kvm/ioapic.c
>>> @@ -378,12 +378,15 @@ static void ioapic_write_indirect(struct kvm_ioap=
ic *ioapic, u32 val)
>>>  =09=09if (e->fields.delivery_mode =3D=3D APIC_DM_FIXED) {
>>>  =09=09=09struct kvm_lapic_irq irq;
>>> =20
>>> -=09=09=09irq.shorthand =3D APIC_DEST_NOSHORT;
>>>  =09=09=09irq.vector =3D e->fields.vector;
>>>  =09=09=09irq.delivery_mode =3D e->fields.delivery_mode << 8;
>>> -=09=09=09irq.dest_id =3D e->fields.dest_id;
>>>  =09=09=09irq.dest_mode =3D
>>>  =09=09=09    kvm_lapic_irq_dest_mode(!!e->fields.dest_mode);
>>> +=09=09=09irq.level =3D 1;
>> 'level' is bool in struct kvm_lapic_irq but other than that, is there a
>> reason we set it to 'true' here? I understand that any particular
>> setting is likely better than random
> Yes, that is the only reason which I had in my mind while doing this chan=
ge.
> I was not particularly sure about the value, so I copied what ioapic_seri=
vce()
> is doing.

Do you think I should skip setting this here?

>>  and it should actually not be used
>> without setting it first but still?
>>
>>> +=09=09=09irq.trig_mode =3D e->fields.trig_mode;
>>> +=09=09=09irq.shorthand =3D APIC_DEST_NOSHORT;
>>> +=09=09=09irq.dest_id =3D e->fields.dest_id;
>>> +=09=09=09irq.msi_redir_hint =3D false;
>>>  =09=09=09bitmap_zero(&vcpu_bitmap, 16);
>>>  =09=09=09kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
>>>  =09=09=09=09=09=09 &vcpu_bitmap);
--=20
Nitesh


--7wo6zBSqKPPCUgIaU05bLm4pPdamA7aME--

--gqLjDvFIIlKGCMD8h54mAIs0D2mHi2qsx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl5rrlMACgkQo4ZA3AYy
oznMMBAAwHpFXBl2ar2xFic2xNFMKllXHPC5wJ17WkorOOpEQcHCO6PVG7mnuLh2
5X5VJzpYp7ewX5S1Xkzxpl2FaVQ5jUvWJxjkGw/xST26iwMGdZXqOzuE+vfRIWYn
ulwmE03SPq515IjekP6GMkRx+hMknj2ipvgms3OPJH3FogksejtOalgOl5CMDKIA
mP8qg9SQvIZtr91FsFqEbTKDzBF4F+jjyjUssCOdephHbtExZNwcleOGg7x5R11V
NCFmzcqa5pactjNCTBDGrb5/5KrsTEyWWmRIjW600gY4KdDV6gzn7DQySS9P5KvT
W0xhYGj15/f/UXJoj2fL/BZKegKp2eAjSwL2s/85CvhuwdWxQduoPdxZf4vP5K/c
d2/DOiUyJS0rryeK31UmqEtQzFe4MjRsExJuTXG5hPkgDCqEm5VgLFzlwbKYJ3on
d+zodG+GL1zZvLJ3rQ/hQcgQipxElQD077MUoVzDLUPaBcK21gHJp97E7tnlDMsm
5ygjYfDUWeGCnS4k6hwNhhHgixsNMuQ0CdyGeWxs5WaEX0fR7gES8jQGg/J2Wtza
SATuIX0iS7MZCCUfzwv2nZH6o6f8NQXM/Q5isOSF3sP3WH6H0jAgureuh47qZiG6
vgMJL0A3P16QLiNrgDj3cPgkFC7/J0ovHigUz2c29/aqTKhXyus=
=AMaw
-----END PGP SIGNATURE-----

--gqLjDvFIIlKGCMD8h54mAIs0D2mHi2qsx--


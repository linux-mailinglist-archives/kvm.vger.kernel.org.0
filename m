Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A57651367CE
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 08:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbgAJHDq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 02:03:46 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48309 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726486AbgAJHDp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jan 2020 02:03:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578639824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=x/pLOEXshBCB3LfpR2NX/CzEMYfdDXHV/QkccakKpqg=;
        b=b005I/2LBd5PG/yBxdM7d2CkcxiIcVmd7oI2sR3/b6UUhC6O0l7wVPF4qbDALqr0n+4TlK
        eZBXbvq2b8BgnkZt59m/1WSedyOym7et+ums1ykUjjlvXwz8xbFJXLWmwPy+Tdh84wSERU
        C36chNsvqFSDY8THKclH+OOS5EJT5ko=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-KM9qLybfMkGv2C7_pmIWkw-1; Fri, 10 Jan 2020 02:03:40 -0500
X-MC-Unique: KM9qLybfMkGv2C7_pmIWkw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90142800EBF;
        Fri, 10 Jan 2020 07:03:39 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-154.ams2.redhat.com [10.36.116.154])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E73A960E3E;
        Fri, 10 Jan 2020 07:03:35 +0000 (UTC)
Subject: Re: [PATCH v4] KVM: s390: Add new reset vcpu API
To:     Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com
References: <20200109155602.18985-1-frankja@linux.ibm.com>
 <20200109180841.6843cb92.cohuck@redhat.com>
 <f79b523e-f3e8-95b8-c242-1e7ca0083012@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f18955c0-4002-c494-b14e-1b9733aad20e@redhat.com>
Date:   Fri, 10 Jan 2020 08:03:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <f79b523e-f3e8-95b8-c242-1e7ca0083012@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Mimecast-Spam-Score: 0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FICSUBYDdHPLxRmXI7sAawtILfZWUf6gM"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FICSUBYDdHPLxRmXI7sAawtILfZWUf6gM
Content-Type: multipart/mixed; boundary="tC6QamWr6jqdvgWeuA2gRrDJunLeCCqWO";
 protected-headers="v1"
From: Thomas Huth <thuth@redhat.com>
To: Janosch Frank <frankja@linux.ibm.com>, Cornelia Huck <cohuck@redhat.com>
Cc: kvm@vger.kernel.org, borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
 david@redhat.com
Message-ID: <f18955c0-4002-c494-b14e-1b9733aad20e@redhat.com>
Subject: Re: [PATCH v4] KVM: s390: Add new reset vcpu API
References: <20200109155602.18985-1-frankja@linux.ibm.com>
 <20200109180841.6843cb92.cohuck@redhat.com>
 <f79b523e-f3e8-95b8-c242-1e7ca0083012@linux.ibm.com>
In-Reply-To: <f79b523e-f3e8-95b8-c242-1e7ca0083012@linux.ibm.com>

--tC6QamWr6jqdvgWeuA2gRrDJunLeCCqWO
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 09/01/2020 18.51, Janosch Frank wrote:
> On 1/9/20 6:08 PM, Cornelia Huck wrote:
>> On Thu,  9 Jan 2020 10:56:01 -0500
>> Janosch Frank <frankja@linux.ibm.com> wrote:
>>
>>> The architecture states that we need to reset local IRQs for all CPU
>>> resets. Because the old reset interface did not support the normal CPU
>>> reset we never did that on a normal reset.
>>>
>>> Let's implement an interface for the missing normal and clear resets
>>> and reset all local IRQs, registers and control structures as stated
>>> in the architecture.
>>>
>>> Userspace might already reset the registers via the vcpu run struct,
>>> but as we need the interface for the interrupt clearing part anyway,
>>> we implement the resets fully and don't rely on userspace to reset the
>>> rest.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
>>>
>>> I dropped the reviews, as I changed quite a lot. =20
>>>
>>> Keep in mind, that now we'll need a new parameter in normal and
>>> initial reset for protected virtualization to indicate that we need to
>>> do the reset via the UV call. The Ultravisor does only accept the
>>> needed reset, not any subset resets.
>>
>> In the interface, or externally?
>=20
> ?
>=20
>>
>> [Apologies, but the details of the protected virt stuff are no longer
>> in my cache.
> Reworded explanation:
> I can't use a fallthrough, because the UV will reject the normal reset
> if we do an initial reset (same goes for the clear reset). To address
> this issue, I added a boolean to the normal and initial reset functions
> which tells the function if it was called directly or was called because
> of the fallthrough.
>=20
> Only if called directly a UV call for the reset is done, that way we can
> keep the fallthrough.

Sounds complicated. And do we need the fallthrough stuff here at all?
What about doing something like:

static int kvm_arch_vcpu_ioctl_normal_reset(struct kvm_vcpu *vcpu)
{
=09...
}

static int kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
{
=09kvm_arch_vcpu_ioctl_normal_reset(vcpu);
=09...
}

static int kvm_arch_vcpu_ioctl_clear_reset(struct kvm_vcpu *vcpu)
{
=09kvm_arch_vcpu_ioctl_initial_reset(vcpu);
=09...
}

...

=09case KVM_S390_CLEAR_RESET:
=09=09r =3D kvm_arch_vcpu_ioctl_clear_reset(vcpu);
=09=09if (!r && protected) {
=09=09=09r =3D uv_cmd_nodata(...,
 =09=09=09=09UVC_CMD_CPU_RESET_CLEAR, ...);
=09=09}
=09=09break;
 =09case KVM_S390_INITIAL_RESET:
 =09=09r =3D kvm_arch_vcpu_ioctl_initial_reset(vcpu);
=09=09if (!r && protected) {
=09=09=09r =3D uv_cmd_nodata(...,
 =09=09=09=09UVC_CMD_CPU_RESET_INITIAL, ...);
=09=09}
=09case KVM_S390_NORMAL_RESET:
=09=09r =3D kvm_arch_vcpu_ioctl_normal_reset(vcpu);
=09=09if (!r && protected) {
=09=09=09r =3D uv_cmd_nodata(...,
 =09=09=09=09UVC_CMD_CPU_RESET, ...);
=09=09}
 =09=09break;

... or does that not work due to some other constraints that I've missed?

 Thomas


--tC6QamWr6jqdvgWeuA2gRrDJunLeCCqWO--

--FICSUBYDdHPLxRmXI7sAawtILfZWUf6gM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEJ7iIR+7gJQEY8+q5LtnXdP5wLbUFAl4YIbwACgkQLtnXdP5w
LbV+kA/+LCaxecWfbo54tO+QJjm3Uf/8bwFax7Mcgjz8am2a5SldrzoLAMbuEYpg
ZinYk4PuicToeJ1utFaAo7m8TGSlGrv72YZtluq+fC7zRq2eR+qFYqAF6Nne/J2e
9Ol1rlptnL08zCg9aegKCD3Zg29zEnTjV1Es8Hc7So/xnM8uAoxjQDpQi0AJjK+x
r6km8vp2WzgegmKinheF3g3oX/hDhxnWW4pS5M2vM40131Yoq+xTv8DPGUW0Yibq
ky77pXScVBtXSQ7txB7jh2tQSg1ArQABt/azbydtYU8jx7/1R8sxVBiPqLXoWRHB
HR18Z3246hygJYEsYBFFLfHvUEfs5PMN7hfIEM0XFkbDWr7E8Yxyf15RLMa+/HPR
evZbscP4E9vfT3edgkquxGxYKlS0FYx/tI06KZJgLSxhk3c0Xd1wpbaoT8rotjhX
Q9xJNthnMy1fBpYXhmeFZiJFix6+IvRxouT/sI7ER0kRg4Olv5MMFxKGN4d83fnv
vnm56o1tiZjV0AgIZeK9C5UnxvoCypOpIgenZjCrPOVQsT1+loFqhvZrxkdhUVNF
9a0vJo/jlhoSyUserIRVQI3XyHuA5oacB3nQxC93j9pZEl7dBPr8nvMJUUjCgxLB
1uFBpo4Q/Drxfw0uliVSp/AHUFMVGz+DqMOCFGo2N9dT4fK2ANY=
=wTwQ
-----END PGP SIGNATURE-----

--FICSUBYDdHPLxRmXI7sAawtILfZWUf6gM--


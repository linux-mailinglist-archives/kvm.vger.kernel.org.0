Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB73FCA80
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 17:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbfKNQFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 11:05:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50420 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726339AbfKNQFX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 11:05:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573747521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aXiY+5Q3GRueAPA4QusPmTLc8/jZ52BrHluWRsmeAoI=;
        b=WJyK7T3C9zKZaNz5pMPwC1LiyGg/QlgNPimJMP6o3xVXGoBmOcpdk1EhbgXiKHmeKcTzpG
        KEt+nZTt8fPnOsBoW7V0IzEacMWTG+7yQV7+EekqV0nn+FV7iWGlCFXAtmyyVsVEDto89m
        FaasDbO8lIMMwmTD+sU7ZvemaomCnjo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-VFhuh-pLMAeMA7xfg1INmg-1; Thu, 14 Nov 2019 11:05:17 -0500
X-MC-Unique: VFhuh-pLMAeMA7xfg1INmg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B65181394D2;
        Thu, 14 Nov 2019 16:05:15 +0000 (UTC)
Received: from gondolin (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3979151;
        Thu, 14 Nov 2019 16:05:11 +0000 (UTC)
Date:   Thu, 14 Nov 2019 17:05:08 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [RFC 21/37] KVM: S390: protvirt: Instruction emulation
Message-ID: <20191114170508.30505d03.cohuck@redhat.com>
In-Reply-To: <d25f2feb-2c40-efae-9970-e08c871de94e@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
        <20191024114059.102802-22-frankja@linux.ibm.com>
        <20191114163819.4fb4bed1.cohuck@redhat.com>
        <d25f2feb-2c40-efae-9970-e08c871de94e@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Mimecast-Spam-Score: 0
Content-Type: multipart/signed; boundary="Sig_/qZi+byzhs1J7Dtjyb+ByhKX";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/qZi+byzhs1J7Dtjyb+ByhKX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Nov 2019 17:00:41 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 11/14/19 4:38 PM, Cornelia Huck wrote:
> > On Thu, 24 Oct 2019 07:40:43 -0400
> > Janosch Frank <frankja@linux.ibm.com> wrote:
> >  =20
> >> We have two new SIE exit codes 104 for a secure instruction
> >> interception, on which the SIE needs hypervisor action to complete the
> >> instruction.
> >>
> >> And 108 which is merely a notification and provides data for tracking
> >> and management, like for the lowcore we set notification bits for the
> >> lowcore pages. =20
> >=20
> > What about the following:
> >=20
> > "With protected virtualization, we have two new SIE exit codes:
> >=20
> > - 104 indicates a secure instruction interception; the hypervisor needs
> >   to complete emulation of the instruction.
> > - 108 is merely a notification providing data for tracking and
> >   management in the hypervisor; for example, we set notification bits
> >   for the lowcore pages."
> >=20
> > ?
> >  =20
> >>
> >> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> >> ---
> >>  arch/s390/include/asm/kvm_host.h |  2 ++
> >>  arch/s390/kvm/intercept.c        | 23 +++++++++++++++++++++++
> >>  2 files changed, 25 insertions(+)
> >>
> >> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/=
kvm_host.h
> >> index 2a8a1e21e1c3..a42dfe98128b 100644
> >> --- a/arch/s390/include/asm/kvm_host.h
> >> +++ b/arch/s390/include/asm/kvm_host.h
> >> @@ -212,6 +212,8 @@ struct kvm_s390_sie_block {
> >>  #define ICPT_KSS=090x5c
> >>  #define ICPT_PV_MCHKR=090x60
> >>  #define ICPT_PV_INT_EN=090x64
> >> +#define ICPT_PV_INSTR=090x68
> >> +#define ICPT_PV_NOT=090x6c =20
> >=20
> > Maybe ICPT_PV_NOTIF? =20
>=20
> NOTF?

Sounds good.

>=20
> >  =20
> >>  =09__u8=09icptcode;=09=09/* 0x0050 */
> >>  =09__u8=09icptstatus;=09=09/* 0x0051 */
> >>  =09__u16=09ihcpu;=09=09=09/* 0x0052 */
> >> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> >> index b013a9c88d43..a1df8a43c88b 100644
> >> --- a/arch/s390/kvm/intercept.c
> >> +++ b/arch/s390/kvm/intercept.c
> >> @@ -451,6 +451,23 @@ static int handle_operexc(struct kvm_vcpu *vcpu)
> >>  =09return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
> >>  }
> >> =20
> >> +static int handle_pv_spx(struct kvm_vcpu *vcpu)
> >> +{
> >> +=09u32 pref =3D *(u32 *)vcpu->arch.sie_block->sidad;
> >> +
> >> +=09kvm_s390_set_prefix(vcpu, pref);
> >> +=09trace_kvm_s390_handle_prefix(vcpu, 1, pref);
> >> +=09return 0;
> >> +}
> >> +
> >> +static int handle_pv_not(struct kvm_vcpu *vcpu)
> >> +{
> >> +=09if (vcpu->arch.sie_block->ipa =3D=3D 0xb210)
> >> +=09=09return handle_pv_spx(vcpu);
> >> +
> >> +=09return handle_instruction(vcpu); =20
> >=20
> > Hm... if I understood it correctly, we are getting this one because the
> > SIE informs us about things that it handled itself (but which we
> > should be aware of). What can handle_instruction() do in this case? =20
>=20
> There used to be an instruction which I could just pipe through normal
> instruction handling. But I can't really remember what it was, too many
> firmware changes in that area since then.
>=20
> I'll mark it as a TODO for thinking about it with some coffee.

ok :)

>=20
> >  =20
> >> +}
> >> +
> >>  int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
> >>  {
> >>  =09int rc, per_rc =3D 0;
> >> @@ -505,6 +522,12 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcp=
u)
> >>  =09=09 */
> >>  =09=09rc =3D 0;
> >>  =09break;
> >> +=09case ICPT_PV_INSTR:
> >> +=09=09rc =3D handle_instruction(vcpu);
> >> +=09=09break;
> >> +=09case ICPT_PV_NOT:
> >> +=09=09rc =3D handle_pv_not(vcpu);
> >> +=09=09break;
> >>  =09default:
> >>  =09=09return -EOPNOTSUPP;
> >>  =09} =20
> >  =20
>=20
>=20


--Sig_/qZi+byzhs1J7Dtjyb+ByhKX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEw9DWbcNiT/aowBjO3s9rk8bwL68FAl3NezQACgkQ3s9rk8bw
L69mERAAm/7hnI2lctgvw1eUOmp6Msv+G0uJQGwpTchaSgEDAbBrJ889RRd25qeE
oBtA72cy24meDLqpjNFOk+hTAObOTcB67kgXvuPcL+89NlHvOLSVmRwQSxsR+SGI
If+WAzAjUb3i6iw+3TN+E2C7UAHsNitA6P7enIf5YfdhwDbBnGj9llP8jnOSqSRM
eQhF9LAtJb2lTjvKY3vrDousrrqR6ScH8kgziCIyihZGyg8CDBil+c0jK18xVsqu
sdweiIcro+Rh7iagfahGnHTxKbmvF3XwbG/nWAxo4BrWl/V/fFALhoV/TINEHiGy
PDwk3GNbBPlHPFlPxhe8WqPK7ZypMkDKcxxqw78zOURBhEteq5fkY3haiZDji+p8
i7h36pEU/WblKDi+geg52XIuSJqKvNSuIVNkwP4fwj3yfeahg2EfHjBd9NypDxBd
duHsqdbSNG+Baewsdo/ehf5g/qDYuW2Br0iMGQX8v751hZpbaT8wrgqHaGnKgQw1
XO7ziO1nN9zK8OdjC/jGgAq+ciPKrVZDN61FceVUdwztBEbay/jnmTaY53djpg2t
bqardW2Pozk+ArODqR+AQ0SuJIKP1vQy4PO6y9FpQe55lCt7Od5VHgRCWMXVeTTL
qI/qqK7d/K/m8tpGwnCETLgUZpu4orkKNbJzs7NTmjxlEzkTLJU=
=esXy
-----END PGP SIGNATURE-----

--Sig_/qZi+byzhs1J7Dtjyb+ByhKX--


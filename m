Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1F66777AA8
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 16:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235725AbjHJOZV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 10:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231955AbjHJOZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 10:25:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D109AED
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 07:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691677467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EGOPK6ESp6BA2jZeEYrFpzQG3cNbtY0GBXHT9EG8kSQ=;
        b=LcXxM1o9w9iKsajOJzvxxeBaLLm937/t6GD/m+Ho74RwHpGnvSsz3GiV6t4NdRFkd1JeKk
        JtBwt+6jjapwNawviekLfIfTZiGYoaLfD6l0cApOqCD3suIF8itVl1mc/nOaIR2vJFKOuM
        V54Mi8kpgJWOHVWctEonOqc37UDA51o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-198-Mdk96T5RNxGim5e_Far3KA-1; Thu, 10 Aug 2023 10:24:23 -0400
X-MC-Unique: Mdk96T5RNxGim5e_Far3KA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0191A85C70F;
        Thu, 10 Aug 2023 14:24:23 +0000 (UTC)
Received: from localhost (unknown [10.39.194.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D044401E63;
        Thu, 10 Aug 2023 14:24:22 +0000 (UTC)
Date:   Thu, 10 Aug 2023 10:24:20 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 2/4] vfio: use __aligned_u64 in struct
 vfio_device_gfx_plane_info
Message-ID: <20230810142420.GC2931656@fedora>
References: <20230809210248.2898981-1-stefanha@redhat.com>
 <20230809210248.2898981-3-stefanha@redhat.com>
 <BN9PR11MB5276BC132EAE86D470B886528C13A@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="O6bfz7OyLmHoLzjF"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276BC132EAE86D470B886528C13A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--O6bfz7OyLmHoLzjF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 10, 2023 at 03:22:56AM +0000, Tian, Kevin wrote:
> > From: Stefan Hajnoczi <stefanha@redhat.com>
> > Sent: Thursday, August 10, 2023 5:03 AM
> >=20
> > The memory layout of struct vfio_device_gfx_plane_info is
> > architecture-dependent due to a u64 field and a struct size that is not
> > a multiple of 8 bytes:
> > - On x86_64 the struct size is padded to a multiple of 8 bytes.
> > - On x32 the struct size is only a multiple of 4 bytes, not 8.
> > - Other architectures may vary.
> >=20
> > Use __aligned_u64 to make memory layout consistent. This reduces the
> > chance of holes that result in an information leak and the chance that
>=20
> I didn't quite get this. The leak example [1] from your earlier fix is re=
ally
> not caused by the use of __u64. Instead it's a counter example that on
> x32 there is no hole with 4byte alignment for __u64.
>=20
> I'd remove the hole part and just keep the compat reason.
>=20
> [1] https://lore.kernel.org/lkml/20230801103114.757d7992.alex.williamson@=
redhat.com/T/

Okay.

>=20
> > @@ -1392,6 +1392,8 @@ static long intel_vgpu_ioctl(struct vfio_device
> > *vfio_dev, unsigned int cmd,
> >  		if (dmabuf.argsz < minsz)
> >  			return -EINVAL;
> >=20
> > +		minsz =3D min(minsz, sizeof(dmabuf));
> > +
>=20
> Is there a case where minsz could be greater than sizeof(dmabuf)?

Thanks for spotting this, it's a bug in the patch. It should be
min(dmabuf.argsz, sizeof(dmabuf)).

Stefan

--O6bfz7OyLmHoLzjF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmTU8xQACgkQnKSrs4Gr
c8jKDgf/RLZgbtwtI72CjE2KiK0+kuRGCyKg6g5IlhEVfIhGpdr+MMHc4q2uUi6b
2pXvDCegcThH0hDv66q2HW9pGdv6CKSTuUuCv0TpKqocxTMImMTWPxBIsN7oslpJ
oOxe3PPzC2jtFQyZkwmsP2yjekvq0e6tPOmaYJMFflBnR1o3SncsLP/Z3TyInMQr
Sron45lvEXLQAH/xHjguvNzACgVLZiJB0/weTWJqi03KEqFw2/YSxX85M1yRLYhp
e/Lfk7FSBAYoNKUXm6pJM/ULEKTbxkH4zb1JwejCkzJ4PPYXsl/MLZZhXnNFPvJ0
/oDPG/KSh9YMo6iS2wQ2Fl8yN50BBQ==
=ESeR
-----END PGP SIGNATURE-----

--O6bfz7OyLmHoLzjF--


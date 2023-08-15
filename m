Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAAE177CCCB
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 14:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237042AbjHOMjl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 08:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236386AbjHOMjL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 08:39:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E0EEE
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 05:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692103104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JYkbsaABdBCwv9nGDYicmFoPIkWDMg14bxPdOSnBUyY=;
        b=XuFAUDhYZ185a7/kMo0ak6MHrjEsctzMJy4uydd4PHdjke30WZaz9WkvB2JY2BeILnlhaU
        dJgBzmRPC1zQZbPW5FAqqfmYGXq5o6DRWqFDxQd+ECUn/E6yEdL64uCO1XZoPifRSZL5rN
        sRS3RSH+TZASZ9T/UQQq6zwJRJtgGpo=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-451-X7c356uDNUCJa_QRFw_9Cg-1; Tue, 15 Aug 2023 08:38:20 -0400
X-MC-Unique: X7c356uDNUCJa_QRFw_9Cg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 32BE53815EE6;
        Tue, 15 Aug 2023 12:38:20 +0000 (UTC)
Received: from localhost (unknown [10.39.193.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D36BC15BAD;
        Tue, 15 Aug 2023 12:38:19 +0000 (UTC)
Date:   Tue, 15 Aug 2023 08:38:17 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     kvm@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>,
        linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 2/4] vfio: use __aligned_u64 in struct
 vfio_device_gfx_plane_info
Message-ID: <20230815123817.GC3235352@fedora>
References: <20230809210248.2898981-1-stefanha@redhat.com>
 <20230809210248.2898981-3-stefanha@redhat.com>
 <ZNppcBX3FD2GdcKc@ziepe.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="QHRILvZdfk9NQdJu"
Content-Disposition: inline
In-Reply-To: <ZNppcBX3FD2GdcKc@ziepe.ca>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--QHRILvZdfk9NQdJu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 14, 2023 at 02:50:40PM -0300, Jason Gunthorpe wrote:
> On Wed, Aug 09, 2023 at 05:02:46PM -0400, Stefan Hajnoczi wrote:
> > diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gv=
t/kvmgt.c
> > index de675d799c7d..ffab3536dc8a 100644
> > --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> > +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > @@ -1382,7 +1382,7 @@ static long intel_vgpu_ioctl(struct vfio_device *=
vfio_dev, unsigned int cmd,
> >  		intel_gvt_reset_vgpu(vgpu);
> >  		return 0;
> >  	} else if (cmd =3D=3D VFIO_DEVICE_QUERY_GFX_PLANE) {
> > -		struct vfio_device_gfx_plane_info dmabuf;
> > +		struct vfio_device_gfx_plane_info dmabuf =3D {};
> >  		int ret =3D 0;
> > =20
> >  		minsz =3D offsetofend(struct vfio_device_gfx_plane_info,
> > @@ -1392,6 +1392,8 @@ static long intel_vgpu_ioctl(struct vfio_device *=
vfio_dev, unsigned int cmd,
> >  		if (dmabuf.argsz < minsz)
> >  			return -EINVAL;
> > =20
> > +		minsz =3D min(minsz, sizeof(dmabuf));
> > +
>=20
> Huh?
>=20
>  minsz =3D min(sizeof(dmabuf), dmabuf.argsz)

Thanks for catching this. I will fix it in the next revision.

Stefan

--QHRILvZdfk9NQdJu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmTbcbkACgkQnKSrs4Gr
c8jqIQf/aSdSFXODVeXP2A+kSWsR0Eoj7p2DH+cYJeg7EEOVjPws1r7a3Y/zKZVj
6Kh+IFZS5q58s2ZA9hzeTf6n9smimrC61qbNGqr8XC8bg6ny2N2Y5753yQErYTrs
kE+pv5VBtVYkMRr2q0VN85YKSfIK1AMg39hOMfwHb+qD3u/zvs0DwH1TaKH5gR9e
960hQXT6vcnqkUuD7IKTOti3cC5J6Y08xxfkuej96+NhrmuOU3Up1OFgccUdKJMH
tJ4cqNlZWmh/R7YoSeugkf7kCVwaEm+Wv/esJ3M+oTgCZcTd7bJzRQKU1FqUaOcA
hxK2TJo3Cm0J2IWnLUm1cFiJJFseLQ==
=MFIr
-----END PGP SIGNATURE-----

--QHRILvZdfk9NQdJu--


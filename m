Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 489E0776A10
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 22:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbjHIUdC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 16:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjHIUc5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 16:32:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8821702
        for <kvm@vger.kernel.org>; Wed,  9 Aug 2023 13:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691613130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bqFcX9n0/AXL5Snz2n5C8CYOWe+BpAWNtYa9e5JE8Gw=;
        b=J7KD5U+ygGPMunlnqFfNUUvLhWxdVTEvKuNKFofSI0PMhM6qhMhEgBXivpmxShoFTdHKbA
        TTPi2gAHJF1xYC7+cJC6D9bShAIowi3CLEAr5Lk/Oluf44gALwl0EEzIw00cPM/918hUgk
        pkeviN2yKqbtkqlm4e2eySRD1xJiCQE=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-685-EyRVbDjEMWOzvL_gLHDfPQ-1; Wed, 09 Aug 2023 16:32:06 -0400
X-MC-Unique: EyRVbDjEMWOzvL_gLHDfPQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 830253C0DDB9;
        Wed,  9 Aug 2023 20:32:06 +0000 (UTC)
Received: from localhost (unknown [10.39.192.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 450CC140E96D;
        Wed,  9 Aug 2023 20:32:04 +0000 (UTC)
Date:   Wed, 9 Aug 2023 16:24:58 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: align capability structures
Message-ID: <20230809202458.GB2852727@fedora>
References: <20230803144109.2331944-1-stefanha@redhat.com>
 <20230803151823.4e5943e6.alex.williamson@redhat.com>
 <ZNLP1dU1Ijzm/NPE@ziepe.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ewDSavC46Cyk/Sng"
Content-Disposition: inline
In-Reply-To: <ZNLP1dU1Ijzm/NPE@ziepe.ca>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--ewDSavC46Cyk/Sng
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 08, 2023 at 08:29:25PM -0300, Jason Gunthorpe wrote:
> On Thu, Aug 03, 2023 at 03:18:23PM -0600, Alex Williamson wrote:
>=20
> > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > index 902f06e52c48..2d074cbd371d 100644
> > --- a/drivers/vfio/vfio_main.c
> > +++ b/drivers/vfio/vfio_main.c
> > @@ -1362,6 +1362,8 @@ struct vfio_info_cap_header *vfio_info_cap_add(st=
ruct vfio_info_cap *caps,
> >  	void *buf;
> >  	struct vfio_info_cap_header *header, *tmp;
> > =20
> > +	size =3D ALIGN(size, sizeof(u64));
> > +
> >  	buf =3D krealloc(caps->buf, caps->size + size, GFP_KERNEL);
> >  	if (!buf) {
> >  		kfree(caps->buf);
> > @@ -1395,6 +1397,8 @@ void vfio_info_cap_shift(struct vfio_info_cap *ca=
ps, size_t offset)
> >  	struct vfio_info_cap_header *tmp;
> >  	void *buf =3D (void *)caps->buf;
> > =20
> > +	WARN_ON(!IS_ALIGNED(offset, sizeof(u64)));
> > +
> >  	for (tmp =3D buf; tmp->next; tmp =3D buf + tmp->next - offset)
> >  		tmp->next +=3D offset;
> >  }
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index fa06e3eb4955..fd2761841ffe 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -217,6 +217,7 @@ struct vfio_device_info {
> >  	__u32	num_regions;	/* Max region index + 1 */
> >  	__u32	num_irqs;	/* Max IRQ index + 1 */
> >  	__u32   cap_offset;	/* Offset within info struct of first cap */
> > +	__u32	pad;		/* Size must be aligned for caps */
> >  };
> >  #define VFIO_DEVICE_GET_INFO		_IO(VFIO_TYPE, VFIO_BASE + 7)
> > =20
> > @@ -1444,6 +1445,7 @@ struct vfio_iommu_type1_info {
> >  #define VFIO_IOMMU_INFO_CAPS	(1 << 1)	/* Info supports caps */
> >  	__u64	iova_pgsizes;	/* Bitmap of supported page sizes */
> >  	__u32   cap_offset;	/* Offset within info struct of first cap */
> > +	__u32	pad;		/* Size must be aligned for caps */
> >  };
>=20
> IMHO this is partially being caused by not using __aligned_u64 for the
> other __u64's in the same struct..
>=20
> Both of these structs have u64s in them and many arches will
> automatically add the above padding. __aligned_u64 will force the
> reset to do it, and then making padding explicit as you have done will
> make it really true.
>=20
> This is a subtle x64/x32 compatability issue also. It is probably best
> just to do the change across the whole header file.

I will send a separate series that switches the struct definitions to
__aligned_u64.

> Please also include the matching hunk for iommufd:
>=20
> --- a/drivers/iommu/iommufd/vfio_compat.c
> +++ b/drivers/iommu/iommufd/vfio_compat.c
> @@ -483,6 +483,8 @@ static int iommufd_vfio_iommu_get_info(struct iommufd=
_ctx *ictx,
>                         rc =3D cap_size;
>                         goto out_put;
>                 }
> +               cap_size =3D ALIGN(cap_size, sizeof(u64));
> +
>                 if (last_cap && info.argsz >=3D total_cap_size &&
>                     put_user(total_cap_size, &last_cap->next)) {
>                         rc =3D -EFAULT;

Okay, will fix.

Stefan

--ewDSavC46Cyk/Sng
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmTT9hoACgkQnKSrs4Gr
c8hfNQf9Ep+MFw6fuOjO2uXkkTRrzYDdXnDkRsjFw02p9qwpa2HNoo3GsvFouF7R
UdgnX9fZxBjgYmTz6yQjCpg2aqhZTQzJeFqoeyaNzyoY8xgehsr6sD+AlY3EMiyw
zJcF0X9FA/EklB6zGbMNtvyqxszIL2fEQEQFXioXnkut+L4H3M6guNuLPxjE/PIL
O8uAmaZHRpw3DOA2MPUU+LY0lxn1+hPCoY/pz5ksNbkPCltLySbb/64JTwYZc2EA
AxD424qBvka0nEgC7fxmPitWE32K78jRCM/gmWdvA3viq2YmReWaAQJSx9Bkttl+
ZUXxYyjQw0UDv/1OkRm0wY7JdKpBmA==
=5aKp
-----END PGP SIGNATURE-----

--ewDSavC46Cyk/Sng--


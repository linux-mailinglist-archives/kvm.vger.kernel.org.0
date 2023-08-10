Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D98D7777ACD
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 16:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235760AbjHJOds (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 10:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjHJOdr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 10:33:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B166430F9
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 07:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691677542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nOJZhUQnOs3d56Ww7WWE5sFKVnOac/cwwQNGpd1gdhU=;
        b=OpFw7a0+/3Ru2fCu4NwYC6B2TeoaTtg81iqYJ2VZSY0pXFH955RKPEtQjHGyIr8cZuNMgy
        eJxUk7f9SFrHJkaKWUl0dTeBKvHvado3yMlpmV/KpaVBZ+igxiHmjNhkHr9dwxI65+d1fy
        Wdkuc+YxQVdYmk2ibxFMmA5VUndJvoA=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-wisTvYhvNCyOxdjY5DTAZw-1; Thu, 10 Aug 2023 10:25:38 -0400
X-MC-Unique: wisTvYhvNCyOxdjY5DTAZw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30BDD382C97A;
        Thu, 10 Aug 2023 14:25:38 +0000 (UTC)
Received: from localhost (unknown [10.39.194.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A161C15BAE;
        Thu, 10 Aug 2023 14:25:37 +0000 (UTC)
Date:   Thu, 10 Aug 2023 10:25:35 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 3/4] vfio: use __aligned_u64 in struct
 vfio_iommu_type1_info
Message-ID: <20230810142535.GD2931656@fedora>
References: <20230809210248.2898981-1-stefanha@redhat.com>
 <20230809210248.2898981-4-stefanha@redhat.com>
 <BN9PR11MB5276D1304E854E2AE7E8EFA18C13A@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uYWLEaQvqBpXEN2x"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276D1304E854E2AE7E8EFA18C13A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--uYWLEaQvqBpXEN2x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 10, 2023 at 03:25:37AM +0000, Tian, Kevin wrote:
> > From: Stefan Hajnoczi <stefanha@redhat.com>
> > Sent: Thursday, August 10, 2023 5:03 AM
> >
> > @@ -1303,8 +1303,9 @@ struct vfio_iommu_type1_info {
> >  	__u32	flags;
> >  #define VFIO_IOMMU_INFO_PGSIZES (1 << 0)	/* supported page sizes info
> > */
> >  #define VFIO_IOMMU_INFO_CAPS	(1 << 1)	/* Info supports caps */
> > -	__u64	iova_pgsizes;	/* Bitmap of supported page sizes */
> > +	__aligned_u64	iova_pgsizes;		/* Bitmap of supported page
> > sizes */
> >  	__u32   cap_offset;	/* Offset within info struct of first cap */
> > +	__u32   reserved;
>=20
> isn't this conflicting with the new 'pad' field introduced in your another
> patch " [PATCH v3] vfio: align capability structures"?
>=20
> @@ -1304,6 +1305,7 @@ struct vfio_iommu_type1_info {
>  #define VFIO_IOMMU_INFO_CAPS	(1 << 1)	/* Info supports caps */
>  	__u64	iova_pgsizes;	/* Bitmap of supported page sizes */
>  	__u32   cap_offset;	/* Offset within info struct of first cap */
> +	__u32   pad;
>  };

Yes, I will rebase this series when "[PATCH v3] vfio: align capability
structures" is merged. I see the __aligned_u64 as a separate issue and
don't want to combine the patch series.

Stefan

--uYWLEaQvqBpXEN2x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmTU818ACgkQnKSrs4Gr
c8iySQf9FZbRiPNfdlBpBsLYscA+oOj9TOnEyxAcMVkvwRME3HsWH8AD5Esrn038
lG5gDBfNWcMl0Uxjzo01BYTKMhOIt0ywbGMmP1AZSJERt3N+MTUnveWsx7pxbr67
VQFlJJyV6JcqSAX7VaRyx4JWJcM1itdWDomC7AG/K8DvE2wupsGZ75tN6eBLQPOW
PS/5VLF14dHWcWRTDuTtsjiZC5uAxONA8nCir4Cm/u2oXcfVl4KGyoGNAK5HUHCg
ZCbiz1+Gf1Q+mDOtt/ZLqMtaD0CmzqzI6Y6EzWhy/W/N6fAAsuni18MU26t5X8Oo
jXsZ6lkXG/eOpZa0r1LswaPNLAzgwQ==
=dfMD
-----END PGP SIGNATURE-----

--uYWLEaQvqBpXEN2x--


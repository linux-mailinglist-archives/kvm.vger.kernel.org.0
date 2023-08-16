Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6F677E2BA
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 15:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245589AbjHPNhy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 09:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245676AbjHPNho (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 09:37:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E1726A9
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 06:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692193016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Dx+js2X4fkPT4YvlU5JKstwIzUXxPY2qnoEgh+8ke+Q=;
        b=XNLRdfHz3DfXLMiYwZblBcdsDULe20iIDQLKnOX0EWfluk1uu3+b/ztyM2Jz4yLBFBoloA
        GRVmPB70Jz1eGe4DgFvy0s/33yksTm8p8PAWewSzj/GYQjcs5ZnJ5NWlh00gUofuFcl05G
        Uq12GwxdnGT/f7i05M6M/dMoMk/tQi0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-76-czA8zGnuPj2VbZyTc6YT5Q-1; Wed, 16 Aug 2023 09:36:52 -0400
X-MC-Unique: czA8zGnuPj2VbZyTc6YT5Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FADF8DC672;
        Wed, 16 Aug 2023 13:36:52 +0000 (UTC)
Received: from localhost (unknown [10.39.193.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A43F4492C18;
        Wed, 16 Aug 2023 13:36:51 +0000 (UTC)
Date:   Wed, 16 Aug 2023 09:36:50 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 2/4] vfio: use __aligned_u64 in struct
 vfio_device_gfx_plane_info
Message-ID: <20230816133650.GC3425284@fedora>
References: <20230809210248.2898981-1-stefanha@redhat.com>
 <20230809210248.2898981-3-stefanha@redhat.com>
 <aff0d24d4bce4d34b27cfe6a76b0634e@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IA0szQIho2MN2VEN"
Content-Disposition: inline
In-Reply-To: <aff0d24d4bce4d34b27cfe6a76b0634e@AcuMS.aculab.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--IA0szQIho2MN2VEN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 15, 2023 at 03:23:50PM +0000, David Laight wrote:
> From: Stefan Hajnoczi
> > Sent: 09 August 2023 22:03
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
> > 32-bit userspace on a 64-bit kernel breakage.
>=20
> Isn't the hole likely to cause an information leak?
> Forcing it to be there doesn't make any difference.
> I'd add an explicit pad as well.

Yes, Kevin had a similar comment about this text. What I meant was that
it's safest to have a single memory layout across all architectures
(with explicit padding) so that there are no surprises. I'm going to
remove the statement about information leaks because it's confusing.

>=20
> It is a shame there isn't an __attribute__(()) to error padded structures.
>=20
> >=20
> > This patch increases the struct size on x32 but this is safe because of
> > the struct's argsz field. The kernel may grow the struct as long as it
> > still supports smaller argsz values from userspace (e.g. applications
> > compiled against older kernel headers).
>=20
> Doesn't changing the offset of later fields break compatibility?
> The size field (probably) only lets you extend the structure.

Yes, that would break compatibility but I don't see any changes in this
patch series that modifies the offsets of later fields. Have I missed
something?

> Oh, for sanity do min(variable, constant).

Can you elaborate?

Thanks,
Stefan

--IA0szQIho2MN2VEN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmTc0PIACgkQnKSrs4Gr
c8jAuQf/Upyntfw/M5KfXri893SxdBLJ23KNlmWpQG93GFyLqc4NWElriTGYe98j
swYOSqt679605BgSc7OR7TttgzLM6s9rDgXo+g5WzF2LzwIFcSjkvySKhjRmaH6a
onatY7KI1vKw59JhuHLU5aCIoG3+SlsfA9gNNGD8Zyo+BtoQqeWUIsKcEsJvQx04
hkiriJOzvjHlWoo6B1w/98HZhaNEwkUOIdskVu5z2PuejMd5wCxR3ho81GIKznds
1JzRXA7dkfAuZ/T4WUP3+XmIllwzMw6YFkafvAwaaHS69myNtk28UDbEcPTUEcw0
QZcCXTOjunwBQzp4Td0LVjEVbz4V1g==
=cIK8
-----END PGP SIGNATURE-----

--IA0szQIho2MN2VEN--


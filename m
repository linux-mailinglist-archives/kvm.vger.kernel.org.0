Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A2A6D6E7F
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 23:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236390AbjDDU7y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 16:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236396AbjDDU7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 16:59:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A130469E
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 13:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680641942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IpeHYjjM+cHO003wVJZp6AvXauDnch621sJXiCnomWI=;
        b=F3p3EysBR7PlTmSmMyFlNh/SYxoG4ef71Y4w/bPcwUHiNoP62EjIHCeCSDVwwcUSEl7DRI
        9Axtfk0otDGvnp0LUyi6ws9zp64XXvZeNO9viUJyEQMDpgGNvjszCIVTvlDDzUfM4TWCxE
        kfYg4i3koyscwBvmoP4nlpkkIMafwbM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-251-YFDuTrO6PfOhNsjJLb5qeQ-1; Tue, 04 Apr 2023 16:58:58 -0400
X-MC-Unique: YFDuTrO6PfOhNsjJLb5qeQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7AF61C07588;
        Tue,  4 Apr 2023 20:58:57 +0000 (UTC)
Received: from localhost (unknown [10.39.194.166])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C558C1121314;
        Tue,  4 Apr 2023 20:58:56 +0000 (UTC)
Date:   Tue, 4 Apr 2023 16:58:55 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Sam Li <faithilikerun@gmail.com>
Cc:     Stefan Hajnoczi <stefanha@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, dmitry.fomichev@wdc.com,
        kvm@vger.kernel.org, damien.lemoal@opensource.wdc.com,
        hare@suse.de, Kevin Wolf <kwolf@redhat.com>, qemu-block@nongnu.org
Subject: Re: [PATCH v9 0/5] Add zoned storage emulation to virtio-blk driver
Message-ID: <20230404205855.GA603232@fedora>
References: <20230327144553.4315-1-faithilikerun@gmail.com>
 <20230329005755-mutt-send-email-mst@kernel.org>
 <CAJSP0QW1FFYYMbwSdG94SvotMe_ER_4Dxe5e+2FAcQMWaJ3ucA@mail.gmail.com>
 <CAAAx-8J72fiVpOqeK71t8uNiyJLR2DowzGouk_H3oFRF_czc+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fW0CvyF0IbPpbDQ9"
Content-Disposition: inline
In-Reply-To: <CAAAx-8J72fiVpOqeK71t8uNiyJLR2DowzGouk_H3oFRF_czc+w@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--fW0CvyF0IbPpbDQ9
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 04, 2023 at 11:46:13PM +0800, Sam Li wrote:
> Stefan Hajnoczi <stefanha@gmail.com> =E4=BA=8E2023=E5=B9=B44=E6=9C=883=E6=
=97=A5=E5=91=A8=E4=B8=80 20:18=E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Wed, 29 Mar 2023 at 01:01, Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Mon, Mar 27, 2023 at 10:45:48PM +0800, Sam Li wrote:
> > >
> > > virtio bits look ok.
> > >
> > > Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
> > >
> > > merge through block layer tree I'm guessing?
> >
> > Sounds good. Thank you!
>=20
> Hi Stefan,
>=20
> I've sent the v8 zone append write to the list where I move the wps
> field to BlockDriverState. It will make a small change the emulation
> code, which is in hw/block/virtio-blk.c of [2/5] virtio-blk: add zoned
> storage emulation for zoned devices:
> - if (BDRV_ZT_IS_CONV(bs->bl.wps->wp[index])) {
> + if (BDRV_ZT_IS_CONV(bs->wps->wp[index])) {
>=20
> Please let me know if you prefer a new version or not.

Yes, please.

Stefan

--fW0CvyF0IbPpbDQ9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmQsj48ACgkQnKSrs4Gr
c8jf9wf/ZbIleajKT16bSiErnJiYuXtdB0QGGK9VqtTV8YwbrhGb8i4w99+OVq9/
x/sBOA7MF+l06Oj6D6eB2PbQ69yEIVqJThvLVPutz02pyWQkxcOBYPRyLX/CxF7C
3cki8X3r3+0tE9ZiZWoMS4M4W2x4R22gKa1NLRCUIfRiBuiCDr3ZaBLJcemvha1F
AKbQOA9uG6triqtaqc9iPAsTSr3WePY+HtZye6bSlnPz4CxM92l9in2V1hfK6WrP
iCjYAcr/Nlyd4gjrsO1NQhY1i8n+WYMrMHV9NI2Sz3FH76nP++yKNxDq+phBISeA
QM+0otZRbS1TRquem20HtqmyyQl7MA==
=FD9+
-----END PGP SIGNATURE-----

--fW0CvyF0IbPpbDQ9--


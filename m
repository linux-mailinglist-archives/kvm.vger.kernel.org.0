Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4156BD97C
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 20:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjCPTrk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 15:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjCPTri (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 15:47:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1355296F01
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 12:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678996016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bdTdOJ6+s2GcSWJg3glgRqHLDbFvhpyQGCderohXZ7Y=;
        b=XjI1oi58qQie7zaWm2zkqjkSdMjU8YyOl3zl5K6oIBUZ9KNj+xZtoQgwxoJR2ERmYLSNdh
        gG8t67vXDdXmPRoycRRQe9NK0vbKIitS3fXR6E0Kkhsrd7XvHWXEtooupX7dWdj+hyNyEO
        Ru875XXLX/sgF8MzLuF2EPfrwYCncfA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-sl2LBpVNMXS-1l3sltPdWw-1; Thu, 16 Mar 2023 15:46:52 -0400
X-MC-Unique: sl2LBpVNMXS-1l3sltPdWw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2179C884EC3;
        Thu, 16 Mar 2023 19:46:52 +0000 (UTC)
Received: from localhost (unknown [10.39.192.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 92E5D2166B26;
        Thu, 16 Mar 2023 19:46:51 +0000 (UTC)
Date:   Thu, 16 Mar 2023 15:24:23 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Sam Li <faithilikerun@gmail.com>
Cc:     qemu-devel@nongnu.org, damien.lemoal@opensource.wdc.com,
        Hanna Reitz <hreitz@redhat.com>, hare@suse.de,
        qemu-block@nongnu.org, Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, dmitry.fomichev@wdc.com,
        Cornelia Huck <cohuck@redhat.com>,
        Markus Armbruster <armbru@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>
Subject: Re: [PATCH v7 0/4] Add zoned storage emulation to virtio-blk driver
Message-ID: <20230316192423.GG63600@fedora>
References: <20230310105431.64271-1-faithilikerun@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="g/veVqzWPfdd0/XF"
Content-Disposition: inline
In-Reply-To: <20230310105431.64271-1-faithilikerun@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--g/veVqzWPfdd0/XF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 10, 2023 at 06:54:27PM +0800, Sam Li wrote:
> This patch adds zoned storage emulation to the virtio-blk driver.
>=20
> The patch implements the virtio-blk ZBD support standardization that is
> recently accepted by virtio-spec. The link to related commit is at
>=20
> https://github.com/oasis-tcs/virtio-spec/commit/b4e8efa0fa6c8d844328090ad=
15db65af8d7d981
>=20
> The Linux zoned device code that implemented by Dmitry Fomichev has been
> released at the latest Linux version v6.3-rc1.
>=20
> Aside: adding zoned=3Don alike options to virtio-blk device will be
> considered as following-ups in future.
>=20
> v6:
> - update headers to v6.3-rc1

Hi Sam,
I had some minor comments but overall this looks good. Looking forward
to merging it soon!

Thanks,
Stefan

--g/veVqzWPfdd0/XF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmQTbOcACgkQnKSrs4Gr
c8iN3gf/cTsBjYPDxFs2/VXzgYz1TXBEUx7BWJNxiaoZHbU04tw6KYTM2O6qNPql
kZF3eyAsin3lrIx7JpcPzyKOPycw2G+5aCdGcpGz5dtGPI4ux5j7dB2dixF++XDL
y85GkodKuGraq6Iv1aEkUZk+ibF19/V/OI/YKcBnydhSYwOo8lW1qDsUA8hdSr6V
cDG+gPS6wxyrgLZQW1/bBKzr0Kwq+VFvDFEmT/qvgKQwmjiG+sv71Xz2NX2nqNJj
SMgXCIHAZZo4HAwxBQf/lj30GiqodJHdXt82m8uCeKzG/+zKzH2fS/LorsQtS4do
xtYAPuhVMZFPVxb8TkI4Z6kLrDZARw==
=K3sE
-----END PGP SIGNATURE-----

--g/veVqzWPfdd0/XF--


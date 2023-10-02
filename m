Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3BB27B5A8E
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 20:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbjJBSz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 14:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjJBSz1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 14:55:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8577B3
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 11:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696272876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dmM5ZNDegeZhf5s/Nz9vdWgDVovgTarUhb8l/wE2St4=;
        b=D6EtpInv3Uq0zrKQjjic7ta+Fe46Eujr51FcGNfpf63EUa9tzOOrqgW9cMBnDawAU6qMGR
        BeOhfAPeGaHTAbqr27TR3BMr+NidPe9NflU8qt6sXFzRKrkN/AJIjoMkta0jzwhlXdb4J/
        E6gtxKOBRXEIGzoI3Bjo5Yau374PjZI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-W4uLBja-N5WWgJ9pUCQOhA-1; Mon, 02 Oct 2023 14:54:22 -0400
X-MC-Unique: W4uLBja-N5WWgJ9pUCQOhA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24FD3101A59B;
        Mon,  2 Oct 2023 18:54:22 +0000 (UTC)
Received: from localhost (unknown [10.39.192.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A0BD310EE402;
        Mon,  2 Oct 2023 18:54:21 +0000 (UTC)
Date:   Mon, 2 Oct 2023 14:54:20 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-scsi: Spelling s/preceeding/preceding/g
Message-ID: <20231002185420.GB1059748@fedora>
References: <b57b882675809f1f9dacbf42cf6b920b2bea9cba.1695903476.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fuzmqqeB7+mI12HN"
Content-Disposition: inline
In-Reply-To: <b57b882675809f1f9dacbf42cf6b920b2bea9cba.1695903476.git.geert+renesas@glider.be>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--fuzmqqeB7+mI12HN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 28, 2023 at 02:18:33PM +0200, Geert Uytterhoeven wrote:
> Fix a misspelling of "preceding".
>=20
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/vhost/scsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--fuzmqqeB7+mI12HN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEyBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmUbEdwACgkQnKSrs4Gr
c8jm3wf3SybCVag7HhsRlbQBB2qCWSsI12mkvW0sXMAwLbLvfBANqEWmTzmywolz
wzPqtLEJrTAScwq8jHk8r9R+V8Sq+thDzpNdI08PCGDVriCt8LBEgDIjvs0EvSNP
rAhQxFxP5ciDKCRnnVq3cdXdzwPdkKNifj02HiaXQknBCE99vXD71LTwYLY4MBXI
fIfva8/FlebeJYdBU91I9alORHAnlmgE7xZWh3j9QN8b+hT6TQKbcVKan2Z+/Zj+
uEsjUWce8P3nTF8jd1AkjFDTegRXSmc9TKX2iqiglCBRZPUT8Ya2pSacmGdk2Lm/
mNLVJfYcDmicuRAkTrTsok4iECvw
=P1kz
-----END PGP SIGNATURE-----

--fuzmqqeB7+mI12HN--


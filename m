Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF1C56F4B1A
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 22:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjEBUPQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 16:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjEBUPK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 16:15:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656B3198C
        for <kvm@vger.kernel.org>; Tue,  2 May 2023 13:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683058463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nAEd+ThcQWINJlvJtJN4h1Ebf0jhOxf5fjR+jlzpGuE=;
        b=dXV9Vy855c32Ms7ngrdJuoSf5TLHv3DweNGGiPHndGZHzFhEm+5fmnMA4BiNmwnMTQHvmr
        O25lfMEDpPTmyozjznZ3P6ZjFTyFK8Df/8Bo7io9FoiLDIR7+f5EjtYVZJwg6As8JLElKP
        wZcZKI0bKznYzlsw7PkVhbW+KSUZir4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-aYlCX5tFMCCM8wy3KwFEfA-1; Tue, 02 May 2023 16:14:21 -0400
X-MC-Unique: aYlCX5tFMCCM8wy3KwFEfA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EAEA0102F22D;
        Tue,  2 May 2023 20:14:20 +0000 (UTC)
Received: from localhost (unknown [10.39.192.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1DDB92026D25;
        Tue,  2 May 2023 20:14:19 +0000 (UTC)
Date:   Tue, 2 May 2023 16:14:18 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
Subject: Re: [Patch net] vsock: improve tap delivery accuracy
Message-ID: <20230502201418.GG535070@fedora>
References: <20230502174404.668749-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0Dc6VZ7ve/w9MZyR"
Content-Disposition: inline
In-Reply-To: <20230502174404.668749-1-xiyou.wangcong@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--0Dc6VZ7ve/w9MZyR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 02, 2023 at 10:44:04AM -0700, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>=20
> When virtqueue_add_sgs() fails, the skb is put back to send queue,
> we should not deliver the copy to tap device in this case. So we
> need to move virtio_transport_deliver_tap_pkt() down after all
> possible failures.
>=20
> Fixes: 82dfb540aeb2 ("VSOCK: Add virtio vsock vsockmon hooks")
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Cc: Stefano Garzarella <sgarzare@redhat.com>
> Cc: Bobby Eshleman <bobby.eshleman@bytedance.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  net/vmw_vsock/virtio_transport.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_tran=
sport.c
> index e95df847176b..055678628c07 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -109,9 +109,6 @@ virtio_transport_send_pkt_work(struct work_struct *wo=
rk)
>  		if (!skb)
>  			break;
> =20
> -		virtio_transport_deliver_tap_pkt(skb);
> -		reply =3D virtio_vsock_skb_reply(skb);
> -
>  		sg_init_one(&hdr, virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)=
));
>  		sgs[out_sg++] =3D &hdr;
>  		if (skb->len > 0) {
> @@ -128,6 +125,8 @@ virtio_transport_send_pkt_work(struct work_struct *wo=
rk)
>  			break;
>  		}
> =20
> +		virtio_transport_deliver_tap_pkt(skb);
> +		reply =3D virtio_vsock_skb_reply(skb);

I don't remember the reason for the ordering, but I'm pretty sure it was
deliberate. Probably because the payload buffers could be freed as soon
as virtqueue_add_sgs() is called.

If that's no longer true with Bobby's skbuff code, then maybe it's safe
to monitor packets after they have been sent.

Stefan

--0Dc6VZ7ve/w9MZyR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmRRbxoACgkQnKSrs4Gr
c8h/hAgAq4kkdU23+bhb7SJMTwFS13v3myHk2VwR1yoo45K747CJ4JrcQ/WPElFK
DfAoVseMWpQD036gdRWJ/PEaKwKNubb4gdi++tcjAaVkpzGF1U94YazwqmUWQhdj
+WQOQdoubxhrAJabeE6CWgSDv2i8CcDkb9ExbePPJ/uwCAlRFcfAjxeIg2+KIPv1
+Gbbc2D5M98u+1TJWVg+uiHmE/MOF1EgEVxf/K5pdV/K/a28Oi5F4rqDQ+pm2o2X
+HLs2N3AO+9k46TdSiAsBLsYkFHwqigogXUUk00tNnlLPS4CZ0qpurC3VetfOIjU
/P2y23AuIY3C0hJIQp6K7HQz/Yjc6A==
=EShQ
-----END PGP SIGNATURE-----

--0Dc6VZ7ve/w9MZyR--


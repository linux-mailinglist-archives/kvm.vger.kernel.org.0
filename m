Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5802D2594
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 09:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbgLHIRF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 03:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbgLHIRF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 03:17:05 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4088C0613D6
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 00:16:24 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id m19so23335896ejj.11
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 00:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0MZ4ych3emYAu7+Q9yW/YIpRfM16QACSHELWSs2rWrA=;
        b=kF3j152eFYRZ/AwAwWDl/8sH1FPpTecOhMACHlnX2wSwpOpc27L5GyoUZDH2EvCMwK
         y9wdK63uwUY50RL+FKK/zFY7ENKQWtMei9T/F0e5Or8fI038x1kXF1sF1iwFXCgopmSZ
         AJOEaH2ql+No+qeGgAULvXiz+Aa5U0IxKDHTifUL42IzuKIBSNaQ/pZhZmfPEU7UhTou
         jF99BF0DppWSjdEFpvFU6Dcpd/2h1jWuRu8A5cPwUhFScGvhBsorFjDslWEVtkJS4M21
         tXsRydYs0Zv/Xh41I5eXCNNTkCFv+auW8eCgzL3yGUKOt5Y6+a+UpjbWfn52hfDkrVvE
         N6wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0MZ4ych3emYAu7+Q9yW/YIpRfM16QACSHELWSs2rWrA=;
        b=Yol4QlcLYX3Zz+TNSuHqg34U9rr8/QT2nTMJrqUO0CQ+8paM5cJ7sbUdT2hfWEfH08
         vpPj/q0n5iK3mClUKsHfe5C8pz41c6qO77vE3DybyLcTVaGvAtsz4Ov4d9UnWDLc9A0/
         3ua43OHCypbOvzX72J33FFN5pqDFArV8rhT0eHuYhWCtRkI+e0hS+MPALKNoXao/7mFK
         iZDDbwgWFTpnNOcADyRhtAv4QdssWK0Uh6M7PtGCW8N57hDSQvKxTuJFrMUMsiiDJpEs
         GWY429OoFKF2SmWO+Ew4FjtXPs/pdPCr17+bcWZpqIxlNcpfSJ9U+v+iBYXK2n95ibqp
         shZA==
X-Gm-Message-State: AOAM531WmKfcZvRK+qEFBNvQ3UJqRikF1AHhpe/FxpIii8nE4F0RacoM
        ze4R0TPn9beT75IeqJDKn/Q=
X-Google-Smtp-Source: ABdhPJxyWbI55Jd6qYICL2uwX+696K8Y0xIltzoZqUUzlSQ/rT8zc0suMehmzBTJUlToBddDlIP13Q==
X-Received: by 2002:a17:906:3294:: with SMTP id 20mr22572710ejw.239.1607415383508;
        Tue, 08 Dec 2020 00:16:23 -0800 (PST)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id z26sm16339109edl.71.2020.12.08.00.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 00:16:22 -0800 (PST)
Date:   Tue, 8 Dec 2020 08:16:21 +0000
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Cc:     qemu-devel@nongnu.org, Lars Ganrot <lars.ganrot@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Salil Mehta <mehta.salil.lnk@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Liran Alon <liralon@gmail.com>,
        Rob Miller <rob.miller@broadcom.com>,
        Max Gurtovoy <maxgu14@gmail.com>,
        Alex Barba <alex.barba@broadcom.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jim Harford <jim.harford@broadcom.com>,
        Jason Wang <jasowang@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Christophe Fontaine <cfontain@redhat.com>,
        vm <vmireyno@marvell.com>, Daniel Daly <dandaly0@gmail.com>,
        Michael Lilja <ml@napatech.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Nitin Shrivastav <nitin.shrivastav@broadcom.com>,
        Lee Ballard <ballle98@gmail.com>,
        Dmytro Kazantsev <dmytro.kazantsev@gmail.com>,
        Juan Quintela <quintela@redhat.com>, kvm@vger.kernel.org,
        Howard Cai <howard.cai@gmail.com>,
        Xiao W Wang <xiao.w.wang@intel.com>,
        Sean Mooney <smooney@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Eli Cohen <eli@mellanox.com>, Siwei Liu <loseweigh@gmail.com>,
        Stephen Finucane <stephenfin@redhat.com>
Subject: Re: [RFC PATCH 13/27] vhost: Send buffers to device
Message-ID: <20201208081621.GR203660@stefanha-x1.localdomain>
References: <20201120185105.279030-1-eperezma@redhat.com>
 <20201120185105.279030-14-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="chReQkDOePndSGWY"
Content-Disposition: inline
In-Reply-To: <20201120185105.279030-14-eperezma@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--chReQkDOePndSGWY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2020 at 07:50:51PM +0100, Eugenio P=E9rez wrote:
> -static inline bool vhost_vring_should_kick(VhostShadowVirtqueue *vq)
> +static bool vhost_vring_should_kick_rcu(VhostShadowVirtqueue *vq)

"vhost_vring_" is a confusing name. This is not related to
vhost_virtqueue or the vhost_vring_* structs.

vhost_shadow_vq_should_kick_rcu()?

>  {
> -    return virtio_queue_get_used_notify_split(vq->vq);
> +    VirtIODevice *vdev =3D vq->vdev;
> +    vq->num_added =3D 0;

I'm surprised that a bool function modifies state. Is this assignment
intentional?

> +/* virtqueue_add:
> + * @vq: The #VirtQueue
> + * @elem: The #VirtQueueElement

The copy-pasted doc comment doesn't match this function.

> +int vhost_vring_add(VhostShadowVirtqueue *vq, VirtQueueElement *elem)
> +{
> +    int host_head =3D vhost_vring_add_split(vq, elem);
> +    if (vq->ring_id_maps[host_head]) {
> +        g_free(vq->ring_id_maps[host_head]);
> +    }

VirtQueueElement is freed lazily? Is there a reason for this approach? I
would have expected it to be freed when the used element is process by
the kick fd handler.

> diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
> index 9352c56bfa..304e0baa61 100644
> --- a/hw/virtio/vhost.c
> +++ b/hw/virtio/vhost.c
> @@ -956,8 +956,34 @@ static void handle_sw_lm_vq(VirtIODevice *vdev, Virt=
Queue *vq)
>      uint16_t idx =3D virtio_get_queue_index(vq);
> =20
>      VhostShadowVirtqueue *svq =3D hdev->sw_lm_shadow_vq[idx];
> +    VirtQueueElement *elem;
> =20
> -    vhost_vring_kick(svq);
> +    /*
> +     * Make available all buffers as possible.
> +     */
> +    do {
> +        if (virtio_queue_get_notification(vq)) {
> +            virtio_queue_set_notification(vq, false);
> +        }
> +
> +        while (true) {
> +            int r;
> +            if (virtio_queue_full(vq)) {
> +                break;
> +            }

Why is this check necessary? The guest cannot provide more descriptors
than there is ring space. If that happens somehow then it's a driver
error that is already reported in virtqueue_pop() below.

I wonder if you added this because the vring implementation above
doesn't support indirect descriptors? It's easy to exhaust the vhost
hdev vring while there is still room in the VirtIODevice's VirtQueue
vring.

--chReQkDOePndSGWY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/PNlUACgkQnKSrs4Gr
c8i9Uwf+KL98CWZdfBbfOzMa4z1SurHdDzNVHmvessTG6JChYGBDqPsIWpD7BZkb
xT/Qq67zwsCyUzrAlmFN90vPucMpqvB21DfXXv4MpjBWS5X0yjwwMQFktulDW/0y
TYJd7mplqyRUC8UV0yzv4U7N9RH15oZ8fyZ0KvYwXhlLgjsfBZAPXekHrVU+Ir1W
5Lx5C+/+h0ocxFTU2ycn4y0flbIvYZXtGf5y9dX3g48JH0R8D81d7qXamsRAA1Cw
uYhOsTVIDTpLWPuT6gJXu8ibk2Zc8tFcBul+5G1XfMNWAaUkZqsQmzGpOl2p3DZK
XuOZqG530TE0w0AtfRTsiDrsjWfvjw==
=TPSt
-----END PGP SIGNATURE-----

--chReQkDOePndSGWY--

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976B52D15D8
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 17:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgLGQU3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 11:20:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgLGQU3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 11:20:29 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF268C061793
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 08:19:42 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id g20so20339917ejb.1
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 08:19:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/eSi/KSMttHPQgAIpGGrtrzzrv7ZxXO1mG7WIUe69XI=;
        b=XBQhYfKoE1vDdmR6R6aw3GslMvqVhMHR+mWPKtK7kFF2S2NzpY3QDbR3B6hc6uqB2E
         nS5Bx6SFAYDqdy/fjDiMPPqUVPc+FyRfT0Mx9I/PnAGu/JGo6420yHTKjXAI/83QoJOL
         KXW9KklObO+mMR2gx5SZMQ93dzL4aK86V3M06gRdD4Ycqegs37yDDNaOPBmd/SWAPiaN
         vjufootHqk+B7uY3S9qON91bzw2uV6jqjyhc5iolXZGBNiYZyorBkZ5P6gngcVB/eGIf
         Qd51RPCKHOL9iMwHe2rnG3dEWHa1S+/v+HWZK75ObhxIlKBH84bLAR3t++wW7yZgMvYR
         ah4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/eSi/KSMttHPQgAIpGGrtrzzrv7ZxXO1mG7WIUe69XI=;
        b=YfSPfUse+VwKol/Srfx4fhGN6VF7SqvWhGUIE4u0Vv55Tp3NEpInGAArGkXqZ/QA2Q
         KLqJ+YSh02MQhuWO0QfWt6N3JO60Ftu3afQmNU8vDE6TPB/oGq51Paw3M0i+WZneUjr4
         nQBPembChIUIPTg/5eCHfjBy9ZFC5gZeurGYcgn2zNrY62olPlWZP7BjBhWMCDEnMhMB
         K3bVIRAm2wOlTEr06WFvG3c8YFlFLnMZ1Q5tD860wqC89AscuSUl6B5fXr5ICTnDniAp
         AcLxyUwIQ+oZcbxcIwFey/u+Vz3guy1jTxPTfT7ZsQJtwleYGs2TNJ3sRXrLe3G27ede
         rXTg==
X-Gm-Message-State: AOAM532eyUgntQZ8Sm+/I/nT9N0aQZLGvrsdawzJi+G6PdkG4v00EVxK
        I5HJ/TzT6WULUXdppbNoPPXIi1znOXKC4A==
X-Google-Smtp-Source: ABdhPJwKqNkLOxHgzPO8kSnC1Cb3/OofXxUefrdmsY4FNYlS+ZjB5jXyTOtCYTslSsyc6ct9KuXq4A==
X-Received: by 2002:a17:906:7146:: with SMTP id z6mr19613913ejj.379.1607357981469;
        Mon, 07 Dec 2020 08:19:41 -0800 (PST)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id u3sm12762018eje.33.2020.12.07.08.19.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 08:19:40 -0800 (PST)
Date:   Mon, 7 Dec 2020 16:19:38 +0000
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
Subject: Re: [RFC PATCH 02/27] vhost: Add device callback in
 vhost_migration_log
Message-ID: <20201207161938.GJ203660@stefanha-x1.localdomain>
References: <20201120185105.279030-1-eperezma@redhat.com>
 <20201120185105.279030-3-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZG+WKzXzVby2T9Ro"
Content-Disposition: inline
In-Reply-To: <20201120185105.279030-3-eperezma@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--ZG+WKzXzVby2T9Ro
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2020 at 07:50:40PM +0100, Eugenio P=E9rez wrote:
> This allows code to reuse the logic to not to re-enable or re-disable
> migration mechanisms. Code works the same way as before.
>=20
> Signed-off-by: Eugenio P=E9rez <eperezma@redhat.com>
> ---
>  hw/virtio/vhost.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>=20
> diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
> index 2bd8cdf893..2adb2718c1 100644
> --- a/hw/virtio/vhost.c
> +++ b/hw/virtio/vhost.c
> @@ -862,7 +862,9 @@ err_features:
>      return r;
>  }
> =20
> -static int vhost_migration_log(MemoryListener *listener, bool enable)
> +static int vhost_migration_log(MemoryListener *listener,
> +                               bool enable,
> +                               int (*device_cb)(struct vhost_dev *, bool=
))

Please document the argument. What is the callback function supposed to
do ("device_cb" is not descriptive so I'm not sure)?

--ZG+WKzXzVby2T9Ro
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/OVhoACgkQnKSrs4Gr
c8gwwgf+I95GBsEKHODfWsFkV4okONNvzPrm37wdLDLPOul1sVnt6WLfrSCIsaMV
JOtZ9+/JvsQFtyPkRSK8+rZhnj9hCnPpDeyHgi7L4w46JZsJDlxJTbu0cGOmg7N7
M3b/q3g6WY3uH2vDG7s47bQbzT+cLO9VTRRiD8G7Vww4r9gG2i0KAtAcnohsfDTQ
jPi3NnuwisOT8xYnj7+av7mVKgT1QhGFgGXp03qASF+KyLT/SCh8h7fOgYo/vrDb
JzDowD77/K9l4bsGOvPi3bpIJu0VPPQ7aTVxWjALnBRIqCce8yeY5angbK+aUjPZ
GLHd2rLH3KnQlEclmuCx0N8nCCvc1Q==
=P6IF
-----END PGP SIGNATURE-----

--ZG+WKzXzVby2T9Ro--

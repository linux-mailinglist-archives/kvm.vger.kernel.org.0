Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067882D267B
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 09:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbgLHImm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 03:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728078AbgLHImm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 03:42:42 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6212C061749
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 00:42:01 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id cw27so16703733edb.5
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 00:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dv5042T5Xl5anFxys9y89AYgrw+q8hp4hTeeMVqbfNM=;
        b=Wff6CoaMW3uX4r9WwTxFp+jpDE9pAduxRRSz4rVxEnS3miF+JZ5aS9POcaEvPBDpQz
         xXbitemYl5dTVKfKNkNxEU7WDwvcrfENEAVtPFtR9Cn0auNaRG8YJ9LDw41E/bwIBDos
         no7fegFtVm8SeEp8tLDpXgwXQ2mKUfL1Zymw1sn3DINpWzHt4irS9t/LQ6zXzsxRjiYL
         ZXw+AP9aHRwBDaRb8jHEcqgoWOnUV5aJpV64PykkpG0XMVbj8bXQtwVmroIefb/pSfyO
         2NR0mGnXYp/Nm1p1ydo3umt/7Juo4vr31PatUjq6dSribOltlKSB8LIlq0LSOK758U/H
         3zLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dv5042T5Xl5anFxys9y89AYgrw+q8hp4hTeeMVqbfNM=;
        b=AJCSYAbNLXMVW4/vDmT9vEJ/fNnqvy0PK82Yyxf+sKP/vAl+8TNDbOHVJvHaM11cIy
         hAgte6Ity+0y/m3//s/2F7/31wSD6CDGrWLQGJYHfybxhYz0AOE9540gb9yJlrMvjrWC
         vLirmwcprYOECsAGQpQA5J6Izqw6Ta5vxqXzwGEIB0+8A5zZBhhlNi62xx5r+rdHER8S
         V51Ud3SD29mu1j9cu32+gbYjuZ6Y35t3Dw5Xk2hVodbEbq6d+CoCrKmGnjPe4aT6gCiJ
         LOkoJEGdpMhGK5CvdESRYLNOVY/foqOtewfyP0GFVfR3wykwf+/WMoGz4BJK0SLR2YqD
         pdmw==
X-Gm-Message-State: AOAM5330FdOkQnsIV9bHpNI/OnyIMJQ03aGp0oKmBJRAMjJLG7YcDdNg
        zGAPcoRJl6MEBI/gLglz+UQYO6IJmW1yww==
X-Google-Smtp-Source: ABdhPJxKX9FUD+oYHW+oUA4G+bzORQxT3oENR+iOmlg23ZJuzgV75RiXV2XUS+CIPltJfjfZPeW9YQ==
X-Received: by 2002:a05:6402:a45:: with SMTP id bt5mr23987529edb.130.1607416920727;
        Tue, 08 Dec 2020 00:42:00 -0800 (PST)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id m1sm13292254ejg.41.2020.12.08.00.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 00:41:59 -0800 (PST)
Date:   Tue, 8 Dec 2020 08:41:58 +0000
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
Subject: Re: [RFC PATCH 18/27] vhost: add vhost_vring_poll_rcu
Message-ID: <20201208084158.GU203660@stefanha-x1.localdomain>
References: <20201120185105.279030-1-eperezma@redhat.com>
 <20201120185105.279030-19-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sDhuxz86kt5qlkuV"
Content-Disposition: inline
In-Reply-To: <20201120185105.279030-19-eperezma@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--sDhuxz86kt5qlkuV
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2020 at 07:50:56PM +0100, Eugenio P=E9rez wrote:
> @@ -83,6 +89,18 @@ void vhost_vring_set_notification_rcu(VhostShadowVirtq=
ueue *vq, bool enable)
>      smp_mb();
>  }
> =20
> +bool vhost_vring_poll_rcu(VhostShadowVirtqueue *vq)

A name like "more_used" is clearer than "poll".

--sDhuxz86kt5qlkuV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/PPFYACgkQnKSrs4Gr
c8i/SQf/TvTgWv3whWVp5Emvh9/XNPEraByggX/NHutQ/7KU68p2ij7mFjVhwXoA
S6Cga7m5aygc3dDUoTF2rsp1uhontJMnUxLtq7glV2eUFpg/DqxfwBjU9uAYziyo
yqr4PaBlhgqJbNO9lsLXpwHX+KZwGDDsm+eiAPgOsKVltCQaHMCE3LETr3MX6JwU
ZHwC9DSppMxi7LXWqiTiHMwP006UxKxQQQfHiUpYYkZQ2qBpNpGXfQoebtyDgbUm
/lb3vNSJzsqrusZvv7j1LMVXFjPnpGdsry9w9q+ia9B68VPFQJp9CYwJxVIBA3DS
mOsdXqFq6+bwjli4YUG16be6Oc3rOg==
=k8Qa
-----END PGP SIGNATURE-----

--sDhuxz86kt5qlkuV--

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08DC2D27D1
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 10:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbgLHJiA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 04:38:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728714AbgLHJh7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 04:37:59 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71ADBC061749
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 01:37:19 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id g20so23721964ejb.1
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 01:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=H04qlmtb8GOVjHbIauAjHp3hL9z0pEZLzsG11VbZlh0=;
        b=dbSZqkFRwScVwXkqKBtCdq0l8wchyeL1jNiwWURQzX0ET32g2KLjJv9FnzY6Eg9DMg
         RdWQUAloKjkiMsK/bLUJx4w+25ypM4iUa5geUif7X5EKHkm2nxmj+iz4/WZYjd29b6vW
         E53uvmjJI32tgj+DBIvM2jWrJgZMLxpttRJw72TMpOs4iUTf56tGzCjYPxPZX7cKWXb5
         H92AcRpoTzotdovrGdPzL5wOrdspybZu5lQ0CTJzka2MAzWHBP3Wn0AEhd/EaiTtFEeO
         7yBcmLe/D7w1aROsuB97aDhI8ql+nc5KUXA6iEyzfe25f50N1EWV6yQNM9aA1CrnYqoH
         CgtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H04qlmtb8GOVjHbIauAjHp3hL9z0pEZLzsG11VbZlh0=;
        b=YEJi9lvCLpvTeh+wjsd5fU8LJz+lThvMjRn7PFKjQzgkoZNQ6G6NkXdKF2FEBqZbbv
         gUS3Ii02Lgb02CBwf47sxrnDMIU8icjLJ6s/e4S3p6SZN9vMVaH+32q3SvvPEY1wUThJ
         XiAmv/WuhttHDVBXP8NggDj5Mg9hcO17Jm8hoHzWQCWr8gcNhGueo4ya2CT+qysOajFG
         t87NQbFktnIb+dxyeNgXtrlbUuT4pE0jm6TrpfkHy86ADdODjPkt+CxxKl1YAdl/jWZh
         PlSS1LnyaB8CXz9q1XiqkYHRFryV095tjyIo6T7JwMlogi9E8Fj69fN7rcF25QT7ozlz
         S15g==
X-Gm-Message-State: AOAM530GCfzHun+jd7Kv9UfsygJlKUc2dIIaoYM9vEwMOqxwU36S7vvD
        +AUYkRTtb81Y7VY0rqSS25U=
X-Google-Smtp-Source: ABdhPJxZVOdT5V/bGQkbT7kDiYMKS1OUX76aAlA687e08yXRtJiX1YkBPrTrqfOklwYbJY8kqXBsKw==
X-Received: by 2002:a17:906:c24b:: with SMTP id bl11mr22185341ejb.3.1607420238209;
        Tue, 08 Dec 2020 01:37:18 -0800 (PST)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id bn21sm12914808ejb.47.2020.12.08.01.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 01:37:17 -0800 (PST)
Date:   Tue, 8 Dec 2020 09:37:15 +0000
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
Subject: Re: [RFC PATCH 00/27] vDPA software assisted live migration
Message-ID: <20201208093715.GX203660@stefanha-x1.localdomain>
References: <20201120185105.279030-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="je0mZywpqEo4t1RU"
Content-Disposition: inline
In-Reply-To: <20201120185105.279030-1-eperezma@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--je0mZywpqEo4t1RU
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2020 at 07:50:38PM +0100, Eugenio P=E9rez wrote:
> This series enable vDPA software assisted live migration for vhost-net
> devices. This is a new method of vhost devices migration: Instead of
> relay on vDPA device's dirty logging capability, SW assisted LM
> intercepts dataplane, forwarding the descriptors between VM and device.

Pros:
+ vhost/vDPA devices don't need to implement dirty memory logging
+ Obsoletes ioctl(VHOST_SET_LOG_BASE) and friends

Cons:
- Not generic, relies on vhost-net-specific ioctls
- Doesn't support VIRTIO Shared Memory Regions
  https://github.com/oasis-tcs/virtio-spec/blob/master/shared-mem.tex
- Performance (see below)

I think performance will be significantly lower when the shadow vq is
enabled. Imagine a vDPA device with hardware vq doorbell registers
mapped into the guest so the guest driver can directly kick the device.
When the shadow vq is enabled a vmexit is needed to write to the shadow
vq ioeventfd, then the host kernel scheduler switches to a QEMU thread
to read the ioeventfd, the descriptors are translated, QEMU writes to
the vhost hdev kick fd, the host kernel scheduler switches to the vhost
worker thread, vhost/vDPA notifies the virtqueue, and finally the
vDPA driver writes to the hardware vq doorbell register. That is a lot
of overhead compared to writing to an exitless MMIO register!

If the shadow vq was implemented in drivers/vhost/ and QEMU used the
existing ioctl(VHOST_SET_LOG_BASE) approach, then the overhead would be
reduced to just one set of ioeventfd/irqfd. In other words, the QEMU
dirty memory logging happens asynchronously and isn't in the dataplane.

In addition, hardware that supports dirty memory logging as well as
software vDPA devices could completely eliminate the shadow vq for even
better performance.

But performance is a question of "is it good enough?". Maybe this
approach is okay and users don't expect good performance while dirty
memory logging is enabled. I just wanted to share the idea of moving the
shadow vq into the kernel in case you like that approach better.

Stefan

--je0mZywpqEo4t1RU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/PSUsACgkQnKSrs4Gr
c8gQ+gf+PZB8RHKqu3nzT0rmAbtlme76xGY3u9UIr5jckuQ1ZTVVztqZEneemNB+
Z4YWhLni7IRYc+vDZbv1gnch2+DCElbbQIq4loGpKp8QDuuOCZVrcFCMtHElPGoV
ND4eMy7TWVkUM1cVEDHxbwyfZAswrLg3Q2vpYw/ysMTX3E2ddjplSw6ILWRj0YYX
L0fy0Hkp2mB8QGa/tIpXLqBXyfj+L9GhOZZEoskfnyGTfAlZK3/NsosrLit/h/GL
5z/GkL/Yvx4jmu/v+FlubhLrJ1YZfiU8yOyuCxXIMdVFNWXS71/KBG+nXiV+DaLt
+tylyKz0CuSBHwe3TXpp29Y6bkGRcA==
=NkoN
-----END PGP SIGNATURE-----

--je0mZywpqEo4t1RU--

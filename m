Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7D7220BBA
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 13:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbgGOLYC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 07:24:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25547 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725811AbgGOLYC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 07:24:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594812240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oWZTkzAA9DPHcbpakWqj0PIztNWmUWrWx7WehE0uGxY=;
        b=B3aTxvF2ztaDtW50UYqQKUbDjMGIorgBfzXiSHZMAVU0kaWKwp7kZDhkkGnB/xXGZo9KAi
        nt0k7UnvP1NY6p1V1DUDUcaP+nGoat6AwQjGAVtjOJW7HP68RvRsjgo8/orwXWqK7VwUnN
        ZMO8E0WmMiLUjCw86TaTnVSGjvUaSsY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-g5yh5mM0NC2f_gxsTnHCZQ-1; Wed, 15 Jul 2020 07:23:51 -0400
X-MC-Unique: g5yh5mM0NC2f_gxsTnHCZQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38DE5801E6A;
        Wed, 15 Jul 2020 11:23:50 +0000 (UTC)
Received: from localhost (ovpn-115-22.ams2.redhat.com [10.36.115.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 883A661463;
        Wed, 15 Jul 2020 11:23:43 +0000 (UTC)
Date:   Wed, 15 Jul 2020 12:23:42 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Nikos Dragazis <ndragazis@arrikto.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Thanos Makatos <thanos.makatos@nutanix.com>,
        "John G. Johnson" <john.g.johnson@oracle.com>,
        Andra-Irina Paraschiv <andraprs@amazon.com>,
        Alexander Graf <graf@amazon.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Maxime Coquelin <maxime.coquelin@redhat.com>,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Subject: Inter-VM device emulation (call on Mon 20th July 2020)
Message-ID: <20200715112342.GD18817@stefanha-x1.localdomain>
References: <86d42090-f042-06a1-efba-d46d449df280@arrikto.com>
MIME-Version: 1.0
In-Reply-To: <86d42090-f042-06a1-efba-d46d449df280@arrikto.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9dgjiU4MmWPVapMU"
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--9dgjiU4MmWPVapMU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
Several projects are underway to create an inter-VM device emulation
interface:

 * ivshmem v2
   https://www.mail-archive.com/qemu-devel@nongnu.org/msg706465.html

   A PCI device that provides shared-memory communication between VMs.
   This device already exists but is limited in its current form. The
   "v2" project updates IVSHMEM's capabilities and makes it suitable as
   a VIRTIO transport.

   Jan Kiszka is working on this and has posted specs for review.

 * virtio-vhost-user
   https://www.mail-archive.com/virtio-dev@lists.oasis-open.org/msg06429.html

   A VIRTIO device that transports the vhost-user protocol. Allows
   vhost-user device emulation to be implemented by another VM.

   Nikos Dragazis is working on this with QEMU, DPDK, and VIRTIO patches
   posted.

 * VFIO-over-socket
   https://github.com/tmakatos/qemu/blob/master/docs/devel/vfio-over-socket.rst

   Similar to the vhost-user protocol in spirit but for any PCI device.
   Uses the Linux VFIO ioctl API as the protocol instead of vhost.

   It doesn't have a virtio-vhost-user equivalent yet, but the same
   approach could be applied to VFIO-over-socket too.

   Thanos Makatos and John G. Johnson are working on this. The draft
   spec is available.

Let's have a call to figure out:

1. What is unique about these approaches and how do they overlap?
2. Can we focus development and code review efforts to get something
   merged sooner?

Jan and Nikos: do you have time to join on Monday, 20th of July at 15:00
UTC?
https://www.timeanddate.com/worldclock/fixedtime.html?iso=20200720T1500

Video call URL: https://bluejeans.com/240406010

It would be nice if Thanos and/or JJ could join the call too. Others
welcome too (feel free to forward this email)!

Stefan

--9dgjiU4MmWPVapMU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl8O5z0ACgkQnKSrs4Gr
c8hjeAf/cWBoN6BvfVBV9auavDcf7KWOyIGyAQ1Km9eixV3EALOXNevMK7Nx7pWM
JVHpTDwQu9fafM2tryPtQFmOSYB6xddYMbXXKzuXiZyE95OAVOSUMS76Fr5X3Z9r
pPn4TjK00P2WG/ztfjLO3HyxCpVkinWaaEAFcaFK6sIZ0U+GbbL758QfAvc9Z0Xp
uwhk3ldruGEvNeq0iMYp1LzNurX/1vI9m+P2gkNcFxwe/xI0NtgJ0cmlZh5efCkA
4in3ac+qs1lfM8W6MI1/XHSUv5qKvCe9scWiN4eXNuzxqmTht2ti+RyoN8cJ4wwT
REBQPTd6KNnBTgu8URZjHU1cjKBi6w==
=ATKX
-----END PGP SIGNATURE-----

--9dgjiU4MmWPVapMU--


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4964100484
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 12:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfKRLmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 06:42:07 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27035 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726506AbfKRLmH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Nov 2019 06:42:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574077326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mwMdwNiUvTdAk1yLeIgbUXoa8gGnHM2LkDasXwZuJ7g=;
        b=PME4ye59jOzi7om6DWyVBSVHeAgNcfNWWcu7Az/du4NWoUJgg7/qxJcdZQe0FPWTfwkQJp
        lYxvwJFGkbBZxt0gwTjQ1YDNsK4yLnkS4GnCpFwALcxlVHqtwwzCwcFjRajBT5bpxREe0X
        c9bClGtS1gMfMAeF4xcEcpX9qWYjyVI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-4dlM98s6NiC6OYyWQN7DVg-1; Mon, 18 Nov 2019 06:42:02 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2097F107ACE5;
        Mon, 18 Nov 2019 11:42:01 +0000 (UTC)
Received: from sirius.home.kraxel.org (ovpn-116-67.ams2.redhat.com [10.36.116.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBA7F2935A;
        Mon, 18 Nov 2019 11:42:00 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id BA18916E2D; Mon, 18 Nov 2019 12:41:59 +0100 (CET)
Date:   Mon, 18 Nov 2019 12:41:59 +0100
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: Re: [PATCH 14/15] sample/vfio-mdev/mbocs: Remove dma_buf_k(un)map
 support
Message-ID: <20191118114159.vi3cpfkj2qaqkuav@sirius.home.kraxel.org>
References: <20191118103536.17675-1-daniel.vetter@ffwll.ch>
 <20191118103536.17675-15-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
In-Reply-To: <20191118103536.17675-15-daniel.vetter@ffwll.ch>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: 4dlM98s6NiC6OYyWQN7DVg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 18, 2019 at 11:35:35AM +0100, Daniel Vetter wrote:
> No in-tree users left.
>=20
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Kirti Wankhede <kwankhede@nvidia.com>
> Cc: kvm@vger.kernel.org
> --
> Ack for merging this through drm trees very much appreciated.
> -Daniel

Acked-by: Gerd Hoffmann <kraxel@redhat.com>

cheers,
  Gerd


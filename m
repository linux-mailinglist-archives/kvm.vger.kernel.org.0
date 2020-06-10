Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAEE1F5394
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 13:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbgFJLho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 07:37:44 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32159 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728480AbgFJLgW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Jun 2020 07:36:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591788982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nqpRKPPRu97i04+lEwiVZnVP4RAISD6OyeyY71/1iaw=;
        b=PD3DXviUIXZSvLoLAGuF692PzUijlWhppV55ZYxp5ZvJhdv/oOyKxnqycdlsIKlAl05Ro9
        vJXmZKpt9/tjiRcITzJF7kZ+lqnPFaDR6sRdKl9FT8WvPsPF/3XlmhxsbBVFUDAcD1u2C4
        Q8BCO1YTt5uaGYZRw8wu8KRy9OYKJWc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-bN5wehGAMTKchmSsljszBQ-1; Wed, 10 Jun 2020 07:36:20 -0400
X-MC-Unique: bN5wehGAMTKchmSsljszBQ-1
Received: by mail-wr1-f72.google.com with SMTP id s17so963015wrt.7
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 04:36:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nqpRKPPRu97i04+lEwiVZnVP4RAISD6OyeyY71/1iaw=;
        b=ZwWNeGlHqxHgdpFM7UlULtV5OIB1MWNMXPvKHS0vekGKDSxtutRDAqNkMlDrnGcrux
         cKpbHmZ7nijSTuyjuoqz2cYu8uIygmdjvxN9DKRDZOUlMBc7NkIboG6iascfi8P2lEw2
         QK4tlpmimYMM3XJrQ2kwHhpRNWM7W7LY372SWoJE41kLS9NX80+56z8MYousII28sDIm
         kKCTpEzVaNnrdruyRHLMrpcbtBSPr8AyW9ycasNQGl1TcFT2Jmk0KpgaP2XnCMdPQlCw
         zA2dHev6MSY2jD1wrPFK3y3oRQTjKh/Yc/G/G0jpg7c7mowatv6D3xRhaKjx/ojhzEoy
         e7RA==
X-Gm-Message-State: AOAM531AVxtvYISjDNuIF2GIwBydC5yyMGyyB/0G4w8B8EjW2+vZtOgP
        GTQSOkj8JxldpIeqkn60vQWC6yUTvmARulfSYLwUc+hDbP7dam5xhZ3aJiXawcNoxCJly7eKYG4
        TjfF30dVAGuaO
X-Received: by 2002:a7b:cc94:: with SMTP id p20mr2749315wma.148.1591788979279;
        Wed, 10 Jun 2020 04:36:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxk/lBSoKqQEzUm0ygb+JThKfl+fyQkS7QcmVzzuz7sF0aMX0Q8Jh3FrRflgePDOX+1hNCqVA==
X-Received: by 2002:a7b:cc94:: with SMTP id p20mr2749304wma.148.1591788979097;
        Wed, 10 Jun 2020 04:36:19 -0700 (PDT)
Received: from redhat.com ([212.92.121.57])
        by smtp.gmail.com with ESMTPSA id d63sm6775894wmc.22.2020.06.10.04.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 04:36:18 -0700 (PDT)
Date:   Wed, 10 Jun 2020 07:36:16 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v7 08/14] fixup! vhost: use batched get_vq_desc version
Message-ID: <20200610113515.1497099-9-mst@redhat.com>
References: <20200610113515.1497099-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610113515.1497099-1-mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

---
 drivers/vhost/vhost.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 7a587b13095c..03e6bca02288 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2205,10 +2205,6 @@ static int fetch_buf(struct vhost_virtqueue *vq)
 	last_avail_idx = vq->last_avail_idx;
 
 	if (unlikely(vq->avail_idx == vq->last_avail_idx)) {
-		/* If we already have work to do, don't bother re-checking. */
-		if (likely(vq->ndescs))
-			return 1;
-
 		if (unlikely(vhost_get_avail_idx(vq, &avail_idx))) {
 			vq_err(vq, "Failed to access avail idx at %p\n",
 				&vq->avail->idx);
-- 
MST


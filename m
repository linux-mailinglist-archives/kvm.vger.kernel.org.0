Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F12B91545FB
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 15:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgBFOWs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 09:22:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39505 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727511AbgBFOWr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 09:22:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580998966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E33KDfHwzzctyySWOHYAqupA1xDN5Ko7hssayl+bQwc=;
        b=CYybzKXKpiEkqGxbMBCWUVNg0dNRA8hNPnZ6piupJA+t8il638NdNodDlrtXZHAvTtW2Y9
        yTVlCfzYFfjNoA2/hjgEmRItvngO0xHn/ZabQIaVnjWn0sMLv9Ki3K6+PqNQ/0IxZxabJi
        ru+6eHu3xzMwiiFB2htCNDuGmZYiic4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-0s5zCX_eO2G4Tlg9eryhBQ-1; Thu, 06 Feb 2020 09:22:44 -0500
X-MC-Unique: 0s5zCX_eO2G4Tlg9eryhBQ-1
Received: by mail-wr1-f70.google.com with SMTP id a12so3455782wrn.19
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2020 06:22:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E33KDfHwzzctyySWOHYAqupA1xDN5Ko7hssayl+bQwc=;
        b=CwBDxpwNT8xkrW7PPPXEMrs0edT1NzXvZZbBk7XhdcJBrMUERGmq0tFrvW0NZXTGuG
         atGcAemqlWJHLYAE2Uz09K70db9wh1y/vOxeWOCf235MO16ysTeDlQFP8UlyLU53LBla
         0Y0GpQzVB1sxp5gsJTYknFK6Ne81iKOp/vBbKOXS3aS2lCnFpGjUUDm9/tkgA6t6fEt5
         do6NmHlADFV2Y63WLC1MkcrlbAtYGO44hJfHL5J7Tu1DF7z5av+3YxfN15/IKElTPo+6
         U5kIteXpFp/GJ8ZC0CiQT6KGLFi30N3Ali7lLARWq0EsU4gLgbhuaMf4ZZu4hJYlhekX
         4grw==
X-Gm-Message-State: APjAAAUUbsqwIQMBoX/1ip0V6/gYTM8To78M1InyqiDkMt7m2ocWo3p5
        6AecsDg3YT+2A7dMDXK9hnWjZyRwhabvt4pnAFrVqbWy64YtmuKgQccdmPgVrwvUEO2c+9bWD4C
        ChmX0rtdHqlsi
X-Received: by 2002:adf:ebc6:: with SMTP id v6mr3994364wrn.75.1580998962365;
        Thu, 06 Feb 2020 06:22:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqxG7BBemHdFdSKhjME040XnbLs09XyhcJynHyJNGXKCsyl9KkmnJAkxk+E5CCHZv+jaiz2pCA==
X-Received: by 2002:adf:ebc6:: with SMTP id v6mr3994337wrn.75.1580998962098;
        Thu, 06 Feb 2020 06:22:42 -0800 (PST)
Received: from eperezma.remote.csb (static-143-30-231-77.ipcom.comunitel.net. [77.231.30.143])
        by smtp.gmail.com with ESMTPSA id 21sm3825312wmo.8.2020.02.06.06.22.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 06:22:41 -0800 (PST)
Message-ID: <b6e32f58e5d85ac5cc3141e9155fb140ae5cd580.camel@redhat.com>
Subject: Re: vhost changes (batched) in linux-next after 12/13 trigger
 random crashes in KVM guests after reboot
From:   eperezma@redhat.com
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>
Date:   Thu, 06 Feb 2020 15:22:39 +0100
In-Reply-To: <2a63b15f-8cf5-5868-550c-42e2cfd92c60@de.ibm.com>
References: <c022e1d6-0d57-ae07-5e6b-8e40d3b01f4b@de.ibm.com>
         <20191218100926-mutt-send-email-mst@kernel.org>
         <2ffdbd95-e375-a627-55a1-6990b0a0e37a@de.ibm.com>
         <20200106054041-mutt-send-email-mst@kernel.org>
         <08ae8d28-3d8c-04e8-bdeb-0117d06c6dc7@de.ibm.com>
         <20200107042401-mutt-send-email-mst@kernel.org>
         <c6795e53-d12c-0709-c2e9-e35d9af1f693@de.ibm.com>
         <20200107065434-mutt-send-email-mst@kernel.org>
         <fe6e7e90-3004-eb7a-9ed8-b53a7667959f@de.ibm.com>
         <20200120012724-mutt-send-email-mst@kernel.org>
         <2a63b15f-8cf5-5868-550c-42e2cfd92c60@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-6.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Christian.

Could you try this patch on top of ("38ced0208491 vhost: use batched version by default")?

It will not solve your first random crash but it should help with the lost of network connectivity.

Please let me know how does it goes.

Thanks!

From 99f0f543f3939dbe803988c9153a95616ccccacd Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
Date: Thu, 6 Feb 2020 15:13:42 +0100
Subject: [PATCH] vhost: filter valid vhost descriptors flags
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Previous commit copy _NEXT flag, and it complains if a copied descriptor
contains it.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 drivers/vhost/vhost.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 27ae5b4872a0..56c5253056ee 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2125,6 +2125,8 @@ static void pop_split_desc(struct vhost_virtqueue *vq)
 	--vq->ndescs;
 }
 
+#define VHOST_DESC_FLAGS (VRING_DESC_F_INDIRECT | VRING_DESC_F_WRITE | \
+			  VRING_DESC_F_NEXT)
 static int push_split_desc(struct vhost_virtqueue *vq, struct vring_desc *desc, u16 id)
 {
 	struct vhost_desc *h;
@@ -2134,7 +2136,7 @@ static int push_split_desc(struct vhost_virtqueue *vq, struct vring_desc *desc,
 	h = &vq->descs[vq->ndescs++];
 	h->addr = vhost64_to_cpu(vq, desc->addr);
 	h->len = vhost32_to_cpu(vq, desc->len);
-	h->flags = vhost16_to_cpu(vq, desc->flags);
+	h->flags = vhost16_to_cpu(vq, desc->flags) & VHOST_DESC_FLAGS;
 	h->id = id;
 
 	return 0;
@@ -2343,7 +2345,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 		struct vhost_desc *desc = &vq->descs[i];
 		int access;
 
-		if (desc->flags & ~(VRING_DESC_F_INDIRECT | VRING_DESC_F_WRITE)) {
+		if (desc->flags & ~VHOST_DESC_FLAGS) {
 			vq_err(vq, "Unexpected flags: 0x%x at descriptor id 0x%x\n",
 			       desc->flags, desc->id);
 			ret = -EINVAL;
-- 
2.18.1


On Wed, 2020-01-22 at 20:32 +0100, Christian Borntraeger wrote:
> 
> On 20.01.20 07:27, Michael S. Tsirkin wrote:
> > On Tue, Jan 07, 2020 at 01:16:50PM +0100, Christian Borntraeger wrote:
> > > On 07.01.20 12:55, Michael S. Tsirkin wrote:
> > > 
> > > > I pushed batched-v3 - same head but bisect should work now.
> > > > 
> > > 
> > > With 
> > > commit 38ced0208491103b50f1056f0d1c8f28e2e13d08 (HEAD)
> > > Author:     Michael S. Tsirkin <mst@redhat.com>
> > > AuthorDate: Wed Dec 11 12:19:26 2019 -0500
> > > Commit:     Michael S. Tsirkin <mst@redhat.com>
> > > CommitDate: Tue Jan 7 06:52:42 2020 -0500
> > > 
> > >     vhost: use batched version by default
> > > 
> > > 
> > > I have exactly one successful ping and then the network inside the guest is broken (no packet
> > > anymore).
> > 
> > Does anything appear in host's dmesg when this happens?
> 
> I think there was nothing, but I am not sure. I would need to redo the test if this is important to know.
> 
> > 
> > > So you could consider this commit broken (but in a different way and also without any
> > > guest reboot necessary).
> > > 
> > > 
> > > bisect log:
> > > git bisect start
> > > # bad: [d2f6175f52062ee51ee69754a6925608213475d2] vhost: use vhost_desc instead of vhost_log
> > > git bisect bad d2f6175f52062ee51ee69754a6925608213475d2
> > > # good: [d1281e3a562ec6a08f944a876481dd043ba739b9] virtio-blk: remove VIRTIO_BLK_F_SCSI support
> > > git bisect good d1281e3a562ec6a08f944a876481dd043ba739b9
> > > # good: [fac7c0f46996e32d996f5c46121df24a6b95ec3b] vhost: option to fetch descriptors through an independent
> > > struct
> > > git bisect good fac7c0f46996e32d996f5c46121df24a6b95ec3b
> > > # bad: [539eb9d738f048cd7be61f404e8f9c7d9d2ff3cc] vhost: batching fetches
> > > git bisect bad 539eb9d738f048cd7be61f404e8f9c7d9d2ff3cc


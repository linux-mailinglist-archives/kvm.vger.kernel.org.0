Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 662F81F535C
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 13:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728581AbgFJLgH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 07:36:07 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25936 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728540AbgFJLgG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Jun 2020 07:36:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591788964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QQIo3L2MWWvjb6mzSKSfjdSEv1rN96HPXR5N45kiTKk=;
        b=AEMqal8DFZiU3yL6IzPoiea7QFSiL7ueOYkC2NZJsIl3gTEGIynOhlVek9XoJOgCFvR70K
        aNGk6lad0egoqocnGCQcznOLgVZr2FZenJzJdhgECrFLt1wpKwMt+9IYRJKdq59Fqv+nsX
        jLgy8WmfOPzZUvh3i8lsPXXfLotUzcY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-bOGI1rFVNu24qMykFIhxYQ-1; Wed, 10 Jun 2020 07:36:03 -0400
X-MC-Unique: bOGI1rFVNu24qMykFIhxYQ-1
Received: by mail-wm1-f72.google.com with SMTP id k185so332977wme.8
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 04:36:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QQIo3L2MWWvjb6mzSKSfjdSEv1rN96HPXR5N45kiTKk=;
        b=EsGi3IDtQslLd66EP4MN+tJ4fFChyzLtrzXds3O7bOCGQkfhtwpxyax16/aQxBZRyA
         Ey6TftC9ns8QwzvgfKO8bz4MU0qYSbG0+aUXGa+MYa7x3B4p7cgpmarK46cFYbKUozPt
         nyIHc/YBpP5ZhKl3y5PXJKtsj8/C7MWnJ1mk9L9uGMIEfNaaAi1P3R/P6D/aUN4xGq3K
         JZnCRYb3WDPUjyiOuh3HkB5KOE+lYTDcV2kA+RuYcidrgb23DYg03R02uiA//9X8V1Sz
         9C0agzp05Ou4tRgCRdPzTEaKqDzklTre6Th2q+PCaFI2SzDNK+lH7kpPXf6LXOoby458
         tgFw==
X-Gm-Message-State: AOAM531YBY+t9rqRV9N58CvKI+RzXwHNvLMFfqb9Jn4d71dOvq2O0qpY
        4b6dDMnGGwy7GNnLomK2l2lHRn091A8mkifnSwvsonXoCQgkndALZ80N8qtYaeHtSEe5gAgGFBe
        P//zgDLCyNK9B
X-Received: by 2002:adf:a157:: with SMTP id r23mr3378907wrr.92.1591788962282;
        Wed, 10 Jun 2020 04:36:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxAHBbn1Hm38GkVQUdC9QO7S3prwhr5Px+sKP6OuFbtKtCWmiw5G13O+k9LGPpnGaeJbpRtfQ==
X-Received: by 2002:adf:a157:: with SMTP id r23mr3378893wrr.92.1591788962077;
        Wed, 10 Jun 2020 04:36:02 -0700 (PDT)
Received: from redhat.com ([212.92.121.57])
        by smtp.gmail.com with ESMTPSA id c206sm7360362wmf.36.2020.06.10.04.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 04:36:01 -0700 (PDT)
Date:   Wed, 10 Jun 2020 07:35:59 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v7 02/14] fixup! vhost: option to fetch descriptors
 through an independent struct
Message-ID: <20200610113515.1497099-3-mst@redhat.com>
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
 drivers/vhost/vhost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 180b7b58c76b..11433d709651 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2614,7 +2614,7 @@ int vhost_get_vq_desc_batch(struct vhost_virtqueue *vq,
 err_fetch:
 	vq->ndescs = 0;
 
-	return ret;
+	return ret ? ret : vq->num;
 }
 EXPORT_SYMBOL_GPL(vhost_get_vq_desc_batch);
 
-- 
MST


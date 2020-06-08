Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64111F18F2
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 14:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgFHMn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 08:43:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49498 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728684AbgFHMnY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 08:43:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591620202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=utvLOGjABWchDzVBBNcvjGgT0Uw4uVA8BCJYHrkDTYE=;
        b=TyCgMLODxX0a9jzlp75v5jJdlB/ziQNUZGG1WFR4A1VSJIXaKZL0jHDPKPxvBk36zGfPGV
        Wm68hG1vlF+FKx1KiRVln78MzBLMBXw9e1DoWFHgU0c44YVcA0QoVqCJ97sc0Dxg4+L062
        DBCepTeUpfOWILkpU7co5aKxYyNROn8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-MAajVjWZM92dYktXTB2bTg-1; Mon, 08 Jun 2020 08:42:59 -0400
X-MC-Unique: MAajVjWZM92dYktXTB2bTg-1
Received: by mail-wm1-f69.google.com with SMTP id k185so3890044wme.8
        for <kvm@vger.kernel.org>; Mon, 08 Jun 2020 05:42:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=utvLOGjABWchDzVBBNcvjGgT0Uw4uVA8BCJYHrkDTYE=;
        b=Mcf/6vmQ3TK/xzZA3GvMMghpmymXDAj1zDDRuuYbsBNEJTy7GXdbVvppxKXrwJFqFa
         MywLSkju4V4+ylzEeQ/mHjfuotl13MrGZxqo2ECmYWZEhJWDC8OWb3gDYBrSezDit8gY
         SkaScSAEtNey9miMAeVyASj9MicDJJWIHqyXcBCL3O+foqvbgURGK9IRyUn6A6tli2In
         k/xmq4Liv1iuauG/suW02Qo9ROsEkR86jIrn/GQzr5ZSo4MEHzfoqgyy756vzmiSAuid
         JITD2mI6Sch7I845S/pYTqFEHTMrb8NCOqMZIoRMR/frb9EPip5soa/tRC4piwM7JARW
         Or0g==
X-Gm-Message-State: AOAM5326FF91+NylQ3zo/+AYa67ArQImamfrj3WsoFOyszo8duxLEanc
        gzYmASsYBwUaX+bFXCjBzaNmxFwUivxHp8CIJ0mK6yKN8Ckr6/H0rYGxexXdfVdN1tei5JQ8Rp8
        8UJUnr78iHrX9
X-Received: by 2002:a1c:5411:: with SMTP id i17mr17027053wmb.137.1591620178213;
        Mon, 08 Jun 2020 05:42:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxHCDKaiMql4q+MgfnmT9afh3wFAhLtf//8SgAbDqi4VLnsVn3wc/xBGn3Rmk2vnzUyPWpJw==
X-Received: by 2002:a1c:5411:: with SMTP id i17mr17027042wmb.137.1591620178029;
        Mon, 08 Jun 2020 05:42:58 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id g82sm22458959wmf.1.2020.06.08.05.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 05:42:57 -0700 (PDT)
Date:   Mon, 8 Jun 2020 08:42:56 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH] vhost/test: fix up after API change
Message-ID: <20200608124254.727184-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass a flag to request kernel thread use.

Fixes: 01fcb1cbc88e ("vhost: allow device that does not depend on vhost worker")
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index f55cb584b84a..12304eb8da15 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -122,7 +122,7 @@ static int vhost_test_open(struct inode *inode, struct file *f)
 	vqs[VHOST_TEST_VQ] = &n->vqs[VHOST_TEST_VQ];
 	n->vqs[VHOST_TEST_VQ].handle_kick = handle_vq_kick;
 	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV + 64,
-		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT, NULL);
+		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT, true, NULL);
 
 	f->private_data = n;
 
-- 
MST


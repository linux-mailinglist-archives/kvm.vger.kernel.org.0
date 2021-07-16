Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C42F53CB25F
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 08:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234791AbhGPGXJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 02:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234465AbhGPGXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 02:23:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1097FC06175F
        for <kvm@vger.kernel.org>; Thu, 15 Jul 2021 23:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=VR1glNZml+cTngi5rUbI6ULJ1OKrHv//v+DP7nQTGl0=; b=dzDy1eMNhsQwHC+WQNrYul8CWx
        Y6mW9QCyzhNbeeF0ctSnl3+YbpQ8Jh9vBAmic9Pbe9HZIFMJjlhdYcuQdGMTOYsGDmFtk7dbnIHyt
        hI8ustbwqloWrGN2tDNDY5bLp8yNvxuAcROI2N9dkeq1cmvCK2zCYRaeoFlihgD1gqTIhoqJ6byaz
        /491z9uRA1UAhyS7qHI0TPdWk/MJtxfOdOxQgjZAjN15C/A4ELKuJzf909nFSuQyH6WDwwXA25LoL
        YZWipdUHiN6IwSrcqZJ1UCiJAo4J1RaoRhFwvTIgsWSxbOtZwe924AkvrIMeKh7g6vBYZg6eAMQ91
        IA/x8RVQ==;
Received: from [2001:4bb8:184:8b7c:6b57:320d:f068:19c6] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m4HAg-004CuL-CT; Fri, 16 Jul 2021 06:18:16 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        kvm@vger.kernel.org
Subject: [PATCH 3/7] vgaarb: move the kerneldoc for vga_set_legacy_decoding to vgaarb.c
Date:   Fri, 16 Jul 2021 08:16:30 +0200
Message-Id: <20210716061634.2446357-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210716061634.2446357-1-hch@lst.de>
References: <20210716061634.2446357-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kerneldoc comments should be at the implementation side, not in the
header just declaring the prototype.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/gpu/vga/vgaarb.c | 11 +++++++++++
 include/linux/vgaarb.h   | 13 -------------
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index fccc7ef5153a..3ed3734f66d9 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -834,6 +834,17 @@ static void __vga_set_legacy_decoding(struct pci_dev *pdev,
 	spin_unlock_irqrestore(&vga_lock, flags);
 }
 
+/**
+ * vga_set_legacy_decoding
+ * @pdev: pci device of the VGA card
+ * @decodes: bit mask of what legacy regions the card decodes
+ *
+ * Indicates to the arbiter if the card decodes legacy VGA IOs, legacy VGA
+ * Memory, both, or none. All cards default to both, the card driver (fbdev for
+ * example) should tell the arbiter if it has disabled legacy decoding, so the
+ * card can be left out of the arbitration process (and can be safe to take
+ * interrupts at any time.
+ */
 void vga_set_legacy_decoding(struct pci_dev *pdev, unsigned int decodes)
 {
 	__vga_set_legacy_decoding(pdev, decodes, false);
diff --git a/include/linux/vgaarb.h b/include/linux/vgaarb.h
index ca5160218538..fdce9007d57e 100644
--- a/include/linux/vgaarb.h
+++ b/include/linux/vgaarb.h
@@ -46,19 +46,6 @@ struct pci_dev;
 
 /* For use by clients */
 
-/**
- *     vga_set_legacy_decoding
- *
- *     @pdev: pci device of the VGA card
- *     @decodes: bit mask of what legacy regions the card decodes
- *
- *     Indicates to the arbiter if the card decodes legacy VGA IOs,
- *     legacy VGA Memory, both, or none. All cards default to both,
- *     the card driver (fbdev for example) should tell the arbiter
- *     if it has disabled legacy decoding, so the card can be left
- *     out of the arbitration process (and can be safe to take
- *     interrupts at any time.
- */
 #if defined(CONFIG_VGA_ARB)
 extern void vga_set_legacy_decoding(struct pci_dev *pdev,
 				    unsigned int decodes);
-- 
2.30.2


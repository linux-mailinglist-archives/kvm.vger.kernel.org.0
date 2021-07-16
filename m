Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0D43CB256
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 08:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbhGPGV1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 02:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234737AbhGPGVZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 02:21:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737C2C06175F
        for <kvm@vger.kernel.org>; Thu, 15 Jul 2021 23:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=YF5b8TNXnQcbiaEvFAaNqUDv1lgagsKKhX10bSFvUTo=; b=sqNZerJ2NfaOjzmouDqVOEgUxH
        3oMlW7vdLWOG4TnyeuXQKYg2N1l5qqFACYpROZdmOPyoaqFX35AT9x2rOMe2v/Z/UKbOdhOENcdSV
        v2yInzYd3hKcOEZuzoXG2Tchc8co4oEoNEaJ20LeTASbXvnnlhztW/dilemKPiITr2/8eDWOpQq9n
        d9rIs+jaX8+oo1UrlVwdQzR4OL5gvx8Fm8U2r8ruByVCIQwqQQcvdFMtjJeXdJB73kv4Vnjy7a0KJ
        ON4N4OnkGUiSU3Y/9DVc1mEU3W5nqtMzLed1FojqNAnGuo7NOmoxFYPh04123B/rL4UKC75N/SVyg
        hhVZFMMg==;
Received: from [2001:4bb8:184:8b7c:6b57:320d:f068:19c6] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m4H9i-004CsF-5q; Fri, 16 Jul 2021 06:17:12 +0000
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
Subject: [PATCH 1/7] vgaarb: remove VGA_DEFAULT_DEVICE
Date:   Fri, 16 Jul 2021 08:16:28 +0200
Message-Id: <20210716061634.2446357-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210716061634.2446357-1-hch@lst.de>
References: <20210716061634.2446357-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The define is entirely unused.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/vgaarb.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/linux/vgaarb.h b/include/linux/vgaarb.h
index dc6ddce92066..26ec8a057d2a 100644
--- a/include/linux/vgaarb.h
+++ b/include/linux/vgaarb.h
@@ -42,12 +42,6 @@
 #define VGA_RSRC_NORMAL_IO     0x04
 #define VGA_RSRC_NORMAL_MEM    0x08
 
-/* Passing that instead of a pci_dev to use the system "default"
- * device, that is the one used by vgacon. Archs will probably
- * have to provide their own vga_default_device();
- */
-#define VGA_DEFAULT_DEVICE     (NULL)
-
 struct pci_dev;
 
 /* For use by clients */
-- 
2.30.2


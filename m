Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A52AD554C08
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 16:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357769AbiFVOBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 10:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236962AbiFVOBj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 10:01:39 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5348936E0C;
        Wed, 22 Jun 2022 07:01:38 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D673221C2A;
        Wed, 22 Jun 2022 14:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655906496; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NzekeBi4Y7KZsC56z0dvdn1JMQTC3UW1T2mc7ZG1Qag=;
        b=Q5or96XnbPgFbUBfpam2kqhkYDdnoBN/8lSPuXXtgcmbS1HLL9gqzgEP9wgi5nMjnI9knj
        FIGhRXi51pm2R7DBcLXZHHqvekcEy8SrRw9ZxNbRTLG1oRPc1VbIDJ418GalK6J2KC74wT
        tPuyBRFadtbZpGHp4Sq+O6rEgLo0m3E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655906496;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NzekeBi4Y7KZsC56z0dvdn1JMQTC3UW1T2mc7ZG1Qag=;
        b=RQKePWKJdUv87dWW2oQ6/398YRfc9wQIQATig2QDQze8Qjkeya1QVAONohAUKJD6yifrHr
        TTWYgFjOExzxdCDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8874A13AC7;
        Wed, 22 Jun 2022 14:01:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qGtiIMAgs2IVRwAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Wed, 22 Jun 2022 14:01:36 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     alex.williamson@redhat.com, corbet@lwn.net,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        airlied@linux.ie, daniel@ffwll.ch, deller@gmx.de,
        gregkh@linuxfoundation.org, javierm@redhat.com, lersek@redhat.com,
        kraxel@redhat.com
Cc:     linux-doc@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH v3 1/3] MAINTAINERS: Broaden scope of simpledrm entry
Date:   Wed, 22 Jun 2022 16:01:32 +0200
Message-Id: <20220622140134.12763-2-tzimmermann@suse.de>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220622140134.12763-1-tzimmermann@suse.de>
References: <20220622140134.12763-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There will be more DRM drivers for firmware-provided framebuffers. Use
the existing entry for simpledrm instead of adding a new one for each
driver. Also add DRM's aperture helpers, which are part of the driver's
infrastructure.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
---
 MAINTAINERS | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a0275a0b4fe6..d4c091739db2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6466,13 +6466,15 @@ S:	Orphan / Obsolete
 F:	drivers/gpu/drm/savage/
 F:	include/uapi/drm/savage_drm.h
 
-DRM DRIVER FOR SIMPLE FRAMEBUFFERS
+DRM DRIVER FOR FIRMWARE FRAMEBUFFERS
 M:	Thomas Zimmermann <tzimmermann@suse.de>
 M:	Javier Martinez Canillas <javierm@redhat.com>
 L:	dri-devel@lists.freedesktop.org
 S:	Maintained
 T:	git git://anongit.freedesktop.org/drm/drm-misc
+F:	drivers/gpu/drm/drm_aperture.c
 F:	drivers/gpu/drm/tiny/simpledrm.c
+F:	include/drm/drm_aperture.h
 
 DRM DRIVER FOR SIS VIDEO CARDS
 S:	Orphan / Obsolete
-- 
2.36.1


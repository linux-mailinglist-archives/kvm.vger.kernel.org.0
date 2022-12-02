Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE51640C76
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234382AbiLBRp4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234302AbiLBRpd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:45:33 -0500
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4110DDEA73
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:45:23 -0800 (PST)
Received: by mail-wm1-x349.google.com with SMTP id j2-20020a05600c1c0200b003cf7397fc9bso2821595wms.5
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qdGLApNIp2m2lMTsqjYlEA803gC0XNxs7/9Tj6tqLSA=;
        b=bjnibou905nzLPV3mq8fu2cP7YKBPUaCztouvWXecO2/JSqysCL2OXyhgbuYq4XBtn
         JPR+FJtGZ9/17ShTLfNiVf/UnAW7nWAjG2Euq4Cv92cKuL/MzDmBtAj0pAiVbsxbSgOQ
         CVjIpY90Od5gqO5nLD3PV6EHhAuuW427ZVf5/HS3eyndN/bAEhzzZYk10wyt8RfOkSzi
         qsC5Bea1LcFixTQYIqlfjuGDCFBIdvuBVz3lckFvuCRg4ypcfMoAjlVQUMHyQZ9NUo9W
         bs5sznFeHkl3CSZzr8Cge8ipjugfjTZA29TWpi7JBi8sXN4AbaHr/DXtaCKw3AoJ0W+N
         umPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qdGLApNIp2m2lMTsqjYlEA803gC0XNxs7/9Tj6tqLSA=;
        b=0kbS7aGA/GQcZWBbN3wVYoO+SFjR5ztHBA+LMuuFcMufg+gHMoOBoZAHupJPlBzzqR
         FDjbNqhQAAg8yEbwPufn+/JJwxwRw9OFLaJpYwdp9MQVNS9QbBEkErpLOU2aM1DQ1w6i
         pUPRdOKa0oPB7KMWBGFZ/XC6ZT/ylY/yGkTFriKuMs4fH36o2qM/65acKjz/x3Rr887v
         tu4b3rwk2G7Ny+LQULku2pvYyX3NpOkTf/6DQxjTku+rpJ3nrxPpxELNLauxEgK8LKSs
         J6OxWxkH3TR5Msgx2EUefqinhpoFoaWVmok/ZxnolMUa8TK5Nr2XtmS4OVgLxFrOrsOg
         M3IA==
X-Gm-Message-State: ANoB5pk/uWfD3dQgdxLbvHdKfoEhVI705rXxl7Y/FnXRDq9rOcPTg9kO
        44MytczrlQTV4KwuP5MQAL1HM1bg658ZD3p1Z5MNl/6EsLjo1e+2heAzhppi2uPbXjMv63g4qAx
        ZI7HBPENLhbnb+TBOOLrX8gcpzwluBZhfI9Zx7IZ08xdlL3i933t9kE4=
X-Google-Smtp-Source: AA0mqf5h2J9oFoH6OwPRKwdUMH9YrATOyswrARRBpdBZ2Q0ivPxSMzGHGfcBLerWqa/pSKgv1IwtB/BIPg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:384d:b0:3cf:7217:d5fa with SMTP id
 s13-20020a05600c384d00b003cf7217d5famr42457601wmr.191.1670003110613; Fri, 02
 Dec 2022 09:45:10 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:44:09 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-25-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 24/32] Change vesa mapping from private to shared
From:   Fuad Tabba <tabba@google.com>
To:     kvm@vger.kernel.org
Cc:     julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        alexandru.elisei@arm.com, alex.bennee@linaro.org, will@kernel.org,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Private mappings don't work with restricted memory since it
might be COWed.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 hw/vesa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/vesa.c b/hw/vesa.c
index 277d638..3233794 100644
--- a/hw/vesa.c
+++ b/hw/vesa.c
@@ -96,7 +96,7 @@ struct framebuffer *vesa__init(struct kvm *kvm)
 		goto unregister_device;
 	}
 
-	mem = mmap(NULL, VESA_MEM_SIZE, PROT_RW, MAP_PRIVATE, mem_fd, 0);
+	mem = mmap(NULL, VESA_MEM_SIZE, PROT_RW, MAP_SHARED, mem_fd, 0);
 	if (mem == MAP_FAILED) {
 		r = -errno;
 		goto close_memfd;
-- 
2.39.0.rc0.267.gcb52ba06e7-goog


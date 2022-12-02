Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98BF0640C69
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234131AbiLBRot (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:44:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234123AbiLBRoq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:44:46 -0500
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4554FDEA6C
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:44:45 -0800 (PST)
Received: by mail-wr1-x449.google.com with SMTP id d8-20020adf9b88000000b0024207f09827so1250375wrc.20
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hOL+sVrDcqcOMr65I7XMCUXkitiCQrNrGUrpvFh3Rl0=;
        b=VmxuGMHFTrgQgIJffg2d7KaBa3cmR0fXgpru0DE6RDl+yUCaWoGanpZSketZGTFfWo
         MEY2XbRdT5QtoqGWFOG88NY8mGlsE4fl+SNrtsaslqq+UehZqR28FX259ralC2j9uBpo
         hli9X+qShSrhWZFQwXn/pBjxsRctWCqKj7PdrqdAeEd+IKZJ9wBu4KXW4Pst6bh2A9MJ
         WAsgrAmJd/AvmBGcS3ACL8658rvLanngiUg6u8yfWCEsofe6xEXxQPeqoCuQAWQ2+zEQ
         aeQnok7iEb3L0fEPJafeuN2s+uN3NwGRfzR/4mYF2RzVrTU1KIJzoruie8Tg7mDfI20G
         ij2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hOL+sVrDcqcOMr65I7XMCUXkitiCQrNrGUrpvFh3Rl0=;
        b=KFdXDx9P110fUenWs+qif0Z+DMV9utxMcgYuX/AQd6RGxHA7Blq8ww3+N4T9TCJNAE
         ceSTgvQoBEX5fer1gqDwdYdaHnBxkRUuXzF5tMMC/yeIVPogHGcl3GJUMkPArgMslxbp
         RM4f25PV3/1wmohKq8yxEa7bMO/Tbmc8AUIbEtQBHPbsyXnEMBuscb4OBSoByfBaGZT2
         mvj3wXBXsaUZ0u6AqmMqXelvWKDSw337m9/0ExjWw55UX0Kk/u3hr7macQZ3aFWEqMjc
         Vivq3QfMD5Oh5Us0vTleGmVihaabqylq5cdkJHFi7Pn/UWyxj/jplScysA9w+zjHAaet
         qhVw==
X-Gm-Message-State: ANoB5plAG7fWpRGcFQ61Mqhb0NvgVbbenFzzf/wPFf/QujBeT+euQ416
        h4N48trqnc9U2P6SPEz12N7236l7zUmWsqziC+sA2qBFwvFryatHveI9kBYCh5Pdl8bPPq7htTA
        bJVwTJ2rDlE+PHY4e/v1PA8qySjDxbohbN2ke1yMSpv5vcTSGKUM0kKk=
X-Google-Smtp-Source: AA0mqf6dNQFvzbiFwI8bMWh6TgeL+CWpXRQOd7+AroRr+2f6cmSKwan9BbKD0674MDInnMaMxER7ugaAwg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6000:5c5:b0:22f:6a99:19f3 with SMTP id
 bh5-20020a05600005c500b0022f6a9919f3mr43925972wrb.165.1670003083907; Fri, 02
 Dec 2022 09:44:43 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:43:56 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-12-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 11/32] Allocate vesa memory with memfd
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

Ensure that all guest memory is fd-based.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 framebuffer.c             |  2 ++
 hw/vesa.c                 | 15 +++++++++++++--
 include/kvm/framebuffer.h |  1 +
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/framebuffer.c b/framebuffer.c
index fb8f51d..a025293 100644
--- a/framebuffer.c
+++ b/framebuffer.c
@@ -73,6 +73,8 @@ int fb__exit(struct kvm *kvm)
 				fb->targets[i]->stop(fb);
 
 		munmap(fb->mem, fb->mem_size);
+		if (fb->mem_fd >= 0)
+			close(fb->mem_fd);
 	}
 
 	return 0;
diff --git a/hw/vesa.c b/hw/vesa.c
index 7f82cdb..522ffa3 100644
--- a/hw/vesa.c
+++ b/hw/vesa.c
@@ -41,6 +41,7 @@ static struct framebuffer vesafb = {
 	.depth		= VESA_BPP,
 	.mem_addr	= VESA_MEM_ADDR,
 	.mem_size	= VESA_MEM_SIZE,
+	.mem_fd		= -1,
 };
 
 static void vesa_pci_io(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
@@ -66,6 +67,7 @@ struct framebuffer *vesa__init(struct kvm *kvm)
 {
 	u16 vesa_base_addr;
 	char *mem;
+	int mem_fd;
 	int r;
 
 	BUILD_BUG_ON(!is_power_of_two(VESA_MEM_SIZE));
@@ -88,22 +90,31 @@ struct framebuffer *vesa__init(struct kvm *kvm)
 	if (r < 0)
 		goto unregister_ioport;
 
-	mem = mmap(NULL, VESA_MEM_SIZE, PROT_RW, MAP_ANON_NORESERVE, -1, 0);
-	if (mem == MAP_FAILED) {
+	mem_fd = memfd_alloc(ARM_PVTIME_SIZE, false, 0, 0);
+	if (mem_fd < 0) {
 		r = -errno;
 		goto unregister_device;
 	}
 
+	mem = mmap(NULL, VESA_MEM_SIZE, PROT_RW, MAP_PRIVATE, mem_fd, 0);
+	if (mem == MAP_FAILED) {
+		r = -errno;
+		goto close_memfd;
+	}
+
 	r = kvm__register_dev_mem(kvm, VESA_MEM_ADDR, VESA_MEM_SIZE, mem);
 	if (r < 0)
 		goto unmap_dev;
 
 	vesafb.mem = mem;
+	vesafb.mem_fd = mem_fd;
 	vesafb.kvm = kvm;
 	return fb__register(&vesafb);
 
 unmap_dev:
 	munmap(mem, VESA_MEM_SIZE);
+close_memfd:
+	close(mem_fd);
 unregister_device:
 	device__unregister(&vesa_device);
 unregister_ioport:
diff --git a/include/kvm/framebuffer.h b/include/kvm/framebuffer.h
index e3200e5..c340273 100644
--- a/include/kvm/framebuffer.h
+++ b/include/kvm/framebuffer.h
@@ -22,6 +22,7 @@ struct framebuffer {
 	char				*mem;
 	u64				mem_addr;
 	u64				mem_size;
+	int				mem_fd;
 	struct kvm			*kvm;
 
 	unsigned long			nr_targets;
-- 
2.39.0.rc0.267.gcb52ba06e7-goog


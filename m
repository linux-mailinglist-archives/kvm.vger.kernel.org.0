Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59838629707
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 12:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbiKOLQo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 06:16:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiKOLQQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 06:16:16 -0500
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C095FAA
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:16:15 -0800 (PST)
Received: by mail-wm1-x349.google.com with SMTP id u9-20020a05600c00c900b003cfb12839d6so3664555wmm.5
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IOlnWRW2tAFQ5q+3RbVn/g3jOsn3BcEoAmGRbW4y3Sc=;
        b=cRTT7FmrUcUcNEWFAa1X868DOxSsppIh+SyOm+tP+0wPPmhMYg4CXwAzjYZNQrf8Ay
         f+4qQP2DEfbUxzLgOoW8KF5W9utjfEQSyxBzAm1pdmnWjjWvpqL1Kxhji2+ezVzmde18
         dyFMqiZEB4cj71oPlHnxjT7b+YUEnJRH1fO7izSI0RVvGreIdS1HNzQnWRxIaSNYKKsm
         SCvOBCw33L47YfXdEtr8vHSJ7fkkr6uxVjrxR3MewQwsoo5U+YYGd0rSFzDcs4DE0FVG
         JeqyhnYkiWcp54jgk7R1jE3thCUvIw6wU/w6LRPBPLcuM+0Zk6lUeHeY/6jHBJ6i0G3c
         l8hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IOlnWRW2tAFQ5q+3RbVn/g3jOsn3BcEoAmGRbW4y3Sc=;
        b=4GTBHCVrayOUBjk6ejkABPp6tQ1Mvpkm52lq2lpBGooG02OLoDPFEdp4GPC2XBVbi1
         avsiAiAS6NIAE9obS7Cr7Ve2Ivwaoin910WVvgm2/OH8fdCCUQERNiMMUviyZ6JhCWKj
         MkVyKlLlrAis0oJf50b2iEiRZJO+ro7o707b7HZFkYsHTsKsyh7cQGoy+IC4QN0g0Q9N
         ojB9xkuHMZNUzxoEP4Wlb5TI7oiOl+tjZKOWRk7BqrGsOrg5TVmLOln/xadCKPw8n/qp
         xb+tHR1cw4HU0BPJzbhqynse11Vp4R5cLLpBrtP/v/4DxMhwBEksun4BvRLUzPsa/PjD
         178A==
X-Gm-Message-State: ANoB5pkK6gt96geAehbUFsADJT23O2BLE+NHeHqX46cwPeltmdZWzVnI
        8xHRAzLGqDzXtTqi2D2vaI1udFfZJKO8b6TFMOXHDGtxrnPIakhPPvH1ud0KfNLvEXwhFlhXeUN
        Agjl0Hdm/zt/gbThTxIQwmYViOHShWrH+CrN23pTVTFmT9S1qC/ZxNes=
X-Google-Smtp-Source: AA0mqf6VGAgxpyvtv2yP0V7yDiDmmgBgURvRdQwSSoc5dpPVgUgfygd5TDuKQhKBfMRZsJB08qvqeHN+nQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:310c:b0:3cf:d58f:f66e with SMTP id
 g12-20020a05600c310c00b003cfd58ff66emr98626wmo.165.1668510973867; Tue, 15 Nov
 2022 03:16:13 -0800 (PST)
Date:   Tue, 15 Nov 2022 11:15:42 +0000
In-Reply-To: <20221115111549.2784927-1-tabba@google.com>
Mime-Version: 1.0
References: <20221115111549.2784927-1-tabba@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115111549.2784927-11-tabba@google.com>
Subject: [PATCH kvmtool v1 10/17] Allocate vesa memory with memfd
From:   Fuad Tabba <tabba@google.com>
To:     kvm@vger.kernel.org
Cc:     julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        alexandru.elisei@arm.com, will@kernel.org, tabba@google.com
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
2.38.1.431.g37b22c650d-goog


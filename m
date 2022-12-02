Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA53A640C79
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234256AbiLBRp7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234250AbiLBRpe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:45:34 -0500
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1312CE1193
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:45:24 -0800 (PST)
Received: by mail-wm1-x349.google.com with SMTP id e8-20020a05600c218800b003cf634f5280so2192654wme.8
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IDYXn6TvCy+Qfe8MDP2oOQsNsQcYdi8tVtAq7gLMUyI=;
        b=CnL3sC9ZmTnlMZxSSixGhu19a5LsbZ6biR1xoPDlNT35BwgU04HngvN7WJ+wQik+at
         o3MDTMU4R0msFLhP3BbTweU38E6RFl8P/jtvOtVGUgInH0PYINV9K6ColCkur4MjnAfY
         hfP31jsxTqymhtl1WWw499KdxkWj/Sqt997buq7hm/MK1MGO9hq5xIhDXdowngwEo6Jx
         eS1qp/gxwChmF4nb+PTOUiY2XfT33HiSpaxWNvDqewZOb5oqW+WSk8Mt2KsCWxaiZlBe
         795ldkAQVB9BbU4iBql5AerlP/Y4XoWCDOItIdz6/Q/tAlmVKk5K7zIQCxjZ5SMVsXR5
         QP+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IDYXn6TvCy+Qfe8MDP2oOQsNsQcYdi8tVtAq7gLMUyI=;
        b=mH3Qe2QGj8e2A3RnV7BtwgwF1Ot58/ESws6IvlnShrTd9dnC81Ev2C06PhkH3le2C2
         nDZxUA+ViC9xr0OSCSP7YYJNAHmVuwakQE/O0/zBn01DTKVI8Ai++lPXkDkKz5EgXYY2
         jgSJmd8vdjmAubxcuzPlG4BBVNe+1J9oDR3l3sYVBrOAD5kkGKuY+G8YZxbnLpcqrEY0
         ndI8/ktCV8v8o2ICPetCu9OSM/3E8gkPQF+vjHyqUz0eRcxSNQQ49/U2JhiK79s7SrCs
         ey2mBVAK3CchaPYnpuWM4HmF9bzg2VoXHRQuk6bMIOU/NqpvDWc6F4Dpb7N4p4Hd5c4Y
         jRwA==
X-Gm-Message-State: ANoB5pmlb8rjNmlU94oFLigUKd16ubat6aa+ybiD7VS6ha6N6P3xsM6S
        FeTXYSnICqXWYDXJQhSiEYupdOGguNZvsViNTioIACMpa8UkS0Utjx/Edpz7raQFBZH0T1VP7Ow
        yXFf98sP0nOtvyERDsD+Pm7r+oOTIqi2k2zpFF53IRSv8SCSB0lRYzIs=
X-Google-Smtp-Source: AA0mqf6E0qTTu0wHO5cJHBdjbupuRhEbWTzk2fj19cl67v6+/R0Gl4kveBNeC3HAZzJxP/9NzGA6V3aLzA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:53cd:0:b0:242:47b9:7ad6 with SMTP id
 a13-20020a5d53cd000000b0024247b97ad6mr1956636wrw.93.1670003114911; Fri, 02
 Dec 2022 09:45:14 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:44:11 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-27-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 26/32] Use the new fd-based extended memory region
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

If restricted guest memory is enabled, use the new extended guest
memory region interface to pass the guest memory to kvm using the
restricted file descriptor.

In the future, pKVM will require this, and the successor of patch
will instead force the use of restricted guest memory for pKVM
(and other potential environments) that require restricted memory.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 kvm.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 49 insertions(+), 5 deletions(-)

diff --git a/kvm.c b/kvm.c
index fc0bfc4..bde6708 100644
--- a/kvm.c
+++ b/kvm.c
@@ -214,6 +214,41 @@ static int set_user_memory_region(int vm_fd, u32 slot, u32 flags,
 	return ret;
 }
 
+static int set_user_memory_region_ext(int vm_fd, u32 slot, u32 flags,
+				  u64 guest_phys, u64 size,
+				  u64 userspace_addr, u32 fd, u64 offset)
+{
+	int ret = 0;
+	struct kvm_enc_region range;
+	struct kvm_userspace_memory_region_ext mem = {
+		.region = {
+			.slot			= slot,
+			.flags			= flags,
+			.guest_phys_addr	= guest_phys,
+			.memory_size		= size,
+			.userspace_addr		= 0,
+		},
+		.restricted_fd = fd,
+		.restricted_offset = offset,
+	};
+
+	ret = ioctl(vm_fd, KVM_SET_USER_MEMORY_REGION, &mem);
+	if (ret < 0) {
+		ret = -errno;
+		goto out;
+	}
+
+	/* Inform KVM that the region is protected. */
+	range.addr = guest_phys;
+	range.size = size;
+	ret = ioctl(vm_fd, KVM_MEMORY_ENCRYPT_REG_REGION, &range);
+	if (ret)
+		ret = -errno;
+
+out:
+	return ret;
+}
+
 int kvm__destroy_mem(struct kvm *kvm, u64 guest_phys, u64 size,
 		     void *userspace_addr)
 {
@@ -240,8 +275,13 @@ int kvm__destroy_mem(struct kvm *kvm, u64 guest_phys, u64 size,
 		goto out;
 	}
 
-	ret = set_user_memory_region(kvm->vm_fd, bank->slot, 0, guest_phys, 0,
-				     (u64) userspace_addr);
+	if (kvm->cfg.restricted_mem)
+		ret = set_user_memory_region_ext(kvm->vm_fd, bank->slot,
+			KVM_MEM_PRIVATE, guest_phys, 0, (u64) userspace_addr,
+			0, 0);
+	else
+		ret = set_user_memory_region(kvm->vm_fd, bank->slot, 0,
+			guest_phys, 0, (u64) userspace_addr);
 	if (ret < 0)
 		goto out;
 
@@ -339,9 +379,13 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
 		flags |= KVM_MEM_READONLY;
 
 	if (type != KVM_MEM_TYPE_RESERVED) {
-		ret = set_user_memory_region(kvm->vm_fd, slot, flags,
-					     guest_phys, size,
-					     (u64) userspace_addr);
+		if (kvm->cfg.restricted_mem)
+			ret = set_user_memory_region_ext(kvm->vm_fd, slot,
+				flags | KVM_MEM_PRIVATE, guest_phys, size,
+				(u64) userspace_addr, memfd, offset);
+		else
+			ret = set_user_memory_region(kvm->vm_fd, slot, flags,
+				guest_phys, size, (u64) userspace_addr);
 		if (ret < 0)
 			goto out;
 	}
-- 
2.39.0.rc0.267.gcb52ba06e7-goog


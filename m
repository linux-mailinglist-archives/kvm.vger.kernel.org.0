Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E407640C7D
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234359AbiLBRqG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:46:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234324AbiLBRpi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:45:38 -0500
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720E4E11A0
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:45:28 -0800 (PST)
Received: by mail-wm1-x349.google.com with SMTP id e8-20020a05600c218800b003cf634f5280so2192716wme.8
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ojAIDneqly7urLUtSI7yC5BejOF4LmcYgz67ETGcXNg=;
        b=RmDaW5xV98br0A+I4X8nKQxFUMHcQ4sapYf//UkOuibrJ4ua7j1fQCu2bYFjRdA8U/
         wNSnbd7QE+2N/tk/XGm6BivQSSt4NUWaPByzCCo3ka8PquxmrOYB0UuQGfU6L2SdyEz+
         w5DF8XEzwE/qgKZXXOFHgIhChTWZi+9Q05N5ls991gR2B32YT0w85kosnI03mSyeb8Rh
         fbL7o4lbelQ619nvM4FymGDHa09fN9gLj6eIzVHUBQdh8HYiyCu6/gGkrgoFAEGNDEqf
         9fzelRXfVj3WS86nxjk0IeJBBD/EwWOIn6Q8yAZs+eiQYuxcOKRnU0XZhJGuBDNoIcDo
         MFrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ojAIDneqly7urLUtSI7yC5BejOF4LmcYgz67ETGcXNg=;
        b=5TieTwZN0q4Tv0Nvyf3BK8RwQFlcfDyCqIwuOldIowfxjFeX7C5lsW3ysFHdQ/rixH
         Yaf6Z4CxnnAvXJDWHwrLCNBPkYE5eobYJ74FcIqruoZkv8RwULOEX8VxNVttqc+VfW5d
         pqeIloqglB7zRlqplxHWLpoWJCyw+qzL5TjW4BeaWrYMhCik9mUw6IMxso3eCTZIsm6X
         B07/5eBuzy1CG/e/2wABUVNWrsmOHwIsbWwBufE7ZAYtfqJSs0lLGmpGdaJ9Ox6fRH8Z
         W417LuAbBwd9YnXrfoMIqIAC6g6yDoouIlJp//LyxzLoT8V6AcoFEDpHpLSyaALYx89U
         ZY3w==
X-Gm-Message-State: ANoB5pnLKKHFyH2kBRF7oLQyckOISqdKyB94wP35luFVsHRlajgeLHVt
        dz9hq6fZxhHh7fN/IqtrqJlpPqqIR72QL88aouvI55myeor0VNYuNVugcREUuFQyPotirw2EpSm
        aJsGBpRbdFbP2FpUtnO1NLDz/RQPZpdhZkPRUot6ttCF7cwLhlm8ZJO8=
X-Google-Smtp-Source: AA0mqf67b6YUTuw8IVvtFaKeWF+h7bmEauUlGhv/RG/zZjeABDv6PvbgtnybGDhOcsvkYqOIgpKrPhG2jQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:6888:b0:3d0:7513:d149 with SMTP id
 fn8-20020a05600c688800b003d07513d149mr9595758wmb.156.1670003118948; Fri, 02
 Dec 2022 09:45:18 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:44:13 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-29-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 28/32] Add functions for mapping/unmapping
 guest memory
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

Host shouldn't map guest memory not shared with it. These
functions allow kvmtool in a future patch to toggle the mapping
depending on the sharing status, even if it changes.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/kvm/kvm.h |   4 +
 kvm.c             | 183 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 187 insertions(+)

diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 6192f6c..66b5664 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -220,6 +220,10 @@ static inline bool kvm__arch_has_cfg_ram_address(void)
 
 void *guest_flat_to_host(struct kvm *kvm, u64 offset);
 u64 host_to_guest_flat(struct kvm *kvm, void *ptr);
+void map_guest_range(struct kvm *kvm, u64 gpa, u64 size);
+void unmap_guest_range(struct kvm *kvm, u64 gpa, u64 size);
+void map_guest(struct kvm *kvm);
+void unmap_guest(struct kvm *kvm);
 
 bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 				 const char *kernel_cmdline);
diff --git a/kvm.c b/kvm.c
index a0bddf4..66e6a8e 100644
--- a/kvm.c
+++ b/kvm.c
@@ -462,6 +462,189 @@ int kvm__for_each_mem_bank(struct kvm *kvm, enum kvm_mem_type type,
 	return ret;
 }
 
+static void *_mmap(void *addr, size_t len, int prot, int flags, int fd, off_t offset)
+{
+	return mmap(addr, len, prot, flags | MAP_FIXED, fd, offset);
+}
+
+static int _munmap(void *addr, size_t len)
+{
+	if (mmap(addr, len, PROT_NONE, MAP_SHARED | MAP_FIXED | MAP_ANON, -1, 0) != MAP_FAILED)
+		return 0;
+
+	return -EFAULT;
+}
+
+struct bank_range {
+	u64 gpa;
+	u64 size;
+};
+
+static bool is_bank_range(struct kvm_mem_bank *bank, struct bank_range *range)
+{
+	u64 bank_start = bank->guest_phys_addr;
+	u64 bank_end = bank_start + bank->size;
+	u64 gpa_end = range->gpa + range->size;
+
+	if (range->gpa < bank_start || range->gpa >= bank_end)
+		return false;
+
+	if (gpa_end > bank_end || gpa_end <= bank_start) {
+		pr_warning("%s invalid guest range", __func__);
+		return false;
+	}
+
+	return true;
+}
+
+static int map_bank_range(struct kvm *kvm, struct kvm_mem_bank *bank, void *data)
+{
+	struct bank_range *range = data;
+	u64 gpa_offset;
+	u64 map_offset;
+	u64 hva;
+	void *mapping;
+
+	if (!is_bank_range(bank, range))
+		return 0;
+
+	gpa_offset = range->gpa - bank->guest_phys_addr;
+	map_offset = bank->memfd_offset + gpa_offset;
+	hva = (u64) bank->host_addr + gpa_offset;
+
+	BUG_ON(map_offset > bank->memfd_offset + bank->size);
+	BUG_ON(map_offset < bank->memfd_offset);
+	BUG_ON(hva < (u64)bank->host_addr);
+	BUG_ON(!bank->memfd);
+
+	mapping = _mmap((void *)hva, range->size, PROT_RW, MAP_SHARED, bank->memfd, map_offset);
+	if (mapping == MAP_FAILED || mapping != (void *)hva)
+		pr_warning("%s gpa 0x%llx (size: %llu) at hva 0x%llx failed with mapping 0x%llx",
+			   __func__,
+			   (unsigned long long)range->gpa,
+			   (unsigned long long)range->size,
+			   (unsigned long long)hva,
+			   (unsigned long long)mapping);
+
+	/* Do not proceed to trying to map the other banks. */
+	return 1;
+}
+
+static int unmap_bank_range(struct kvm *kvm, struct kvm_mem_bank *bank, void *data)
+{
+	struct bank_range *range = data;
+	u64 gpa_offset;
+	u64 hva;
+	int ret;
+
+	if (!is_bank_range(bank, range))
+		return 0;
+
+	gpa_offset = range->gpa - bank->guest_phys_addr;
+	hva = (u64)bank->host_addr + gpa_offset;
+
+	BUG_ON(hva < (u64)bank->host_addr);
+	BUG_ON(!bank->memfd);
+
+	ret = _munmap((void *)hva, range->size);
+	if (ret)
+		pr_warning("%s gpa 0x%llx (size: %llu) at hva 0x%llx failed with error %d",
+			 __func__,
+			 (unsigned long long)range->gpa,
+			 (unsigned long long)range->size,
+			 (unsigned long long)hva,
+			 ret);
+
+	/* Do not proceed to trying to unmap the other banks. */
+	return 1;
+}
+
+static int map_bank(struct kvm *kvm, struct kvm_mem_bank *bank, void *data)
+{
+	void *mapping;
+
+	BUG_ON(!bank->memfd);
+
+	pr_debug("%s hva 0x%llx (size: %llu) of memfd %d (offset %llu)",
+		 __func__,
+		 (unsigned long long)bank->host_addr,
+		 (unsigned long long)bank->size,
+		 bank->memfd,
+		 (unsigned long long)bank->memfd_offset);
+
+	mapping = _mmap(bank->host_addr, bank->size, PROT_RW, MAP_SHARED, bank->memfd, bank->memfd_offset);
+	if (!mapping || mapping != bank->host_addr)
+		pr_warning("%s hva 0x%llx (size: %llu) failed with return 0x%llx",
+			   __func__,
+			   (unsigned long long)bank->host_addr,
+			   (unsigned long long)bank->size,
+			   (unsigned long long)mapping);
+	return 0;
+}
+
+static int unmap_bank(struct kvm *kvm, struct kvm_mem_bank *bank, void *data)
+{
+	int ret;
+
+	pr_debug("%s hva 0x%llx (size: %llu)",
+		 __func__,
+		 (unsigned long long)bank->host_addr,
+		 (unsigned long long)bank->size);
+
+	ret = _munmap(bank->host_addr, bank->size);
+	if (ret)
+		pr_warning("%s hva 0x%llx (size: %llu) failed with error %d",
+			   __func__,
+			   (unsigned long long)bank->host_addr,
+			   (unsigned long long)bank->size,
+			   ret);
+	return 0;
+}
+
+void map_guest_range(struct kvm *kvm, u64 gpa, u64 size)
+{
+	struct bank_range range = { .gpa = gpa, .size = size };
+	int ret;
+
+	ret = kvm__for_each_mem_bank(kvm, KVM_MEM_TYPE_RAM|KVM_MEM_TYPE_DEVICE,
+				     map_bank_range, &range);
+
+	if (!ret)
+		pr_warning("%s gpa 0x%llx (size: %llu) found no matches",
+			   __func__,
+			   (unsigned long long)gpa,
+			   (unsigned long long)size);
+}
+
+void unmap_guest_range(struct kvm *kvm, u64 gpa, u64 size)
+{
+	struct bank_range range = { .gpa = gpa, .size = size };
+	int ret;
+
+	ret = kvm__for_each_mem_bank(kvm, KVM_MEM_TYPE_RAM|KVM_MEM_TYPE_DEVICE,
+				     unmap_bank_range, &range);
+
+	if (!ret)
+		pr_warning("%s gpa 0x%llx (size: %llu) found no matches",
+			   __func__,
+			   (unsigned long long)gpa,
+			   (unsigned long long)size);
+
+	return;
+}
+
+void map_guest(struct kvm *kvm)
+{
+	kvm__for_each_mem_bank(kvm, KVM_MEM_TYPE_RAM|KVM_MEM_TYPE_DEVICE,
+			       map_bank, NULL);
+}
+
+void unmap_guest(struct kvm *kvm)
+{
+	kvm__for_each_mem_bank(kvm, KVM_MEM_TYPE_RAM|KVM_MEM_TYPE_DEVICE,
+			       unmap_bank, NULL);
+}
+
 int kvm__recommended_cpus(struct kvm *kvm)
 {
 	int ret;
-- 
2.39.0.rc0.267.gcb52ba06e7-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75BA629704
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 12:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiKOLQh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 06:16:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiKOLQF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 06:16:05 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7720ECE32
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:16:03 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-352e29ff8c2so134187127b3.21
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:16:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l4S0tjXl5OOwn+z7QW2vWgpLSdRiAzoEj1Tb/VWK9Zs=;
        b=kfzrhi1GHeIjfa32c6SZkj8M3TIE/5eqQVyQZ/Zl0EqYd8LhnQHQmkanHYkchhYuXt
         PfK3SGMD7vw12VSNUtDxLKEfyS/MfuN2Jw9naBClPy2zt3trVqCx+zjN4rVw3EbGooXd
         UlQx77yNnjxQXyMXRrNdAodYslWXJTAT0spmvS1MC49N9g1UFX4oCchkd8UP8+MqSd2Z
         RgCsy2uGFnTJWg2WekKqIUZyobJJy8vdqjOX5KIOqM/ENBIPMhZKvFkOl1f9Y/oijvGH
         ruCvsZaDOeab375jOh+vIs7ncFVkHuJP0VSVqw+eEz8VtIuHl/pZVStRtDKYD9wDnnbn
         nUXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l4S0tjXl5OOwn+z7QW2vWgpLSdRiAzoEj1Tb/VWK9Zs=;
        b=HPv5XDrhNpUvWHOGSGuDD46XDaugkIWKoAXz3VF3lpqXD60MJBE6MqjXDyA0iM3D2b
         HZTvALvpjHqRHHl8SiZmXKRj741QkaDAiTMFRTkNMQgvA3nQ9hL5LniGugXlGmQOBjAX
         fXeQuf5aIokE+IbCVQ9mwBb1vm0bowMeb/19LEUETujC/hcmuDXPnPPINkyy04wmBK4X
         eWeJad+ZHUR71GDR9077HIL3MAN7iTGCHSZ4EAozvnD7H/hfXydOeHPkF14lwCiP/oIn
         9VrlRK4dr00lAVTUcHldLai6ADGz/8fKWTmQ8frE4DS5CqV1BacG5aAqN1eTdbPVTwRx
         47sw==
X-Gm-Message-State: ANoB5pkKEBlJqwOVXxjVZ936GG3fO5RgkuiJnAMpqt1Wr9uGvog/cSXv
        Ry7aZBZJFqRkPNTrs0OPvycJG7xq90WZkLy+ZzodaWxlUFXQWdqcK+CjNdPP0DaFAGjpkLzWud1
        h7EGAqSie5sIFRNmylC0JnijkUpYBA4iOQeasUH8ltw52/3z9Ig1qrxg=
X-Google-Smtp-Source: AA0mqf5DB6EGMC9wDQymh6JZnGH2RPp8LALO6BEm7DczaUUKU9ahmapd+kHAplLwvZTsHedP+slBrRHstQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1244:b0:6d5:6914:2ceb with SMTP id
 t4-20020a056902124400b006d569142cebmr28005286ybu.599.1668510962006; Tue, 15
 Nov 2022 03:16:02 -0800 (PST)
Date:   Tue, 15 Nov 2022 11:15:37 +0000
In-Reply-To: <20221115111549.2784927-1-tabba@google.com>
Mime-Version: 1.0
References: <20221115111549.2784927-1-tabba@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115111549.2784927-6-tabba@google.com>
Subject: [PATCH kvmtool v1 05/17] Factor out getting the hugetlb block size
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

This functionality will be needed separately in a future patch.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 util/util.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/util/util.c b/util/util.c
index 22b64b6..e6c0951 100644
--- a/util/util.c
+++ b/util/util.c
@@ -81,13 +81,9 @@ void die_perror(const char *s)
 	exit(1);
 }
 
-static void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
+static u64 get_hugepage_blk_size(const char *htlbfs_path)
 {
-	char mpath[PATH_MAX];
-	int fd;
 	struct statfs sfs;
-	void *addr;
-	unsigned long blk_size;
 
 	if (statfs(htlbfs_path, &sfs) < 0)
 		die("Can't stat %s\n", htlbfs_path);
@@ -95,10 +91,20 @@ static void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
 	if ((unsigned int)sfs.f_type != HUGETLBFS_MAGIC)
 		die("%s is not hugetlbfs!\n", htlbfs_path);
 
-	blk_size = (unsigned long)sfs.f_bsize;
-	if (sfs.f_bsize == 0 || blk_size > size) {
-		die("Can't use hugetlbfs pagesize %ld for mem size %lld\n",
-			blk_size, (unsigned long long)size);
+	return sfs.f_bsize;
+}
+
+static void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
+{
+	char mpath[PATH_MAX];
+	int fd;
+	void *addr;
+	u64 blk_size;
+
+	blk_size = get_hugepage_blk_size(htlbfs_path);
+	if (blk_size == 0 || blk_size > size) {
+		die("Can't use hugetlbfs pagesize %lld for mem size %lld\n",
+			(unsigned long long)blk_size, (unsigned long long)size);
 	}
 
 	kvm->ram_pagesize = blk_size;
-- 
2.38.1.431.g37b22c650d-goog


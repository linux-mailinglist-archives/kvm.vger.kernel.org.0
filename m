Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A317874FD70
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 05:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbjGLDIp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 23:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjGLDIl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 23:08:41 -0400
Received: from mail.208.org (unknown [183.242.55.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCFA1712
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 20:08:40 -0700 (PDT)
Received: from mail.208.org (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTP id 4R12kT03smzBS5pn
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 11:08:32 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
        content-transfer-encoding:content-type:message-id:user-agent
        :references:in-reply-to:subject:to:from:date:mime-version; s=
        dkim; t=1689131312; x=1691723313; bh=0CcwIDO4opsdPdT4gBowEy44D9V
        0u/t38EtRWkFSWAU=; b=bBnaNlAQyesxeAgkFte1OKh/5DV8Hu3PWYdRzp2uaq4
        w2kmA40H/ylOK1VsSZW25+dcB61IxoDF/JkvVj/51aGn6D0jDFkjqonHG9SlsVob
        z4xm5FFk8KHYkK/6hfPULHVr5HcAmguBq2isZErHNIq0AIu9k+KtRXb3+cMtJMTl
        zbF3s3MN9p3ZYd8u2lV08PLWnjGnJt5CmbIfCnr36bKDdCAeEarciwML0Oh6gSvo
        JZEdsyZ2LlvZIVr0DjSniZR7/B3wxVPiIzxDwwXQV10AJubMJRNafBFuRW0GRAxi
        FixeLcVTuPyU0nfaHb1MIPnUXoDnbLqK8hUfQqnqUKw==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
        by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id GL8J6lyVmIUM for <kvm@vger.kernel.org>;
        Wed, 12 Jul 2023 11:08:32 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTPSA id 4R12kS3r3pzBJ8lQ;
        Wed, 12 Jul 2023 11:08:32 +0800 (CST)
MIME-Version: 1.0
Date:   Wed, 12 Jul 2023 11:08:32 +0800
From:   shijie001@208suo.com
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org
Cc:     hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86:Fix warnings in debugfs.c
In-Reply-To: <tencent_5FEF30EB273BF931FF82DB522CA8CB13A307@qq.com>
References: <tencent_5FEF30EB273BF931FF82DB522CA8CB13A307@qq.com>
User-Agent: Roundcube Webmail
Message-ID: <d02e47813a9b22b2c625caf8ac5ae0fb@208suo.com>
X-Sender: shijie001@208suo.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RDNS_NONE,SPF_HELO_FAIL,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following checkpatch warning is removed:
WARNING: Prefer seq_puts to seq_printf

Signed-off-by: Jie Shi <shijie001@208suo.com>
---
  arch/x86/kvm/debugfs.c | 6 +++---
  1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index ee8c4c3496ed..a3e118397aa3 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -133,20 +133,20 @@ static int kvm_mmu_rmaps_stat_show(struct seq_file 
*m, void *v)
      mutex_unlock(&kvm->slots_lock);

      /* index=0 counts no rmap; index=1 counts 1 rmap */
-    seq_printf(m, "Rmap_Count:\t0\t1\t");
+    seq_puts(m, "Rmap_Count:\t0\t1\t");
      for (i = 2; i < RMAP_LOG_SIZE; i++) {
          j = 1 << (i - 1);
          k = (1 << i) - 1;
          seq_printf(m, "%d-%d\t", j, k);
      }
-    seq_printf(m, "\n");
+    seq_puts(m, "\n");

      for (i = 0; i < KVM_NR_PAGE_SIZES; i++) {
          seq_printf(m, "Level=%s:\t", kvm_lpage_str[i]);
          cur = log[i];
          for (j = 0; j < RMAP_LOG_SIZE; j++)
              seq_printf(m, "%d\t", cur[j]);
-        seq_printf(m, "\n");
+        seq_puts(m, "\n");
      }

      ret = 0;

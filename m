Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C34C4CC540
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 19:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233906AbiCCSeW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 13:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234176AbiCCSeV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 13:34:21 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F7710DA48
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 10:33:35 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id a23-20020aa794b7000000b004f6a3ac7a87so558182pfl.23
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 10:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/CVFzv1lHijKVsu+/AwQgOYGzYLObEY8ntA0I+2sSps=;
        b=Khsmzsfc1QvIRgHVwAaP4/9i/urdGO/czx0ewLL6zD2iAcufM3L7VPmGFlz1rsHbau
         lkV0Al6qGPDlIB1neIIOdDF1fYNdqG/YKl3OpJ6rhECIlYvVI9vFuL7SYjAmi2zHzrSs
         Sk7gzohvSSVfyEeqIoujxPWsU61byCVmw4B8E7jWrPi4Q4BKqibBRc7K4xLNN5Y0Huv+
         DCToGPhKJW0yGZdCiCKQ1X+cQc3/PP1BSoJmofeOsAL/77HeAJsbPffRvCD4JtDyraWT
         WbtyRWHlwLQl+jCExGTMEI5Q8XyUeTar6MSGqmd3gGJVLoevuyMprsntksVZ2f7ZqLh4
         i45g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/CVFzv1lHijKVsu+/AwQgOYGzYLObEY8ntA0I+2sSps=;
        b=G7Q0ZX96Bz8pmu4wdc55Fa0HiNnGIRUBkcGEq3jktTrSv+QyD/M1WjwCvwh7wQAR02
         q8tZYss3tKOnutWyq/5hH360mUPVQZN/nXYkYzOrHiKRdrwlsshuUm6Qgmnm8RfUaF0h
         lhdw0K0VcHkiXoz4BY02MyCP4Xlf1Qwzcx+wWwM3lBlvEfcvuX23VdD97NMosG9fNhAP
         A2ucl3QyJUmo8JoXxB5DLxkq4Y72HWK3nQGsYPoopj7wk6KDcnGqQgV1vHw5CMrpQytH
         NT+Or6vbJZGltkzEijya6D9AtsJM73bhMbv4swJblyfUB3XqvM1vo+ez7gbuggej/22S
         Fh1g==
X-Gm-Message-State: AOAM530L6Q2Me1Tc5I7LssLqX1UvjBLmmzSWI9NTMiiM1lPYeMt95KJ4
        XJ8petjSFlR1r+g+fIuMxGI+qYhJq1i1XA==
X-Google-Smtp-Source: ABdhPJy+QHJPjKpeGkvtBVOpW7PD7zxKVT+82Aq+GD5zKBbdDS9NteFjpSKrQA3Iit6MJIIjNrJ1mYl6cz68mg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:7610:b0:151:6152:549c with SMTP
 id k16-20020a170902761000b001516152549cmr23663447pll.91.1646332414548; Thu,
 03 Mar 2022 10:33:34 -0800 (PST)
Date:   Thu,  3 Mar 2022 18:33:28 +0000
In-Reply-To: <20220303183328.1499189-1-dmatlack@google.com>
Message-Id: <20220303183328.1499189-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20220303183328.1499189-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH RESEND 2/2] Revert "KVM: set owner of cpu and vm file operations"
From:   David Matlack <dmatlack@google.com>
To:     pbonzini@redhat.com
Cc:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, Rik van Riel <riel@redhat.com>,
        seanjc@google.com, bgardon@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This reverts commit 3d3aab1b973b01bd2a1aa46307e94a1380b1d802.

Now that the KVM module's lifetime is tied to kvm.users_count, there is
no need to also tie it's lifetime to the lifetime of the VM and vCPU
file descriptors.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 virt/kvm/kvm_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b59f0a29dbd5..73b8f70e16cc 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3684,7 +3684,7 @@ static int kvm_vcpu_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static struct file_operations kvm_vcpu_fops = {
+static const struct file_operations kvm_vcpu_fops = {
 	.release        = kvm_vcpu_release,
 	.unlocked_ioctl = kvm_vcpu_ioctl,
 	.mmap           = kvm_vcpu_mmap,
@@ -4735,7 +4735,7 @@ static long kvm_vm_compat_ioctl(struct file *filp,
 }
 #endif
 
-static struct file_operations kvm_vm_fops = {
+static const struct file_operations kvm_vm_fops = {
 	.release        = kvm_vm_release,
 	.unlocked_ioctl = kvm_vm_ioctl,
 	.llseek		= noop_llseek,
@@ -5744,8 +5744,6 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 		goto out_free_5;
 
 	kvm_chardev_ops.owner = module;
-	kvm_vm_fops.owner = module;
-	kvm_vcpu_fops.owner = module;
 
 	r = misc_register(&kvm_dev);
 	if (r) {
-- 
2.35.1.616.g0bdcbb4464-goog


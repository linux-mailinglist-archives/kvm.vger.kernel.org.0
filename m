Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 886924D3C18
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 22:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238056AbiCIVdU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 16:33:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237819AbiCIVdS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 16:33:18 -0500
Received: from mail-oi1-x249.google.com (mail-oi1-x249.google.com [IPv6:2607:f8b0:4864:20::249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9178111D7B2
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 13:32:18 -0800 (PST)
Received: by mail-oi1-x249.google.com with SMTP id h25-20020a056808015900b002d6048692beso2391396oie.8
        for <kvm@vger.kernel.org>; Wed, 09 Mar 2022 13:32:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0dfXPpydeZEC3VDqzkrY7+izQjMCWin/le7c3KYdolQ=;
        b=JzjNKDWxPAvJ4+G+kuVfG7e4Logr2FT5nUikbifToloS5Ap3uNMqPgXIIDJSjSlgaq
         wsk5ddzs9BI4FftUbrxuweNJmI/kBfzde5I+obRBCkSxNHdl5BgasCuSTDigoM79L3lI
         5df7GbhzQyF1YEh+WP6yKO9MhRn8ae+TOX/T8HRLV0gL7PBmeaBYZz0HN+oQsa/0mWb7
         ay8g8YZgl9wxCxbM2df9OBgOH/l636R9jw+HMOXOYDacQF2m8y1vZOYibUJSIX9h700T
         qgQiJyJdrxBANaHVtkNfMXv8cwnUOksnR5lsrTdqNZbCD7//pmxvWdEftn7yihU/tW8n
         Fkaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0dfXPpydeZEC3VDqzkrY7+izQjMCWin/le7c3KYdolQ=;
        b=J3QppRlzez/++FsI3wEAUoNYwC3ygVV0KShP2QGQHShq5Ibk5ZouY+QN73HmjU8j34
         pWbDWbnnqXDLcFaa1jj1WAL/WUPvYFskGBdv2zCbleaVJZqQMnivdwB/oStmolze3vPs
         PYmtZL3tx2vFO4q2Kozj1vcSE9iDRK6EI5oV2YwWqwvM0ii2r7z+ZUwdUmBVgBUMbdzR
         U9o7hRS5jncI1kj9KnzE6gxWj94wTF1hc1NJv7V/YOLtaJ4UVKt7iaaHCtsCFntWkSLn
         9Nz5Y6CX9hz/f0epWKFKUEvktJozYwrMFP+N46mf0TxwnteAGIBQZjuwsGuHfK5naksX
         BmdA==
X-Gm-Message-State: AOAM533OWN0aig3MCWceCbv2dI9NAbp1P+PkntP+x1QngZLd5zqTe5aD
        BWGPePdZ1utEX00z2RpodJkmf4EzbqwlRw==
X-Google-Smtp-Source: ABdhPJzugdz5iy4t+ODhE2oOSy5pXQPLmy8G5RbFUGz5yrY9ME1XbkrifokL2llwjZ4yWvT6fRiCc05+ZzqPEQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6808:17a8:b0:2d9:e067:e090 with SMTP
 id bg40-20020a05680817a800b002d9e067e090mr7405802oib.25.1646861537828; Wed,
 09 Mar 2022 13:32:17 -0800 (PST)
Date:   Wed,  9 Mar 2022 21:32:08 +0000
In-Reply-To: <20220309213208.872644-1-dmatlack@google.com>
Message-Id: <20220309213208.872644-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20220309213208.872644-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH v2 2/2] Revert "KVM: set owner of cpu and vm file operations"
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Matlack <dmatlack@google.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, seanjc@google.com,
        bgardon@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
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
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 virt/kvm/kvm_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e17f9fd847e0..dfbd9592eaba 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3673,7 +3673,7 @@ static int kvm_vcpu_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static struct file_operations kvm_vcpu_fops = {
+static const struct file_operations kvm_vcpu_fops = {
 	.release        = kvm_vcpu_release,
 	.unlocked_ioctl = kvm_vcpu_ioctl,
 	.mmap           = kvm_vcpu_mmap,
@@ -4724,7 +4724,7 @@ static long kvm_vm_compat_ioctl(struct file *filp,
 }
 #endif
 
-static struct file_operations kvm_vm_fops = {
+static const struct file_operations kvm_vm_fops = {
 	.release        = kvm_vm_release,
 	.unlocked_ioctl = kvm_vm_ioctl,
 	.llseek		= noop_llseek,
@@ -5731,8 +5731,6 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 		goto out_free_5;
 
 	kvm_chardev_ops.owner = module;
-	kvm_vm_fops.owner = module;
-	kvm_vcpu_fops.owner = module;
 
 	r = misc_register(&kvm_dev);
 	if (r) {
-- 
2.35.1.616.g0bdcbb4464-goog


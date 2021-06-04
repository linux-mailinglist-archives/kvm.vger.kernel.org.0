Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F6539BF75
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 20:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhFDSUg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 14:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhFDSUg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 14:20:36 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3CF4C061766
        for <kvm@vger.kernel.org>; Fri,  4 Jun 2021 11:18:39 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 15-20020a17090a0f0fb029016ad0f32fd0so5337231pjy.6
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 11:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=OURJ6TzGdfX+C5aElOfrvLYLXIEwqt+64W7DY078FOs=;
        b=DoohwkvXjAFEjB702S1RR85vweNK+i/nJ9ySyGXZL7k7ooN4RLk2j6KK0JpK4KBp0W
         BUCiT5U1dWIDDUHEwVM7l41dmz4VGvpZC68yGABSBExHHEVCcyStRIbAUKmecH0d3lw0
         WAeJhuBJ4/auMLn3lWtehD0nD9R4kYgREzE0Un51yljJ0Kkkn40uZeXLGZHBrDMZFbku
         B4nAxYWuyr1KCo72Kw/gia2f9dqgfXPC3SsCi2vYLkGHhOf+aK2m8i9J8dOwiGL36dXM
         NUkgGWEj9O1cTJKdJc7xeWZ9KBsejArXk3bHK3N01RJcAJDiym53uZ99msNDGxs+7R97
         YEMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=OURJ6TzGdfX+C5aElOfrvLYLXIEwqt+64W7DY078FOs=;
        b=jBltyJ3KmWZ7uAG5+sHFgZqSMOs2zrWxjlgPPCyp+vgV2ORLa+DUWVlD5uZD9IXKpw
         awbcR6taJzb5/naYVgso2TpilL+CyKQedAIDKQpM93rBLcqUFjNeBusHaRAkUMIOTSIV
         9sytTzi/HV+KVVFd/gKdPN1haZZ8Q7W70H+WWuHQSLfgIDGlr/bxNt6DcD7Ag1r5KiI7
         h6f03pgeCI/MV45mHfgUXzuFveFSXeXhsiokJ/Jsl+JuxNH+8MTkEmCT3sv3OPT4sfj/
         YHcVhZkSHAtHFjK6p3joniH7XxKOWxCdDS2kA94YooHvbPP1IO2edKpAFMGaySZiJbwZ
         kraA==
X-Gm-Message-State: AOAM531tVU2nysCxiH1MMH84QjrFsa8dl3Xi3wG8y8JCbNaqcLj4ZWhF
        Akn2L//4NJLsSoazKGFT7xwGjbmjQiWGnA==
X-Google-Smtp-Source: ABdhPJy9PKCQtJIEuOUg8w1qPNwviZRTxC7lSkcVhvhRw5bRINA/J7AJOwPEGcjkcY9tf+d4n0aJ6rlK3EBbhQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:c68a:: with SMTP id
 n10mr18432159pjt.32.1622830719294; Fri, 04 Jun 2021 11:18:39 -0700 (PDT)
Date:   Fri,  4 Jun 2021 11:18:33 -0700
Message-Id: <20210604181833.1769900-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH] KVM: selftests: Rename vm_handle_exception in evmcs test
From:   Ricardo Koller <ricarkol@google.com>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc:     maz@kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        eric.auger@redhat.com, Ricardo Koller <ricarkol@google.com>,
        kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kernel test robot reports this:

> /usr/bin/ld: tools/testing/selftests/kvm/x86_64/evmcs_test.c:157: undefined reference to `vm_handle_exception'
> /usr/bin/ld: tools/testing/selftests/kvm/x86_64/evmcs_test.c:158: undefined reference to `vm_handle_exception'
> collect2: error: ld returned 1 exit status

Fix it by renaming vm_handle_exception to vm_install_vector_handler in
evmcs_test.c.

Fixes: a2bad6a990a4 ("KVM: selftests: Rename vm_handle_exception")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/x86_64/evmcs_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index 63096cea26c6..278711723f4b 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -154,8 +154,8 @@ int main(int argc, char *argv[])
 
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vm, VCPU_ID);
-	vm_handle_exception(vm, UD_VECTOR, guest_ud_handler);
-	vm_handle_exception(vm, NMI_VECTOR, guest_nmi_handler);
+	vm_install_vector_handler(vm, UD_VECTOR, guest_ud_handler);
+	vm_install_vector_handler(vm, NMI_VECTOR, guest_nmi_handler);
 
 	pr_info("Running L1 which uses EVMCS to run L2\n");
 
-- 
2.32.0.rc1.229.g3e70b5a671-goog


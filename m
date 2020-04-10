Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E48631A45BA
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 13:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgDJLf2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 07:35:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33812 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbgDJLf2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 07:35:28 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jMrwU-0008VB-On; Fri, 10 Apr 2020 11:35:26 +0000
From:   Colin King <colin.king@canonical.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: remove redundant assignment to variable r
Date:   Fri, 10 Apr 2020 12:35:26 +0100
Message-Id: <20200410113526.13822-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable r is being assigned  with a value that is never read
and it is being updated later with a new value.  The initialization is
redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 virt/kvm/kvm_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 74bdb7bf3295..03571f6acaa8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3160,7 +3160,6 @@ static long kvm_vcpu_ioctl(struct file *filp,
 	case KVM_SET_REGS: {
 		struct kvm_regs *kvm_regs;
 
-		r = -ENOMEM;
 		kvm_regs = memdup_user(argp, sizeof(*kvm_regs));
 		if (IS_ERR(kvm_regs)) {
 			r = PTR_ERR(kvm_regs);
-- 
2.25.1


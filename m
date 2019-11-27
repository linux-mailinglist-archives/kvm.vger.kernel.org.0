Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07ECB10A783
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 01:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfK0Aaa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 19:30:30 -0500
Received: from m17618.mail.qiye.163.com ([59.111.176.18]:19773 "EHLO
        m17618.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbfK0Aaa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Nov 2019 19:30:30 -0500
Received: from localhost.localdomain.localdomain (unknown [121.12.147.250])
        by m17618.mail.qiye.163.com (Hmail) with ESMTPA id 708184E1718;
        Wed, 27 Nov 2019 08:30:27 +0800 (CST)
From:   Peng Hao <richard.peng@oppo.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peng Hao <richard.peng@oppo.com>
Subject: [PATCH] kvm/x86: export kvm_vector_hashing_enabled() is unnecessary
Date:   Wed, 27 Nov 2019 08:30:25 +0800
Message-Id: <1574814625-29295-1-git-send-email-richard.peng@oppo.com>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVk9VSkJPS0tKSkJMQ0pPQk9ZV1koWU
        FJSUtLSjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PRw6IRw*ODg#MgMDCjc2Og9J
        PEgKCUxVSlVKTkxPQ0pPTUlDS0JPVTMWGhIXVQkSGBMaCR9VCx4VHDsUCwsUVRgUFkVZV1kSC1lB
        WUpJSlVKSVVKT0xVSU5LWVdZCAFZQUpIS0k3Bg++
X-HM-Tid: 0a6eaa44384b9376kuws708184e1718
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_vector_hashing_enabled() is just called in kvm.ko module.

Signed-off-by: Peng Hao <richard.peng@oppo.com>
---
 arch/x86/kvm/x86.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5d53052..169cea6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10236,7 +10236,6 @@ bool kvm_vector_hashing_enabled(void)
 {
 	return vector_hashing;
 }
-EXPORT_SYMBOL_GPL(kvm_vector_hashing_enabled);
 
 bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 {
-- 
1.8.3.1


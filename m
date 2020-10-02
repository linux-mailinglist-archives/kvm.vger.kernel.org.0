Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E275A281609
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 17:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388223AbgJBPEm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 11:04:42 -0400
Received: from mail-m971.mail.163.com ([123.126.97.1]:52908 "EHLO
        mail-m971.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgJBPEm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 11:04:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=vw4BK
        ZeWGdQzXY4U/kB8MPQGDeBG0VY8mfLs5IuUnEc=; b=IRbhaL9qdd03/iJRVZV5Q
        sc1LgpbRKiUp4csPMr25gqa08PXi0JHD2fzdlwakwMcaZq4Tyx+agHCJWM0q3vQd
        5yqUH4uaXJreTfFNm0jwIqGK2nB5wfqjrf43deTikXkTW6UvNOGCQwRL5Z07G7J/
        O4G+uLgEwrMeKRGHskP8ps=
Received: from ubuntu.localdomain (unknown [125.120.102.69])
        by smtp1 (Coremail) with SMTP id GdxpCgB3Scp5QXdfpcjqAg--.3258S4;
        Fri, 02 Oct 2020 23:04:26 +0800 (CST)
From:   Li Qiang <liq3ea@163.com>
To:     pbonzini@redhat.com, corbet@lwn.net, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     liq3ea@gmail.com, Li Qiang <liq3ea@163.com>
Subject: [PATCH] Documentation: kvm: fix a typo
Date:   Fri,  2 Oct 2020 08:04:22 -0700
Message-Id: <20201002150422.6267-1-liq3ea@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GdxpCgB3Scp5QXdfpcjqAg--.3258S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrZr4UXw1kuFyxXFy5tFW3GFg_yoW3WrgEvw
        1UJFsYyr1xtryIvw4UWFZ5XF1fXa1ruFW8Cws7JrZ5Aay3AwsY9F97A3s0kw1UWFsxur4r
        JFZxZrW5Gr1S9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRRTa0PUUUUU==
X-Originating-IP: [125.120.102.69]
X-CM-SenderInfo: 5oltjvrd6rljoofrz/xtbBZhqxbVaD6Ear8gAAsC
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixes: 9824c83f92bc8 ("Documentation: kvm: document CPUID bit for MSR_KVM_POLL_CONTROL")
Signed-off-by: Li Qiang <liq3ea@163.com>
---
 Documentation/virt/kvm/cpuid.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
index a7dff9186bed..9150e9d1c39b 100644
--- a/Documentation/virt/kvm/cpuid.rst
+++ b/Documentation/virt/kvm/cpuid.rst
@@ -78,7 +78,7 @@ KVM_FEATURE_PV_SEND_IPI           11          guest checks this feature bit
                                               before enabling paravirtualized
                                               sebd IPIs
 
-KVM_FEATURE_PV_POLL_CONTROL       12          host-side polling on HLT can
+KVM_FEATURE_POLL_CONTROL          12          host-side polling on HLT can
                                               be disabled by writing
                                               to msr 0x4b564d05.
 
-- 
2.25.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8069427FCDC
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 12:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731839AbgJAKJa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 06:09:30 -0400
Received: from mail-m975.mail.163.com ([123.126.97.5]:58166 "EHLO
        mail-m975.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgJAKJa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Oct 2020 06:09:30 -0400
X-Greylist: delayed 934 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Oct 2020 06:09:29 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=+4m/E
        60rd4MuVV6IHtmEXYYNuvcrK2YYQtFtbcmsOP4=; b=FrhotxVHrq4eURvN2ZD4q
        RCPQ/3jYiLQTL+dgyeO0KxUEPGPxSVQoCiHL11fFofSCEeMvsM3kBXAuJaXCmjDM
        h9Fri3aSaxO+VnT02/MqCOCNtMn+0qr0PoRWtGrAve+SZ9dZ6RHUJI3XnD2fVwYC
        zkR14cCw2syCJgz5ZClL+o=
Received: from ubuntu.localdomain (unknown [125.120.102.69])
        by smtp5 (Coremail) with SMTP id HdxpCgBnVQ8ep3Vf0ouQOw--.234S4;
        Thu, 01 Oct 2020 17:53:42 +0800 (CST)
From:   Li Qiang <liq3ea@163.com>
To:     pbonzini@redhat.com, corbet@lwn.net, lnowakow@eng.ucsd.edu,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     liq3ea@gmail.com, Li Qiang <liq3ea@163.com>
Subject: [PATCH] Documentation: kvm: fix a typo
Date:   Thu,  1 Oct 2020 02:53:33 -0700
Message-Id: <20201001095333.7611-1-liq3ea@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HdxpCgBnVQ8ep3Vf0ouQOw--.234S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7Xw18Gw17Zr45Xw4rGFyDZFb_yoW3XrbE9r
        1DtFsYqr18tr1Sqw4UGFs5ZF13Xa1rCFyUCw1kArs5Aa4Ut395uFyDC3y2y345XFsxurZ8
        JFZxZrW5Jw129jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRR75r3UUUUU==
X-Originating-IP: [125.120.102.69]
X-CM-SenderInfo: 5oltjvrd6rljoofrz/xtbBZgawbVaD6D9K2AAAst
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixes: e287d6de62f74 ("Documentation: kvm: Convert cpuid.txt to .rst")
Signed-off-by: Li Qiang <liq3ea@163.com>
---
 Documentation/virt/kvm/cpuid.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
index a7dff9186bed..ff2b38d3e108 100644
--- a/Documentation/virt/kvm/cpuid.rst
+++ b/Documentation/virt/kvm/cpuid.rst
@@ -62,7 +62,7 @@ KVM_FEATURE_PV_EOI                6           paravirtualized end of interrupt
                                               handler can be enabled by
                                               writing to msr 0x4b564d04
 
-KVM_FEATURE_PV_UNHAULT            7           guest checks this feature bit
+KVM_FEATURE_PV_UNHALT             7           guest checks this feature bit
                                               before enabling paravirtualized
                                               spinlock support
 
-- 
2.25.1


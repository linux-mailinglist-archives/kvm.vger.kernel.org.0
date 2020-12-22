Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 798032E0A84
	for <lists+kvm@lfdr.de>; Tue, 22 Dec 2020 14:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbgLVNPQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Dec 2020 08:15:16 -0500
Received: from prt-mail.chinatelecom.cn ([42.123.76.219]:36032 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727124AbgLVNPP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Dec 2020 08:15:15 -0500
X-Greylist: delayed 729 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Dec 2020 08:15:14 EST
HMM_SOURCE_IP: 172.18.0.48:50097.1081722363
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-223.223.190.99?logid-d47f15e47a804f34bc51bd0740602e91 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id 6EA06280096;
        Tue, 22 Dec 2020 21:00:57 +0800 (CST)
X-189-SAVE-TO-SEND: +liuxp11@chinatelecom.cn
Received: from  ([172.18.0.48])
        by App0024 with ESMTP id d47f15e47a804f34bc51bd0740602e91 for kvm@vger.kernel.org;
        Tue Dec 22 21:00:59 2020
X-Transaction-ID: d47f15e47a804f34bc51bd0740602e91
X-filter-score:  filter<0>
X-Real-From: liuxp11@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
Sender: liuxp11@chinatelecom.cn
From:   Xinpeng Liu <liuxp11@chinatelecom.cn>
To:     kvm@vger.kernel.org
Cc:     liuxp11@chinatelecom.cn
Subject: [kvm-unit-tests PATCH] fix a arrayIndexOutOfBounds in function init_apic_map, online_cpus[i / 8] when i in 248...254.
Date:   Tue, 22 Dec 2020 21:00:49 +0800
Message-Id: <1608642049-21007-1-git-send-email-liuxp11@chinatelecom.cn>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

refer to x86/cstart64.S:online_cpus:.fill (max_cpus + 7) / 8, 1, 0

Signed-off-by: Xinpeng Liu <liuxp11@chinatelecom.cn>
---
 lib/x86/apic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/x86/apic.c b/lib/x86/apic.c
index f43e9ef..da8f301 100644
--- a/lib/x86/apic.c
+++ b/lib/x86/apic.c
@@ -232,7 +232,7 @@ void mask_pic_interrupts(void)
     outb(0xff, 0xa1);
 }
 
-extern unsigned char online_cpus[MAX_TEST_CPUS / 8];
+extern unsigned char online_cpus[(MAX_TEST_CPUS + 7) / 8];
 
 void init_apic_map(void)
 {
-- 
1.8.3.1


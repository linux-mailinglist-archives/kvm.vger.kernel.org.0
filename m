Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7FFB5A76B8
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 08:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbiHaGf6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 02:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiHaGf4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 02:35:56 -0400
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.154.221.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBDDA61DF;
        Tue, 30 Aug 2022 23:35:52 -0700 (PDT)
X-QQ-mid: bizesmtp81t1661927738tvymfl2y
Received: from localhost.localdomain ( [182.148.13.26])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 31 Aug 2022 14:35:36 +0800 (CST)
X-QQ-SSF: 01000000000000D0E000000A0000000
X-QQ-FEAT: r/cTxDoDoiHHOLH8/pfmSzkC6LAycOY6ODvGYfCuyUE00ML6d0WF7UrVe6GSA
        HOccopvysDr1rWgE7Uo8zCYHPC2kLmrnI7hCmTEnUrQJj6tpRaFWioqqOaQ2c5HoEHQYGki
        G8ejFWM4/j6DF453T/OLYq/YFnjTsy1Borj7KZrLWKPyTvQKg5q22qAP6Ncyxql9OLafT1p
        WriXnFxzuO/EW0qUk+i/ZDdOnSJZfubPUEfz5lPkoDIpRxY4O6pojJO7sdTyqVRj9cZat72
        bC8XQe/JN0arjOYltCm5gWq1ui6x09PkmISp65esh2Jb5Qn/I2JxPYOe2x+adn1LX9RVkZn
        W/1r1HmQ0EXgdSZjOtUSCDsKIqaJQWxZNXSyAz18pnCWNrBuv5aPqNM9c3qnXNO4lMAwMH8
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] KVM: s390: fix repeated words in comments
Date:   Wed, 31 Aug 2022 14:35:30 +0800
Message-Id: <20220831063530.16876-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Delete the redundant word 'not'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 arch/s390/kvm/interrupt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index b9c944b262c7..f0b925e70900 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -577,7 +577,7 @@ static int __write_machine_check(struct kvm_vcpu *vcpu,
 	/*
 	 * All other possible payload for a machine check (e.g. the register
 	 * contents in the save area) will be handled by the ultravisor, as
-	 * the hypervisor does not not have the needed information for
+	 * the hypervisor does not have the needed information for
 	 * protected guests.
 	 */
 	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
-- 
2.36.1


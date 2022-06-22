Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1D98554C32
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 16:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357892AbiFVOHs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 10:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238207AbiFVOHr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 10:07:47 -0400
Received: from smtpbg.qq.com (smtpbg138.qq.com [106.55.201.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3CDC37BF2;
        Wed, 22 Jun 2022 07:07:42 -0700 (PDT)
X-QQ-mid: bizesmtp81t1655906846trebwzja
Received: from ubuntu.localdomain ( [106.117.78.84])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 22 Jun 2022 22:07:22 +0800 (CST)
X-QQ-SSF: 01000000008000B0B000B00A0000000
X-QQ-FEAT: 1npaVEgjlkIwMbFnQPtwJv0BZBcdNG8yP83XgmY+2RAS5Gx7hH9Ag/haCwB/e
        8kCdzW5zmlpTXiQZWiELlpbXRy3cwLQwtOFvsG0qBEfyKRICQqKXIFcDgimTeKm2rDfMBRu
        FrElx4NL5Kx2sVTGocMs2vDo2oGXdzxcAXbk4QF+CuINMH7BMeFbQXRM9Dh2j9QTMFGY/Kb
        Aln4ivMovz8yE0VwMFOvGJ+RmVZo4sqLWyATAmC6aHU6XyxmIdoWWkixY/sd1of/4H3mA+2
        UOcZQ+wqGqf472TBQd99OpHJwYKNAi1vB4ceh1qKpxjK2vdLzX/n0UwyOQZqO8IdgXl23Kd
        VG1YJAERwCq58PQEyeCeE3yYAm7ArdeeSIxWreG
X-QQ-GoodBg: 0
From:   Jiang Jian <jiangjian@cdjrlc.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     david@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiang Jian <jiangjian@cdjrlc.com>
Subject: [PATCH] KVM: s390: drop unexpected word 'and' in the comments
Date:   Wed, 22 Jun 2022 22:07:20 +0800
Message-Id: <20220622140720.7617-1-jiangjian@cdjrlc.com>
X-Mailer: git-send-email 2.17.1
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

there is an unexpected word 'and' in the comments that need to be dropped

file: arch/s390/kvm/interrupt.c
line: 705

* Subsystem damage are the only two and and are indicated by

changed to:

* Subsystem damage are the only two and are indicated by

Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
---
 arch/s390/kvm/interrupt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index af96dc0549a4..1e3fb2d4d448 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -702,7 +702,7 @@ static int __must_check __deliver_machine_check(struct kvm_vcpu *vcpu)
 	/*
 	 * We indicate floating repressible conditions along with
 	 * other pending conditions. Channel Report Pending and Channel
-	 * Subsystem damage are the only two and and are indicated by
+	 * Subsystem damage are the only two and are indicated by
 	 * bits in mcic and masked in cr14.
 	 */
 	if (test_and_clear_bit(IRQ_PEND_MCHK_REP, &fi->pending_irqs)) {
-- 
2.17.1


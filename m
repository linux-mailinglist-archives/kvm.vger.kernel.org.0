Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED165E5CA7
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 09:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiIVHta (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 03:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiIVHt1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 03:49:27 -0400
Received: from ssh248.corpemail.net (ssh248.corpemail.net [210.51.61.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A921AFAC4;
        Thu, 22 Sep 2022 00:49:24 -0700 (PDT)
Received: from ([60.208.111.195])
        by ssh248.corpemail.net ((D)) with ASMTP (SSL) id QGT00019;
        Thu, 22 Sep 2022 15:49:19 +0800
Received: from localhost.localdomain (10.200.104.97) by
 jtjnmail201607.home.langchao.com (10.100.2.7) with Microsoft SMTP Server id
 15.1.2507.12; Thu, 22 Sep 2022 15:49:20 +0800
From:   Bo Liu <liubo03@inspur.com>
To:     <borntraeger@linux.ibm.com>, <frankja@linux.ibm.com>,
        <imbrenda@linux.ibm.com>, <david@redhat.com>, <hca@linux.ibm.com>,
        <gor@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <svens@linux.ibm.com>
CC:     <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Bo Liu <liubo03@inspur.com>
Subject: [PATCH] KVM: s390: Fix double word in comments
Date:   Thu, 22 Sep 2022 03:49:02 -0400
Message-ID: <20220922074902.2345-1-liubo03@inspur.com>
X-Mailer: git-send-email 2.18.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.200.104.97]
tUid:   2022922154919890efbf21344134e13fb188b7e6eb9bf
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the repeated word "not" in comments.

Signed-off-by: Bo Liu <liubo03@inspur.com>
---
 arch/s390/kvm/interrupt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index ab569faf0df2..4b3c02ab9f70 100644
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
2.27.0


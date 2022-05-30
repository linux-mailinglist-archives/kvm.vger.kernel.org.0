Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3292853737C
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 04:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbiE3CJ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 May 2022 22:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbiE3CJ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 May 2022 22:09:28 -0400
Received: from smtpbg.qq.com (smtpbg136.qq.com [106.55.201.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD00957B2C;
        Sun, 29 May 2022 19:09:21 -0700 (PDT)
X-QQ-mid: bizesmtp91t1653876553tmjo7znn
Received: from localhost.localdomain ( [125.70.163.149])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 30 May 2022 10:09:05 +0800 (CST)
X-QQ-SSF: 01000000000000B0G000000A0000000
X-QQ-FEAT: I9ND0OY2eBBcEnb4rKrPQb7iIEPvTdW2xFR6PBMGrnnHidp6DhYeutlEf892f
        seS4nL8r/AE9CoxugJP4k4bSZ9fFH5qdeb9N++v8nmqLM+bXkpsr78xHSSldUB2J2d+nNDv
        sNUzFs31bbyh+H4ESl/eyMjneJUXMcKO2lxKoPNlbXSlrO4APTBGRdVAiTKVcp8GNl/opr8
        V7i3pUkKPpM/YiXyHDrxddjOomhy/uRZwaB5xNnhaUluZ2vUGqRdcRX67kjhxnBnf3uTDiO
        2be0Gh5rZXuHmBTQkzePyUaV/auCUtOuEumpzYIBNDam7I
X-QQ-GoodBg: 0
From:   Xiang wangx <wangxiang@cdjrlc.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiang wangx <wangxiang@cdjrlc.com>
Subject: [PATCH] KVM: Add const to file_operations
Date:   Mon, 30 May 2022 10:08:57 +0800
Message-Id: <20220530020857.2565-1-wangxiang@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Struct file_operations should normally be const.

Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>
---
 virt/kvm/kvm_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3f6d450355f0..7dc2433f1b01 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3550,7 +3550,7 @@ static int kvm_vcpu_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static struct file_operations kvm_vcpu_fops = {
+static const struct file_operations kvm_vcpu_fops = {
 	.release        = kvm_vcpu_release,
 	.unlocked_ioctl = kvm_vcpu_ioctl,
 	.mmap           = kvm_vcpu_mmap,
@@ -4599,7 +4599,7 @@ static long kvm_vm_compat_ioctl(struct file *filp,
 }
 #endif
 
-static struct file_operations kvm_vm_fops = {
+static const struct file_operations kvm_vm_fops = {
 	.release        = kvm_vm_release,
 	.unlocked_ioctl = kvm_vm_ioctl,
 	.llseek		= noop_llseek,
@@ -4701,7 +4701,7 @@ static long kvm_dev_ioctl(struct file *filp,
 	return r;
 }
 
-static struct file_operations kvm_chardev_ops = {
+static const struct file_operations kvm_chardev_ops = {
 	.unlocked_ioctl = kvm_dev_ioctl,
 	.llseek		= noop_llseek,
 	KVM_COMPAT(kvm_dev_ioctl),
-- 
2.36.1


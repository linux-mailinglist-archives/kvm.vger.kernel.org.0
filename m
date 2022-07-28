Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA3F8583A4F
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 10:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235174AbiG1IZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 04:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233810AbiG1IZQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 04:25:16 -0400
Received: from out0-143.mail.aliyun.com (out0-143.mail.aliyun.com [140.205.0.143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834246596
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 01:25:09 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047205;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=1;SR=0;TI=SMTPD_---.OfjlJUR_1658996705;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.OfjlJUR_1658996705)
          by smtp.aliyun-inc.com;
          Thu, 28 Jul 2022 16:25:06 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Subject: [PATCH 0/2] Add missing trace points in emulator path
Date:   Thu, 28 Jul 2022 16:25:03 +0800
Message-Id: <cover.1658913543.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some existed trace points are missing in emulator path, e.g.,
RDMSR/WRMSR emulation and CR read/write emulation. However,
if add those trace points in emulator common interfaces in
arch/x86/kvm/x86.c, other instruction emulation may use those
interfaces too and cause too much trace records. But add those
trace points in em_* functions in arch/x86/kvm/emulate.c seems
to be ugly. Luckily, RDMSR/WRMSR emulation uses a sepreate
interface, so add trace points for RDMSR/WRMSR in emulator
path is acceptable like normal path.

Hou Wenlong (2):
  KVM: x86: Return emulator error if RDMSR/WRMSR emulation failed
  KVM: x86: Add missing trace points for RDMSR/WRMSR in emulator path

 arch/x86/kvm/x86.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

--
2.31.1


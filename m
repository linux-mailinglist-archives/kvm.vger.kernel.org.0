Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4C34C41C3
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 10:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239247AbiBYJuR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 04:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233675AbiBYJuP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 04:50:15 -0500
Received: from out0-141.mail.aliyun.com (out0-141.mail.aliyun.com [140.205.0.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E972424CCFE
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 01:49:43 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047202;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---.Mvtm120_1645782581;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.Mvtm120_1645782581)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 25 Feb 2022 17:49:41 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     "Paolo Bonzini" <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        "Hou Wenlong" <houwenlong.hwl@antgroup.com>
Subject: [kvm-unit-tests PATCH v4 0/3] x86/emulator: Add some tests for loading segment descriptor in emulator
Date:   Fri, 25 Feb 2022 17:49:24 +0800
Message-Id: <cover.1645672780.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add some far ret and far jmp tests for the related x86 emulator bugs[*].
Those tests would be tested both on hardware and emulator. Enable
kvm.force_emulation_prefix to test them on emulator.

Changed from v3:
- Fix build failure with --target-efi.

Changed from v2:
- Fix some complication errors, which are not gotten in my gcc.
- Rename lret as far ret, and rename ljmp as far jmp.

Changed from v1:
- As Sean suggested, refactor the test loop to make the code simple.

v3: https://lore.kernel.org/kvm/cover.1644481282.git.houwenlong.hwl@antgroup.com

[*] https://lore.kernel.org/kvm/cover.1644292363.git.houwenlong.hwl@antgroup.com


Hou Wenlong (3):
  x86/emulator: Add some tests for far ret instruction emulation
  x86/emulator: Rename test_ljmp() as test_far_jmp()
  x86/emulator: Add some tests for far jmp instruction emulation

 x86/emulator.c | 203 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 189 insertions(+), 14 deletions(-)

--
2.31.1


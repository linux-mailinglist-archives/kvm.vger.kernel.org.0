Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6754AD4F4
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 10:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354812AbiBHJbf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 04:31:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232862AbiBHJbe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 04:31:34 -0500
Received: from out0-155.mail.aliyun.com (out0-155.mail.aliyun.com [140.205.0.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA52C03FEC1
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 01:31:32 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047199;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---.Mn033lt_1644312689;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.Mn033lt_1644312689)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Feb 2022 17:31:30 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     "Sean Christopherson" <seanjc@google.com>,
        "Hou Wenlong" <houwenlong.hwl@antgroup.com>
Subject: [kvm-unit-tests PATCH v2 0/2] x86/emulator: Add some tests for loading segment descriptor in emulator
Date:   Tue, 08 Feb 2022 17:30:55 +0800
Message-Id: <cover.1644311445.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1642669912.git.houwenlong.hwl@antgroup.com>
References: <cover.1642669912.git.houwenlong.hwl@antgroup.com>
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

Add some lret and ljmp tests for the related x86 emulator bugs[*]. Those tests
would be tested both on hardware and emulator. Enable kvm.force_emulation_prefix
to test them on emulator.

Changed from v1:
- As Sean suggested, refactor the test loop to make the code simple.

[*] https://lore.kernel.org/kvm/cover.1644292363.git.houwenlong.hwl@antgroup.com

Hou Wenlong (2):
  x86/emulator: Add some tests for lret instruction emulation
  x86/emulator: Add some tests for ljmp instruction emulation

 x86/emulator.c | 205 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 192 insertions(+), 13 deletions(-)

--
2.31.1


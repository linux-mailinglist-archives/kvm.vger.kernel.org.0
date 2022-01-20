Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4914494AB6
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 10:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359480AbiATJ15 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 04:27:57 -0500
Received: from out0-133.mail.aliyun.com ([140.205.0.133]:37421 "EHLO
        out0-133.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241126AbiATJ1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 04:27:54 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047194;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---.MfqJbKs_1642670871;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.MfqJbKs_1642670871)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 20 Jan 2022 17:27:51 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     "Hou Wenlong" <houwenlong.hwl@antgroup.com>
Subject: [kvm-unit-tests PATCH 0/2] x86/emulator: Add some tests for loading segment descriptor in emulator
Date:   Thu, 20 Jan 2022 17:26:57 +0800
Message-Id: <cover.1642669912.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add some lret and ljmp tests for the related x86 emulator bugs[*]. Those tests
would be tested both on hardware and emulator. Enable kvm.force_emulation_prefix
to test them on emulator.

[*] https://lore.kernel.org/kvm/cover.1642669684.git.houwenlong.hwl@antgroup.com

Hou Wenlong (2):
  x86/emulator: Add some tests for lret instruction emulation
  x86/emulator: Add some tests for ljmp instruction emulation

 x86/emulator.c | 283 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 270 insertions(+), 13 deletions(-)

--
2.31.1


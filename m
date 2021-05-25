Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B971938FD15
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 10:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231971AbhEYIrG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 04:47:06 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:58339 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231472AbhEYIrF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 May 2021 04:47:05 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R261e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=chaowu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Ua3XLTC_1621932333;
Received: from localhost.localdomain(mailfrom:chaowu@linux.alibaba.com fp:SMTPD_---0Ua3XLTC_1621932333)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 25 May 2021 16:45:34 +0800
From:   Chao Wu <chaowu@linux.alibaba.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org,
        Chao Wu <chaowu@linux.alibaba.com>
Subject: [PATCH 0/2] Fix ptp_kvm_get_time_fn infinite loop and remove redundant EXPORT_SYMBOL_GPL
Date:   Tue, 25 May 2021 16:44:56 +0800
Message-Id: <cover.1621505277.git.chaowu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We fix the infinite loop bug in ptp_kvm_get_time_fn function and removes the redundant EXPORT_SYMBOL_GPL for pvclock_get_pvti_cpu0_va.

Chao Wu (2):
  ptp_kvm: fix an infinite loop in ptp_kvm_get_time_fn when vm has more than 64 vcpus 
  pvclock: remove EXPORT_SYMBOL_GPL for pvclock_get_pvti_cpu0_va

 arch/x86/include/asm/kvmclock.h | 16 ++++++++++++++++
 arch/x86/kernel/kvmclock.c      | 12 ++----------
 arch/x86/kernel/pvclock.c       |  1 -
 drivers/ptp/ptp_kvm.c           |  6 ++----
 4 files changed, 20 insertions(+), 15 deletions(-)

-- 
2.24.3 (Apple Git-128)


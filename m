Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 327E65B4FB
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 08:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfGAGXu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 02:23:50 -0400
Received: from mxhk.zte.com.cn ([63.217.80.70]:16898 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbfGAGXu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 02:23:50 -0400
Received: from mse-fl2.zte.com.cn (unknown [10.30.14.239])
        by Forcepoint Email with ESMTPS id 3D5E5422633A9622B803;
        Mon,  1 Jul 2019 14:23:48 +0800 (CST)
Received: from notes_smtp.zte.com.cn ([10.30.1.239])
        by mse-fl2.zte.com.cn with ESMTP id x616Merk061391;
        Mon, 1 Jul 2019 14:22:40 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019070114224387-1995712 ;
          Mon, 1 Jul 2019 14:22:43 +0800 
From:   Yi Wang <wang.yi59@zte.com.cn>
To:     pbonzini@redhat.com
Cc:     rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.yi59@zte.com.cn, up2wing@gmail.com, wang.liang82@zte.com.cn
Subject: [PATCH 0/4] kvm: x86: introduce CONFIG_KVM_DEBUG
Date:   Mon, 1 Jul 2019 14:21:07 +0800
Message-Id: <1561962071-25974-1-git-send-email-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-07-01 14:22:44,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-07-01 14:22:41,
        Serialize complete at 2019-07-01 14:22:41
X-MAIL: mse-fl2.zte.com.cn x616Merk061391
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series introduce CONFIG_KVM_DEBUG, using which we can make
the invoking *_debug in KVM simly and uniform.

FYI: the former discussion can been found in:
https://www.spinics.net/lists/kvm/msg187026.html

Yi Wang (4):
  kvm: x86: Add CONFIG_KVM_DEBUG
  kvm: x86: allow set apic and ioapic debug dynamically
  kvm: x86: replace MMU_DEBUG with CONFIG_KVM_DEBUG
  kvm: x86: convert TSC pr_debugs to be gated by CONFIG_KVM_DEBUG

 arch/x86/kvm/Kconfig  |  8 ++++++++
 arch/x86/kvm/ioapic.c |  2 +-
 arch/x86/kvm/lapic.c  |  5 ++++-
 arch/x86/kvm/mmu.c    |  5 ++---
 arch/x86/kvm/x86.c    | 18 ++++++++++++------
 5 files changed, 27 insertions(+), 11 deletions(-)

-- 
1.8.3.1


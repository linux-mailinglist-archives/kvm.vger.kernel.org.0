Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFD4B5F765
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 13:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbfGDLsN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 07:48:13 -0400
Received: from mx7.zte.com.cn ([202.103.147.169]:55146 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727436AbfGDLsM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 07:48:12 -0400
Received: from mse-fl2.zte.com.cn (unknown [10.30.14.239])
        by Forcepoint Email with ESMTPS id 25E194A1888AAFC85ED7;
        Thu,  4 Jul 2019 19:48:08 +0800 (CST)
Received: from notes_smtp.zte.com.cn ([10.30.1.239])
        by mse-fl2.zte.com.cn with ESMTP id x64BloNE014331;
        Thu, 4 Jul 2019 19:47:50 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019070419482011-2086631 ;
          Thu, 4 Jul 2019 19:48:20 +0800 
From:   Yi Wang <wang.yi59@zte.com.cn>
To:     pbonzini@redhat.com
Cc:     rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        xue.zhihong@zte.com.cn, wang.yi59@zte.com.cn, up2wing@gmail.com,
        wang.liang82@zte.com.cn
Subject: [PATCH 0/2] fix likely hint of sched_info_on()
Date:   Thu, 4 Jul 2019 19:46:13 +0800
Message-Id: <1562240775-16086-1-git-send-email-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-07-04 19:48:20,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-07-04 19:47:55,
        Serialize complete at 2019-07-04 19:47:55
X-MAIL: mse-fl2.zte.com.cn x64BloNE014331
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When make defconfig, CONFIG_SCHEDSTATS is set to be y, so
sched_info_on() is 'likely' to be true. However, some functions
invoke this function with unlikely hint or use no hint. Let's
fix this.

Yi Wang (2):
  kvm: x86: add likely to sched_info_on()
  sched: fix unlikely use of sched_info_on()

 arch/x86/kvm/cpuid.c | 2 +-
 kernel/sched/stats.h | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
1.8.3.1


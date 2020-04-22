Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 799C81B35F8
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 06:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgDVELr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 00:11:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:60012 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbgDVELr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 00:11:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5F1ABAD5E;
        Wed, 22 Apr 2020 04:11:44 +0000 (UTC)
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     tglx@linutronix.de, pbonzini@redhat.com
Cc:     bigeasy@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        torvalds@linux-foundation.org, will@kernel.org,
        joel@joelfernandes.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, dave@stgolabs.net,
        Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 1/5] rcuwait: Fix stale wake call name in comment
Date:   Tue, 21 Apr 2020 21:07:35 -0700
Message-Id: <20200422040739.18601-2-dave@stgolabs.net>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200422040739.18601-1-dave@stgolabs.net>
References: <20200422040739.18601-1-dave@stgolabs.net>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The 'trywake' name was renamed to simply 'wake', update the comment.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 kernel/exit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 389a88cb3081..9f9015f3f6b0 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -236,7 +236,7 @@ void rcuwait_wake_up(struct rcuwait *w)
 	/*
 	 * Order condition vs @task, such that everything prior to the load
 	 * of @task is visible. This is the condition as to why the user called
-	 * rcuwait_trywake() in the first place. Pairs with set_current_state()
+	 * rcuwait_wake() in the first place. Pairs with set_current_state()
 	 * barrier (A) in rcuwait_wait_event().
 	 *
 	 *    WAIT                WAKE
-- 
2.16.4


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC00190495
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 05:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgCXEqK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 00:46:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:39334 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbgCXEqJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 00:46:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 774EAB021;
        Tue, 24 Mar 2020 04:46:07 +0000 (UTC)
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     tglx@linutronix.de, pbonzini@redhat.com
Cc:     bigeasy@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        torvalds@linux-foundation.org, will@kernel.org,
        joel@joelfernandes.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, dave@stgolabs.net,
        Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 1/4] rcuwait: Fix stale wake call name in comment
Date:   Mon, 23 Mar 2020 21:44:50 -0700
Message-Id: <20200324044453.15733-2-dave@stgolabs.net>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200324044453.15733-1-dave@stgolabs.net>
References: <20200324044453.15733-1-dave@stgolabs.net>
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
index d70d47159640..a33c0baffdae 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -234,7 +234,7 @@ void rcuwait_wake_up(struct rcuwait *w)
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


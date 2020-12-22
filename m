Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C612DC14E
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 14:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbgLPNbI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 08:31:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgLPNbH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 08:31:07 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B86DC0617A6;
        Wed, 16 Dec 2020 05:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PccmPCCzsl5AXd2yr/SDspnaIQTIwIgNAjEsRYyVJ6Q=; b=Fanh4/Ub9cv2qTRs549wIA/XFm
        nsFkkxhxJF9oOyXkZ6Y5Nw6lmYjcYsGH+6UQWQGXjq0If4X3+asMbh6CyjAoW+0L/+rEt89U4s84l
        hJ/E3BpZ0ess6UXAxvif2OTr2cUHHuQe3E79lqU1hApR0Hlq1rUuuffCwtma5QjE/nLnm8QikTm2d
        UpYluT770mBUaoqvr5gTbLR/QlTyg7suE6dGhQlp25NkvQzfSswipXoFm90n0ZHgF+vUd4XcFgQy6
        79nmDNTuCAXfS75zU9OaOJF/DQT+g9wP26sQurerPypVq1cynGofXrSwGRtbIqP6ON+eWEiq9M9S8
        zl0sP8aA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kpWsh-000281-Tu; Wed, 16 Dec 2020 13:30:16 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 51D58304D58;
        Wed, 16 Dec 2020 14:30:14 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 2B8B121ADB49F; Wed, 16 Dec 2020 14:30:14 +0100 (CET)
Date:   Wed, 16 Dec 2020 14:30:14 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jeyu@kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        ardb@kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Jason Baron <jbaron@akamai.com>
Subject: [RFC][PATCH] jump_label/static_call: Add MAINTAINERS
Message-ID: <20201216133014.GT3092@hirez.programming.kicks-ass.net>
References: <MW4PR21MB1857CC85A6844C89183C93E9BFC59@MW4PR21MB1857.namprd21.prod.outlook.com>
 <20201216092649.GM3040@hirez.programming.kicks-ass.net>
 <20201216105926.GS3092@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216105926.GS3092@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


FWIW, I recently noticed we're not being Cc'ed on patches for this
stuff, so how about we do something like the below?

Anybody holler if they don't agree with the letter assigned, or if they
feel they've been left out entirely and want in on the 'fun' :-)

---
Subject: jump_label/static_call: Add MAINTAINERS
From: Peter Zijlstra <peterz@infradead.org>

These files don't appear to have a MAINTAINERS entry and as such
patches miss being seen by people who know this code.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 MAINTAINERS |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16766,6 +16766,18 @@ M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
 F:	drivers/net/ethernet/adaptec/starfire*
 
+STATIC BRANCH/CALL
+M:	Peter Zijlstra <peterz@infradead.org>
+M:	Josh Poimboeuf <jpoimboe@redhat.com>
+M:	Jason Baron <jbaron@akamai.com>
+R:	Steven Rostedt <rostedt@goodmis.org>
+R:	Ard Biesheuvel <ardb@kernel.org>
+S:	Supported
+F:	include/linux/jump_label*.h
+F:	include/linux/static_call*.h
+F:	kernel/jump_label.c
+F:	kernel/static_call.c
+
 STEC S1220 SKD DRIVER
 M:	Damien Le Moal <Damien.LeMoal@wdc.com>
 L:	linux-block@vger.kernel.org

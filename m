Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7708537BBFC
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 13:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbhELLlt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 07:41:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:48012 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230293AbhELLlr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 07:41:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E8690B048;
        Wed, 12 May 2021 11:40:38 +0000 (UTC)
Date:   Wed, 12 May 2021 12:40:35 +0100
From:   Mel Gorman <mgorman@suse.de>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     tglx@linutronix.de, mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, bristot@redhat.com,
        bsingharora@gmail.com, pbonzini@redhat.com, maz@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        riel@surriel.com, hannes@cmpxchg.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 7/6] delayacct: Add sysctl to enable at runtime
Message-ID: <20210512114035.GH3672@suse.de>
References: <20210505105940.190490250@infradead.org>
 <YJkhebGJAywaZowX@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <YJkhebGJAywaZowX@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 10, 2021 at 02:05:13PM +0200, Peter Zijlstra wrote:
> 
> Just like sched_schedstats, allow runtime enabling (and disabling) of
> delayacct. This is useful if one forgot to add the delayacct boot time
> option.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  Documentation/accounting/delay-accounting.rst |    6 ++--
>  kernel/delayacct.c                            |   36 ++++++++++++++++++++++++--
>  kernel/sysctl.c                               |   12 ++++++++
>  3 files changed, 50 insertions(+), 4 deletions(-)
> 

Update sysctl/kernel.rst?

diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
index 1d56a6b73a4e..5d9193bd8d27 100644
--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -1087,6 +1087,13 @@ Model available). If your platform happens to meet the
 requirements for EAS but you do not want to use it, change
 this value to 0.
 
+sched_delayacct
+===============
+
+Enables/disables task delay accounting (see
+:doc:`accounting/delay-accounting.rst`). Enabling this feature incurs
+a small amount of overhead in the scheduler but is useful for debugging
+and performance tuning. It is required by some tools such as iotop.
 
 sched_schedstats
 ================

-- 
Mel Gorman
SUSE Labs

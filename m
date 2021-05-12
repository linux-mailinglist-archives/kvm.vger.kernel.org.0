Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9039337BBE4
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 13:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhELLg2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 07:36:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:43094 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230114AbhELLg2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 07:36:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 67EE0AF1F;
        Wed, 12 May 2021 11:35:19 +0000 (UTC)
Date:   Wed, 12 May 2021 12:35:16 +0100
From:   Mel Gorman <mgorman@suse.de>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     tglx@linutronix.de, mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, bristot@redhat.com,
        bsingharora@gmail.com, pbonzini@redhat.com, maz@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        riel@surriel.com, hannes@cmpxchg.org
Subject: Re: [PATCH 6/6] [RFC] delayacct: Default disabled
Message-ID: <20210512113516.GG3672@suse.de>
References: <20210505105940.190490250@infradead.org>
 <20210505111525.308018373@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210505111525.308018373@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 05, 2021 at 12:59:46PM +0200, Peter Zijlstra wrote:
> Assuming this stuff isn't actually used much; disable it by default
> and avoid allocating and tracking the task_delay_info structure.
> 
> taskstats is changed to still report the regular sched and sched_info
> and only skip the missing task_delay_info fields instead of not
> reporting anything.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs

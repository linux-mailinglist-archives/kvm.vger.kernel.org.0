Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F9637BB7C
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 13:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhELLM4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 07:12:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:52518 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230168AbhELLMz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 07:12:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E61AFAFAA;
        Wed, 12 May 2021 11:11:45 +0000 (UTC)
Date:   Wed, 12 May 2021 12:11:43 +0100
From:   Mel Gorman <mgorman@suse.de>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     tglx@linutronix.de, mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, bristot@redhat.com,
        bsingharora@gmail.com, pbonzini@redhat.com, maz@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        riel@surriel.com, hannes@cmpxchg.org
Subject: Re: [PATCH 4/6] kvm: Select SCHED_INFO instead of TASK_DELAY_ACCT
Message-ID: <20210512111143.GD3672@suse.de>
References: <20210505105940.190490250@infradead.org>
 <20210505111525.187225172@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210505111525.187225172@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 05, 2021 at 12:59:44PM +0200, Peter Zijlstra wrote:
> AFAICT KVM only relies on SCHED_INFO. Nothing uses the p->delays data
> that belongs to TASK_DELAY_ACCT.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs

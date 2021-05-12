Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B3137BB91
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 13:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhELLPL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 07:15:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:55592 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230329AbhELLPG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 07:15:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 27639B02A;
        Wed, 12 May 2021 11:13:57 +0000 (UTC)
Date:   Wed, 12 May 2021 12:13:54 +0100
From:   Mel Gorman <mgorman@suse.de>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     tglx@linutronix.de, mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, bristot@redhat.com,
        bsingharora@gmail.com, pbonzini@redhat.com, maz@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        riel@surriel.com, hannes@cmpxchg.org
Subject: Re: [PATCH 5/6] delayacct: Add static_branch in scheduler hooks
Message-ID: <20210512111354.GE3672@suse.de>
References: <20210505105940.190490250@infradead.org>
 <20210505111525.248028369@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210505111525.248028369@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 05, 2021 at 12:59:45PM +0200, Peter Zijlstra wrote:
> Cheaper when delayacct is disabled.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs

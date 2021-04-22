Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE81367EF0
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 12:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235863AbhDVKq2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 06:46:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:54666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230270AbhDVKq1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 06:46:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4ECAD613C4;
        Thu, 22 Apr 2021 10:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619088352;
        bh=TGwnKk/RxvquNuLw5D+m/omaHgTDQoSOY+tpVfcrgEM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L5yfjC8lbYuMRmPdHO6ptjp8eu5N99h7ZnBGiGzWGeTtqdJ9kqbZhWDy4q7gtd5YY
         RVr5CfV6tOpE5eZ0AU+6jk3WUcB0ub0Xyl5HgWucC/jQ85emuUQyVQV9fXj2MtyzHd
         ZsGp1DQwGyyJEPO5pQ4X+VHXCoadt6N5AfN+HmoIoO3whD55gR1/KXElfJlV2z7PeD
         4tt0krHZ4CZFGIDZpDOoUCCE0DQA2r4qIs0r1LLBKX+FmXnsZ7FZ1yS0OPQvjkDVCU
         umqonzbStYcdoLStaZ4vVJyqHYxmqKwuRzg8o/BpGT9FTcWQuBn4nYIeOiYZ31Avxv
         FDk5QCVI4sT8w==
Date:   Thu, 22 Apr 2021 11:45:46 +0100
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Rich Felker <dalias@libc.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, nathan@kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 2/5] arm64: Get rid of oprofile leftovers
Message-ID: <20210422104545.GD1442@willie-the-truck>
References: <20210414134409.1266357-1-maz@kernel.org>
 <20210414134409.1266357-3-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414134409.1266357-3-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 14, 2021 at 02:44:06PM +0100, Marc Zyngier wrote:
> perf_pmu_name() and perf_num_counters() are now unused. Drop them.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  drivers/perf/arm_pmu.c | 30 ------------------------------
>  1 file changed, 30 deletions(-)

Nice! This was some of the first code I ever wrote in the kernel but I can't
say I miss it:

Acked-by: Will Deacon <will@kernel.org>

Will

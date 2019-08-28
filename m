Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E38FEA0503
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 16:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfH1Ocg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 10:32:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57118 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbfH1Ocg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 10:32:36 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 43188811D8;
        Wed, 28 Aug 2019 14:32:36 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 851FE6060D;
        Wed, 28 Aug 2019 14:32:34 +0000 (UTC)
Date:   Wed, 28 Aug 2019 16:32:32 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, rkrcmar@redhat.com, maz@kernel.org,
        vladimir.murzin@arm.com, andre.przywara@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 01/16] arm: selftest.c: Remove
 redundant check for Exception Level
Message-ID: <20190828143232.nffx5tko3zbjbnbf@kamzik.brq.redhat.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
 <1566999511-24916-2-git-send-email-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566999511-24916-2-git-send-email-alexandru.elisei@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 28 Aug 2019 14:32:36 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 28, 2019 at 02:38:16PM +0100, Alexandru Elisei wrote:
> expected_regs.pstate already has PSR_MODE_EL1h set as the expected
> Exception Level.

That's true for selftest-vectors-kernel, but not for
selftest-vectors-user.

Thanks,
drew

> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/selftest.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/arm/selftest.c b/arm/selftest.c
> index 28a17f7a7531..176231f32ee1 100644
> --- a/arm/selftest.c
> +++ b/arm/selftest.c
> @@ -213,10 +213,6 @@ static bool check_regs(struct pt_regs *regs)
>  {
>  	unsigned i;
>  
> -	/* exception handlers should always run in EL1 */
> -	if (current_level() != CurrentEL_EL1)
> -		return false;
> -
>  	for (i = 0; i < ARRAY_SIZE(regs->regs); ++i) {
>  		if (regs->regs[i] != expected_regs.regs[i])
>  			return false;
> -- 
> 2.7.4
> 

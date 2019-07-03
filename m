Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 711495E881
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 18:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfGCQN5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 12:13:57 -0400
Received: from foss.arm.com ([217.140.110.172]:51754 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbfGCQN4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 12:13:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2DB5B344;
        Wed,  3 Jul 2019 09:13:56 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5FEE63F718;
        Wed,  3 Jul 2019 09:13:55 -0700 (PDT)
Date:   Wed, 3 Jul 2019 17:13:53 +0100
From:   Dave Martin <Dave.Martin@arm.com>
To:     Marc Zyngier <marc.zyngier@arm.com>
Cc:     kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 02/59] KVM: arm64: Move __load_guest_stage2 to kvm_mmu.h
Message-ID: <20190703161353.GT2790@e103592.cambridge.arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-3-marc.zyngier@arm.com>
 <20190624111924.GK2790@e103592.cambridge.arm.com>
 <bf4e43db-a0ea-9489-1a8c-280a72950cad@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf4e43db-a0ea-9489-1a8c-280a72950cad@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 03, 2019 at 10:30:03AM +0100, Marc Zyngier wrote:
> On 24/06/2019 12:19, Dave Martin wrote:
> > On Fri, Jun 21, 2019 at 10:37:46AM +0100, Marc Zyngier wrote:
> >> Having __load_guest_stage2 in kvm_hyp.h is quickly going to trigger
> >> a circular include problem. In order to avoid this, let's move
> >> it to kvm_mmu.h, where it will be a better fit anyway.
> >>
> >> In the process, drop the __hyp_text annotation, which doesn't help
> >> as the function is marked as __always_inline.
> > 
> > Does GCC always inline things marked __always_inline?
> > 
> > I seem to remember some gotchas in this area, but I may be being
> > paranoid.
> 
> Yes, this is a strong guarantee. Things like static keys rely on that,
> for example.
> 
> > 
> > If this still only called from hyp, I'd be tempted to heep the
> > __hyp_text annotation just to be on the safe side.
> 
> The trouble with that is that re-introduces the circular dependency with
> kvm_hyp.h that this patch is trying to break...

Ah, right.

I guess it's easier to put up with this, then.

Cheers
---Dave

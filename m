Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 781F1596D04
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 12:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239018AbiHQKvb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 06:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236115AbiHQKv3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 06:51:29 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BDF506C76D
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 03:51:28 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5241C113E;
        Wed, 17 Aug 2022 03:51:29 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1FCB13F67D;
        Wed, 17 Aug 2022 03:51:26 -0700 (PDT)
Date:   Wed, 17 Aug 2022 11:52:06 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
        suzuki.poulose@arm.com, will@kernel.org
Subject: Re: [PATCH v2 0/2] KVM: arm64: Uphold 64bit-only behavior on
 asymmetric systems
Message-ID: <YvzIVo5H21upnaPt@monolith.localdoman>
References: <20220816192554.1455559-1-oliver.upton@linux.dev>
 <87tu6bw5dd.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tu6bw5dd.wl-maz@kernel.org>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Wed, Aug 17, 2022 at 11:07:10AM +0100, Marc Zyngier wrote:
> On Tue, 16 Aug 2022 20:25:52 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > Small series to fix a couple issues around when 64bit-only behavior is
> > applied. As KVM is more restrictive than the kernel in terms of 32bit
> > support (no asymmetry), we really needed our own predicate when the
> > meaning of system_supports_32bit_el0() changed in commit 2122a833316f
> > ("arm64: Allow mismatched 32-bit EL0 support").
> > 
> > Lightly tested as I do not have any asymmetric systems on hand at the
> > moment. Attention on patch 2 would be appreciated as it affects ABI.
> 
> I don't think this significantly affect the ABI, as it is pretty
> unlikely that you'd have been able to execute the result, at least on
> VM creation (set PSTATE.M=USR, start executing, get the page fault on
> the first instruction... bang).
> 
> You could have tricked it in other ways, but at the end of the day
> you're running a broken hypervisor on an even more broken system...

Just FYI, you can create such a system on models, by running two clusters
and setting clusterX.max_32bit_el=-1. Or you can have even crazier
configurations, where AArch32 support is present on only one cluster, and
only for EL0.

Thanks,
Alex

> 
> Anyway, I've applied this to fixes.
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0680E1BC4BC
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 18:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbgD1QNz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 12:13:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728035AbgD1QNz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 12:13:55 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B69F2063A;
        Tue, 28 Apr 2020 16:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588090434;
        bh=CHxPMdMtXgCxp7jYJRO9Lz56+pxSSBnx2dPI3JGn6mQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Oh8fOJLNiku2IDCPSQblj3TfEucyBMwB1dATPVIP2q2tPa5qN05yteDCnICfRyouX
         2v4HOThXeH7+UiZKXvk6VczULmRhp6sCi10Hj4qzZ6Sb01KtQsiuCxj3y0UWStUq3o
         GsBjYh+b2Ke9RL1tp+ueRqKW9M5vrPxbfvBiEWdg=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jTSrp-007QVJ-2k; Tue, 28 Apr 2020 17:13:53 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 28 Apr 2020 17:13:53 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Will Deacon <will@kernel.org>
Cc:     Fuad Tabba <tabba@google.com>, catalin.marinas@arm.com,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        trivial@kernel.org, jeffv@google.com
Subject: Re: [PATCH] KVM: Fix spelling in code comments
In-Reply-To: <20200428155847.GC12697@willie-the-truck>
References: <20200401140310.29701-1-tabba@google.com>
 <20200428155847.GC12697@willie-the-truck>
User-Agent: Roundcube Webmail/1.4.3
Message-ID: <38234cbd287b9e7f4b87ec3d6fa9b0e5@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, tabba@google.com, catalin.marinas@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, trivial@kernel.org, jeffv@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-04-28 16:58, Will Deacon wrote:
> On Wed, Apr 01, 2020 at 03:03:10PM +0100, Fuad Tabba wrote:
>> Fix spelling and typos (e.g., repeated words) in comments.
>> 
>> Signed-off-by: Fuad Tabba <tabba@google.com>
>> ---
>>  arch/arm64/kvm/guest.c        | 4 ++--
>>  arch/arm64/kvm/reset.c        | 6 +++---
>>  arch/arm64/kvm/sys_regs.c     | 6 +++---
>>  virt/kvm/arm/arm.c            | 6 +++---
>>  virt/kvm/arm/hyp/vgic-v3-sr.c | 2 +-
>>  virt/kvm/arm/mmio.c           | 2 +-
>>  virt/kvm/arm/mmu.c            | 6 +++---
>>  virt/kvm/arm/psci.c           | 6 +++---
>>  virt/kvm/arm/vgic/vgic-v3.c   | 2 +-
>>  virt/kvm/coalesced_mmio.c     | 2 +-
>>  virt/kvm/eventfd.c            | 2 +-
>>  virt/kvm/kvm_main.c           | 2 +-
>>  12 files changed, 23 insertions(+), 23 deletions(-)
> 
> FWIW, these *do* all look like valid typos to me, but I'll leave it at
> Marc's discretion as to whether he wants to merge the series, since 
> things
> like this can confuse 'git blame' and get in the way of backports.

I have provisionally queued this a couple of weeks ago, with a goal to
apply it on top of the whole arm64 cleanup series.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...

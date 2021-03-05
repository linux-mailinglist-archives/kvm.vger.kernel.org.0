Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A6E32F379
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 20:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhCETHb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 14:07:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:33434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229758AbhCETHN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 14:07:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DC1A6509E;
        Fri,  5 Mar 2021 19:07:11 +0000 (UTC)
Date:   Fri, 5 Mar 2021 19:07:09 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH] KVM: arm64: Ensure I-cache isolation between vcpus of a
 same VM
Message-ID: <20210305190708.GL23855@arm.com>
References: <20210303164505.68492-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303164505.68492-1-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 03, 2021 at 04:45:05PM +0000, Marc Zyngier wrote:
> It recently became apparent that the ARMv8 architecture has interesting
> rules regarding attributes being used when fetching instructions
> if the MMU is off at Stage-1.
> 
> In this situation, the CPU is allowed to fetch from the PoC and
> allocate into the I-cache (unless the memory is mapped with
> the XN attribute at Stage-2).

Digging through the ARM ARM is hard. Do we have this behaviour with FWB
as well?

-- 
Catalin

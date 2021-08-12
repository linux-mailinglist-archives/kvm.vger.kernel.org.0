Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6ED63EA134
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 10:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235586AbhHLJAX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 05:00:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235567AbhHLJAX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 05:00:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F383A60C3F;
        Thu, 12 Aug 2021 08:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628758798;
        bh=LSnxIAWFBH+TXzoUemge/IGwf/7z3pt2Uhl+LDDkxG0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=itKfYN4tnJcJNST1aLwNL7a+/CGcbemG2hv6LXhDO5dQZTv+04wX+2HMYoiIC7c2G
         D99xgtedO5NbHZmKgAsT7fqJuOpp98cGy+w/+SOtceyBG2H+EDh8eKqSQZNkyQ7t3o
         SViG1JoldkmNPMYdEKqCbV832AmUrTYYHI+JsEye+2YhBtTBYZsif6yJJC+VqQap4b
         P4Rx2Jh1Q4uoTVzfiZjOoTnC72RvnmBEL0ytFbdktRyszTzG0ny1pyKyPYRFIYeT1A
         Y8CBF/mLJMFFwzPWbZ3HSZxM1R9hACQdgFrAbDuoc4WYHrW/vLtRR+mtqxg5b/X0to
         3fj6BL17+wRIQ==
Date:   Thu, 12 Aug 2021 09:59:53 +0100
From:   Will Deacon <will@kernel.org>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Subject: Re: [PATCH v3 09/15] KVM: arm64: Add config register bit definitions
Message-ID: <20210812085952.GG5912@willie-the-truck>
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-10-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719160346.609914-10-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 19, 2021 at 05:03:40PM +0100, Fuad Tabba wrote:
> Add hardware configuration register bit definitions for HCR_EL2
> and MDCR_EL2. Future patches toggle these hyp configuration
> register bits to trap on certain accesses.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_arm.h | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)

I checked all of these against the Arm ARM and they look correct to me:

Acked-by: Will Deacon <will@kernel.org>

Will

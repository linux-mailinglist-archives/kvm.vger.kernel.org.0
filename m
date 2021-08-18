Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33463F0486
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 15:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236817AbhHRNWo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 09:22:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236731AbhHRNWh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 09:22:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 974B560232;
        Wed, 18 Aug 2021 13:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629292923;
        bh=sPj+IO31w+5a8e1Hoa/GlytzFKIw6PQM72kgo1I8pd4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jo1gxH3HkFdM8PKOw/vCByec43EbCwMJpYviJkjPOL+xuM8TgJRQdLCBoGOAhhPC3
         l1I23oJKKFzo7ou8pq0FJZuH4Ke4AWT8vIb+EEK6KwRxGJn1r5KuKljdvgnB7mKlre
         ixHdL0qoVpvk2tNty3cWxB59hW+ZSsPdhPWaXfn5/dL5jbTms3jA2NgpR00XrA1CmS
         byEsAzcSeN//PGf28zcvt/fSNCfWbL82UQQweuXEI7zydF7m84eJwvjGZXMD5OGFG2
         T6RGp82aoiUSsl3SXgtJHrIlF0iMYf/tNUdN2RenhG5R3NgfB6IBrAaDYVXhvdz7ov
         2Il+IiAHRNhqg==
Date:   Wed, 18 Aug 2021 14:21:57 +0100
From:   Will Deacon <will@kernel.org>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: Re: [PATCH v4 09/15] KVM: arm64: Add feature register flag
 definitions
Message-ID: <20210818132156.GF14107@willie-the-truck>
References: <20210817081134.2918285-1-tabba@google.com>
 <20210817081134.2918285-10-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210817081134.2918285-10-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 17, 2021 at 09:11:28AM +0100, Fuad Tabba wrote:
> Add feature register flag definitions to clarify which features
> might be supported.
> 
> Consolidate the various ID_AA64PFR0_ELx flags for all ELs.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/cpufeature.h |  4 ++--
>  arch/arm64/include/asm/sysreg.h     | 12 ++++++++----
>  arch/arm64/kernel/cpufeature.c      |  8 ++++----
>  3 files changed, 14 insertions(+), 10 deletions(-)

Thanks, looks better now:

Acked-by: Will Deacon <will@kernel.org>

Will


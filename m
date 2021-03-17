Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80FC133F213
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 15:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhCQOBu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 10:01:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:48834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231364AbhCQOBV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 10:01:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BCF964F6A;
        Wed, 17 Mar 2021 14:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615989681;
        bh=R6KOf4597iuSM4zPgAf8uid9pCmGJM6V8VLQdYKDtuk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AMuPGbX/1Rbfsk9QPCfX1ABnBwbsQubBcaLqciEpZlKtAgiqP48jjGh+q9ue11UFc
         JeLgldqcpVhBn9ZcVzjVr44x/u7Ud8Z7E3oVAajsMohBLdggCeVBxMt5oJf7QxdmH5
         NsX1HJxvy8xCxOzCnQMm90gF5LiyhKSFPTjRX/wIys6PtNWW0Eg3jVjAdNtD2wbd/7
         yF94m1w1jg4yDHW6iz1rbJ1wESGkHHylcdbEk5IfcI76xeqIQm6uYvS1a+0w3pClan
         xuRRdZOwm/yfnaLgeUq/MBEQR2rO8EghdnWRxmry+fKdv0LLCSdLyaE/KmwX75vrQO
         vs6WJ9R7Hocsg==
Date:   Wed, 17 Mar 2021 14:01:15 +0000
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, dave.martin@arm.com, daniel.kiss@arm.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        broonie@kernel.org, kernel-team@android.com
Subject: Re: [PATCH 04/10] KVM: arm64: Introduce vcpu_sve_vq() helper
Message-ID: <20210317140115.GA5295@willie-the-truck>
References: <20210316101312.102925-1-maz@kernel.org>
 <20210316101312.102925-5-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316101312.102925-5-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 10:13:06AM +0000, Marc Zyngier wrote:
> The KVM code contains a number of "sve_vq_from_vl(vcpu->arch.sve_max_vl)"
> instances, and we are about to add more.
> 
> Introduce vcpu_sve_vq() as a shorthand for this expression.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h       | 4 +++-
>  arch/arm64/kvm/guest.c                  | 6 +++---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
>  3 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index fb1d78299ba0..c4afe3d3397f 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -375,6 +375,8 @@ struct kvm_vcpu_arch {
>  #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
>  			     sve_ffr_offset((vcpu)->arch.sve_max_vl))
>  
> +#define vcpu_sve_vq(vcpu)	sve_vq_from_vl((vcpu)->arch.sve_max_vl)

nit: maybe vcpu_sve_max_vq() would be a better name?

Either way:

Acked-by: Will Deacon <will@kernel.org>

Will

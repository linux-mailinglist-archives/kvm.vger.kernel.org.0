Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A78233F7B8
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 19:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbhCQSAf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 14:00:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231332AbhCQSAX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 14:00:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFD5264F21;
        Wed, 17 Mar 2021 18:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616004023;
        bh=19/EHa8tqrBvjr5N+17FlDNPaZq4lw493X2jfLFSXMU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qmtsr6jfQGZvpiPtqAKOYAJGAFJD/3AieD2zGweFccZ92UmjEDsr47puog4UPWImD
         jL423PnqghvSY69wUYdL60Zq3mOq3jAh3t4deDklE6s7quCvhuz6CcBAwOzGyHqq+3
         5AsJZo9WM7OkYmHZHutAgu3lCGyF/2AJchbrEb8zrWfchIzb6SujeKEbYjmMjl2yPi
         L11n1lRaoZlIgP+KHv/yt2TZeVBJekNsyNQYghmVeONuOr9Lpcl290whyZaoQAR2wZ
         9SGFNkG1qdacKrB/ceUun0OuG0dSEinmoliDwo1IlsZBvyJnSgNWTQitAYeD1TNUhB
         q+8m8ZGZASQMg==
Date:   Wed, 17 Mar 2021 18:00:17 +0000
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, dave.martin@arm.com, daniel.kiss@arm.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        broonie@kernel.org, kernel-team@android.com
Subject: Re: [PATCH 10/10] KVM: arm64: Enable SVE support for nVHE
Message-ID: <20210317180017.GB5713@willie-the-truck>
References: <20210316101312.102925-1-maz@kernel.org>
 <20210316101312.102925-11-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316101312.102925-11-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 10:13:12AM +0000, Marc Zyngier wrote:
> From: Daniel Kiss <daniel.kiss@arm.com>
> 
> Now that KVM is equipped to deal with SVE on nVHE, remove the code
> preventing it from being used as well as the bits of documentation
> that were mentioning the incompatibility.
> 
> Signed-off-by: Daniel Kiss <daniel.kiss@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/Kconfig                |  7 -------
>  arch/arm64/include/asm/kvm_host.h | 13 -------------
>  arch/arm64/kvm/arm.c              |  5 -----
>  arch/arm64/kvm/reset.c            |  4 ----
>  4 files changed, 29 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

I thought we might need to update the documentation too, but I couldn't
actually find anywhere that needed it when I looked.

Will

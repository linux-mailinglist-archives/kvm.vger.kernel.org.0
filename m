Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35CED2AFAF2
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 23:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgKKWBb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 17:01:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:55606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726459AbgKKWBb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Nov 2020 17:01:31 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E34FF20797;
        Wed, 11 Nov 2020 22:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605132090;
        bh=cO+Oo7tLJ0GIAI1cy0gnQJnk1VhcwPfJeLVIEUWbAjo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0MCjeen4txQHseNpwO2xJkY7ofMCB9iLyuQwfy7IB4UUnn5hVoknQYTjpZ7DTK//0
         iM6X/hzrmCNMLv5DQQM1nCp7gqen69Nq81eZYmoAZAhmMU7JJJtHA9wrTTiLlnKnCv
         euwrnkyS++e9JHHifqXmjwjeqVrYBv/mbfforNbY=
Date:   Wed, 11 Nov 2020 22:01:25 +0000
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        Peng Liang <liangpeng10@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH v2 2/3] KVM: arm64: Unify trap handlers injecting an UNDEF
Message-ID: <20201111220125.GB18414@willie-the-truck>
References: <20201110141308.451654-1-maz@kernel.org>
 <20201110141308.451654-3-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110141308.451654-3-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 10, 2020 at 02:13:07PM +0000, Marc Zyngier wrote:
> A large number of system register trap handlers only inject an
> UNDEF exeption, and yet each class of sysreg seems to provide its
> own, identical function.
> 
> Let's unify them all, saving us introducing yet another one later.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 65 +++++++++++++++------------------------
>  1 file changed, 25 insertions(+), 40 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will

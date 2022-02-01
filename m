Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE7D4A60C6
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 16:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240722AbiBAPxa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 10:53:30 -0500
Received: from foss.arm.com ([217.140.110.172]:48454 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237890AbiBAPx3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 10:53:29 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8C323113E;
        Tue,  1 Feb 2022 07:53:29 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 825563F40C;
        Tue,  1 Feb 2022 07:53:28 -0800 (PST)
Date:   Tue, 1 Feb 2022 15:01:34 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Martin Radev <martin.b.radev@gmail.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: Re: [PATCH kvmtool 4/5] Makefile: Mark stack as not executable
Message-ID: <20220201150134.37c5fb66@donnerap.cambridge.arm.com>
In-Reply-To: <e90b5826343e0e5858db015df44e4eaa332bd938.1642457047.git.martin.b.radev@gmail.com>
References: <cover.1642457047.git.martin.b.radev@gmail.com>
        <e90b5826343e0e5858db015df44e4eaa332bd938.1642457047.git.martin.b.radev@gmail.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Jan 2022 00:12:02 +0200
Martin Radev <martin.b.radev@gmail.com> wrote:

> This patch modifies CFLAGS to mark the stack explicitly
> as not executable.
> 
> Signed-off-by: Martin Radev <martin.b.radev@gmail.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  Makefile | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index f251147..09ef282 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -380,8 +380,11 @@ DEFINES	+= -D_GNU_SOURCE
>  DEFINES	+= -DKVMTOOLS_VERSION='"$(KVMTOOLS_VERSION)"'
>  DEFINES	+= -DBUILD_ARCH='"$(ARCH)"'
>  
> +# The stack doesn't need to be executable
> +SECURITY_HARDENINGS := -z noexecstack
> +
>  KVM_INCLUDE := include
> -CFLAGS	+= $(CPPFLAGS) $(DEFINES) -I$(KVM_INCLUDE) -I$(ARCH_INCLUDE) -O2 -fno-strict-aliasing -g
> +CFLAGS	+= $(CPPFLAGS) $(DEFINES) $(SECURITY_HARDENINGS) -I$(KVM_INCLUDE) -I$(ARCH_INCLUDE) -O2 -fno-strict-aliasing -g
>  
>  WARNINGS += -Wall
>  WARNINGS += -Wformat=2
> @@ -582,4 +585,4 @@ ifneq ($(MAKECMDGOALS),clean)
>  
>  KVMTOOLS-VERSION-FILE:
>  	@$(SHELL_PATH) util/KVMTOOLS-VERSION-GEN $(OUTPUT)
> -endif
> \ No newline at end of file
> +endif


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B8330A902
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 14:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbhBANqi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 08:46:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:47650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231284AbhBANqg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 08:46:36 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FAC864D99;
        Mon,  1 Feb 2021 13:45:55 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1l6ZWb-00BHWZ-EK; Mon, 01 Feb 2021 13:45:53 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 01 Feb 2021 13:45:53 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Linux-Next Mailing List <linux-next@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, lkft-triage@lists.linaro.org,
        kvmarm@lists.cs.columbia.edu,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        James Morse <james.morse@arm.com>,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Subject: Re: arm64: gen-hyprel.c:40:10: fatal error: generated/autoconf.h: No
 such file or directory
In-Reply-To: <CA+G9fYvzh5GEssPJHM=r2TVUKOhsFJ8jqrY+pP4t7+jF8ctz9A@mail.gmail.com>
References: <CA+G9fYvzh5GEssPJHM=r2TVUKOhsFJ8jqrY+pP4t7+jF8ctz9A@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <5f072f84c7c9b03ded810e56687935b2@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: naresh.kamboju@linaro.org, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, lkft-triage@lists.linaro.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, sfr@canb.auug.org.au, arnd@arndb.de, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-02-01 13:38, Naresh Kamboju wrote:
> Linux next 20210201 tag arm64 builds failed.
> kernel config attached to this email.
> 
> BAD:    next-20210201
> GOOD: next-20210129
> 
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=arm64
> CROSS_COMPILE=aarch64-linux-gnu- 'CC=sccache aarch64-linux-gnu-gcc'
> 'HOSTCC=sccache gcc'
> arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:40:10: fatal error:
> generated/autoconf.h: No such file or directory
>    40 | #include <generated/autoconf.h>
>       |          ^~~~~~~~~~~~~~~~~~~~~~
> compilation terminated.
> 
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

Could you please check with the fix suggested at [1]?

Thanks,

         M.

[1] https://lore.kernel.org/r/20210201104251.5foc64qq3ewgnhuz@google.com
-- 
Jazz is not dead. It just smells funny...

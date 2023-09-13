Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 933C379EF70
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 18:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjIMQ4g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 12:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjIMQ4f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 12:56:35 -0400
X-Greylist: delayed 577 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 13 Sep 2023 09:56:31 PDT
Received: from out-211.mta0.migadu.com (out-211.mta0.migadu.com [91.218.175.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A90B7
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 09:56:31 -0700 (PDT)
Date:   Wed, 13 Sep 2023 16:46:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694623612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=feVS4B5LNs4OUmHDp+EA+Nx30GrdETelcpYRXM6KOig=;
        b=dfadPrblVRHjAees1Xudp1s1OT42l8nar625isqgh1QwTha5HRan3k5aMEm2G35xfI85UZ
        qIhA8cGEFkw0khi0Fh+HH7tbho5OokMCRYQb9muFUucCnv/9A4yrOW9HCz+Avo0gwRo/1P
        iFLMCV3LAY5Yb0ojy/FX1NE/lWJq1e0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Shaoqin Huang <shahuang@redhat.com>, rananta@google.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: Re: kvm: arm64: WARNING: CPU: 3 PID: 1 at
 arch/arm64/kvm/hyp/pgtable.c:453 hyp_map_walker+0xa8/0x120
Message-ID: <ZQHndmjItuE7AOyz@linux.dev>
References: <CA+G9fYtC0iTRSRj8WSw5KMDwrx4Z3Djo89OXXdHjna9r3qy3Kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtC0iTRSRj8WSw5KMDwrx4Z3Djo89OXXdHjna9r3qy3Kg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Naresh,

Can you cc the correct kvmarm mailing list in the future? We had to
migrate a few releases ago but the right address is in MAINTAINERS.

On Wed, Sep 13, 2023 at 05:33:28PM +0530, Naresh Kamboju wrote:
> Following kernel warning noticed on arm64 Raspberry Pi 4 Model B and
> Juno-r2 devices while booting the mainline 6.6.0-rc1 kernel.

Thanks for the report. This came up already and Marc has a fix queued up
that'll find its way to Linus' tree eventually:

https://lore.kernel.org/kvmarm/20230828153121.4179627-1-maz@kernel.org/

-- 
Thanks,
Oliver

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4165A17E9
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 19:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242109AbiHYRWF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 13:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234511AbiHYRWE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 13:22:04 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E40B9419
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 10:22:02 -0700 (PDT)
Date:   Thu, 25 Aug 2022 10:21:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661448120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fv5uLAiqTfJ7ki0m8vXx4vs+Jg/Y+MlltpOcaffBFAo=;
        b=hCNBLE8xOnvioAmSw1qaKUFLJI121ieWuU2y0LduHX7bASykDCdmx62a9ocDSXMbeikvGv
        j9Z8YdxxaCxUqCoOgvbiuKT8VIYjypf8Virf/z3Jlq2SKFg0Aki0uQX1f/KhoGfssBZMg7
        CD6u0+7mrIRtbaC54AbWc1boPzToqB0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/9] KVM: arm64: selftests: Add helpers to enable debug
 exceptions
Message-ID: <YwevrW4YrHQQOyew@google.com>
References: <20220825050846.3418868-1-reijiw@google.com>
 <20220825050846.3418868-5-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825050846.3418868-5-reijiw@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 24, 2022 at 10:08:41PM -0700, Reiji Watanabe wrote:
> Add helpers to enable breakpoint and watchpoint exceptions.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  .../selftests/kvm/aarch64/debug-exceptions.c  | 25 ++++++++++---------
>  1 file changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> index 183ee16acb7d..713c7240b680 100644
> --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> @@ -128,10 +128,20 @@ static void enable_os_lock(void)
>  	GUEST_ASSERT(read_sysreg(oslsr_el1) & 2);
>  }
>  
> +static void enable_debug_bwp_exception(void)

uber-nit: enable_monitor_debug_exceptions()

(more closely matches the definition of MDSCR_EL1.MDE)

With that:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver

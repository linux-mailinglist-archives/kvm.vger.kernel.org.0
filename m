Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B57EE679451
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 10:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbjAXJhl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 04:37:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjAXJhk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 04:37:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404E16E8D;
        Tue, 24 Jan 2023 01:37:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAA20B81104;
        Tue, 24 Jan 2023 09:37:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DBAC433EF;
        Tue, 24 Jan 2023 09:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674553055;
        bh=1zzgkNRfTR3Nd94PvxKyIX49lYH4mssft7KcQNucUqY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OuS4XbfhuQ3vkfJ5iXQDtE2abnO3giky+BFrHtX9/CzM2VEj7jIajVl3lm3t8TESe
         3J9E1BgzSrg6Ijj1OD9PnRHVMsi78EoCbg+uXeSxb6WSsq7GohmMbMB6KmCI5eqYlC
         RqeqIjuxVDDdeSyjJk6fNj87WntHQT8KbDLL9iSIlMmuD3/DhUbR0ljdemdHZDu+65
         HO79MXjydzAmPG7ReyEOs5t2keE1cwBs3yJGmsQw5IiXXFbsHs7QlTelg2ytdRDKx+
         Xot+lVqHRsDyREMJFq+iNzq8Xj42LhEf5N/+8L3IzjVWilnXZFdCXiHX0IaFigf5TF
         zCGl3E6GGApXw==
Date:   Tue, 24 Jan 2023 09:37:29 +0000
From:   Will Deacon <will@kernel.org>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     maz@kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
        catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] MAINTAINERS: Add Oliver Upton as co-maintainer of
 KVM/arm64
Message-ID: <20230124093728.GA26080@willie-the-truck>
References: <20230123210256.2728218-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123210256.2728218-1-oliver.upton@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 23, 2023 at 09:02:56PM +0000, Oliver Upton wrote:
> Going forward I intend to help Marc with maintaining KVM/arm64. We've
> spoken about this quite a bit and he has been a tremendous help in
> ramping up to the task (thank you!). We haven't worked out the exact
> details of how the process will work, but the goal is to even out the
> maintenance responsibilities to give us both ample time for development.
> 
> To that end, updating the maintainers entry to reflect the change.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 42fc47c6edfd..7323efcc1270 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11355,9 +11355,9 @@ F:	virt/kvm/*
>  
>  KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)
>  M:	Marc Zyngier <maz@kernel.org>
> +M:	Oliver Upton <oliver.upton@linux.dev>

Ya know, alphabetical order tends to put Mr Z at the bottom of the list,
but I can understand why you don't necessarily want to be first in the
pack just yet!

In any case, this is really great to see:

Acked-by: Will Deacon <will@kernel.org>

Thank you!

Will

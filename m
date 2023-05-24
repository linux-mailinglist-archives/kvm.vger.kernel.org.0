Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7320D70EC12
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 05:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239381AbjEXDtc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 23:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239273AbjEXDtW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 23:49:22 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481A31A7;
        Tue, 23 May 2023 20:49:13 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-513fd8cc095so154815a12.0;
        Tue, 23 May 2023 20:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684900151; x=1687492151;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+/2vcU3rfSk9ugDsVe4zLqIGe3H0V4ejxElXFrJjh6w=;
        b=YmYY+H/VoSoR+ArQyGVV1V1UF2SRlDFlntlkRjjvYEDRUxNgXoYh4pExSzlB8fjnyD
         LUOkERUALMd4w7b8N1d3zkN4kJ4rYsuA/1rEbEX8IrWKsjwHPAYPJAK8qhw7PGesJvQn
         Ok1d9bXYW6R8sjei/SN5+PceeLeuKVX+GO9sFOiIaRPCiqC5HZ1X5R6BURfKKvPRZvvk
         REeSwcTEMwe9xyzLU/7nlhJ0qpohOto7nbdeWZ9kf7oVvlKmC+OayM8w9KuxBqyegAIk
         lD5KQywmhEBMHqC/EcRw74YS8e6eOcpfRn8grmPnMI5I+1dQ+49C54UYRHh7dloDlyrZ
         CMpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684900151; x=1687492151;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+/2vcU3rfSk9ugDsVe4zLqIGe3H0V4ejxElXFrJjh6w=;
        b=Fh95OvZnsDa2nab9raJLzeczJlkSnZAOa+I5Kced5mTRGsri2Nb4V6MLUc0njme2Hi
         TYH3BiqnOgo3Nit+LXeIdUObggTQjYNdrtnKbH2jz2dPZPnBgYUorL4xYpZsC8qwKimT
         LD4/Lf36PLYjadMxLx1b6Z689iBC0O7ypCJwvysOyuysCR28U8+LM733pnysoCMYzHEo
         WGLEF8c2cQQDN199XKa3DuNjrvq2vA3Ho5t50xsOhQACWjSMJvXlDIHwNWnZSSrBiaPY
         Hpc7gIzDgLfvYC1rHL7TLgOQIRmYSGzOCGmhPw/5riMRhl4RcS0kbPtQAEF9k6ei+z4t
         ljcA==
X-Gm-Message-State: AC+VfDwI4lMc1+fu0lUuJ592PTOwkp8gvJ2nQFGUdYalORrzLKUqzbzq
        Fyg6lSMCN7pR6JI/6Bcx4uE=
X-Google-Smtp-Source: ACHHUZ4E2aCABHLtTxEIZdPJoT06zmAKgAfupT38TPqKIbH6rGwHi1/k1wUYqwPXrsR+6TBWas4mig==
X-Received: by 2002:a17:906:7393:b0:96f:56f1:e89e with SMTP id f19-20020a170906739300b0096f56f1e89emr12763657ejl.0.1684900150958;
        Tue, 23 May 2023 20:49:10 -0700 (PDT)
Received: from localhost ([192.55.46.56])
        by smtp.gmail.com with ESMTPSA id qx15-20020a170906fccf00b00965f98eefc1sm5213304ejb.116.2023.05.23.20.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 20:49:10 -0700 (PDT)
Date:   Wed, 24 May 2023 11:48:59 +0800
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, will@kernel.org,
        catalin.marinas@arm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, robin.murphy@arm.com,
        nicolinc@nvidia.com, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, jgg@nvidia.com,
        John Hubbard <jhubbard@nvidia.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 1/2] mmu_notifiers: Restore documentation for
 .invalidate_range()
Message-ID: <20230524114859.000016e3.zhi.wang.linux@gmail.com>
In-Reply-To: <3cece716fc09724793aa832e755abfc9d70a8bb3.1684892404.git-series.apopple@nvidia.com>
References: <3cece716fc09724793aa832e755abfc9d70a8bb3.1684892404.git-series.apopple@nvidia.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 24 May 2023 11:47:28 +1000
Alistair Popple <apopple@nvidia.com> wrote:

It is actually commit 4e15a073a168 ("Revert "mm, mmu_notifier:
annotate mmu notifiers with blockable invalidate callbacks"")'s problem.
It tries to revert commit 5ff7091f5a2c but forgets to get back this
piece of comment.

It would be better to have a Fixes tag in the commit message.

> The .invalidate_range() callback is called by
> mmu_notifier_invalidate_range() which is often called while holding
> the ptl spin-lock. Therefore any implementations of this callback must
> not sleep. This was originally documented when the call back was added
> in commit 0f0a327fa12c ("mmu_notifier: add the callback for
> mmu_notifier_invalidate_range()") but appears to have been
> inadvertently removed by commit 5ff7091f5a2c ("mm, mmu_notifier:
> annotate mmu notifiers with blockable invalidate callbacks").
> 
> Restore the comment to make it clear that .invalidate_range()
> callbacks may not sleep.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>  include/linux/mmu_notifier.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> index 64a3e05..447d757 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -200,6 +200,9 @@ struct mmu_notifier_ops {
>  	 * external TLB range needs to be flushed. For more in depth
>  	 * discussion on this see Documentation/mm/mmu_notifier.rst
>  	 *
> +	 * The invalidate_range() function is called under the ptl
> +	 * spin-lock and not allowed to sleep.
> +	 *
>  	 * Note that this function might be called with just a sub-range
>  	 * of what was passed to invalidate_range_start()/end(), if
>  	 * called between those functions.
> 
> base-commit: 44c026a73be8038f03dbdeef028b642880cf1511


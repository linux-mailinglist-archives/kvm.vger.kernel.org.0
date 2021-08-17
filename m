Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2CA3EF64A
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 01:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236635AbhHQXr2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 19:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235369AbhHQXrZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 19:47:25 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D753C061764
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 16:46:52 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id w8so344239pgf.5
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 16:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XqQFpWeHcUSQ+PzurepI7rzfCx4vcTPngCOlB1Frgp8=;
        b=lFKC+5yRwUMxrTd/aU32KYVl6pxWSqvF2ahYEDOtdrp1Vo0Uoendl7WxGHRZMdh4jd
         NQqluvnTV1RQuEvnI0VZAmFmxBEnChGj3HCvdS/RQPGyw7SFoWR/t7L9pkh5FDHBQ0hE
         0kuW3kkAozYwZ9sLpVGqRIFKPq7xPrGxw9KDgW3E/OK8oQKe9IC4u4GPLU1kIN27qCNj
         rBRowlRKGyZMnJfn/Nrl6xQu3bDkUg4YUkG713hP2hawXKwI59QoysKHY7mw4BsNpec4
         zWRebUy9+q4sDI+p2yKO8aCVbOqJBmSzSoExJbxoGOCeOMksyHrv4xmMsAjUugC9Xvsw
         52HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XqQFpWeHcUSQ+PzurepI7rzfCx4vcTPngCOlB1Frgp8=;
        b=tgmNXcc/RakYrwZEuhErMROixgZvvynog2GCLC+y3x2mocgaIgu95zehEEZEaB7nap
         49WxeLyH/I4WPBrz5E2PHtyebC670/xcOF1pQeY4HPCcaX8pTUOyYBPfoD3HlfXSvDEK
         tJX9mEIXA0T6Hbp/X7l3rES7hrgu63peAgmAnmz/+xQEbq0utXMUzPqPrMhgpd0RbRAw
         cWpAsm3Hl66bdYinLMEy6egWuzsL9fhazB+xIqaMWaYPuC0UuJ930I12XzO9Piu7Z/Xk
         9lZguEnflt7Adl8gw9dCaTFjV5MtLq++BCzgzh4cegndvmAIxVILLdlBeU+Wt6aYe3VH
         320g==
X-Gm-Message-State: AOAM5310BmGb6rT9954Wdk+u9OsrwJb8ZfQfYlYCrtxVxGd2CBpUy9Le
        uUWNoVdEyzpF/WqUX+rOyaiUenpN/54lzA==
X-Google-Smtp-Source: ABdhPJzPZi/rbcDO/mYvuJ8vRPrRzQvJbWlrYqeHyb74ExzFJcNnNFPVzvXV3W9Tu7TP+2eheAFEpg==
X-Received: by 2002:a63:5b04:: with SMTP id p4mr5969927pgb.236.1629244011395;
        Tue, 17 Aug 2021 16:46:51 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g26sm4356226pgb.45.2021.08.17.16.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 16:46:50 -0700 (PDT)
Date:   Tue, 17 Aug 2021 23:46:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Cannon Matthews <cannonmatthews@google.com>
Subject: Re: [PATCH] KVM: stats: add stats to detect if vcpu is currently
 halted
Message-ID: <YRxKZXm68FZ0jr34@google.com>
References: <20210817230508.142907-1-jingzhangos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210817230508.142907-1-jingzhangos@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 17, 2021, Jing Zhang wrote:
> Current guest/host/halt stats don't show when we are currently halting

s/we are/KVM is

And I would probably reword it to "when KVM is blocking a vCPU in response to
the vCPU activity state, e.g. halt".  More on that below.

> well. If a guest halts for a long period of time they could appear
> pathologically blocked but really it's the opposite there's nothing to
> do.
> Simply count the number of times we enter and leave the kvm_vcpu_block

s/we/KVM

In general, it's good practice to avoid pronouns in comments and changelogs as
doing so all but forces using precise, unambiguous language.  Things like 'it'
and 'they' are ok when it's abundantly clear what they refer to, but 'we' and 'us'
are best avoided entirely.

> function per vcpu, if they are unequal, then a VCPU is currently
> halting.
> The existing stats like halt_exits and halt_wakeups don't quite capture
> this. The time spend halted and halt polling is reported eventually, but
> not until we wakeup and resume. If a guest were to indefinitely halt one
> of it's CPUs we would never know, it may simply appear blocked.
     ^^^^      ^^
     its       userspace?


The "blocked" terminology is a bit confusing since KVM is explicitly blocking
the vCPU, it just happens to mostly do so in response to a guest HLT.  I think
"block" is intended to mean "vCPU task not run", but it would be helpful to make
that clear.

> Original-by: Cannon Matthews <cannonmatthews@google.com>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  include/linux/kvm_host.h  | 4 +++-
>  include/linux/kvm_types.h | 2 ++
>  virt/kvm/kvm_main.c       | 2 ++
>  3 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d447b21cdd73..23d2e19af3ce 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1459,7 +1459,9 @@ struct _kvm_stats_desc {
>  	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_hist,	       \
>  			HALT_POLL_HIST_COUNT),				       \
>  	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_wait_hist,	       \
> -			HALT_POLL_HIST_COUNT)
> +			HALT_POLL_HIST_COUNT),				       \
> +	STATS_DESC_COUNTER(VCPU_GENERIC, halt_block_starts),		       \
> +	STATS_DESC_COUNTER(VCPU_GENERIC, halt_block_ends)

Why two counters?  It's per-vCPU, can't this just be a "blocked" flag or so?  I
get that all the other stats use "halt", but that's technically wrong as KVM will
block vCPUs that are not runnable for other reason, e.g. because they're in WFS
on x86.

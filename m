Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 433CA5B3AD6
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 16:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbiIIOjU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 10:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbiIIOjP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 10:39:15 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E97913206E
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 07:39:10 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id l10so1969454plb.10
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 07:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=U5FTkv+asckv29sSKVU9VhH/lr2YF5aAU9B1yR0VWoQ=;
        b=SNLfz/BPCXqSkdAhvq4GvU5u/Z5tt8TxclpvUbaUFBxgnciVbFLAYtpmiFIAmek+wY
         gDXkF2dLCUmZcB3iBfaaeM0ZwAnC/axC9ionABVBgsLlm5K+mSfs3RyMyDUT86Tko+e4
         I1njM8j6MCm6VrBUJ+5PK6qcJCPC7maQKUUa2mZbmhG3LkW80dXIviWFmJ+EjIXUB2Ce
         xkUexljYzo90MGx4K9xrTPz5QWMG97Uq4QBRPDXCqWK+Hgcg5sWPReCOLQtQkTODKzAj
         PLOIy2ZMeqBeMmC4R+AwHW/erasfzTc+KAlmAFEOQj3lv+Um5vK+Li9Go0rAkGpbXxEn
         Mnaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=U5FTkv+asckv29sSKVU9VhH/lr2YF5aAU9B1yR0VWoQ=;
        b=T5TSjJtQ0JULgIjPG3Uom9r7LkndHeT0X84wTjEHtdtBl9ACJpg5iVxKXGtTA4ptlx
         taBtycjEhjoIW13lGShhdhoXD93O0hmy79MJBa34R0onMdoXdW7j91EufW95dmJCeTDB
         VcZAdxQuMG0l0scrGUm/ATfTKlQEveEE9za+NiPAZQPCV0HYRQGbzoz8M3WVIFppaFhY
         duAta3qZlBHllLL73q3OC49tT0Z3b/XRFhSeq/ksmYNSwnWfeY3MIwFkyIvUrQnIfZxi
         0mPFkZ+6euzhVAX1q1fJUP600+glgAo01Asfj/X21P79ReXnSEy3qM3eybzkzvCUUEBg
         crDA==
X-Gm-Message-State: ACgBeo2Wtq09cuS2y+lwMNpLuhGIZMxh+z1oo12j73zANwKIAXu/wg5c
        MHpwSM0SWVh4lSc2uL/SCVHwqw==
X-Google-Smtp-Source: AA6agR77AFUEIRdT9FJnK1ce2cvfJZqiSLVtJZ68JjdPp1h0NVmgzqTpF0raI7zxen4ZdJ50qNggnQ==
X-Received: by 2002:a17:902:e80f:b0:178:fee:c5fe with SMTP id u15-20020a170902e80f00b001780feec5femr1765435plg.85.1662734349476;
        Fri, 09 Sep 2022 07:39:09 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id mn22-20020a17090b189600b00200a85fa777sm566013pjb.1.2022.09.09.07.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 07:39:09 -0700 (PDT)
Date:   Fri, 9 Sep 2022 14:39:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Metin Kaya <metikaya@amazon.co.uk>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, x86@kernel.org,
        bp@alien8.de, dwmw@amazon.co.uk, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com,
        joao.m.martins@oracle.com
Subject: Re: [PATCH 1/2] KVM: x86/xen: Remove redundant NULL check
Message-ID: <YxtQCUJjZDhYpz0p@google.com>
References: <20220909095006.65440-1-metikaya@amazon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909095006.65440-1-metikaya@amazon.co.uk>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Channeling Jim, s/redundant/superfluous.  Redundant would imply there's a !NULL
check in close proximity.

On Fri, Sep 09, 2022, Metin Kaya wrote:
> 'kvm' cannot be NULL if we are at that point.

Please make the changelog a standalone thing, i.e. don't rely on the shortlog to
provide context.  Some subsystems prefer making the changelog a continuation of
the shortlog, but IMO it makes life unnecessarily painful for reviewers and
archaeologists, e.g. I don't even see the subject/shortlog right now.

Please elaborate on what guarantees that this in the changelog.  It's trivial to
see from the code, but the fact that it's trivial to document is all the more
reason to provide a one-liner.

E.g.

  Remove a superfluous check that @kvm is non-NULL in
  kvm_xen_eventfd_deassign(), the pointer has already been dereferenced
  multiple times before the check, and the sole caller unconditionally
  passes in a valid pointer.

> This bug was discovered and resolved using Coverity Static Analysis
> Security Testing (SAST) by Synopsys, Inc.
> 
> Fixes: 2fd6df2f2b47 ("KVM: x86/xen: intercept EVTCHNOP_send from
> guests")

Don't wrap fixes tags.

> Signed-off-by: Metin Kaya <metikaya@amazon.co.uk>
> ---
>  arch/x86/kvm/xen.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 280cb5dc7341..f2e09481f633 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -1734,8 +1734,7 @@ static int kvm_xen_eventfd_deassign(struct kvm *kvm, u32 port)
>  	if (!evtchnfd)
>  		return -ENOENT;
>  
> -	if (kvm)
> -		synchronize_srcu(&kvm->srcu);
> +	synchronize_srcu(&kvm->srcu);
>  	if (!evtchnfd->deliver.port.port)
>  		eventfd_ctx_put(evtchnfd->deliver.eventfd.ctx);
>  	kfree(evtchnfd);
> -- 
> 2.37.1
> 

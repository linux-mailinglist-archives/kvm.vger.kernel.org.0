Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0C64B784E
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 21:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242195AbiBORIX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 12:08:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239455AbiBORIV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 12:08:21 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EAFE11ACC1
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 09:08:10 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id c10so10314943pfv.8
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 09:08:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TRcNDUgXoT6OZOBt2+++3rmCdi8tsP1V+jytusJgHpc=;
        b=dItuKln7xrgOVHkAQ9pjdGpQViJKChs+LxfNttrgJ0Cr7S2Qmt+lYAW8GRGaPy6/P5
         IB0o7rRimgAtQJ6piWnoiTIvPalw2BpyCcW4W4CHZKSU9VoeDbDYXDTLRcCa2JcAasY/
         aEl6Yy9zYJ0dG3Ub4G1lWT8iM9S4xff0T/QO191ZffmbQYPR3EP6JZ3AaPApvNfEZpBo
         1C8yihxT0e3xX8KRlOrF1it+DQYR+sJRhK+66IVvI0x6LWcTruuNFupZFEVihwMjSJc0
         VEfKrnSvv0CRb/xNO5g+DggdjuzTvbptWmYTWyET8Os5PSKVmt0mjeSHlx6q0qgYb1ON
         ptMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TRcNDUgXoT6OZOBt2+++3rmCdi8tsP1V+jytusJgHpc=;
        b=uCK1C9xdYaS7BnJoX8bQdNlcD8zZbA0p4hKbWQMAdXv+oPwYdGhNDGVuI4Z+IyCTxF
         yz5f2cqoGKGri/Jzfhw1oVfidMDmc9eIscah31WJQqFfmL/hvfFVFsOonE/uiFoDL3MY
         WO/Q9BkgmUUwnNcIMCPxARKPb4x1cCUeu7WbgPbRNxN7NvqnprRwUj+x0+N3/KnyyaET
         oi4b9AUzFZ8DigJ4N2qgzQBNPrfKm7ggGv89q2TN6pvIEPA12dZKxTUftt7Jx3vTgugD
         702BY8ebmQryxkiPyOIqk4E1LLufobxq9WXPs5OuqRuPE1pESes8rCf7XoFgc4mmxOqy
         duug==
X-Gm-Message-State: AOAM533b6mUfDsKv4iw+coqfc1K1EPYfln/khdl8u3KXwywCjgngAMs4
        3J2iSeg+lRzQU0qWSGI6TBdiNKeFBVQXkQ==
X-Google-Smtp-Source: ABdhPJzrsZn3NwtaFf5BiKmBjOYmsYtgU/fWcbt/Anm0hsxLEPBoVreh5F9X5rtngmqMyMdHCgZsJQ==
X-Received: by 2002:a05:6a00:16d3:: with SMTP id l19mr5227528pfc.7.1644944889854;
        Tue, 15 Feb 2022 09:08:09 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k26sm3050425pgl.46.2022.02.15.09.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 09:08:09 -0800 (PST)
Date:   Tue, 15 Feb 2022 17:08:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/5] KVM: x86: remove KVM_X86_OP_NULL and mark
 optional kvm_x86_ops
Message-ID: <Ygvd9Q+R+tt6WfC2@google.com>
References: <20220214131614.3050333-1-pbonzini@redhat.com>
 <20220214131614.3050333-3-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214131614.3050333-3-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022, Paolo Bonzini wrote:
> The original use of KVM_X86_OP_NULL, which was to mark calls
> that do not follow a specific naming convention, is not in use
> anymore.  Instead, let's mark calls that are optional because
> they are always invoked within conditionals or with static_call_cond.
> Those that are _not_, i.e. those that are defined with KVM_X86_OP,
> must be defined by both vendor modules or some kind of NULL pointer
> dereference is bound to happen at runtime.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h | 84 +++++++++++++++---------------
>  arch/x86/include/asm/kvm_host.h    |  4 +-
>  arch/x86/kvm/x86.c                 |  2 +-
>  3 files changed, 44 insertions(+), 46 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 9e37dc3d8863..9415d9af204c 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -1,25 +1,23 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
> -#if !defined(KVM_X86_OP) || !defined(KVM_X86_OP_NULL)
> +#if !defined(KVM_X86_OP) || !defined(KVM_X86_OP_OPTIONAL)
>  BUILD_BUG_ON(1)
>  #endif
>  
>  /*
> - * KVM_X86_OP() and KVM_X86_OP_NULL() are used to help generate
> + * KVM_X86_OP() and KVM_X86_OP_OPTIONAL() are used to help generate
>   * "static_call()"s. They are also intended for use when defining
> - * the vmx/svm kvm_x86_ops. KVM_X86_OP() can be used for those
> - * functions that follow the [svm|vmx]_func_name convention.
> - * KVM_X86_OP_NULL() can leave a NULL definition for the
> - * case where there is no definition or a function name that
> - * doesn't match the typical naming convention is supplied.
> + * the vmx/svm kvm_x86_ops.

But assuming your veto of actually using kvm-x86-ops to fill vendor ops isn't
overriden, they're _not_ "intended for use when defining the vmx/svm kvm_x86_ops."

> KVM_X86_OP_OPTIONAL() can be used for those
> + * functions that can have a NULL definition, for example if
> + * "static_call_cond()" will be used at the call sites.
>   */

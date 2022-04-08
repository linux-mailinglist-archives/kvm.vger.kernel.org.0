Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D949F4F8C94
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 05:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbiDHC6C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 22:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiDHC55 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 22:57:57 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D8233221F6
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 19:55:55 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id o5-20020a17090ad20500b001ca8a1dc47aso10716790pju.1
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 19:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LW5/xk09U35y47kU1iT/IUull86sczJ/HfaSdnlo37k=;
        b=RyYsDEgszfeN0rvSoEnttHXduQn54BRTMC1/1VGHwKuIGsFOVZ5u4P6Ylu8l/yGNzE
         yhXE7NzJ8MIyckX+PWwWxooQ0I3pxbeUcNAVltOC0unkA3KSuGxclYr/DVd212HZjdoK
         X8pjgIU3i8brFM0vAYF/gHjc1+8Vynj3oDOJq2HIPqY+Qcd2Ea8lCCuWlff3ia62GmAr
         ob6cE4TwVaHZgKeUBFyFUXKzF9u9+ae+8wk5VGwogWEfV1AjwfPohzf+Cvs/Uqq045WQ
         Xdfa0N+mfW3mBbs9wjchwgFT97ifkLLXxJu6RijjMlPrzxBBFnqFFs4UUvjyXpyYX+sK
         iOAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LW5/xk09U35y47kU1iT/IUull86sczJ/HfaSdnlo37k=;
        b=lpxzcnfI6JeCpMxkjz00Xf0lCfOMduVGXKQCR3gyGPGj2xjdOO06aTdUBQsXgWhXuq
         jFFdYfnMAEV/A1xWrzqXJ6154/NeEKQgljd5x+r7VezqFfU43AE/W9oJVnhsEEBqLFBk
         zreJmqzcZgsh6wTf60ehtsnqe2HIjmsQPYOd8vV8lIjBxIIqXCLLduZ5OSHQozvrbwub
         Cpt1jvLOkZDo5Lygq30QQRxMKSkDpgYFnGVL8N5N2t3DfM36CfOGO5roOAFygqW+Q+X6
         92WnRGdR9Hv9rH0fuUXYqKBHXTsmGAL0gZiWglSjleTj0+yaB0OYD5iBIxtxYmOMEz6a
         NPuA==
X-Gm-Message-State: AOAM532jlFEzabsopqAaEWgde4jSFqtiNCoEG3wSgp/gCMVnRGjRR3PZ
        F1H0Ptxor1UjkF9EyiCMerLsjgkk1HiuCA==
X-Google-Smtp-Source: ABdhPJzxKC633+kFwbLBoyi38pZ1xVFYWH2THwr+JinyzBLP1qhN2r9TVZl9gVU6BP03rg084W2rQA==
X-Received: by 2002:a17:902:dace:b0:156:cdab:2c56 with SMTP id q14-20020a170902dace00b00156cdab2c56mr16729364plx.80.1649386554542;
        Thu, 07 Apr 2022 19:55:54 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id nm11-20020a17090b19cb00b001cb0d587a7esm3750225pjb.46.2022.04.07.19.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 19:55:53 -0700 (PDT)
Date:   Fri, 8 Apr 2022 02:55:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4.1] KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
Message-ID: <Yk+kNqJjzoJ9TWVH@google.com>
References: <20220407210233.782250-1-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407210233.782250-1-pgonda@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 07, 2022, Peter Gonda wrote:
> If an SEV-ES guest requests termination, exit to userspace with
> KVM_EXIT_SYSTEM_EVENT and a dedicated SEV_TERM type instead of -EINVAL
> so that userspace can take appropriate action.
> 
> See AMD's GHCB spec section '4.1.13 Termination Request' for more details.

Maybe it'll be obvious by the lack of compilation errors, but the changelog should
call out the flags => ndata+data shenanigans, otherwise this looks like ABI breakage.

> Suggested-by: Sean Christopherson <seanjc@google.com>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Peter Gonda <pgonda@google.com>
> 
> ---
> V4
>  * Updated to Sean and Paolo's suggestion of reworking the
>    kvm_run.system_event struct to ndata and data fields to fix the
>    padding.
>  * 4.1 Updated commit description
> 
> V3
>  * Add Documentation/ update.
>  * Updated other KVM_EXIT_SHUTDOWN exits to clear ndata and set reason
>    to KVM_SHUTDOWN_REQ.
> 
> V2
>  * Add KVM_CAP_EXIT_SHUTDOWN_REASON check for KVM_CHECK_EXTENSION.
> 
> Tested by making an SEV-ES guest call sev_es_terminate() with hardcoded
> reason code set and reason code and then observing the codes from the
> userspace VMM in the kvm_run.shutdown.data fields.
> 
> ---
>  arch/x86/kvm/svm/sev.c   | 9 +++++++--
>  include/uapi/linux/kvm.h | 5 ++++-
>  2 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 75fa6dd268f0..1a080f3f09d8 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2735,8 +2735,13 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>  		pr_info("SEV-ES guest requested termination: %#llx:%#llx\n",
>  			reason_set, reason_code);
>  
> -		ret = -EINVAL;
> -		break;
> +		vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> +		vcpu->run->system_event.type = KVM_SYSTEM_EVENT_SEV_TERM |
> +					       KVM_SYSTEM_EVENT_NDATA_VALID;
> +		vcpu->run->system_event.ndata = 1;
> +		vcpu->run->system_event.data[1] = control->ghcb_gpa;
> +
> +		return 0;

Kinda silly, but

		ret = 0;
		break;

would be better so that this flows through the tracepoint.  I wouldn't care much
if it didn't result in an unpaired "entry" tracepoint (and I still don't care that
much...).

>  	}
>  	default:
>  		/* Error, keep GHCB MSR value as-is */
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 8616af85dc5d..dd1d8167e71f 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -444,8 +444,11 @@ struct kvm_run {
>  #define KVM_SYSTEM_EVENT_SHUTDOWN       1
>  #define KVM_SYSTEM_EVENT_RESET          2
>  #define KVM_SYSTEM_EVENT_CRASH          3
> +#define KVM_SYSTEM_EVENT_SEV_TERM       4
> +#define KVM_SYSTEM_EVENT_NDATA_VALID    (1u << 31)
>  			__u32 type;
> -			__u64 flags;
> +			__u32 ndata;
> +			__u64 data[16];
>  		} system_event;
>  		/* KVM_EXIT_S390_STSI */
>  		struct {
> -- 
> 2.35.1.1178.g4f1659d476-goog
> 

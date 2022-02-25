Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10FB64C3B02
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 02:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbiBYBdW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 20:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiBYBdW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 20:33:22 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89041186229
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 17:32:49 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id q11so3439773pln.11
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 17:32:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yawEE7Ursf188KqxzBs5Nc6FxIhaTDHce2sVMCnsWCk=;
        b=lIEM+gYEyBMiMgWt0faSJHYeeuybr9wlsTwICYiQ+5px4hR3D26Az9X0GJ07NlS5Ka
         76zam2YQfTLvJX7kGIcLqgfRdrQuQG2fEq05c+dxq3DExFAUUzFcWNGgRnUKWlZ2S35T
         Js+R8rDquNoceCh7GIM/uY0my/X5IZO1bfsTLOZ7AAlCGvb07al08wZag/DP0XoImpTV
         yEgqsfrvqtynenbycUPwQnvnHj2rYx/N90MV1AXgCzc/Dwthqs+VQ7sLn+K4/4+RM4G3
         M/WvKPe9BLeK/485c3F8pTNU41PSmtutm+PuCFXPr+BvJUzVU5WF1CtHZdwQgDrd1VGC
         xrYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yawEE7Ursf188KqxzBs5Nc6FxIhaTDHce2sVMCnsWCk=;
        b=eBk8KW2xLzHNC7zKmC0b/4IHR4jKDr8eBzIMQ+0U/MZX7GsS1OKBzJlwee+FaMd1es
         zXpD4+6OoHgxmqXFT1CI3vbyRmYPDNPRcjwOUnC3UrSDj5eFLM3wG3npCsthtTEg3U4i
         BlftdH+NsOM/CgljXo2h1eJe1vD1W2/LwoPT26v0WrYYZ39hZ5cDXr5Y3tCWpz8Oo3Fj
         +OSUxMwvyzFOVPD/CdZixZMnbS+V6W4Fs4tcPXVbyNCqbdueau1TGDJcJzEOoGQAdASX
         TajJGDjdX1zv7j1APQ2IePeydNOTBHIjH8Wp2dJbUUK38srQRxc2sB5b9lN4lkBdSl9a
         xwhQ==
X-Gm-Message-State: AOAM530jK65Ky43+nySC6KdwOgM1IsNUQKGFIjuW28JnpGC4GuDX7hnK
        mFzzlGkcQ+hbdwYaV8BEFmtcDA==
X-Google-Smtp-Source: ABdhPJzVPHLJZiGcRORD5R8nHlcv1rz++AsjBy5x+JSXTmAFyG0GASWhgqsZbhdAMxNZ6rgZfSFoOg==
X-Received: by 2002:a17:90b:e08:b0:1bc:2b0c:65aa with SMTP id ge8-20020a17090b0e0800b001bc2b0c65aamr822579pjb.102.1645752768946;
        Thu, 24 Feb 2022 17:32:48 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id on18-20020a17090b1d1200b001b9cfbfbf00sm500010pjb.40.2022.02.24.17.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 17:32:48 -0800 (PST)
Date:   Fri, 25 Feb 2022 01:32:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH] KVM: VMX: Fix header file dependency of asm/vmx.h
Message-ID: <YhgxvA4KBEZc/4VG@google.com>
References: <20220225012959.1554168-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225012959.1554168-1-jmattson@google.com>
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

On Thu, Feb 24, 2022, Jim Mattson wrote:
> From: Jacob Xu <jacobhxu@google.com>
> 
> Include a definition of WARN_ON_ONCE() before using it.
> 
> Fixes: bb1fcc70d98f ("KVM: nVMX: Allow L1 to use 5-level page walks for nested EPT")
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Jacob Xu <jacobhxu@google.com>
> [reworded commit message; changed <asm/bug.h> to <linux/bug.h>]
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/include/asm/vmx.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 0ffaa3156a4e..447b97296400 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -14,6 +14,7 @@
>  
>  #include <linux/bitops.h>
>  #include <linux/types.h>
> +#include <linux/bug.h>

Paolo, any chance you want to put these in alphabetical order when applying? :-)

Reviewed-by: Sean Christopherson <seanjc@google.com>

>  #include <uapi/asm/vmx.h>
>  #include <asm/vmxfeatures.h>
>  
> -- 
> 2.35.1.574.g5d30c73bfb-goog
> 

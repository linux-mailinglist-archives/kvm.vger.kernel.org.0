Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BED604BBD50
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 17:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237690AbiBRQSD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 11:18:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237677AbiBRQR6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 11:17:58 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13E82A4A22
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 08:17:35 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id z16so2685082pfh.3
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 08:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FRSZd3fBk7csQd6ekFYVUPxE635CUFF9aE3/2GpUFwY=;
        b=Nj6hmVanszUmzi9KjB+xJ4F/ntkI5tTY/48glTq88ZFVzRRwA+YJBnklzlNn7V/mf8
         BbZB1fKWW4YcAZ2NQQohD/DXqbwgvqIy9AWZmcS6GGxDgJNwcupy5GpbHV13in668gkR
         mzF+6ou++t9PcdNil+CM7qTsnDFssX4Y7uU2fRGRiOAIYlj1TZrYGyU1hL/5OQcWTVMd
         fX7bp29qB4QsKLv7SH7Q/hRwuy27WPVF0VzGPNWRkBQBGZ866qX3p+Ey2oJ1zpJ8MxA3
         ehnGTyFvgcq/VUtxUUrz8qCI7Wc8eZmxXTAN4FimrFxsiJG/a0vOFeKAKEApAjQcKWQi
         jgNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FRSZd3fBk7csQd6ekFYVUPxE635CUFF9aE3/2GpUFwY=;
        b=A5AXE4D5FpCaQBh/gIw6Het0KuP1gqwIN2ZOX9X4mCztQMxaNrXS/Jy15E8lqKwwwE
         nAEn+PLTTRwLemHCjcYQVwVIqjwPBxnAjUjzUVPtZ0GRgoa0B87dn7umHI4CyeMAcwCC
         vhT2bS6A+bHcf6g1DSndsY0RnwoIdc/h44gY2th6Jp1QUs5CQI+rjTwe39P+joHK17TB
         WKVNpr1vsHj2Ls+sYnjlQoicerKXga/WPTOsQd1CN5QVUvUg1rSdsiJpAYRSOzZ3gRud
         LgXSNPHqV36QaIhtH2o7o96sfj21+WgfpAiYdyH9hWXrRVCocA5vbJEe3XMP4unPXlCb
         cDZw==
X-Gm-Message-State: AOAM532H8ijE4GpfR0UGC6EVFk9wjYo7isjWQiNBSbXCYIX90JTgSFV5
        Xg9U05OgLCjKMtVeeDBaIQBefg==
X-Google-Smtp-Source: ABdhPJxpbuKhDBeeP4BqX4FrhvC6lUgdxX0u4ICIDjV5mLveme+6a+IXNA092AMbXmo/1ibMLKxc3A==
X-Received: by 2002:a05:6a00:124f:b0:4c0:6242:c14e with SMTP id u15-20020a056a00124f00b004c06242c14emr8463713pfi.83.1645201054938;
        Fri, 18 Feb 2022 08:17:34 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id hk3sm5818815pjb.12.2022.02.18.08.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 08:17:34 -0800 (PST)
Date:   Fri, 18 Feb 2022 16:17:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peng Hao <flyingpenghao@gmail.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]  kvm/vmx: Make setup/unsetup under the same conditions
Message-ID: <Yg/GmgbmLKTRqUbo@google.com>
References: <20220218111113.11861-1-flyingpeng@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218111113.11861-1-flyingpeng@tencent.com>
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

"KVM: VMX" for the scope, or maybe even "KVM: nVMX:" despite this not touching
vmx/nested.c.  Either way (but not "kvm/vmx:").

On Fri, Feb 18, 2022, Peng Hao wrote:
> Make sure nested_vmx_hardware_setup/unsetup are called in pairs under
> the same conditions.

Probably worth adding a sentence to clarify that the existing code isn't buggy
only because free_page() plays nice with getting passed '0' and vmx_bitmap is
initialized to zero.  Something like:

  Make sure nested_vmx_hardware_setup/unsetup() are called in pairs under
  the same conditions.  Calling nested_vmx_hardware_unsetup() when nested
  is false "works" right now because it only calls free_page() on zero-
  initialized pointers, but it's possible that more code will be added to
  nested_vmx_hardware_unsetup() in the future.

Reviewed-by: Sean Christopherson <seanjc@google.com>


> 
> Signed-off-by: Peng Hao <flyingpeng@tencent.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 0ffcfe54eea5..5392def71093 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7852,7 +7852,7 @@ static __init int hardware_setup(void)
>  	vmx_set_cpu_caps();
>  
>  	r = alloc_kvm_area();
> -	if (r)
> +	if (r && nested)
>  		nested_vmx_hardware_unsetup();
>  
>  	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
> -- 
> 2.27.0
> 

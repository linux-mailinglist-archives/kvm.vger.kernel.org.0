Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564BA4CC2A0
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 17:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234959AbiCCQ0q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 11:26:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234950AbiCCQ0p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 11:26:45 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5328199E2F
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 08:25:59 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id a5so5090051pfv.9
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 08:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UWcMhJUNvd7aXk2jmgHcMiSOEWKmbkoQpHudCcHb9wE=;
        b=SHTI0HtbMA263QpJAzjR9NbZeGYNec3dPd3vioV+PcPLacdVGcgd14GY5KOg00ZH9d
         gh5aRsBGihcJmKFBFNss4m9+I0N5SqZthTCpx46sWNRllZQbuM5kDptqRQJKT3OfZdie
         LjTaZSarWxfY5muxqMz153VTD1T+jfdg73OKLYTNS+vroY5jJo4kZ3KScEC2qew5Fnsh
         t2BkE/WgyD26fDZutrjQbS3uw/JI43eYs2cTm3+qUchd32OO2bLLseWv83L/ZL10Sqry
         TavzpNgXEWQwFz7z7hYRdTwhK7Dq33mLbJGXYu5aYHHOj96yvQiMhG8X9/YiI6/maMyO
         8FTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UWcMhJUNvd7aXk2jmgHcMiSOEWKmbkoQpHudCcHb9wE=;
        b=5oJpjSxVpkpZkhwa9PmamXwOdoncul1vIu3fU9azyv6Nox3MxlLj/+0uNj3bpediHW
         tvtu40Twm3skXvfnWpdbRGS39oV/h9NjH3s4BfXanruAb62LtdO0EgYOnu2WCmrdkHWj
         bPxVxSOvoEIkrDeADmePutaddTm1/kU2KfQuBYesDhf/hLVClYjiKfuWbqEllo0CVrjT
         y2DEFPno9V3kySLgfeNDWwxDuCUmKqmKqmoOWQHSLOsJvnkSqvx0qwDdaBOi01LTihnw
         mNCDCRNjVpijIbqf8RId5grzbqbwS0ijg9WVqTFTtgZ38WPnPFTgkXsj4WqwmtTfnqpF
         jeug==
X-Gm-Message-State: AOAM531OUXxyLa6qXybeA5hFy5aSknyV2rXfrqDd4/2V4Iucy32MdeLN
        YKOlsUw7nAXZBr3G+wf7KJrvNA==
X-Google-Smtp-Source: ABdhPJxmaVclrnJYHWduPcYrmKTcHPthck5iwf2QkmD0vZx1CT4Ia/ks4aL6LsXCsGoW6EwG9t+WEg==
X-Received: by 2002:a62:d141:0:b0:4f3:c07b:7bf5 with SMTP id t1-20020a62d141000000b004f3c07b7bf5mr28542069pfl.41.1646324758951;
        Thu, 03 Mar 2022 08:25:58 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g28-20020a63111c000000b00374646abc42sm2373426pgl.36.2022.03.03.08.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 08:25:57 -0800 (PST)
Date:   Thu, 3 Mar 2022 16:25:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: Fix missing kvm_cache_regs.h include in svm.h
Message-ID: <YiDsEgxUDZL+XY9R@google.com>
References: <20220303160442.1815411-1-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303160442.1815411-1-pgonda@google.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 03, 2022, Peter Gonda wrote:
> Adds include for is_guest_mode() in svm.h.

Write changelogs as "commands", not descriptions.  And a little extra verbosity
wouldn't hurt, e.g.

  Include kvm_cache_regs.h to pick up the definition of is_guest_mode(),
  which is referenced by nested_svm_virtualize_tpr().

Though you'll probably need a different changelog (see below).

> Just compile tested.

This belongs in the ignored part, not the changelog proper.

> Fixes: 883b0a91f41ab ("KVM: SVM: Move Nested SVM Implementation to nested.c")
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/x86/kvm/svm/svm.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index e45b5645d5e0..396d60e36b82 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -22,6 +22,8 @@
>  #include <asm/svm.h>
>  #include <asm/sev-common.h>
>  
> +#include "kvm_cache_regs.h"

Ha, we've already got a lovely workaround for exactly this problem.  This patch
should drop the include from svm_onhyperv.c, there's nothing in that file that
needs kvm_cache_regs.h (I verified by deleting use of is_guest_mode()), it's
included purely because of this bug in svm.h.

diff --git a/arch/x86/kvm/svm/svm_onhyperv.c b/arch/x86/kvm/svm/svm_onhyperv.c
index 98aa981c04ec..8cdc62c74a96 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.c
+++ b/arch/x86/kvm/svm/svm_onhyperv.c
@@ -4,7 +4,6 @@
  */

 #include <linux/kvm_host.h>
-#include "kvm_cache_regs.h"

 #include <asm/mshyperv.h>



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C52622EB2
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 16:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbiKIPGi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 10:06:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbiKIPGh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 10:06:37 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C3C51AD82
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 07:06:36 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d20so16276854plr.10
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 07:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wHPhbbvw5zFQKI19I4sRlCQw5xxCQ/IYVwUpkVORIms=;
        b=R/SWCxd+3hQJIoJnDxrsqdA56lLB5g+FgnJMOYd8l4iyIq96g+qxIwYGU0X8opCQfd
         qTl67qlRX1cM4loGOVfON0qjK65rCHwemp7HPP7+J3JSi9QhlC23IwXQQXU33QhIAQsu
         7SBqJGvSM4zIjGUjq/KemmRWQ9r8ojzN2AN3UG6ulpQ9oZPgWEsqjmvOogAN+WkgljqQ
         eA/75xbxirqNB0iWC7CkaU+25AloDkSx+G24wbQbVj2ycJ3Ea9ljz1bIFzj15pboP0fn
         So2czgfaa9+daUHBRcqu1U04LAR2sIG6io3ydzlVeHN1n/uBOtNyNcPSVCBzCPdjNtgY
         5HAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wHPhbbvw5zFQKI19I4sRlCQw5xxCQ/IYVwUpkVORIms=;
        b=hfEQPgvBl/c/bKMutk+B2KibaKIgs+RgBg7h6+a2dPyGiYrIx+zLB+cmmMVbMAozn3
         OEv3V4M3cdny1V/sCYUTabKG9YoxWuLS/ipZgyHMkRmt2rwPDLpj+Tx6cMBh5f1EJtb5
         XJ9yWRBayTD6UXxL++U+G22t1wFFFxinum82LVXEiqh/ejcpHub2GM72WrSsvLH8Fc7m
         wjZSE10dYjj3AhWK9Ty4iibqUHsD9rc8qfaZlEQ4JIHCX162Rub/jtCV89LzWzDFq/0J
         m6GEueX249a21R9V1ZGfgk0EaJKF5b6Nx1wrL6UGKxYeb2wNdfXFyR0mgOhPGnXF8TTH
         FXEA==
X-Gm-Message-State: ACrzQf3aG5QDbeQkmm6gOpZVcSOaSO9s7EaMUiWbiJU7kQJPquV6f+cO
        1MhIlVlLTGTFTh6Vlpp8Q7oqSw==
X-Google-Smtp-Source: AMsMyM6Z5xLVh5jZzjJlzADewH2T5jsFGuZx0MlXhl+qVr1AAl9XYi1PgOdRS78kxn+PpGeJKUGNKg==
X-Received: by 2002:a17:90b:1d8a:b0:213:cdfa:8aa2 with SMTP id pf10-20020a17090b1d8a00b00213cdfa8aa2mr55457865pjb.204.1668006395438;
        Wed, 09 Nov 2022 07:06:35 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j12-20020a170902da8c00b0017f5ad327casm9224672plx.103.2022.11.09.07.06.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 07:06:35 -0800 (PST)
Date:   Wed, 9 Nov 2022 15:06:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        thomas.lendacky@amd.com, jmattson@google.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 01/11] KVM: x86: use a separate asm-offsets.c file
Message-ID: <Y2vB96tzh8GqfmFF@google.com>
References: <20221109145156.84714-1-pbonzini@redhat.com>
 <20221109145156.84714-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109145156.84714-2-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 09, 2022, Paolo Bonzini wrote:
> This already removes the ugly #includes from asm-offsets.c, but especially
> it avoids a future error when asm-offsets will try to include svm/svm.h.
> 
> This would not work for kernel/asm-offsets.c, because svm/svm.h
> includes kvm_cache_regs.h which is not in the include path when
> compiling asm-offsets.c.  The problem is not there if the .c file is
> in arch/x86/kvm.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Cc: stable@vger.kernel.org
> Fixes: a149180fbcf3 ("x86: Add magic AMD return-thunk")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index 8477d8bdd69c..0b5db4de4d09 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -1,12 +1,12 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  #include <linux/linkage.h>
>  #include <asm/asm.h>
> -#include <asm/asm-offsets.h>
>  #include <asm/bitsperlong.h>
>  #include <asm/kvm_vcpu_regs.h>
>  #include <asm/nospec-branch.h>
>  #include <asm/percpu.h>
>  #include <asm/segment.h>
> +#include "kvm-asm-offsets.h"

Do you have a preference on KVM files using dashes or underscores?  Outside of
kvm-x86-ops.h and kvm-x86-pmu-ops.h, KVM x86 uses underscores.  I actually prefer
dashes because they're slightly easier to type, but when there are only a few
outliers I constantly mistype the names.  If dashes are generally, maybe we could
gradually/opportunistically move in that direction?

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13782C8E93
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 21:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388264AbgK3T7h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 14:59:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgK3T7g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 14:59:36 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E87C0613D3
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 11:58:56 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id w202so11108742pff.10
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 11:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=JOx+dix68GBdJvNP9ttj7+w4PMBc+DbmStt47v8N/pU=;
        b=JEoJRJ0PFt+1b2KEhLB1LQyQPDz/V3W2jRZ3177OpgpM5FIpAN27dyhYoWapjm/59j
         ob5KZwS25okZKtemKiGyG/xqDjWV4HXxVWyW3TDhIWrkY6VFoL0NaooEfHMMRz4nVP5C
         4jOiVYySfvok5DLnH5t2Zel9q217GqJJm3KpFWxWWJCmDWjSxNqJsM6nqFEV7LUz/r23
         4eaPjW8uahr0k8L67IQyroWML33QHYL6KV64llTCuLKONAtUj9lUpkIG4MtI0GE2hqKg
         UcPF7xodct6kdODMUPTq51qUsYdEZbLRIuaCsPUTArqD4zXhyNwshzqSXSlxygoAiuwI
         L8cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=JOx+dix68GBdJvNP9ttj7+w4PMBc+DbmStt47v8N/pU=;
        b=a1ImZBPJHWLEQD0HujWjnlXjAWmnCvbPkU9OhgmbE8jdlHriDc7Mc1rpbqPN+mvz25
         PaGMzg9gBHOWet5ShDIq+D717LxNQxR5W730RHlfctiASwyibXlo1k00n420EAFhxNQ1
         kOOK/oNtkdPtyJEtF9rQ6nlQlEnSOwccR7q+l+2q2XICi4SIa3Xc261iuz6QjwqX9+tK
         Ckn4TGQ010BfXtvg2/OgQ+JxSqzmYHqjc5Gpe5sfuDOe/eeZleBUs+3+Z7CiiE43l6cP
         xUtXdkdutRT5pRDErdfORlixacooplzLSiuSKW/EjH52vjIVr7kB8FL/PxCVLQHVDLsq
         PyEQ==
X-Gm-Message-State: AOAM5324HI9PTKWpmJ+lPo11UG84gqpz4WW81DALQSU0Q4eCvcviuekM
        oaRu/npVygD4yUM+VqVjsm23Mw==
X-Google-Smtp-Source: ABdhPJz6uqyOABPokPOn4StdYCj4ng5yodK9AjOFKgjG065uT5nJpm0FyVgR5ITaW6ZmDkma3pM6kA==
X-Received: by 2002:a62:1443:0:b029:197:e734:a289 with SMTP id 64-20020a6214430000b0290197e734a289mr20421412pfu.66.1606766336221;
        Mon, 30 Nov 2020 11:58:56 -0800 (PST)
Received: from google.com (242.67.247.35.bc.googleusercontent.com. [35.247.67.242])
        by smtp.gmail.com with ESMTPSA id w18sm17896847pfi.216.2020.11.30.11.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 11:58:55 -0800 (PST)
Date:   Mon, 30 Nov 2020 19:58:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     =?utf-8?B?5b2t5rWpKFJpY2hhcmQp?= <richard.peng@oppo.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Suravee.Suthikulpanit@amd.com" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] kvm:svm: Return the correct error code
Message-ID: <X8VO+4/r+LltG7AF@google.com>
References: <HKAPR02MB42915D77D43D4ED125BD2121E0F90@HKAPR02MB4291.apcprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <HKAPR02MB42915D77D43D4ED125BD2121E0F90@HKAPR02MB4291.apcprd02.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 26, 2020, 彭浩(Richard) wrote:
> The return value of sev_asid_new is assigned to the variable asid, which
> should be returned directly if the asid is an error code.
> 
> Fixes: 1654efcbc431 ("KVM: SVM: Add KVM_SEV_INIT command")
> Signed-off-by: Peng Hao <richard.peng@oppo.com>

It's probably worth noting in the changelog that this is a nop.  sev_asid_new()
can only fail with -EBUSY, and ret is guaranteed to be -EBUSY as well.  I agree
it's probably better to return the result of sev_asid_new() instead of assuuming
it will always return -EBUSY.

> ---
>  arch/x86/kvm/svm/sev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 566f4d18185b..41cea6b69860 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -174,7 +174,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
> 
>         asid = sev_asid_new();
>         if (asid < 0)
> -               return ret;
> +               return asid;
> 
>         ret = sev_platform_init(&argp->error);
>         if (ret)
> --
> 2.18.4

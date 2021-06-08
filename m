Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8B439EAAA
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 02:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhFHA0m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 20:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbhFHA0m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 20:26:42 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F04C061574
        for <kvm@vger.kernel.org>; Mon,  7 Jun 2021 17:24:35 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id x73so14364448pfc.8
        for <kvm@vger.kernel.org>; Mon, 07 Jun 2021 17:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TolwmxxCwECy0smx+kbv10pYUmgnzqDOVNxYM1QT1F0=;
        b=A/n/bnZtrmuheCMwGi0R73jFYpb0hfmrajekvBgNje1VVmeFNbTlzMhtRlaQ3GXDOa
         CcBxQIfze8Y/iwVoaCIdLAGySPhv9d5RD8uBASy7bFdf9zZv6RaL/DgKNWLabq/zqDQT
         V+RBHuKz2wVPQQEzTVkk6R4iI7rHgDGppiGpvqys5h5jniTuFykkT3X8fPk1HrR5QsLC
         qF0DQbJi38Dpk++g9Zb3ilDaDXF6qCXJqo98Hyce4NETdM4mjZZ5Ig5Crd2GFQLgR7CO
         LuwXSC26QT0IwlWF+6l9w+f350ggAoulEPkztYbV8GX/0b3zHJAoOArdXSK7ljfWflLX
         gcKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TolwmxxCwECy0smx+kbv10pYUmgnzqDOVNxYM1QT1F0=;
        b=bhJpkef0krAGe29y30mm0i1s7U7FdRnkc2vxtV8jr/E3DS2psaRFL6U/ymkyb0vC0L
         lYlOGBrE7bHo9Mxox9aolhXQ6fYmgl4bq8y+s0CTz4jQitTOugWFbsXLewuGG75VYOjK
         v7UZ6P+AUPY8yU4CLkPvVWhXggHBxO3mYtQ+Ir6vBKc+J/owrh8lcwKoo3O3JdBDRzs9
         GEIdo1sH4d//QmsXiPZjbiTZf/urPrMaVdVVqG9fnXkOP4eztp28BtUI52c5LQFp2F75
         /KNvHinOjNm1QvvcDm3h7W4D3HtkMpMh7sJ3Ei60+M8eRx5lAsqmhEvY6kx6SRBN5Vfe
         BvOw==
X-Gm-Message-State: AOAM5339NKJcaKgKJ0xtyRMr8zhh/I50tCoT1sP10apxyUE9j5UxoOpR
        E53RJgU67MqkaOitFO46l9WOZQ==
X-Google-Smtp-Source: ABdhPJxy1YkNVNbvvp6EY6KPyEDFSSwdlBsdAEG1LLiPdkRjPiUYe018f8t+SdsXVohBgRb65v82uA==
X-Received: by 2002:a63:aa48:: with SMTP id x8mr20008889pgo.359.1623111875257;
        Mon, 07 Jun 2021 17:24:35 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id p24sm7228678pfh.17.2021.06.07.17.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 17:24:34 -0700 (PDT)
Date:   Tue, 8 Jun 2021 00:24:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Subject: Re: [kvm-unit-tests PATCH V3] x86: Add a test to check effective
 permissions
Message-ID: <YL64voHPNZofL/s+@google.com>
References: <6c87d221-8b6c-56a7-e8d1-31ad8a8379e3@linux.alibaba.com>
 <20210605174901.157556-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210605174901.157556-1-jiangshanlai@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 06, 2021, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> Add a test to verify that KVM correctly handles the case where two or
> more non-leaf page table entries point at the same table gfn, but with
> different parent access permissions.
> 
> For example, here is a shared pagetable:
>    pgd[]   pud[]        pmd[]            virtual address pointers
>                      /->pmd1(u--)->pte1(uw-)->page1 <- ptr1 (u--)
>         /->pud1(uw-)--->pmd2(uw-)->pte2(uw-)->page2 <- ptr2 (uw-)
>    pgd-|           (shared pmd[] as above)
>         \->pud2(u--)--->pmd1(u--)->pte1(uw-)->page1 <- ptr3 (u--)
>                      \->pmd2(uw-)->pte2(uw-)->page2 <- ptr4 (u--)
>   pud1 and pud2 point to the same pmd table
> 
> The test is useful when TDP is not enabled.
> 
> Co-Developed-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---

Awesome, thanks!

Reviewed-by: Sean Christopherson <seanjc@google.com>

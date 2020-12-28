Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB612E6C9F
	for <lists+kvm@lfdr.de>; Tue, 29 Dec 2020 00:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgL1Xzg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Dec 2020 18:55:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbgL1Xzg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Dec 2020 18:55:36 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BB0C0613D6
        for <kvm@vger.kernel.org>; Mon, 28 Dec 2020 15:54:50 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id i5so8249821pgo.1
        for <kvm@vger.kernel.org>; Mon, 28 Dec 2020 15:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kDv04UcJXsRXAAb0BfpkpsXloYCUI9DJy9xrXGs5QQM=;
        b=rgFY1m+/I9TgOjygQc4ha2TMqD/pP3XpA3G7ozM621zTgnuLzPcCiYZ/9OMACx1lyW
         UveinnYhBpRFTA/9pAQ7d40htGoeRfR0DvekxWlkgGnwd/Vh/OM2PpN1205f2ImGQMEI
         02SUMQwXTxyUi2rcBY/UpvZ6Xjvl2qsmfcEcrjTYI7hVGuhEL36lx7aAKWefN9wGB8gK
         hA6ZHLwwumoWiQbQ9lEIw3WFyRVcix2XwO5z0j32cdZS++6cP8e+o9LzjhsACFLYnUig
         G+HTKme4yTAzAGyjLlvahv9zqJjhX8ocEx9nr6TuFppLG2NDoT/bK2Sc0a+zUFcqoFxe
         5u1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kDv04UcJXsRXAAb0BfpkpsXloYCUI9DJy9xrXGs5QQM=;
        b=hPITirxji6k02YFqkeRroWCnKYMpQ2imf1mFmFw2zSwjpp68yzNzNDROYcylUYxz+m
         HYAm9jJ2Nplyz2IQ9xQOsA2L8IaEm4eCwXF6J9s9TDinEuepxgYOFjlMlH9NDbe033jg
         +REMKDy5QEhiAyWy8jy5YzjtT5XtQkVYnnoRtfXebLXNgbYh9oKLE/HE/UV1FEw2vcUr
         OAtABI9u9uAxlOr9PVqsvbQ57y19GIPa7/3W/Hg+hDyJBW+ILUVEJxTuA7Llpffg0E8K
         rh1KiJ4F3REctm3DjPrxTe15ypTonsd6CFGqkV8yqs/eERbFFJ1sU98uSFHIQ3GUC5XD
         LAwg==
X-Gm-Message-State: AOAM533u3FopFU0LKCKqCpanjW44EKnDJ5Y2y88d9K5Zg39byB6T9T3A
        dF8Sc3DirEghdjWivIQtdyNLP/uRMkhz8A==
X-Google-Smtp-Source: ABdhPJyyRAr3zrs08czIJ+HKYlNPj0xru7yWQ0bN5m9zJOEMLLWNvO9ObZi71MHus+HLcxOFzA+7qg==
X-Received: by 2002:aa7:8297:0:b029:1a9:9d0a:c407 with SMTP id s23-20020aa782970000b02901a99d0ac407mr42397687pfm.76.1609199689678;
        Mon, 28 Dec 2020 15:54:49 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id q23sm38439853pfg.18.2020.12.28.15.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 15:54:49 -0800 (PST)
Date:   Mon, 28 Dec 2020 15:54:42 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH v3] KVM/x86: Move definition of __ex to x86.h
Message-ID: <X+pwQrLgVcMg0x3M@google.com>
References: <20201221194800.46962-1-ubizjak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201221194800.46962-1-ubizjak@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 21, 2020, Uros Bizjak wrote:
> Merge __kvm_handle_fault_on_reboot with its sole user
> and move the definition of __ex to a common include to be
> shared between VMX and SVM.
> 
> v2: Rebase to the latest kvm/queue.
> 
> v3: Incorporate changes from review comments.

The v2, v3, ... vN patch history should go below the '---' so that it doesn't
need to be manually stripped when applying.

> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---

vN stuff down here

>  arch/x86/include/asm/kvm_host.h | 25 -------------------------
>  arch/x86/kvm/svm/sev.c          |  2 --
>  arch/x86/kvm/svm/svm.c          |  2 --
>  arch/x86/kvm/vmx/vmx.c          |  4 +---
>  arch/x86/kvm/vmx/vmx_ops.h      |  4 +---
>  arch/x86/kvm/x86.h              | 24 ++++++++++++++++++++++++
>  6 files changed, 26 insertions(+), 35 deletions(-)

Reviewed-by: Sean Christopherson <seanjc@google.com>

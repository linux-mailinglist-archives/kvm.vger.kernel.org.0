Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEFD48B91C
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 22:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236454AbiAKVCf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 16:02:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236303AbiAKVCe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 16:02:34 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABE9C06173F
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 13:02:34 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id ie23-20020a17090b401700b001b38a5318easo1070344pjb.2
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 13:02:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KP22ekfBfvtfdZJuVQAmoq8mG19AH/gb+o7LwKndtYs=;
        b=b/P8JT3dnswhxIdvQnrQuqhUXUeaJ1GZbigQbjs9sIgAsLD4ixy/s9Rim/uumbTLr/
         hmGE2gF+yj3wXwhJDjoJSf4WpKTRuKft/UrhmsJkf5Azn1VA4pEjq43xO1U3N+tkODSg
         eeTWU3giubfEZBDAtAknNHCKhI3uHiiSqFL8sWsVZHbLKYLv0X3rYSQzgk2vmJWN1bsG
         SLdXXggYx8s7P5c8ITinq5w6zb4DiX/DF10A+2g5TS7DFlo3S0ejJcTqPTjkZym09X2q
         J0fl5UOW9MgoArXIXRf7WEokjCoStGC5HvkEW/r6ZdroAIzUo8HrwmoXbHwhAOITQNh8
         6Mdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KP22ekfBfvtfdZJuVQAmoq8mG19AH/gb+o7LwKndtYs=;
        b=otwufoPWaP7L2KNcGM8P76VjLbxCR5dNnFXv8BVRZO/MedYQTQg3BJRlR4tB1pKkwS
         SDasRD73uC2Y0GFEGHUHPn4bcIkNBeuphPOrY0DKO3wEu0XRd35u7NaV7apCVBp8J+2O
         KdXWrVEKEC2WXl3JdWusCuIv+RPo/qvUXiqeRgQcjsCxgXTVdlKHxlNx9OVQRaEg1VkY
         WE9CUrtHDvzKhIWC1f9dI4E82084Z8MHGE4gM3hZmFOOGhBYDTXuLMeZ5qenxD5BjHXe
         YryWic8p/wrlntt1HwlD8QkgVA1hAUxHwvz8v3rAUIkZktKOPl4zC58KFsIB+lOiDbZK
         BAzg==
X-Gm-Message-State: AOAM532mV9tJZBgQ5Il1QePSgFavPhtDrJJ+oGuoP23fOn37TyMQlH1h
        JDvJmP7U5UFnUTojjpDWv2M65DPN5cA5ug==
X-Google-Smtp-Source: ABdhPJwYyA1X7Bfg45oD8YBhBwdA5jD7QS6C7HOdCnRZ2tfTgfGILyCszz8uNmzWyZLAkeSMiyLXGg==
X-Received: by 2002:a17:90a:9284:: with SMTP id n4mr5133516pjo.109.1641934953660;
        Tue, 11 Jan 2022 13:02:33 -0800 (PST)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id h19sm11844710pfh.112.2022.01.11.13.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 13:02:33 -0800 (PST)
Date:   Tue, 11 Jan 2022 13:02:29 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org
Subject: Re: [kvm-unit-tests PATCH] arm64: debug: mark test_[bp, wp, ss] as
 noinline
Message-ID: <Yd3wZaEVMTjdqpk2@google.com>
References: <20220111041103.2199594-1-ricarkol@google.com>
 <Yd3dvorNkP7eercw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yd3dvorNkP7eercw@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 11, 2022 at 07:42:54PM +0000, Sean Christopherson wrote:
> On Mon, Jan 10, 2022, Ricardo Koller wrote:
> > Clang inlines some functions (like test_ss) which define global labels
> > in inline assembly (e.g., ss_start). This results in:
> > 
> >     arm/debug.c:382:15: error: invalid symbol redefinition
> >             asm volatile("ss_start:\n"
> >                          ^
> >     <inline asm>:1:2: note: instantiated into assembly here
> >             ss_start:
> >             ^
> >     1 error generated.
> > 
> > Fix these functions by marking them as "noinline".
> > 
> > Cc: Andrew Jones <drjones@redhat.com>
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> > This applies on top of: "[kvm-unit-tests PATCH 0/3] arm64: debug: add migration tests for debug state"
> > which is in https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue.
> > 
> >  arm/debug.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arm/debug.c b/arm/debug.c
> > index 54f059d..6c5b683 100644
> > --- a/arm/debug.c
> > +++ b/arm/debug.c
> > @@ -264,7 +264,7 @@ static void do_migrate(void)
> >  	report_info("Migration complete");
> >  }
> >  
> > -static void test_hw_bp(bool migrate)
> > +static __attribute__((noinline)) void test_hw_bp(bool migrate)
> 
> Use "noinline", which was added by commit 16431a7 ("lib: define the "noinline" macro").

Will do, thanks for the pointer.

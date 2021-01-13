Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C191C2F50F2
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 18:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbhAMRSK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 12:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727265AbhAMRSK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 12:18:10 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37AEFC061575
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 09:17:30 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id z21so1905101pgj.4
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 09:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/3STmS+zatbijavWt2TOuzoxTb1FHjkZNwlSMF11jw0=;
        b=qGncu76OHOBf70DtOp94s5WPBtUSZQAg9+TESOqjGujjFleamyY7hjpE4ZxMc8dpmu
         qPPOlr9HEDxXMAWavY5ppT70MRbTVUHv/Te2aS1zBCqVHsQ/GD5hrLLnYv2vNbYKvwPN
         aDIBZNwv9K8iHbf456M0lrc7C6vMHpjaBY80TSBYK97jXyuZ5cdgo+zBbPRIhgywlF69
         bbLfS2CLHSJU6ujTMmp7A/L9uiEQmkqyq7tS64XVX5olYQUoQfafMMWdSgtyxw5QPx6q
         slrDtXpbIOOIltYbkZC/TyVX8TNeC9YDg0A1574F1afRqi7BCmdWQh1ijQg/aeV7dXoU
         Byug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/3STmS+zatbijavWt2TOuzoxTb1FHjkZNwlSMF11jw0=;
        b=jqrlTbfN6T2tJhAc97P5VxLuzmWRBDs8lgCcYqtJeAj4V0oCJVGdZW/GjX4n9K2cTe
         /OCtr7Nnm9WjUaBs6EktzbD5tBBbnqtU03OXFTizOTZ84dVT0v7TV9pzfN9ZHeEbA1Xb
         QfuFQbGV7/MVYOdnJCp0TDMiLFLfMo1KuW69Rw4bxOgywVMGhDhdX8N8GQ5zG8ROFtKs
         4A+9JE3DyT1gkO4fzzcMUQigCesu0kghJW0Lw/+FaMAQoZfRGIP/y+SXaR4ZCW2ybyk2
         MP/uxJ+yJ1L1gHHJx/R+QrMKmX05P3JDxawWL6vY89ax8z5aFdnIKQgsZT5/itFvFpNP
         LN/w==
X-Gm-Message-State: AOAM530047ii5StIxDvueSD8z9dlZTRPSj8yf02B+6pN3rDdmy8eS6fZ
        Whf7QjwaQYj7+QXrSSb3js/FKQsv5P0q9Q==
X-Google-Smtp-Source: ABdhPJzQAr5AwCj9j/9lCm0gPeLTxznNLGrNOq388mriy/cQdG48dqpJ/7jgEBs02tqYbK/EN/1gow==
X-Received: by 2002:a63:e151:: with SMTP id h17mr2963978pgk.120.1610558249502;
        Wed, 13 Jan 2021 09:17:29 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id d20sm40837423pjz.3.2021.01.13.09.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 09:17:28 -0800 (PST)
Date:   Wed, 13 Jan 2021 09:17:22 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jason Baron <jbaron@akamai.com>, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        peterz@infradead.org, aarcange@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: x86: introduce definitions to support static
 calls for kvm_x86_ops
Message-ID: <X/8rIgrMkb61/la9@google.com>
References: <cover.1610379877.git.jbaron@akamai.com>
 <ce483ce4a1920a3c1c4e5deea11648d75f2a7b80.1610379877.git.jbaron@akamai.com>
 <ee071807-5ce5-60c1-c5df-b0b3e068b2ba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee071807-5ce5-60c1-c5df-b0b3e068b2ba@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 13, 2021, Paolo Bonzini wrote:
> If you need to choose between DECLARE_STATIC_CALL_NULL and
> DECLARE_STATIC_CALL, you can have kvm-x86-ops.h use one of two macros
> KVM_X86_OP_NULL and KVM_X86_OP.
> 
> #define KVM_X86_OP(func) \
> 	DECLARE_STATIC_CALL(kvm_x86_##func,	\
> 			    *(((struct kvm_x86_ops *)0)->func));
> 
> #define KVM_X86_OP_NULL(func) \
> 	DECLARE_STATIC_CALL_NULL(kvm_x86_##func,	\

Gah, DECLARE_STATIC_CALL_NULL doesn't exist, though it's referenced in a comment.
I assume these should be s/DECLARE/DEFINE?  I haven't fully grokked the static
call code yet...

> 			    *(((struct kvm_x86_ops *)0)->func));
> 
> #include <asm/kvm-x86-ops.h>
> 
> ...
> 
> #define KVM_X86_OP(func) \
>   static_call_update(kvm_x86_##func, kvm_x86_ops.func)
> #define KVM_X86_OP_NULL(func) \
>   static_call_update(kvm_x86_##func, kvm_x86_ops.func)
> #include <asm/kvm-x86-ops.h>
> 
> In that case vmx.c and svm.c could define KVM_X86_OP_NULL to an empty string
> and list the optional callbacks manually.
> 
> Paolo
> 

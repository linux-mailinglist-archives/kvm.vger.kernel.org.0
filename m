Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E5E2F50B8
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 18:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbhAMRMR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 12:12:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727980AbhAMRMR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 12:12:17 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CB2C061794
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 09:11:36 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 30so1888292pgr.6
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 09:11:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=4uJELGmrgTV6oDhSBCZU6Lk6noMLvlnDJHsGzjWwBeg=;
        b=Jo3JSUvsZRJVAEhmBGnk+e8/L/q4NABUUGd4hKij9+6rkY9MSRRP5Sb5zeeDjh/P0K
         WgxdPdctlmPl/lWk3c7cmIL71R4rx7tG2LGNjLFFtySqxMz0Of7e4KKYxdMbk9qgCd59
         x4jj71do/qBl8fO/abGSj1tAa6X6IPjqn+U6Bcdj7iHs+PxnA7j5wGIAVO41VULDfr+v
         uICwldeZiWUI+B84R0ddSU3gkyBUsBPjflMG4vr43ygDIUSvL6ZG6Ws4/wOUOYIlHnxo
         0UQIIFLYjIgY8r1igv2Xtgp+3zYf1FEftFY6Oj6A5MCf/i6/2eAHGbUfCAQEqaThZNYU
         2zDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=4uJELGmrgTV6oDhSBCZU6Lk6noMLvlnDJHsGzjWwBeg=;
        b=i0PtGhFxUn6TAOlSdi19CVbOUN1I2ErBhV2BnZHTCjmbyS1oNx5oXiRZzxsDP4iOI5
         OKaFJdXYoEa3idx0yjW8N3/5pZ2kQbQAJG1wXbYfToEMWe5LbdmQ/Dn32YVLDuaSGVFg
         VROIG085HzkKqTd8B+rgEgxIePGPJAMyXjx7tdH/BfSh8dcD4sjoVku5jt261B+YUNhX
         vDt9DYCwAXgE/AVhbMRRBe6oD/5n7VYHC4q4J8JaQ7+XwB3YyR5xXER3zHthJ05h2n8h
         9cCMGximcxej1lTKEhl5Ew1umO9QFRsCAS/0TDCKJgTOqz++OXI0NHoP08DUwiSNkRz5
         f/Vg==
X-Gm-Message-State: AOAM5309gvBwuOcIRWZX2Ll2LxidjCktgV+G2abGdMqrTNCxtcgSK3Ka
        UZHyGHxB4eae1NklKKVD+wZHbQ==
X-Google-Smtp-Source: ABdhPJzG91J+1ta+ecDGKySDQDEH5DwHx7XtDzjnWpflYz+j2oLZvfcgItXkUlAezpQcgPxInhy0sw==
X-Received: by 2002:a63:1b22:: with SMTP id b34mr3003930pgb.132.1610557896044;
        Wed, 13 Jan 2021 09:11:36 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id p3sm3333425pjg.53.2021.01.13.09.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 09:11:35 -0800 (PST)
Date:   Wed, 13 Jan 2021 09:11:28 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Jason Baron <jbaron@akamai.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        peterz@infradead.org, aarcange@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: x86: introduce definitions to support static
 calls for kvm_x86_ops
Message-ID: <X/8pwE24sQmNuznq@google.com>
References: <cover.1610379877.git.jbaron@akamai.com>
 <ce483ce4a1920a3c1c4e5deea11648d75f2a7b80.1610379877.git.jbaron@akamai.com>
 <ee071807-5ce5-60c1-c5df-b0b3e068b2ba@redhat.com>
 <6026c2a4-57bf-e045-b62d-30b2490ee331@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6026c2a4-57bf-e045-b62d-30b2490ee331@akamai.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 13, 2021, Jason Baron wrote:
> 
> On 1/13/21 7:53 AM, Paolo Bonzini wrote:
> > #define KVM_X86_OP(func) \
> >   static_call_update(kvm_x86_##func, kvm_x86_ops.func)
> > #define KVM_X86_OP_NULL(func) \
> >   static_call_update(kvm_x86_##func, kvm_x86_ops.func)
> > #include <asm/kvm-x86-ops.h>
> > 
> > In that case vmx.c and svm.c could define KVM_X86_OP_NULL to an empty
> > string and list the optional callbacks manually.
> > 
> 
> Ok, yes, this all makes sense. So I looked at vmx/svm definitions
> and I see that there are 5 definitions that are common that
> don't use the vmx or svm prefix:

We'll rename the helpers when doing the conversion, i.e. you can safely assume
that all VMX/SVM functions will use the pattern {vmx,svm}_##func.  I did all the
renaming a few months back, but it got tossed away when svm.c was broken up.

> .update_exception_bitmap = update_exception_bitmap,
> .enable_nmi_window = enable_nmi_window,
> .enable_irq_window = enable_irq_window,
> .update_cr8_intercept = update_cr8_intercept,
> .enable_smi_window = enable_smi_window,

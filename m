Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCAA62E74F8
	for <lists+kvm@lfdr.de>; Tue, 29 Dec 2020 23:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgL2WO6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Dec 2020 17:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgL2WO6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Dec 2020 17:14:58 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB7AC061574
        for <kvm@vger.kernel.org>; Tue, 29 Dec 2020 14:14:17 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id e2so7727349plt.12
        for <kvm@vger.kernel.org>; Tue, 29 Dec 2020 14:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PizDOlpVsbZH64i8GikIjYAR5gm+hOoRIX/6bX40NPY=;
        b=tIkFpkAYvxjSJbAi6xFgMwqFfQ1saKG9rOj6RgONZ75cs96TTDk3U4q+QkAzIWv+nL
         jjStgb0rHgjLB2LmJ/6FZcjzd0V4XfBAtXZm+P6Y5NfOhxwPrnsNxXC6tyl5eO4waGxy
         xCPwIbGAuh/eipyySHHCNgd4f7wveAwpY00nt9F2ho5JVq2OcNFuSerHcv96O/MJeveq
         kvL/c4a1s8SDktbqBX8RBhp928WpSjoXYupqCttcYtDJa6oHJFXbKZI7K5BhVNSrmfky
         y8vR3cDDnc3LDuyPA2fkD1CS+umzgKxHXk2wUeRRFC+OYR0beisUadB2OeI4eyPNbyc7
         x8RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PizDOlpVsbZH64i8GikIjYAR5gm+hOoRIX/6bX40NPY=;
        b=MFnDycEGTnUVIPTZL505YPez8w60neituW3nJNPG5BsU/jxQcAwik1zHBf24cwUiVB
         Aa2K+5Gc65gsgPN5zgVhQWED8upVxIsned7flwFs1rflBKPlRfVLySWxVvYXnA05iHOT
         NiOCjnQMWTscqQhUYbZoh0qsNZAgbott2U/K03LhymRrR4DPAVNfYAfDzegy/dew1tt3
         RQp2wVvipy0jNLDf+r6XCOVWjK/pKx1VRU+1YPdEq7v0TNprFGQBHL25NzxU5EihbwnY
         yKzBGd+234mIzkhqhW4dze5rTBJXud7UWnMd5/g812cVfpSLZ6DmtO8hHsR5qAsDuCH3
         3Akw==
X-Gm-Message-State: AOAM530cscWqsOZE9mn4a4kdRH3deHQuLsO++RuuRGNiXS14YQ9IDRtk
        s+bzVTwaaSXeyK5yNmkGq4VELGtKBfAhPg==
X-Google-Smtp-Source: ABdhPJwCYt4hVFX1UCVZSMle7MH/FQuzhRpMwILJYtblJPy2Nl/nv6I1upp2/FZoRpWvv4cwqDSx0Q==
X-Received: by 2002:a17:902:7c04:b029:db:e44d:9366 with SMTP id x4-20020a1709027c04b02900dbe44d9366mr50594161pll.51.1609280057285;
        Tue, 29 Dec 2020 14:14:17 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id 4sm4346037pjn.14.2020.12.29.14.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Dec 2020 14:14:16 -0800 (PST)
Date:   Tue, 29 Dec 2020 14:14:10 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH v3] KVM/x86: Move definition of __ex to x86.h
Message-ID: <X+uqMvJDXCHH199o@google.com>
References: <20201221194800.46962-1-ubizjak@gmail.com>
 <X+pwQrLgVcMg0x3M@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X+pwQrLgVcMg0x3M@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 28, 2020, Sean Christopherson wrote:
> On Mon, Dec 21, 2020, Uros Bizjak wrote:
> > Merge __kvm_handle_fault_on_reboot with its sole user
> > and move the definition of __ex to a common include to be
> > shared between VMX and SVM.
> > 
> > v2: Rebase to the latest kvm/queue.
> > 
> > v3: Incorporate changes from review comments.
> 
> The v2, v3, ... vN patch history should go below the '---' so that it doesn't
> need to be manually stripped when applying.
> 
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> > Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> > ---
> 
> vN stuff down here
> 
> >  arch/x86/include/asm/kvm_host.h | 25 -------------------------
> >  arch/x86/kvm/svm/sev.c          |  2 --
> >  arch/x86/kvm/svm/svm.c          |  2 --
> >  arch/x86/kvm/vmx/vmx.c          |  4 +---
> >  arch/x86/kvm/vmx/vmx_ops.h      |  4 +---
> >  arch/x86/kvm/x86.h              | 24 ++++++++++++++++++++++++
> >  6 files changed, 26 insertions(+), 35 deletions(-)
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>

Paolo, can you hold off on queuing this patch?  Long story short, this jogged my
memory for something tangentially related and I ended up with series that kills
off __ex() / ____kvm_handle_fault_on_reboot() completely.  It's coded up, I just
need to test.  I'm OOO for a few days, will hopefully get it posted next week.

Thanks!

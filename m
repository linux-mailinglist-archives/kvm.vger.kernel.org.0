Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8F431EE72
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 19:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbhBRSf7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 13:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbhBRSDN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 13:03:13 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E65C0613D6
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 10:02:32 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id b145so1828708pfb.4
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 10:02:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ls8LFMuOfFIGXP+zyESQQVzdohbKJv1NNu1HQ2O+7mo=;
        b=vt0xaUaXssRiggG9KZr6gimnPEHznpV2Fa9on2er/KvXV+DyDwLdjMew6tUAPjAD+D
         3Kx9Tel6z3LhvrvChjjVuFCDg1HvRNA+h4TM3bMvryyE7e36j65FrOtYMrLhh0750jDJ
         mTZcyC2G7fj5/nFo4K6RtySvrjPXw9bFGIldUlTVda1VEkiME5d5iPk22YGTikR9/7rD
         vYPeoC4/r3iocdVPiuw9n9CesvbMZSjGHZo4BXanF4k5BUsvoD27VDG8XIcOEIgxjQQA
         agTyDddQ0gbN6niYP+htkntLzffcs5eVDRZ6yTiYJeuJG+XAYtU0zAAt9kmE59/ZxlbU
         1kTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ls8LFMuOfFIGXP+zyESQQVzdohbKJv1NNu1HQ2O+7mo=;
        b=EKWEvePl4Firu1dZEN+cVAyx7Okh+43USqUvI1iH6bSe/CAf9FngQMOnBSf0U2d8Vt
         HS44X1i+SNpurIA5UB9RNDMKTgV6pfgnvKLVHjSRhGqRkI6VtSS2cLuCMSNTrnFUXE0f
         Y/7fR/SSHNdi+uoYqSeKRts0/XZ4nPGJAh9evFAIf7fHvuIb7wTDGGaQ5ycaNF46GLKr
         xtvVPaz0EcfaicTNzls5Stb1Xk7M6k7nHqV9xPsh7e5g3exv5X5+T/l9InfObqsoWf2l
         CblA9G+dK8BGssWsL+nP/gBghz8n8fKK4AHZSX28+7D7kl5OGe8tBlcoocy6EE+UUTMI
         YHqA==
X-Gm-Message-State: AOAM533BU9+4K3+HkmRE/e3ENsyT8c6wfGBpPQHz/Z+83sUgj84s5A86
        wtAm2MAzcLMAeoGXJGt5RyW00Q==
X-Google-Smtp-Source: ABdhPJxSw0HbBab/Pii65Ovw+NhRgLoHYHkzQzk2SDTtnMynKpXQnHY6nm19yGrTglJTiJWQM+2WUw==
X-Received: by 2002:a65:4b89:: with SMTP id t9mr4975224pgq.211.1613671352128;
        Thu, 18 Feb 2021 10:02:32 -0800 (PST)
Received: from google.com ([2620:15c:f:10:dc76:757f:9e9e:647c])
        by smtp.gmail.com with ESMTPSA id ml7sm1210320pjb.28.2021.02.18.10.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 10:02:31 -0800 (PST)
Date:   Thu, 18 Feb 2021 10:02:25 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH kvm-unit-tests] x86: clean up EFER definitions
Message-ID: <YC6rsTdE1iqiYYYO@google.com>
References: <20210218132648.1397421-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218132648.1397421-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 18, 2021, Paolo Bonzini wrote:
> The X86_EFER_LMA definition is wrong, while X86_IA32_EFER is unused.
> There are also two useless WRMSRs that try to set EFER_LMA in
> x86/pks.c and x86/pku.c.  Clean them all up.

For posterity: EFER_LMA is incorrectly defined as EFER_LME, and both PKS and PKU
tests are 64-bit only, so the WRMSRs are guaranteed to be nops.

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Sean Christopherson <seanjc@google.com>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775B433F60D
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 17:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbhCQQvY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 12:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232634AbhCQQvD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 12:51:03 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435E0C06175F
        for <kvm@vger.kernel.org>; Wed, 17 Mar 2021 09:51:03 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id q6-20020a17090a4306b02900c42a012202so1660642pjg.5
        for <kvm@vger.kernel.org>; Wed, 17 Mar 2021 09:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f5B8RIbfm5J4UJRtgY7+A871o4pdaxUTzMiKm7U0AjE=;
        b=oFEUYdn0KTCCVCg+/s7305+A+2Q2gNLYfCq3g/fr8SsAJVDKnzA57x0RLPqFVBxwyR
         hKQ0TSaIbgzJ/3805DpmUyQoIS/MTJTclHQSKLp4QRFLbpoHpafiXJh6ggfQUbZHoH3x
         yfmVlrnSqS8db4n7/+LfwH+yKnI4THv/j7ZXbTkeWzNQCJkTwXb7VPOgLMUbtP3SQ/ab
         59aWoCdWtQ53azSWCXdlBudAbV0nMZMYtEo8996jP/D5aKvsBsmX1r+LCUFueWyeImVn
         RmlOKSnyp88A3b9z9SyT+c49HtNIJvSURpspy514vYpPYtTEI4vWmG83Q7d7NhBXFTAh
         tsTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f5B8RIbfm5J4UJRtgY7+A871o4pdaxUTzMiKm7U0AjE=;
        b=XaP3lucIoW1SUE1bd5bdM+DAF71LOQiuwlTvQrJN2jfNubIHFbwwsa9ChwXd5mKvLI
         XMoxkwTqEqsh10o/l3/62u8oyW/uqD+Go0xmVVooqzDLt44Kb5nv3isA6ZNU3jf48Vv3
         DzN2LgkNRs6z/i3T22kRluUOOfJCxCkmn2wjHLVDV0IJ4zMshT3cLwJmMVaoESd/zLDr
         DuG0J3A4+wS62Mc3dZsyDRDQkAUkEdWL43Ld03yLdKHTgfNlPgf52cm3u1BDjIixXlCi
         RpzgSl/dWA5zMXeSngzeEopN8aHTsthyvoyERROw8m2+yzutjV5KlRfToy68/qGBwXR0
         Pu+A==
X-Gm-Message-State: AOAM532p6Q8CZLvs8i2xlUEbZkuYTw2rFpTlIf7Tzyk8JwTRR9iGJbWd
        4C3LTZ/bG1KOwTqIT9juEeZnDg==
X-Google-Smtp-Source: ABdhPJwiAOSb88M3YGUbaEutvTwmBeiEwT6tDQYJ21cceXll22Jz5fIzzKNhUo9i4XRuBKiYmOYkIg==
X-Received: by 2002:a17:902:7203:b029:e6:a8b1:8d37 with SMTP id ba3-20020a1709027203b02900e6a8b18d37mr5367131plb.44.1615999862582;
        Wed, 17 Mar 2021 09:51:02 -0700 (PDT)
Received: from google.com ([2620:15c:f:10:e113:95c2:2d1:e304])
        by smtp.gmail.com with ESMTPSA id y2sm18524970pgf.7.2021.03.17.09.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 09:51:02 -0700 (PDT)
Date:   Wed, 17 Mar 2021 09:50:55 -0700
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Yuan Yao <yaoyuan0329os@gmail.com>
Subject: Re: [PATCH 2/4] KVM: nVMX: Handle dynamic MSR intercept toggling
Message-ID: <YFIzbz6S5/vyvBJz@google.com>
References: <20210316184436.2544875-1-seanjc@google.com>
 <20210316184436.2544875-3-seanjc@google.com>
 <66bc75f6-58c5-c67f-f268-220d371022a2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66bc75f6-58c5-c67f-f268-220d371022a2@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 17, 2021, Paolo Bonzini wrote:
> On 16/03/21 19:44, Sean Christopherson wrote:
> > Always check vmcs01's MSR bitmap when merging L0 and L1 bitmaps for L2,
> > and always update the relevant bits in vmcs02.  This fixes two distinct,
> > but intertwined bugs related to dynamic MSR bitmap modifications.
> > 
> > The first issue is that KVM fails to enable MSR interception in vmcs02
> > for the FS/GS base MSRs if L1 first runs L2 with interception disabled,
> > and later enables interception.
> > 
> > The second issue is that KVM fails to honor userspace MSR filtering when
> > preparing vmcs02.
> > 
> > Fix both issues simultaneous as fixing only one of the issues (doesn't
> > matter which) would create a mess that no one should have to bisect.
> > Fixing only the first bug would exacerbate the MSR filtering issue as
> > userspace would see inconsistent behavior depending on the whims of L1.
> > Fixing only the second bug (MSR filtering) effectively requires fixing
> > the first, as the nVMX code only knows how to transition vmcs02's
> > bitmap from 1->0.
> > 
> > Move the various accessor/mutators buried in vmx.c into vmx.h so that
> > they can be shared by the nested code.
> > 
> > Fixes: 1a155254ff93 ("KVM: x86: Introduce MSR filtering")
> > Fixes: d69129b4e46a ("KVM: nVMX: Disable intercept for FS/GS base MSRs in vmcs02 when possible")
> > Cc: stable@vger.kernel.org
> > Cc: Alexander Graf <graf@amazon.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---

...

> Feel free to squash patch 3 in this one or reorder it before; it makes sense
> to make them macros when you go from 4 to 6 functions.

I put them in a separate patch so that backporting the fix for the older FS/GS
nVMX bug was at least feasible.  Not worth it?

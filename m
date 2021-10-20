Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63CD54352C4
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 20:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhJTSk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 14:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbhJTSkZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 14:40:25 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2F9C06161C
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 11:38:11 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id pi19-20020a17090b1e5300b0019fdd3557d3so3056090pjb.5
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 11:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uMN9qvywh3sv/oaPckg/G842AJu+I72mzD6okHONmBE=;
        b=OQtzFHyCtGBKK45bfehF2A364ZUkMfTSyUySkQyT4iu/jfR47nbaZ2erU1cNvlnaw4
         t4t+qmcXhOKAe7jSMzJ7eNQNndMj2L80zwE1QWx8bk3GX4YLE9u8xrZ1TvUcWMuFheCV
         faG9N51gBShfpEpmnLkJbfACb2c6dA8JCf1kfQllKRjlGrbzMtbARsgXX2Q5oiZBEgVZ
         uFotf1fuqwzgiAryDidSCxyS52Ax+/LaQ3aGyKffmOvbTHZM5pWSclzGd0oMzgyvJEXV
         B+FMz5ciFWfOY8j3NW4kN0OKETi3eRQ2q4k1uagZQHkE8i6gtmaOcPwDg/mQL39JCeqp
         C38A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uMN9qvywh3sv/oaPckg/G842AJu+I72mzD6okHONmBE=;
        b=Ba5qfZIapPQdAfZqHu0zKrpU4NTpc6qImjACZVeE1np7JeJs+jA5I7w2o7J/L2/f6/
         Lm4Hi/EMd4paOSYgzr5oQb4YH3h7I/rFsd/ey8KyKonNptmIy+SMl7me1lo9p0K3MlTr
         pkkaBQK+E8dLXJNLOKgCr/pVZgy3bsE/46fYP2LmJNP3+63hxTWcywWtCVb6D9ci+RSC
         2cZnZPH1eiWnrmfPNJpY1takYGsrAsd1Urn/fK1D2ahsHRsxHim/OUcAN7xupvE5p2UC
         oIyC61IuFWH5WTmaZG/kdN8f38IJ6ho/on05UVs3K3yft7tht/7+MxcejLZmu5loaF2+
         QqPw==
X-Gm-Message-State: AOAM532fk5K424KsYPsJ5KlKxhu3HvibHfftcrS72k7kfHeieYyWrJo0
        DIBihew2++2bin8+IdbTwBGHidu5SxoZvg==
X-Google-Smtp-Source: ABdhPJxDxfUH+ZisL0WQepkRzWx6ElcffZJPq7n362achsfgXeb9+WjHNojBNJyaIeobx95CO6qwwg==
X-Received: by 2002:a17:90a:c595:: with SMTP id l21mr656275pjt.188.1634755090640;
        Wed, 20 Oct 2021 11:38:10 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id lp9sm3549636pjb.35.2021.10.20.11.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 11:38:10 -0700 (PDT)
Date:   Wed, 20 Oct 2021 18:38:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH v5 4/6] KVM: SVM: Add support to handle AP reset MSR
 protocol
Message-ID: <YXBiDr5mgtkgwBDR@google.com>
References: <20211020124416.24523-1-joro@8bytes.org>
 <20211020124416.24523-5-joro@8bytes.org>
 <YXBUlYll8JDjH/Wd@google.com>
 <95d99b9a-8600-619b-9b83-63597d937bc6@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95d99b9a-8600-619b-9b83-63597d937bc6@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 20, 2021, Tom Lendacky wrote:
> On 10/20/21 12:40 PM, Sean Christopherson wrote:
> > On Wed, Oct 20, 2021, Joerg Roedel wrote:
> > This can race with the SIPI and effectively corrupt svm->vmcb->control.ghcb_gpa.
> > 
> >          vCPU0                           vCPU1
> >                                          #VMGEXIT(RESET_HOLD)
> >                                          __kvm_vcpu_halt()
> >          INIT
> >          SIPI
> >          sev_vcpu_deliver_sipi_vector()
> >          ghcb_msr_ap_rst_resp(1);
> 
> This isn't possible. vCPU0 doesn't set vCPU1's GHCB value. vCPU1's GHCB
> value is set when vCPU1 handles events in vcpu_enter_guest().

Argh, I was thinking of injecting regular IPIs across vCPUs.  In hindsight it
makes sense that INIT and SIPI are handled on the current vCPU, stuffing all that
state from a different vCPU would be needlessly complex.

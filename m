Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3544630EA0D
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 03:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbhBDCUU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 21:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233077AbhBDCUT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 21:20:19 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74762C061573
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 18:19:39 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id s24so810290pjp.5
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 18:19:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=bI15oVQgc1lFGULeaCog8tE69ZYTPzxNtQA/R861SRY=;
        b=Ul6QJPOqgKCpkIj2uU3Ya196bFz7RuWWlxzfr/nMwlbTiEGDHGVJTmdhE83/bPxc84
         6J3JrRSXI8eEVh+dxZ1/9JzGIz+k5HZQn4NAzVeTnMx3iG/wLMNk/T8mM3jmPkrKSwWi
         canJoZNADlCZC/y6Ej4WVzdIU5Vmb4YIbQCuuh1Cv/kDcze5rxHO0wd4iZIhF1oZS97J
         jgaeP/ZYjTSP1vXp6b7p7Wi3rUkb7ZN6x8FCp89VRtGctCyV5gg1LlkcefV48s6qHRPL
         bdE5ZIgnyhgsnAMnR+YoPYVZ7pDOBP2BkEBOhzBTi6kW1q75dsEAFi1w9eHRS7bDiATT
         s2QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=bI15oVQgc1lFGULeaCog8tE69ZYTPzxNtQA/R861SRY=;
        b=X/U2GTp7i0FfYsBdTnDnal8g1WeD5gCMIDnn11E8fZCtTgJMOPw9UVVCeC9BOBNd4y
         M3BPdSu7Dnu45PZNiZ+9hFmeYMynP1PRv6PJCnmqs0vViaV26YbKZIWtCvhjPUYIjq44
         elR5U4m5QHziiCt2g59b+9JrjpgDnhJaOe9bXRDoa+ykvpgUZPJ6okd9g7b5sM8j2SGi
         gx/9/MkuekLa4r+I+FQSIArDKB/9reGZZ5D2+JSbEvSu6JZhVPCA/44FJiYfa1xf4dlI
         Qja31PxmvrVFwcT3/XpJMypKnTuOOMKWzEAF+ROOSvHuMgPG0zQUOyeSPYlZxYkaWPlK
         tvAQ==
X-Gm-Message-State: AOAM531cMI46GTUC4mDw9RfeTDNukZ9/ZTEqiDapLIbk5UWFpcAOjj6y
        BgwxxIUec8Vz78ATx1w4FaEA0w==
X-Google-Smtp-Source: ABdhPJypw/YUgiSi5ZA2WhWPE4I6mYx08kPE1EXRXSSrf4FwN3n6GhJer5RMDpiqQP5ClCUruKsa0w==
X-Received: by 2002:a17:90b:4c85:: with SMTP id my5mr6184510pjb.225.1612405178717;
        Wed, 03 Feb 2021 18:19:38 -0800 (PST)
Received: from google.com ([2620:15c:f:10:a9a0:e924:d161:b6cb])
        by smtp.gmail.com with ESMTPSA id u26sm3497603pfm.61.2021.02.03.18.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 18:19:38 -0800 (PST)
Date:   Wed, 3 Feb 2021 18:19:31 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Subject: Re: [PATCH 07/12] KVM: x86: SEV: Treat C-bit as legal GPA bit
 regardless of vCPU mode
Message-ID: <YBtZs4Z2ROeHyf3m@google.com>
References: <20210204000117.3303214-1-seanjc@google.com>
 <20210204000117.3303214-8-seanjc@google.com>
 <5fa85e81a54800737a1417be368f0061324e0aec.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fa85e81a54800737a1417be368f0061324e0aec.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 04, 2021, Edgecombe, Rick P wrote:
> On Wed, 2021-02-03 at 16:01 -0800, Sean Christopherson wrote:
> >  
> > -       unsigned long cr3_lm_rsvd_bits;
> > +       u64 reserved_gpa_bits;
> 
> LAM defines bits above the GFN in CR3:
> https://software.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-programming-reference.html
> 
> KVM doesn't support this today of course, but it might be confusing to
> try to combine the two concepts.

Ah, took me a few minutes, but I see what you're saying.  LAM will introduce
bits that are repurposed for CR3, but not generic GPAs.  And, the behavior is
based on CPU support, so it'd make sense to have a mask cached in vcpu->arch
as opposed to constantly generating it on the fly.

Definitely agree that having a separate cr3_lm_rsvd_bits or whatever is the
right way to go when LAM comes along.  Not sure it's worth keeping a duplicate
field in the meantime, though it would avoid a small amount of thrash.

Paolo, any thoughts?

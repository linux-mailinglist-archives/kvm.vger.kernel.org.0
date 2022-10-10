Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C825FA202
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 18:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiJJQb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 12:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiJJQb4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 12:31:56 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095CF6BCED
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 09:31:55 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id f140so11225396pfa.1
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 09:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cef4tENcEln1YpvYHQqhPeC7gMKImdcmFkiWo05D8o0=;
        b=PQFFoZUc+lDbIKkce4B2VR38yIj97UhKeRmHUeEaanlFq7GdI0oJfH2/datNrT3ac+
         UTFRW4f6tRQ8TfvPeM3KSRbYd5MA8kqTEvnV14XogbwCnoGijmBCBbKdGEFxtzoIvDBk
         4NBgSB95fW/mighg6OSyReveap83AZFvJusdWM+MYs7E8t1xW9YLM98dZtIPWfVaNzOW
         UBOBigXrKS+mdm3oVtingOs03WyeQ1Hf0YxfbfBaRKQy0mflM5DeyNLYnCgvtddVY5+v
         0wyYOt4sb0ovI4puHffpjlNFeM63d3hnca7IXcgqrcf6/3esQOXZWBHxWF375HXM/wQK
         cK7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cef4tENcEln1YpvYHQqhPeC7gMKImdcmFkiWo05D8o0=;
        b=vjD1GvYjenek6GpBhdH1a8sPua6JTSRTrbNrAYeVTRq7Dhek3WeQ7uWqyTb3N3IvXl
         E9QO0M4lGR1LNfSM30a5lZbdn1Vc7czmE3pwO9ilMS/QK5hmvCaT1btw++Al2+qnwALx
         eU54WmeKEPLfggK1aB3SBR6JshitLCuUrpAmJKv+PUFWOwS1hNn/xqVxDtehLYALyptl
         8SFfAfDNR3hhDMY79VqWkDYwrGgR0zK+yGeykd96qUZBHI+24O+lGqm2Co8sUg+IGrWR
         1PZRRpo+GQFHEe9Pb7U6lLLTKu49COpg0i3HjcwX6WyVFDXyK2HC4C3TJlyn+FTiM8TD
         oorg==
X-Gm-Message-State: ACrzQf1c1twqROaLPkn/JQGVw70YA2jF+UOw673uKRbo22XZlnlKB6EI
        8+gYEKfIw+9Uukpg/ONVbpT8vQ==
X-Google-Smtp-Source: AMsMyM6qMVfnGNSFco0Sh4eauG3X9+2OZTzj81+MF94q6XAf4Z7ObzGbHU8Z/N2phVDyoP/4+ad7ig==
X-Received: by 2002:a65:6954:0:b0:445:fdb8:738e with SMTP id w20-20020a656954000000b00445fdb8738emr16712484pgq.520.1665419514448;
        Mon, 10 Oct 2022 09:31:54 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id ij2-20020a170902ab4200b00176ab6a0d5fsm6918110plb.54.2022.10.10.09.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 09:31:53 -0700 (PDT)
Date:   Mon, 10 Oct 2022 16:31:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v5 7/7] KVM: x86/mmu: explicitly check nx_hugepage in
 disallowed_hugepage_adjust()
Message-ID: <Y0RI9oQt9L78oom3@google.com>
References: <20220930234854.1739690-1-seanjc@google.com>
 <20220930234854.1739690-8-seanjc@google.com>
 <Y0N+d2seeNJcsFPD@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0N+d2seeNJcsFPD@yzhao56-desk.sh.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 10, 2022, Yan Zhao wrote:
> On Fri, Sep 30, 2022 at 11:48:54PM +0000, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 54005b7f1499..688beed3a41e 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3110,6 +3110,11 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
> >  	    cur_level == fault->goal_level &&
> >  	    is_shadow_present_pte(spte) &&
> >  	    !is_large_pte(spte)) {
> > +		u64 page_mask;
> > +
> > +		if (!spte_to_child_sp(spte)->nx_huge_page_disallowed)
> > +			return;
> Merge this "if" with the upper level "if" ?

Ya, good call.  The separate check is no longer necessary now that the superfluous
smp_rmb() is gone.  That'll minimize the diff to.

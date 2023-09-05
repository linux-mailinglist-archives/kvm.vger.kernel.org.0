Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6527930BF
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 23:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238246AbjIEVJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 17:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234306AbjIEVJu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 17:09:50 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD8A1BB
        for <kvm@vger.kernel.org>; Tue,  5 Sep 2023 14:09:40 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-68bec4380edso312365b3a.1
        for <kvm@vger.kernel.org>; Tue, 05 Sep 2023 14:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693948180; x=1694552980; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HxWd/JxgmSGajFF87A8h9wNUEFwW+sZa+eEy3CYAxpg=;
        b=Gc5STmxqUeIoxFwRhte5YyhM4UOJ5MIgSmqvewy6bq2GHf7MbfmQMHhHuuXHmX+AvO
         IW1K7oK+6n+uqRMwrhC678PeMiBvoab0nbvMazhOYnhl3iXPZQhGIn+sak//iT+M5kDe
         sCZxtDn2SFFlmvEbSfeQp2I+VmXKz7kzdWgJUcaU5O+kyXiWylSIS/D9VS12PJ/7QxH9
         tXx3czKZK9VbYLc4LKgwOUUr1Hst52QypGDtfsEqbJduj7+a0mMOnApjZQhKBbw6V3Ai
         aAjHcRo4oO//Gp/4GFTsK9v/J6MofD8garwT7G0Lb3HNR7T4LB9WkzdP4uyA058xJZof
         NdKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693948180; x=1694552980;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HxWd/JxgmSGajFF87A8h9wNUEFwW+sZa+eEy3CYAxpg=;
        b=B8eGZfUPGxjnycue5hWd2WR+NV95B8+fOsP4aWcYt9SmOIMRzUmwoVm90nzez3/3IW
         OO00NHB3c3kLrO6eYG8EYUIB64bPiUZ8A+tHAk2Q9DF0Z3OcGT/x+ewnE2zBWgVulNxL
         BzbbhbxU/Ay47S0u9FSn8UQJuKb7f8cOcM8fIGVrAv1z6oyq9BwFV0EuHkd/ccVSHgqV
         OIO8QQqqI0pEVRFJI9JkMQLQdmp+95adYKGvcbFM6yPeX1/K8HJ/5eoRqEd+iX4xEDkZ
         LtiF7XWBD1QvinDNUD/Ys+wjWQRBjVGckD4JkSe4qjft1oz7hDzR2bQBJaGYtSvU4zSq
         rVdQ==
X-Gm-Message-State: AOJu0YzQQberxs88+CEDUJXZpl36/f2iqgEivsjUBE5DoQkFPDm6aTlq
        nJVaH1/hFR4fA0iqW4twlPP8F2rGM4w=
X-Google-Smtp-Source: AGHT+IGI+Vz9BgR1PXF97IznQmBHRaIcD4F8AI2rGPVPalycx2vl24NpJSXelSsFzyRf0WUSSrif3BRxw+k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d0d:b0:68a:5937:ea87 with SMTP id
 fa13-20020a056a002d0d00b0068a5937ea87mr5398834pfb.3.1693948179970; Tue, 05
 Sep 2023 14:09:39 -0700 (PDT)
Date:   Tue, 5 Sep 2023 14:09:38 -0700
In-Reply-To: <99cf9b5929418e8876e95a169d20ee26e126c51c.camel@intel.com>
Mime-Version: 1.0
References: <20230902175431.2925-1-zeming@nfschina.com> <ZPIVzccIAiQnG4IA@google.com>
 <99cf9b5929418e8876e95a169d20ee26e126c51c.camel@intel.com>
Message-ID: <ZPeZEpn391RGLob6@google.com>
Subject: Re: [PATCH] x86/kvm/mmu: =?utf-8?Q?Remove_?= =?utf-8?B?dW5uZWNlc3Nhcnkg4oCYTlVMTOKAmQ==?=
 values from sptep
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "zeming@nfschina.com" <zeming@nfschina.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 04, 2023, Kai Huang wrote:
> On Fri, 2023-09-01 at 09:48 -0700, Sean Christopherson wrote:
> > @@ -3447,6 +3447,14 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >                 else
> >                         sptep = fast_pf_get_last_sptep(vcpu, fault->addr, &spte);
> >  
> > +               /*
> > +                * It's entirely possible for the mapping to have been zapped
> > +                * by a different task, but the root page is should always be
> > +                * available as the vCPU holds a reference to its root(s).
> > +                */
> > +               if (WARN_ON_ONCE(!sptep))
> > +                       spte = REMOVED_SPTE;
> 
> If I recall correctly, REMOVED_SPTE is only used by TDP MMU code.  Should we use
> 0 (or initial SPTE value for case like TDX) instead of REMOVED_SPTE?

I deliberately suggested REMOVED_SPTE in part because of TDX introducing "initial
SPTE"; finding/remembering '0' initialization of SPTEs is hard.  Though FWIW, '0'
would be totally fine for TDX because the value is never exposed to hardware.

I think it's totally fine to use REMOVED_SPTE like this in common code, I would
be quite surprised if it causes confusion.  Even though REMOVED_SPTE was introduced
by the TDP MMU, its value/semantics are generic.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27FB96F70CC
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 19:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjEDRYC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 13:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbjEDRYA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 13:24:00 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C1B448A
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 10:23:59 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba1b052e53dso1147702276.1
        for <kvm@vger.kernel.org>; Thu, 04 May 2023 10:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683221039; x=1685813039;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ONB00+6Q69z3/h03ZXeAoDFdXXdOjEaMLtfkrHED77E=;
        b=a19ly5QJ1Q1N22wDXhgi9csT1yq+d14FzfsBWgUtF4wbUqyCVwSYl75NVDF+a4VtDE
         Ii9TlZsiACL2LTTI08ua87HBuUovZFuBkxtAs65RU+NYy+LOeL81Yx25IxhPkStxvE4a
         puKgvwWz8lVMfccj9E41YPBeKftkVqVLBUUOm8MaEYjLyhmqBwWKsChhLCXouqxxIb0V
         ZxHq+oddfmEkNiR82cqG4X6vidPMoanq8BFAbBQA+v97hN4fxCRmNe8QoTf169a64ul8
         +l0aISINsGVg9egilXnwsORqMbtmn6H6Vr9fiRayC/WofHyGLboRtxmtxwXGO5i2CIIe
         IROA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683221039; x=1685813039;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ONB00+6Q69z3/h03ZXeAoDFdXXdOjEaMLtfkrHED77E=;
        b=kzxFTUCEYLFK3wGEPwwfTBTXxLxq0aaPaeSaKY8B43rWiDgeLCC/yXnz6n0KKkE/kW
         VxFtvRp9NlE0DMZejfVGYgSqtPg9GXn9tZvwdkbwnEBokZRHQzAjHC+0fUC/p42JN15R
         6V3WQugykXHdgaXvuZlZ7dlsCh6aTnjC+1LnaYXo+9iWTWqGZcxnVGZXKaP5tqkdn2dF
         Y1VIeSCwvDiYYt4rXwSV2gCiIbqVBzdEjggyABHE+pjvSw+Ih8fA8im1vmspVz8KN+22
         E2p997kYNNBfFlwS9xi/3PmhTBaOZKHLMOtspqT9lWTwYsxLIoHJtiALU2zj/tjkvZLV
         riTw==
X-Gm-Message-State: AC+VfDwHf+blDHXKdaofvE7EMVMZC+iGmmkvRLRn6yFcFTTC6ZBQ7Ddf
        4/4F8VSqNQgmb35z6jiB1eufy+HklPc=
X-Google-Smtp-Source: ACHHUZ6nT2T395WRubeB3aSWGrfqRKKIgCUhsMtSEWpYYWZrkznq+sx7rqITmcWPGdxyYiBgCtn8mm8/UAQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8b03:0:b0:b9d:f5b9:3d58 with SMTP id
 i3-20020a258b03000000b00b9df5b93d58mr281680ybl.3.1683221039062; Thu, 04 May
 2023 10:23:59 -0700 (PDT)
Date:   Thu, 4 May 2023 10:23:57 -0700
In-Reply-To: <34f44b2748ad1365907c7927a3cbee794b986243.camel@intel.com>
Mime-Version: 1.0
References: <20230503182852.3431281-1-seanjc@google.com> <20230503182852.3431281-2-seanjc@google.com>
 <56fa0da83203b20c9945e7c82a0eed11f3d31ea5.camel@intel.com>
 <ZFLtfFjAvuL0JSQj@google.com> <34f44b2748ad1365907c7927a3cbee794b986243.camel@intel.com>
Message-ID: <ZFPqLS08b0xT/PLa@google.com>
Subject: Re: [PATCH 1/5] KVM: VMX: Open code writing vCPU's PAT in VMX's MSR handler
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "guoke@uniontech.com" <guoke@uniontech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haiwenyao@uniontech.com" <haiwenyao@uniontech.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 03, 2023, Kai Huang wrote:
> On Wed, 2023-05-03 at 16:25 -0700, Sean Christopherson wrote:
> > On Wed, May 03, 2023, Kai Huang wrote:
> > > On Wed, 2023-05-03 at 11:28 -0700, Sean Christopherson wrote:
> > > > From: Wenyao Hai <haiwenyao@uniontech.com>
> > > > 
> > > > Open code setting "vcpu->arch.pat" in vmx_set_msr() instead of bouncing
> > > > through kvm_set_msr_common() to get to the same code in kvm_mtrr_set_msr().
> > > 
> > > What's the value of doing so, besides saving a function of kvm_set_msr_common()?
> > 
> > To avoid complicating a very simple operation (writing vcpu->arch.pat), and to
> > align with SVM.
> > 
> > > PAT change shouldn't be something frequent so shouldn't in a performance
> > > critical path.  Given the PAT logic on Intel and AMD are basically the same ,
> > > isn't it better to do in kvm_set_msr_common()?
> > 
> > I could go either way on calling into kvm_set_msr_common().  I agree that
> > performance isn't a concern.  Hmm, and kvm_set_msr_common() still has a case
> > statement for MSR_IA32_CR_PAT, so handling the write fully in vendor code won't
> > impact the code generation for other MSRs.
> > 
> > Though I am leaning towards saying we should either handle loads and stores to
> > vcpu->arch.pat in common code _or_ vendor code, i.e. either teach VMX and SVM to
> > handle reads of PAT, or have their write paths call kvm_set_msr_common().  A mix
> > of both is definitely odd.
> 
> Agreed.  Alternatively we can move SVM's setting vcpu->arch.pat to common code.
> 
> > 
> > I don't have strong preference on which of those two we choose.  I dislike duplicating
> > logic across VMX and SVM, but on the other hands it's so little code.  I think
> > I'd vote for handling everything in vendor code, mostly because this gives the
> > appearance that the write can fail, which is silly and misleading.
> > 
> > 		ret = kvm_set_msr_common(vcpu, msr_info);
> 
> No opinion either.  First glance is having 
> 
> 	case MSR_IA32_CR_PAT:
> 		vcpu->arch.pat = data;
> 
> in kvm_set_msr_common() is clearer because it is symmetrical to the read path.
> 
> Anyway your decision :)

Duh, the obvious answer is to do 

	ret = kvm_set_msr_common(vcpu, msr_info);
	if (ret)
		break;

	<vendor code here>

That's an established pattern for other MSRs, and addresses my main concern of
not unwinding the VMCS updates in the should-be-impossible scenario of
kvm_set_msr_common() failing after the kvm_pat_valid() check.

Thanks Kai!

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0AD5B6801
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 08:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbiIMGiW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Sep 2022 02:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiIMGiU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Sep 2022 02:38:20 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF104B4B3
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 23:38:19 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id q9-20020a17090a178900b0020265d92ae3so14599062pja.5
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 23:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=yRMQ/7+r9GUY+GzpBL7TomOE27K2ryKn69RGe09nqHE=;
        b=l2EDNIeQsRD9mPqnUsJKYjUQa93muu4Fn3t2t01mz/eo6EoREvzQYFrIqZbuxjleea
         ZW6EEZG4zJxUHqVMLXJc+jJA4lCpC1V9SJ7A4ZTpfGDMppI5Qye8jmpvLuXi5hfTvc07
         HfcJK2E7QL6vt/x0v1qvwkcREMTF1UpfK70oLAYz7sNdre40xvy4Z9mSZygrBTfgk3TB
         2FOhnWCLOQMhhmcSYRipoT2Toc+YcrK9vi4NaydFGdH//7hx64TI72NHZHg1gzJ8j13+
         gNnDw+OZ3cd+JStW2oGfXyQpYhTXDYUwu73cwwaSveqG/QrmbKwzB0LCBz7vnyxvjsX0
         rqaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=yRMQ/7+r9GUY+GzpBL7TomOE27K2ryKn69RGe09nqHE=;
        b=wlHcflewZqJ36JdQp6MSLvxNK48mcAXgPWXUMCN40x6+Vo2EicSY7JEQ6DRBYmuVno
         VLTEOoxoJYbX74Q1sOY5ttLVK5ukaJihA6RgQhOeVchd7PGzsITlF77BQmxyAFi2PFoQ
         IRbYGNcLd4YZLOi3ZywStyylLJJevhJTUqwRyuNTC1p3l76l6HrJlBuWPEpJUb5eK0aU
         5GBaT0+YACefxSZ/apefafezfvn2Krjn3DMFsTe9af3W1zQF5vZj01f6gj+YGBhr1E/P
         q2i4gJbQlh3SlquUq8a3KdbDLVygxz7snghZW/pR9VFLhuSOP6Dsm1+OScv/NsLLORp1
         48gQ==
X-Gm-Message-State: ACgBeo0lFPKVTVJnKwkNNIcg6ZKlY1tqIpFDXpvgDkW+OpgbSEbdS+0S
        I6Jju8U11l9nnzojgQGDso0BS0NT0AxwEg==
X-Google-Smtp-Source: AA6agR5EqqCusRAusedKrvgiXAIj6PhCK9BLb4GY+vQQFeGhrkaFHhQ2X4fxNVEeHduBK7MMPbrw+w==
X-Received: by 2002:a17:903:2285:b0:177:ab99:9e5 with SMTP id b5-20020a170903228500b00177ab9909e5mr28592312plh.121.1663051098722;
        Mon, 12 Sep 2022 23:38:18 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i32-20020a17090a3da300b001fbb0f0b00fsm6364690pjc.35.2022.09.12.23.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 23:38:18 -0700 (PDT)
Date:   Tue, 13 Sep 2022 06:38:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH kernel] KVM: SVM: Fix function name in comment
Message-ID: <YyAlVrrSpqTxrRlM@google.com>
References: <20220912075219.70379-1-aik@amd.com>
 <Yx79ugW49M3FT/Zp@google.com>
 <699404b6-dfa7-f286-8e66-6d9cadd10250@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <699404b6-dfa7-f286-8e66-6d9cadd10250@amd.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 13, 2022, Alexey Kardashevskiy wrote:
> On 12/9/22 19:36, Sean Christopherson wrote:
> > On Mon, Sep 12, 2022, Alexey Kardashevskiy wrote:
> > > A recent renaming patch missed 1 spot, fix it.
> > > 
> > > This should cause no behavioural change.
> > > 
> > > Fixes: 23e5092b6e2a ("KVM: SVM: Rename hook implementations to conform to kvm_x86_ops' names")
> > > Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> > > ---
> > >   arch/x86/kvm/svm/sev.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > index 28064060413a..3b99a690b60d 100644
> > > --- a/arch/x86/kvm/svm/sev.c
> > > +++ b/arch/x86/kvm/svm/sev.c
> > > @@ -3015,7 +3015,7 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
> > >   	/*
> > >   	 * As an SEV-ES guest, hardware will restore the host state on VMEXIT,
> > >   	 * of which one step is to perform a VMLOAD.  KVM performs the
> > > -	 * corresponding VMSAVE in svm_prepare_guest_switch for both
> > > +	 * corresponding VMSAVE in svm_prepare_switch_to_guest for both
> > >   	 * traditional and SEV-ES guests.
> > >   	 */
> > 
> > Rather than match the rename, what about tweaking the wording to not tie the comment
> > to the function name, e.g. "VMSAVE in common SVM code".
> 
> Although I kinda like the pointer to the caller, it is not that useful with
> a single caller and working cscope :)

Yeah, having exact function names is nice, but we always seem to end up with goofs
like this where a comment gets left behind and then they become stale and confusing.

> > Even better, This would be a good opportunity to reword this comment to make it more
> > clear why SEV-ES needs a hook, and to absorb the somewhat useless comments below.
> > 
> > Would something like this be accurate?  Please modify and/or add details as necessary.
> > 
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 3b99a690b60d..c50c6851aedb 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -3013,19 +3013,14 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
> >   void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
> >   {
> >          /*
> > -        * As an SEV-ES guest, hardware will restore the host state on VMEXIT,
> > -        * of which one step is to perform a VMLOAD.  KVM performs the
> > -        * corresponding VMSAVE in svm_prepare_switch_to_guest for both
> > -        * traditional and SEV-ES guests.
> > +        * Manually save host state that is automatically loaded by hardware on
> > +        * VM-Exit from SEV-ES guests, but that is not saved by VMSAVE (which is
> > +        * performed by common SVM code).  Hardware unconditionally restores
> > +        * host state, and so KVM skips manually restoring this state in common
> > +        * code.
> 
> I am new to this arch so not sure :) The AMD spec calls these three "Type B
> swaps" from the VMSA's "Table B-3. Swap Types" so may be just say:
> 
> ===
> These are Type B swaps which are not saved by VMSAVE (performed by common
> SVM code) but restored by VMEXIT unconditionally.

Weird consistency nit: KVM refers to VM-Exit as an event and not a thing/action,
whereas the APM tends to refer to VMEXIT as a thing, thus the "on VM-Exit" stylization
versus "by VMEXIT".  Similarly, when talking about the broader event of entering
the guest, KVM uses "VM-Enter".

VMRUN and VMSAVE on the other hand are instructions and so are "things" in KVM's world.

Using the VM-Enter/VM-Exit terminology consistently throughout KVM x86 makes it easy
to talk about KVM x86 behavior that is common to both SVM and VMX without getting
tripped up on naming differences between the two.  So even though it's a little odd
odd when looking only at SVM code, using "on VM-Exit" instead of "by VMEXIT" is
preferred.

> ===

I want to avoid relying on the APM's arbitrary "Type B" classification.  Having to
dig up and look at a manual to understand something that's conceptually quite simple
is frustrating.  Providing references to "Type B" and the table in the changelog is
definitely welcome, e.g. so that someone who wants more details/background can easily
find that info via  via git blame.  But for a comment, providing all the information
in the comment itself is usually preferable.

How about this?

  Save state that is loaded unconditionally by hardware on VM-Exit for SEV-ES
  guests, but is not saved via VMRUN or VMSAVE (performed by common SVM code).

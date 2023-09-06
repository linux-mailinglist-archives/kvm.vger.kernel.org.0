Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 570B179444B
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 22:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244258AbjIFULs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 16:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231558AbjIFULq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 16:11:46 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CCE198E
        for <kvm@vger.kernel.org>; Wed,  6 Sep 2023 13:11:42 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d7ba833ef2aso290373276.0
        for <kvm@vger.kernel.org>; Wed, 06 Sep 2023 13:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694031101; x=1694635901; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=peODubx65uqMrjkWQ//78jxQ/SfLOSDFlEmlVraSU1s=;
        b=oMsKFAzjqYxda23YRciiU/mrunUU5yBTgyJ3VM24LhBDNZaQiGt7H+L9l5FaUfyLTK
         a1SW5hpwO4Y03/6Qv5QtKzg1syo6YgQF5TBIkXNaAJNFAXFGxbqj6UXfaRb2rMDiMWxv
         DseSWxmCdHPUyEMWuB3XmQMM4jeXPDEuyRfDicb+G+IxPeYCW2ZIXHBDpn7CaGs5KY3F
         bobY5+zYc84aUpTNVkQu585vN/ujKM4KwAi7UIqfLXlE6wKxQocrBIwpu0EWxa8Loq7d
         tMVhh+CK9rkcHQwZKXm81wiAMDIyjjiKhPaD2grJ3IvHN7dOU63RDnUgCZx5c/mINXMn
         dgrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694031101; x=1694635901;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=peODubx65uqMrjkWQ//78jxQ/SfLOSDFlEmlVraSU1s=;
        b=G87RTCl7h2qkQoVDegGNmSB6U9nFUnr2LO1pm8HDEieywQpGvHM2ulFm3JwC0bNH/b
         PuX3uFMD3QZfUieRuJBH0RocuzojvLZazGraGcL+1BqQE9h0c95P3Qe21G+os4maY09G
         03Ens7CM+deK5wTSw/4KcwuF14geANkJk/2Kyk7sVnZfuoSEYRsu/CMfPp/JEZP3NPKf
         4UxgeBA3YqnWaXlv1jKRSYIsdOTAfDc1i05oqwncvO1TIAcDzv3yCoiEdlAaDmLgXuDh
         iQFP1bb/CFgeztMR4FYeXl7ZK7TfoBJlHvSrWTMteO/wi5i+43/1tCrRQXAjjllkKwIU
         1KQg==
X-Gm-Message-State: AOJu0YzkiuCQhPAFq5Ko8qaj3Dn6H4VyM0+NAB/rY4Gh4VkfD9ixPovI
        C9f6cvzrTv+I3aYRGkb9AzvHIOfMMb4=
X-Google-Smtp-Source: AGHT+IHmjE1nbBVkGoMBFKQzpb3eElrhE6wjuj15n/74+GzAvNY7DEWoz7hxMLzs2bUnBR0Ne6hV8GK53i4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8b0a:0:b0:d78:1cbd:fe37 with SMTP id
 i10-20020a258b0a000000b00d781cbdfe37mr399580ybl.2.1694031101774; Wed, 06 Sep
 2023 13:11:41 -0700 (PDT)
Date:   Wed, 6 Sep 2023 13:11:40 -0700
In-Reply-To: <68a44c6d-21c9-30c2-b0cf-66f02f9d2f4e@amd.com>
Mime-Version: 1.0
References: <20230906151449.18312-1-pgonda@google.com> <68a44c6d-21c9-30c2-b0cf-66f02f9d2f4e@amd.com>
Message-ID: <ZPjc/PoBLPNNLukt@google.com>
Subject: Re: [PATCH V2] KVM: SEV: Update SEV-ES shutdown intercepts with more metadata
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 06, 2023, Tom Lendacky wrote:
> On 9/6/23 10:14, Peter Gonda wrote:
> > Currently if an SEV-ES VM shuts down userspace sees KVM_RUN struct with
> 
> s/down userspace/down, userspace/

Heh, yeah, I read that the same way you did.

> > only the INVALID_ARGUMENT. This is a very limited amount of information
> > to debug the situation. Instead KVM can return a
> > KVM_EXIT_SHUTDOWN to alert userspace the VM is shutting down and
> > is not usable any further.
> > 
> > Signed-off-by: Peter Gonda <pgonda@google.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: x86@kernel.org
> > Cc: kvm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > 
> > ---
> >   arch/x86/kvm/svm/svm.c | 8 +++++---
> >   1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 956726d867aa..cecf6a528c9b 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -2131,12 +2131,14 @@ static int shutdown_interception(struct kvm_vcpu *vcpu)
> >   	 * The VM save area has already been encrypted so it
> >   	 * cannot be reinitialized - just terminate.
> >   	 */
> > -	if (sev_es_guest(vcpu->kvm))
> > -		return -EINVAL;
> > +	if (sev_es_guest(vcpu->kvm)) {
> > +		kvm_run->exit_reason = KVM_EXIT_SHUTDOWN;
> > +		return 0;
> > +	}
> 
> Just a nit... feel free to ignore, but, since KVM_EXIT_SHUTDOWN is also set
> at the end of the function and I don't think kvm_vcpu_reset() clears the
> value from kvm_run, you could just set kvm_run->exit_reason on entry and
> just return 0 early for an SEV-ES guest.

kvm_run is writable by userspace though, so KVM can't rely on kvm_run->exit_reason
for correctness.

And IIUC, the VMSA is also toast, i.e. doing anything other than marking the VM
dead is futile, no?

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6FB0794479
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 22:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244261AbjIFU0X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 16:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbjIFU0W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 16:26:22 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E261D172E
        for <kvm@vger.kernel.org>; Wed,  6 Sep 2023 13:26:18 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-58e49935630so3401537b3.0
        for <kvm@vger.kernel.org>; Wed, 06 Sep 2023 13:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694031978; x=1694636778; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WlTf+NVKt7dV5VShanUKxJ6eK2OVsTdMO/HD91r/E2o=;
        b=zp9gTyizYH3AxdXzjJ6jZwmeTmbQk4CoL1PnzKeBgJARQuwE9tsHnWmIEgcy2694P4
         qIA56/pdgDcKFn527/vgJB6VhssbOVrUuaO5hmoVBqYkbXEJD24mj9Z0Mm0Er4dCq4VI
         iLVHBw6U90yzseXFjzSJpuMgLnkKmumxNqe03bobrXT9yfAEVjIOKwyIb3wCOD1LiBBs
         h0MiiKOhsruklkzC/fJ9kiLZFGvf+9c/fMClwZRJck1fiyzmMmJp5DfwGO4sXpVxdvpL
         Bee6RQIHa3KSqigx7CkEG1GZlY4AUWZnR/tay8E4mtD8pOiC+868e80UgTAO3GGlhwFv
         YXVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694031978; x=1694636778;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WlTf+NVKt7dV5VShanUKxJ6eK2OVsTdMO/HD91r/E2o=;
        b=GeMahqLRjNuILQ11UevoHF36SkWwC9IJZeI4/D6Gq9B6lHhKZpKYxTXc3CXJxYo8ci
         MK6FkFUnoxEx/+S5AJ9wYcJJxcZnBAapd4NLneZFJfOsCPoZ+GT2aaNx0ou+nvkmVCZJ
         gqqQeKpMA9+LFKxoiBhaokviVRPeqllN0A1V9tExYCW/oQ46r/deEiV16VNb307cHNha
         O7QFUMK9AY0HdZa8Js/N5swV9FRJXPGfDacNtb4q8c7ERuo8wIpkCZIHzDW9X7icTGFu
         YAawnXwX4I1+erLiA4MK7JTr1BqjWjEiiZIx0EgbEJhrw/b0UiAaOJ2FzGX5yaAyS3cR
         Gq1g==
X-Gm-Message-State: AOJu0Yyqg9gtRYi1Ghl205EI8iE+HK8+FYpwFoYP/SgbXCYvyIUt6WsB
        8n0FlpqSfYtQLCkxQvLI9hSy1zWsaU8=
X-Google-Smtp-Source: AGHT+IGjJh1xM7/pZbUwcHONh3f/BbLtWMSpwQxYaUEI84cuhmjTSEPmq7OKhQen/xH81w4xWIhSD3h1+I8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2990:b0:59b:3adb:f2e with SMTP id
 eh16-20020a05690c299000b0059b3adb0f2emr19163ywb.2.1694031978220; Wed, 06 Sep
 2023 13:26:18 -0700 (PDT)
Date:   Wed, 6 Sep 2023 13:26:16 -0700
In-Reply-To: <249694b0-2afd-f653-a443-124e510f4a4c@amd.com>
Mime-Version: 1.0
References: <20230906151449.18312-1-pgonda@google.com> <68a44c6d-21c9-30c2-b0cf-66f02f9d2f4e@amd.com>
 <ZPjc/PoBLPNNLukt@google.com> <249694b0-2afd-f653-a443-124e510f4a4c@amd.com>
Message-ID: <ZPjgaKoF9jVS/ATx@google.com>
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 06, 2023, Tom Lendacky wrote:
> On 9/6/23 15:11, Sean Christopherson wrote:
> > On Wed, Sep 06, 2023, Tom Lendacky wrote:
> > > On 9/6/23 10:14, Peter Gonda wrote:
> > > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > > index 956726d867aa..cecf6a528c9b 100644
> > > > --- a/arch/x86/kvm/svm/svm.c
> > > > +++ b/arch/x86/kvm/svm/svm.c
> > > > @@ -2131,12 +2131,14 @@ static int shutdown_interception(struct kvm_vcpu *vcpu)
> > > >    	 * The VM save area has already been encrypted so it
> > > >    	 * cannot be reinitialized - just terminate.
> > > >    	 */
> > > > -	if (sev_es_guest(vcpu->kvm))
> > > > -		return -EINVAL;
> > > > +	if (sev_es_guest(vcpu->kvm)) {
> > > > +		kvm_run->exit_reason = KVM_EXIT_SHUTDOWN;
> > > > +		return 0;
> > > > +	}
> > > 
> > > Just a nit... feel free to ignore, but, since KVM_EXIT_SHUTDOWN is also set
> > > at the end of the function and I don't think kvm_vcpu_reset() clears the
> > > value from kvm_run, you could just set kvm_run->exit_reason on entry and
> > > just return 0 early for an SEV-ES guest.
> > 
> > kvm_run is writable by userspace though, so KVM can't rely on kvm_run->exit_reason
> > for correctness.
> > 
> > And IIUC, the VMSA is also toast, i.e. doing anything other than marking the VM
> > dead is futile, no?
> 
> I was just saying that "kvm_run->exit_reason = KVM_EXIT_SHUTDOWN;" is in the
> shutdown_interception() function twice now (at both exit points of the
> function) and can probably just be moved to the top of the function and be
> common for both exit points, now, right?
> 
> I'm not saying to get rid of it, just set it sooner.

Ah, I thought you were saying bail early from kvm_vcpu_reset().  I agree that not
having completely split logic would be ideal.  What about this?

	/*
	 * VMCB is undefined after a SHUTDOWN intercept.  INIT the vCPU to put
	 * the VMCB in a known good state.  Unfortuately, KVM doesn't have
	 * KVM_MP_STATE_SHUTDOWN and can't add it without potentially breaking
	 * userspace.  At a platform view, INIT is acceptable behavior as
	 * there exist bare metal platforms that automatically INIT the CPU
	 * in response to shutdown.
	 *
	 * The VM save area for SEV-ES guests has already been encrypted so it
	 * cannot be reinitialized, i.e. synthesizing INIT is futile.
	 */
	if (!sev_es_guest(vcpu->kvm)) {
		clear_page(svm->vmcb);
		kvm_vcpu_reset(vcpu, true);
	}

	kvm_run->exit_reason = KVM_EXIT_SHUTDOWN;
	return 0;

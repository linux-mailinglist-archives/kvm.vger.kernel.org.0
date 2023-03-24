Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF26A6C7FE7
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 15:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjCXOcB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 10:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjCXOb7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 10:31:59 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7722514235
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 07:31:57 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-544539a729cso20268027b3.5
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 07:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679668316;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ty3wse5DF2ys6PoInqEvitG3vpIktmR+SFLR6U/ysFc=;
        b=KrvNTV+VwvF0CjZfmGIp7CnP7o0W8sxb7gs0MBkMD8ZiGSZMvSNH59YtWyLSriVv75
         cgruU2EOipD92w4i5Q7i03b7I3mEEtTpvjnmuHgVcjPgFvwTLCasowWJTqQSeHOE1A3K
         bpwILXupYeXhBvnmhVCFcCP+hOJpt6upQXRXeUXeqEjzPoLo2VkyGeevEW1H/dL4f7sh
         DrywnkrjwATzOEwagnfUwQOqQGEV9BqoDlFZrFUmrZFhPl7LAgczSqKx82m0ojVHCjTA
         pDK4T7uH4fGDa70GCuwVREq1Gz3Ogn6KtVU+i7hkE0cZVMtxKhsGw0yx+0wPAMaHQSnY
         vfFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679668316;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ty3wse5DF2ys6PoInqEvitG3vpIktmR+SFLR6U/ysFc=;
        b=260o9QuYoxGr/rDcyWy7xVukvvRlXRdK630/eVNI9djLGWoSBTGt9vqOF1/ZDlvTeO
         Ne8PB3co6S73nQPHlSIQupIPA2Kby5LD5n2H2KlRVlYyWik/JVU4H8V4jkW2zqBjou/W
         6zlgaceMqp8xsWC3FiFDAxKAAEPFgiQ0ZfRwax0LdHYDMbD6ogiES5l6CiyUQj1Qt58Q
         2/f2Zq6TeYbKaiUfCZS/RCzuWRK9Z0HydM5zBDsz5r7qdykQXbUcYbRzK5MIHtIw5OGA
         ELgF9wZBN3cCtXAveOiEGWxX1vO27vGLynBPa8QxpLMUBVEsCwOyd3GsFKOHj+dyFYfW
         fxvg==
X-Gm-Message-State: AAQBX9db7HuvZos1+SgaVg5mwU7FB8DOjRZuGzg+JbafVJqxI8hO5l+e
        AciAOl5K+wo6cWYb0PRQmOmmAb9V9VU=
X-Google-Smtp-Source: AKy350b/nn/R+ZOxHwMrUoKAuwzV0OlisAA4vPdStZV49dEt07t6trWRHl4OtpI5R6SD0zZLsf9Wf51b9fw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:bd4d:0:b0:541:359c:103a with SMTP id
 n13-20020a81bd4d000000b00541359c103amr1122172ywk.8.1679668316732; Fri, 24 Mar
 2023 07:31:56 -0700 (PDT)
Date:   Fri, 24 Mar 2023 07:31:55 -0700
In-Reply-To: <655ac0f7-223b-9440-1bcb-e93af8915bfa@oracle.com>
Mime-Version: 1.0
References: <20230316200219.42673-1-joao.m.martins@oracle.com>
 <20230316200219.42673-2-joao.m.martins@oracle.com> <ZBODjjANx6pkq5iq@google.com>
 <655ac0f7-223b-9440-1bcb-e93af8915bfa@oracle.com>
Message-ID: <ZB20W14VzVZZz+nI@google.com>
Subject: Re: [PATCH v2 1/2] iommu/amd: Don't block updates to GATag if guest
 mode is on
From:   Sean Christopherson <seanjc@google.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vasant Hegde <vasant.hegde@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 16, 2023, Joao Martins wrote:
> On 16/03/2023 21:01, Sean Christopherson wrote:
> > Is there any harm in giving deactivate the same treatement?  If the worst case
> > scenario is a few wasted cycles, having symmetric flows and eliminating benign
> > bugs seems like a worthwhile tradeoff (assuming this is indeed a relatively slow
> > path like I think it is).
> > 
> 
> I wanna say there's no harm, but initially I had such a patch, and on testing it
> broke the classic interrupt remapping case but I didn't investigate further --
> my suspicion is that the only case that should care is the updates (not the
> actual deactivation of guest-mode).

Ugh, I bet this is due to KVM invoking irq_set_vcpu_affinity() with garbage when
AVIC is enabled, but KVM can't use a posted interrupt due to the how the IRQ is
configured.  I vaguely recall a bug report about uninitialized data in "pi" being
consumed, but I can't find it at the moment.

	if (!get_pi_vcpu_info(kvm, e, &vcpu_info, &svm) && set &&
		    kvm_vcpu_apicv_active(&svm->vcpu)) {

		...

	} else {
			/* Use legacy mode in IRTE */
			struct amd_iommu_pi_data pi;

			/**
			 * Here, pi is used to:
			 * - Tell IOMMU to use legacy mode for this interrupt.
			 * - Retrieve ga_tag of prior interrupt remapping data.
			 */
			pi.prev_ga_tag = 0;
			pi.is_guest_mode = false;
			ret = irq_set_vcpu_affinity(host_irq, &pi);
	}


> > Any chance you (or anyone) would want to create a follow-up series to rename and/or
> > rework these flows to make it more obvious that the helpers handle updates as well
> > as transitions between "guest mode" and "host mode"?  E.g. I can see KVM getting
> > clever and skipping the "activation" when KVM knows AVIC is already active (though
> > I can't tell for certain whether or not that would actually be problematic).
> > 
> 
> To be honest, I think the function naming is correct.

After looking more closely at the KVM code, I agree.  I was thinking KVM invoked
the (de)activate helpers somewhat spuriously, but that's not actually the case,
KVM just has a few less-than-perfect names due to conflicting requirements.

Thanks!

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D39547B72F5
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 23:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241089AbjJCVAT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 17:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbjJCVAS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 17:00:18 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F23AAD
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 14:00:09 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d85fc6261ffso1709173276.1
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 14:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696366808; x=1696971608; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mE7WbSRGG3IBXYNyxwgRAed3lO7KyWMV50CsUdXZcYc=;
        b=TqutrsOmn9atFkU2oGu/uezbxygdBlh0cVfTPBgn7AnUDjklWdqjlycZiIZN0mRgH9
         Vb6LvB/nzvC2vYLCYAmbOfdWvT2vUSQkOWbdqykKWC29xyVQg4uLG/e1dxhRQmniZy5t
         ChI0pD7cM1iNITN5nyj3GdDrpkVANEnrpr6MiEvaYw3eyUN8Wq77RaeITIa725AHPjBB
         tKVgZMsvK6afuDJTJOGw9PKQwCKmUfacfjofLKW/4a+XG7DW5neDya6iTiisPoF0/RQk
         sK+Gww8pi+LfWt1uXkP4eeLRhSyJhsB/qmYq5B+j9gEOeMFUvbcMKRo0+vGKRPDHh3cV
         Yg2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696366808; x=1696971608;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mE7WbSRGG3IBXYNyxwgRAed3lO7KyWMV50CsUdXZcYc=;
        b=Aiszb5pTKwI2vVuNp08coACD8Ps4Ml/gMZf9H/SyEwZpMNWiddWhAOtD2oj6rFTAv5
         /KxKleOFVf63aZfEWTn5viv03TOGbX27qNCimTfZBmFVQ1RBOhma62iFT9OMQjLIePAZ
         m+d88uYUFlLQ/0rN3ViW7hlwQ4V7imQLtit3q2sXrsfw4liBfBRyedGLkZ+I5BvW7kUp
         JEEIm5WfWqkTkNAl/Ept2ZgGpCCdU3zIjIp+sJMkBdDuy8B0i/9kA5T+q4hN9RiyFzAE
         b/jB7X//uJa3G6OTDw/fgTPsbuyyTEO/kFyhLTFhmoOiucXOEGYarKfOGwvJTNTdK0jC
         1qRw==
X-Gm-Message-State: AOJu0Yx9S4WjDbitIUTOfCrbE5C1a/NpgG+si6tP7UE9bHxxM1d9pB6o
        gugX+ibGmsxhrJ4Lonn9/bPiOyIL34g=
X-Google-Smtp-Source: AGHT+IGbJxXZ4vvK5lEPewhlyhfI4WFnbA1LXX3nxv5zgeQeix4PkOW5F84jEuW4er/V5aRynVB7EGLG54c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:482:0:b0:d81:b2db:8c2e with SMTP id
 124-20020a250482000000b00d81b2db8c2emr5346ybe.6.1696366808381; Tue, 03 Oct
 2023 14:00:08 -0700 (PDT)
Date:   Tue, 3 Oct 2023 14:00:06 -0700
In-Reply-To: <1326f47a-45c0-963d-d50f-a9774d932744@oracle.com>
Mime-Version: 1.0
References: <36f3dbb1-61d7-e90a-02cf-9f151a1a3d35@oracle.com>
 <ZRWnVDMKNezAzr2m@google.com> <a461bf3f-c17e-9c3f-56aa-726225e8391d@oracle.com>
 <884aa233ef46d5209b2d1c92ce992f50a76bd656.camel@infradead.org>
 <ZRrxtagy7vJO5tgU@google.com> <52a3cea2084482fc67e35a0bf37453f84dcd6297.camel@infradead.org>
 <ZRtl94_rIif3GRpu@google.com> <afa70110-72dc-cf7d-880f-345a6e8a3995@oracle.com>
 <ZRtzEgnRVZ7FpG3R@google.com> <1326f47a-45c0-963d-d50f-a9774d932744@oracle.com>
Message-ID: <ZRyA1jSb_Ok9l0po@google.com>
Subject: Re: [PATCH RFC 1/1] KVM: x86: add param to update master clock periodically
From:   Sean Christopherson <seanjc@google.com>
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Joe Jin <joe.jin@oracle.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 02, 2023, Dongli Zhang wrote:
> Hi Sean,
> 
> On 10/2/23 18:49, Sean Christopherson wrote:
> > On Mon, Oct 02, 2023, Dongli Zhang wrote:
> >>> @@ -12185,6 +12203,10 @@ int kvm_arch_hardware_enable(void)
> >>>  	if (ret != 0)
> >>>  		return ret;
> >>>  
> >>> +	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
> >>> +		kvm_get_time_scale(NSEC_PER_SEC, tsc_khz * 1000LL,
> >>> +				   &host_tsc_shift, &host_tsc_to_system_mul);
> >>
> >> I agree that to use the kvmclock to calculate the ns elapsed when updating the
> >> master clock.
> >>
> >> Would you take the tsc scaling into consideration?
> >>
> >> While the host_tsc_shift and host_tsc_to_system_mul are pre-computed, how about
> >> the VM using different TSC frequency?
> > 
> > Heh, I'm pretty sure that's completely broken today.  I don't see anything in KVM
> > that takes hardware TSC scaling into account.
> > 
> > This code:
> > 
> > 	if (unlikely(vcpu->hw_tsc_khz != tgt_tsc_khz)) {
> > 		kvm_get_time_scale(NSEC_PER_SEC, tgt_tsc_khz * 1000LL,
> > 				   &vcpu->hv_clock.tsc_shift,
> > 				   &vcpu->hv_clock.tsc_to_system_mul);
> > 		vcpu->hw_tsc_khz = tgt_tsc_khz;
> > 		kvm_xen_update_tsc_info(v);
> > 	}
> > 
> > is recomputing the multipler+shift for the current *physical* CPU, it's not
> > related to the guest's TSC in any way.
> 
> The below is the code.
> 
> line 3175: query freq for current *physical* CPU.
> 
> line 3211: scale the freq if scaling is involved.
> 
> line 3215: compute the view for guest based on new 'tgt_tsc_khz' after scaling.
> 
> 3146 static int kvm_guest_time_update(struct kvm_vcpu *v)
> 3147 {
> 3148         unsigned long flags, tgt_tsc_khz;
> 3149         unsigned seq;
> ... ...
> 3173         /* Keep irq disabled to prevent changes to the clock */
> 3174         local_irq_save(flags);
> 3175         tgt_tsc_khz = get_cpu_tsc_khz();
> ... ...
> 3210         if (kvm_caps.has_tsc_control)
> 3211                 tgt_tsc_khz = kvm_scale_tsc(tgt_tsc_khz,
> 3212                                             v->arch.l1_tsc_scaling_ratio);
> 3213
> 3214         if (unlikely(vcpu->hw_tsc_khz != tgt_tsc_khz)) {
> 3215                 kvm_get_time_scale(NSEC_PER_SEC, tgt_tsc_khz * 1000LL,
> 3216                                    &vcpu->hv_clock.tsc_shift,
> 3217                                    &vcpu->hv_clock.tsc_to_system_mul);
> 3218                 vcpu->hw_tsc_khz = tgt_tsc_khz;
> 3219                 kvm_xen_update_tsc_info(v);
> 3220         }
> 
> 
> Would you please let me know if the above understanding is incorrect?

Ah, yeah, you're correct.  I missed the call to kvm_scale_tsc() at 3211.

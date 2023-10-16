Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB9797CB6AE
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 00:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbjJPWsc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 18:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232345AbjJPWsa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 18:48:30 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42332F7
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 15:48:23 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-6be1065cc81so1583693b3a.3
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 15:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697496502; x=1698101302; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=84aTo4Tf+aZUy0HcQ/Zqt9HQ4tRBchQvuwbCa4iyIjE=;
        b=s/nWiyMENdy1hEDXEZO9QIdBcRB83YoiDaOJjVCPukUwiRsZ93UEmU/M18N246xNUC
         TxzzQQQ+5f50/G8G1sjra8hC217UR+/ZugynQQtAmwx5bzkdRmWRyiLL8gclO52W9ORA
         x+Y4jDXKpvqhJRSRYuq3GS8x39BxBefpwHRQMtfeROUX+zQoUAEanTiO8d3zvgUfoztQ
         rFUnOuG6fxdcM4dyhv9WJpkrvCG+XqGHBvXJloxnKNeO6/a7XHpG9HSVPRDepQubgaFw
         Q2GNJYD9UviNF7k82Lmc2lHlksAMoTw+W8dcTqLuI+jfYFRgcKME0RWtzK4GpvMmcFn+
         oV5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697496502; x=1698101302;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=84aTo4Tf+aZUy0HcQ/Zqt9HQ4tRBchQvuwbCa4iyIjE=;
        b=Yl/DNkelpA0YG8P4HLk7k3c5KwSZ0yu77DIKCYFJBYtrAsAISPwU4WbmAKqiPeTUZU
         FUudf5JOLQg7rt9dCvDwpixj7RUyHktOXWZlN0SNHiXbJHwqeg1BT2uxv6wkt9WQGUYV
         TbrUHVwbnOPQcbvU3VueJwLRJoET1a3wSJW07B3skNZGGTZKWbjAZP9cKBZSgDoILYpC
         SMKYVDwo/5cR4ohiMytVY/h0joDIfw7iPQoGH3XExwcVOYN3T3sXe7Ti+BNrDTr2+Qme
         vCrOflBGQiS0RUx5JgKPVIqNsOb8F6K4pkNcq+C9Y/kl5pAyFVZrLXSz+3/6UEwbngVb
         /V8Q==
X-Gm-Message-State: AOJu0YxGblpSv0gTmqut60y6TGU7VkPNQ2VtCiNTW9IkDh5kCuNGEjL/
        TfvL2N+3smR3qzqnCIa683NtjdHIpPY=
X-Google-Smtp-Source: AGHT+IF0TmBQ7Ykmhy2UUdvxRB8M72Fy7i6DMqyApsOvlfciXQg+hCzL0X1i1/bPqE+coJRrJ66yG2/lo0U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:d5b:b0:68e:24fe:d9a with SMTP id
 n27-20020a056a000d5b00b0068e24fe0d9amr13672pfv.2.1697496502682; Mon, 16 Oct
 2023 15:48:22 -0700 (PDT)
Date:   Mon, 16 Oct 2023 15:48:21 -0700
In-Reply-To: <b3721f33-d5b0-79db-8500-d6b93dded0c1@oracle.com>
Mime-Version: 1.0
References: <ZSXqZOgLYkwLRWLO@google.com> <8f3493ca4c0e726d5c3876bb7dd2cfc432d9deaa.camel@infradead.org>
 <ZSmHcECyt5PdZyIZ@google.com> <cf2b22fc-78f5-dfb9-f0e6-5c4059a970a2@oracle.com>
 <ZSnSNVankCAlHIhI@google.com> <BD4C4E71-C743-4B79-93CA-0F3AC5423412@infradead.org>
 <993cc7f9-a134-8086-3410-b915fe5db7a5@oracle.com> <03afed7eb3c1e5f4b2b8ecfd8616ae5c6f1819e9.camel@infradead.org>
 <ZS2Fq5dr2CeZaBok@google.com> <b3721f33-d5b0-79db-8500-d6b93dded0c1@oracle.com>
Message-ID: <ZS29teniU3xer0Xu@google.com>
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 16, 2023, Dongli Zhang wrote:
> Hi Sean,
> 
> On 10/16/23 11:49, Sean Christopherson wrote:
> > Compile tested only, but the below should fix the vCPU hotplug case.  Then
> > someone (not me) just needs to figure out why kvm_xen_shared_info_init() forces
> > a masterclock update.
> > 
> > I still think we should clean up the periodic sync code, but I don't think we
> > need to periodically sync the masterclock.
> 
> This looks good to me. The core idea is to not update master clock for the
> synchronized cases.
> 
> 
> How about the negative value case? I see in the linux code it is still there?

See below.  

> (It is out of the scope of my expectation as I do not need to run vCPUs in
> different tsc freq as host)
> 
> Thank you very much!
> 
> Dongli Zhang
> 
> > 
> > ---
> >  arch/x86/kvm/x86.c | 29 ++++++++++++++++-------------
> >  1 file changed, 16 insertions(+), 13 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index c54e1133e0d3..f0a607b6fc31 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -2510,26 +2510,29 @@ static inline int gtod_is_based_on_tsc(int mode)
> >  }
> >  #endif
> >  
> > -static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu)
> > +static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu, bool new_generation)
> >  {
> >  #ifdef CONFIG_X86_64
> > -	bool vcpus_matched;
> >  	struct kvm_arch *ka = &vcpu->kvm->arch;
> >  	struct pvclock_gtod_data *gtod = &pvclock_gtod_data;
> >  
> > -	vcpus_matched = (ka->nr_vcpus_matched_tsc + 1 ==
> > -			 atomic_read(&vcpu->kvm->online_vcpus));
> > +	/*
> > +	 * To use the masterclock, the host clocksource must be based on TSC
> > +	 * and all vCPUs must have matching TSCs.  Note, the count for matching
> > +	 * vCPUs doesn't include the reference vCPU, hence "+1".
> > +	 */
> > +	bool use_master_clock = (ka->nr_vcpus_matched_tsc + 1 ==
> > +				 atomic_read(&vcpu->kvm->online_vcpus)) &&
> > +				gtod_is_based_on_tsc(gtod->clock.vclock_mode);
> >  
> >  	/*
> > -	 * Once the masterclock is enabled, always perform request in
> > -	 * order to update it.
> > -	 *
> > -	 * In order to enable masterclock, the host clocksource must be TSC
> > -	 * and the vcpus need to have matched TSCs.  When that happens,
> > -	 * perform request to enable masterclock.
> > +	 * Request a masterclock update if the masterclock needs to be toggled
> > +	 * on/off, or when starting a new generation and the masterclock is
> > +	 * enabled (compute_guest_tsc() requires the masterclock snaphot to be
> > +	 * taken _after_ the new generation is created).
> >  	 */
> > -	if (ka->use_master_clock ||
> > -	    (gtod_is_based_on_tsc(gtod->clock.vclock_mode) && vcpus_matched))
> > +	if ((ka->use_master_clock && new_generation) ||
> > +	    (ka->use_master_clock != use_master_clock))
> >  		kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
> >  
> >  	trace_kvm_track_tsc(vcpu->vcpu_id, ka->nr_vcpus_matched_tsc,
> > @@ -2706,7 +2709,7 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
> >  	vcpu->arch.this_tsc_nsec = kvm->arch.cur_tsc_nsec;
> >  	vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
> >  
> > -	kvm_track_tsc_matching(vcpu);
> > +	kvm_track_tsc_matching(vcpu, !matched);

If my analysis of how the negative timestamp occurred is correct, the problematic
scenario was if cur_tsc_nsec/cur_tsc_write were updated without a masterclock update.
Passing !matched for @new_generation means that KVM will force a masterclock update
if cur_tsc_nsec/cur_tsc_write are changed, i.e. prevent the negative timestamp bug.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873A237AFF4
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 22:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbhEKULR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 16:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhEKULQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 16:11:16 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8429C061574
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 13:10:09 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id h7so11385680plt.1
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 13:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9hsJp/8M+c794Pqj/BGqU0TDUiLA1/EXUU62NU+MuI8=;
        b=QWxVvsHJmxi2i0/v0yvXGA/rYmebcRITSfU78PEVWzxzZQj5NH4W2zx4Ow2aldvIOZ
         RF+Pp01gjiTBsL4GN8iYTGXpT6Tk8/q5bZuVXfvEMLhACIa26lseUWufR0uXgI5csmYZ
         qPaYTvBEgra7SDs/9ygersTwFvS7PngkczxI2jgG8p5lKZFWvqGWB5EBUmZ7KdIZywut
         7YKlRIiPop3urGUH1d28rki8FOxWFo1xJl/93w/+LUlRj7ZnFAX/x6i1e8t8bFnPZg9V
         sinN/l4I+RBvPQvUwtxvn/l4MRno77sXlDk/dibPowkeifpBrMli9ad0UZzE7+2l8L5s
         PjTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9hsJp/8M+c794Pqj/BGqU0TDUiLA1/EXUU62NU+MuI8=;
        b=Tfb+cgoV2YEcYBZ3NT0q4eMC/NaT5SkGSwMVtpEtpW11z6XhyY7pbj9B3WV6/w4DPd
         MWX2q515uCeUjBUWfSfvysBreGbDijOrxxUrXcu45uEMxWg6SFkEecQHzvP4rDE8EgqY
         mi0cR/VVd+Lzz7VmPs84j7WDT5tNZ0UbNl8pDKlixZKhDCDXkEOyM4Mj0ZA4evpskQWj
         snHkSxPIQRTVxcCCkMwjmXxTNjY8QFuNdjqcD16O3ObNi3dEp8xpAjpZ3//kc65sJTJq
         LX7N0i8u9+wlcK6m7FAGSnCRj5f/ZV4Pfgfa41X92sDoCNL0E8j/a2WRuFDH7avoopts
         dqTw==
X-Gm-Message-State: AOAM532vL4//2XHrhBwAjkMYNWZZpzj1UTkGPkr46rK3OfoLHz9MTSAX
        zG8wr3FjG9cnpZistxuZKtVPGg==
X-Google-Smtp-Source: ABdhPJwy09jfy7yLVMouNyu5hwQFqzdeaXW6xbEDwmbX67gFS2cIgwJGT3bwVeejCDmtI2vaIRbYFA==
X-Received: by 2002:a17:902:70c5:b029:ec:9a57:9cc8 with SMTP id l5-20020a17090270c5b02900ec9a579cc8mr31856628plt.73.1620763809212;
        Tue, 11 May 2021 13:10:09 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id s14sm1396567pjp.16.2021.05.11.13.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 13:10:08 -0700 (PDT)
Date:   Tue, 11 May 2021 20:10:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 08/15] KVM: VMX: Configure list of user return MSRs at
 module init
Message-ID: <YJrkndzXzUOXsZYJ@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
 <20210504171734.1434054-9-seanjc@google.com>
 <db161b4dd7286870db5adb9324e4941f0dc3f098.camel@redhat.com>
 <YJlNsvKoFIKI2V/V@google.com>
 <9cf65a1d7b96c69077779d7a11777004d0bce6c9.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cf65a1d7b96c69077779d7a11777004d0bce6c9.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021, Maxim Levitsky wrote:
> On Mon, 2021-05-10 at 15:13 +0000, Sean Christopherson wrote:
> > On Mon, May 10, 2021, Maxim Levitsky wrote:
> > > On Tue, 2021-05-04 at 10:17 -0700, Sean Christopherson wrote:
> > > > @@ -6929,18 +6942,10 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
> > > >  			goto free_vpid;
> > > >  	}
> > > >  
> > > > -	BUILD_BUG_ON(ARRAY_SIZE(vmx_uret_msrs_list) != MAX_NR_USER_RETURN_MSRS);
> > > > +	for (i = 0; i < vmx_nr_uret_msrs; ++i) {
> > > > +		vmx->guest_uret_msrs[i].data = 0;
> > > >  
> > > > -	for (i = 0; i < ARRAY_SIZE(vmx_uret_msrs_list); ++i) {
> > > > -		u32 index = vmx_uret_msrs_list[i];
> > > > -		int j = vmx->nr_uret_msrs;
> > > > -
> > > > -		if (kvm_probe_user_return_msr(index))
> > > > -			continue;
> > > > -
> > > > -		vmx->guest_uret_msrs[j].slot = i;
> > > I don't see anything initalizing the .slot after this patch.
> > > Now this code is removed later which masks this bug, 
> > > but for the bisect sake, I think that this patch 
> > > should still be fixed.
> > 
> > Egad, indeed it's broken.  I'll retest the whole series to verify the other
> > patches will bisect cleanly.
> > 
> > Nice catch!
> > 
> Thanks!

Unfortunately this made it's way to Linus before I could fix my goof.  Fingers
crossed no one is unfortunate enough to land on this while bisecting...

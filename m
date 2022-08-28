Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62DC25A3F45
	for <lists+kvm@lfdr.de>; Sun, 28 Aug 2022 21:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiH1TWG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Aug 2022 15:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiH1TWE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Aug 2022 15:22:04 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CDFE248EB
        for <kvm@vger.kernel.org>; Sun, 28 Aug 2022 12:22:03 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id q3so2846765pjg.3
        for <kvm@vger.kernel.org>; Sun, 28 Aug 2022 12:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=+ic0Yt7oxPZ1wi8BAOg3RUokNIfn9p5PWxe7nG/Tsdg=;
        b=ICJdR/EEyYmhI2vBHZXddX9WPnY1sFjBI3l93dQ+g1qNgmHLVXHbzpsxWr+VowXKd8
         lo44NQEYmS4JDuNw5FzsEtsNcX3mK6DfWH5BGVw/DwdvWFIVWNoLDnTLlTc1TviJcBWO
         0pm+6lPp+TB6K0sFGGzm45rG129Lkh3QZynibszzp8r4+4ktX83dyx/8UCJIFI4h2eFP
         YVSvm7wJnO0+HO8yVMO96vZUWYenqK0PHY7fItqnk08oYCWqFxHAH8yuGH/010tPcwyb
         XhKzWc44EQg8F4vI+5mHVdRO2QuyOoCFkZ+mUEk5Jl76UHhFy1TjLMsGO1IGXgNyZA1G
         K9tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=+ic0Yt7oxPZ1wi8BAOg3RUokNIfn9p5PWxe7nG/Tsdg=;
        b=31DOpn788DKAHmHiSv9ZrL5Uv1gHChbbfGPqo0+4aChGad49I7+ri46pSbCUvMRhE7
         fvT3smD512NhHdyJO2bGwKjYLyrAN+VILQD3stydYO3ob269w1vVn6alDpibcVtCx2qy
         8IIM2OqfX4yvAky5mX41zjkFci7P1YoitrpdlNFM2POTJRSpgqWdUAWLvd+baWH0KFBH
         C65AQkbYLuicEau6cNhjabIMiVjS+M/RQwjomgqyLxmgKT8C60OB7QhHv+jmVw9x1DlC
         wZgM6KEBRaVNUhfY5VGO/ZkQ2+lNN0AZeUbHWz8iWSptdcnrnuQe5LEPq7txRoE+a2bG
         PFkg==
X-Gm-Message-State: ACgBeo2+dzdnXgM9iB/BlmObCzYR+TefjkuNe/Gaja3q95Qu6zlPtUj/
        nHwa22nehF8CUcjKRuXga8BRFA==
X-Google-Smtp-Source: AA6agR7Y5486TlORoeIP+W8vDIEpmWVpd9xJAh/qqqMNU93qC6TcjoKgoU7gi7DQYFjQo1AdywOobw==
X-Received: by 2002:a17:902:f606:b0:172:6522:4bfc with SMTP id n6-20020a170902f60600b0017265224bfcmr13046789plg.133.1661714522403;
        Sun, 28 Aug 2022 12:22:02 -0700 (PDT)
Received: from google.com (33.5.83.34.bc.googleusercontent.com. [34.83.5.33])
        by smtp.gmail.com with ESMTPSA id f12-20020a170902ce8c00b001749acb167csm1869110plg.27.2022.08.28.12.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Aug 2022 12:22:01 -0700 (PDT)
Date:   Sun, 28 Aug 2022 19:21:58 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>
Subject: Re: [PATCH 3/5] selftests: KVM: Introduce vcpu_run_interruptable()
Message-ID: <YwvAVtfrF9xLvpM8@google.com>
References: <20220802230718.1891356-1-mizhang@google.com>
 <20220802230718.1891356-4-mizhang@google.com>
 <Ywa/BaYIdBi7N0iR@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ywa/BaYIdBi7N0iR@google.com>
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 25, 2022, Sean Christopherson wrote:
> On Tue, Aug 02, 2022, Mingwei Zhang wrote:
> > Introduce vcpu_run_interruptable() to allow selftests execute their own
> > code when a vcpu is kicked out of KVM_RUN on receiving a POSIX signal.
> 
> But that's what __vcpu_run() is for.  Clearing "immediate_exit" after KVM_RUN does
> not scream "interruptible" to me.
> 
> There's only one user after this series, just clear vcpu->run->immediate_exit
> manually in that test (a comment on _why_ it's cleared would be helpful).
> 
hmm. good point. __vcpu_run() I thought it was internal function private
to kvm_util.c, but now after your selftest refactoring, this is useable.
Will use __vcpu_run() instead.

> > +int vcpu_run_interruptable(struct kvm_vcpu *vcpu)
> > +{
> > +	int rc;
> > +
> > +	rc = __vcpu_run(vcpu);
> > +
> > +	vcpu->run->immediate_exit = 0;
> > +
> > +	return rc;
> > +}
> > +
> >  int _vcpu_run(struct kvm_vcpu *vcpu)
> >  {
> >  	int rc;
> > -- 
> > 2.37.1.455.g008518b4e5-goog
> > 

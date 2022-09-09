Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F795B4046
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 21:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbiIIT5Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 15:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiIIT5W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 15:57:22 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFB711B037
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 12:57:18 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id q3so2451353pjg.3
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 12:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Ix+zHu63uexJwygRlsHzmVxxGE2dqts71wJzPIEl4nM=;
        b=s3KGT+5stdiJg6ABS08VG/cuaUdFpcYRsjAtE0XUHTJ2k0VaiPA6MoGcOqQzAMBKQ5
         g76yDGGNwKZwynN1NZv3i4AiFb4LC4FBH+O88gO53Sw8OAobYXXdc1XWZcFuhHwXGHNT
         sPrdsFYYJSPQ7UOGjPhzy53NLHd9TAKri8US/CzLBtaqTMDr9/MPYcAkNWgSwmDZUQhA
         +qBDiBBDao6/P5LSqLNw/NEEJsb+6YZWBrBnPPSfVgNutZ7WZuz8iyuIepnoISqJ4lMC
         58DGydl2/5e/O/5o7/1Nho6fNza7IDKHbiob7N9vDffb3r3lHf/xHmM09asG4LVKlGv0
         MOPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Ix+zHu63uexJwygRlsHzmVxxGE2dqts71wJzPIEl4nM=;
        b=lG+AnKSpN/Sy+3OezdVukZWEX4wHUg01bAlX1W1giafvp4mCn3rLZhxR5K5iUXVORY
         E1My8hm+oDmRUQ1Lm3S8IO8iOg9HuASt+zbANJH/8n7KZ57QQvxXZjcZ0+bAtmcgP6Qw
         fPfy5pye74GopFa5a97Kw007IqWCsjbqHEKkrqTh3DbpswWMbMVh4NltqpB616sCPAX5
         acBZPvd/hosqJw2LR4l0/YrFMBISmfHgaRqJfukysegqes4jTJH6ynknL162/FOiz91b
         3kX9Tn1qTpIfLh5dYvk8Lnlf5ufbTA4lYHARbw2EW5Si4Iz7s6MAZnx2l4AVnNlL1NZn
         MRSg==
X-Gm-Message-State: ACgBeo38bYQ0TVoXpEbtMBtiai6M8te8Ah6S6A9+OljLGU0eCPbbucZl
        ul9U2LjG83fEPxPy4/ZT8dn+q4/pWUdSsQ==
X-Google-Smtp-Source: AA6agR5iABvqonzUsPwhF2ANtZ3gF54funoMeqvKsSUZtabxsI64h5+aJQDpiixm2ch7NwlmHH/+sA==
X-Received: by 2002:a17:90b:164f:b0:1f5:4ced:ed81 with SMTP id il15-20020a17090b164f00b001f54ceded81mr11101733pjb.122.1662753438095;
        Fri, 09 Sep 2022 12:57:18 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id b9-20020a170902d40900b0016bedcced2fsm890830ple.35.2022.09.09.12.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 12:57:17 -0700 (PDT)
Date:   Fri, 9 Sep 2022 12:57:13 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Reiji Watanabe <reijiw@google.com>, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Andrew Jones <andrew.jones@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/9] KVM: arm64: selftests: Add helpers to enable debug
 exceptions
Message-ID: <YxuamUS4F1SLz7Md@google.com>
References: <20220825050846.3418868-1-reijiw@google.com>
 <20220825050846.3418868-5-reijiw@google.com>
 <YwevrW4YrHQQOyew@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwevrW4YrHQQOyew@google.com>
X-Spam-Status: No, score=-15.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URI_DOTEDU,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 25, 2022 at 10:21:49AM -0700, Oliver Upton wrote:
> On Wed, Aug 24, 2022 at 10:08:41PM -0700, Reiji Watanabe wrote:
> > Add helpers to enable breakpoint and watchpoint exceptions.
> > 
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  .../selftests/kvm/aarch64/debug-exceptions.c  | 25 ++++++++++---------
> >  1 file changed, 13 insertions(+), 12 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > index 183ee16acb7d..713c7240b680 100644
> > --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > @@ -128,10 +128,20 @@ static void enable_os_lock(void)
> >  	GUEST_ASSERT(read_sysreg(oslsr_el1) & 2);
> >  }
> >  
> > +static void enable_debug_bwp_exception(void)
> 
> uber-nit: enable_monitor_debug_exceptions()
> 
> (more closely matches the definition of MDSCR_EL1.MDE)

oh, didn't know the MDE was for monitor debug exc. Anyway:

Reviewed-by: Ricardo Koller <ricarkol@google.com>

> 
> With that:
> 
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> 
> --
> Thanks,
> Oliver
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

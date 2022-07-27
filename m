Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30429581D9F
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 04:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239972AbiG0C3I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 22:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233554AbiG0C3H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 22:29:07 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E1B3C8DC
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 19:29:07 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id bh13so14753197pgb.4
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 19:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Xt1DjmVl4U5N3l5qtCeMuaUsGLKcjntACgSyyEM4lUc=;
        b=szuOoqkw2ViLkaHOXdhTRcJsv330QS30uwrWThy/QvFSt6dMjYUW1Kb8xRHB3hHPZS
         jdH5iGcFHQbPtves5M/Viy5DL2k8GvQcSKXD6fCWbuzjobMEzkAwoIR1WbkuIbvsADBD
         UFRiX1ADtYD2qF0FsUZDzDHekJrgTd6TxftAtoyHi6rTHfhHOMx3UpuRMsrzUBVTmUOk
         MKKsll0lqKC1Rb7z7XK/zSVY2xjpYzCkYbCa+QBeiEs5kd1+qEdwuf76+9vk5pdxHbhx
         XTsatamtSYbiDrgrdTKVYkGkmzlIqafnE3iXC9mxzBA7XRvtNYmKoi1YOo+0TyJ75I6B
         ABBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xt1DjmVl4U5N3l5qtCeMuaUsGLKcjntACgSyyEM4lUc=;
        b=d2fO3VJZUeqcL79jik388oCQVsBgOX+kJp2pwzcS1wGPtHitaRTObkulZxN/P9sBqJ
         olCvJmEGR5xzT/a63UTi0rZhBndRrQLfMfrnp7vzf1XH049LhIEtG7xAraK2+euqthMQ
         nH6/V0EjQPEfEI0AX1PaeQgmNe68uBGHZUkmReU9ydqhqEJU16s5q+rUEDD9hhaPrwTw
         HYUeEL3W3WZdkZTD6er7zErk43cPapZEUMeaJKhQaEVNVqKZ1M2CqwzlcYA6MXHOtlhH
         tLauF7wC+acpbQpKAOHgzXANgakYJqVg6VCVQbFlODVZQPZws9+ou3E/nW17Wk/TcBjv
         6lPw==
X-Gm-Message-State: AJIora/Hr7ixUPR7F2guhMBe8yOmX9N/l9UIiM8q09g4N3wmRdVco0Dv
        F6pUNQHxfez9W5iACRRhh+6Sfw==
X-Google-Smtp-Source: AGRyM1uX1ZM5ywBj8WbRVbH9b+XKaR87Z46iycdDdF6uQ9blbrk80iU3FnQ/eDW4XGZGRdcazp1H1A==
X-Received: by 2002:a65:580e:0:b0:41a:4c10:817f with SMTP id g14-20020a65580e000000b0041a4c10817fmr17433895pgr.93.1658888946533;
        Tue, 26 Jul 2022 19:29:06 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id j6-20020a170902da8600b0016d763967f8sm5617010plx.107.2022.07.26.19.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 19:29:05 -0700 (PDT)
Date:   Tue, 26 Jul 2022 19:29:01 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH 3/3] arm: pmu: Remove checks for !overflow
 in chained counters tests
Message-ID: <YuCi7ew10HfnSFmc@google.com>
References: <20220718154910.3923412-4-ricarkol@google.com>
 <87edyhz68i.wl-maz@kernel.org>
 <Yte/YXWYSikyQcqh@google.com>
 <875yjsyv67.wl-maz@kernel.org>
 <Ythw1UT1wFHbY/jN@google.com>
 <Ythy8XXN2rFytXdr@google.com>
 <871quezill.wl-maz@kernel.org>
 <YtscUOUGKra3LpsK@google.com>
 <20220723075955.ipoekdpzkqticadt@kamzik>
 <875yjmdf23.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875yjmdf23.wl-maz@kernel.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jul 24, 2022 at 10:40:20AM +0100, Marc Zyngier wrote:
> On Sat, 23 Jul 2022 08:59:55 +0100,
> Andrew Jones <andrew.jones@linux.dev> wrote:
> > 
> > On Fri, Jul 22, 2022 at 02:53:20PM -0700, Ricardo Koller wrote:
> > > 
> > > Which brings me to what to do with this test. Should it be fixed for
> > > bare-metal by ignoring the PMOVSSET check? or should it actually check
> > > for PMOVSSET=1 and fail on KVM until KVM gets fixed?
> > >
> > 
> > Hi Ricardo,
> > 
> > Please write the test per the spec. Failures pointed out in kvm-unit-tests
> > are great, when the tests are written correctly, since it means it's
> > doing its job :-)
> 
> Agreed. This is a bug, and bugs are to be fixed. The fact that it will
> flare up and annoy people is a good incentive to fix the kernel!
> 

Sounds good, thank you both. Will send V2 with the proper behavior then.

Thanks,
Ricardo

> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

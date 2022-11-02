Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96BC9616E58
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 21:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiKBUK4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 16:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbiKBUKj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 16:10:39 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3F91A8
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 13:10:29 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 78so17166224pgb.13
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 13:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=H2+PKRdmInfTvqAypdu5OzPafcn0HJsxpikVuqXyIw0=;
        b=nIzVwoF24Ts2X590Rhqa+EIohLFQhcwuwh+RrHzF0EP70aP7IUYbVM6w+x+Cm/WUc7
         OJha6oyPduPEs4Ji1TUgSMw1qdxD/XHHHxNGwFZgH5Bdm6gc1KcctNQrAhq/oRDtw1Y8
         ZCfQtiqm8w9AFvOSPfnnuG2hEM+NJc5zHOEAdcfiuWAhWfKCoYh2Oh27QW75A68/9Eo8
         c6a/gfzMMOUxpPD6zVkI0Kyy38vwh3XseF94L9Ut+0wiz+Qw12CPfxa6n7ypW8HfhOXp
         8qTGvsABuahDgrGb7x/9jGdsJbcx0LwRQ/cGjIldnD/z6HyCZKa7ziUkyKM05fnWA55f
         Ka4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H2+PKRdmInfTvqAypdu5OzPafcn0HJsxpikVuqXyIw0=;
        b=dU/hYrAEUZmPDzCz2QgnenG/mDZUAUfCufzHxiImCoPi/s8H2apIB0mjyH1x6hXqdX
         Grzrb2hBwKO5J3cR62tk4F4I4sWz+FU4BPUdj6HDGSQLoEYFI0dktUiRdAV0ZdVpGHyc
         6osYj9mkSb2q0+SJJuqiUbG4NTCLjvHbXMvif0qCDadU5+ai+lFV98AzJTKSkt0fryoM
         KVbf99bjdTyEn3cdZ1TOyWnFI7d8kalnZqMVLZIVjrxCgpW9YGyiQqTgMl7+06+Ti+w3
         iHVJAyJMLaZyoL0x4TOG+ka+KAEqZ+8nh2KcchLjvvHLvu1XXvFOPahqIYhhMLR2nRIW
         6GCQ==
X-Gm-Message-State: ACrzQf1So4ivaeq1gvLWGIabq8o/ED3bES1A/UGUxIHEWCTc26U9Emhj
        S7PDpb8XuVSyTdslFk42cbdoVzd6TVUujw==
X-Google-Smtp-Source: AMsMyM7CSko8NfH7g4x0mspWpAxS0KLVVuIXlQASDnlegZBfuAsLh30xwklejW0+Gk/ispPbIK4gHQ==
X-Received: by 2002:a65:6753:0:b0:438:e83a:bebc with SMTP id c19-20020a656753000000b00438e83abebcmr22805848pgu.602.1667419828923;
        Wed, 02 Nov 2022 13:10:28 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b00178b77b7e71sm8700390plg.188.2022.11.02.13.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 13:10:28 -0700 (PDT)
Date:   Wed, 2 Nov 2022 20:10:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Sandipan Das <sandipan.das@amd.com>
Subject: Re: [kvm-unit-tests PATCH v4 23/24] x86/pmu: Update testcases to
 cover AMD PMU
Message-ID: <Y2LOsfpWAJs44gA2@google.com>
References: <20221024091223.42631-1-likexu@tencent.com>
 <20221024091223.42631-24-likexu@tencent.com>
 <Y2KvzqPsU5VIGU+x@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2KvzqPsU5VIGU+x@google.com>
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

On Wed, Nov 02, 2022, Sean Christopherson wrote:
> On Mon, Oct 24, 2022, Like Xu wrote:
> >  static inline bool this_cpu_has_pmu(void)
> >  {
> > +	if (!is_intel())
> > +		return true;
> 
> I think it makes sense to kill off this_cpu_has_pmu(), the only usage is after
> an explicit is_intel() check, and practically speaking that will likely hold true
> since differentiating between Intel and AMD PMUs seems inevitable.

Rats, this won't work as vmx_tests.c uses the wrapper.  That's obviously Intel-only
too, but funneling that code through pmu_version() or whatever is rather gross.

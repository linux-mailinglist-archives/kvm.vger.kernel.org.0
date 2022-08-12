Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E23975913D5
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 18:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239305AbiHLQYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 12:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233658AbiHLQYT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 12:24:19 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CD8AE9E9
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 09:24:18 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id z145so1184120iof.9
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 09:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=rRiRP9SOwv6/zJBIcFwpDlKwTsktewwdXYSRXV8AemM=;
        b=f9FxPMKJjcSykquWEOI8GNH5GyE+yglD8XeLCT97ys5HUJCEOZqQve9/DoFPhOzyTz
         y8wujnQHHThqcCXBei0KI1LLXr4fd4gETNXs9IwqQwcniWA1kqgcQ3pkdwEACfbeo9jh
         jm8nPsyZ8McA42Z+cHn4lqbXhvV6GFw2Qy/vmtCBSHU3H5gkBNYwkPYP8EmRQxsv5RNp
         AEF+i8iUlxQcMyrmvqJGwJ/fQ/4mFwSwl04epOBIxeEo0gbDOei5Bp2yZsrhHmOtY/T/
         4993AcHNIrAuXt3j9LTiNJPL6qjGm0a8Ww5m/9J8Rrm0ElJkL0A4lu7PcHuKN8o5CNU+
         oMWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=rRiRP9SOwv6/zJBIcFwpDlKwTsktewwdXYSRXV8AemM=;
        b=gbtltK8DgU52Vk5MzJeS3waYNxsigCETDqZyl6IMId/hSSYqtaq9g2lKD+PZPLA4Q9
         dsVBNLY/JxGDH1svXoj+FNWor3mBbfj5V8mgLq6QxIS6esW9D23atJ2Up6rDjDR+rEqz
         CZNk9rZVyqp0Wo36Pq6fnWt5lw1xuyXgDKtNamrFn5avN/Xk+fnntJTXqaf1LIePBt9x
         JDREBCekIS1YJ++MqfD81VOXRZesDo/ryXbDAE8VPUI0dDkThPnvbu7OuGYtzmP6+Lhd
         bolhr9v2w4s92ic3aDFVTKzGx1uThGV7EKbzdwu5S10iSnNEplBZx/2PDuZwjbRhn2XI
         2oeg==
X-Gm-Message-State: ACgBeo3q6PHjB1fyH+hFGNEE+efOSoFIl2VZtKu6q6YJ5sUgMhNRwl9b
        SRMzU+K07wfxJjBzd50K11K/Bw==
X-Google-Smtp-Source: AA6agR4hrJ4/c4ofmCe+T9Vf9MUNN9hOpXLnrFHLlLYArTj1k55yGiBeclkwPAmshrZCD8XIx+IGHw==
X-Received: by 2002:a02:cc78:0:b0:342:7639:6d20 with SMTP id j24-20020a02cc78000000b0034276396d20mr2283128jaq.53.1660321457392;
        Fri, 12 Aug 2022 09:24:17 -0700 (PDT)
Received: from google.com (30.64.135.34.bc.googleusercontent.com. [34.135.64.30])
        by smtp.gmail.com with ESMTPSA id g25-20020a05663810f900b0034287949de5sm46075jae.148.2022.08.12.09.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 09:24:16 -0700 (PDT)
Date:   Fri, 12 Aug 2022 16:24:13 +0000
From:   Colton Lewis <coltonlewis@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, oupton@google.com, ricarkol@google.com
Subject: Re: [PATCH 3/3] KVM: selftests: Randomize page access order
Message-ID: <YvZ+rTKd8dmezzgu@google.com>
References: <20220810175830.2175089-1-coltonlewis@google.com>
 <20220810175830.2175089-4-coltonlewis@google.com>
 <YvREA1VJA3ryF+io@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvREA1VJA3ryF+io@google.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 10, 2022 at 04:49:23PM -0700, David Matlack wrote:
> On Wed, Aug 10, 2022 at 05:58:30PM +0000, Colton Lewis wrote:
> > diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> > index 3c7b93349fef..9838d1ad9166 100644
> > --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> > +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> > @@ -52,6 +52,9 @@ void perf_test_guest_code(uint32_t vcpu_idx)
> >  	struct perf_test_vcpu_args *vcpu_args = &pta->vcpu_args[vcpu_idx];
> >  	uint64_t gva;
> >  	uint64_t pages;
> > +	uint64_t addr;
> > +	bool random_access = pta->random_access;
> > +	bool populated = false;
> >  	int i;
> >  
> >  	gva = vcpu_args->gva;
> > @@ -62,7 +65,11 @@ void perf_test_guest_code(uint32_t vcpu_idx)
> >  
> >  	while (true) {
> >  		for (i = 0; i < pages; i++) {
> > -			uint64_t addr = gva + (i * pta->guest_page_size);
> > +			if (populated && random_access)
> 
> Skipping the populate phase makes sense to ensure everything is
> populated I guess. What was your rational?

That's it. Wanted to ensure everything was populated. Random
population won't hit every page, but those unpopulated pages might be
hit on subsequent iterations. I originally let population be random
too and suspect this was driving an odd behavior I noticed early in
testing where later iterations would be much faster than earlier ones.

> Either way I think this policy should be driven by the test, rather than
> harde-coded in perf_test_guest_code(). i.e. Move the call
> perf_test_set_random_access() in dirty_log_perf_test.c to just after the
> population phase.

That makes sense. Will do.

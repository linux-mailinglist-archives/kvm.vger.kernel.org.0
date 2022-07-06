Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8A2568CC1
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 17:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233399AbiGFP3h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 11:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbiGFP3f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 11:29:35 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7CE1C91F
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 08:29:35 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id r133so14328828iod.3
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 08:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/g+2QDhf/M+KKE2UkJnZoUTJqeRg0COeESHnYwx3rvI=;
        b=QTml3dMluEIkRRHy+OtIGUwJTwOOk4eTs/ho9Y/BSbNv7IHRat+Cma+KaEzTFO/ric
         6i14jc7Cj/q+zKTH4m/NuQCTOyhO/nIAULH/hZSqPUiPTY886coDBzr5mhwLNXi4+8EB
         grb1qn/16vQshvPb4U+xbuPKwQuQRgdP/+ZKTAz49gR/hMelyP+Kdsv9x7CHhFWetU+E
         0dLzqM9S7Ldlcm71Hk3mvy4ayAnVq9m4ziBCVMacdytQ43V0ay8knAgE6gkDB2siPU9v
         eln5bjqT2B3qM3c7TinZJImvxbqC9RqWnYjsgRXiSLMZxf0feugmTwSG7QnQUZDrASmm
         WX0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/g+2QDhf/M+KKE2UkJnZoUTJqeRg0COeESHnYwx3rvI=;
        b=qUVvl2hTEEbqgkadLfIAq5gqOQJDQO8+MnEJTcqR7zueTArTk1q1T0PzNO1Ica6Ecg
         LpwC5kTBcdBUEsrTWySnprR4q6o7BnImxCP3Libh4fW15Mc98B00ca2hYmlR0hbgEZ2J
         AfB/csmQFLchvDxfNM2WYgLpt9steliTVb2oBdTEgzMpBG6VbSzO60M884ZbVIKbRttk
         YyNxjk7gKN19CxeQpVbtym0Ni35RcsF1UYLvT/P1koN10Yk09tpXp0MH+PHs1yrO3OtB
         uK+hJy5nEg36PjIO1SnIzhyj2DEd5mNnVdGC01V1BPobYg32T79sRs86tvgNJxdB80Vm
         cBiA==
X-Gm-Message-State: AJIora8l2a5KLbR4ZjZ5CQX+g8hJocsH6OVikg+AZ48MUXwwvjRz0YoQ
        89TeEohHX0Hj3mial1rF5IEwDcww4Ht5CeWv
X-Google-Smtp-Source: AGRyM1v3zPhIeXW9MdHQumXXkgoBSrJYc1+K8Lq6AAlHI2A+/POU8SMD2YQI+pgfkywwa0XVa2xS4w==
X-Received: by 2002:a05:6638:409f:b0:33c:d757:2e4e with SMTP id m31-20020a056638409f00b0033cd7572e4emr23791804jam.221.1657121374715;
        Wed, 06 Jul 2022 08:29:34 -0700 (PDT)
Received: from google.com (30.64.135.34.bc.googleusercontent.com. [34.135.64.30])
        by smtp.gmail.com with ESMTPSA id y25-20020a056638229900b00339d244c4a6sm1718724jas.23.2022.07.06.08.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 08:29:34 -0700 (PDT)
Date:   Wed, 6 Jul 2022 15:29:30 +0000
From:   Colton Lewis <coltonlewis@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, seanjc@google.com,
        vkuznets@redhat.com, thuth@redhat.com, maz@kernel.org,
        Ricardo Koller <ricarkol@google.com>, g@gator
Subject: Re: [PATCH 4/4] KVM: selftests: Fix filename reporting in guest
 asserts
Message-ID: <YsWqWkl8ymLFqxgY@google.com>
References: <20220615193116.806312-1-coltonlewis@google.com>
 <20220615193116.806312-5-coltonlewis@google.com>
 <20220616124519.erxasor4b5t7zaks@gator>
 <2fc82066-f092-bc19-ae69-6852820f41ef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2fc82066-f092-bc19-ae69-6852820f41ef@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 02:04:43PM +0200, Paolo Bonzini wrote:
> On 6/16/22 14:45, Andrew Jones wrote:
> > > +#define __GUEST_ASSERT(_condition, _condstr, _nargs, _args...) do {	\
> > > +		if (!(_condition))					\
> > > +			ucall(UCALL_ABORT, GUEST_ASSERT_BUILTIN_NARGS + _nargs,	\
> > > +			      "Failed guest assert: " _condstr,		\
> > > +			      __FILE__,					\
> > > +			      __LINE__,					\
> > > +			      ##_args);					\
> > We don't need another level of indentation nor the ## operator on _args.
> > 
> 
> The ## is needed to drop the comma if there are no _args.

I haven't heard anything more about part 4 of this patch in a while,
so I'm checking in that I didn't miss something requiring action on my
part.

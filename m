Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAE059151A
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 19:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237116AbiHLR5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 13:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233349AbiHLR5Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 13:57:16 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F47A5C72
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 10:57:15 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id r22so1388741pgm.5
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 10:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=On7C2WVHpUSP29uDe0Zk7xxqfw94zgRBvMfSSWUNRhE=;
        b=T7d1TkRsePjPxfnWhD1hH8gtjeKcF1Ui/wCiLf7RviRGolw2Km2Y+mQXkWGuyV2Ysa
         H6cXOMgIammjqjfKqJgseTSjYpunELu99QkzL6+jdHjRpsMj3LDXqGet5nBZK0RHZkN8
         T4aiUW+Q2gG89SyvKu+Y9PDPdRwonxwoa+oWRgYQwDgUhwU9KlBRl9pUwnWaqxFo47Pw
         TBKljNA8DeNhP+p0eTHy6fSsMEsX/g21SUyG1rc+ym7PwX54GSq84BQJp4VFzwTm4QpL
         OrZAc+rbqWaBvsugzqB0PuiJGXcH73pAc35YUNpxDSkmNDuGwbYD+v4NnaUdExj9lGCS
         eACw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=On7C2WVHpUSP29uDe0Zk7xxqfw94zgRBvMfSSWUNRhE=;
        b=AMk/+XacYqkhrR5gt+PCMZX3NxZL0FYYiHZOwOSh423Dgs4fX1hN3ki2Pd3oP6x1et
         s7ry4LIkjeDuBp5juk+Z5i6547StIsbuMfKfEd9nn+bC41tzasl5gfZoc+QyBI4u/FBs
         KuI5XKxU/zWzcRNwKyheqtsawI/vTRmxRrvmbxpCppThiWIufH+p9whoDgtLj6wsJlJU
         Yy1ec8JZrTVOne9cNinibCKkyBAh50eLlTwAI8/GAj3ramxZvpSjvx6F+9BewTpCuSti
         XqPYceuRzhgK8mi0QIQ/T6kFycukA2qdYzbm/afkCP2PMlpn9WY/USF/00pduX7SD9pA
         CjTA==
X-Gm-Message-State: ACgBeo2DEyX6rhwjtojbqI8qOJDzIytYsdngyAoZIWW8IJyNfaxnytul
        FAOLnb+wWXFRVtqL9wyHGDbaNw==
X-Google-Smtp-Source: AA6agR7WF+te4SjtfCu2H/j3kNeq5igrD9TNACHGGoMYEgeEc2wnCVx2meSrLvTN+UvM4hGRXAx43Q==
X-Received: by 2002:a63:5320:0:b0:41c:89ca:f931 with SMTP id h32-20020a635320000000b0041c89caf931mr3918667pgb.525.1660327035251;
        Fri, 12 Aug 2022 10:57:15 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id v7-20020a632f07000000b0041cd5ddde6fsm1591636pgv.76.2022.08.12.10.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 10:57:14 -0700 (PDT)
Date:   Fri, 12 Aug 2022 10:57:10 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH v4 0/4] arm: pmu: Fixes for bare metal
Message-ID: <YvaUdjguLwvXabIF@google.com>
References: <20220811185210.234711-1-ricarkol@google.com>
 <20220812063300.ygeyivgzzkyzg3uo@kamzik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220812063300.ygeyivgzzkyzg3uo@kamzik>
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

On Fri, Aug 12, 2022 at 08:33:00AM +0200, Andrew Jones wrote:
> On Thu, Aug 11, 2022 at 11:52:06AM -0700, Ricardo Koller wrote:
> > There are some tests that fail when running on bare metal (including a
> > passthrough prototype).  There are three issues with the tests.  The
> > first one is that there are some missing isb()'s between enabling event
> > counting and the actual counting. This wasn't an issue on KVM as
> > trapping on registers served as context synchronization events. The
> > second issue is that some tests assume that registers reset to 0.  And
> > finally, the third issue is that overflowing the low counter of a
> > chained event sets the overflow flag in PMVOS and some tests fail by
> > checking for it not being set.
> > 
> > Addressed all comments from the previous version:
> > https://lore.kernel.org/kvmarm/YvPsBKGbHHQP+0oS@google.com/T/#mb077998e2eb9fb3e15930b3412fd7ba2fb4103ca
> > - add pmu_reset() for 32-bit arm [Andrew]
> > - collect r-b from Alexandru
> 
> You forgot to pick up Oliver's r-b's and his Link suggestion.

Ahh, yes, sorry Oliver.

> I can do that again, though.

Thanks Andrew

> 
> Thanks,
> drew

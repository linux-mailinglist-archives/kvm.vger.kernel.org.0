Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 173B1578832
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 19:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbiGRRSp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 13:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbiGRRSo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 13:18:44 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884492C64C
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 10:18:43 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id t5-20020a17090a6a0500b001ef965b262eso13273664pjj.5
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 10:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=O+93vwyZCBtIfSzt+zHZDwMtD0oUi0EihMlo7pm6fvc=;
        b=r6OoQJ3en6er/iZYe0wnDU0KNgKRWt+E0a8EaCaViv/9dnMVeDBoImj2fdN8lMKU0Z
         +ODctnO2E+tj3jyYyXR0Q/kctG9PaBcw+yg94KJZ9DIBtc3cUQs15pb87aPaZvRTWGA9
         fc365G0ro09jgrY2VdDJ7/l3PKyOg4VCdMTOE13LoX5TMUuhcGU2rw3T6aJCJP+IVhan
         vv/Z200yFtPdGSUlmAxckM/3xVG+GM+vCc/UDUuyjUda8UbchATNR3sfDPEez7/4y9Uu
         n134Hfah/MxdViGOOkSrtVvXRH0sNRa6VhrhDhkyKmnP5XZzVDfUqL/57mNSCNtz7KD1
         l5KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=O+93vwyZCBtIfSzt+zHZDwMtD0oUi0EihMlo7pm6fvc=;
        b=pEAPH9iNmTaZ4e1UF1F6prKVpx8XcAnM6ntDlH20lznBQ0Mk+aHKfqgqqlpcM/nIY/
         Y/z3pYxk6hMRtooQcnSZjTfAW7sOw1ufl0LqrxnlGdIPYaEULXBSoF0YX8fyXygSbZhq
         hmBHhyD2A9vva98PFiOsCypJH6YoBP+bIl4Svj1h5Bqwz6YP3jWwJqnQ/ttfx5tstzwF
         NuhvVOz/cQCs9Dejn/u1DtKOoDu1QOtwBL8Vsvu8E6GlOhGpiP7qvqEcUqC7tZuAG8OL
         KkYH8Y4RYYQAgOMIHlHRs+Tj/cbxFV617yCFUINKNEXIdzBZBqmmE3821Yi3qlYGC0xh
         Ky5w==
X-Gm-Message-State: AJIora/Ajfy6zSPR8eZ27uDdnUBjUwOTN6O1JEQu+DHv3XP142na1huo
        wTCitQJQzcE9d9M51FdT2sTrxs7H/SWvWA==
X-Google-Smtp-Source: AGRyM1tvU8nSRHjMbzxG++8pKT3KPkxakjucMRyr+1ZsowRIduO2aS8kjdBQ7saWuuzuAyWaltgE1A==
X-Received: by 2002:a17:90b:3b4b:b0:1ef:f5b0:ce60 with SMTP id ot11-20020a17090b3b4b00b001eff5b0ce60mr40865600pjb.71.1658164722909;
        Mon, 18 Jul 2022 10:18:42 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id w24-20020aa79558000000b0052af2e8bba3sm9556204pfq.37.2022.07.18.10.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 10:18:42 -0700 (PDT)
Date:   Mon, 18 Jul 2022 10:18:37 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        eric.auger@redhat.com, oliver.upton@linux.dev, reijiw@google.com,
        andrew.jones@linux.dev
Subject: Re: [kvm-unit-tests PATCH 0/3] arm: pmu: Fixes for bare metal
Message-ID: <YtWV7fDh9ihufLhM@google.com>
References: <20220718154910.3923412-1-ricarkol@google.com>
 <YtWNYGuP/Nu1HwDU@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtWNYGuP/Nu1HwDU@monolith.localdoman>
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

On Mon, Jul 18, 2022 at 05:42:08PM +0100, Alexandru Elisei wrote:
> Hi,
> 
> I believe you're missing the updated email for the arm maintainer. Added it.
> 
> Thanks,
> Alex
> 
> On Mon, Jul 18, 2022 at 08:49:07AM -0700, Ricardo Koller wrote:
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
> > I believe the third fix also requires a KVM change, but would like to
> > double check with others first.  The only reference I could find in the
> > ARM ARM is the AArch64.IncrementEventCounter() pseudocode (DDI 0487H.a,
> > J1.1.1 "aarch64/debug") that unconditionally sets the PMOVS bit on
> > overflow.
> > 
> > Ricardo Koller (3):
> >   arm: pmu: Add missing isb()'s after sys register writing
> >   arm: pmu: Reset the pmu registers before starting some tests
> >   arm: pmu: Remove checks for !overflow in chained counters tests
> > 
> >  arm/pmu.c | 34 +++++++++++++++++++++++-----------
> >  1 file changed, 23 insertions(+), 11 deletions(-)
> > 
> > -- 
> > 2.37.0.170.g444d1eabd0-goog
> > 

Right, I forgot about the new email. Thanks for the forwarding!

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B366B7C5AE0
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 20:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234990AbjJKSFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 14:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233132AbjJKSFV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 14:05:21 -0400
Received: from out-203.mta0.migadu.com (out-203.mta0.migadu.com [91.218.175.203])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03CF3A4
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 11:05:19 -0700 (PDT)
Date:   Wed, 11 Oct 2023 18:05:11 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697047518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xRTgX+Dt/2jA3rPcRQK47Ac8WI7XuDHgVx6Sck8TIV4=;
        b=QsEW8oO59znRSH20Z881Su3EwC+j9t1fxQ/8bITL/6ii3NQdDjbGFM+T82lhR0HavTkHqX
        A4yjoj0FEpN7RZq+qlYv68ucpDOURHnpLcpTTMnuTNdNPsOsHkeeEesaSrF2r7TGZMEEXQ
        dLo9uawYW2yW7zaY2UGkQYfi3psRujo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Mark Brown <broonie@kernel.org>
Cc:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        linux-perf-users@vger.kernel.org,
        Jing Zhang <jingzhangos@google.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 1/5] tools headers arm64: Copy sysreg-defs generation
 from kernel source
Message-ID: <ZSbj16o2FYOTn9DL@linux.dev>
References: <20231010011023.2497088-1-oliver.upton@linux.dev>
 <20231010011023.2497088-2-oliver.upton@linux.dev>
 <871qe1m79u.wl-maz@kernel.org>
 <cef524b7-ecbc-44c4-a582-e39f495c53db@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cef524b7-ecbc-44c4-a582-e39f495c53db@sirena.org.uk>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 11, 2023 at 05:59:28PM +0100, Mark Brown wrote:
> On Wed, Oct 11, 2023 at 05:51:57PM +0100, Marc Zyngier wrote:
> > Oliver Upton <oliver.upton@linux.dev> wrote:
> 
> > > The system register definitions are now generated with a script over in
> > > the kernel sources. Pull a copy into tools in anticipation of updating
> > > dependent header files and add a common makefile for generating the
> > > header.
> 
> > Rather than a copy, which makes the maintenance pretty horrible, why
> > don't you just symlink it? Git is perfectly capable of storing them,
> > last time I checked.
> 
> Do we even need to symlink - as I suggested on the previous version can
> we not just reference the script and data file directly in the main
> kernel tree?  Like I said then there may be some use case for building
> the tools directory outside the kernel source that I'm not aware of but
> otherwise I'm not clear that the motivations for copying the actual
> headers for use in tools/ apply to these files.
> 
> I think the current approach is *fine* (hence my reviewed by) 
> given the amount of other copying but it would save a bit of work to not
> copy.

So long as we aren't going to do any further renames I don't have an
issue with this approach.

-- 
Thanks,
Oliver

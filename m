Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C939A73D744
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 07:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbjFZFnT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 01:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbjFZFnG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 01:43:06 -0400
Received: from out-34.mta1.migadu.com (out-34.mta1.migadu.com [95.215.58.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3FDE76
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 22:42:55 -0700 (PDT)
Date:   Mon, 26 Jun 2023 07:42:51 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1687758173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z5xm0yL6tMpfNwaXgE7k/hFpi1rO8H47YZjf4UctCUQ=;
        b=vDZPjTiTo3abdwEz71qk9WLmG+/xRon3GLB4Mm/4AYg57UYWx2+6MbhbDZ/yuM5+VKhUAq
        8JAuU8qrpoSdYhs07ivvwQRHHF3LRv4In9GTbjiR7wnze5sCT5nqluoP2pf/T1zfnEb2bP
        cb/RKQETi9AcDxt4uZbtPtcSIo4Px3w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: Re: [kvm-unit-tests PATCH 3/6] arm64: enable frame pointer and
 support stack unwinding
Message-ID: <20230626-78ae2a0aee916a655de66849@orel>
References: <20230617014930.2070-1-namit@vmware.com>
 <20230617014930.2070-4-namit@vmware.com>
 <20230623-622ec2c26e09f951f42cce46@orel>
 <7BD2B564-E0E0-4589-8FB1-E82D5D697D13@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7BD2B564-E0E0-4589-8FB1-E82D5D697D13@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 25, 2023 at 12:22:15PM -0700, Nadav Amit wrote:
> 
> 
> > On Jun 24, 2023, at 3:13 AM, Andrew Jones <andrew.jones@linux.dev> wrote:
> > 
> >> +extern char vector_stub_start, vector_stub_end;
> > 
> > These aren't used until the next patch.
> > 
> >> +
> >> +int backtrace_frame(const void *frame, const void **return_addrs, int max_depth) {
> > 
> > '{' should be on its own line. I usually try to run the kernel's
> > checkpatch since we use the same style (except we're even more forgiving
> > for long lines).
> 
> I usually do use checkpatch. I guess I got sloppy. I will fix these 2 issues.
> 
> BTW: I used the get_maintainer script to get who to send the patches to and it
> included the depreciated kvmarm@lists.cs.columbia.edu <mailto:kvmarm@lists.cs.columbia.edu> .. Ugh.

Ah, thanks for pointing that out. It's safe to declare the depreciation
peroid over. I just pushed a patch dropping it now.

drew

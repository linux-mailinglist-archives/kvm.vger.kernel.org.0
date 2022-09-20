Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3225BE087
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 10:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbiITIme (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 04:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiITIln (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 04:41:43 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3856AA12
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 01:40:50 -0700 (PDT)
Date:   Tue, 20 Sep 2022 10:40:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663663248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lHFpp7hkEKHFOnfHwDvnl2TA13NgithyV4MAxYR7lFw=;
        b=hOLqMjZEActPJjnEsEOOMcSvEmbyxu+Is3FgBzWFo2dvi+zRY3bGLWLc2UvF37oEyft5u1
        DY1ESt1u7zNxVXVi7DaI4On4yGMStJZSFPB2gAAZul8oVeCTS2n0p3VswOK1BAXnO6/iYV
        lPzp6rpr95YEvwLxZqMrNVaQDC7WqdA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 06/19] lib/alloc_phys: Remove
 allocation accounting
Message-ID: <20220920084047.gblxkhedbugl7giz@kamzik>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-7-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809091558.14379-7-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 09, 2022 at 10:15:45AM +0100, Alexandru Elisei wrote:
> The page allocator has better allocation tracking and is used by all
> architectures, while the physical allocator is now never used for
> allocating memory.
> 
> Simplify the physical allocator by removing allocation accounting. This
> accomplishes two things:
> 
> 1. It makes the allocator more useful, as the warning that was displayed
> each allocation after the 256th is removed.
> 
> 2. Together with the lock removal, the physical allocator becomes more
> appealing as a very early allocator, when using the page allocator might
> not be desirable or feasible.

How does the locking cause problems when used in an early allocator?

> 
> Also, phys_alloc_show() has received a slight change in the way it displays
> the use and free regions: the end of the region is now non-inclusive, to
> allow phys_alloc_show() to express that no memory has been used, or no
> memory is free, in which case the start and the end adresses are equal.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/alloc_phys.c | 65 ++++++++++++++----------------------------------
>  lib/alloc_phys.h |  5 ++--
>  2 files changed, 21 insertions(+), 49 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

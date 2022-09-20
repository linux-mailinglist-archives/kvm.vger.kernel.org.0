Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74D955BE002
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 10:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbiITI3O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 04:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231516AbiITI2f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 04:28:35 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34F0263B
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 01:27:05 -0700 (PDT)
Date:   Tue, 20 Sep 2022 10:27:03 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663662424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wkhrlpTcE9gr3IvZCURiyAx4WO76j5beHMNEbt6Gc3s=;
        b=Tw/OLBTom06BSxI2FYf7MbQKQomDYGYO2QHssZ2C58PVKMJOEB1FSzmjUQ4clCZ+x+Q7Pt
        ToheBMvnADX/lAnHCX/7dLnQWYB/elY6svwd9SNf1EE5WvL3xIsuGavxw/unc7wndB2Efi
        YZmSaW56xZDSHKvQCA0EF/4snymwb30=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 03/19] lib/alloc_phys: Use
 phys_alloc_aligned_safe and rename it to memalign_early
Message-ID: <20220920082703.u37twjovg7yv2ea6@kamzik>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-4-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809091558.14379-4-alexandru.elisei@arm.com>
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

On Tue, Aug 09, 2022 at 10:15:42AM +0100, Alexandru Elisei wrote:
> phys_alloc_aligned_safe() is called only by early_memalign() and the safe
> parameter is always true. In the spirit of simplifying the code, merge the
> two functions together. Rename it to memalign_early(), to match the naming
> scheme used by the page allocator.
> 
> Change the type of top_safe to phys_addr_t, to match the type of the top
> and base variables describing the available physical memory; this is a
> cosmetic change only, since libcflat.h defines phys_addr_t as an alias
> for u64.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/alloc_phys.c | 38 ++++++++++++++------------------------
>  1 file changed, 14 insertions(+), 24 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

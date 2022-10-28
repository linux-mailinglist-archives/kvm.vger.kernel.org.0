Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50BB56111F3
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 14:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiJ1MyY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 08:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiJ1MyX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 08:54:23 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127621D5876
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 05:54:21 -0700 (PDT)
Date:   Fri, 28 Oct 2022 14:54:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666961660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=faBEUID8ecAxojrzIEDsR5vvjyAZdIaTRru7O3n6MSA=;
        b=HzQId8h+ivqZDyADgQ+r39KPBFNZme6jQ4lv3E/pippXUK9I/6TnboHl9U/bux6+UPHkDM
        K4YpxCCM/vvqXNZvl++r0upMO4ITfbA18qUZlMKBXK1Rleiymof6s7YZdvuKhhPknLselO
        O2Q8QINKo8V4n8hprlLlht7ma1NUeoI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH] MAINTAINERS: new kvmarm mailing list
Message-ID: <20221028125419.6cfeokgtm7ycifpt@kamzik>
References: <20221025160730.40846-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025160730.40846-1-cohuck@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 25, 2022 at 06:07:30PM +0200, Cornelia Huck wrote:
> KVM/arm64 development is moving to a new mailing list (see
> https://lore.kernel.org/all/20221001091245.3900668-1-maz@kernel.org/);
> kvm-unit-tests should advertise the new list as well.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  MAINTAINERS | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 90ead214a75d..649de509a511 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -67,7 +67,8 @@ ARM
>  M: Andrew Jones <andrew.jones@linux.dev>
>  S: Supported
>  L: kvm@vger.kernel.org
> -L: kvmarm@lists.cs.columbia.edu
> +L: kvmarm@lists.linux.dev
> +L: kvmarm@lists.cs.columbia.edu (deprecated)
>  F: arm/
>  F: lib/arm/
>  F: lib/arm64/
> -- 
> 2.37.3
>

Pushed, thanks!

drew

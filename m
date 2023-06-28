Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C36D740B78
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 10:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbjF1I3M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 04:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234752AbjF1I06 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 04:26:58 -0400
Received: from out-54.mta1.migadu.com (out-54.mta1.migadu.com [IPv6:2001:41d0:203:375::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554EC3A87
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 01:19:05 -0700 (PDT)
Date:   Wed, 28 Jun 2023 10:19:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1687940343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8/NpNtfgHWocmA3JK1yueXlTaMV0/c7t/H+GYBwbgk8=;
        b=w0luHIs1GtcC3Fb18QLuSEHXxi8VN2DHsp/n/vfoWEnf+Ph48ZX9NYWwOW+F7qAGCVjjvv
        /6mTrqYVYSahEmf7Qn0VFFP/kIQFg2qlRWKXCdwIETWji/6e5VUBr7kNG1s+16vKrqGeEA
        zYQdagh8eoejIvz7uGqyf09BQ/w+PYs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Nadav Amit <namit@vmware.com>
Subject: Re: [PATCH] .debug ignore - to squash with efi:keep efi
Message-ID: <20230628-646da878865323f64fc52452@orel>
References: <20230628001356.2706-1-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230628001356.2706-1-namit@vmware.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023 at 12:13:48AM +0000, Nadav Amit wrote:
> From: Nadav Amit <namit@vmware.com>

Missing s-o-b.

> 
> ---
>  .gitignore | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/.gitignore b/.gitignore
> index 29f352c..2168e01 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -7,6 +7,7 @@ tags
>  *.flat
>  *.efi
>  *.elf
> +*.debug
>  *.patch
>  .pc
>  patches
> -- 
> 2.34.1
>

The patch threading is busted. Everything in the thread, including the
cover letter, is in reply to this patch.

Thanks,
drew

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6321D5BE1D8
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 11:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiITJZF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 05:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiITJZE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 05:25:04 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0EA2B615
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 02:25:01 -0700 (PDT)
Date:   Tue, 20 Sep 2022 11:24:59 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663665899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9zrLhW6+j/sbUQdXwNAlZMyILSK9/uM8auDZkZ2Ibrg=;
        b=a63720QQS8maY/E/11LPxMihWSMsik+ISeTPBLj8yb/ScHEdkXiaGBbFqZ5zE2NkTV5ztj
        CmWTcZFDhm2JznDf4irbevFWtS1Iff5d+/fFNcqIh+uQrV6e488cJYY7khdkgtgCx50bce
        UZoLu1waKnHrJSlJt6bl2oTzqYUy7Wo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 09/19] arm/arm64: Zero secondary CPUs'
 stack
Message-ID: <20220920092459.ptiwfll5cxo76bah@kamzik>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-10-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809091558.14379-10-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 09, 2022 at 10:15:48AM +0100, Alexandru Elisei wrote:
> For the boot CPU, the entire stack is zeroed in the entry code. For the
> secondaries, only struct thread_info, which lives at the bottom of the
> stack, is zeroed in thread_info_init().
> 
> Be consistent and zero the entire stack for the secondaries. This should
> also improve reproducibility of the testsuite, as all the stacks now start
> with the same contents, which is zero. And now that all the stacks are
> zeroed in the entry code, there is no need to explicitely zero struct
> thread_info in thread_info_init().
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/cstart.S          | 6 ++++++
>  arm/cstart64.S        | 3 +++
>  lib/arm/processor.c   | 1 -
>  lib/arm64/processor.c | 1 -
>  4 files changed, 9 insertions(+), 2 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

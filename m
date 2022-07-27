Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACDCA582A2D
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 18:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbiG0QBs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 12:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234467AbiG0QBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 12:01:45 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E2B4AD4F
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 09:01:43 -0700 (PDT)
Date:   Wed, 27 Jul 2022 16:01:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1658937701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MIVHqmVT6XDFh0scJsMUAJJN5QiOkyZcHL6zatK40GI=;
        b=pf/jpd6W/zgUqZ06ofNtfuD9HllnMfiRTormw96GjNDkX8MLvy4eJcvM8Y4ku1aua8lnO4
        iwhIu9WoGeJfUXN/v2RTQGVLgabWVUnlsDf+fhkcFiJp5cNv22CZIG3FBbQteS3NCtAXIa
        BB7xDgLzFurRCGkyTWkMnIC+rZ74rqA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, mark.rutland@arm.com, broonie@kernel.org,
        madvenka@linux.microsoft.com, tabba@google.com, qperret@google.com,
        kaleshsingh@google.com, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        catalin.marinas@arm.com, andreyknvl@gmail.com,
        vincenzo.frascino@arm.com, mhiramat@kernel.org, ast@kernel.org,
        wangkefeng.wang@huawei.com, elver@google.com, keirf@google.com,
        yuzenghui@huawei.com, ardb@kernel.org, kernel-team@android.com
Subject: Re: [PATCH 0/6] KVM: arm64: nVHE stack unwinder rework
Message-ID: <YuFhWu78i7EpcG/a@google.com>
References: <20220726073750.3219117-18-kaleshsingh@google.com>
 <20220727142906.1856759-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727142906.1856759-1-maz@kernel.org>
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

On Wed, Jul 27, 2022 at 03:29:00PM +0100, Marc Zyngier wrote:
> Hi all,
> 
> As Kalesh's series[1] already went through quite a few rounds and that
> it has proved to be an extremely useful debugging help, I'd like to
> queue it for 5.20.
> 
> However, there is a couple of nits that I'd like to address:
> 
> - the code is extremely hard to follow, due to the include maze and
>   the various levels of inline functions that have forward
>   declarations...
> 
> - there is a subtle bug in the way the kernel on_accessible_stack()
>   helper has been rewritten
> 
> - the config symbol for the protected unwinder is oddly placed
> 
> Instead of going for another round and missing the merge window, I
> propose to stash the following patches on top, which IMHO result in
> something much more readable.
> 
> This series directly applies on top of Kalesh's.
> 
> [1] https://lore.kernel.org/r/20220726073750.3219117-1-kaleshsingh@google.com

For the series (besides my own patch of course):

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver

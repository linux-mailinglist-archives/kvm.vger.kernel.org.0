Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65C03563183
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 12:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236468AbiGAKgV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 06:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236388AbiGAKgS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 06:36:18 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5EEF796B7
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 03:36:17 -0700 (PDT)
Date:   Fri, 1 Jul 2022 12:36:15 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656671776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xKnujC1lUGcxYTHtclqkqpYSHQWQtlsVYghDNNV/IpQ=;
        b=dfn5/NgGI30rt9WSZ7rMQWvK6tUxMj0IWKJzMcz5Y1pxpOlysBtPipAtXR8SxxmI9eGwIq
        JHmSBsJjVGqtLk6zm49ern2Vw0gtq68nLbMl+gCpfQ2F4TytoyoxHc0n9HmrUgu33wXjAC
        TOcQ3g+105U5iw5NObHjAjyXpHJOERQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, jade.alglave@arm.com, ricarkol@google.com
Subject: Re: [kvm-unit-tests PATCH v3 15/27] arm/arm64: mmu_disable: Clean
 and invalidate before disabling
Message-ID: <20220701103615.xtz2nnzc4uxi6xrc@kamzik>
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
 <20220630100324.3153655-16-nikos.nikoleris@arm.com>
 <Yr1480um3Blh078q@monolith.localdoman>
 <16eda3c9-ec36-cd45-5c1a-0307f60dbc5f@arm.com>
 <Yr2H3AiNGHeKReP2@monolith.localdoman>
 <218172cd-25fc-8888-96cc-a7b5a9c65f73@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <218172cd-25fc-8888-96cc-a7b5a9c65f73@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 30, 2022 at 04:16:09PM +0100, Nikos Nikoleris wrote:
...
> So unless UEFI maps all memory as Device-nGnRnE we have to do something. I
> will try to find out more about UEFI's page tables.
>

UEFI will map memory as normal-cacheable. You may find section 2.3.6 of
the UEFI spec informative.

Thanks,
drew

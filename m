Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95FB83679F8
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 08:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbhDVGck (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 02:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbhDVGcj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 02:32:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7972AC06174A;
        Wed, 21 Apr 2021 23:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cJHhh3PcR/vv65+kUNeyJ8AL2c6DH0x6BTNjbnOkGTs=; b=eNOZRmnwHuZjmNSLwLDEWy2zHD
        7q1KvPWLyiYxPvbuqqphrAwRFMOhWK/wTPLPSU46WQ47Gm7AMYuKiu+d3Q1KpPDDD+PVWr4fcfq0b
        8r0ylnLMa6UyEsQ2VbNpWtc9UraUKGQmeXwM6pDX+7Qwl/hyId4D1hcO0xr/HtfEHtImC1QBX6qYW
        lPFCgUyhYdE5iL2426E8fYbw4ij6knNPwBMopLpBtDBqTEPfZaWFGkbAbbjARvut4rPHAR51rRAY5
        s+2k9zNwcSDVxAWUw1cBeyPmlckJ7OBV6Pdl+70E7mKF/Vc3IOA5Eb+dDk3G026w4Plwq1+k2Fp7K
        N7zrOCEQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lZSs4-00HX89-Rw; Thu, 22 Apr 2021 06:31:38 +0000
Date:   Thu, 22 Apr 2021 07:31:28 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com, file@sect.tu-berlin.de, ashish.kalra@amd.com,
        martin.radev@aisec.fraunhofer.de, konrad.wilk@oracle.com,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] Untrusted device support for virtio
Message-ID: <20210422063128.GB4176641@infradead.org>
References: <20210421032117.5177-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421032117.5177-1-jasowang@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 21, 2021 at 11:21:10AM +0800, Jason Wang wrote:
> The behaivor for non DMA API is kept for minimizing the performance
> impact.

NAK.  Everyone should be using the DMA API in a modern world.  So
treating the DMA API path worse than the broken legacy path does not
make any sense whatsoever.

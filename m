Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9986E3711CB
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 09:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbhECHDA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 03:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhECHC7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 03:02:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA487C06174A;
        Mon,  3 May 2021 00:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EvzK/tNTFu6j7RpqReg+UsePxfTlwWDpS1m4nxob5S8=; b=d+fupqW0bciG3xsylg36LLTQ15
        +QOOLEWa0exqDSIyE2RFjDoTQS5TD06FY0/1FfQh1XNyXHeFTsG9tyenVBVIqgjCBGawuG14FPPQb
        nlgJ4eujI3lzEMR10byAqYaaw88/xqIRqygJ5YIZ9PGkOsxhy0ki3ZQtW3ya69QlCjplaZenO46s3
        CkePR34QF23Hm6BAF/3bUu0VKRE3N5IjTHEqDqDYFI3jHmEo9AfrGQSPCIGrZ0Y8/bi+X18cTDSU5
        0b538F8+voZe0aZQuAYNWKR2ipPh29rG5HgUm/aggYZDfxdDlS/AZf2JS+8jK3UFDn0+WK/YHAl6N
        vR5rCHXw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1ldSaF-00Elgh-Vf; Mon, 03 May 2021 07:01:37 +0000
Date:   Mon, 3 May 2021 08:01:35 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Shanker Donthineni <sdonthineni@nvidia.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vikram Sethi <vsethi@nvidia.com>,
        Jason Sequeira <jsequeira@nvidia.com>
Subject: Re: [RFC 0/2] [RFC] Honor PCI prefetchable attributes for a virtual
 machine on ARM64
Message-ID: <20210503070135.GA3515187@infradead.org>
References: <20210429162906.32742-1-sdonthineni@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210429162906.32742-1-sdonthineni@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 29, 2021 at 11:29:04AM -0500, Shanker Donthineni wrote:
> Problem statement: Virtual machine crashes when NVIDIA GPU driver access a prefetchable BAR space due to the unaligned reads/writes for pass-through devices. The same binary works fine as expected in the host kernel. Only one BAR has control & status registers (CSR) and other PCI BARs are marked as prefetchable. NVIDIA GPU driver uses the write-combine feature for mapping the prefetchable BARs to improve performance. This problem applies to all other drivers which want to enable WC.

Unless you mean the noveau drivers this simply does not matter.  Please
don't spam the kernel lists with issues with your broken and license
violating drivers.

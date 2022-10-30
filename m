Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48BD26128EA
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 09:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiJ3IFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 04:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiJ3IFq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 04:05:46 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A577A640C;
        Sun, 30 Oct 2022 01:05:44 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1527B68AA6; Sun, 30 Oct 2022 09:05:41 +0100 (CET)
Date:   Sun, 30 Oct 2022 09:05:40 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux.dev, Ashish Kalra <ashish.kalra@amd.com>,
        Pankaj Gupta <pankaj.gupta@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH kernel] x86/swiotlb/amd: Half the size if allocation
 failed
Message-ID: <20221030080540.GH4214@lst.de>
References: <20221027052607.260234-1-aik@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027052607.260234-1-aik@amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The subject looks wrong - this just touches the swiotlb code, and
nothing x86 or AMD specific.

The code flow now looks a little confusing.  Can yu just add a little
swiotlb_memblock_alloc helper that does the two variants of memblock
allocation and remap, so that we can keep a simply
loop around them in the caller?

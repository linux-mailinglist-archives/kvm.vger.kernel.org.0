Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA40F78F832
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 07:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348303AbjIAFu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 01:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjIAFu1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 01:50:27 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1AB10C4
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 22:50:24 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2EFC468BEB; Fri,  1 Sep 2023 07:50:21 +0200 (CEST)
Date:   Fri, 1 Sep 2023 07:50:20 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     Christoph Hellwig <hch@lst.de>, joro@8bytes.org,
        suravee.suthikulpanit@amd.com, iommu@lists.linux.dev,
        Michael Roth <michael.roth@amd.com>,
        "Kalra, Ashish" <Ashish.Kalra@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        linux-coco@lists.linux.dev
Subject: Re: [PATCH] iommu/amd: remove amd_iommu_snp_enable
Message-ID: <20230901055020.GA31908@lst.de>
References: <20230831123107.280998-1-hch@lst.de> <d33f6abe-5de1-fdba-6a69-51bcbf568c81@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d33f6abe-5de1-fdba-6a69-51bcbf568c81@amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 31, 2023 at 01:03:53PM -0500, Kim Phillips wrote:
> +Mike Roth, Ashish
>
> On 8/31/23 7:31 AM, Christoph Hellwig wrote:
>> amd_iommu_snp_enable is unused and has been since it was added in commit
>> fb2accadaa94 ("iommu/amd: Introduce function to check and enable SNP").
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> ---
>
> It is used by the forthcoming host SNP support:
>
> https://lore.kernel.org/lkml/20230612042559.375660-8-michael.roth@amd.com/

Then resend it with that support, but don't waste resources and everyones
time now.

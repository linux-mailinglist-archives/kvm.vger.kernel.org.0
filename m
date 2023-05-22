Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3367570C238
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 17:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233104AbjEVPWL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 11:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbjEVPWJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 11:22:09 -0400
X-Greylist: delayed 333 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 22 May 2023 08:22:08 PDT
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C924DC6
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 08:22:08 -0700 (PDT)
Received: from 8bytes.org (p200300c2773e310086ad4f9d2505dd0d.dip0.t-ipconnect.de [IPv6:2003:c2:773e:3100:86ad:4f9d:2505:dd0d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.8bytes.org (Postfix) with ESMTPSA id E7982248072;
        Mon, 22 May 2023 17:16:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
        s=default; t=1684768594;
        bh=DJnnHRFABOvNHxU+sM0/gzKHfwvuSdSM/0hnrDup9uw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ffl8I/IW7hHbYH3bgYzZcwYlHV8DpOJToHNvSdxK453EJWYyoOCM6MTxtSPMgKQel
         3DsxkhhcTkSpvTQTkM2mU6wWiKp2i4c3eaahq+bigvlXeWll8+OlEDhHZ3Vsam5EuP
         xPpvy+oLHLB1mcif5fQaER0d3rwTKJBny6TZfmWVLVybIDICANpJGlu1RXuAN/ZFQa
         YwYp/lS8i1Yu1Dt/GHTabc7K/bDxlmP4MKuTCE687PFkjBEVxXcOhEw4mcmZ5SuVRQ
         xdlG3TuXHCBssftNCbQjK0vzFjHqehb2m32DYt0tW+LUp4Z7zlCy9+Ft6dyKZzfA1k
         AQpZra4UGiVKg==
Date:   Mon, 22 May 2023 17:16:32 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vasant Hegde <vasant.hegde@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/2] iommu/amd: Fix GAM IRTEs affinity and GALog
 restart
Message-ID: <ZGuHULCklqSgVdmi@8bytes.org>
References: <20230419201154.83880-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419201154.83880-1-joao.m.martins@oracle.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 19, 2023 at 09:11:52PM +0100, Joao Martins wrote:
> Joao Martins (2):
>   iommu/amd: Don't block updates to GATag if guest mode is on
>   iommu/amd: Handle GALog overflows
> 
>  drivers/iommu/amd/amd_iommu.h |  1 +
>  drivers/iommu/amd/init.c      | 24 ++++++++++++++++++++++++
>  drivers/iommu/amd/iommu.c     | 12 +++++++++---
>  3 files changed, 34 insertions(+), 3 deletions(-)

Applied for 6.4, thanks.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5CD6F7728
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 22:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjEDUg7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 16:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbjEDUgP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 16:36:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8129F1385E
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 13:28:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC08E611EF
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 20:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F98C433EF;
        Thu,  4 May 2023 20:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683231602;
        bh=/t6l1LC6nVpi0cfB8LI0t8hsEbE4BDH3MfapO5h+/TM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ld1oUD6YGmlaF3yDcVfvBXO111WZ5RSc1iLeFvYlfM6AbrKoYpAg7TYQJdNKxF+B0
         YWzsBjWdW7919DXXYl2/eIukm6v+QTrkGkqMnLMn1gBPwnj54bcF27y6/TiyC/2UqS
         vfQ/cT859h1gut6dUOHmARDK19P8agWr346epKeBQCcw+6qhY+4D3Bym1S7xosl5au
         hLTPuxZ5PNkBVOYUDR4Dm4RPa4s4IxNywYuKm9bUkRj45cm4FTfHiyksEzqOAlNQhs
         6/KQIYFWaHySY15hhK/y5OCtFKGCH11QAJSUQBXpjd/9Sqqf0EUcNEG2De3p+qHuMc
         JrZfEb2o+w6Vg==
Date:   Thu, 4 May 2023 13:20:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Brett Creeley <brett.creeley@amd.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, alex.williamson@redhat.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com, shannon.nelson@amd.com, drivers@pensando.io
Subject: Re: [PATCH v9 vfio 2/7] vfio/pds: Initial support for pds_vfio VFIO
 driver
Message-ID: <20230504132001.32b72926@kernel.org>
In-Reply-To: <ZFPq0xdDWKYFDcTz@nvidia.com>
References: <20230422010642.60720-1-brett.creeley@amd.com>
        <20230422010642.60720-3-brett.creeley@amd.com>
        <ZFPq0xdDWKYFDcTz@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 4 May 2023 14:26:43 -0300 Jason Gunthorpe wrote:
> This indenting scheme is not kernel style. I generally suggest people
> run their code through clang-format and go through and take most of
> the changes. Most of what it sugges for this series is good
> 
> This GNU style of left aligning the function name should not be
> in the kernel.

FTR that's not a kernel-wide rule. Please scope your coding style
suggestions to your subsystem, you may confuse people.

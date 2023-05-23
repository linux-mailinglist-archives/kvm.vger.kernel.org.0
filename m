Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632FA70DACB
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 12:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236441AbjEWKqQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 06:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236491AbjEWKqO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 06:46:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F0E119
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 03:46:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18330625DC
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 10:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF03C433EF;
        Tue, 23 May 2023 10:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684838772;
        bh=wAfZ0rQpGTMfdwEVsZpgC/dNSQRNMWPfp30taCiTAbc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HihHcCSHVgzj657HpyzAq9BT5pWn7+WhV9Dt6GW/ClftiCLKJ/TpPgyMLssa83Pzw
         oyypFeJe2TqDAqJEuT7FhdCfWDSlBMISg/EJRnBL+Kz2cbpWuK99PvNBtCurUvYgw6
         fFAU4lvlneAyLpsM9HSR5zXyOBPT0MhCXJTqRM+YOb1JhOmJJDEwGJs4BUpSs3wvZA
         ZuJvndl9vSl7pdpvCHqNRtmmGL9jDM7ythThQ2WaowftE8KH3E3uOtQeBqF2u1fJKP
         hhiFT2YBWy6qFCmb0ds4fRLm1do4C8C7aB7XEIXYT7ZXj5M7zNN7WZYMqQkgYGbxTD
         g/4X8bXfNxCAQ==
Date:   Tue, 23 May 2023 11:46:08 +0100
From:   Will Deacon <will@kernel.org>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     kvm@vger.kernel.org, suzuki.poulose@arm.com
Subject: Re: [PATCH kvmtool 00/16] Fix vhost-net, scsi and vsock
Message-ID: <20230523104607.GC7414@willie-the-truck>
References: <20230419132119.124457-1-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419132119.124457-1-jean-philippe@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jean-Philippe,

On Wed, Apr 19, 2023 at 02:21:04PM +0100, Jean-Philippe Brucker wrote:
> Kvmtool supports the three kernel vhost devices, but since they are not
> trivial to test, that support has not followed kvmtool core changes over
> time and is now severely broken. Restore vhost support to its former glory.
> 
> Patches 1-4 introduce virtio/vhost.c to gather common operations, and
> patches 5-11 finish fixing the vhost devices.
> 
> Patch 12 adds documentation about testing all virtio devices, so that
> vhost support can be kept up to date more easily in the future. 
> 
> Patches 13-16 add support for vhost when the device does not use MSIs
> (virtio-mmio or virtio-pci without a MSI-capable irqchip). That's only
> nice to have, but is easy enough to implement.
> 
> Patch 17 documents and fixes a possible issue which will appear when
> enabling CCA or pKVM.

Do you plan to respin this with the outstanding comments addressed?

Will

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A68B544C4E
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 14:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245692AbiFIMlE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 08:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238255AbiFIMlC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 08:41:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB71F23BCD
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 05:41:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47F866190B
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 12:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49FE4C34114;
        Thu,  9 Jun 2022 12:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654778460;
        bh=j8B8hPmt38j0C4H2NjDL9HXsvH1BP9tDr35zQVZQDeo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wy62YLdkwbSTgrC2KoqLMdWxjR4m+oFIU2ID+adE6PXBCVJRxdreZYbusnKTjJhpu
         wH2FwQw8r6xT3JI+h6iJ84x1/dxL8XHfxrMCYi+UFJzQgNoLDUOtN0MlZZw9CkUB7l
         KvwERqaBNDbMmZzwOMTIB66PnLW2XiwNL2BoAyuaCjmantXhZEc+AIddG9sTtl5Ioq
         7i0khdCVypX+/n/yK74f7+LQGcz/r7mu4cVPFxkbAYsnW1Bpndmj7hFGCKZ+0QwCGd
         76vNZO+u4lT6Rx1lf04/5XCSZfZNT2AECc1JzYAadXSefNGc9HXP89fNmM1WWlyarM
         e55y7Lz2CZ00Q==
Date:   Thu, 9 Jun 2022 13:40:55 +0100
From:   Will Deacon <will@kernel.org>
To:     Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com,
        sasha.levin@oracle.com, jean-philippe@linaro.org
Subject: Re: [PATCH kvmtool 17/24] virtio/pci: Delete MSI routes
Message-ID: <20220609124054.GB2599@willie-the-truck>
References: <20220607170239.120084-1-jean-philippe.brucker@arm.com>
 <20220607170239.120084-18-jean-philippe.brucker@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607170239.120084-18-jean-philippe.brucker@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 07, 2022 at 06:02:32PM +0100, Jean-Philippe Brucker wrote:
> On exit_vq() and device reset, remove the MSI routes that were set up at
> runtime.
> 
> TODO: make irq__add_msix_route reuse those deleted routes. Currently, new
> ones will be created after reset.

Please don't leave the TODO in here

Will

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47E31783B2D
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 09:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbjHVHwR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 03:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232434AbjHVHwQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 03:52:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7DDCEF
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 00:52:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98560640FA
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 07:52:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B89C433C8;
        Tue, 22 Aug 2023 07:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692690720;
        bh=tUNXAy/Qa2HXOQo95yhA/qC5ttOJw/0KFtRrpO25v7o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BSEPg6DhPjBE/naw5vAIT3/57NgQ5fistVThuMjBIaBzUje4h5gbGSctv5BKPi+iO
         6tjelTlkSzOdSIZx3gnnD6Vpn6aInbMIlWASsch3KyeN5djiKJmAijDjdRQ7JRuxDP
         7RYR7QfJYEH7N33r1QVF9c3qfVkN11wSMt0HK4qx+/4nywjVN5a+K2QP2fazmDixm3
         2vOi6b9/Zc9bqsUlesGDoaLIOD2xyj7K6zLq/8O7shhEEqx3UztpKyBCMgAw2LSxmL
         O89Myk8jh+E7qi2HnC9EA4oQhnPSecgYgUiFxvRNqgeFt1JKfJPXpXmhCR4+p5nXoK
         izMa0xzfdLWsA==
Date:   Tue, 22 Aug 2023 09:51:56 +0200
From:   Simon Horman <horms@kernel.org>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        shannon.nelson@amd.com
Subject: Re: [PATCH vfio] vfio/pds: Send type for SUSPEND_STATUS command
Message-ID: <20230822075156.GT2711035@kernel.org>
References: <20230821184215.34564-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230821184215.34564-1-brett.creeley@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 21, 2023 at 11:42:15AM -0700, Brett Creeley wrote:
> Commit bb500dbe2ac6 ("vfio/pds: Add VFIO live migration support")
> added live migration support for the pds-vfio-pci driver. When
> sending the SUSPEND command to the device, the driver sets the
> type of suspend (i.e. P2P or FULL). However, the driver isn't
> sending the type of suspend for the SUSPEND_STATUS command, which
> will result in failures. Fix this by also sending the suspend type
> in the SUSPEND_STATUS command.
> 
> Fixes: bb500dbe2ac6 ("vfio/pds: Add VFIO live migration support")
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>

Reviewed-by: Simon Horman <horms@kernel.org>


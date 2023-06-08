Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3661728A61
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 23:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236672AbjFHVqL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 17:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236418AbjFHVqJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 17:46:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A0A2D6A
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 14:46:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D845265123
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 21:46:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0535FC433D2;
        Thu,  8 Jun 2023 21:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686260767;
        bh=Vk7Urm/HQrsqWy1kOShA/VxmDb6EJdWHKmaqmMHu4IY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FJ6+dTpjSShnNtM8523crj5cEIKnjM+bKzUN1L5ZZoAlafCkjcCT2A0U62RAfgibd
         K9GNukHWNgiQnUG5u7tWELviTy3Nf4YaMhNyu5Cs1R3fpr8dQcT7Qh+2P0CfUBglLg
         0BuE45RyRlrj1SgpTT5O9IVsNZHukMTzF3EKpoZdyE7rOTJkRIc6165o+Tfejc/WBu
         dV/Y8HQSFA78m0mgJIFQ2BJqj8yFfXKKVIZpZz6MrpPzR3DKPv1d8xDeHi8R9UvQye
         ctv2H2eSLxNEr8dawhBXRgovE0Dq373z8sZaMAyXoF1ngDFTplJeiT6+uDNPYCwO3/
         CUPuspOsNxa1Q==
From:   Will Deacon <will@kernel.org>
To:     kvm@vger.kernel.org,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, andre.przywara@arm.com
Subject: Re: [PATCH kvmtool v2 00/17] Fix vhost-net, scsi and vsock
Date:   Thu,  8 Jun 2023 22:45:56 +0100
Message-Id: <168626034436.2990232.5014852742701410800.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230606130426.978945-1-jean-philippe@linaro.org>
References: <20230606130426.978945-1-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 6 Jun 2023 14:04:09 +0100, Jean-Philippe Brucker wrote:
> This is version 2 of the vhost fixes for kvmtool posted here:
> https://lore.kernel.org/all/20230419132119.124457-1-jean-philippe@linaro.org/
> 
> Since v1:
> * Added review tags from Andre
> * Fixed issues reported by Andre, and the max_target size found while
>   rebasing patch 8
> * Added patch 14 (warn and disable an unsupported configuration)
> 
> [...]

Applied to kvmtool (master), thanks!

[01/17] virtio: Factor vhost initialization
        https://git.kernel.org/will/kvmtool/c/f84ab9eb74fc
[02/17] virtio/vhost: Factor vring operation
        https://git.kernel.org/will/kvmtool/c/745221e582f7
[03/17] virtio/vhost: Factor notify_vq_eventfd()
        https://git.kernel.org/will/kvmtool/c/676c0c8ad95b
[04/17] virtio/vhost: Factor notify_vq_gsi()
        https://git.kernel.org/will/kvmtool/c/029cd2bb7898
[05/17] virtio/scsi: Move VHOST_SCSI_SET_ENDPOINT to device start
        https://git.kernel.org/will/kvmtool/c/13e7d626e00f
[06/17] virtio/scsi: Fix and simplify command-line
        https://git.kernel.org/will/kvmtool/c/145a86fedfe8
[07/17] disk/core: Fix segfault on exit with SCSI
        https://git.kernel.org/will/kvmtool/c/7bc3b5d7ef80
[08/17] virtio/scsi: Initialize max_target
        https://git.kernel.org/will/kvmtool/c/b8420e8d5d8d
[09/17] virtio/scsi: Fix feature selection
        https://git.kernel.org/will/kvmtool/c/13ea439a1f48
[10/17] virtio/vsock: Fix feature selection
        https://git.kernel.org/will/kvmtool/c/cf8358d34f31
[11/17] virtio/net: Fix feature selection
        https://git.kernel.org/will/kvmtool/c/53171d59b081
[12/17] virtio: Document how to test the devices
        https://git.kernel.org/will/kvmtool/c/13534ee80ce3
[13/17] virtio: Fix messages about missing Linux config
        https://git.kernel.org/will/kvmtool/c/33e026a78c9f
[14/17] virtio/net: Warn about enabling multiqueue with vhost
        https://git.kernel.org/will/kvmtool/c/3a70ab1e7bb3
[15/17] Factor epoll thread
        https://git.kernel.org/will/kvmtool/c/d30d94872e7f
[16/17] virtio/vhost: Support line interrupt signaling
        https://git.kernel.org/will/kvmtool/c/46aaf3b87d7e
[17/17] virtio/vhost: Clear VIRTIO_F_ACCESS_PLATFORM
        https://git.kernel.org/will/kvmtool/c/3b1cdcf9e78f

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

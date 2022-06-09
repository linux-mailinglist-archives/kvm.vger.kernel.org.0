Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED5B0544CA7
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 14:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238680AbiFIMxm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 08:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245357AbiFIMvK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 08:51:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3550612E319
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 05:51:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5C2BB82D5A
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 12:51:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5B0C34114;
        Thu,  9 Jun 2022 12:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654779064;
        bh=KcXCacENiLY05COpMRC0EgZmHs5czwzNjYj3kckHBDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XFH5Gwz0qFQ0ZSych/T6Q9cGv50WbBaICD9TgxaG3z5racvRnqo+d3wqIgdZdS2wh
         XvRCxaqizJG3COga4eV/SaMtluOrXO5Y1TH7Mr5z5a8iTPjBi+bxdKNEP1VsrSlXXG
         K9xFbF4TIfVNdh5r1zj7opdS6oS4jIA/HVmX8iYZKmpwp8cV+DkJVjk4LQuglkxaz9
         aydt71SgKal69cUrtYqzahsIW/zVXDdgCK7VQOCObN73HxKUNOuu6Cw/HA1KoNJw6q
         gsTbt5yL+RzNv8iHZdG2e9FRM0N+lxP7uHMaPijcNx/cQl4fIDEprCe37ipiGnix3C
         ALBexvDi4lh6Q==
From:   Will Deacon <will@kernel.org>
To:     Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, sasha.levin@oracle.com,
        suzuki.poulose@arm.com, kvm@vger.kernel.org,
        jean-philippe@linaro.org, alexandru.elisei@arm.com,
        andre.przywara@arm.com
Subject: Re: [PATCH kvmtool 00/24] Virtio v1 support
Date:   Thu,  9 Jun 2022 13:50:57 +0100
Message-Id: <165477865658.606093.3606622024437424791.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220607170239.120084-1-jean-philippe.brucker@arm.com>
References: <20220607170239.120084-1-jean-philippe.brucker@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 7 Jun 2022 18:02:15 +0100, Jean-Philippe Brucker wrote:
> Add support for version 1 of the virtio transport to kvmtool. Based on a
> RFC by Sasha Levin [1], I've been trying to complete it here and there.
> It's long overdue and is quite painful to rebase, so let's get it
> merged.
> 
> Several reasons why the legacy transport needs to be replaced:
> 
> [...]

Applied patches 1-16 to kvmtool (master), thanks!

[01/24] virtio: Add NEEDS_RESET to the status mask
        https://git.kernel.org/will/kvmtool/c/7efc2622d5ee
[02/24] virtio: Remove redundant test
        https://git.kernel.org/will/kvmtool/c/3a1e36e4bf49
[03/24] virtio/vsock: Remove redundant state tracking
        https://git.kernel.org/will/kvmtool/c/a8e397bb9dd9
[04/24] virtio: Factor virtqueue initialization
        https://git.kernel.org/will/kvmtool/c/fd41cde06617
[05/24] virtio: Support modern virtqueue addresses
        https://git.kernel.org/will/kvmtool/c/609ee9066879
[06/24] virtio: Add config access helpers
        https://git.kernel.org/will/kvmtool/c/15e6c4e74d06
[07/24] virtio: Fix device-specific config endianness
        https://git.kernel.org/will/kvmtool/c/867b15ccd7da
[08/24] virtio/console: Remove unused callback
        https://git.kernel.org/will/kvmtool/c/17ad9fd6ce37
[09/24] virtio: Remove set_guest_features() device op
        https://git.kernel.org/will/kvmtool/c/902a8ecb3877
[10/24] Add memcpy_fromiovec_safe
        https://git.kernel.org/will/kvmtool/c/c492534f3ac9
[11/24] virtio/net: Offload vnet header endianness conversion to tap
        https://git.kernel.org/will/kvmtool/c/8b27bcff44fd
[12/24] virtio/net: Prepare for modern virtio
        https://git.kernel.org/will/kvmtool/c/b231683c3361
[13/24] virtio/net: Implement VIRTIO_F_ANY_LAYOUT feature
        https://git.kernel.org/will/kvmtool/c/6daffe57762c
[14/24] virtio/console: Add VIRTIO_F_ANY_LAYOUT feature
        https://git.kernel.org/will/kvmtool/c/e74b56e1495c
[15/24] virtio/blk: Implement VIRTIO_F_ANY_LAYOUT feature
        https://git.kernel.org/will/kvmtool/c/484278913807
[16/24] virtio/pci: Factor MSI route creation
        https://git.kernel.org/will/kvmtool/c/f44af23e3a62

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

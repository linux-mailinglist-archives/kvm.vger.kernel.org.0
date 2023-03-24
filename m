Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C31C6C847B
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 19:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbjCXSH0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 14:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232224AbjCXSHM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 14:07:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE711E9DD
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 11:05:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E92AB825BB
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 18:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27F4C433D2;
        Fri, 24 Mar 2023 18:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679681149;
        bh=P3yN+CCt8uhbOyw0LNZjitJt7nsU6St31cQw/l8EIac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qzzSOHTaq3G4bRTquXavAhI7WNSLkGm7oe0saREQu7uxzD3bCtMpLkkjCHNE2u7y/
         2DYGMWVejgyX5Os8RNLD4iMDKszc0MFoizWLHiL8+k1vzb+UR/5xikfCwuQoSQQXu+
         erditVi7ZMOJtrxYPwFJPaIheS89rYzP9evzTL5gOIE+nC0RgjZTUpDyGIC/x74cqK
         L1lnzKYOo/9RQ1XWISxX+Bm+3A97YZRSuCm7ku6Y4x/+vak4UzST8bgfU9CPE9UQ8R
         3nAl5H0AwmFG41tbgnrnjC+2YL7x/FzXv3UIg/3NgN4vc6c+JVSsQ5Cogyul08kCXG
         XxYbETUXPStRg==
From:   Will Deacon <will@kernel.org>
To:     Rajnesh Kanwal <rkanwal@rivosinc.com>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, jean-philippe@linaro.org,
        maz@kernel.org, kvm@vger.kernel.org, atishp@rivosinc.com,
        julien.thierry.kdev@gmail.com, apatel@ventanamicro.com,
        andre.przywara@arm.com, alexandru.elisei@arm.com
Subject: Re: [PATCH kvmtool v3] Add virtio-transport option and deprecate force-pci and virtio-legacy.
Date:   Fri, 24 Mar 2023 18:05:42 +0000
Message-Id: <167967946029.939081.10542050560973915388.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230320143344.404307-1-rkanwal@rivosinc.com>
References: <20230320143344.404307-1-rkanwal@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Mar 2023 14:33:44 +0000, Rajnesh Kanwal wrote:
> This is a follow-up patch for [0] which proposed the --force-pci option
> for riscv. As per the discussion it was concluded to add virtio-tranport
> option taking in four options (pci, pci-legacy, mmio, mmio-legacy).
> 
> With this change force-pci and virtio-legacy are both deprecated and
> arm's default transport changes from MMIO to PCI as agreed in [0].
> This is also true for riscv.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] Add virtio-transport option and deprecate force-pci and virtio-legacy.
      https://git.kernel.org/will/kvmtool/c/9b46ebc561d3

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

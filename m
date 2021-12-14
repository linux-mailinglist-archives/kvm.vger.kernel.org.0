Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF315474639
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 16:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235294AbhLNPSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 10:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234452AbhLNPSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 10:18:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3D4C061574
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 07:18:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B964661581
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 15:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09214C34606;
        Tue, 14 Dec 2021 15:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639495111;
        bh=UriMdmZ+AeOcoV1G6zXI5X5WLwoTiyx3V7TzycPA3Iw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SXtg3Fja4XqrPdOh8vzLdLyXU91ULFx81uw3C98I8xDWECgWZsvBUHUdv66EQxyqM
         aXXf0YJZW49Z3adgDw1KXojU2Q7z8EuLwE5YPAaQqwpduMktKNYdaDYYPxjqHSVPWl
         a9kSBJr/QnMfC8EArXmDKGRzt0A2EFN1jVxXiG+qssbpijILfnWWZ5Ocy/d4y05zVk
         w8qxT10EdoHeyUC4JnfELaA2ZOkdxb0EnwstBhEdPegkCkGrS6b2JF9cK/+ly2QEEH
         1dLwOzdJTJpKXtq+8R2bgPJdkcyD1iYH5LsrJ1kA2BuI60Ea1DeV8Ri/Gai0mbbB4B
         5YqPMbAE8NvVA==
From:   Will Deacon <will@kernel.org>
To:     julien.thierry.kdev@gmail.com, kvm@vger.kernel.org,
        Sathyam Panda <panda.sathyam9@gmail.com>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, jean-philippe@linaro.org,
        alexandru.elisei@arm.com, sathyam.panda@arm.com,
        andre.przywara@arm.com, vivek.gautam@arm.com
Subject: Re: [PATCH kvmtool RESENT] arm/pci: update interrupt-map only for legacy interrupts
Date:   Tue, 14 Dec 2021 15:18:13 +0000
Message-Id: <163949402712.3919523.5844807265902321769.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211111120231.5468-1-sathyam.panda@arm.com>
References: <20211111120231.5468-1-sathyam.panda@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 11 Nov 2021 12:02:31 +0000, Sathyam Panda wrote:
> The interrupt pin cell in "interrupt-map" property
> is defined only for legacy interrupts with a valid
> range in [1-4] corrspoding to INTA#..INTD#. And the
> PCI endpoint devices that support advance interrupt
> mechanism like MSI or MSI-X should not have an entry
> with value 0 in "interrupt-map". This patch takes
> care of this problem by avoiding redundant entries.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] arm/pci: update interrupt-map only for legacy interrupts
      https://git.kernel.org/will/kvmtool/c/7a60af05c183

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

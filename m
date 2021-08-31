Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5863FCA85
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 17:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238577AbhHaPHC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 11:07:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230237AbhHaPHA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Aug 2021 11:07:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC51860F9E;
        Tue, 31 Aug 2021 15:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630422365;
        bh=ViEcZriqNGftF6CD6GvE421AsLC+XWVHOYgf9s6bi40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ucV/l2krKJt53NOLNvrINOu+/Vf0KBjb+f7K+Yg9yirJro99zhofmSGOkgMkGuU9M
         HANpEBMBspd9KoD1rFuzb2rV4cUy2hGFuGRGEOKwkVGXUFI06eC/y2NAUxz+pnA793
         B3LFHqG0VGfB8R0dTjllr9lVv0lylGd0Cy175lRXA9VN74GQzq6SYySYJzTc7yZCie
         Ex8Or2SMqEq3V0SexX605y06M3BVe+ykaf0BGx+Wid/Mpt+za3tArccRz3DQdSS3tW
         7O4IBNlZy45gZ0yIMLKUJISoL5ECmbawIljG/R+p9eYuH3B7QWR7P5CJfOrw1E9UtV
         Dgl2UjBhjhpcA==
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH][kvmtool] virtio/pci: Size the MSI-X bar according to the number of MSI-X
Date:   Tue, 31 Aug 2021 16:05:56 +0100
Message-Id: <163042127389.1911500.12320690511273820628.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210827115405.1981529-1-maz@kernel.org>
References: <20210827115405.1981529-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 27 Aug 2021 12:54:05 +0100, Marc Zyngier wrote:
> Since 45d3b59e8c45 ("kvm tools: Increase amount of possible interrupts
> per PCI device"), the number of MSI-S has gone from 4 to 33.
> 
> However, the corresponding storage hasn't been upgraded, and writing
> to the MSI-X table is a pretty risky business. Now that the Linux
> kernel writes to *all* MSI-X entries before doing anything else
> with the device, kvmtool dies a horrible death.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] virtio/pci: Size the MSI-X bar according to the number of MSI-X
      https://git.kernel.org/will/kvmtool/c/2e7380db438d

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

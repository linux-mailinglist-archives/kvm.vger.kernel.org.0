Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916E42139CA
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 14:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgGCMHy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 08:07:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725984AbgGCMHy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jul 2020 08:07:54 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99EB2207D4;
        Fri,  3 Jul 2020 12:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593778074;
        bh=nUh9op6CAi0IxgUhuOMPaGPv8W0mnewfQsFgLajKM8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZWokXalUsEEfKxEaYWHe/VpbopWzUYcyJ4zepSldCNmsSsiiH8ltKSHNVgRIWa0uY
         C2nz+c2xriblDEx6x+1Ufpv95aHv5UqXZmkXBi/xabSVE02/ZVo+WViIgK8tSQCQip
         1ifUGemUJwM7wQgRe0A0U6TojMLaLbJ01JloK4Rk=
From:   Will Deacon <will@kernel.org>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        andre.przywara@arm.com, linux-arm-kernel@lists.infradead.org,
        Sami Mujawar <sami.mujawar@arm.com>
Subject: Re: [PATCH] kvmtool: arm64: Report missing support for 32bit guests
Date:   Fri,  3 Jul 2020 13:07:48 +0100
Message-Id: <159377741751.260263.15198073437610178444.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200701142002.51654-1-suzuki.poulose@arm.com>
References: <20200701142002.51654-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 1 Jul 2020 15:20:02 +0100, Suzuki K Poulose wrote:
> When the host doesn't support 32bit guests, the kvmtool fails
> without a proper message on what is wrong. i.e,
> 
>  $ lkvm run -c 1 Image --aarch32
>   # lkvm run -k Image -m 256 -c 1 --name guest-105618
>   Fatal: Unable to initialise vcpu
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] kvmtool: arm64: Report missing support for 32bit guests
      https://git.kernel.org/will/kvmtool/c/351d931f496a

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

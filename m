Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3010368142
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 15:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235977AbhDVNLT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 09:11:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230005AbhDVNLR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 09:11:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7393160FF1;
        Thu, 22 Apr 2021 13:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619097042;
        bh=w5sXlLF70Z413juhDaKlUm4jbVBoVeustbBPoJbzpnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NEnwxHigM3F//1ZmOB2dEBv2LJWo3PQSTY979NNCbeGxlAjgb+jigXEkVlEB4mohQ
         FmvJmD7bkq1yVQyimt1VV5JEYZgmPu7KEobQXq2tI/fkT+gJ62ch53uh9YlrO38P2e
         1iFre8BfbVrUzxCTeVRYacD1yVs3bx6VPXJXEv0tvKLqdpRo+a6Vk4AOqWWCz5cUnd
         v5epHz+5aUHOWd6CBDTUB6RViInPPMUU1se+7DxtEJvhv3KTGn3U6Yh+YfHEJ6kf6Q
         QgzKbuC/bTyPc8kVOJJYi8vtX0IGGeEj9lkbb8XAPo9zWKmkO6EpXthZXbLg2JW+TG
         LO98WGmLA6tEg==
From:   Will Deacon <will@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        julien.thierry.kdev@gmail.com,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH kvmtool] arm: Fail early if KVM_CAP_ARM_PMU_V3 is not supported
Date:   Thu, 22 Apr 2021 14:10:37 +0100
Message-Id: <161909655048.2359255.9892790598815356092.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210415131725.105675-1-alexandru.elisei@arm.com>
References: <20210415131725.105675-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 15 Apr 2021 14:17:25 +0100, Alexandru Elisei wrote:
> pmu__generate_fdt_nodes() checks if the host has support for PMU in a guest
> and prints a warning if that's not the case. However, this check is too
> late because the function is called after the VCPU has been created, and
> VCPU creation fails if KVM_CAP_ARM_PMU_V3 is not available with a rather
> unhelpful error:
> 
> $ ./vm run -c1 -m64 -f selftest.flat --pmu
>   # lkvm run --firmware selftest.flat -m 64 -c 1 --name guest-1039
>   Info: Placing fdt at 0x80200000 - 0x80210000
>   Fatal: Unable to initialise vcpu
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] arm: Fail early if KVM_CAP_ARM_PMU_V3 is not supported
      https://git.kernel.org/will/kvmtool/c/415f92c33a22

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD34D2333A6
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 15:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbgG3N6F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 09:58:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727966AbgG3N6E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 09:58:04 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 368962074B;
        Thu, 30 Jul 2020 13:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596117484;
        bh=I4VtO+RvTl5dHcnmis2rhMN15keqAvYuB5FZEdImv3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bm9nVVGjGZ7XYNnFoyAkAmwjyW5kA9q1IsWKYLKaXwYx5CxsIH156XdZeWk+HBeOn
         nkjkN6aIgkq/OSSDn08riSiwgRXr2P9h+M3dHPFJmZk2HRzvSiuVcc3IOnBZLRq4lG
         bbcdjhffeKKlT7hQJnfY11YZKzgeDrmUju2alRl8=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k194M-00GH3a-Mo; Thu, 30 Jul 2020 14:58:02 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Alexander Graf <graf@amazon.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        kvmarm@lists.cs.columbia.edu,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH] KVM: arm: Add trace name for ARM_NISV
Date:   Thu, 30 Jul 2020 14:57:56 +0100
Message-Id: <159611742543.1691243.7923791390001583960.b4-ty@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200730094441.18231-1-graf@amazon.com>
References: <20200730094441.18231-1-graf@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: graf@amazon.com, kvm@vger.kernel.org, pbonzini@redhat.com, xypron.glpk@gmx.de, linux-kernel@vger.kernel.org, christoffer.dall@arm.com, kvmarm@lists.cs.columbia.edu, vkuznets@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 30 Jul 2020 11:44:41 +0200, Alexander Graf wrote:
> Commit c726200dd106d ("KVM: arm/arm64: Allow reporting non-ISV data aborts
> to userspace") introduced a mechanism to deflect MMIO traffic the kernel
> can not handle to user space. For that, it introduced a new exit reason.
> 
> However, it did not update the trace point array that gives human readable
> names to these exit reasons inside the trace log.
> 
> [...]

Applied to kvm-arm64/misc-5.9, thanks!

[1/1] KVM: arm: Add trace name for ARM_NISV
      commit: 1ccf2fe35c30f79102ad129c5aa71059daaaed7f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



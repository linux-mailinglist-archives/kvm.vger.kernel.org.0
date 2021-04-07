Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034B3356F4D
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 16:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244523AbhDGOwX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 10:52:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232041AbhDGOwW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 10:52:22 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19AB961363;
        Wed,  7 Apr 2021 14:52:13 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lU9XN-00665o-Vi; Wed, 07 Apr 2021 15:52:10 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, alexandru.elisei@arm.com, drjones@redhat.com,
        eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org
Cc:     james.morse@arm.com, suzuki.poulose@arm.com, pbonzini@redhat.com,
        shuah@kernel.org
Subject: Re: [PATCH] KVM: selftests: vgic_init kvm selftests fixup
Date:   Wed,  7 Apr 2021 15:52:04 +0100
Message-Id: <161780711779.1927596.2664047995521276237.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210407135937.533141-1-eric.auger@redhat.com>
References: <20210407135937.533141-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alexandru.elisei@arm.com, drjones@redhat.com, eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, pbonzini@redhat.com, shuah@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 7 Apr 2021 15:59:37 +0200, Eric Auger wrote:
> Bring some improvements/rationalization over the first version
> of the vgic_init selftests:
> 
> - ucall_init is moved in run_cpu()
> - vcpu_args_set is not called as not needed
> - whenever a helper is supposed to succeed, call the non "_" version
> - helpers do not return -errno, instead errno is checked by the caller
> - vm_gic struct is used whenever possible, as well as vm_gic_destroy
> - _kvm_create_device takes an addition fd parameter

Applied to kvm-arm64/vgic-5.13, thanks!

[1/1] KVM: selftests: vgic_init kvm selftests fixup
      commit: 4cffb2df4260ed38c7ae4105f6913ad2d71a16ec

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



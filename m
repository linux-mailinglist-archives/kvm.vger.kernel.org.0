Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 882363C834C
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 12:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbhGNK7h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 06:59:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229836AbhGNK7g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 06:59:36 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2946761363;
        Wed, 14 Jul 2021 10:56:45 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1m3cZH-00DGup-2m; Wed, 14 Jul 2021 11:56:43 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, Andrew Jones <drjones@redhat.com>,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: Re: [PATCH 0/2] KVM: selftests: a couple fixes
Date:   Wed, 14 Jul 2021 11:56:38 +0100
Message-Id: <162626019253.574894.16521023581512885892.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210713203742.29680-1-drjones@redhat.com>
References: <20210713203742.29680-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, drjones@redhat.com, kvm@vger.kernel.org, pbonzini@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Jul 2021 22:37:40 +0200, Andrew Jones wrote:
> The first removes a compiler warning. The second does what a 6 patch
> patch series wanted to do, but apparently got too distracted with
> the preparation refactoring to actually do...
> 
> Andrew Jones (2):
>   KVM: selftests: change pthread_yield to sched_yield
>   KVM: arm64: selftests: get-reg-list: actually enable pmu regs in pmu
>     sublist
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: selftests: change pthread_yield to sched_yield
      commit: bac0b135907855e9f8c032877c3df3c60885a08f
[2/2] KVM: arm64: selftests: get-reg-list: actually enable pmu regs in pmu sublist
      commit: 5cf17746b302aa32a4f200cc6ce38865bfe4cf94

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



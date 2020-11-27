Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1AB2C7461
	for <lists+kvm@lfdr.de>; Sat, 28 Nov 2020 23:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388584AbgK1Vtl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Nov 2020 16:49:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:34150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726685AbgK0Trk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Nov 2020 14:47:40 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4072420885;
        Fri, 27 Nov 2020 19:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606506456;
        bh=E4Xw2UALw2gG/o50RD2ZdpFI8M+G0YGs2VL7UrXLG+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zLSL2n69ZTVMec7aXivZFZwiWnc8hmiCL+kG42eiRgWS1zrtud7RU4tTe1g3x3F9i
         uXhRol7nuo+fyqG8fm9hKxDseEo6UxZIDEPoe023pfnneuj4LjmQJEaJlF8CjABilc
         DhlBv+8qnx0gkC0srhbKfErAkWpkmd0vj64PvreM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kijiQ-00E9BK-B8; Fri, 27 Nov 2020 19:47:34 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Jones <drjones@redhat.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: Re: [PATCH 0/2] KVM: arm64: Fix DEMUX register access
Date:   Fri, 27 Nov 2020 19:47:30 +0000
Message-Id: <160650643709.6468.11593626862508119672.b4-ty@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201126134641.35231-1-drjones@redhat.com>
References: <20201126134641.35231-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 26 Nov 2020 14:46:39 +0100, Andrew Jones wrote:
> The first patch is a fix, but not one likely to ever truly be needed,
> as it's unlikely to find seven levels of cache. The bug was found
> while code reading. Writing the second patch was actually why I was
> reading the code. The issue being fixed for the get-reg-list test was
> found when running it on a different machine than what was used to
> develop it.
> 
> [...]

Applied to kvm-arm64/cache-demux, thanks!

[1/2] KVM: arm64: CSSELR_EL1 max is 13
      commit: c73a44161776f6e60d933717f3b34084b0a0eba0
[2/2] KVM: arm64: selftests: Filter out DEMUX registers
      commit: c6232bd40b2eda3819d108e6e3f621ec604e15d8

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



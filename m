Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F35763DD781
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 15:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233956AbhHBNqD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 09:46:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233863AbhHBNqC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 09:46:02 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E52060F6D;
        Mon,  2 Aug 2021 13:45:53 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mAYGN-002Spk-Pn; Mon, 02 Aug 2021 14:45:51 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH] KVM: ARM: count remote TLB flushes
Date:   Mon,  2 Aug 2021 14:45:47 +0100
Message-Id: <162791193623.3441939.13198222517993801713.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727103251.16561-1-pbonzini@redhat.com>
References: <20210727103251.16561-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 27 Jul 2021 12:32:51 +0200, Paolo Bonzini wrote:
> KVM/ARM has an architecture-specific implementation of
> kvm_flush_remote_tlbs; however, unlike the generic one,
> it does not count the flushes in kvm->stat.remote_tlb_flush,
> so that it inexorably remained stuck to zero.

Applied to next, thanks!

[1/1] KVM: ARM: count remote TLB flushes
      commit: 38f703663d4c82ead5b51b8860deeef19d6dcb6d

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA31C46B6D5
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 10:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbhLGJTa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 04:19:30 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:38918 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232973AbhLGJT3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 04:19:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2CDE2CE1A1B;
        Tue,  7 Dec 2021 09:15:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5495EC341C1;
        Tue,  7 Dec 2021 09:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638868556;
        bh=10f+R/8X0dYmS8o0i5pPW38pneCq/ge4D2wCUEIod3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h5Lrwf0waJd2VfML2Kgvv/cwYUn0enBDdkWhdyIDn5yE3GgfQ5pAisoR3YCiNbPh0
         YInR00F/+PQOmuh+I2JV9iyscRpRFNSp+zKtbss/Sz3ss8GUD197dTII+C/q8fPS1O
         z6ck22gMo34XNjqR0/XKSU5D/esMIJB+G/Xi2nbmrNaPLZ7aww7BZ+fx4HO7FicQ2o
         o4/GL/uWzyQWn8MJLFdwW4f0PeOY99y75NfHZWedI9nft6xI+F+eNwvrWvTMd++PBE
         /zBfCEnk+CiZrv1eHuppiqkxieOgS3JgIlvSALQL+v9fslwcsy0ASfapZNV1eXAU56
         eYLfz2jtGaCMw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1muWZm-00AShj-Ch; Tue, 07 Dec 2021 09:15:54 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: Drop stale kvm_is_transparent_hugepage() declaration
Date:   Tue,  7 Dec 2021 09:15:50 +0000
Message-Id: <163886853926.1894941.3531543799691674670.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211018151407.2107363-1-vkuznets@redhat.com>
References: <20211018151407.2107363-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, vkuznets@redhat.com, pbonzini@redhat.com, seanjc@google.com, jmattson@google.com, wanpengli@tencent.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 Oct 2021 17:14:07 +0200, Vitaly Kuznetsov wrote:
> kvm_is_transparent_hugepage() was removed in commit 205d76ff0684 ("KVM:
> Remove kvm_is_transparent_hugepage() and PageTransCompoundMap()") but its
> declaration in include/linux/kvm_host.h persisted. Drop it.

Applied to next, thanks!

[1/1] KVM: Drop stale kvm_is_transparent_hugepage() declaration
      commit: f0e6e6fa41b3d2aa1dcb61dd4ed6d7be004bb5a8

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



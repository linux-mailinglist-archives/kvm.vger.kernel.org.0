Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80BF81F4A22
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 01:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbgFIXbs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 19:31:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38354 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbgFIXbs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jun 2020 19:31:48 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jiniD-0005mQ-Lw; Tue, 09 Jun 2020 23:31:21 +0000
From:   Colin King <colin.king@canonical.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kvm: i8254: remove redundant assignment to pointer s
Date:   Wed, 10 Jun 2020 00:31:21 +0100
Message-Id: <20200609233121.1118683-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0.rc0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The pointer s is being assigned a value that is never read, the
assignment is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 arch/x86/kvm/i8254.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index febca334c320..a6e218c6140d 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -462,7 +462,6 @@ static int pit_ioport_write(struct kvm_vcpu *vcpu,
 		if (channel == 3) {
 			/* Read-Back Command. */
 			for (channel = 0; channel < 3; channel++) {
-				s = &pit_state->channels[channel];
 				if (val & (2 << channel)) {
 					if (!(val & 0x20))
 						pit_latch_count(pit, channel);
-- 
2.27.0.rc0


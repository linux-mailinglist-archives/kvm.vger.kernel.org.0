Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21221433073
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 10:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbhJSIGm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 04:06:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234704AbhJSIGk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 04:06:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0BAA6139D;
        Tue, 19 Oct 2021 08:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634630667;
        bh=tec3N26Ppj3HiN6XnRgihubCdhjpDSY4LAigZu83/u8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tHUasibGDKgOMPqbVa3yy31jaz86MII3c+HeUbc0odcKyo2dDxEgew+l1F+lL5eJ3
         8zc5U3379u+Wuk0mGZ5PZx0yQlfH1aWR9N+tUhdXUP/E9cNteKdi0/5vePojp7RYtL
         RrBaeTb88qfQPqgwDZffQKL08J8Yj6JHiJdjM5cEGfYpcZz/mXFNVj4y5w/6HaZQ6p
         J8bJRq8sFEgXsVWswBlIx92EqX2W4ZdzOwyDES0Vd0S8t1RpO0mIOyD7bkqdRW08eO
         ccdLhc2Lb7x+hYEFbYSVx+7nFghOTaIjyBIyoW35P2BpUH2oifrGjxIINsRaK1u4xb
         A+x5paxMCjuJQ==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1mck6j-001oJR-6m; Tue, 19 Oct 2021 09:04:25 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup.patel@wdc.com>,
        Atish Patra <atish.patra@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: [PATCH v3 13/23] Documentation: update vcpu-requests.rst reference
Date:   Tue, 19 Oct 2021 09:04:12 +0100
Message-Id: <1f62fdbd0dd9298a19c491447a4b415a8ef3bd69.1634630486.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1634630485.git.mchehab+huawei@kernel.org>
References: <cover.1634630485.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changeset 2f5947dfcaec ("Documentation: move Documentation/virtual to Documentation/virt")
renamed: Documentation/virtual/kvm/vcpu-requests.rst
to: Documentation/virt/kvm/vcpu-requests.rst.

Update its cross-reference accordingly.

Fixes: 2f5947dfcaec ("Documentation: move Documentation/virtual to Documentation/virt")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---

To mailbombing on a large number of people, only mailing lists were C/C on the cover.
See [PATCH v3 00/23] at: https://lore.kernel.org/all/cover.1634630485.git.mchehab+huawei@kernel.org/

 arch/riscv/kvm/vcpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index c44cabce7dd8..260ce0779a32 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -912,7 +912,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 * Ensure we set mode to IN_GUEST_MODE after we disable
 		 * interrupts and before the final VCPU requests check.
 		 * See the comment in kvm_vcpu_exiting_guest_mode() and
-		 * Documentation/virtual/kvm/vcpu-requests.rst
+		 * Documentation/virt/kvm/vcpu-requests.rst
 		 */
 		vcpu->mode = IN_GUEST_MODE;
 
-- 
2.31.1


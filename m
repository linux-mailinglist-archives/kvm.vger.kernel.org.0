Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E929D4531DF
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 13:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235980AbhKPMOb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 07:14:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233974AbhKPMOX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 07:14:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF40261B39;
        Tue, 16 Nov 2021 12:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637064686;
        bh=n19PeZU2LLuo2IYYfWPaoxt6iBWjGOzxM2A7Hzh8IFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ug6fs3RRoPZhimt0+m9Po/TJeUUSn/FpTkvaEMogRWZ7DB6UE0v3nl3Xsf6+iesp9
         2uG7+JtqFBv9x69AQL1MrMTd2NhopHcS/uySnwaT5v2ZaizPqb6y8drYKfkjssTSPV
         5sBFhf38UBtvkX/eMRVKWvhDL9DS/KN2PI6qcEOXOHTAqtEP9TRmtKtt1al5TenRyG
         6Y82rUwwo4fVZ4EXlEBoF+2cTmASqALH2KUQ6cCkQ0gl7Wg3+n1IEDT2selgFgZ0Io
         helbnK4wO1IXd0IZeAO9rQCHwDxnADhWyZ+PtO3DhErPDsfVYkFu7Sk1b71UMrhz6D
         vjtDm8BEW25wg==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1mmxJ6-00A9LX-CG; Tue, 16 Nov 2021 12:11:24 +0000
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
Subject: [PATCH 3/4] Documentation: update vcpu-requests.rst reference
Date:   Tue, 16 Nov 2021 12:11:22 +0000
Message-Id: <32b3693314f3914f10a42dea97ad6e06292fcd4a.1637064577.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1637064577.git.mchehab+huawei@kernel.org>
References: <cover.1637064577.git.mchehab+huawei@kernel.org>
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
Reviewed-by: Anup Patel <anup.patel@wdc.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---

To mailbombing on a large number of people, only mailing lists were C/C on the cover.
See [PATCH 0/4] at: https://lore.kernel.org/all/cover.1637064577.git.mchehab+huawei@kernel.org/

 arch/riscv/kvm/vcpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index e3d3aed46184..fb84619df012 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -740,7 +740,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 * Ensure we set mode to IN_GUEST_MODE after we disable
 		 * interrupts and before the final VCPU requests check.
 		 * See the comment in kvm_vcpu_exiting_guest_mode() and
-		 * Documentation/virtual/kvm/vcpu-requests.rst
+		 * Documentation/virt/kvm/vcpu-requests.rst
 		 */
 		vcpu->mode = IN_GUEST_MODE;
 
-- 
2.33.1


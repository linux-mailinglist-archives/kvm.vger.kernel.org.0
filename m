Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2D0015DA0D
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 15:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387484AbgBNO7e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 09:59:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52699 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729479AbgBNO7d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 09:59:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581692372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MeFvLL1/+GA3tvHrsl7+s0QSGTgmzZDA+Wib0aNqzc8=;
        b=Ze7JeI35No8qGX4wM9p9LLXLCjnR9kUKbOXUViqSdhtPD4wX1OSymTDPmc/zdvZuvsxYuO
        l1HL4k0eap1ipDGeAo5UUkxv2E5B4lRy5Gl8xvlsgUVqm9lfNoCPt1n5yCftMSJ0v4xQ+1
        s4z7sxb+Zu07cYk5Ea3FTVFNQHvbP8M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371--9_Ob5YcNiSVqgFwbgL7Pg-1; Fri, 14 Feb 2020 09:59:31 -0500
X-MC-Unique: -9_Ob5YcNiSVqgFwbgL7Pg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2591419057A1;
        Fri, 14 Feb 2020 14:59:30 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 70CC919E9C;
        Fri, 14 Feb 2020 14:59:28 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, thuth@redhat.com, peterx@redhat.com
Subject: [PATCH 02/13] fixup! KVM: selftests: Add support for vcpu_args_set to aarch64 and s390x
Date:   Fri, 14 Feb 2020 15:59:09 +0100
Message-Id: <20200214145920.30792-3-drjones@redhat.com>
In-Reply-To: <20200214145920.30792-1-drjones@redhat.com>
References: <20200214145920.30792-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[Fixed array index (num =3D> i) and made some style changes.]
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/lib/aarch64/processor.c     | 24 ++++---------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/=
testing/selftests/kvm/lib/aarch64/processor.c
index 839a76c96f01..f7dffccea12c 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -334,36 +334,20 @@ void vm_vcpu_add_default(struct kvm_vm *vm, uint32_=
t vcpuid, void *guest_code)
 	aarch64_vcpu_add_default(vm, vcpuid, NULL, guest_code);
 }
=20
-/* VM VCPU Args Set
- *
- * Input Args:
- *   vm - Virtual Machine
- *   vcpuid - VCPU ID
- *   num - number of arguments
- *   ... - arguments, each of type uint64_t
- *
- * Output Args: None
- *
- * Return: None
- *
- * Sets the first num function input arguments to the values
- * given as variable args.  Each of the variable args is expected to
- * be of type uint64_t. The registers set by this function are r0-r7.
- */
 void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num,=
 ...)
 {
 	va_list ap;
 	int i;
=20
 	TEST_ASSERT(num >=3D 1 && num <=3D 8, "Unsupported number of args,\n"
-		    "  num: %u\n",
-		    num);
+		    "  num: %u\n", num);
=20
 	va_start(ap, num);
=20
-	for (i =3D 0; i < num; i++)
-		set_reg(vm, vcpuid, ARM64_CORE_REG(regs.regs[num]),
+	for (i =3D 0; i < num; i++) {
+		set_reg(vm, vcpuid, ARM64_CORE_REG(regs.regs[i]),
 			va_arg(ap, uint64_t));
+	}
=20
 	va_end(ap);
 }
--=20
2.21.1


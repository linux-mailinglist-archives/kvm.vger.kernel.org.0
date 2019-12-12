Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF6F11C378
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 03:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbfLLCpb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 21:45:31 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:60788 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727879AbfLLCpa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Dec 2019 21:45:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576118729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vVBnTdpElxP7oPw8MW4U3TzLCcSf5UiwUt7vzIeW4ps=;
        b=KDRzkLEhJj0gaQt9UdggpFq4eXkoZaPWQl/rrfiphS+g6gBsXpC/Jhx7GagDAyFzxit9CW
        FG1HWoMgbCTsmTd2UkwRvwPGy9qCGkoQFF5QpB4tpr9FTVGWpbe+Ts2l+lH5ImeLBBzwQQ
        MFYNS/SV9zMPqL3tNssOUMA6hLC6PEc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-G0VUWj9PM5qw6TyRw48vBw-1; Wed, 11 Dec 2019 21:45:28 -0500
X-MC-Unique: G0VUWj9PM5qw6TyRw48vBw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8142F800D4C;
        Thu, 12 Dec 2019 02:45:27 +0000 (UTC)
Received: from localhost.localdomain.com (vpn2-54-40.bne.redhat.com [10.64.54.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 699A46609A;
        Thu, 12 Dec 2019 02:45:24 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, paulus@ozlabs.org,
        maz@kernel.org, jhogan@kernel.org, drjones@redhat.com,
        vkuznets@redhat.com, gshan@redhat.com
Subject: [PATCH 1/3] kvm/mips: Standardize kvm exit reason field
Date:   Thu, 12 Dec 2019 13:45:10 +1100
Message-Id: <20191212024512.39930-2-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This standardizes kvm exit reason field name by replacing "reason"
with "exit_reason".

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/mips/kvm/trace.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/mips/kvm/trace.h b/arch/mips/kvm/trace.h
index a8c7fd7bf6d2..acbbe3fff9de 100644
--- a/arch/mips/kvm/trace.h
+++ b/arch/mips/kvm/trace.h
@@ -113,20 +113,20 @@ DEFINE_EVENT(kvm_transition, kvm_out,
 	{ KVM_TRACE_EXIT_GPA,		"GPA" }
=20
 TRACE_EVENT(kvm_exit,
-	    TP_PROTO(struct kvm_vcpu *vcpu, unsigned int reason),
-	    TP_ARGS(vcpu, reason),
+	    TP_PROTO(struct kvm_vcpu *vcpu, unsigned int exit_reason),
+	    TP_ARGS(vcpu, exit_reason),
 	    TP_STRUCT__entry(
 			__field(unsigned long, pc)
-			__field(unsigned int, reason)
+			__field(unsigned int, exit_reason)
 	    ),
=20
 	    TP_fast_assign(
 			__entry->pc =3D vcpu->arch.pc;
-			__entry->reason =3D reason;
+			__entry->exit_reason =3D exit_reason;
 	    ),
=20
 	    TP_printk("[%s]PC: 0x%08lx",
-		      __print_symbolic(__entry->reason,
+		      __print_symbolic(__entry->exit_reason,
 				       kvm_trace_symbol_exit_types),
 		      __entry->pc)
 );
--=20
2.23.0


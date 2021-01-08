Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E972EF0F3
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 11:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbhAHK4S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 05:56:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34570 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727646AbhAHK4R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 Jan 2021 05:56:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610103291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=UoWmJXSbQgP5GKJxH0Tujf7dGsDbgivX1oOEbaf2iwM=;
        b=Kk+AkL0BOFXATreSCJoiHhfuVGcDch4X3nPchMMFI3IF977/gKGy69+eJgd90ZKCBCvOKC
        yXgiPkl/8UPS1ePoOqsbWXUo0gCCQdpzX5tlMoyi7Mj5pjdNL1dcU/2YSwzLTB5OTGClZF
        tgcmdfJ31wvUWcn+dfGrCZwiltdrnyA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-imqUcbM9OqyMTgXQMTMqwg-1; Fri, 08 Jan 2021 05:54:49 -0500
X-MC-Unique: imqUcbM9OqyMTgXQMTMqwg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 884B710054FF;
        Fri,  8 Jan 2021 10:54:48 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A0D75D9C0;
        Fri,  8 Jan 2021 10:54:48 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: x86: __kvm_vcpu_halt can be static
Date:   Fri,  8 Jan 2021 05:54:47 -0500
Message-Id: <20210108105447.37906-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0287840b93e0..a480804ae27a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7976,7 +7976,7 @@ void kvm_arch_exit(void)
 	kmem_cache_destroy(x86_fpu_cache);
 }
 
-int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason)
+static int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason)
 {
 	++vcpu->stat.halt_exits;
 	if (lapic_in_kernel(vcpu)) {
-- 
2.26.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28BB7201A9F
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 20:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388231AbgFSSqj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 14:46:39 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57475 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731358AbgFSSqi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jun 2020 14:46:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592592397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uQl6Bsxc7SVXJaJ585YknvsUaymV8f0R9mIn/btW8+M=;
        b=NnsZGKvwvemaBqKGZYiuap1v1vX7gn8Gj4t77RLikrYRscERjtmHRIxKhGK/PVDksSLGNc
        hlHZkPWXi7iNd1BqM+SQ9cjCauf+MlHanEPZUTLB4DAmkDQM7/6UAHiRfWmyDP+/YZu53O
        aXQqECWnUIEpCyocatLjng77yHOwRg0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-O1iWbGyQNDmjbjjmCAYc-Q-1; Fri, 19 Jun 2020 14:46:35 -0400
X-MC-Unique: O1iWbGyQNDmjbjjmCAYc-Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC3951052508;
        Fri, 19 Jun 2020 18:46:34 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E601960BF4;
        Fri, 19 Jun 2020 18:46:32 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, steven.price@arm.com
Subject: [PATCH 1/4] KVM: Documentation minor fixups
Date:   Fri, 19 Jun 2020 20:46:26 +0200
Message-Id: <20200619184629.58653-2-drjones@redhat.com>
In-Reply-To: <20200619184629.58653-1-drjones@redhat.com>
References: <20200619184629.58653-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 Documentation/virt/kvm/api.rst | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 426f94582b7a..9a12ea498dbb 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6121,7 +6121,7 @@ HvCallSendSyntheticClusterIpi, HvCallSendSyntheticClusterIpiEx.
 8.21 KVM_CAP_HYPERV_DIRECT_TLBFLUSH
 -----------------------------------
 
-:Architecture: x86
+:Architectures: x86
 
 This capability indicates that KVM running on top of Hyper-V hypervisor
 enables Direct TLB flush for its guests meaning that TLB flush
@@ -6134,16 +6134,17 @@ in CPUID and only exposes Hyper-V identification. In this case, guest
 thinks it's running on Hyper-V and only use Hyper-V hypercalls.
 
 8.22 KVM_CAP_S390_VCPU_RESETS
+-----------------------------
 
-Architectures: s390
+:Architectures: s390
 
 This capability indicates that the KVM_S390_NORMAL_RESET and
 KVM_S390_CLEAR_RESET ioctls are available.
 
 8.23 KVM_CAP_S390_PROTECTED
+---------------------------
 
-Architecture: s390
-
+:Architectures: s390
 
 This capability indicates that the Ultravisor has been initialized and
 KVM can therefore start protected VMs.
-- 
2.25.4


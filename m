Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610263E4458
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 13:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234930AbhHILBw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 07:01:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36580 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234354AbhHILBv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Aug 2021 07:01:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628506890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=I4iw7fn0YB8IrJWVg7SMxyrXhBb76FvYytxPyMw8j2Y=;
        b=Np+7H6ULMwIv+eIZCI9bQVX4t5PkCyConeyQuQwvNUvFg5qgmCzLxzoBU5FFsDrvkch4fe
        ha2GA6ygKqlK0edfrhTlwnZ6/gDC0YMywJR64Qhsh+ZUbtTBJUHxzry7swkE3SSEhfqN8a
        uUF2PRVPAK7SyAYH76SZIEaUqEGs8pw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-0Oz19N7BN1-sp-Y4tGaTpg-1; Mon, 09 Aug 2021 07:01:29 -0400
X-MC-Unique: 0Oz19N7BN1-sp-Y4tGaTpg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FBD71940940;
        Mon,  9 Aug 2021 11:01:21 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 954C777302;
        Mon,  9 Aug 2021 11:01:20 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>
Subject: [PATCH] KVM: x86: remove dead initialization
Date:   Mon,  9 Aug 2021 07:01:20 -0400
Message-Id: <20210809110120.3237065-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

hv_vcpu is initialized again a dozen lines below, so remove the
initializer.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/hyperv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index e9582db29a99..2da21e45da99 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1968,7 +1968,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *entry;
-	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+	struct kvm_vcpu_hv *hv_vcpu;
 
 	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_INTERFACE, 0);
 	if (entry && entry->eax == HYPERV_CPUID_SIGNATURE_EAX) {
-- 
2.27.0


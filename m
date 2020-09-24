Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF621277475
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 16:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgIXO6O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 10:58:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42254 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728199AbgIXO6N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 10:58:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600959491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DNn4YwQRBHPa5GtdZ/7RYlHQGoNXgh5enMfZlg0F2Yk=;
        b=iscagfQBHrukzWQkGkj3I/FkCJ8YjpxB9AmecsI3pF8NHBEqt5Lw4RqkHB7bzfRPfeBlUo
        HVYhretRsokbdEy/ykCwsDf/XKRT+NgKp3n4UTFPFqt62n/lxUMb7mkxFlqr9jGd2H+0oF
        pxNqOo0kdJjV2CrH1Un7s8ZAInRQUBM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-U6Dcz271NvWFnJeHznogyw-1; Thu, 24 Sep 2020 10:58:06 -0400
X-MC-Unique: U6Dcz271NvWFnJeHznogyw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C2121882FCB;
        Thu, 24 Sep 2020 14:58:04 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECC7555786;
        Thu, 24 Sep 2020 14:58:01 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jon Doron <arilou@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/7] KVM: x86: hyper-v: Mention SynDBG CPUID leaves in api.rst
Date:   Thu, 24 Sep 2020 16:57:51 +0200
Message-Id: <20200924145757.1035782-2-vkuznets@redhat.com>
In-Reply-To: <20200924145757.1035782-1-vkuznets@redhat.com>
References: <20200924145757.1035782-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We forgot to update KVM_GET_SUPPORTED_HV_CPUID's documentation in api.rst
when SynDBG leaves were added.

While on it, fix 'KVM_GET_SUPPORTED_CPUID' copy-paste error.

Fixes: f97f5a56f597 ("x86/kvm/hyper-v: Add support for synthetic debugger interface")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 Documentation/virt/kvm/api.rst | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d2b733dc7892..f0e9582c6b44 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4498,11 +4498,14 @@ Currently, the following list of CPUID leaves are returned:
  - HYPERV_CPUID_ENLIGHTMENT_INFO
  - HYPERV_CPUID_IMPLEMENT_LIMITS
  - HYPERV_CPUID_NESTED_FEATURES
+ - HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS
+ - HYPERV_CPUID_SYNDBG_INTERFACE
+ - HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES
 
 HYPERV_CPUID_NESTED_FEATURES leaf is only exposed when Enlightened VMCS was
 enabled on the corresponding vCPU (KVM_CAP_HYPERV_ENLIGHTENED_VMCS).
 
-Userspace invokes KVM_GET_SUPPORTED_CPUID by passing a kvm_cpuid2 structure
+Userspace invokes KVM_GET_SUPPORTED_HV_CPUID by passing a kvm_cpuid2 structure
 with the 'nent' field indicating the number of entries in the variable-size
 array 'entries'.  If the number of entries is too low to describe all Hyper-V
 feature leaves, an error (E2BIG) is returned. If the number is more or equal
-- 
2.25.4


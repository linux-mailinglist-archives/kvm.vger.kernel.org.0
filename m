Return-Path: <kvm+bounces-553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EE3E67E0C78
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 01:03:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8FCBDB217F8
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 00:03:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49B2F523F;
	Sat,  4 Nov 2023 00:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bVxgGu2l"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC284409
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 00:02:56 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0E6D52
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 17:02:53 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5b064442464so36572157b3.3
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 17:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699056172; x=1699660972; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yY/rmfF8uWP2qcFcrSxU2iBcqr1KyrUXkO4fHTVenYU=;
        b=bVxgGu2lCXmKuMm5QSCv4s4eEQMRPejB9mbV+VIMt8rwNnEbc4fGpD9gfpa/rIO62D
         a9YtZYAMX9/ZVajKB5TnBX6lraaMPSTFQGbb3kyLxn0b6AFUdHezzYwQviGz2GydGkWr
         js0oeQM1pRmxbl+jlS/Kk5Im2HNFp2H3XTCuHjtroLJi3sJl7vLc6MNeJrBi73Y+RZw/
         yanHmcJyR6NWW5VC96HE+sxYFKF/MkbkWAu43pvYUWD61Peq0k/g2ztgNUCEOmPR6Ez/
         blcVDM8flPsc/ljnxrf6iaeVLAXE0pTXboK1+CrKOv01ZvOPz8i4fsyCGEIxQSpkV+fi
         /BWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699056172; x=1699660972;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yY/rmfF8uWP2qcFcrSxU2iBcqr1KyrUXkO4fHTVenYU=;
        b=OKYJHM6e0ds7U7z7Q0jDgL4B1DMTj3TMkXjmVOxQbw3uj438X3hf4JV2QUCnPIHTy7
         Y2O2Rg8K/uqEZa1RRPte6MKWJLuR2L7o7g2QbXccz7E6l+0C9jdfC9Z/6RA6QYtt9vzA
         zgFrEEaAsUtPutY229RBuofX6OdH4dxSXEis+G30mfDsmlKzKBGQnCURgAZaBhDyHf26
         IYsES9mE9OY7mvs4M1GdWZLB2G8DYUcCLWc0W/lPF43t06cxx5qGNROH4IGDJzoTlaxl
         Ajxp/Brj4NbZlNOEVj+zcL+C2WKOzpt92/9s4Ur5P8rVRQSDFevU6BPksREzwvqQTJac
         zDBA==
X-Gm-Message-State: AOJu0YxdoEWchcftepswlZUNUeyEoK1YQECxhtO+qdcpwxN7bCAqxXem
	lSEkOKpWfKO3BtBtRnFrqoVWJCPl+/U=
X-Google-Smtp-Source: AGHT+IFwZt1P5Flriq9GqFcVYmLFgZ3LqYDtH2Fw5lrbDAOEtYZcr2cmtoQB2HW7yndqlTSKrdJ1ZHlMIX8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:9011:0:b0:da0:4f83:60c1 with SMTP id
 s17-20020a259011000000b00da04f8360c1mr432157ybl.9.1699056172262; Fri, 03 Nov
 2023 17:02:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Nov 2023 17:02:24 -0700
In-Reply-To: <20231104000239.367005-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231104000239.367005-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231104000239.367005-7-seanjc@google.com>
Subject: [PATCH v6 06/20] KVM: selftests: Add vcpu_set_cpuid_property() to set properties
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Like Xu <likexu@tencent.com>, 
	Jim Mattson <jmattson@google.com>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Jinrong Liang <cloudliang@tencent.com>

Add vcpu_set_cpuid_property() helper function for setting properties, and
use it instead of open coding an equivalent for MAX_PHY_ADDR.  Future vPMU
testcases will also need to stuff various CPUID properties.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/x86_64/processor.h |  4 +++-
 tools/testing/selftests/kvm/lib/x86_64/processor.c   | 12 +++++++++---
 .../kvm/x86_64/smaller_maxphyaddr_emulation_test.c   |  2 +-
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 25bc61dac5fb..a01931f7d954 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -994,7 +994,9 @@ static inline void vcpu_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu_ioctl(vcpu, KVM_GET_CPUID2, vcpu->cpuid);
 }
 
-void vcpu_set_cpuid_maxphyaddr(struct kvm_vcpu *vcpu, uint8_t maxphyaddr);
+void vcpu_set_cpuid_property(struct kvm_vcpu *vcpu,
+			     struct kvm_x86_cpu_property property,
+			     uint32_t value);
 
 void vcpu_clear_cpuid_entry(struct kvm_vcpu *vcpu, uint32_t function);
 void vcpu_set_or_clear_cpuid_feature(struct kvm_vcpu *vcpu,
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index d8288374078e..9e717bc6bd6d 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -752,11 +752,17 @@ void vcpu_init_cpuid(struct kvm_vcpu *vcpu, const struct kvm_cpuid2 *cpuid)
 	vcpu_set_cpuid(vcpu);
 }
 
-void vcpu_set_cpuid_maxphyaddr(struct kvm_vcpu *vcpu, uint8_t maxphyaddr)
+void vcpu_set_cpuid_property(struct kvm_vcpu *vcpu,
+			     struct kvm_x86_cpu_property property,
+			     uint32_t value)
 {
-	struct kvm_cpuid_entry2 *entry = vcpu_get_cpuid_entry(vcpu, 0x80000008);
+	struct kvm_cpuid_entry2 *entry;
+
+	entry = __vcpu_get_cpuid_entry(vcpu, property.function, property.index);
+
+	(&entry->eax)[property.reg] &= ~GENMASK(property.hi_bit, property.lo_bit);
+	(&entry->eax)[property.reg] |= value << (property.lo_bit);
 
-	entry->eax = (entry->eax & ~0xff) | maxphyaddr;
 	vcpu_set_cpuid(vcpu);
 }
 
diff --git a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
index 06edf00a97d6..9b89440dff19 100644
--- a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
@@ -63,7 +63,7 @@ int main(int argc, char *argv[])
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vcpu);
 
-	vcpu_set_cpuid_maxphyaddr(vcpu, MAXPHYADDR);
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_MAX_PHY_ADDR, MAXPHYADDR);
 
 	rc = kvm_check_cap(KVM_CAP_EXIT_ON_EMULATION_FAILURE);
 	TEST_ASSERT(rc, "KVM_CAP_EXIT_ON_EMULATION_FAILURE is unavailable");
-- 
2.42.0.869.gea05f2083d-goog



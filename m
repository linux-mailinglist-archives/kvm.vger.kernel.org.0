Return-Path: <kvm+bounces-1120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 631237E4E75
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 02:10:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C03CBB207E9
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 01:10:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC846A59;
	Wed,  8 Nov 2023 01:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KNk9X+yL"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BFC7EA
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 01:09:58 +0000 (UTC)
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31653181
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 17:09:58 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1cc42d3f61eso50142885ad.3
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 17:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699405797; x=1700010597; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XHnYIgeuYnPaMTfaU4V1KcO3tRZbF1dAHww2EEsDLec=;
        b=KNk9X+yLvbKdLq5WcyfQWz12nGw1FyLnYDKa0DuN3FbXt065ejG+wUWmz8EbOGU5S1
         lSJR651wz2wpp74PokcXQdh2A/dm3Q4n08cojyafO5X1BpPZq8QdPzK7lzgo0CDa6NKv
         TkMAlukBF2n3R9yHRmdGhlwj8BZ1yfjP/S8yWBYU7GxXU80FGSye2nf8kMxgoJAxk3bG
         3lAqSihbrXhK+hUUBuAnl84vSVkB2q/esO8Y3i6itwCcGHz27o0pFLrIGp6MlxsNDZCG
         ir8irnJCxmcGQcBkgbLOfxgnjyiXYcWzg1bUFTsM/w0ix/gC4NO2fwG73pn7rPIofCEg
         +FoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699405797; x=1700010597;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XHnYIgeuYnPaMTfaU4V1KcO3tRZbF1dAHww2EEsDLec=;
        b=B1kaGfzxSRVi5YuOno4RdcKqi8EP2iyoBZT/UXKxHLCMO18gUJOG12fLjrAEVV1YbA
         OJ9bHOU/s95NkihMBPKqPzDCiBJvk4dtUg9FHhzhU0SZzLkKCoeA/ruw0Xxc1Ba1tI6Q
         4vLhGTL649AYrQmKvn5ZM2I4ErMKjmo7IGpKwL3G/bxhZOYXTQJdUQQO5EoYF45ARSKF
         OLsWEUbV3LHr1A1JPop/2qXSCYsJ7k6YOpYNVwuI2RjNNWETUtBc99LpL4/9ww0aaivH
         18K7UsT1HQZKh47Y6L9wIpKIqwev86MO+dJvWEQzSwwkrz4eSa7c7V7hWUqFrMP08QFq
         9k8g==
X-Gm-Message-State: AOJu0YwYeSofQC25mNcgC6/q7tt7ZgdleDHfCNl0ZyqiZS9WnWyk27E1
	GkJQtgvM91HxsmnqK1cWLKjp/LjX6o0=
X-Google-Smtp-Source: AGHT+IEtFZ5nQP+PVap4ZI1wAyHm+SCviDchK454xmpEndjoc1pqWDYIoQ76ldLEmceKCG5PH55ZNa74iaI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:aa08:b0:1cc:3da9:2b96 with SMTP id
 be8-20020a170902aa0800b001cc3da92b96mr11895plb.3.1699405797712; Tue, 07 Nov
 2023 17:09:57 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Nov 2023 17:09:52 -0800
In-Reply-To: <20231108010953.560824-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108010953.560824-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231108010953.560824-2-seanjc@google.com>
Subject: [PATCH v2 1/2] KVM: selftests: Drop the single-underscore ioctl() helpers
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Michal Luczaj <mhal@rbox.co>, Oliver Upton <oliver.upton@linux.dev>, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop _kvm_ioctl(), _vm_ioctl(), and _vcpu_ioctl(), as they are no longer
used by anything other than the no-underscores variants (and may have
never been used directly).  The single-underscore variants were never
intended to be a "feature", they were a stopgap of sorts to ease the
conversion to pretty printing ioctl() names when reporting errors.

Opportunistically add a comment explaining when to use __KVM_IOCTL_ERROR()
versus KVM_IOCTL_ERROR().  The single-underscore macros were subtly
ensuring that the name of the ioctl() was printed on error, i.e. it's all
too easy to overlook the fact that using __KVM_IOCTL_ERROR() is
intentional.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 42 +++++++++----------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index a18db6a7b3cf..1f6193dc7d3a 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -248,6 +248,13 @@ static inline bool kvm_has_cap(long cap)
 #define __KVM_SYSCALL_ERROR(_name, _ret) \
 	"%s failed, rc: %i errno: %i (%s)", (_name), (_ret), errno, strerror(errno)
 
+/*
+ * Use the "inner", double-underscore macro when reporting errors from within
+ * other macros so that the name of ioctl() and not its literal numeric value
+ * is printed on error.  The "outer" macro is strongly preferred when reporting
+ * errors "directly", i.e. without an additional layer of macros, as it reduces
+ * the probability of passing in the wrong string.
+ */
 #define __KVM_IOCTL_ERROR(_name, _ret)	__KVM_SYSCALL_ERROR(_name, _ret)
 #define KVM_IOCTL_ERROR(_ioctl, _ret) __KVM_IOCTL_ERROR(#_ioctl, _ret)
 
@@ -260,17 +267,13 @@ static inline bool kvm_has_cap(long cap)
 #define __kvm_ioctl(kvm_fd, cmd, arg)				\
 	kvm_do_ioctl(kvm_fd, cmd, arg)
 
-
-#define _kvm_ioctl(kvm_fd, cmd, name, arg)			\
+#define kvm_ioctl(kvm_fd, cmd, arg)				\
 ({								\
 	int ret = __kvm_ioctl(kvm_fd, cmd, arg);		\
 								\
-	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));	\
+	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(#cmd, ret));	\
 })
 
-#define kvm_ioctl(kvm_fd, cmd, arg) \
-	_kvm_ioctl(kvm_fd, cmd, #cmd, arg)
-
 static __always_inline void static_assert_is_vm(struct kvm_vm *vm) { }
 
 #define __vm_ioctl(vm, cmd, arg)				\
@@ -279,16 +282,12 @@ static __always_inline void static_assert_is_vm(struct kvm_vm *vm) { }
 	kvm_do_ioctl((vm)->fd, cmd, arg);			\
 })
 
-#define _vm_ioctl(vm, cmd, name, arg)				\
-({								\
-	int ret = __vm_ioctl(vm, cmd, arg);			\
-								\
-	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));	\
-})
-
 #define vm_ioctl(vm, cmd, arg)					\
-	_vm_ioctl(vm, cmd, #cmd, arg)
-
+({								\
+	int ret = __vm_ioctl(vm, cmd, arg);			\
+								\
+	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(#cmd, ret));	\
+})
 
 static __always_inline void static_assert_is_vcpu(struct kvm_vcpu *vcpu) { }
 
@@ -298,15 +297,12 @@ static __always_inline void static_assert_is_vcpu(struct kvm_vcpu *vcpu) { }
 	kvm_do_ioctl((vcpu)->fd, cmd, arg);			\
 })
 
-#define _vcpu_ioctl(vcpu, cmd, name, arg)			\
-({								\
-	int ret = __vcpu_ioctl(vcpu, cmd, arg);			\
-								\
-	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));	\
-})
-
 #define vcpu_ioctl(vcpu, cmd, arg)				\
-	_vcpu_ioctl(vcpu, cmd, #cmd, arg)
+({								\
+	int ret = __vcpu_ioctl(vcpu, cmd, arg);			\
+								\
+	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(#cmd, ret));	\
+})
 
 /*
  * Looks up and returns the value corresponding to the capability
-- 
2.42.0.869.gea05f2083d-goog



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB03D17F344
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 10:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgCJJQS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 05:16:18 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51371 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726481AbgCJJQR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Mar 2020 05:16:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583831775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=82Qwv8fAMe1153nHAMv9BlmiozM199Ub0ZSLaKOwxTY=;
        b=DCAZqi3oD3QP5VyE0PwfrFay129Bidm2CD+ZM2fUTStoP4aygJTog5QGGD9vz1EYRTIlYq
        VIOQa4BUSh/eOQ/cKXQ7A+flz1LMYJW4j6dkHfNLp+Ks8rD6gu3A3zj0Kn/ZhCyrRcRFW0
        yWBKUF7TSMTZO2HjqcY6z6M/JeE4hKA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-nwgYwSVPMjS6Fylo7A7paQ-1; Tue, 10 Mar 2020 05:16:14 -0400
X-MC-Unique: nwgYwSVPMjS6Fylo7A7paQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 36D898017DF;
        Tue, 10 Mar 2020 09:16:13 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCCE060C05;
        Tue, 10 Mar 2020 09:16:09 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, peterx@redhat.com,
        thuth@redhat.com
Subject: [PATCH 3/4] KVM: selftests: Enable printf format warnings for TEST_ASSERT
Date:   Tue, 10 Mar 2020 10:15:55 +0100
Message-Id: <20200310091556.4701-4-drjones@redhat.com>
In-Reply-To: <20200310091556.4701-1-drjones@redhat.com>
References: <20200310091556.4701-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the format attribute to enable printf format warnings, and
then fix them all.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c          | 2 +-
 tools/testing/selftests/kvm/include/test_util.h           | 3 ++-
 tools/testing/selftests/kvm/lib/kvm_util.c                | 8 ++++----
 tools/testing/selftests/kvm/x86_64/evmcs_test.c           | 4 ++--
 tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c         | 2 +-
 .../testing/selftests/kvm/x86_64/set_memory_region_test.c | 3 +--
 tools/testing/selftests/kvm/x86_64/state_test.c           | 4 ++--
 tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c      | 3 +--
 tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c   | 2 +-
 .../selftests/kvm/x86_64/vmx_set_nested_state_test.c      | 2 +-
 10 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/tes=
ting/selftests/kvm/demand_paging_test.c
index c1e326d3ed7f..47654071544c 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -388,7 +388,7 @@ static void run_test(enum vm_guest_mode mode, bool us=
e_uffd,
 	 */
 	TEST_ASSERT(guest_num_pages < vm_get_max_gfn(vm),
 		    "Requested more guest memory than address space allows.\n"
-		    "    guest pages: %lx max gfn: %lx vcpus: %d wss: %lx]\n",
+		    "    guest pages: %lx max gfn: %x vcpus: %d wss: %lx]\n",
 		    guest_num_pages, vm_get_max_gfn(vm), vcpus,
 		    vcpu_memory_bytes);
=20
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/test=
ing/selftests/kvm/include/test_util.h
index c921ea719ae0..07823740227b 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -37,7 +37,8 @@ ssize_t test_read(int fd, void *buf, size_t count);
 int test_seq_read(const char *path, char **bufp, size_t *sizep);
=20
 void test_assert(bool exp, const char *exp_str,
-		 const char *file, unsigned int line, const char *fmt, ...);
+		 const char *file, unsigned int line, const char *fmt, ...)
+		__attribute__((format(printf, 5, 6)));
=20
 #define TEST_ASSERT(e, fmt, ...) \
 	test_assert((e), #e, __FILE__, __LINE__, fmt, ##__VA_ARGS__)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/s=
elftests/kvm/lib/kvm_util.c
index 69a28a9211b4..b29c5d338555 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -265,7 +265,7 @@ void kvm_vm_restart(struct kvm_vm *vmp, int perm)
 		TEST_ASSERT(ret =3D=3D 0, "KVM_SET_USER_MEMORY_REGION IOCTL failed,\n"
 			    "  rc: %i errno: %i\n"
 			    "  slot: %u flags: 0x%x\n"
-			    "  guest_phys_addr: 0x%lx size: 0x%lx",
+			    "  guest_phys_addr: 0x%llx size: 0x%llx",
 			    ret, errno, region->region.slot,
 			    region->region.flags,
 			    region->region.guest_phys_addr,
@@ -280,7 +280,7 @@ void kvm_vm_get_dirty_log(struct kvm_vm *vm, int slot=
, void *log)
=20
 	ret =3D ioctl(vm->fd, KVM_GET_DIRTY_LOG, &args);
 	TEST_ASSERT(ret =3D=3D 0, "%s: KVM_GET_DIRTY_LOG failed: %s",
-		    strerror(-ret));
+		    __func__, strerror(-ret));
 }
=20
 void kvm_vm_clear_dirty_log(struct kvm_vm *vm, int slot, void *log,
@@ -293,7 +293,7 @@ void kvm_vm_clear_dirty_log(struct kvm_vm *vm, int sl=
ot, void *log,
=20
 	ret =3D ioctl(vm->fd, KVM_CLEAR_DIRTY_LOG, &args);
 	TEST_ASSERT(ret =3D=3D 0, "%s: KVM_CLEAR_DIRTY_LOG failed: %s",
-		    strerror(-ret));
+		    __func__, strerror(-ret));
 }
=20
 /*
@@ -785,7 +785,7 @@ void vm_mem_region_move(struct kvm_vm *vm, uint32_t s=
lot, uint64_t new_gpa)
 	ret =3D ioctl(vm->fd, KVM_SET_USER_MEMORY_REGION, &region->region);
=20
 	TEST_ASSERT(!ret, "KVM_SET_USER_MEMORY_REGION failed\n"
-		    "ret: %i errno: %i slot: %u flags: 0x%x",
+		    "ret: %i errno: %i slot: %u flags: 0x%lx",
 		    ret, errno, slot, new_gpa);
 }
=20
diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/test=
ing/selftests/kvm/x86_64/evmcs_test.c
index 185226c39c03..464a55217085 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -109,7 +109,7 @@ int main(int argc, char *argv[])
=20
 		switch (get_ucall(vm, VCPU_ID, &uc)) {
 		case UCALL_ABORT:
-			TEST_ASSERT(false, "%s at %s:%d", (const char *)uc.args[0],
+			TEST_ASSERT(false, "%s at %s:%ld", (const char *)uc.args[0],
 				    __FILE__, uc.args[1]);
 			/* NOT REACHED */
 		case UCALL_SYNC:
@@ -122,7 +122,7 @@ int main(int argc, char *argv[])
=20
 		/* UCALL_SYNC is handled here.  */
 		TEST_ASSERT(!strcmp((const char *)uc.args[0], "hello") &&
-			    uc.args[1] =3D=3D stage, "Unexpected register values vmexit #%lx,=
 got %lx",
+			    uc.args[1] =3D=3D stage, "Stage %d: Unexpected register values vm=
exit, got %lx",
 			    stage, (ulong)uc.args[1]);
=20
 		state =3D vcpu_save_state(vm, VCPU_ID);
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/te=
sting/selftests/kvm/x86_64/hyperv_cpuid.c
index 443a2b54645b..3edf3b517f9f 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
@@ -66,7 +66,7 @@ static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_e=
ntries,
=20
 		TEST_ASSERT((entry->function >=3D 0x40000000) &&
 			    (entry->function <=3D 0x4000000A),
-			    "function %lx is our of supported range",
+			    "function %x is our of supported range",
 			    entry->function);
=20
 		TEST_ASSERT(entry->index =3D=3D 0,
diff --git a/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c =
b/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c
index 125aeab59ab6..f2efaa576794 100644
--- a/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c
@@ -61,8 +61,7 @@ static void *vcpu_worker(void *data)
 		    "Unexpected exit reason =3D %d", run->exit_reason);
=20
 	cmd =3D get_ucall(vm, VCPU_ID, &uc);
-	TEST_ASSERT(cmd =3D=3D UCALL_DONE, "Unexpected val in guest =3D %llu",
-		    uc.args[0]);
+	TEST_ASSERT(cmd =3D=3D UCALL_DONE, "Unexpected val in guest =3D %lu", u=
c.args[0]);
 	return NULL;
 }
=20
diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/test=
ing/selftests/kvm/x86_64/state_test.c
index 164774206170..a4dc1ee59659 100644
--- a/tools/testing/selftests/kvm/x86_64/state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/state_test.c
@@ -152,7 +152,7 @@ int main(int argc, char *argv[])
=20
 		switch (get_ucall(vm, VCPU_ID, &uc)) {
 		case UCALL_ABORT:
-			TEST_ASSERT(false, "%s at %s:%d", (const char *)uc.args[0],
+			TEST_ASSERT(false, "%s at %s:%ld", (const char *)uc.args[0],
 				    __FILE__, uc.args[1]);
 			/* NOT REACHED */
 		case UCALL_SYNC:
@@ -165,7 +165,7 @@ int main(int argc, char *argv[])
=20
 		/* UCALL_SYNC is handled here.  */
 		TEST_ASSERT(!strcmp((const char *)uc.args[0], "hello") &&
-			    uc.args[1] =3D=3D stage, "Unexpected register values vmexit #%lx,=
 got %lx",
+			    uc.args[1] =3D=3D stage, "Stage %d: Unexpected register values vm=
exit, got %lx",
 			    stage, (ulong)uc.args[1]);
=20
 		state =3D vcpu_save_state(vm, VCPU_ID);
diff --git a/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c b/tools=
/testing/selftests/kvm/x86_64/svm_vmcall_test.c
index e280f68f6365..8cd841ff6305 100644
--- a/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
+++ b/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
@@ -69,8 +69,7 @@ int main(int argc, char *argv[])
 		case UCALL_DONE:
 			goto done;
 		default:
-			TEST_ASSERT(false,
-				    "Unknown ucall 0x%x.", uc.cmd);
+			TEST_ASSERT(false, "Unknown ucall 0x%lx.", uc.cmd);
 		}
 	}
 done:
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c b/to=
ols/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
index fe0734d9ef75..d9ca948d0b72 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
@@ -126,7 +126,7 @@ int main(int argc, char *argv[])
=20
 		switch (get_ucall(vm, VCPU_ID, &uc)) {
 		case UCALL_ABORT:
-			TEST_ASSERT(false, "%s at %s:%d", (const char *)uc.args[0],
+			TEST_ASSERT(false, "%s at %s:%ld", (const char *)uc.args[0],
 				    __FILE__, uc.args[1]);
 			/* NOT REACHED */
 		case UCALL_SYNC:
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test=
.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
index 9ef7fab39d48..7962f2fe575d 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
@@ -212,7 +212,7 @@ void test_vmx_nested_state(struct kvm_vm *vm)
 	test_nested_state(vm, state);
 	vcpu_nested_state_get(vm, VCPU_ID, state);
 	TEST_ASSERT(state->size >=3D sizeof(*state) && state->size <=3D state_s=
z,
-		    "Size must be between %d and %d.  The size returned was %d.",
+		    "Size must be between %ld and %d.  The size returned was %d.",
 		    sizeof(*state), state_sz, state->size);
 	TEST_ASSERT(state->hdr.vmx.vmxon_pa =3D=3D -1ull, "vmxon_pa must be -1u=
ll.");
 	TEST_ASSERT(state->hdr.vmx.vmcs12_pa =3D=3D -1ull, "vmcs_pa must be -1u=
ll.");
--=20
2.21.1


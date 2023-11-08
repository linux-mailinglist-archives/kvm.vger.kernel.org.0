Return-Path: <kvm+bounces-1147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 95A7F7E52BF
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 10:41:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EFBE9B20DF5
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 09:41:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84FEB101D2;
	Wed,  8 Nov 2023 09:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i8/W794g"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FE8FC12
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 09:41:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14351A6
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 01:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699436461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=NyFFI+QLTn/KCY41JKK+/gb0GFQOellCsquJKsgSF6E=;
	b=i8/W794g/bVUGRFZi2yKonobUhI2CJTrSnU5Kpzd/DC5dm1ZYslCtY5q3cM5GChIuaFdX9
	Rff4TTRHa6eGY913hooHG4y16mXaThKM8Pt7F99Xt0kLUlw78aOKbG8nmzgydyUTMAdu0k
	07zpbePcHzjD3J+qPDGuB3MUeUY8JaU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-265-5G49vdi4MKGlCodbOb3dYQ-1; Wed,
 08 Nov 2023 04:40:56 -0500
X-MC-Unique: 5G49vdi4MKGlCodbOb3dYQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B9031C06EC1;
	Wed,  8 Nov 2023 09:40:56 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2C8B740C6EB9;
	Wed,  8 Nov 2023 09:40:56 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH] selftests: kvm/s390x: use vm_create_barebones()
Date: Wed,  8 Nov 2023 04:40:55 -0500
Message-Id: <20231108094055.221234-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

This function does the same but makes it clearer why one would use
the "____"-prefixed version of vm_create().

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/s390x/cmma_test.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390x/cmma_test.c b/tools/testing/selftests/kvm/s390x/cmma_test.c
index c8e0a6495a63..626a2b8a2037 100644
--- a/tools/testing/selftests/kvm/s390x/cmma_test.c
+++ b/tools/testing/selftests/kvm/s390x/cmma_test.c
@@ -94,11 +94,6 @@ static void guest_dirty_test_data(void)
 	);
 }
 
-static struct kvm_vm *create_vm(void)
-{
-	return ____vm_create(VM_MODE_DEFAULT);
-}
-
 static void create_main_memslot(struct kvm_vm *vm)
 {
 	int i;
@@ -157,7 +152,7 @@ static struct kvm_vm *create_vm_two_memslots(void)
 {
 	struct kvm_vm *vm;
 
-	vm = create_vm();
+	vm = vm_create_barebones();
 
 	create_memslots(vm);
 
@@ -276,7 +271,7 @@ static void assert_exit_was_hypercall(struct kvm_vcpu *vcpu)
 
 static void test_migration_mode(void)
 {
-	struct kvm_vm *vm = create_vm();
+	struct kvm_vm *vm = vm_create_barebones();
 	struct kvm_vcpu *vcpu;
 	u64 orig_psw;
 	int rc;
@@ -670,7 +665,7 @@ struct testdef {
  */
 static int machine_has_cmma(void)
 {
-	struct kvm_vm *vm = create_vm();
+	struct kvm_vm *vm = vm_create_barebones();
 	int r;
 
 	r = !__kvm_has_device_attr(vm->fd, KVM_S390_VM_MEM_CTRL, KVM_S390_VM_MEM_ENABLE_CMMA);
-- 
2.39.1



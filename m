Return-Path: <kvm+bounces-4740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20E5181771D
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 17:13:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78DA8285502
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 16:13:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 229B5498BC;
	Mon, 18 Dec 2023 16:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cnIo1V9b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A641C4FF9D
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 16:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--pgonda.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-28b6819999bso553539a91.1
        for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 08:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702915961; x=1703520761; darn=vger.kernel.org;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dO4QxICI4OY8n1NmTGy/GBpUmjeoRLVn201/SHi6jvw=;
        b=cnIo1V9b/P8qOrQtC+9PfQ2IT1AlagPL8v1HGFoxK8psXH/pVtuz4kbgHQ7IjAeaqL
         P1Gxok4/KPzg/5N4DFh3doFcCduSIT4io25gZ+ZZ/KSfcwC5bW6RrJDH43etmXPVUq7w
         vFZqyRkupeI9DuY17IudkIvV7CXOE/k1VejlozF5MNJKvk21q5zP4umjre+2pPqv2IU7
         LuhWW06+Biu+01OtUfPbn00ZqTsFoG/wSUjiKvcotRBBhifdpxgICHpE/ZbdpXGD09sN
         ucpPtZPUeR517Ri9K+WaRtQA9pdfU0Xt/lkJNN/H3YogAWFI49J7M+mvTDXK3B1yz5FZ
         fomg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702915961; x=1703520761;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dO4QxICI4OY8n1NmTGy/GBpUmjeoRLVn201/SHi6jvw=;
        b=FDBXCOHRwGnSekCOMNAAEl6FcyPY44BLwDzxDexejUi2PpZf8sez1hwAfA+8WURbjo
         YmsHJTkvcNtGOJp/F5e7CZmawBcu6VF/2chFO3mEa72O3KuL3cQcNvYLuWoUrASOCgtU
         hWpK3OnvZzQK8NFjjwlnQFwkW6KtMXTmOA/OuJ6t2Az2tBcJ+0l3iZDcdUwMaDBuCFD4
         IdpHq/AmH1r2eD7BtrIvS0Bt+8MFUl+B4dnssTN85UnWN1Lc+DTHVeeGYB/QOTP/+Iqa
         g2zhgiSxiyYNp2q88KAwzVBm3J7a7joLRmfyYpCF2kniP1vU75daaXPi8J2egzSJJdP4
         txkg==
X-Gm-Message-State: AOJu0YyQbKMd4X0zfBGZS+wlabgENy1FGzWNGpTNVmUE1hDP6seumagl
	jY4znvSjtHJAh5YIc/4uSXaaGD1gDRK9mTY7VlcH0Ph3thgwrPvhcI1K/7cFJtP9HRwPVyZJ2bC
	GcnSypLb4L+XhTTE4iBd59OmU9ANqCJ7svIqHE0fJF4VYnuomVQD4EPrJzg==
X-Google-Smtp-Source: AGHT+IGKJhSsVLXHbzqEatX01C+Y9wmyIMdMQhGLjtBbw24nNELzFO6GZEfyWt1g9dsBzhfCJAdop+r/umc=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:15:8aeb:e3fa:237c:63a5])
 (user=pgonda job=sendgmr) by 2002:a17:903:2452:b0:1d2:eb13:5cd7 with SMTP id
 l18-20020a170903245200b001d2eb135cd7mr2040499pls.12.1702915960012; Mon, 18
 Dec 2023 08:12:40 -0800 (PST)
Date: Mon, 18 Dec 2023 08:11:45 -0800
In-Reply-To: <20231218161146.3554657-1-pgonda@google.com>
Message-Id: <20231218161146.3554657-8-pgonda@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231218161146.3554657-1-pgonda@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Subject: [PATCH V7 7/8] KVM: selftests: Update ucall pool to allocate from
 shared memory
From: Peter Gonda <pgonda@google.com>
To: kvm@vger.kernel.org
Cc: Peter Gonda <pgonda@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerly Tng <ackerleytng@google.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"

Update the per VM ucall_header allocation from vm_vaddr_alloc() to
vm_vaddr_alloc_shared(). This allows encrypted guests to use ucall pools
by placing their shared ucall structures in unencrypted (shared) memory.
No behavior change for non encrypted guests.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerly Tng <ackerleytng@google.com>
cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 tools/testing/selftests/kvm/lib/ucall_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 816a3fa109bf..f5af65a41c29 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -29,7 +29,8 @@ void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 	vm_vaddr_t vaddr;
 	int i;
 
-	vaddr = __vm_vaddr_alloc(vm, sizeof(*hdr), KVM_UTIL_MIN_VADDR, MEM_REGION_DATA);
+	vaddr = vm_vaddr_alloc_shared(vm, sizeof(*hdr), KVM_UTIL_MIN_VADDR,
+				      MEM_REGION_DATA);
 	hdr = (struct ucall_header *)addr_gva2hva(vm, vaddr);
 	memset(hdr, 0, sizeof(*hdr));
 
-- 
2.43.0.472.g3155946c3a-goog



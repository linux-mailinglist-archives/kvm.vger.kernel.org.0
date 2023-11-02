Return-Path: <kvm+bounces-440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A1F97DF9C0
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 19:16:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CDC7FB2119F
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 18:16:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D55D21357;
	Thu,  2 Nov 2023 18:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FOVvAT9j"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C98621114
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 18:16:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FEC134
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 11:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698948964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lX9pDYhUv0xNWCwt2hkI8FAcvsPw051Wv1MARO9LEh8=;
	b=FOVvAT9jGjFKOX7lJDq9F37aroIE+8WU6feEIfqXeISriC1ts5Xx3602+JtGBl6a+jpUhe
	wJG4UQo5iy+gzT/q86rTsO/05Qw3QKtc5uh4nqhDXNBDDUJfXHMmWuKrjD8Pwpnbbx5Ft3
	eCC03cX6M/SyNxrwuNcgAINoQ27spyo=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-349-B8hRMxwYOAuLMcKn-vnp-Q-1; Thu, 02 Nov 2023 14:16:02 -0400
X-MC-Unique: B8hRMxwYOAuLMcKn-vnp-Q-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2c509f2c0c7so2559021fa.0
        for <kvm@vger.kernel.org>; Thu, 02 Nov 2023 11:16:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698948961; x=1699553761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lX9pDYhUv0xNWCwt2hkI8FAcvsPw051Wv1MARO9LEh8=;
        b=o6hbkiLe9kj9OQAzegmvNPu17gj6UXdqqv6gO8KfYuNk2Bk9XUolHjRqSgGujdiZeU
         ZQYwlsD82ndDWf5st8G07qDfzfanyM6v77bgglOZMK1q9pq52JAKS2XYdm6iptAe0xfe
         C7V1E5YGA7AmVtZ+JeoZShjsSLxkMGynkRUstPSxdwZLyPSpYYiDHO9vZ+216fgY7kzY
         kmICl8+3jlBC9LxUtT37UAoC2Vi3MuAmFXGWqcBK76OmNUEkwmVSyAsGkSvshJyvi7dh
         U8+0cnTexAbRa+40jS6a8PpMdTIhy7tZEKVJltDmyyyRl+eNNTF9GPjECrnbncJ6KFSy
         O3yQ==
X-Gm-Message-State: AOJu0YwNfygW9B2SHWB2bvbBd+8cVuJTO34xpfXbxF2qz0//aJ6AtWL+
	o5fR19S72s1t7jEkon7tjDxvdCNiufCc4OVBN0namrSq/RvGpmhePcTbEkr0/4HvwA9XidmYXbX
	r4eyFNiIi7FwK
X-Received: by 2002:a2e:b5cd:0:b0:2c0:7d6:1349 with SMTP id g13-20020a2eb5cd000000b002c007d61349mr13191948ljn.0.1698948960948;
        Thu, 02 Nov 2023 11:16:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEA9GFg/9wbEsQk9hiRtyKr5Sw8+tU0lzjpfffLtjFPJgequPAx/iZqfrIIRwYQeDUno1rPwQ==
X-Received: by 2002:a2e:b5cd:0:b0:2c0:7d6:1349 with SMTP id g13-20020a2eb5cd000000b002c007d61349mr13191934ljn.0.1698948960612;
        Thu, 02 Nov 2023 11:16:00 -0700 (PDT)
Received: from pstanner-thinkpadt14sgen1.remote.csb ([2001:9e8:32c5:d600:227b:d2ff:fe26:2a7a])
        by smtp.gmail.com with ESMTPSA id m28-20020a05600c3b1c00b004076f522058sm3879929wms.0.2023.11.02.11.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 11:16:00 -0700 (PDT)
From: Philipp Stanner <pstanner@redhat.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Philipp Stanner <pstanner@redhat.com>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 1/3] arch/x86/kvm: copy user-array with overflow-check
Date: Thu,  2 Nov 2023 19:15:24 +0100
Message-ID: <20231102181526.43279-2-pstanner@redhat.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231102181526.43279-1-pstanner@redhat.com>
References: <20231102181526.43279-1-pstanner@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cpuid.c utilizes vmemdup_user() and array_size() to copy two userspace
arrays. This, currently, does not check for an overflow.

Use the new wrapper vmemdup_array_user() to copy the arrays more safely.

Suggested-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Philipp Stanner <pstanner@redhat.com>
---
 arch/x86/kvm/cpuid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 773132c3bf5a..4a15b2a20f84 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -467,7 +467,7 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 		return -E2BIG;
 
 	if (cpuid->nent) {
-		e = vmemdup_user(entries, array_size(sizeof(*e), cpuid->nent));
+		e = vmemdup_array_user(entries, cpuid->nent, sizeof(*e));
 		if (IS_ERR(e))
 			return PTR_ERR(e);
 
@@ -511,7 +511,7 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 		return -E2BIG;
 
 	if (cpuid->nent) {
-		e2 = vmemdup_user(entries, array_size(sizeof(*e2), cpuid->nent));
+		e2 = vmemdup_array_user(entries, cpuid->nent, sizeof(*e2));
 		if (IS_ERR(e2))
 			return PTR_ERR(e2);
 	}
-- 
2.41.0



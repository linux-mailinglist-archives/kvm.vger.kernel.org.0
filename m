Return-Path: <kvm+bounces-1371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 78DAC7E7341
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 22:04:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2DD84281271
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 21:04:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 595CA38DF6;
	Thu,  9 Nov 2023 21:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NyigdJF+"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED34E374EC
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 21:03:46 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D2A478D
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 13:03:46 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5afa77f9a33so18862717b3.0
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 13:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699563825; x=1700168625; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qijOPy0ERXUhax/ZBRVntyygIlckAr4kgGgQkmlO6nw=;
        b=NyigdJF+kb5HNAGNgNtj/fDKG+vw3PRPV6Qi7oveX2OcQzuZ/WZl9YLQ5SxfkoqW+/
         wMk3yk1QoiGq93HfTcosbxHuSI5Rcq12MoMCQxAc/HgS+k/vEcfygF/HcfIvoMTyzaib
         q3PrCx8424plOIfXMHzA0B4sva61Z97IHz6cBAaFRMMK+RKtppIUX5nkMFhS3xm0agMK
         5TCXOZmhu56DYM88mro+8JDbbIhaItZXMFn6hQDGKKyOrqyeqPfGufn7eGQ62pp6s6fv
         864PLSHWkLdnxnP1+ix2lIAxn1x5E7K0YxhLCUighRfPWfoT2fvsw3LDaNdQrrMQ/fs8
         Q48w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699563825; x=1700168625;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qijOPy0ERXUhax/ZBRVntyygIlckAr4kgGgQkmlO6nw=;
        b=CaGWj73sJYo9gWdEVn/QWxlG1hJrQ+hnbd0HvO0xAA9qn8pu/vBlNvVBq5QBs+eq6s
         cx4KrRfs5OEoB5/1hGa51xf4cGDqL9eQ4hUy+yCp4LbImTIpCQYXxAbBaCkHPOAVpQwF
         vmhwAgNcfqFJR6Ioo9wliE6mxdE2UPanY8EUXjzyqROLUIXTzuruDiUxjkPcqmGip9uC
         XJpApFRXJEKcVET9kkvUlUYPq3PNi7Ir2bWm9bSKeBeZLvRcP6/iTkBHkFs+22W0Hh7r
         18F6aFRJUxWQpUA+IHGdA35aPdR7cX4lKWOEkt0shCtLphSXSxfWZiSzc06QstOuYSYe
         pImw==
X-Gm-Message-State: AOJu0Yz8YOS0VJwfz3r0FfWcM7TV29LYOaEpJBc/eiqcOD/yZgTVX+pB
	bNGt47b+X9HoAQSHzUiwrx+/SyzNh31zvg==
X-Google-Smtp-Source: AGHT+IHnmQkK4g0KoxqixIoEiE1OXZsGIcaGUD3aF5w4eY/4zuUTkKMYBZztpx1oc2DM9MDYdS3CIiEG7TrJVQ==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a0d:d78d:0:b0:59b:f138:c835 with SMTP id
 z135-20020a0dd78d000000b0059bf138c835mr167156ywd.5.1699563825368; Thu, 09 Nov
 2023 13:03:45 -0800 (PST)
Date: Thu,  9 Nov 2023 21:03:13 +0000
In-Reply-To: <20231109210325.3806151-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231109210325.3806151-3-amoorthy@google.com>
Subject: [PATCH v6 02/14] KVM: Documentation: Add docstrings for __kvm_read/write_guest_page()
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

The (gfn, data, offset, len) order of parameters is a little strange
since "offset" applies to "gfn" rather than to "data". Add docstrings to
make things perfectly clear.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 687374138cfd..f521b6fd808f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3328,6 +3328,7 @@ static int next_segment(unsigned long len, int offset)
 		return len;
 }
 
+/* Copy @len bytes from guest memory at '(@gfn * PAGE_SIZE) + @offset' to @data */
 static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
 				 void *data, int offset, int len)
 {
@@ -3429,6 +3430,7 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 
+/* Copy @len bytes from @data into guest memory at '(@gfn * PAGE_SIZE) + @offset' */
 static int __kvm_write_guest_page(struct kvm *kvm,
 				  struct kvm_memory_slot *memslot, gfn_t gfn,
 			          const void *data, int offset, int len)
-- 
2.42.0.869.gea05f2083d-goog



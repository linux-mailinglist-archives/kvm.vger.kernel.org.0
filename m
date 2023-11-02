Return-Path: <kvm+bounces-441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC7B17DF9C1
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 19:16:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECD991C20FFF
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 18:16:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0406121363;
	Thu,  2 Nov 2023 18:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AmKeNG6e"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2AC21117
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 18:16:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A85B9
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 11:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698948964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zgG3A5hpFrp+6V7xcOap0dfvpVeqP5J5h/8swybWPW8=;
	b=AmKeNG6e5TGAmov2bQOQ1EysZ4KQklR/7TXeewd+jGPyLxfPHn5T9d0BEEvy/xefL6F1MB
	IWHk/IoFW9gAe01jfrFvoNErDm+78E+A8DJSFnAFYrp26F4FlSjI3TQIH0A/hIrRhYjZ/9
	4vak1+LpLGk/nmbSVc5rqCJqFyZPiAM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-115-9qhIlTQfPEyVY_YdJYdQfg-1; Thu, 02 Nov 2023 14:16:03 -0400
X-MC-Unique: 9qhIlTQfPEyVY_YdJYdQfg-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4083e371a18so1445655e9.0
        for <kvm@vger.kernel.org>; Thu, 02 Nov 2023 11:16:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698948962; x=1699553762;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zgG3A5hpFrp+6V7xcOap0dfvpVeqP5J5h/8swybWPW8=;
        b=NNGovGs48a3AByWY0VMh8u12j2K40pxY9cXoM4viN8JL73oPoWz08j2I+uYq+w3Czl
         vFqElz7Gx1i/KKfs8gpqatKwCchqBEc4GyfU030sv8IEXyX+hfgymM5FAX1GQNAVzjMb
         yM9LKDKT4DH7tMOXwUY4HlGOr6H5qC8OQu+0CdUjVTHMsB1Jzj51baTUaCSheFRP0rCY
         riO43MI7N2GSt0I6VSTc9uQFz44cFVknxtOVpXvl5HFnyZwojmmAlrqGrJOBh4Hb68LL
         dUlepYo1KT1eTE+UKlNJWWRBytlRGHI8ZRSGTvEVGNb87DW4CcdPA0+zgS8sYfoVrOr0
         u97Q==
X-Gm-Message-State: AOJu0YyOfjz3wo363l2+WUoRWQl8q7abMm2DXmqmgpbq+b5tELMsk4Lo
	IouhDgw8+iMY4KVsAUZzfoX8JFYtT3iugZzpTCOnKqsnM8XmX2tUAMroIfRk6FlOBX7MmeUtjbw
	qyCmkc+ikMvgu
X-Received: by 2002:a05:600c:510a:b0:405:1ba2:4fcf with SMTP id o10-20020a05600c510a00b004051ba24fcfmr15629806wms.4.1698948962015;
        Thu, 02 Nov 2023 11:16:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFjTetfCnz62A+Ip2Hdlm3nuttWd2b6W3o5YuoU7reIi83z2x4Kzw5EwS3QOFs2J4hJ+0CIUg==
X-Received: by 2002:a05:600c:510a:b0:405:1ba2:4fcf with SMTP id o10-20020a05600c510a00b004051ba24fcfmr15629783wms.4.1698948961745;
        Thu, 02 Nov 2023 11:16:01 -0700 (PDT)
Received: from pstanner-thinkpadt14sgen1.remote.csb ([2001:9e8:32c5:d600:227b:d2ff:fe26:2a7a])
        by smtp.gmail.com with ESMTPSA id m28-20020a05600c3b1c00b004076f522058sm3879929wms.0.2023.11.02.11.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 11:16:01 -0700 (PDT)
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
Subject: [PATCH 2/3] arch/s390/kvm: copy userspace-array safely
Date: Thu,  2 Nov 2023 19:15:25 +0100
Message-ID: <20231102181526.43279-3-pstanner@redhat.com>
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

guestdbg.c utilizes memdup_user() to copy a userspace array. This,
currently, does not check for an overflow.

Use the new wrapper memdup_array_user() to copy the array more safely.

Suggested-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Philipp Stanner <pstanner@redhat.com>
---
 arch/s390/kvm/guestdbg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/guestdbg.c b/arch/s390/kvm/guestdbg.c
index 3765c4223bf9..80879fc73c90 100644
--- a/arch/s390/kvm/guestdbg.c
+++ b/arch/s390/kvm/guestdbg.c
@@ -213,8 +213,8 @@ int kvm_s390_import_bp_data(struct kvm_vcpu *vcpu,
 	else if (dbg->arch.nr_hw_bp > MAX_BP_COUNT)
 		return -EINVAL;
 
-	bp_data = memdup_user(dbg->arch.hw_bp,
-			      sizeof(*bp_data) * dbg->arch.nr_hw_bp);
+	bp_data = memdup_array_user(dbg->arch.hw_bp, dbg->arch.nr_hw_bp,
+				    sizeof(*bp_data));
 	if (IS_ERR(bp_data))
 		return PTR_ERR(bp_data);
 
-- 
2.41.0



Return-Path: <kvm+bounces-442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 285907DF9C2
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 19:16:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7F62281D47
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 18:16:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F3842136E;
	Thu,  2 Nov 2023 18:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BEj5L1+y"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E6F2136A
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 18:16:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09DA2136
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 11:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698948970;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yH09Py8IYRdWEq70yMXJ3wDczRklXyABpCu4Oku+uko=;
	b=BEj5L1+yDbpj8VEFhM26+acInhu79zBTNL2rKWITBLn4Lt0sL9E8ponVmTuVq2m/tm7amL
	zzA8BmqVz/H1GmF3YVyk4kvUhLjIj1W9l7kPNbB/Gf58732MoZSCiJ4a0m7XI9d1+h9qPt
	Ywwbm5i+HuywuFYtii6DfeYzlw/GT1w=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-303-2kzVPuGuP8q6yd_hYba37A-1; Thu, 02 Nov 2023 14:16:04 -0400
X-MC-Unique: 2kzVPuGuP8q6yd_hYba37A-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2c3e3672dc8so2089161fa.1
        for <kvm@vger.kernel.org>; Thu, 02 Nov 2023 11:16:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698948963; x=1699553763;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yH09Py8IYRdWEq70yMXJ3wDczRklXyABpCu4Oku+uko=;
        b=u2VbuiCk2t5N4M6A/XkbOGfJujHmDbmzjMhCeiA2TKzs+nZvrWVFXnvGKKxgUL/40p
         JmtK7dBZJl9OgL6U/6wzdZ2DOpCOIVdYN6r0YbG4IvIUFo5UaDwt5ltZNBmsCWyyn1Uy
         9hRfaEG01odu3iHOsQ/ajnbq1+zgzxzLYhzpA+spUQhOhUBBedzEF+vt959pVzNhJ/mq
         QZXwt+G3WdseNMxTLASU+G32VlUVhyVIk9lCcmdWNFTfNrWTeTidPFV3QzLjShY+RHEG
         emy/eANzJTZKk5f+vLcb/dtJG8rQ4kKXEP8J7NaWE2/rIyTggjmH0uFqM6jUGGN0XFM3
         WyuQ==
X-Gm-Message-State: AOJu0YyLghpNOjOk2iL78JuAeousevFhwXl6f1DWxYSXEPH31ENxsXYP
	4XQeU4uaQy5awYCQrPiNmDSLEtKN4wPBzevZkFz8jYa8u0c5MyW/jT6/7hFf23cqJIFQl3RNQ2A
	izxmlp9oVn9GC
X-Received: by 2002:a2e:9695:0:b0:2c4:ff24:b02e with SMTP id q21-20020a2e9695000000b002c4ff24b02emr14483920lji.3.1698948963402;
        Thu, 02 Nov 2023 11:16:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFS1zGZUHtg3KOcze+sfSekgUGd8coQqnik/gqhe4Qn0cg6IP3P+fkjw/XDjmt/1fT6T4eXsA==
X-Received: by 2002:a2e:9695:0:b0:2c4:ff24:b02e with SMTP id q21-20020a2e9695000000b002c4ff24b02emr14483906lji.3.1698948963067;
        Thu, 02 Nov 2023 11:16:03 -0700 (PDT)
Received: from pstanner-thinkpadt14sgen1.remote.csb ([2001:9e8:32c5:d600:227b:d2ff:fe26:2a7a])
        by smtp.gmail.com with ESMTPSA id m28-20020a05600c3b1c00b004076f522058sm3879929wms.0.2023.11.02.11.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 11:16:02 -0700 (PDT)
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
Subject: [PATCH 3/3] virt/kvm: copy userspace-array safely
Date: Thu,  2 Nov 2023 19:15:26 +0100
Message-ID: <20231102181526.43279-4-pstanner@redhat.com>
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

kvm_main.c utilizes vmemdup_user() and array_size() to copy a userspace
array. Currently, this does not check for an overflow.

Use the new wrapper vmemdup_array_user() to copy the array more safely.

Suggested-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Philipp Stanner <pstanner@redhat.com>
---
 virt/kvm/kvm_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 486800a7024b..2a2f409c2a7d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4932,9 +4932,8 @@ static long kvm_vm_ioctl(struct file *filp,
 			goto out;
 		if (routing.nr) {
 			urouting = argp;
-			entries = vmemdup_user(urouting->entries,
-					       array_size(sizeof(*entries),
-							  routing.nr));
+			entries = vmemdup_array_user(urouting->entries,
+						     routing.nr, sizeof(*entries));
 			if (IS_ERR(entries)) {
 				r = PTR_ERR(entries);
 				goto out;
-- 
2.41.0



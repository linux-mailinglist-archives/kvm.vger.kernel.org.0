Return-Path: <kvm+bounces-439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C73E7DF9BF
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 19:16:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25696281188
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 18:16:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0C4F21346;
	Thu,  2 Nov 2023 18:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aWeqHmmg"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7F32110F
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 18:16:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393BE186
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 11:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698948962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dm/JjHi370CidasORpTf+wVzVufl6jy0cXiZxdhplD4=;
	b=aWeqHmmgf9gIF60xiFGqspXOIYwgQq2OYn/pASWJiP8ZJuCJQFbBbSjpGhWZIpI17MVuRk
	QojJ9GbPcRwnSWgtLFqncR2B9dp7jq2taxPAOBtiHNoyjVQzp8Hdzy2JTTugCFbmFgRNGh
	vQDEj5VxyIwR7o+03ViOe9BdaPgxjjA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-166-vtkhlkSjOcWauOGLSK3jMg-1; Thu, 02 Nov 2023 14:16:01 -0400
X-MC-Unique: vtkhlkSjOcWauOGLSK3jMg-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4084b6f4515so2553805e9.1
        for <kvm@vger.kernel.org>; Thu, 02 Nov 2023 11:16:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698948959; x=1699553759;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dm/JjHi370CidasORpTf+wVzVufl6jy0cXiZxdhplD4=;
        b=vlDb4ODmmpZ35bgHgD/zJdYZMhzLYIWlMqPiPCDf4ro8sMk+BCerp0TgxztpBvT2WO
         Js9jm4BqHVclJTqpkCPF6Jeg6B0AxLT7oPvBUKr/x1keK0PcSwyPEHm6pvM/cR7I1qmq
         ojNI0iTSEYXLQyJ0d+AHtM57A6p25LbvcCoU6HYBWI1L+LOih5WQ3PasweJf/Kas6fai
         9Mz9WJLYlPIhoDie04FU8n/W8XV0DdseX2AGlZz4LXATBUA3J2+H8xk2L6d2201X5S9I
         eud2oefs08vC2mxMrywyWLvYSlL20wuJ/1jtZUaqv2xpNcLiAmuyr/6qbRi5Hn4X8T30
         pYDA==
X-Gm-Message-State: AOJu0YwTjdaIjoHoa2bD1k2I8NLLfUCOppqAsUX1MPkvSJgoeqtxmMDO
	4bruMPfaFYfZQoGyVyJu2UjVrUuLwc7/EpOYzM99/GSzV5mBkphEvXlqXlQTm3vWqElwevCKXgB
	OZ/XZeUpUhYMZ
X-Received: by 2002:a05:600c:35d6:b0:3fe:21a6:a18 with SMTP id r22-20020a05600c35d600b003fe21a60a18mr15692784wmq.3.1698948959793;
        Thu, 02 Nov 2023 11:15:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHdSFZUxYnwUz4IzHW2eQMQDQi7I71cXUtCaaSMnHVgWWbl2msHbfrBfeDCbf3D1IMoAJPZeQ==
X-Received: by 2002:a05:600c:35d6:b0:3fe:21a6:a18 with SMTP id r22-20020a05600c35d600b003fe21a60a18mr15692766wmq.3.1698948959456;
        Thu, 02 Nov 2023 11:15:59 -0700 (PDT)
Received: from pstanner-thinkpadt14sgen1.remote.csb ([2001:9e8:32c5:d600:227b:d2ff:fe26:2a7a])
        by smtp.gmail.com with ESMTPSA id m28-20020a05600c3b1c00b004076f522058sm3879929wms.0.2023.11.02.11.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 11:15:58 -0700 (PDT)
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
	Philipp Stanner <pstanner@redhat.com>
Subject: [PATCH 0/3] Use new wrappers to copy userspace arrays
Date: Thu,  2 Nov 2023 19:15:23 +0100
Message-ID: <20231102181526.43279-1-pstanner@redhat.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Linus recently merged [1] the wrapper functions memdup_array_user() and
vmemdup_array_user() in include/linux/string.h for Kernel v6.7

I am currently adding them to all places where (v)memdup_user() had been
used to copy arrays.

The wrapper is different to the wrapped functions only in that it might
return -EOVERFLOW. So this new error code might get pushed up to
userspace. I hope this is fine.

I felt that it might be a good idea to land those three patches here
with a single series, since they all touch something KVM-related.

Kind regards,
P.

[1] https://lore.kernel.org/all/169886743808.2396.17544791408117731525.pr-tracker-bot@kernel.org/

Philipp Stanner (3):
  arch/x86/kvm: copy user-array with overflow-check
  arch/s390/kvm: copy userspace-array safely
  virt/kvm: copy userspace-array safely

 arch/s390/kvm/guestdbg.c | 4 ++--
 arch/x86/kvm/cpuid.c     | 4 ++--
 virt/kvm/kvm_main.c      | 5 ++---
 3 files changed, 6 insertions(+), 7 deletions(-)

-- 
2.41.0



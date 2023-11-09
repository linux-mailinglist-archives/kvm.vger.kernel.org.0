Return-Path: <kvm+bounces-1377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D4CF97E734E
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 22:04:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 766D0B21350
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 21:04:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C97683985E;
	Thu,  9 Nov 2023 21:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EfAj8SFz"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1141238F99
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 21:03:53 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17E949D3
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 13:03:52 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-da0c7d27fb0so1604664276.1
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 13:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699563832; x=1700168632; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FlXGm33qnDUGSwPi6nRUH+NhfpRFfL8yhZwyreXloOM=;
        b=EfAj8SFzDmOCXtDzsirs+0iUcajDkPSK9vppWQGwMHpXm/pdBoaLdeRkRmeR+qWu0t
         MJi6PPezjpRVpYWJLg9pCNfO8DnCiWVyUe/7zJkRnGtZ/K8dL+yF3Ftw5Nz0YYfTT9Ca
         iro9z8IxcRkLsZlZVY+tAsOqA38e9qqHwwehE4Pz8j6YhhG/xcDlLVhMibF6Y+BmJ0e/
         kUmrruDA5LHTqLdcBcJdIJqInhuoUX10u9nolrHCmRugccpmlzN+F1ddtvilXFFz6x9O
         gDG/E2GIYRaQlvoCwUjFTrlrJLjsTvE+49nJg8m4ZHw7ltAopBcQxvH4Nvw/XQWjPJvZ
         nvTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699563832; x=1700168632;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FlXGm33qnDUGSwPi6nRUH+NhfpRFfL8yhZwyreXloOM=;
        b=HOPUxG7kkabT10g/qrhaYXze6pXTEg3HAS71CAPgCQDXkwY7ZFpr/j5kVYizYF+0Yg
         hZ2mqve5HjQAkayLaEvG345qpw947OMU1TS7BilGUbDDLrMnWaCCpPqNlWB7JPI5Af7N
         qMmO+BU6uhe38A8GMt4xbvNfAke0hC9MQDtKh3feHvp5uJStR+ttp2+T1fmII6qU5uo9
         ZL/khR5k0k3zvIkoYK2z0/yvTIu5Mc3FTnBJtR5lwfKonhY0PLxvdIITc0PXjooG0SRg
         Okd2pppLa7Q6SEfaDjJPUwzzwzbposw8iNciQ/WPZNzj9p1KdXx8QAZ5uoGrtA+C6fuw
         k2OQ==
X-Gm-Message-State: AOJu0YwaW9CfrcZdBU4+uBTg62NjE30uRhYjQ4hTscdnwnLPosVxmrMN
	EdHiYqebBx0py+xaau28umrPZwRhxUPh0A==
X-Google-Smtp-Source: AGHT+IFaRWh9Kbo8WRKxbI1CvM7U18p+ZwojLoHrOJQ0ULGFOG0q4KET+/ELOWlz9GcEp/WRM4l5DEYeDb6NvQ==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:1366:b0:dae:49a3:ae23 with SMTP
 id bt6-20020a056902136600b00dae49a3ae23mr158715ybb.7.1699563832063; Thu, 09
 Nov 2023 13:03:52 -0800 (PST)
Date: Thu,  9 Nov 2023 21:03:19 +0000
In-Reply-To: <20231109210325.3806151-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231109210325.3806151-9-amoorthy@google.com>
Subject: [PATCH v6 08/14] KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

TODO: Changelog -- and possibly just merge into the "god" arm commit?

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 arch/arm64/kvm/arm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 317964bad1e1..b5c1d1fb77d0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -241,6 +241,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SYSTEM_SUSPEND:
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_COUNTER_OFFSET:
+	case KVM_CAP_MEMORY_FAULT_INFO:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
-- 
2.42.0.869.gea05f2083d-goog



Return-Path: <kvm+bounces-1379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D464C7E7354
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 22:04:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5D5A4B21115
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 21:04:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B56243987A;
	Thu,  9 Nov 2023 21:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1koZbFRk"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE43B38FAE
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 21:03:55 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1EE049EA
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 13:03:54 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a8ee6a1801so18261117b3.3
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 13:03:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699563834; x=1700168634; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ndN5evHM8MUglZ5LACl1va3WXCv7FT2yLnixDthGd8U=;
        b=1koZbFRkvo13gtyS05R6wZwGD0fXvQah5zHalyzUW9AxunfsEXwKN2kPuxQEeKC2MF
         jeU9iweKcReKzBfyoylfK3KSa673kv0AP7m1cWp9h+8nQYW9Szmw6jVzVJ2iffPeR1/n
         Sl2RNeIz7NfYoME/fx6UHFBhIK410BcBFTIeYmjS5WQkR7DloxS3n1OruGuajsBblwKH
         7VAIGBssgG1D5bUPDbu7BWoxSC6XMgXp0rgc5AKX/OY7LYXuVgPeHQqlmPFKyqM04oKX
         7piCjPjMHbKLnhn2X51u88bmfRlF116WCSoDtPkiLEwdjJ1JVVDu3KaP3Qlfwy7b3ld3
         eZJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699563834; x=1700168634;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ndN5evHM8MUglZ5LACl1va3WXCv7FT2yLnixDthGd8U=;
        b=N6PQk74ecIBGE80p061fKmyy9hHCExr7W9g0xQh2JGZUQqHMAG9Hd6Nsje22AW8C2G
         p2m3cAxdbOaLxmtp5yTSLLkreCRdf12z4oSi4LokUFvCucjWh7XLqziZnwTrdlTYJNrZ
         RWnnDA7H1d9q8swp3+H3fmBKimN1uoMd9j8g4QVZOOS6v7GorxAm8ru999y5rQv3puE1
         Hz+Ed6yWYdjpTcldxN3NBvDnahUTPPIFYyI2GRdtzVb+gSMjT6nnuOL/CNh+UtxXQsIP
         0Rdsodirj62OgaALcoTkX+3bxKoZwdac/Uuhj8Tug80caBxCBFM95dfEXBGmi4ilM339
         PCXQ==
X-Gm-Message-State: AOJu0YzC2m7oHVTVAZfZk95YzBZm4xJQQo//GRZyxP9WwfHiG/+2kRy0
	RuSlz8y7HrElnkYRhAX/TA29Lmarm5cfWQ==
X-Google-Smtp-Source: AGHT+IGr/R/Ys/jo55wlqQbJQ0YqF45A4R74eV/HizZPI6A91g6dD/euSHzkl4e6vMTELVXYRo6uYcd4cdgrgw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:1fd6:0:b0:d9a:e3d9:99bd with SMTP id
 f205-20020a251fd6000000b00d9ae3d999bdmr147977ybf.5.1699563834122; Thu, 09 Nov
 2023 13:03:54 -0800 (PST)
Date: Thu,  9 Nov 2023 21:03:21 +0000
In-Reply-To: <20231109210325.3806151-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231109210325.3806151-11-amoorthy@google.com>
Subject: [PATCH v6 10/14] KVM: selftests: Report per-vcpu demand paging rate
 from demand paging test
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

Using the overall demand paging rate to measure performance can be
slightly misleading when vCPU accesses are not overlapped. Adding more
vCPUs will (usually) increase the overall demand paging rate even
if performance remains constant or even degrades on a per-vcpu basis. As
such, it makes sense to report both the total and per-vcpu paging rates.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 09c116a82a84..6dc823fa933a 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -135,6 +135,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct timespec ts_diff;
 	struct kvm_vm *vm;
 	int i;
+	double vcpu_paging_rate;
 
 	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
 				 p->src_type, p->partition_vcpu_memory_access);
@@ -191,11 +192,17 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 			uffd_stop_demand_paging(uffd_descs[i]);
 	}
 
-	pr_info("Total guest execution time: %ld.%.9lds\n",
+	pr_info("Total guest execution time:\t%ld.%.9lds\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);
-	pr_info("Overall demand paging rate: %f pgs/sec\n",
-		memstress_args.vcpu_args[0].pages * nr_vcpus /
-		((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / NSEC_PER_SEC));
+
+	vcpu_paging_rate =
+		memstress_args.vcpu_args[0].pages
+		/ ((double)ts_diff.tv_sec
+			+ (double)ts_diff.tv_nsec / NSEC_PER_SEC);
+	pr_info("Per-vcpu demand paging rate:\t%f pgs/sec/vcpu\n",
+		vcpu_paging_rate);
+	pr_info("Overall demand paging rate:\t%f pgs/sec\n",
+		vcpu_paging_rate * nr_vcpus);
 
 	memstress_destroy_vm(vm);
 
-- 
2.42.0.869.gea05f2083d-goog



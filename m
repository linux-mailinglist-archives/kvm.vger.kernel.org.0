Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 995A479F743
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 04:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234594AbjINCA5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 22:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234351AbjINB74 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 21:59:56 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106B03AB1
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 18:56:28 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59224c40275so6512357b3.3
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 18:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694656588; x=1695261388; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=UjBddbZXLqwDqs/dRSKLKY4HwUhf6Ai3WxLtYL+KxyQ=;
        b=KboWSIH7XxmXbABlwi/6KJLJB3fhVTfhSqa+YwT/eN4xatsBOrQ3g/WiEFYZxztaO3
         GYloXmdz7qHX5Vy4ANktTMYIxorfyRtz75U++EXqXcKb6A3T1NvXFtR9WrKAZDhVLEBv
         y9XBoBYeOQuT7r+7UXXM8J8WV2BMYyQuHv3WZTqy+V/2vef8lrBIx8SkDu+kJdaBfuoo
         qrTrIHrrOVDJj+i4dZb81pvre5u9a7iS57AnHEyXS1gTIT6cE4nTY6Ycc0JnnBwBlkJG
         Za0fu3fKb8MzMHzP51/o0B4t7QNJaR4hUacg+kEY4qjsWeEfHhIoUupY0DLJhcZqTjYr
         zGvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694656588; x=1695261388;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UjBddbZXLqwDqs/dRSKLKY4HwUhf6Ai3WxLtYL+KxyQ=;
        b=f1wq1yjyp9S3P6g7jdydCGNzfgwtwOdHcDUODrgRmfXA7Vu8CBxv6BkKcVwO9BTE1Q
         PhU/tE5VgVX52x/R/HEJwCZxvhqqd4weRnJ8rnfgu/L3w/oei2348Retwl01iBprKCP6
         lCAds2V7qZUL4ftsrytRQMjcIpG1RD778QsGKNp9ZfdilQI4FtprdnrJ3fV3sVe3vhCS
         /ddS+D/CWRXq/3ORr/oxOJLoG+DJCPNQ6PAg/9TQYdrzYyiWbfEO9Zh+6DwPDQQzPWP+
         bj+ogOooAwo7tedyyxYquXYF4l2hnj5sdk8D18KgxOP0TC7PJQi6TM7nYCB+gPxgLPag
         zb5g==
X-Gm-Message-State: AOJu0YzqwZdpo5++rzUpLaWpTqLlglaE3Fo7oE65ODCvGcYOruCBrEWJ
        0fuWwgGcWzNHuiHfy3ChG6WiAvOxMLo=
X-Google-Smtp-Source: AGHT+IH0gGeX6zOzLjc3uszP5L1cVBy/yaTsK9vfF/9VEoisKrc6F33BJumlmtJCwJ85BnFPZfgq0s7SPdg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2e05:b0:59b:e1db:5633 with SMTP id
 et5-20020a05690c2e0500b0059be1db5633mr53066ywb.1.1694656588217; Wed, 13 Sep
 2023 18:56:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 13 Sep 2023 18:55:24 -0700
In-Reply-To: <20230914015531.1419405-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230914015531.1419405-27-seanjc@google.com>
Subject: [RFC PATCH v12 26/33] KVM: selftests: Add helpers to do
 KVM_HC_MAP_GPA_RANGE hypercalls (x86)
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Anish Moorthy <amoorthy@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Xu Yilun <yilun.xu@intel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vishal Annapurve <vannapurve@google.com>

Add helpers for x86 guests to invoke the KVM_HC_MAP_GPA_RANGE hypercall,
which KVM will forward to userspace and thus can be used by tests to
coordinate private<=>shared conversions between host userspace code and
guest code.

Signed-off-by: Vishal Annapurve <vannapurve@google.com>
[sean: drop shared/private helpers (let tests specify flags)]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h      | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 4fd042112526..1911c12d5bad 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -15,6 +15,7 @@
 #include <asm/msr-index.h>
 #include <asm/prctl.h>
 
+#include <linux/kvm_para.h>
 #include <linux/stringify.h>
 
 #include "../kvm_util.h"
@@ -1171,6 +1172,20 @@ uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
 uint64_t __xen_hypercall(uint64_t nr, uint64_t a0, void *a1);
 void xen_hypercall(uint64_t nr, uint64_t a0, void *a1);
 
+static inline uint64_t __kvm_hypercall_map_gpa_range(uint64_t gpa,
+						     uint64_t size, uint64_t flags)
+{
+	return kvm_hypercall(KVM_HC_MAP_GPA_RANGE, gpa, size >> PAGE_SHIFT, flags, 0);
+}
+
+static inline void kvm_hypercall_map_gpa_range(uint64_t gpa, uint64_t size,
+					       uint64_t flags)
+{
+	uint64_t ret = __kvm_hypercall_map_gpa_range(gpa, size, flags);
+
+	GUEST_ASSERT(!ret);
+}
+
 void __vm_xsave_require_permission(uint64_t xfeature, const char *name);
 
 #define vm_xsave_require_permission(xfeature)	\
-- 
2.42.0.283.g2d96d420d3-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278593DC0C3
	for <lists+kvm@lfdr.de>; Sat, 31 Jul 2021 00:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbhG3WFR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 18:05:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35615 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233247AbhG3WFO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Jul 2021 18:05:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627682708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nJ5kIz6o1OQd9QTNvIHXfvS8tA6xw4680ifwk1fWPhY=;
        b=OiBcf8ItaceCmzR9F5B24Vwh30MEgE8kp9gYAIsHzLNphdvLk55YjWqKXBTPByZcHVzKjc
        AYrGeAfKOVM1gaY5TA7IcpY0YYdxl+KuzIAe9FvxUVE5ZbWD6XLuYrjBHVhX5PNqTsRBGP
        bfaYISSb1IcxMkF33ViPCTMX5aCDy/U=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-KEl4-E6wPJGnyFiEsjj8oA-1; Fri, 30 Jul 2021 18:05:07 -0400
X-MC-Unique: KEl4-E6wPJGnyFiEsjj8oA-1
Received: by mail-qt1-f199.google.com with SMTP id w19-20020ac87e930000b029025a2609eb04so5104392qtj.17
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:05:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nJ5kIz6o1OQd9QTNvIHXfvS8tA6xw4680ifwk1fWPhY=;
        b=JCni+2vOUJ098pbnY/uu4XrIAUp7LUmT0AGk0v2HQzCUF2yA7t0myUweIgWdQxuexL
         uDnbU25cGsEb5C9kZ2XCru2tlqPs2PdXeV/faNn7hHzMQ+9ALAPQApu1uYOE4IpKgx2O
         ifPQ2eoOTjtmexzEZjHqJSkPvtDZa5uSfuGlKeydi2jdhpgTx74PJqDSZI5ybaV/ZMqz
         b3nx/pdWhXFuPnEI/Z3abY5R0aMAEQwSfDVEw+Tf28SvZinvmD5wlzg6LNoTydoTs/O1
         K3ctsXUbSADbp85rxfWvrMerjuKelWDxHndQ4XItKrHDLvI+hsxtm7+9DLXZiK4q0hwz
         xhvw==
X-Gm-Message-State: AOAM532d4WveYPiIrvpxzHghsr15m2jf6mUe2k5tpXYNJUw4vCFLJbKm
        82eAb/4Tix8EuC3AdSu/+5hkPaBHzCwzPvaCUeimQws0uoEzPV802uo9GXI/gU/IgYKGCDmbDBe
        dhvaaDePTcX426JjkUK8K8HJlmFUnrSj8fe4QlWR3Qea/ajNdavWUZaIRnoYrCg==
X-Received: by 2002:a37:9c06:: with SMTP id f6mr4344540qke.86.1627682705671;
        Fri, 30 Jul 2021 15:05:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz2+zyiyehuJ7kqaZ8WuhUtBpixZqcJNaSYno9mpuUyv7sxWUQmjmlZLJ6h4xEDlsaUXutyew==
X-Received: by 2002:a37:9c06:: with SMTP id f6mr4344517qke.86.1627682705409;
        Fri, 30 Jul 2021 15:05:05 -0700 (PDT)
Received: from t490s.. (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id l12sm1199651qtx.45.2021.07.30.15.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 15:05:04 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>, peterx@redhat.com,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 5/7] KVM: X86: MMU: Tune PTE_LIST_EXT to be bigger
Date:   Fri, 30 Jul 2021 18:04:53 -0400
Message-Id: <20210730220455.26054-6-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210730220455.26054-1-peterx@redhat.com>
References: <20210730220455.26054-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently rmap array element only contains 3 entries.  However for EPT=N there
could have a lot of guest pages that got tens of even hundreds of rmap entry.

A normal distribution of a 6G guest (even if idle) shows this with rmap count
statistics:

Rmap_Count:     0       1       2-3     4-7     8-15    16-31   32-63   64-127  128-255 256-511 512-1023
Level=4K:       3089171 49005   14016   1363    235     212     15      7       0       0       0
Level=2M:       5951    227     0       0       0       0       0       0       0       0       0
Level=1G:       32      0       0       0       0       0       0       0       0       0       0

If we do some more fork some pages will grow even larger rmap counts.

This patch makes PTE_LIST_EXT bigger so it'll be more efficient for the general
use case of EPT=N as we do list reference less and the loops over PTE_LIST_EXT
will be slightly more efficient; but still not too large so less waste when
array not full.

It should not affecting EPT=Y since EPT normally only has zero or one rmap
entry for each page, so no array is even allocated.

With a test case to fork 500 child and recycle them ("./rmap_fork 500" [1]),
this patch speeds up fork time of about 29%.

    Before: 473.90 (+-5.93%)
    After:  366.10 (+-4.94%)

[1] https://github.com/xzpeter/clibs/commit/825436f825453de2ea5aaee4bdb1c92281efe5b3

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 16c99f771c9e..c0b452bb5dd9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -137,8 +137,8 @@ module_param(dbg, bool, 0644);
 
 #include <trace/events/kvm.h>
 
-/* make pte_list_desc fit well in cache line */
-#define PTE_LIST_EXT 3
+/* make pte_list_desc fit well in cache lines */
+#define PTE_LIST_EXT 15
 
 struct pte_list_desc {
 	u64 *sptes[PTE_LIST_EXT];
-- 
2.31.1


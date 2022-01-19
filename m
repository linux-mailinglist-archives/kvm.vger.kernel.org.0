Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2427493BA6
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 15:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355000AbiASODh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 09:03:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350177AbiASODg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 09:03:36 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F91C061574;
        Wed, 19 Jan 2022 06:03:36 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id e9so2721897pgb.3;
        Wed, 19 Jan 2022 06:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z1ML4GC+j2a5rWM6N2roBceEIMaA3plN8shiVq57uXM=;
        b=feqKKD6tisUnEBfXeMh5xY5MivbGBLZfPjcGhnCtrZYFKTcRvoEKolIDnrDa54SuxA
         i5+tMbQbDlG8sX3z5i4hDDmD2yCtDBLEbNfLmS+bCxtKwc4SGZJaHCT4OB0rfKP0F5in
         Er8GY5KMl++5g3O5Wcjk9RgFiAh043TcsZv8cLoqzgRcncf/B8ELPbFIds9U/2YdVp/2
         zZTFPdvlNJqdjxkXmpumM/zayrQGP7TIKuEruU3pb3xJpajM3nsYQoGC6eqJh/hOrl3Q
         B1oQij/TfFn+HdDKZda/jtyJE43GZ4XvqfA/DFnfdBlVwPNlrfPAgQLgGi/Azt4+4nFA
         v2eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z1ML4GC+j2a5rWM6N2roBceEIMaA3plN8shiVq57uXM=;
        b=DyLXMnl9H3jrNVCbwy6AQvAtcDxqt/+JyYQj5Tk7wu1vwTK1VGARhg87hqzkjtZhLJ
         fdXHz8UwXMmtJAK627dXJH8070z2Ypaav/SfAeQ2gkf4aTVYY7rUeb+NIvjQLLyURlV5
         RYmJYzvLi05sSC9JJGqS1V/ABfkTqaaxYDl3Yez/5cXfz+S4u8kqbG5rTAfuYfPU6/9Z
         71Sh1jKdkhyrHY1k87kkXxOEFkpPBqleI4Vq0Pu5i+yz1nnxNrM/TmxkabdeH+HgVXc2
         Rqnn068Qb0Q7bz1R3kyrU21sK18coQE0vkgO/JWW5pE0GtSp31kTqByRuRVjZfUpLmpl
         dLyw==
X-Gm-Message-State: AOAM531JD7dKBKVBqKWyCljfvDHN+TtzLNne3A5Ke7L4aPttAqOgb0SB
        tWq55JxpZy9YlR+vsCTsk3Q=
X-Google-Smtp-Source: ABdhPJzr2z45cWUGJRrX9a47cpCNL3XatnLuF2QeckaZTwdfRy6+0n1bzaK/kw/k7uOYma+llY9xqg==
X-Received: by 2002:a63:85c6:: with SMTP id u189mr20086333pgd.282.1642601015829;
        Wed, 19 Jan 2022 06:03:35 -0800 (PST)
Received: from CLOUDLIANG-MB0.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t6sm20031177pfg.92.2022.01.19.06.03.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jan 2022 06:03:35 -0800 (PST)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] selftests: kvm/x86: Fix the warning in lib/x86_64/processor.c
Date:   Wed, 19 Jan 2022 22:03:25 +0800
Message-Id: <20220119140325.59369-1-cloudliang@tencent.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

The following warning appears when executing
make -C tools/testing/selftests/kvm

In file included from lib/x86_64/processor.c:11:
lib/x86_64/processor.c: In function ':
include/x86_64/processor.h:290:2: warning: 'ecx' may be used uninitialized in this
function [-Wmaybe-uninitialized]
  asm volatile("cpuid"
  ^~~
lib/x86_64/processor.c:1523:21: note: 'ecx' was declared here
  uint32_t eax, ebx, ecx, edx, max_ext_leaf;

Just initialize ecx to remove this warning.

Fixes: c8cc43c1eae2 ("selftests: KVM: avoid failures due to reserved
HyperTransport region")

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 59dcfe1967cc..4a4c7945cf3e 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1520,7 +1520,7 @@ unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
 {
 	const unsigned long num_ht_pages = 12 << (30 - vm->page_shift); /* 12 GiB */
 	unsigned long ht_gfn, max_gfn, max_pfn;
-	uint32_t eax, ebx, ecx, edx, max_ext_leaf;
+	uint32_t eax, ebx, ecx = 0, edx, max_ext_leaf;
 
 	max_gfn = (1ULL << (vm->pa_bits - vm->page_shift)) - 1;
 
-- 
2.27.0


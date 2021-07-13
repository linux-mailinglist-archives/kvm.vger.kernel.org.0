Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60463C796B
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 00:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236435AbhGMWNC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 18:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236350AbhGMWNB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 18:13:01 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCA5C0613DD
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 15:10:10 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id c13-20020a25880d0000b029055492c8987bso28886803ybl.19
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 15:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YypJ74lmVV39roAzI2i/DT39zCOCRxagBpvdMWnNzDc=;
        b=tqkK/AEEOu7BbZPEMF+lYPYsxG5yJkYgdSRJvLmjIpWkgiAjXz+/fu3lYHsI/RT8ld
         5LgcFraRjkj8sEoa9dlH3FjKNdJVyQ52fGvpExyjRqVp/gwolRles3ZKerC+RU2cCNWB
         0wg76tMjdTlOD9w3rxRzBIzelYdTfocJYerUFxCGca3btiTjQ8e37ZDa9M9N8Fp5Rg2g
         9jxJ3XIvPpM2M83wKXeQZ4W6sLLaZUg022Wth2NYtPL/WhMr0U01/jcEsnso23OIHs6e
         i8zbJgG7jyi/QU6qff4CyoP2Vcv0hJJ+fYGFhCMNOxL5uEFNoe5tQA78W4NucrHcjgVo
         aebg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YypJ74lmVV39roAzI2i/DT39zCOCRxagBpvdMWnNzDc=;
        b=mN4m0JbNZKh112Q9lAYUG+1bz7s39h+boEG/3HMX8Cjp3bjvgG23W2BqJNhZaR/9Vl
         8M+6jW37FSQvoRczP/fr6vWaQbWn/SQLDl8LA6rdUBP/EAQBn8usybWHBUjXThDL5QX1
         jBf3ILeBjFqm6lArigWTgeycJNk5rcrx4OkZzccPL9NLh+d3v7tvW4qGAVkpxzjQ/XbY
         lBEMF1fzTKlUr5tV86gtq0Ay5KfUI3kCT0QUfvaiFxdcV7wDg4p1Oa2/PpaNWyhJHDu8
         DZfr5cZLpJ9Z26AnNw1QSS/XVIv6WPmQyE1hCFQ4g5hHhNRUV1N1VKsvpWTAjUVJuNal
         jvJw==
X-Gm-Message-State: AOAM5339b5Ymv4xMhugudxVLZVVXz+Vm0QkgJe0zgpRYBiHRlp9TCU6R
        AyomOSbi0UuGa84AgBQiH8n+tjJhkxnYbdELfBQ/bzrPafER9coEmg8qAygTv/xwtoKZv0b63Uw
        3OkiQNWZ18qGwY3e7uWi/XUA/QpHQliMdmAXoyTwpYzFXNdVTIQX3mLylvYukn1U=
X-Google-Smtp-Source: ABdhPJzmvJKJ1VKb/4cDoSM1HqZd219RP0e5Ij7S+NiYElrvIUF03DrcOy4BiY+FqznD5RBfowQlg1o4ErWgJg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a25:ada1:: with SMTP id
 z33mr8976596ybi.438.1626214209324; Tue, 13 Jul 2021 15:10:09 -0700 (PDT)
Date:   Tue, 13 Jul 2021 22:09:56 +0000
In-Reply-To: <20210713220957.3493520-1-dmatlack@google.com>
Message-Id: <20210713220957.3493520-6-dmatlack@google.com>
Mime-Version: 1.0
References: <20210713220957.3493520-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v3 5/6] KVM: selftests: Fix missing break in
 dirty_log_perf_test arg parsing
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is a missing break statement which causes a fallthrough to the
next statement where optarg will be null and a segmentation fault will
be generated.

Fixes: 9e965bb75aae ("KVM: selftests: Add backing src parameter to dirty_log_perf_test")
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/dirty_log_perf_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 04a2641261be..80cbd3a748c0 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -312,6 +312,7 @@ int main(int argc, char *argv[])
 			break;
 		case 'o':
 			p.partition_vcpu_memory_access = false;
+			break;
 		case 's':
 			p.backing_src = parse_backing_src_type(optarg);
 			break;
-- 
2.32.0.93.g670b81a890-goog


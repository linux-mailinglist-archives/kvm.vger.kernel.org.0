Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFD12F3DC8
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 01:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732066AbhALVqB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 16:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731990AbhALVn6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 16:43:58 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A48EC0617A9
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 13:42:58 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id t17so51581qvv.17
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 13:42:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=U+CbYhEX3bk6CbEgkAzVDMsXIsxbjmYTO8NB12RiUfg=;
        b=ZYv6sEPqBHAArWWsUp2QL2JuEOAXcxNJ/TbleUpNix3Zom4HvsFXD6eBgs0/JiuL8S
         RcC1e//0CvYuIWl8eVu13IUXE/CsevnVnke/u6pKoUh8iiHXOER4VvVQafnlPnmlAft8
         IPP4Z4TjBYoZLIA6As9ZWQ3/6zwgdW1r/QykaNd0NxkuFhTYSFysEDk58A8TKx8oCI+4
         niiR71NrYJaivrHtLYhDIPWFeH4AHZhSo8YIrSKNB19Oq8kd94F/lH+OGNbCfTSoPYIe
         fJ8FVeeiInuJ3Tlo0Ydy1IEQ4MNRWlX3hErJuv9pGKd75FQd+Htl2xNJa6mB45RXHbDK
         5RGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=U+CbYhEX3bk6CbEgkAzVDMsXIsxbjmYTO8NB12RiUfg=;
        b=F13pz6H6g1R1vI0RaGR1ZWwMqcc6VZr79ygJ5Wi7hFjbgq8LcArOwfQoVUod3u3WKR
         X+Bp8v4pxPsPeuQoprQ9oYXi8Io4DCTI9q9nP/nWjHG6nUmSuAu4s9cH7lXj+Buw3Z1F
         8ltVFaXotdvlAGMOWRwlGyi7AIo6Bbh0QwDOxFVa8fYHkd1fUx5KfQc9WcSc3mw3a/Sk
         wDqzkIf8kg9Zjn11X8VG++sRS3yIPdPZhsH7T/oVLUf9a+9f/d18/N9UzSEX4AEKEEB5
         j6pNPz3sHHZdlHTV1vjYrCQihto7qmx+AlDElLeqSX9Ru1/pH8viI4zc62aZ0ZDGaKby
         cyFw==
X-Gm-Message-State: AOAM531p0sC1mFsMHhivVpZCx4pYUty9wAkh5xRrp6r4l2y0bE9NNyT5
        3OE5hDeEfJm4BpuTkEckfI9NmtudFrin
X-Google-Smtp-Source: ABdhPJwcwZH2KZ2pN7t1zlwuuRyYOL6A378R4xORgoSVJhlmFt3unwT0CSROZTnrTQpMBKu6C2QJNlR2YppO
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a0c:da87:: with SMTP id
 z7mr1679434qvj.41.1610487777488; Tue, 12 Jan 2021 13:42:57 -0800 (PST)
Date:   Tue, 12 Jan 2021 13:42:47 -0800
Message-Id: <20210112214253.463999-1-bgardon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 0/6] KVM: selftests: Perf test cleanups and memslot
 modification test
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Huth <thuth@redhat.com>, Jacob Xu <jacobhxu@google.com>,
        Makarand Sonare <makarandsonare@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series contains a few cleanups that didn't make it into previous
series, including some cosmetic changes and small bug fixes. The series
also lays the groundwork for a memslot modification test which stresses
the memslot update and page fault code paths in an attempt to expose races.

Tested: dirty_log_perf_test, memslot_modification_stress_test, and
	demand_paging_test were run, with all the patches in this series
	applied, on an Intel Skylake machine.

	echo Y > /sys/module/kvm/parameters/tdp_mmu; \
	./memslot_modification_stress_test -i 1000 -v 64 -b 1G; \
	./memslot_modification_stress_test -i 1000 -v 64 -b 64M -o; \
	./dirty_log_perf_test -v 64 -b 1G; \
	./dirty_log_perf_test -v 64 -b 64M -o; \
	./demand_paging_test -v 64 -b 1G; \
	./demand_paging_test -v 64 -b 64M -o; \
	echo N > /sys/module/kvm/parameters/tdp_mmu; \
	./memslot_modification_stress_test -i 1000 -v 64 -b 1G; \
	./memslot_modification_stress_test -i 1000 -v 64 -b 64M -o; \
	./dirty_log_perf_test -v 64 -b 1G; \
	./dirty_log_perf_test -v 64 -b 64M -o; \
	./demand_paging_test -v 64 -b 1G; \
	./demand_paging_test -v 64 -b 64M -o

	The tests behaved as expected, and fixed the problem of the
	population stage being skipped in dirty_log_perf_test. This can be
	seen in the output, with the population stage taking about the time
	dirty pass 1 took and dirty pass 1 falling closer to the times for
	the other passes.

Note that when running these tests, the -o option causes the test to take
much longer as the work each vCPU must do increases proportional to the
number of vCPUs.

You can view this series in Gerrit at:
https://linux-review.googlesource.com/c/linux/kernel/git/torvalds/linux/+/7216

Ben Gardon (6):
  KVM: selftests: Rename timespec_diff_now to timespec_elapsed
  KVM: selftests: Avoid flooding debug log while populating memory
  KVM: selftests: Convert iterations to int in dirty_log_perf_test
  KVM: selftests: Fix population stage in dirty_log_perf_test
  KVM: selftests: Add option to overlap vCPU memory access
  KVM: selftests: Add memslot modification stress test

 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/demand_paging_test.c        |  40 +++-
 .../selftests/kvm/dirty_log_perf_test.c       |  72 +++---
 .../selftests/kvm/include/perf_test_util.h    |   4 +-
 .../testing/selftests/kvm/include/test_util.h |   2 +-
 .../selftests/kvm/lib/perf_test_util.c        |  25 ++-
 tools/testing/selftests/kvm/lib/test_util.c   |   2 +-
 .../kvm/memslot_modification_stress_test.c    | 211 ++++++++++++++++++
 9 files changed, 307 insertions(+), 51 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/memslot_modification_stress_test.c

-- 
2.30.0.284.gd98b1dd5eaa7-goog


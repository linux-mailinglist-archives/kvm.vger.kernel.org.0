Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728EF277662
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 18:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgIXQQ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 12:16:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56014 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726458AbgIXQQ2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 12:16:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600964187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=5f9IDQpqKUYEZt/PJc6SN3XdD+SlWrtomGR4ny1qU3M=;
        b=NLC9UKDPGmym/FnqJyo6MNQCtZJoMWgdIT7iKxk6x268JvrHmC9ZDeKBfd9SaA+6QEa5Qf
        6GbuT43K6gzwLUcYQugnYrbkNqqJDdKvkVyZT+c4tjYtfiSumhYSI8bbb+7Y3mxz77Iozy
        CvEYepngJ6XkpGsZ27GzR3OeQKcY9RM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-DfzocSktP2mCtUwC0lvtBQ-1; Thu, 24 Sep 2020 12:16:25 -0400
X-MC-Unique: DfzocSktP2mCtUwC0lvtBQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69F6584E247;
        Thu, 24 Sep 2020 16:16:24 +0000 (UTC)
Received: from thuth.com (ovpn-113-113.ams2.redhat.com [10.36.113.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9899573662;
        Thu, 24 Sep 2020 16:16:19 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Drew Jones <drjones@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [kvm-unit-tests PATCH 0/9] Update travis CI
Date:   Thu, 24 Sep 2020 18:16:03 +0200
Message-Id: <20200924161612.144549-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Travis now features Ubuntu Focal containers, so we can update our
kvm-unit-tests CI to use it for getting a newer version of QEMU and
the compilers. Thanks to this QEMU update, we can now run more tests
with TCG here.

Additionally, this series switches the second aarch64 build job to
use the native builder - this way we can use the Clang compiler
there to get some additional test coverage. This indeed already helped
to discover some bogus register constraints in the aarch64 code.
(ppc64 and s390x are not using the native builders yet since there are
still some issues with Clang there that I haven't quite figured out ...
that's maybe something for later)

Thomas Huth (9):
  travis.yml: Update from Bionic to Focal
  travis.yml: Rework the x86 64-bit tests
  travis.yml: Refresh the x86 32-bit test list
  travis.yml: Add the selftest-setup ppc64 test
  kbuild: fix asm-offset generation to work with clang
  arm/pmu: Fix inline assembly for Clang
  lib/arm64/spinlock: Fix inline assembly for Clang
  travis.yml: Rework the aarch64 jobs
  travis.yml: Update the list of s390x tests

 .travis.yml             | 71 ++++++++++++++++++++++++-----------------
 arm/pmu.c               | 10 +++---
 lib/arm64/spinlock.c    |  2 +-
 lib/kbuild.h            |  6 ++--
 scripts/asm-offsets.mak |  5 +--
 5 files changed, 54 insertions(+), 40 deletions(-)

-- 
2.18.2


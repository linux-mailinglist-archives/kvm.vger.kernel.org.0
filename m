Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF0915490E
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 17:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbgBFQYz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 11:24:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41452 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727711AbgBFQYy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 11:24:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581006293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qN8RCxXeAK1r7ort6M2u2im4/XhxQCSZbxycfi3O8rs=;
        b=P51INxJN5bZcqnzc8cs0/+O3sGBjMwr9BD+QSuP0hJHTYB8mDVC7fCoQ3m1BGKM90moXhh
        RbXt/za+zoTXGc4K2LmK3PPWpKc2GbHuE/xmCfpEA+U9GIDmLhuPoRgITv2iifylZCQp8x
        Kd/I6oVFSlvp1ubMLKDQj+Q99Xg7aJU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-rtjQKo5bO7KlvdKH3eQ1sw-1; Thu, 06 Feb 2020 11:24:37 -0500
X-MC-Unique: rtjQKo5bO7KlvdKH3eQ1sw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5969E1034AE1
        for <kvm@vger.kernel.org>; Thu,  6 Feb 2020 16:24:36 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82C1810016DA;
        Thu,  6 Feb 2020 16:24:35 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PULL kvm-unit-tests 00/10] arm/arm64: Various fixes
Date:   Thu,  6 Feb 2020 17:24:24 +0100
Message-Id: <20200206162434.14624-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

This pull request contains one general Makefile fix, but the rest
are a nice collection of fixes for arm/arm64 from Alexandru.

Thanks,
drew



The following changes since commit 5779d60cccfbd325a68837795c6884c6bf6d7e=
67:

  Merge tag 's390x-2020-02-04' of https://gitlab.com/huth/kvm-unit-tests =
into HEAD (2020-02-05 16:47:23 +0100)

are available in the Git repository at:

  https://github.com/rhdrjones/kvm-unit-tests arm/queue

for you to fetch changes up to 528d32d4e63c3ee43f3b8c005968caddbbf0f0bb:

  arm/arm64: Perform dcache clean + invalidate after turning MMU off (202=
0-02-06 16:59:57 +0100)

----------------------------------------------------------------
Alexandru Elisei (10):
      Makefile: Use no-stack-protector compiler options
      arm/arm64: psci: Don't run C code without stack or vectors
      arm64: timer: Add ISB after register writes
      arm64: timer: Add ISB before reading the counter value
      arm64: timer: Make irq_received volatile
      arm64: timer: EOIR the interrupt after masking the timer
      arm64: timer: Wait for the GIC to sample timer interrupt state
      arm64: timer: Check the timer interrupt state
      arm64: timer: Test behavior when timer disabled or masked
      arm/arm64: Perform dcache clean + invalidate after turning MMU off

 Makefile                  |  4 ++--
 arm/cstart.S              | 22 ++++++++++++++++++++++
 arm/cstart64.S            | 23 +++++++++++++++++++++++
 arm/psci.c                | 14 +++++++++++---
 arm/timer.c               | 79 +++++++++++++++++++++++++++++++++++++++++=
+++++++++++++++++++++++++-------------
 arm/unittests.cfg         |  2 +-
 lib/arm/asm/processor.h   | 13 +++++++++++++
 lib/arm/setup.c           |  8 ++++++++
 lib/arm64/asm/processor.h | 12 ++++++++++++
 9 files changed, 158 insertions(+), 19 deletions(-)

--=20
2.21.1


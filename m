Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9188E1FBE92
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 20:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730263AbgFPS4c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 14:56:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30193 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725911AbgFPS4b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 14:56:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592333789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=EkeSX+EiBATyC7DxJif6NPiC4iQnBSzJeKJ/vXyLHuI=;
        b=hJouHnEJUWqJy3763JrpbF25gkHwQsdBNLuFP4rU4XPjdlF+ZNrysupk6EBti0xkHeTJzd
        UcdFU8BfF/Iqbs1Tjq8kWBFwWQnLNR4lEyC70zUIbqpe+MOnpzWnPTz2JQFyBfdNhePUJ8
        bHCUsd5cm/V8ZZbHHwRnQL3W25pFO6c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-c8q40vYtPkaqb8EAVMr-Jg-1; Tue, 16 Jun 2020 14:56:26 -0400
X-MC-Unique: c8q40vYtPkaqb8EAVMr-Jg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B8A518A2664
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 18:56:25 +0000 (UTC)
Received: from thuth.com (ovpn-114-128.ams2.redhat.com [10.36.114.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F1347CAA8;
        Tue, 16 Jun 2020 18:56:23 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PULL 00/12] CI-related fixes and improvements
Date:   Tue, 16 Jun 2020 20:56:10 +0200
Message-Id: <20200616185622.8644-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

 Hi Paolo,

the following changes since commit 4b74c718c57d1697e3228e2c699b0fe9c1d24e97:

  x86/pmu: Fix compilation on 32-bit hosts (2020-06-16 08:29:34 -0400)

are available in the Git repository at:

  https://gitlab.com/huth/kvm-unit-tests.git tags/pull-request-2020-06-16

for you to fetch changes up to 9d7f9a2f0b3427bbeda242c64f698d14e21d2a42:

  s390x: stsi: Make output tap13 compatible (2020-06-16 20:22:14 +0200)

----------------------------------------------------------------
* Lots of CI-related fixes and improvements
* Update the gitlab-CI to Fedora 32
* Test compilation with Clang
----------------------------------------------------------------

Andrew Jones (1):
      Fix out-of-tree builds

Bill Wendling (2):
      x86: use a non-negative number in shift
      x86: use inline asm to retrieve stack pointer

Janosch Frank (1):
      s390x: stsi: Make output tap13 compatible

Paolo Bonzini (2):
      x86: avoid multiple defined symbol
      x86: disable SSE on 32-bit hosts

Thomas Huth (6):
      Fixes for the umip test
      Always compile the kvm-unit-tests with -fno-common
      Fix powerpc issue with the linker from Fedora 32
      Update the gitlab-ci to Fedora 32
      vmx_tests: Silence warning from Clang
      Compile the kvm-unit-tests also with Clang

 .gitlab-ci.yml       | 17 +++++++++++++++--
 Makefile             |  2 +-
 configure            |  8 +++-----
 lib/auxinfo.h        |  3 +--
 lib/x86/fault_test.c |  2 +-
 lib/x86/usermode.c   |  2 +-
 powerpc/flat.lds     | 19 ++++++++++++++++---
 s390x/stsi.c         |  6 +++---
 x86/Makefile.common  |  1 +
 x86/Makefile.i386    |  1 +
 x86/svm_tests.c      |  2 +-
 x86/umip.c           |  6 ++++--
 x86/vmx_tests.c      | 10 +++++++---
 13 files changed, 55 insertions(+), 24 deletions(-)


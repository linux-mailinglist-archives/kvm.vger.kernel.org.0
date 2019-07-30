Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C29B47AD24
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 18:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730460AbfG3QB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 12:01:58 -0400
Received: from relay.sw.ru ([185.231.240.75]:41016 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727937AbfG3QB6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 12:01:58 -0400
Received: from [172.16.25.136] (helo=localhost.sw.ru)
        by relay.sw.ru with esmtp (Exim 4.92)
        (envelope-from <andrey.shinkevich@virtuozzo.com>)
        id 1hsUZR-0001RG-FB; Tue, 30 Jul 2019 19:01:49 +0300
From:   Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>
To:     qemu-devel@nongnu.org, qemu-block@nongnu.org
Cc:     kvm@vger.kernel.org, berto@igalia.com, mdroth@linux.vnet.ibm.com,
        armbru@redhat.com, ehabkost@redhat.com, rth@twiddle.net,
        mtosatti@redhat.com, pbonzini@redhat.com, den@openvz.org,
        vsementsov@virtuozzo.com, andrey.shinkevich@virtuozzo.com
Subject: [PATCH 0/3] Reduce the number of Valgrind reports in unit tests.
Date:   Tue, 30 Jul 2019 19:01:35 +0300
Message-Id: <1564502498-805893-1-git-send-email-andrey.shinkevich@virtuozzo.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Running unit tests under the Valgrind may help to detect QEMU memory issues
(suggested by Denis V. Lunev). Some of the Valgrind reports relate to the
unit test code itself. Let's eliminate the detected memory issues to ease
locating critical ones.

Andrey Shinkevich (3):
  test-throttle: Fix uninitialized use of burst_length
  tests: Fix uninitialized byte in test_visitor_in_fuzz
  i386/kvm: initialize struct at full before ioctl call

 target/i386/kvm.c                 | 3 +++
 tests/test-string-input-visitor.c | 8 +++-----
 tests/test-throttle.c             | 2 ++
 3 files changed, 8 insertions(+), 5 deletions(-)

-- 
1.8.3.1


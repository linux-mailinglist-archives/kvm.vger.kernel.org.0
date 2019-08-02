Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3756A7ED5A
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 09:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389519AbfHBHXg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 03:23:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38882 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728404AbfHBHXg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 03:23:36 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6A69C859FB;
        Fri,  2 Aug 2019 07:23:36 +0000 (UTC)
Received: from thuth.com (dhcp-200-228.str.redhat.com [10.33.200.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C5BE760922;
        Fri,  2 Aug 2019 07:23:32 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [kvm-unit-tests PULL 0/2] New s390x test for CPU model + CI fix for ARM
Date:   Fri,  2 Aug 2019 09:23:27 +0200
Message-Id: <20190802072329.8276-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Fri, 02 Aug 2019 07:23:36 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

 Hi Paolo, hi Radim,

the following changes since commit 2130fd4154ad5cb2841d831c0c8b92d19b642fd5:

  tscdeadline_latency: Check condition first before loop (2019-07-11 14:26:53 +0200)

are available in the Git repository at:

  https://gitlab.com/huth/kvm-unit-tests.git tags/pull-request-2019-08-02

for you to fetch changes up to 0d72123587961d31897868b8bda820759cf1ef9d:

  Force GCC version to 8.2 for compiling the ARM tests (2019-08-02 09:14:15 +0200)

----------------------------------------------------------------
- New test for facility dependencies on s390x
- Work around problem with GCC 9 in the gitlab CI
----------------------------------------------------------------

Christian Borntraeger (1):
      kvm-unit-tests: s390: add cpu model checks

Thomas Huth (1):
      Force GCC version to 8.2 for compiling the ARM tests

 .gitlab-ci.yml      |  2 +-
 s390x/Makefile      |  1 +
 s390x/cpumodel.c    | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |  3 +++
 4 files changed, 65 insertions(+), 1 deletion(-)
 create mode 100644 s390x/cpumodel.c

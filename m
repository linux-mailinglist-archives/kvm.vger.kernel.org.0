Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17C83174D0
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 11:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbfEHJPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 05:15:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58004 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbfEHJPx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 05:15:53 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2FD0A3007455
        for <kvm@vger.kernel.org>; Wed,  8 May 2019 09:15:53 +0000 (UTC)
Received: from xz-x1.nay.redhat.com (dhcp-15-205.nay.redhat.com [10.66.15.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D33695C225;
        Wed,  8 May 2019 09:15:48 +0000 (UTC)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        peterx@redhat.com, "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: [PATCH v2 0/3] kvm: Some more trivial fixes for clear dirty log
Date:   Wed,  8 May 2019 17:15:44 +0800
Message-Id: <20190508091547.11963-1-peterx@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Wed, 08 May 2019 09:15:53 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2:
- fix patch 2 to use DIV_ROUND_UP
- add one more patch to obsolete the old cap, and introduce new [Paolo]

Two issues I've noticed when I'm drafting the QEMU support of it.
With these two patches applied the QEMU binary (with the clear dirty
log supported [1]) can migrate correctly otherwise the migration can
stall forever if with/after heavy memory workload.

Please have a look, thanks.

[1] https://github.com/xzpeter/qemu/tree/kvm-clear-dirty-log

Peter Xu (3):
  KVM: Fix the bitmap range to copy during clear dirty
  KVM: Fix loop of clear dirty with possible off-by-one
  KVM: Introduce KVM_CAP_MANUAL_DIRTY_LOG_PROTECT_2

 Documentation/virtual/kvm/api.txt            | 13 ++++++++-----
 include/uapi/linux/kvm.h                     |  5 +++--
 tools/testing/selftests/kvm/dirty_log_test.c |  4 ++--
 virt/kvm/kvm_main.c                          | 10 +++++-----
 4 files changed, 18 insertions(+), 14 deletions(-)

-- 
2.17.1


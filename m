Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 373E6D015C
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 21:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730452AbfJHTnm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 15:43:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55416 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728465AbfJHTnm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 15:43:42 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 27CA2A44AF2;
        Tue,  8 Oct 2019 19:43:42 +0000 (UTC)
Received: from vitty.brq.redhat.com (ovpn-204-92.brq.redhat.com [10.40.204.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4396A5D6A7;
        Tue,  8 Oct 2019 19:43:40 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 0/3] selftests: kvm: improvements to VMX support check
Date:   Tue,  8 Oct 2019 21:43:35 +0200
Message-Id: <20191008194338.24159-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Tue, 08 Oct 2019 19:43:42 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vmx_dirty_log_test fails on AMD and this is no surprise as it is VMX
specific. Consolidate checks from other VMX tests into a library routine
and add a check to skip the test when !VMX.

Vitaly Kuznetsov (3):
  selftests: kvm: vmx_set_nested_state_test: don't check for VMX support
    twice
  selftests: kvm: consolidate VMX support checks
  selftests: kvm: vmx_dirty_log_test: skip the test when VMX is not
    supported

 tools/testing/selftests/kvm/include/x86_64/vmx.h    |  2 ++
 tools/testing/selftests/kvm/lib/x86_64/vmx.c        | 10 ++++++++++
 .../kvm/x86_64/vmx_close_while_nested_test.c        |  6 +-----
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c       |  2 ++
 .../kvm/x86_64/vmx_set_nested_state_test.c          | 13 ++-----------
 .../selftests/kvm/x86_64/vmx_tsc_adjust_test.c      |  6 +-----
 6 files changed, 18 insertions(+), 21 deletions(-)

-- 
2.20.1


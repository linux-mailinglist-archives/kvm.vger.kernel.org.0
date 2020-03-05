Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D60DA17AD2A
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 18:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbgCERZw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 12:25:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23754 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725938AbgCERZv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 12:25:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583429151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=LNaeYUuZ/I8N5sWDPpA8Jaa5r8899vfI3fz+QN5P+JQ=;
        b=Vfd9qM7PAiQtytjcKpI/TgPKhPaYUvVvKpj2Dca27L820+7A5sFeN7wkO7VI6RZQuAcZ0Y
        hNH3bKcaM3STmdnnaIsKJw7+Tfij93aXMynWKjg9qT1Khy+TlDMlL6khKcLCxrxfd0dTKe
        z5YoCMOPZhOCC9pJ4Qh9zQ5u1FlSTe8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-gvySo0gPN4e7waaKGzfUMA-1; Thu, 05 Mar 2020 12:25:47 -0500
X-MC-Unique: gvySo0gPN4e7waaKGzfUMA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1B9C1005509;
        Thu,  5 Mar 2020 17:25:45 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-124.gru2.redhat.com [10.97.116.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 704005C219;
        Thu,  5 Mar 2020 17:25:41 +0000 (UTC)
From:   Wainer dos Santos Moschetta <wainersm@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     shuah@kernel.org, tglx@linutronix.de, thuth@redhat.com,
        sean.j.christopherson@intel.com, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/1] kvm: selftests: Add TEST_FAIL macro
Date:   Thu,  5 Mar 2020 14:25:31 -0300
Message-Id: <20200305172532.9360-1-wainersm@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following patch's commit message is self-explanatory about this proposal.

I adjusted to use TEST_FAIL only a few source files, in reality it will
need to change all the ones listed below. I will proceed with the
adjustments if this new macro idea is accepted.

$ find . -type f -name "*.c" -exec grep -l "TEST_ASSERT(false" {} \;
./lib/kvm_util.c
./lib/io.c
./lib/x86_64/processor.c
./lib/aarch64/ucall.c
./lib/aarch64/processor.c
./x86_64/vmx_dirty_log_test.c
./x86_64/state_test.c
./x86_64/vmx_tsc_adjust_test.c
./x86_64/svm_vmcall_test.c
./x86_64/evmcs_test.c
./x86_64/vmx_close_while_nested_test.c

Wainer dos Santos Moschetta (1):
  kvm: selftests: Add TEST_FAIL macro

 tools/testing/selftests/kvm/dirty_log_test.c             | 7 +++----
 tools/testing/selftests/kvm/include/test_util.h          | 3 +++
 tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c | 4 ++--
 3 files changed, 8 insertions(+), 6 deletions(-)

-- 
2.17.2


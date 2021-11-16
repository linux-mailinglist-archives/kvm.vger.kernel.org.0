Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D264534E3
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 16:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237892AbhKPPHT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 10:07:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:56846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237921AbhKPPG0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 10:06:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D79261178;
        Tue, 16 Nov 2021 15:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637075009;
        bh=fd+4IpcckmJCv5DVzDaeYbY9dErPRQQTYtd2HeahSA8=;
        h=Date:From:To:Cc:Subject:From;
        b=qhl3jHBkzwuB+n3VI36UupE17lubHYyXDAFpKGYBTnoypaRXPeSFXUQJ1m73IBnvN
         0ruMIVcShLlpzZpfWHPzZDhZYcyPV6TqTrEP6KTU18ZlmaNlUmDvwPdVo2kgTyH9oN
         nWMAWiYYKX83dIVS4m+BrGeEpuh9uiwF0dN6f4URphlU/zQCCT08Yi3mbCEnXlclpL
         e7VCE/wiAqgEJBYT327806y2UOZpySyj5rmI5ab8Df9cULUA6rR4rFV4c1YdDirTM1
         peEIl/mJyD/c/Eo+8xpv+dWnvbQpe2igdsdiuMFVZ4cVkmlGOq08s4nJHQnC76JUcR
         92IHsEFnFKykg==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 8086C4088E; Tue, 16 Nov 2021 12:03:25 -0300 (-03)
Date:   Tue, 16 Nov 2021 12:03:25 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Marc Orr <marcorr@google.com>, Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] selftests: KVM: Add /x86_64/sev_migrate_tests to
 .gitignore
Message-ID: <YZPIPfvYgRDCZi/w@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  $ git status
  nothing to commit, working tree clean
  $
  $ make -C tools/testing/selftests/kvm/ > /dev/null 2>&1
  $ git status

  Untracked files:
    (use "git add <file>..." to include in what will be committed)
  	tools/testing/selftests/kvm/x86_64/sev_migrate_tests

  nothing added to commit but untracked files present (use "git add" to track)
  $

Fixes: 6a58150859fdec76 ("selftest: KVM: Add intra host migration tests")
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Marc Orr <marcorr@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Gonda <pgonda@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/testing/selftests/kvm/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index d4a8301396833fc8..3763105029fb3b3c 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -23,6 +23,7 @@
 /x86_64/platform_info_test
 /x86_64/set_boot_cpu_id
 /x86_64/set_sregs_test
+/x86_64/sev_migrate_tests
 /x86_64/smm_test
 /x86_64/state_test
 /x86_64/svm_vmcall_test
-- 
2.31.1


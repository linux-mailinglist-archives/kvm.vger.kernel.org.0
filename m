Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D711B1A53
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 01:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgDTXxJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 19:53:09 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:56801 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbgDTXxJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Apr 2020 19:53:09 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 495k680rMFz9sSK; Tue, 21 Apr 2020 09:53:03 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1587426784; bh=4g/i2MGnTG6nJDseUfUwsw1dXEWqVewuevwTuwG5qgk=;
        h=Date:From:To:Cc:Subject:From;
        b=AAw+ol29IphyefKgOkTg7mgJkCBqOuFEFDhNrJ+knK0TX+o9mttp4ZHY+8q6TO2w8
         ebHBXStg/TFfEUk1fpxqtc4W2Lu5MlYwvx/r7zfa2seqBUwxeAKNXZFGLkrPnRKQ0B
         TBmHL5AYkCLTItwPzsNgefMG+r/M5WKibl9w045j3lkCk9FYmF2DAyYqWr8p/5gpGe
         clM5pexpppqnhvdoEEP767YmaQPt1jD2uGyU8prUdq9Iq7sAJjp3elT3wgdeEOUqO7
         FXzRNB8Y/QTc+fkkLc6TNb50F2f1XdkZudgp5JemyiGXjBQ402OB7On5hT63/kZ+ks
         oGaXkmcrgNf4g==
Date:   Tue, 21 Apr 2020 09:53:00 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Subject: [GIT PULL] Please pull my kvm-ppc-fixes-5.7-1 tag
Message-ID: <20200420235300.GA7086@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Please do a pull from my kvm-ppc-fixes-5.7-1 tag to get one commit
which fixes a regression introduced in the 5.7 merge window by one of
my patches.  It causes guests in HPT mode occasionally to get a
spurious EFAULT error return from KVM_RUN, which tends to cause them
to die.

Thanks,
Paul.

The following changes since commit dbef2808af6c594922fe32833b30f55f35e9da6d:

  KVM: VMX: fix crash cleanup when KVM wasn't used (2020-04-07 08:35:36 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-fixes-5.7-1

for you to fetch changes up to ae49dedaa92b55258544aace7c585094b862ef79:

  KVM: PPC: Book3S HV: Handle non-present PTEs in page fault functions (2020-04-21 09:23:41 +1000)

----------------------------------------------------------------
PPC KVM fix for 5.7

- Fix a regression introduced in the last merge window, which results
  in guests in HPT mode dying randomly.

----------------------------------------------------------------
Paul Mackerras (1):
      KVM: PPC: Book3S HV: Handle non-present PTEs in page fault functions

 arch/powerpc/kvm/book3s_64_mmu_hv.c    | 9 +++++----
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 9 +++++----
 2 files changed, 10 insertions(+), 8 deletions(-)

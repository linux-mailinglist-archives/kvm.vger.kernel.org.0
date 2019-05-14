Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACDB1C6C1
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 12:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfENKNe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 06:13:34 -0400
Received: from ozlabs.org ([203.11.71.1]:36593 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbfENKNd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 06:13:33 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 453D6M23T0z9sMr; Tue, 14 May 2019 20:13:31 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1557828811; bh=3ZC5rwVVnYc/CNFGC04hlUVgDbQl3qTlacY4Q4Fe3gs=;
        h=Date:From:To:Cc:Subject:From;
        b=Rip0U82hdADw5tkVqMuajXtlMgTw+dwy1P0+sNBZyRoenbsb3BC2Y3gDT5138MC0r
         q8+vP9HWUg34wfHaD1pUcg348FAH7QALuiB1iQ8atbJvFXThwiozhXrJ2lGz7qkoWM
         KQ8nybgvRLQmYuRvjMaqp3s2JS+6YEe0g43qGRbWU0cmoRLmYqP2RnhYvTbcB5335E
         ByX6j0EFgYhwndgsGkYi0Spmj/q5T539NwGMPR1GRE4NRQX6VJ0jUgX4quTC+H6IQZ
         smYbuk4iLW3kzkSyuwXYyRfvOxjGDy8+hK4wjeKPcbdl0GKA75YfX05LmSN4fN3RWD
         opOz+LG6C5F3w==
Date:   Tue, 14 May 2019 20:13:27 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org
Subject: [GIT PULL] Please pull my kvm-ppc-next-5.2-2 tag
Message-ID: <20190514101327.GA13522@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo, Radim,

I have added 3 more commits to my kvm-ppc-next tree, for various fixes
that have come in recently.  There is one bug fix, one spelling fix,
and one commit that removes some code that does nothing.  The net
result is 12 fewer lines of code in the kernel. :)

If you pull this tag and not the earlier kvm-ppc-next-5.2-1 tag, you
might want to include the text from that tag in the commit message.
That text is:

"
PPC KVM update for 5.2

* Support for guests to access the new POWER9 XIVE interrupt controller
  hardware directly, reducing interrupt latency and overhead for guests.

* In-kernel implementation of the H_PAGE_INIT hypercall.

* Reduce memory usage of sparsely-populated IOMMU tables.

* Several bug fixes.
"

Thanks,
Paul.

The following changes since commit 0caecf5b00199636eb2d32201199ecd6be52558d:

  KVM: PPC: Book3S HV: XIVE: Clear escalation interrupt pointers on device close (2019-04-30 19:41:01 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-next-5.2-2

for you to fetch changes up to 4894fbcce856635c9ab79f44e50826e86bb92110:

  KVM: PPC: Book3S: Remove useless checks in 'release' method of KVM device (2019-05-14 12:06:03 +1000)

----------------------------------------------------------------
Second PPC KVM update for 5.2

- Fix a bug, fix a spelling mistake, remove some useless code.

----------------------------------------------------------------
Colin Ian King (1):
      KVM: PPC: Book3S HV: XIVE: Fix spelling mistake "acessing" -> "accessing"

Cédric Le Goater (1):
      KVM: PPC: Book3S: Remove useless checks in 'release' method of KVM device

Paul Mackerras (1):
      KVM: PPC: Book3S HV: Make sure to load LPID for radix VCPUs

 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 6 ------
 arch/powerpc/kvm/book3s_xive_native.c   | 2 +-
 virt/kvm/kvm_main.c                     | 6 ------
 3 files changed, 1 insertion(+), 13 deletions(-)

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 385C510862D
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2019 01:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfKYA6c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Nov 2019 19:58:32 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:47659 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727126AbfKYA6c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Nov 2019 19:58:32 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 47LpYy0Ym2z9sPf; Mon, 25 Nov 2019 11:58:29 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1574643510; bh=OFA72bnCsrg8Coz2J033yUMxPG/0CYGgg43ImyrX5as=;
        h=Date:From:To:Cc:Subject:From;
        b=UMXTR6Ueq1Mp1Xw7kFaK2/tR6xb6L9u4Qo+4ItVShcTkTkYLgZkgcnBNDztKuMKRh
         olEfTtgIY/ccRiGhobeVhlPh2rVmQel2thV5TGtfXRqeZqgpdFCvBB/+dw+DPyMEw2
         G05NKoaBCIdOUPbI4tvlYfXfU+zawTFqcp58oaqiylWtY/rgui2jJ71rFaTwoa0KTt
         rmR5hWt2HBGU/sotcZPlSXEedFIfhhY0GQWNbdx2sFtIC11A6e35Tnmd5QgzghINw2
         E8iXyMYmdyp9d319930Ok8/wM3gul4xprfeCkc6hyO6pvLaiRfckXIGDekRqmp1GIP
         Sr5d87CPvRw8Q==
Date:   Mon, 25 Nov 2019 11:58:26 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, Greg Kurz <groug@kaod.org>
Subject: [GIT PULL] Please pull my kvm-ppc-next-5.5-2 tag
Message-ID: <20191125005826.GA25463@oak.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Please do a pull from my kvm-ppc-next-5.5-2 tag to get two more
commits which should go upstream for 5.5.  Although they are in my
kvm-ppc-next branch, they are actually bug fixes, fixing host memory
leaks in the XIVE interrupt controller code, so they should be fine to
go into v5.5 even though the merge window is now open.

Thanks,
Paul.

The following changes since commit 55d7004299eb917767761f01a208d50afad4f535:

  KVM: PPC: Book3S HV: Reject mflags=2 (LPCR[AIL]=2) ADDR_TRANS_MODE mode (2019-10-22 16:29:02 +1100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-next-5.5-2

for you to fetch changes up to 30486e72093ea2e594f44876b7a445c219449bce:

  KVM: PPC: Book3S HV: XIVE: Fix potential page leak on error path (2019-11-21 16:24:41 +1100)

----------------------------------------------------------------
Second KVM PPC update for 5.5

- Two fixes from Greg Kurz to fix memory leak bugs in the XIVE code.

----------------------------------------------------------------
Greg Kurz (2):
      KVM: PPC: Book3S HV: XIVE: Free previous EQ page when setting up a new one
      KVM: PPC: Book3S HV: XIVE: Fix potential page leak on error path

 arch/powerpc/kvm/book3s_xive_native.c | 44 +++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 15 deletions(-)

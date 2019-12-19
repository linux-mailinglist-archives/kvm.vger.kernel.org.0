Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD08A125866
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 01:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfLSATW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 19:19:22 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:50811 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbfLSATW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 19:19:22 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 47dXYh2zFLz9sPh; Thu, 19 Dec 2019 11:19:20 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1576714760; bh=zDFPOp5nfTe9y2XdAgtTDk1OYIJnpIlIJMAWmNX76Rs=;
        h=Date:From:To:Cc:Subject:From;
        b=QPXN2QO89XnH+U6Igy7bOrJWBozpChUM+Wfy1iWU17v9LnKwNUDPwiIJ6RdsQ6UDU
         0dVpA3TDAPB379FbLFETgcaMriAGXc6QdxOdLISkVhXDDOQjyB5PsJg1qggTpjLG3n
         2NkzffxNyh3l+6xNAPkomM4cZNw88a9Ui5ofcIfFI9TQ0TiQFgt67D4irpjlRUhuHd
         EUy4Ew0JUrO7StTViV3GYagW726jQvmjqU11dnYGh7ifz9f5Gc4HfXGa/8VTodJ5Nb
         s7PAww+V/uN6m/iRZZua2LMIEkQHrNx7oE78quTyj1zyHbr3WmXTI8u/PdV91sgPmt
         lgRRVXFVoP3CA==
Date:   Thu, 19 Dec 2019 11:19:12 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org
Subject: [GIT PULL] Please pull my kvm-ppc-fixes-5.5-1 tag
Message-ID: <20191219001912.GA12288@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Please do a pull from my kvm-ppc-fixes-5.5-1 to get one commit which
should go in 5.5.  It fixes a regression introduced in my last pull,
which added an ultravisor call even on systems without an ultravisor.

Thanks,
Paul.

The following changes since commit 7d73710d9ca2564f29d291d0b3badc09efdf25e9:

  kvm: vmx: Stop wasting a page for guest_msrs (2019-12-04 12:23:27 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-fixes-5.5-1

for you to fetch changes up to d89c69f42bf0fe42d1f52ea9b3dca15b1ade7601:

  KVM: PPC: Book3S HV: Don't do ultravisor calls on systems without ultravisor (2019-12-18 15:46:34 +1100)

----------------------------------------------------------------
PPC KVM fix for 5.5

- Fix a bug where we try to do an ultracall on a system without an
  ultravisor.

----------------------------------------------------------------
Paul Mackerras (1):
      KVM: PPC: Book3S HV: Don't do ultravisor calls on systems without ultravisor

 arch/powerpc/kvm/book3s_hv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

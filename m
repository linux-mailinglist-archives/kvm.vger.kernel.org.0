Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51BADDE31C
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 06:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfJUETu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 00:19:50 -0400
Received: from ozlabs.org ([203.11.71.1]:53351 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbfJUETu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 00:19:50 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 46xNhM73BQz9sPL; Mon, 21 Oct 2019 15:19:47 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1571631587; bh=tFDCZHiCpDGbaT0g9jIZjA6STP+v2L5+76W/D47yv9Y=;
        h=Date:From:To:Cc:Subject:From;
        b=tIY5F3uZeIgiqDlirqZ5oQdhDWT8xCCUei8csmJxyyxai9Et8lFhPTlP3SPUXars6
         MAbJl0gE0dABKeiz3DiVEpnb3mJ+gf7Md+5TiQkgnNOen0Fhlgo12SN+Fdplu5uMHl
         DlyhsOT3LK+9Eypnp5IpsO8DAJdDo699v0vTbTW1eT0QVktaJiqHVo77sit1o9BxNq
         sYgGnpq9yA3bEOr6gp4xKoQafzbQLL69q2dxS/xkVQCPqQkD0Udfo4fEubsp7A80/2
         dm/DKWXrw3CWNwK4S2IiKR0Cq0WnBP/seSVrS7TbPIH0+sgXAYqhZs98FV4V/4JNHH
         WXvsVcSnS7ROw==
Date:   Mon, 21 Oct 2019 15:19:41 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Subject: [GIT PULL] Please pull my kvm-ppc-fixes-5.4-1 tag
Message-ID: <20191021041941.GA17498@oak.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo or Radim,

Please do a pull from my kvm-ppc-fixes-5.4-1 tag to get a commit which
fixes a potential host crash.  I have based my tree on 5.4-rc3 because
there is another KVM fix which is included in 5.4-rc3, having gone
upstream via Michael Ellerman's tree.

Thanks,
Paul.

The following changes since commit 4f5cafb5cb8471e54afdc9054d973535614f7675:

  Linux 5.4-rc3 (2019-10-13 16:37:36 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-fixes-5.4-1

for you to fetch changes up to 12ade69c1eb9958b13374edf5ef742ea20ccffde:

  KVM: PPC: Book3S HV: XIVE: Ensure VP isn't already in use (2019-10-15 16:09:11 +1100)

----------------------------------------------------------------
PPC KVM fix for 5.4

- Fix a bug in the XIVE code which can cause a host crash.

----------------------------------------------------------------
Greg Kurz (1):
      KVM: PPC: Book3S HV: XIVE: Ensure VP isn't already in use

 arch/powerpc/kvm/book3s_xive.c        | 24 ++++++++++++++++--------
 arch/powerpc/kvm/book3s_xive.h        | 12 ++++++++++++
 arch/powerpc/kvm/book3s_xive_native.c |  6 ++++--
 3 files changed, 32 insertions(+), 10 deletions(-)

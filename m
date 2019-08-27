Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4FF59E4F3
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 11:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729523AbfH0Jxq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 05:53:46 -0400
Received: from ozlabs.org ([203.11.71.1]:58623 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728883AbfH0Jxp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 05:53:45 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 46Hkj34P0Dz9sBF; Tue, 27 Aug 2019 19:53:43 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1566899623; bh=t6/73EjuF6lJD3vndlHCMS7wuROyK8CMl9+AMLeKESY=;
        h=Date:From:To:Cc:Subject:From;
        b=drvcqPoXL2O5q/SiHCsJcM00v3xX/xRnF6GtGEbpZR+8fhkU+8EnAxFSaumKWmc/Q
         7AdQdmdRGr2Xl1yLRuq0kVGQJ/zPB6NXghY8zJmYaJBeBn6BBmxwar02Z0ZFRVMlTJ
         qjZArhmMIeOig0++PCIr3kV+Q1VzdpLJYSbGkk6k6cJLSqWBp/4tTmlrtcwtazL5lH
         lm4TYBAu9YPdS+EyuYZwPBAH+7+oH+8I294253uidNQ/fVRqi02pxnnPf1CaAQjoQK
         bVYu4hoc8mSEFi8OFkx2L2df6gJWcfz7W9Fjfg552ptlZ/1vRix3OGMF3GYxPmkYU5
         6U2zPqPMKKy8w==
Date:   Tue, 27 Aug 2019 19:53:38 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Subject: [GIT PULL] Please pull my kvm-ppc-fixes-5.3-1 tag
Message-ID: <20190827095338.GA22875@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo or Radim,

Please do a pull from my kvm-ppc-fixes-5.3-1 tag to get one small
commit which I would like to go to Linus for 5.3 if possible, since it
fixes a bug where a malicious guest could cause host CPUs to hang
hard.  The fix is small and obviously correct.

Thanks,
Paul.

The following changes since commit e4427372398c31f57450565de277f861a4db5b3b:

  selftests/kvm: make platform_info_test pass on AMD (2019-08-21 19:08:18 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-fixes-5.3-1

for you to fetch changes up to ddfd151f3def9258397fcde7a372205a2d661903:

  KVM: PPC: Book3S: Fix incorrect guest-to-user-translation error handling (2019-08-27 10:59:30 +1000)

----------------------------------------------------------------
KVM/PPC fix for 5.3

- Fix bug which could leave locks locked in the host on return
  to a guest.

----------------------------------------------------------------
Alexey Kardashevskiy (1):
      KVM: PPC: Book3S: Fix incorrect guest-to-user-translation error handling

 arch/powerpc/kvm/book3s_64_vio.c    | 6 ++++--
 arch/powerpc/kvm/book3s_64_vio_hv.c | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

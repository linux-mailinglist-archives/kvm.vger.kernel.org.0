Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3BB710C34C
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 05:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbfK1E4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 23:56:44 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:35697 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbfK1E4o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 23:56:44 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 47NljP3y4zz9sPL; Thu, 28 Nov 2019 15:56:41 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1574917001; bh=dq/B6bAPFmqaGLATrGnSHKh6kfJmN3b0JQehcdPnYtU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n0YjGm0+WUE/mAWbwEBnHeHpoAhycAW4uSUqCMso72OfrvDMubpSw+IwhpyxQBZ//
         v0z8HWhAUtL5hdjF58njrD2mnP/URxH29lwcAU4ELS2YwUgpeCOebQ+LdBTLaAdq2n
         ws+r4hWglzx6/IEWg/K81C5ZJpk8UODMtJC/YZ08Wns5jCQW1sm7nhfXTu87bcqFbN
         TmFb3Z4uN4UDTEkZvK3njR7tjnpX6EcJRV23kkSgb0mHjnT8Tfkwst7djOPLlCULVz
         VBZxSCAFj9nqwu3/OqR+UYfPZ8FZzdh5Jxufyf4MbSqCIRKunWQFmOhL+piBwHjNe+
         z5KxTH4tswrKw==
Date:   Thu, 28 Nov 2019 15:56:39 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [GIT PULL] Please pull my kvm-ppc-uvmem-5.5 tag
Message-ID: <20191128045639.GA28618@oak.ozlabs.ibm.com>
References: <20191126052455.GA2922@oak.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191126052455.GA2922@oak.ozlabs.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 26, 2019 at 04:24:55PM +1100, Paul Mackerras wrote:
> Paolo,
> 
> If you are intending to send a second pull request for Linus for this
> merge window, and you are OK with taking a new feature in PPC KVM code
> at this stage, then please do a pull from my kvm-ppc-uvmem-5.5 tag.
> This adds code to manage the movement of pages for a secure KVM guest
> between normal memory managed by the host kernel and secure memory
> managed by the ultravisor on Power systems with Protected Execution
> Facility hardware and firmware.  Secure memory is not accessible to
> the host kernel and is represented as device memory using the
> ZONE_DEVICE facility.
> 
> The patch set has been around for a while and has been reasonably well
> reviewed -- this branch contains v11 of the patch set.  The code
> changes are confined to PPC KVM code with the exception of a one-line
> change to mm/ksm.c to export the ksm_madvise function, the addition of
> a new ioctl number in include/uapi/linux/kvm.h, and the addition of a
> Kconfig option in arch/powerpc/Kconfig (which Michael Ellerman is OK
> with).

Please hold off on this.  Hugh Dickins sent some review comments
identifying a problem (ksm_madvise needs mmap_sem held for writing,
not just reading).  I'll send an updated pull request shortly.

Paul.

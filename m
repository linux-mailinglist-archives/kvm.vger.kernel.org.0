Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B942FECF9
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 15:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728790AbhAUOfM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 09:35:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:34388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731142AbhAUOey (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jan 2021 09:34:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A4DC20897;
        Thu, 21 Jan 2021 14:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611239653;
        bh=NyY0K19yajfT2sm4tgx32YpC0YhTOnSipCQjqUUx/SQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tWK3YIdPaGjYQXijMn2pJI6NwvkA4grsI8hNN5y0csmGC7UXUzPo0i/mJLolu3Uy1
         VHl2RuhD/SoDnLkgCG14voHHuylK5jDzcUGOe18P2I55ZpDr8bQDDij7RlvMVJkP+N
         xzBDK6ixGzZnRic3IKn7r8zU9TdgKZBenIg8s88yy6dJZmQ4TObGfh75EGFqPGxxvp
         phWVm9kCqFS/pxdzauR9hRIFtj2YPlmvY3tqQrfEAI42tKUoXC2NUZvqoYj7yLzxiv
         MfjsQ9sTjgkYmJmi/8++HyQl96k14TXuxusj61nU/zrUTVze+8q0woOXYKPI9DvUIz
         BCk4Gz0frsglA==
Date:   Thu, 21 Jan 2021 16:34:11 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de, jmattson@google.com,
        joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        corbet@lwn.net
Subject: Re: [RFC PATCH v2 00/26] KVM SGX virtualization support
Message-ID: <YAmQ43o5nNWvuZ8i@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
 <YAaW5FIkRrLGncT5@kernel.org>
 <0adf45fae5207ed3d788bbb7260425f8da7aff43.camel@intel.com>
 <YAjALTpv/aDzOalD@kernel.org>
 <20210121125248.ca25483b4fcc732492149b49@intel.com>
 <YAjV47B0+HLAgMVc@kernel.org>
 <20210121142713.7738ed255764766a1e5b9c1a@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121142713.7738ed255764766a1e5b9c1a@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 21, 2021 at 02:27:13PM +1300, Kai Huang wrote:
> On Thu, 21 Jan 2021 03:16:19 +0200 Jarkko Sakkinen wrote:
> > On Thu, Jan 21, 2021 at 12:52:48PM +1300, Kai Huang wrote:
> > > On Thu, 21 Jan 2021 01:43:41 +0200 Jarkko Sakkinen wrote:
> > > > On Wed, Jan 20, 2021 at 01:52:32PM +1300, Kai Huang wrote:
> > > > > On Tue, 2021-01-19 at 10:23 +0200, Jarkko Sakkinen wrote:
> > > > > > Can you send a new version that applies:
> > > > > > 
> > > > > > $ git pw series apply 416463
> > > > > > Applying: x86/cpufeatures: Add SGX1 and SGX2 sub-features
> > > > > > Applying: x86/sgx: Remove a warn from sgx_free_epc_page()
> > > > > > Applying: x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()
> > > > > > Applying: x86/sgx: Add SGX_CHILD_PRESENT hardware error code
> > > > > > Applying: x86/sgx: Introduce virtual EPC for use by KVM guests
> > > > > > Applying: x86/cpu/intel: Allow SGX virtualization without Launch Control support
> > > > > > Applying: x86/sgx: Initialize virtual EPC driver even when SGX driver is disabled
> > > > > > error: sha1 information is lacking or useless (arch/x86/kernel/cpu/sgx/main.c).
> > > > > > error: could not build fake ancestor
> > > > > > hint: Use 'git am --show-current-patch=diff' to see the failed patch
> > > > > > Patch failed at 0007 x86/sgx: Initialize virtual EPC driver even when SGX driver is disabled
> > > > > > When you have resolved this problem, run "git am --continue".
> > > > > > If you prefer to skip this patch, run "git am --skip" instead.
> > > > > > To restore the original branch and stop patching, run "git am --abort".
> > > > > 
> > > > > Could you let me know which branch should I rebase to? It appears your linux-sgx tree
> > > > > next branch?
> > > > 
> > > > I tried my tree first, which was actually out-of-sync, so I rebase it.
> > > > You can find it from MAINTAINERS failed.
> > > > 
> > > > After sending this email I rebased it to tip/x86/sgx, which also failed.
> > > > That tree failed with a merge conflict.
> > > 
> > > This series is based on v5.11-rc3, as mentioned in cover letter below:
> > 
> > Please use tip/x86/sgx as base instead.
> 
> When I wrote this series, the tip/x86/sgx was still v5.10-rc4. I felt I should
> rebase to some newer code, so I chose upstream v5.11-rc3.
> 
> I just checked the latest tip/x86/sgx, and it has updated to v5.11-rc3, so
> yes I will rebase to it for next version.

I think we did a good review round anyway, and I've used this
time to learn to use Graphene, i.e. no time wasted :-)

/Jarkko

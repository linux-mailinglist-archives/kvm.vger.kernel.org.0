Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D16D02FDEDD
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 02:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730766AbhAUB1p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 20:27:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:46336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391871AbhAUBRH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 20:17:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C9EB23719;
        Thu, 21 Jan 2021 01:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611191787;
        bh=2Kbewoyh4ImwQuoSHBl1JOQu9faKEnUdJd5CqyeJjSg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cwcrmhJfnv/OpbOVs+k5GkHFetF2hejHWWPj+MjvjK5F+s2ZDh5zepP6iPrZiD0QS
         yUfAt90a8tUvwK2S+P6ETpD6SgmL71zJsiluA1GI76mNb7ZZRe9VLF3KkGPsDcDygl
         pCiuXUqyTIceUeYZDSqtIvUFwP9P2vYtPdHgPmGWTJu9g90Be2hwJxYRWJOg5zoH2y
         ovxbOPxyP2IGxivjBFer7q1iYWeHMHPtfM7V8dR/mCKpA/LUrGHqv0zXTCmJrtwxYN
         5fkgWaCz8dRLOpxIMscDeiGMNlzxpj2gq+XHsdwpPaH/4MyqemJ30x7TT9GI+5P4Xk
         ptkdXZmxUZMfw==
Date:   Thu, 21 Jan 2021 03:16:19 +0200
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
Message-ID: <YAjV47B0+HLAgMVc@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
 <YAaW5FIkRrLGncT5@kernel.org>
 <0adf45fae5207ed3d788bbb7260425f8da7aff43.camel@intel.com>
 <YAjALTpv/aDzOalD@kernel.org>
 <20210121125248.ca25483b4fcc732492149b49@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121125248.ca25483b4fcc732492149b49@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 21, 2021 at 12:52:48PM +1300, Kai Huang wrote:
> On Thu, 21 Jan 2021 01:43:41 +0200 Jarkko Sakkinen wrote:
> > On Wed, Jan 20, 2021 at 01:52:32PM +1300, Kai Huang wrote:
> > > On Tue, 2021-01-19 at 10:23 +0200, Jarkko Sakkinen wrote:
> > > > Can you send a new version that applies:
> > > > 
> > > > $ git pw series apply 416463
> > > > Applying: x86/cpufeatures: Add SGX1 and SGX2 sub-features
> > > > Applying: x86/sgx: Remove a warn from sgx_free_epc_page()
> > > > Applying: x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()
> > > > Applying: x86/sgx: Add SGX_CHILD_PRESENT hardware error code
> > > > Applying: x86/sgx: Introduce virtual EPC for use by KVM guests
> > > > Applying: x86/cpu/intel: Allow SGX virtualization without Launch Control support
> > > > Applying: x86/sgx: Initialize virtual EPC driver even when SGX driver is disabled
> > > > error: sha1 information is lacking or useless (arch/x86/kernel/cpu/sgx/main.c).
> > > > error: could not build fake ancestor
> > > > hint: Use 'git am --show-current-patch=diff' to see the failed patch
> > > > Patch failed at 0007 x86/sgx: Initialize virtual EPC driver even when SGX driver is disabled
> > > > When you have resolved this problem, run "git am --continue".
> > > > If you prefer to skip this patch, run "git am --skip" instead.
> > > > To restore the original branch and stop patching, run "git am --abort".
> > > 
> > > Could you let me know which branch should I rebase to? It appears your linux-sgx tree
> > > next branch?
> > 
> > I tried my tree first, which was actually out-of-sync, so I rebase it.
> > You can find it from MAINTAINERS failed.
> > 
> > After sending this email I rebased it to tip/x86/sgx, which also failed.
> > That tree failed with a merge conflict.
> 
> This series is based on v5.11-rc3, as mentioned in cover letter below:

Please use tip/x86/sgx as base instead.

/Jarkko
> 

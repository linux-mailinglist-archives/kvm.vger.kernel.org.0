Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5062FDE96
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 02:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392280AbhAUBOa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 20:14:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:45534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390812AbhAUBMw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 20:12:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E7B723719;
        Thu, 21 Jan 2021 01:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611191531;
        bh=MIiAmjBqR6PKxf2ETFGVQ73fKN329vQBK0jgpoGOGnw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fQiyBITudZ8xE9lPM5zVyS7nu5PCPn5r8nE5Z9tYcuE0k1nYnVkDQrngptB4HAOhw
         BbV7F0IhmZjT2azMCjVEh6mi3aJ3fFORvMdcqKAjK/tWa1P8ls8iWtkUz4VtKmIQBg
         fRVg+dF5XEh4+DKvCGqm3AUcwmrpN7y8IweJEH5ak7O3woGBgYH9rpoM97ylMU7hDp
         6uNNi+He8TftW7FQmOhe6ACzqQ3sEzhqdIKP7w7nKuArz13OAXHznsltV5sDHcXvTo
         RDRJ8iDoSQnlHPkwPymEtMV8FD27waciyh+S0PIwBCLEXdHoqz3giw6oNx2b6QhMrT
         fM8RdbRik9BSw==
Date:   Thu, 21 Jan 2021 03:12:05 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de
Subject: Re: [RFC PATCH v2 06/26] x86/cpu/intel: Allow SGX virtualization
 without Launch Control support
Message-ID: <YAjU5U/RSAle7tTi@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
 <a6c0b0d2632a6c603e68d9bdc81f564290ff04ad.1610935432.git.kai.huang@intel.com>
 <bc73adaf-fae6-2088-c8d4-6f53057a4eac@intel.com>
 <YAiwhdcOknqTJihk@google.com>
 <666e0995-cf08-1ed9-20b2-f64d1ce64c20@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <666e0995-cf08-1ed9-20b2-f64d1ce64c20@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 20, 2021 at 03:27:27PM -0800, Dave Hansen wrote:
> On 1/20/21 2:36 PM, Sean Christopherson wrote:
> > On Wed, Jan 20, 2021, Dave Hansen wrote:
> >> BTW, CONFIG_X86_SGX_VIRTUALIZATION is a pretty porky name.  Maybe just
> >> CONFIG_X86_SGX_VIRT?
> > Mmm, bacon.  I used the full "virtualization" to avoid any possible confusion
> > with virtual memory.  The existing sgx_get_epc_virt_addr() in particular gave me
> > pause.
> > 
> > I agree it's long and not consistent since other code in this series uses "virt".
> > My thinking was that most shortand versions, e.g. virt_epc, would be used only
> > in contexts that are already fairly obvious to be KVM/virtualization related,
> > whereas the porcine Kconfig would help establish that context.
> 
> Not a big deal either way.  I agree that "virt" can be confusing.
> 
> Considering that:
> 
> +config X86_SGX_VIRTUALIZATION
> +	depends on ... KVM_INTEL
> 
> Calling it X86_SGX_KVM doesn't seem horrible either.

This is something that I could cope just as well as with my proposal
as this is KVM tied feature.

/Jarkko

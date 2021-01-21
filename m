Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492E62FED01
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 15:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbhAUOgr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 09:36:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:34696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731557AbhAUOgX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jan 2021 09:36:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DFF120897;
        Thu, 21 Jan 2021 14:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611239743;
        bh=XF32tjRsQjutz9Spy5sO1et4bcjj6Nxb9dZk7OAsvaM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RWlfhp7arbktVT1p0bAIRgmHwRZ3KppL8yzRVz7P8ezOZgBLEt1VyxoQosiXvfGmp
         ym4YjfBgoJXsQ4zMM1WHS4NQ8X29p7SpTBmhbRVFlLbX+gmUrnLeWukgiB7LgE/1SP
         rWcQLBGqotYTulLKmAUkuuqucm5vzJVaAHBOZQ8zhnhV7DAue4HSJBZgmyTuXPQnNf
         o97Y6rQaCvCcsVrntjC7p0H2DjalCaP4R0TA1dJpt7U879YeayyhE63X2RRNVQj6VW
         cvjVRJd8OGT6+5z61/EmZp175Xt31JG3bx1UO+ksEFm3ZqM8EbMe4xdGI6cYRbidgL
         Mir9HucqrgTcA==
Date:   Thu, 21 Jan 2021 16:35:40 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de
Subject: Re: [RFC PATCH v2 06/26] x86/cpu/intel: Allow SGX virtualization
 without Launch Control support
Message-ID: <YAmRPEQS8ssQ6X8A@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
 <a6c0b0d2632a6c603e68d9bdc81f564290ff04ad.1610935432.git.kai.huang@intel.com>
 <bc73adaf-fae6-2088-c8d4-6f53057a4eac@intel.com>
 <YAiwhdcOknqTJihk@google.com>
 <666e0995-cf08-1ed9-20b2-f64d1ce64c20@intel.com>
 <20210121124830.3cb323c5ead91800645c912a@intel.com>
 <626d0157-c0a0-60fd-813f-af3207ad91df@intel.com>
 <20210121145323.0caad8f1d1970214bba905b1@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121145323.0caad8f1d1970214bba905b1@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 21, 2021 at 02:53:23PM +1300, Kai Huang wrote:
> On Wed, 20 Jan 2021 15:51:44 -0800 Dave Hansen wrote:
> > On 1/20/21 3:48 PM, Kai Huang wrote:
> > >> Not a big deal either way.  I agree that "virt" can be confusing.
> > >>
> > >> Considering that:
> > >>
> > >> +config X86_SGX_VIRTUALIZATION
> > >> +	depends on ... KVM_INTEL
> > > It is already in patch 3: Introduce virtual EPC for use by KVM guests:
> > > 
> > > +config X86_SGX_VIRTUALIZATION
> > > +	bool "Software Guard eXtensions (SGX) Virtualization"
> > > +	depends on X86_SGX && KVM_INTEL
> > 
> > Right, I'm suggesting that patch 3 should call it:
> > 
> > 	X86_SGX_KVM
> > 
> > instead of:
> > 
> > 	X86_SGX_VIRTUALIZATION
> 
> In case we want to change to X86_SGX_KVM, is it more reasonable to put it to
> arch/x86/kvm/Kconfig (maybe change to X86_KVM_SGX)?
> 
> Jarkko also mentioned X86_SGX_VEPC, in which case still putting it to
> arch/x86/Kconfig looks a better fit.

I disagree with myself on that now :-) I think the other
suggestions are better. I'm only pursuing 'vepc' for the
device name because it follows the pattern used in the
other devices.

> 
> Sean, Paolo,
> 
> Do you have comment here?


/Jarkko

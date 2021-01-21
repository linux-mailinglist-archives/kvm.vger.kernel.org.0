Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEE22FDEFC
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 02:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392578AbhAUBnb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 20:43:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:43144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730924AbhAUA5G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 19:57:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5837423787;
        Thu, 21 Jan 2021 00:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611190546;
        bh=KV28Ht8nRXvJJvq6ndE++WTzU0oDXHtG6Yq4FbS++H8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fqBhtTOyF/zqUlqAeuXmsLrmlt7XJHD2JEWtq56LucpH8Cp3LQ5AoOqCQuXIvChbl
         GGDivWUsacHCVsuo9xrNvQKGzPQCRDpHm0XO7zvcu58EHOQTbHySfnx4YZqDUK8A10
         5FLaQck0nqGApoXYtTmZKUryPDmvEmzBrD8VrStmifhCYK4CpvpXKtmlHaD1x1ga81
         MowHr0NOEZvcR13PWKrYRf3aiKTXk/wEqH655muZ/CxdGwAMCzKAYepKyvNdbsb1jQ
         1gUdDLIjtTO2YUQ2JfsvFK5/TJBTWbx/n0jugtGvrXi7M3oTYVMv3Xo8XNMzj2YCxW
         ekpWbbAsrW/KA==
Date:   Thu, 21 Jan 2021 02:55:41 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v2 05/26] x86/sgx: Introduce virtual EPC for use by
 KVM guests
Message-ID: <YAjRDdgOT/AC89gC@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
 <4597db567351468c360fc810fff5a8232cb96c4c.1610935432.git.kai.huang@intel.com>
 <YAgZ8lGaafoTXcYF@kernel.org>
 <YAhrJNvg9KfEr/b7@google.com>
 <YAjQuCxYH9V7JsN2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAjQuCxYH9V7JsN2@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 21, 2021 at 02:54:23AM +0200, Jarkko Sakkinen wrote:
> On Wed, Jan 20, 2021 at 09:40:52AM -0800, Sean Christopherson wrote:
> > On Wed, Jan 20, 2021, Jarkko Sakkinen wrote:
> > > On Mon, Jan 18, 2021 at 04:26:53PM +1300, Kai Huang wrote:
> > > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > 
> > > > Add a misc device /dev/sgx_virt_epc to allow userspace to allocate "raw"
> > > > EPC without an associated enclave.  The intended and only known use case
> > > > for raw EPC allocation is to expose EPC to a KVM guest, hence the
> > > > virt_epc moniker, virt.{c,h} files and X86_SGX_VIRTUALIZATION Kconfig.
> > > 
> > > Is /dev/sgx_virt_epc something only usable for KVM, or is there
> > > any thinkable use outside of the KVM context?
> > 
> > I can't think of a sane use case without KVM (or an out-of-tree hypervisor).
> > Doing anything useful with EPC requires ENCLS, which means being able to run
> > CPL0 code.
> 
> OK, thanks for elaboration.
> 
> To bring more context to my thinking to call this to sgx_vepc is that it's
> kind of "standard" in other device names I've such as:
> 
> - vhost_net
> - vhci
> - vtpm
> - vcs*
> - The list goes on..
> 
> Since "virtual something" is always abbreviated just with a 'v', wouldn't it
> make sense to just follow along?

And even kVm :-)

/Jarkko

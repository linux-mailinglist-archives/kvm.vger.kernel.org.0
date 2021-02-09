Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8743159FD
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 00:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234732AbhBIXXM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 18:23:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:32884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233749AbhBIWl6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 17:41:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6B3664E85;
        Tue,  9 Feb 2021 21:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612905603;
        bh=EqtcTDWQuWQ17YBpCKfbqrpwrSVDDZRYyET0mFRkOI4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JLMm4CdzEZ6cgjPlJrlIpT5HdxQ011fsVg0uYewq+/wguYgMIwCrYPm85NZE4pS+i
         r49YCdAXiCBhFdBcGx7VPAAbsUZMEyRJ/RSHaAiMmgwfBEnHAO0BkRbQod6bn3pzfu
         hOnhhl8Of3bxStPekz3xgT1ISGlHVG6HvVYPzxO4dvIzIXJAJTJD2j3QbJMTm8pKPD
         wLACY2lAPDbkGyGYODsgDf87zsK7OWxK2IH5HEvtrj2w1sohfjdiIHDLm5MbPnEAKb
         mCW/08cGO0vJpbSR4b8+sGl2KSZWIAkpjUU6uMDALN9I72+Dv7m+GyiMmlwvb0RSNX
         sXQh2uejJi4ww==
Date:   Tue, 9 Feb 2021 23:19:52 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com,
        pbonzini@redhat.com, bp@alien8.de, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v4 05/26] x86/sgx: Introduce virtual EPC for use by
 KVM guests
Message-ID: <YCL8eNNfuo2k5ghO@kernel.org>
References: <cover.1612777752.git.kai.huang@intel.com>
 <11a923a314accf36a82aac4b676310a4802f5c75.1612777752.git.kai.huang@intel.com>
 <YCL8ErAGKNSnX2Up@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCL8ErAGKNSnX2Up@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 09, 2021 at 11:18:13PM +0200, Jarkko Sakkinen wrote:
> On Mon, Feb 08, 2021 at 11:54:09PM +1300, Kai Huang wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Add a misc device /dev/sgx_vepc to allow userspace to allocate "raw" EPC
> > without an associated enclave.  The intended and only known use case for
> > raw EPC allocation is to expose EPC to a KVM guest, hence the 'vepc'
> > moniker, virt.{c,h} files and X86_SGX_KVM Kconfig.
> 
> This commit message does give existential background for having vEPC.
> I.e. everything below this paragraph is "good enough" to make the case
> for SGX subsystem controlled vEPC.
> 
> However, it does not give any existential background for /dev/sgx_vpec.
> Even with differing internals you could just as well make the whole
> thing as subfunction of /dev/sgx_enclave. It's perfectly doable. It
> does not really matter how much the same internals are used (e.g.
> sgx_encl).
> 
> Without that clearly documented, it would be unwise to merge this.

E.g.

- Have ioctl() to turn opened fd as vEPC.
- If FLC is disabled, you could only use the fd for creating vEPC.

Quite easy stuff to implement.

/Jarkko

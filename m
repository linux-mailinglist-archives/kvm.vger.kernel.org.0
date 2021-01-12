Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0442F25A8
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 02:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732709AbhALBrc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 20:47:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:55438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727708AbhALBrc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 20:47:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F18A222D6D;
        Tue, 12 Jan 2021 01:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610416011;
        bh=15ETxPhtEEdrgHZBczeVTXmx91pDiN0yVsB5AtTtxuw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L8RodCKWXbKEwTogPMakTf9UQbhK4eLm7JMoD3kXpTJYbu/Q3kfg3phXTbJf65JfT
         xdaNwYlxwp0+FRX4jZGu/bPwVCZqGO1dpQcTTfVE93PnQD07ipRUK5cAGV6dF8AW6k
         rKAZ/8K2AzZgt4iIQpCZpMpL9mfr5ZRzl//GaO40PYvzWrfXnov5Rxn+x8a4HHKfVo
         gRoWMPWVOFflFHGIB6qxZnV/ttHpc+/78MkNSPQaVrPHQmHUr1nkQuEDhBYAOlWNp5
         eYmDhL3isxzrHdyXJ9sjnjN7zHDaY8+sj6TyYpO16yFF34dFjpCt79KrUW3v7vA8hR
         JtUAX9nV6o4yw==
Date:   Tue, 12 Jan 2021 03:46:45 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 02/23] x86/sgx: Add enum for SGX_CHILD_PRESENT error
 code
Message-ID: <X/z/hXPAKfFfUZO6@kernel.org>
References: <cover.1609890536.git.kai.huang@intel.com>
 <2a41e15dfda722dd1e34feeda34ce864cd82361b.1609890536.git.kai.huang@intel.com>
 <X/zgA1F+o4jXYDM/@kernel.org>
 <20210112131653.d8150b795dc64e0add0e809f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112131653.d8150b795dc64e0add0e809f@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021 at 01:16:53PM +1300, Kai Huang wrote:
> On Tue, 12 Jan 2021 01:32:19 +0200 Jarkko Sakkinen wrote:
> > On Wed, Jan 06, 2021 at 02:55:19PM +1300, Kai Huang wrote:
> > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > 
> > > SGX virtualization requires to allocate "raw" EPC and use it as "virtual
> > > EPC" for SGX guest.  Unlike EPC used by SGX driver, virtual EPC doesn't
> > > track how EPC pages are used in VM, e.g. (de)construction of enclaves,
> > > so it cannot guarantee EREMOVE success, e.g. it doesn't have a priori
> > > knowledge of which pages are SECS with non-zero child counts.
> > > 
> > > Add SGX_CHILD_PRESENT for use by SGX virtualization to assert EREMOVE
> > > failures are expected, but only due to SGX_CHILD_PRESENT.
> > > 
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > 
> > Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> Thanks Jarkko. 
> 
> Dave suggested to change patch subject to explicitly call out hardware error
> code:
> 	Add SGX_CHILD_PRESENT hardware error code
> 
> I suppose this also works for you, and I can have your Acked-by after I changed
> that in v2?

Yeah, I agree with that.

/Jarkko

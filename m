Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D4B2FDEFF
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 02:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbhAUBqL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 20:46:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:42460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732107AbhAUAzx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 19:55:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DD7E23602;
        Thu, 21 Jan 2021 00:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611190462;
        bh=BWNHxEUGRr6oGRrnxjIDJYAZvB4Oa/aDpfmBM3CeeR0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=reGQ/sYvbemOkQ+JFVbVSa6ZNXtxB6a9mY1dsol6grcpH72fW+7+goKDmE84Cmr5s
         gN8bDTSb2CMWtJFQwb6rmbCd1gllE7Jz06p9/2ZYl6VtRFa+2UrnK3dm3sy3Ko9nxp
         VWcQUEWsLujuiEcq3CCg/Jg4fPO3UW04cZGajfIW/Luwpr9694tfFBEMOck3GuGOQ5
         0JPirO8N7TyuioTQe5G+H8Xuk9xgINyDFK4z86eF21bWOGVidQuVnccFZwmwW6McAO
         sCxv4EKGTeBtZRJGoAR/8+mGks4+t0sxYhWMYjJfEAP3BdcSog4Ssbz5qWS6RX36SN
         /tkIzNUeDEnUg==
Date:   Thu, 21 Jan 2021 02:54:16 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v2 05/26] x86/sgx: Introduce virtual EPC for use by
 KVM guests
Message-ID: <YAjQuCxYH9V7JsN2@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
 <4597db567351468c360fc810fff5a8232cb96c4c.1610935432.git.kai.huang@intel.com>
 <YAgZ8lGaafoTXcYF@kernel.org>
 <YAhrJNvg9KfEr/b7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAhrJNvg9KfEr/b7@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 20, 2021 at 09:40:52AM -0800, Sean Christopherson wrote:
> On Wed, Jan 20, 2021, Jarkko Sakkinen wrote:
> > On Mon, Jan 18, 2021 at 04:26:53PM +1300, Kai Huang wrote:
> > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > 
> > > Add a misc device /dev/sgx_virt_epc to allow userspace to allocate "raw"
> > > EPC without an associated enclave.  The intended and only known use case
> > > for raw EPC allocation is to expose EPC to a KVM guest, hence the
> > > virt_epc moniker, virt.{c,h} files and X86_SGX_VIRTUALIZATION Kconfig.
> > 
> > Is /dev/sgx_virt_epc something only usable for KVM, or is there
> > any thinkable use outside of the KVM context?
> 
> I can't think of a sane use case without KVM (or an out-of-tree hypervisor).
> Doing anything useful with EPC requires ENCLS, which means being able to run
> CPL0 code.

OK, thanks for elaboration.

To bring more context to my thinking to call this to sgx_vepc is that it's
kind of "standard" in other device names I've such as:

- vhost_net
- vhci
- vtpm
- vcs*
- The list goes on..

Since "virtual something" is always abbreviated just with a 'v', wouldn't it
make sense to just follow along?

/Jarkko

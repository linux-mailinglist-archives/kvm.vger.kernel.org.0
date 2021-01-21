Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F7E2FDE92
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 02:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388300AbhAUBLW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 20:11:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:45056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391751AbhAUBJk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 20:09:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB03823888;
        Thu, 21 Jan 2021 01:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611191340;
        bh=/1loaPDEo0tGEnR5Gy4AsGNXHaymeTj36LsNU8s0pnY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hnaTrL9KcAznqnEJ7Wnl66eXfYx5zSKkvM5+54bJm95zY7YKbNiYXHsQpb4eUI9Yj
         VG1T/PgyIdXE0O/30ylDDbYBxZ0AVL6IHBI/6AlhiQa5vWwEnCz5N/GXVbwGt/atu6
         m5kGtWNeCTWNmg/ag/16v5O01XdrLoZS2ibJKBdE5YQTECun0xUe1nwrQE4Cpn/vAf
         dO+I6jM12cVIo0diWd/XKsZxgR0KB4ik0PI844ptfHbTuCU6cLEA3RHmcnzZ+INptV
         APWsNXicZRTkoyHWbdxxaEmMAb4VgPpo/b13iq+EiCGP/g8IHrW3FzLXZuNTQRmlM+
         lVv1//cNCO3zA==
Date:   Thu, 21 Jan 2021 03:08:54 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, seanjc@google.com,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v2 12/26] x86/sgx: Add helper to update
 SGX_LEPUBKEYHASHn MSRs
Message-ID: <YAjUJiNcVV/PkGp9@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
 <5116fdc732e8e14b3378c44e3b461a43f330ed0c.1610935432.git.kai.huang@intel.com>
 <YAgcIhkmw0lllD3G@kernel.org>
 <8613b3f1-c4f6-3e5d-4406-9476727666a7@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8613b3f1-c4f6-3e5d-4406-9476727666a7@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 20, 2021 at 10:36:09AM -0800, Dave Hansen wrote:
> On 1/20/21 4:03 AM, Jarkko Sakkinen wrote:
> >> +void sgx_update_lepubkeyhash(u64 *lepubkeyhash)
> >> +{
> >> +	int i;
> >> +
> >> +	for (i = 0; i < 4; i++)
> >> +		wrmsrl(MSR_IA32_SGXLEPUBKEYHASH0 + i, lepubkeyhash[i]);
> >> +}
> > Missing kdoc.
> 
> I dunno... kdoc is nice, but I'm not sure its verbosity is useful here,
> even if this function is called from more than one .c file.
> 
> I'd be happy with a single-line comment, personally.

WFM.

/Jarkko

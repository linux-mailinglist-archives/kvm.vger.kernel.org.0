Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB512FED0D
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 15:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731610AbhAUOhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 09:37:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:34922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731532AbhAUOh3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jan 2021 09:37:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DA5D20691;
        Thu, 21 Jan 2021 14:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611239809;
        bh=E5H7nV5xGStsQcAwPIlhHlwdHFUNwOaU3Fb9cCr6DAc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bPzPq+i7QVMlT6fYRD19w9S+QUw+50r6Ylc1Z1AQ6AtU4dmoe0T8HdOHwL17QmRvC
         b7WXP9XkLEoNK+MAwYvx/tY66ra4cXl6NVu6GMGgH45WxxWeWcTzX9/lK65hrWaCk8
         Ryj4xUg1J4ZUo2fUsleFJiygAaOMyPsgwB5nvBczi2Baq+8a1aCpOoesMY2LVQ4IRT
         eaUWI7F4W2/v56ZQXAAq9cxVha8Pq7IWDmLFP6rcubigFuoxe7AONVa3qKHXjDZQWZ
         swh1D6GPk0Mix8gt+RCsqFAQcm2qng80S5HxY+B6R1aQvH+QvNSHkftFKN0Lk3Vc+P
         fAMJMOBaM58tQ==
Date:   Thu, 21 Jan 2021 16:36:46 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, seanjc@google.com,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v2 12/26] x86/sgx: Add helper to update
 SGX_LEPUBKEYHASHn MSRs
Message-ID: <YAmRfir1epEk9CbN@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
 <5116fdc732e8e14b3378c44e3b461a43f330ed0c.1610935432.git.kai.huang@intel.com>
 <YAgcIhkmw0lllD3G@kernel.org>
 <8613b3f1-c4f6-3e5d-4406-9476727666a7@intel.com>
 <20210121123625.c45deeccc690138f2417bd41@intel.com>
 <982ddc27-27ec-2d03-54a4-1c0b07e8a3c9@intel.com>
 <20210121140638.b9bac5af44fc0f33996a2853@intel.com>
 <db1c3826-8299-d83e-95f5-e25ee593b646@intel.com>
 <20210121144426.361258fb52a4934c0ab92f8c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121144426.361258fb52a4934c0ab92f8c@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 21, 2021 at 02:44:26PM +1300, Kai Huang wrote:
> On Wed, 20 Jan 2021 17:15:35 -0800 Dave Hansen wrote:
> > On 1/20/21 5:06 PM, Kai Huang wrote:
> > > 
> > > /*
> > >  * Update the SGX_LEPUBKEYHASH MSRs to the values specified by caller.
> > >  *
> > >  * EINITTOKEN is not used in enclave initialization, which requires
> > >  * hash of enclave's signer must match values in SGX_LEPUBKEYHASH MSRs
> > >  * to make EINIT be successful.
> > >  */
> > 
> > I'm grumpy, but I hate it.
> > 
> > I'll stop the bike shedding for now, though.
> 
> Jarkko and Dave,
> 
> I'll change to use below:
> 
>  /*
>   * Update the SGX_LEPUBKEYHASH MSRs to the values specified by caller.
>   * Bare-metal driver requires to update them to hash of enclave's signer
>   * before EINIT. KVM needs to update them to guest's virtual MSR values
>   * before doing EINIT from guest.
>   */
>
> Please let me know if are not OK with this.

I am.

/Jarkko

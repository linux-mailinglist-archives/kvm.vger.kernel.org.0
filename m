Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6433E30D700
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 11:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbhBCKEd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 05:04:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:44256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233215AbhBCKEc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 05:04:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C842764DD4;
        Wed,  3 Feb 2021 10:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612346631;
        bh=iDRUK1dfIoKv6p3k1yQ5f2Cl0AFuONzv34q2WQe7GM0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F0m4Sltz3uZxB1AklHhBuerzDt/tEJafYqB0uS0KywOB1mvXTeW9KjjmYoF53zGw7
         vEZK8b0aseAfyl/bgDADaBF4N3ApbdRLeWnVBuihAqOL23L9kjH3id/n1Ar+/vV7Vl
         8Z+40H+IfOZ7JaG8/wBoYgblQQav8n2ZwQ58L6zPkio2mt4AzS43UQD3dySKIRMjR6
         VJ/goWdqchVa99j8T9IZC7dJyGpjd8GIS/HOH/Ha8eqm86S9a3nu+frBoQ/7NBxpeg
         eLfVdzE8qJEf4s3gQJlrGYZqBnqh6QguRCQin4stnwiGAt6ZqfJxjbOemtKO4dLwJf
         6GyNsAdvvTXxQ==
Date:   Wed, 3 Feb 2021 12:03:44 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, seanjc@google.com,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 03/27] x86/sgx: Remove a warn from
 sgx_free_epc_page()
Message-ID: <YBp1APi0LBhrbgQx@kernel.org>
References: <cover.1611634586.git.kai.huang@intel.com>
 <36e999dce8a1a4efb8ca69c9a6fbe3fa63305e08.1611634586.git.kai.huang@intel.com>
 <d09b8b34-6e8c-5323-e155-f45da5abb48b@intel.com>
 <6e859dc6610d317f09663a4ce76b7e13fc0c0f8e.camel@intel.com>
 <15dda40e-5875-aaa9-acbb-7d868a13f982@intel.com>
 <20210127142652.b9d181813b10f8660d0df664@intel.com>
 <20210201131110.d1425c4d0db46fb895bde10f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201131110.d1425c4d0db46fb895bde10f@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 01, 2021 at 01:11:10PM +1300, Kai Huang wrote:
> On Wed, 27 Jan 2021 14:26:52 +1300 Kai Huang wrote:
> > On Tue, 26 Jan 2021 17:12:12 -0800 Dave Hansen wrote:
> > > On 1/26/21 5:08 PM, Kai Huang wrote:
> > > > I don't have deep understanding of SGX driver. Would you help to answer?
> > > 
> > > Kai, as the patch submitter, you are expected to be able to at least
> > > minimally explain what the patch is doing.  Please endeavor to obtain
> > > this understanding before sending patches in the future.
> > 
> > I see. Thanks.
> 
> Hi Jarkko,
> 
> I think I'll remove this patch in next version, since it is not related to KVM
> SGX. And I'll rebase your second patch based on current tip/x86/sgx. You may
> send out this patch independently. Let me know if you have comment.

I don't like to pre-ack changes.

My main concern is not to introduce multiple disjoint versions
of sgx_free_epc_page(). It is just not sane because you can do
an implementation where those don't exist.

/Jarkko

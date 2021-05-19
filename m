Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF5B3899E0
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 01:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhESXbX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 19:31:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhESXbW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 19:31:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44CC6611AB;
        Wed, 19 May 2021 23:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621467002;
        bh=8xvSSE3H35qcDXVWBq8krJ/CkeS4P86f6MpxZY+FQsI=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=pdeWnBCOnInNDm8x6YAc+z9QI+Wu0uGxbXPy3JyYre/HD1tUr1yp6Kj89MZ/+rP4j
         yP5bCoD92a0n36gX2BAgc3g5ShKUr18Xw+WgAzNI8SNW/Sk5rU/KyTIrmiiul6h1Wg
         eT0zgg4taZ/bludKSSGnXyBVkQKxorWMOnB8PG4P7W2+I07XYaArz+llvLdH4G+O+N
         tzQE4mXkQcKNXTuv5CU/EnJ5oulujaPddY2b+jkmjSUcR6D3RjGV/vScxk/7tTfePz
         k34YWGiA5fjDL/STm/OGEjTDauJfOd+tL9eNhUJyrdSknsk/RRxsjrst6a35PUaLNs
         FdW6geIgOvIKg==
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailauth.nyi.internal (Postfix) with ESMTP id 550F327C0054;
        Wed, 19 May 2021 19:30:00 -0400 (EDT)
Received: from imap21 ([10.202.2.71])
  by compute2.internal (MEProxy); Wed, 19 May 2021 19:30:00 -0400
X-ME-Sender: <xms:d5-lYHGmPWDSX8OSBqh8yqRFL6-TU4DGvAAYQa_ollvI-_ZFCfiU8A>
    <xme:d5-lYEWA6xPYUhC6Dp-0AaIYZd1uBpZsvgq6yetXcps0f_I2zd7eQCGNfT61HZfO0
    kAZe7T5DnMvIhY_1Hk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejtddgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreerjeenucfhrhhomhepfdetnhgu
    hicunfhuthhomhhirhhskhhifdcuoehluhhtoheskhgvrhhnvghlrdhorhhgqeenucggtf
    frrghtthgvrhhnpeegjefghfdtledvfeegfeelvedtgfevkeeugfekffdvveeffeetieeh
    ueetveekfeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegrnhguhidomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudduiedukeeh
    ieefvddqvdeifeduieeitdekqdhluhhtoheppehkvghrnhgvlhdrohhrgheslhhinhhugi
    drlhhuthhordhush
X-ME-Proxy: <xmx:d5-lYJLzfx3n_y0I3zlLOGlU6QQemwxaAQP1RPrT6w3cifmzFy3kXw>
    <xmx:d5-lYFFNy--_xYr0kWZptyE06O5JxcTVrqCwu81bzB8JH91a3XzhPA>
    <xmx:d5-lYNV19oH3DOUeibnsJQfgKXqcPYhjwLeW8Zt2oSxUuuDukuwBvA>
    <xmx:eJ-lYGvA-tXWjlTjhLx2635WhOntheP6f4M6vGlDhqQ6qROmgFpx5OUCrR3ovjulKRgSqQ>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 155B051C0060; Wed, 19 May 2021 19:29:58 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-448-gae190416c7-fm-20210505.004-gae190416
Mime-Version: 1.0
Message-Id: <86701a5e-87b5-4e73-9b7a-557d8c855f89@www.fastmail.com>
In-Reply-To: <YJvU+RAvetAPT2XY@zn.tnic>
References: <cover.1619193043.git.ashish.kalra@amd.com>
 <ff68a73e0cdaf89e56add5c8b6e110df881fede1.1619193043.git.ashish.kalra@amd.com>
 <YJvU+RAvetAPT2XY@zn.tnic>
Date:   Wed, 19 May 2021 16:29:37 -0700
From:   "Andy Lutomirski" <luto@kernel.org>
To:     "Borislav Petkov" <bp@alien8.de>,
        "Ashish Kalra" <Ashish.Kalra@amd.com>,
        "Sean Christopherson" <seanjc@google.com>
Cc:     "Paolo Bonzini" <pbonzini@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Joerg Roedel" <joro@8bytes.org>, thomas.lendacky@amd.com,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "kvm list" <kvm@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        srutherford@google.com, venu.busireddy@oracle.com,
        brijesh.singh@amd.com
Subject: =?UTF-8?Q?Re:_[PATCH_v2_2/4]_mm:_x86:_Invoke_hypercall_when_page_encrypt?=
 =?UTF-8?Q?ion_status_is_changed?=
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 12, 2021, at 6:15 AM, Borislav Petkov wrote:
> On Fri, Apr 23, 2021 at 03:58:43PM +0000, Ashish Kalra wrote:
> > +static inline void notify_page_enc_status_changed(unsigned long pfn,
> > +						  int npages, bool enc)
> > +{
> > +	PVOP_VCALL3(mmu.notify_page_enc_status_changed, pfn, npages, enc);
> > +}
> 
> Now the question is whether something like that is needed for TDX, and,
> if so, could it be shared by both.

The TDX MapGPA call can fail, and presumably it will fail if the page is not sufficiently quiescent from the host's perspective.  It seems like a mistake to me to have a KVM-specific hypercall for this that cannot cleanly fail.

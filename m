Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6D33899B4
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 01:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbhESXRF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 19:17:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229465AbhESXRE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 19:17:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B10F61073;
        Wed, 19 May 2021 23:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621466143;
        bh=beE4/t2PXKApA1HIKdMVG9OOGAVvsn53W5079fVxQ/0=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=XLozLhVPQv/6woT+UnfzEZrnec0PUe+d6LxgEbl2gcjIkECwfIQsIq2XseOagWUYg
         n54mHH7QANRtQVpvW+joEulDL3hR0UJcJ1B7KXtaCCFHlHI8pB9jRrUNebaSvE3ReV
         HDFYG9SRQM6RkdeP1hxJoyv6tNLhxgNrHCe2pcPeg89KEBEyV4fwYxnkAmB+LTuTgo
         p3BKwJTv5gA3jp4LdK2HzB5M+Ls47btJIFIPw35Xz3rsL23lgmwh383uO1Lg3w98HP
         Ls8poELkNPu5u6MXKyrLKc3AZGYbuDFAaC/YO/JUHRg3OCwfYjYCRsiulV9Bs0ibaf
         8jfFd+AjQkCRQ==
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailauth.nyi.internal (Postfix) with ESMTP id 72A8927C007C;
        Wed, 19 May 2021 19:15:40 -0400 (EDT)
Received: from imap21 ([10.202.2.71])
  by compute2.internal (MEProxy); Wed, 19 May 2021 19:15:40 -0400
X-ME-Sender: <xms:GZylYPnLzxNtu3_dJKXqLloo9yV7x8vCtLfIxwFAAN-ZFNJAarmdfw>
    <xme:GZylYC2rPWBl7cozB0Prt83-b5SpWIhD36DDRT9N0twjSjW8yFD-nsjdIwl7-Ql3R
    15-Y_lxWw_XnFxfAkQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejtddgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgfgsehtqhertderreejnecuhfhrohhmpedftehn
    ugihucfnuhhtohhmihhrshhkihdfuceolhhuthhosehkvghrnhgvlhdrohhrgheqnecugg
    ftrfgrthhtvghrnhepvdelheejjeevhfdutdeggefftdejtdffgeevteehvdfgjeeiveei
    ueefveeuvdetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homheprghnugihodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduudeiudek
    heeifedvqddvieefudeiiedtkedqlhhuthhopeepkhgvrhhnvghlrdhorhhgsehlihhnuh
    igrdhluhhtohdruhhs
X-ME-Proxy: <xmx:GZylYFqo6Cyo29Tv2pkNc1D38FyCqeJS7CMM5cAEJFWXpcdWqxfECw>
    <xmx:GZylYHn2K6qjX46ceqkbccWf9PIcI6uh7z3nUGDyKazqBWnvCxSyjA>
    <xmx:GZylYN1r-FWIAg8kqvADLhJYl-pLeo9-4iqXKbZ-2h9VeeoFkfG3Kw>
    <xmx:HJylYOcszQWe3wSdQtP4wYcfrxwLBIYWxc6HVQrFsOTyrmy2kangPvqHafCV_u0o8_noIPl7o14>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 2219051C0060; Wed, 19 May 2021 19:15:37 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-448-gae190416c7-fm-20210505.004-gae190416
Mime-Version: 1.0
Message-Id: <b2a9056a-d181-44ae-bb9f-a809f52cf691@www.fastmail.com>
In-Reply-To: <8e45611c-f6ce-763a-ad17-adada33716d6@intel.com>
References: <20210507164456.1033-1-jon@nutanix.com>
 <CALCETrW0_vwpbVVpc+85MvoGqg3qJA+FV=9tmUiZz6an7dQrGg@mail.gmail.com>
 <5e01d18b-123c-b91f-c7b4-7ec583dd1ec6@redhat.com>
 <8e45611c-f6ce-763a-ad17-adada33716d6@intel.com>
Date:   Wed, 19 May 2021 16:15:16 -0700
From:   "Andy Lutomirski" <luto@kernel.org>
To:     "Dave Hansen" <dave.hansen@intel.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Jon Kohler" <jon@nutanix.com>,
        "Sean Christopherson" <seanjc@google.com>
Cc:     "Babu Moger" <babu.moger@amd.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        "Wanpeng Li" <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>,
        "Yu-cheng Yu" <yu-cheng.yu@intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Uros Bizjak" <ubizjak@gmail.com>,
        "Petteri Aimonen" <jpa@git.mail.kapsi.fi>,
        "Kan Liang" <kan.liang@linux.intel.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Mike Rapoport" <rppt@kernel.org>,
        "Benjamin Thiel" <b.thiel@posteo.de>,
        "Fan Yang" <Fan_Yang@sjtu.edu.cn>,
        "Juergen Gross" <jgross@suse.com>,
        "Dave Jiang" <dave.jiang@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Ricardo Neri" <ricardo.neri-calderon@linux.intel.com>,
        "Arvind Sankar" <nivedita@alum.mit.edu>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "kvm list" <kvm@vger.kernel.org>
Subject: =?UTF-8?Q?Re:_[PATCH]_KVM:_x86:_add_hint_to_skip_hidden_rdpkru_under_kvm?=
 =?UTF-8?Q?=5Fload=5Fhost=5Fxsave=5Fstate?=
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19, 2021, at 3:44 PM, Dave Hansen wrote:
> On 5/17/21 12:46 AM, Paolo Bonzini wrote:
> > On 14/05/21 07:11, Andy Lutomirski wrote:
> >> That's nice, but it fails to restore XINUSE[PKRU].=C2=A0 As far as =
I know,
> >> that bit is live, and the only way to restore it to 0 is with
> >> XRSTOR(S).
> >=20
> > The manual says "It is possible for XINUSE[i] to be 1 even when stat=
e
> > component i is in its initial configuration" so this is architectura=
lly
> > valid.=C2=A0 Does the XINUSE optimization matter for PKRU which is a=
 single
> > word?
>=20
> In Linux with normal userspace, virtually never.
>=20
> The hardware defaults PKRU to 0x0 which means "no restrictions on any
> keys".  Linux defaults PKRU via 'init_pkru_value' to the most
> restrictive value.  This ensures that new non-zero-pkey-assigned memor=
y
> is protected by default.
>=20
> But, that also means PKRU is virtually never in its init state in Linu=
x.
>  An app would probably need to manipulate PKRU with XRSTOR to get
> XINUSE[PKRU]=3D0.
>=20
> It would only even *possibly* be useful if running a KVM guest that ha=
d
> PKRU=3D0x0 (sorry I don't consider things using KVM "normal userspace"=
 :P ).
>=20

There was at least one report from the rr camp of glibc behaving differe=
ntly depending on the result of XGETBV(1).  It's at least impolite to ch=
ange the XINUSE register for a guest behind its back.

Admittedly that particular report wasn't about PKRU, and *Linux* guests =
won't run with XINUSE[PKRU]=3D0 under normal circumstances, but non-Linu=
x guests could certainly do so.

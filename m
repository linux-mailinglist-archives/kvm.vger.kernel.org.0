Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5734D42C449
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhJMPBz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 11:01:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:58328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229877AbhJMPBx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 11:01:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FB6E60720;
        Wed, 13 Oct 2021 14:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634137190;
        bh=m6EK94Z0I7s3Fz7RIep+4fYpO3uptoAMo/2RBZnuMBo=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=l4oTUl1y6XisZTtiRt2PTxP4tDAizYXeBIOS+tZ3Q/jRj1VBCileReJsXcD4k84lC
         CqFB24Y/EvTiNY3GN9B8Y9l2wx1XGNvBUUn6cDiOhzB/hsIGTgoueI6mtjmEoB3ikz
         SF1FZCZ1T/WPD8Xkmc/g6hfcXPQieR/kPWIkue2RHWueWCbERpHHJCSAC7mmV6L3OV
         DVd1pC2nZcyBbVzLFp7oUEUuhY2dVClaNCPaPWN4LI0/YcF9Ihrl6Y4KICEr6+/jkv
         vTy0odJ6KBpf+jsXf7ZkelxfQo+K4TZJaAtPJnCR3bFQTVLB1OMeJZtVDXOoF3jHPp
         hdy1bWZTq7hew==
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailauth.nyi.internal (Postfix) with ESMTP id 8C6B127C0054;
        Wed, 13 Oct 2021 10:59:48 -0400 (EDT)
Received: from imap48 ([10.202.2.98])
  by compute6.internal (MEProxy); Wed, 13 Oct 2021 10:59:48 -0400
X-ME-Sender: <xms:ZPRmYf3QyUJAJlkM6X35Jf2Z_1GY3UJr6Nuy7wimuxK2T7t-N2Zw8A>
    <xme:ZPRmYeFl4ximey-QOcMSinKZlzh5AwU1jxscNDmYZAHDuHGhWAX3nqDb5fniyNCd9
    mSRlJoxZ_sXf8-wnq8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddutddgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgfgsehtqhertderreejnecuhfhrohhmpedftehn
    ugihucfnuhhtohhmihhrshhkihdfuceolhhuthhosehkvghrnhgvlhdrohhrgheqnecugg
    ftrfgrthhtvghrnhepgeeiueehlefftdehgfevveejkeffieehkeeftdduudefudejledu
    veelhedtleffnecuffhomhgrihhnpehtshdrhihouhenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrnhguhidomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqudduiedukeehieefvddqvdeifeduieeitdekqdhluhhtoheppe
    hkvghrnhgvlhdrohhrgheslhhinhhugidrlhhuthhordhush
X-ME-Proxy: <xmx:ZPRmYf7eJuckEl_RlFMKD9B8C2oVOhKjjvjXC1ZhSNUHccR1Tx-0rA>
    <xmx:ZPRmYU2S8HIxTNlVHisj_CimSII3zrDIdzGB9OY1te9R7lArZerFwA>
    <xmx:ZPRmYSE9H_Uxb-HC8KY9bqUGgQ0CYpbM1zToa2QAGNC1dRtcC1Tr8Q>
    <xmx:ZPRmYVDgMlhVVJ589Rm11ZGkNbChk8L5GylmQINTSpa82AS14MYhX-9O-zI>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id EAF6B21E006A; Wed, 13 Oct 2021 10:59:47 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-1345-g8441cd7852-fm-20211006.001-g8441cd78
Mime-Version: 1.0
Message-Id: <10a8868e-eb85-4043-a5ad-96c03d9b0abb@www.fastmail.com>
In-Reply-To: <df3af1c2-fe93-ea21-56e5-4d70d08e55f2@redhat.com>
References: <20211011215813.558681373@linutronix.de>
 <20211011223611.069324121@linutronix.de>
 <8a5762ab-18d5-56f8-78a6-c722a2f387c5@redhat.com>
 <BYAPR11MB3256B39E2A34A09FF64ECC5BA9B79@BYAPR11MB3256.namprd11.prod.outlook.com>
 <0962c143-2ff9-f157-d258-d16659818e80@redhat.com>
 <BYAPR11MB325676AAA8A0785AF992A2B9A9B79@BYAPR11MB3256.namprd11.prod.outlook.com>
 <da47ba42-b61e-d236-2c1c-9c5504e48091@redhat.com>
 <d673e736-0a72-4549-816d-b755227ea797@www.fastmail.com>
 <df3af1c2-fe93-ea21-56e5-4d70d08e55f2@redhat.com>
Date:   Wed, 13 Oct 2021 07:59:26 -0700
From:   "Andy Lutomirski" <luto@kernel.org>
To:     "Paolo Bonzini" <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        "Arjan van de Ven" <arjan@linux.intel.com>,
        "kvm list" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Jing Liu" <jing2.liu@linux.intel.com>,
        "Sean Christopherson" <seanjc@google.com>
Subject: Re: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On Wed, Oct 13, 2021, at 5:26 AM, Paolo Bonzini wrote:
> On 13/10/21 12:14, Andy Lutomirski wrote:
>>> I think it's simpler to always wait for #NM, it will only happen
>>> once per vCPU.  In other words, even if the guest clears XFD before
>>> it generates #NM, the guest_fpu's XFD remains nonzero and an #NM
>>> vmexit is possible.  After #NM the guest_fpu's XFD is zero; then
>>> passthrough can happen and the #NM vmexit trap can be disabled.
>>
>> This will stop being at all optimal when Intel inevitably adds
>> another feature that uses XFD.  In the potentially infinite window in
>> which the guest manages XFD and #NM on behalf of its userspace and
>> when the guest allocates the other hypothetical feature, all the #NMs
>> will have to be trapped by KVM.
>
> The reason is that it's quite common to simply let the guest see all=20
> CPUID bits that KVM knows about.  But it's not unlikely that most gues=
ts=20
> will not ever use any XFD feature, and therefore will not ever see an=20
> #NM.  I wouldn't have any problem with allocating _all_ of the dynamic=20
> state space on the first #NM.
>
> Thinking more about it, #NM only has to be trapped if XCR0 enables a=20
> dynamic feature.  In other words, the guest value of XFD can be limite=
d=20
> to (host_XFD|guest_XFD) & guest_XCR0.  This avoids that KVM=20
> unnecessarily traps for old guests that use CR0.TS.
>

You could simplify this by allocating the state the first time XCR0 enab=
les the feature in question.

(This is how regular non-virt userspace *should* work too, but it looks =
like I=E2=80=99ve probably been outvoted on that front=E2=80=A6)

> Paolo
>
>> Is it really worthwhile for KVM to use XFD at all instead of
>> preallocating the state and being done with it?  KVM would still have
>> to avoid data loss if the guest sets XFD with non-init state, but #NM
>> could always pass through.
>>

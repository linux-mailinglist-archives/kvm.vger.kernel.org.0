Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80FF452953
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 06:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244041AbhKPFDv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 00:03:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:36876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230482AbhKPFDo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 00:03:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A2DB61BF9;
        Tue, 16 Nov 2021 05:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637038848;
        bh=gOA/DqIuHnoyIPWhMKi35OEWm99vzDEl2z9BCaXYPCE=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=ECWHdIsa9raOte0ivRlaX5zUraoSDor3mhLn1LjGpJmCqjYI1EL+gpvDrx51IJ+rm
         +VCi4FdIKlSWHpgaEdNEQV9GW/Q6hYPrNlCJ2abLV6ATrA2YigItSgj5TBy2V5fO2G
         UfpxP0B4WrsVqdOqqwvc/bU5yC+z6EmeuKc7ksM6E0E7WdQllMHu0iCXw0FRQEWVdX
         vSd/QjOvM6oFcsozrooiosqzbozOtI2QCeIAlzNhdOPJGQ31YEiKlcVi+ZCxgKD2Nm
         OXynOhjRjnUgUJLXJgDY7Fq78lnkYKQBkQJw/ZG0Osa20kL+HV/7DKPP7IQ9m/IB0f
         bmuicnUuWNX0A==
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailauth.nyi.internal (Postfix) with ESMTP id 13AC227C0054;
        Tue, 16 Nov 2021 00:00:45 -0500 (EST)
Received: from imap48 ([10.202.2.98])
  by compute6.internal (MEProxy); Tue, 16 Nov 2021 00:00:45 -0500
X-ME-Sender: <xms:-zqTYTkmpastpk7xioLaZBSRJao9k-n9qE52sPvZxvCjyuYGPlTm3w>
    <xme:-zqTYW2YKmgXBYjbSSfdL9g_gq7srYrbJqCH19hxDrrnQws_r-JGvfTr0Lcd2j7EN
    0VC-b49C8sYHIRPYNE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrfedugdejhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtgfesthhqredtreerjeenucfhrhhomhepfdetnhgu
    hicunfhuthhomhhirhhskhhifdcuoehluhhtoheskhgvrhhnvghlrdhorhhgqeenucggtf
    frrghtthgvrhhnpedvleehjeejvefhuddtgeegffdtjedtffegveethedvgfejieevieeu
    feevuedvteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegrnhguhidomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudduiedukeeh
    ieefvddqvdeifeduieeitdekqdhluhhtoheppehkvghrnhgvlhdrohhrgheslhhinhhugi
    drlhhuthhordhush
X-ME-Proxy: <xmx:-zqTYZos8aDErUYGtevu8zo8GpOSWHNJPRa1OlMpwA96D1xkSAP0ug>
    <xmx:-zqTYbnFnSNboyysvQdEXnREdxw3kOK-5xGg3xzoovnZyffzwRl1qg>
    <xmx:-zqTYR0qodo9tm-jUVoP1wGLE_O8e5kUf7g046VWPo_h0_kuu8zlhg>
    <xmx:_TqTYb0twwIFSsfD0VdncnhPVDfBQfN2ipRE5-969-HzkGQC1p3h7YV7F0A>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 781AA21E006E; Tue, 16 Nov 2021 00:00:43 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-1371-g2296cc3491-fm-20211109.003-g2296cc34
Mime-Version: 1.0
Message-Id: <40c1794a-104e-4bcd-add5-2096aefc23e1@www.fastmail.com>
In-Reply-To: <CAA03e5E3Rvx0t8_ZrbNMZwBkjPivGKOg5HCShSFYwfkKDDHWtA@mail.gmail.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com> <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com> <YZJTA1NyLCmVtGtY@work-vm>
 <YZKmSDQJgCcR06nE@google.com>
 <CAA03e5E3Rvx0t8_ZrbNMZwBkjPivGKOg5HCShSFYwfkKDDHWtA@mail.gmail.com>
Date:   Mon, 15 Nov 2021 21:00:23 -0800
From:   "Andy Lutomirski" <luto@kernel.org>
To:     "Marc Orr" <marcorr@google.com>,
        "Sean Christopherson" <seanjc@google.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        "Borislav Petkov" <bp@alien8.de>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Peter Gonda" <pgonda@google.com>,
        "Brijesh Singh" <brijesh.singh@amd.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "kvm list" <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org,
        "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Joerg Roedel" <jroedel@suse.de>,
        "Tom Lendacky" <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Ard Biesheuvel" <ardb@kernel.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        "Wanpeng Li" <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        "Sergio Lopez" <slp@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Srinivas Pandruvada" <srinivas.pandruvada@linux.intel.com>,
        "David Rientjes" <rientjes@google.com>,
        "Dov Murik" <dovmurik@linux.ibm.com>,
        "Tobin Feldman-Fitzthum" <tobin@ibm.com>,
        "Michael Roth" <Michael.Roth@amd.com>,
        "Vlastimil Babka" <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        "Andi Kleen" <ak@linux.intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Sathyanarayanan Kuppuswamy" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP) Hypervisor
 Support
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On Mon, Nov 15, 2021, at 10:41 AM, Marc Orr wrote:
> On Mon, Nov 15, 2021 at 10:26 AM Sean Christopherson <seanjc@google.co=
m> wrote:
>>
>> On Mon, Nov 15, 2021, Dr. David Alan Gilbert wrote:
>> > * Sean Christopherson (seanjc@google.com) wrote:
>> > > On Fri, Nov 12, 2021, Borislav Petkov wrote:
>> > > > On Fri, Nov 12, 2021 at 09:59:46AM -0800, Dave Hansen wrote:
>> > > > > Or, is there some mechanism that prevent guest-private memory=
 from being
>> > > > > accessed in random host kernel code?
>> > >
>> > > Or random host userspace code...
>> > >
>> > > > So I'm currently under the impression that random host->guest a=
ccesses
>> > > > should not happen if not previously agreed upon by both.
>> > >
>> > > Key word "should".
>> > >
>> > > > Because, as explained on IRC, if host touches a private guest p=
age,
>> > > > whatever the host does to that page, the next time the guest ru=
ns, it'll
>> > > > get a #VC where it will see that that page doesn't belong to it=
 anymore
>> > > > and then, out of paranoia, it will simply terminate to protect =
itself.
>> > > >
>> > > > So cloud providers should have an interest to prevent such rand=
om stray
>> > > > accesses if they wanna have guests. :)
>> > >
>> > > Yes, but IMO inducing a fault in the guest because of _host_ bug =
is wrong.
>> >
>> > Would it necessarily have been a host bug?  A guest telling the hos=
t a
>> > bad GPA to DMA into would trigger this wouldn't it?
>>
>> No, because as Andy pointed out, host userspace must already guard ag=
ainst a bad
>> GPA, i.e. this is just a variant of the guest telling the host to DMA=
 to a GPA
>> that is completely bogus.  The shared vs. private behavior just means=
 that when
>> host userspace is doing a GPA=3D>HVA lookup, it needs to incorporate =
the "shared"
>> state of the GPA.  If the host goes and DMAs into the completely wron=
g HVA=3D>PFN,
>> then that is a host bug; that the bug happened to be exploited by a b=
uggy/malicious
>> guest doesn't change the fact that the host messed up.
>
> "If the host goes and DMAs into the completely wrong HVA=3D>PFN, then
> that is a host bug; that the bug happened to be exploited by a
> buggy/malicious guest doesn't change the fact that the host messed
> up."
> ^^^
> Again, I'm flabbergasted that you are arguing that it's OK for a guest
> to exploit a host bug to take down host-side processes or the host
> itself, either of which could bring down all other VMs on the machine.
>
> I'm going to repeat -- this is not OK! Period.

I don=E2=80=99t understand the point you=E2=80=99re trying to make. If t=
he host _kernel_has a bug that allows a guest to trigger invalid host me=
mory access, this is bad. We want to know about it and fix it, abcs the =
security folks want to minimize the chance that such a bug exists.

If host _userspace_ such a bug, the kernel should not crash if it=E2=80=99=
s exploited.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B98452969
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 06:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbhKPFRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 00:17:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:40128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231394AbhKPFRg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 00:17:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6ECAE61BF9;
        Tue, 16 Nov 2021 05:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637039680;
        bh=uzvq7qH1QNygCiG4ASW07zQPbu8n22Hb1H789frznlc=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=Dr6qSNyWB7V4i53e6aageor6AaQNs6MrQZZWkgNHd9I3c9LiuZYXU1WP9mjoGbi7P
         GyZC+oRmac9zUMbNw42V9n9h7sv1h2RyXRb2AW4iTZg5+w/5XiGnJUJ6beT+RdVTI/
         8HfRLqp85ADJVHtbjQVXAZxRxwOKpPvPFNj2EvBdHSie92D4dWqPJYZwbblFDw6VIE
         8AVEUBVg0CoE/AmzHvF/az6GUEMJZ9WOfbnRmSnj5FCFmgyUKu7Nb6Lud45/nwAfUf
         WB+Eg/hjGzYPRWXtziWNPgWFQ0RP08x1WZg8mB8Z3g08BZXpoVSOfTy4N9YG/iUu6w
         vsGbZtX1fiHOw==
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailauth.nyi.internal (Postfix) with ESMTP id 8446B27C0054;
        Tue, 16 Nov 2021 00:14:36 -0500 (EST)
Received: from imap48 ([10.202.2.98])
  by compute6.internal (MEProxy); Tue, 16 Nov 2021 00:14:36 -0500
X-ME-Sender: <xms:Oz6TYaXR5jGLSQAvnT5-P6na7mcwunBrvV1ZWQWs3Ekg2v9R5oDvKQ>
    <xme:Oz6TYWmds0EBERPADmyMtJdWIjXhNxtzAMk-HLYSnFz_l2pZwlDjn7dFeGhD3NO2l
    RtZY5MY634SzsXv2Vg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrfedugdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtgfesthhqredtreerjeenucfhrhhomhepfdetnhgu
    hicunfhuthhomhhirhhskhhifdcuoehluhhtoheskhgvrhhnvghlrdhorhhgqeenucggtf
    frrghtthgvrhhnpedvleehjeejvefhuddtgeegffdtjedtffegveethedvgfejieevieeu
    feevuedvteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegrnhguhidomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudduiedukeeh
    ieefvddqvdeifeduieeitdekqdhluhhtoheppehkvghrnhgvlhdrohhrgheslhhinhhugi
    drlhhuthhordhush
X-ME-Proxy: <xmx:Oz6TYeazEnv9jTDUURa35TuRoZksgGC1pvVijDsy2_oig868mr35JA>
    <xmx:Oz6TYRWpgsXPDY6lvAG5K1sJv3p_dElpEhEGRwLPfZN9XZGgvFh-mA>
    <xmx:Oz6TYUmgKs6Sfn-JUhINeqgxys_CTtEJX1IRP2kHji5XBQPcodbY2Q>
    <xmx:PD6TYWoBJd8MC65OBHhxqV06zimivy9GBijefFqJYQWBbIzAg2uk4BPCDrU>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 4DAE321E006E; Tue, 16 Nov 2021 00:14:35 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-1371-g2296cc3491-fm-20211109.003-g2296cc34
Mime-Version: 1.0
Message-Id: <8a244d34-2b10-4cf8-894a-1bf12b59cf92@www.fastmail.com>
In-Reply-To: <CAA03e5GBajwRJBuTJLPjji7o8QD2daEUJU7DpPJBxtWsf-DE8g@mail.gmail.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com> <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com> <YZJTA1NyLCmVtGtY@work-vm>
 <YZKmSDQJgCcR06nE@google.com>
 <CAA03e5E3Rvx0t8_ZrbNMZwBkjPivGKOg5HCShSFYwfkKDDHWtA@mail.gmail.com>
 <YZKxuxZurFW6BVZJ@google.com>
 <CAA03e5GBajwRJBuTJLPjji7o8QD2daEUJU7DpPJBxtWsf-DE8g@mail.gmail.com>
Date:   Mon, 15 Nov 2021 21:14:14 -0800
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
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Marc Zyngier" <maz@kernel.org>, "Will Deacon" <will@kernel.org>,
        "Quentin Perret" <qperret@google.com>
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP) Hypervisor
 Support
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On Mon, Nov 15, 2021, at 7:07 PM, Marc Orr wrote:
> On Mon, Nov 15, 2021 at 11:15 AM Sean Christopherson <seanjc@google.co=
m> wrote:
>>
>> +arm64 KVM folks
>>
>> On Mon, Nov 15, 2021, Marc Orr wrote:
>> > On Mon, Nov 15, 2021 at 10:26 AM Sean Christopherson <seanjc@google=
.com> wrote:
>> > >
>> > > On Mon, Nov 15, 2021, Dr. David Alan Gilbert wrote:
>> > > > * Sean Christopherson (seanjc@google.com) wrote:
>> > > > > On Fri, Nov 12, 2021, Borislav Petkov wrote:
>> > > > > > On Fri, Nov 12, 2021 at 09:59:46AM -0800, Dave Hansen wrote:
>> > > > > > > Or, is there some mechanism that prevent guest-private me=
mory from being
>> > > > > > > accessed in random host kernel code?
>> > > > >
>> > > > > Or random host userspace code...
>> > > > >
>> > > > > > So I'm currently under the impression that random host->gue=
st accesses
>> > > > > > should not happen if not previously agreed upon by both.
>> > > > >
>> > > > > Key word "should".
>> > > > >
>> > > > > > Because, as explained on IRC, if host touches a private gue=
st page,
>> > > > > > whatever the host does to that page, the next time the gues=
t runs, it'll
>> > > > > > get a #VC where it will see that that page doesn't belong t=
o it anymore
>> > > > > > and then, out of paranoia, it will simply terminate to prot=
ect itself.
>> > > > > >
>> > > > > > So cloud providers should have an interest to prevent such =
random stray
>> > > > > > accesses if they wanna have guests. :)
>> > > > >
>> > > > > Yes, but IMO inducing a fault in the guest because of _host_ =
bug is wrong.
>> > > >
>> > > > Would it necessarily have been a host bug?  A guest telling the=
 host a
>> > > > bad GPA to DMA into would trigger this wouldn't it?
>> > >
>> > > No, because as Andy pointed out, host userspace must already guar=
d against a bad
>> > > GPA, i.e. this is just a variant of the guest telling the host to=
 DMA to a GPA
>> > > that is completely bogus.  The shared vs. private behavior just m=
eans that when
>> > > host userspace is doing a GPA=3D>HVA lookup, it needs to incorpor=
ate the "shared"
>> > > state of the GPA.  If the host goes and DMAs into the completely =
wrong HVA=3D>PFN,
>> > > then that is a host bug; that the bug happened to be exploited by=
 a buggy/malicious
>> > > guest doesn't change the fact that the host messed up.
>> >
>> > "If the host goes and DMAs into the completely wrong HVA=3D>PFN, th=
en
>> > that is a host bug; that the bug happened to be exploited by a
>> > buggy/malicious guest doesn't change the fact that the host messed
>> > up."
>> > ^^^
>> > Again, I'm flabbergasted that you are arguing that it's OK for a gu=
est
>> > to exploit a host bug to take down host-side processes or the host
>> > itself, either of which could bring down all other VMs on the machi=
ne.
>> >
>> > I'm going to repeat -- this is not OK! Period.
>>
>> Huh?  At which point did I suggest it's ok to ship software with bugs=
?  Of course
>> it's not ok to introduce host bugs that let the guest crash the host =
(or host
>> processes).  But _if_ someone does ship buggy host software, it's not=
 like we can
>> wave a magic wand and stop the guest from exploiting the bug.  That's=
 why they're
>> such a big deal.
>>
>> Yes, in this case a very specific flavor of host userspace bug could =
be morphed
>> into a guest exception, but as mentioned ad nauseum, _if_ host usersp=
ace has bug
>> where it does not properly validate a GPA=3D>HVA, then any such bug e=
xists and is
>> exploitable today irrespective of SNP.
>
> If I'm understanding you correctly, you're saying that we will never
> get into the host's page fault handler due to an RMP violation if we
> implement the unmapping guest private memory proposal (without bugs).
>
> However, bugs do happen. And the host-side page fault handler will
> have code to react to an RMP violation (even if it's supposedly
> impossible to hit). I'm saying that the host-side page fault handler
> should NOT handle an RMP violation by killing host-side processes or
> the kernel itself. This is detrimental to host reliability.
>
> There are two ways to handle this. (1) Convert the private page
> causing the RMP violation to shared, (2) Kill the guest.

It=E2=80=99s time to put on my maintainer hat. This is solidly in my ter=
ritory, and NAK.  A kernel privilege fault, from who-knows-what context =
(interrupts off? NMI? locks held?) that gets an RMP violation with no ex=
ception handler is *not* going to blindly write the RMP and retry.  It=E2=
=80=99s not going to send flush IPIs or call into KVM to =E2=80=9Cfix=E2=
=80=9D things.  Just the locking issues alone are probably showstopping,=
 even ignoring the security and sanity issues.

You are welcome to submit patches to make the panic_on_oops=3D0 case as =
robust as practical, and you are welcome to keep running other VMs after=
 we die() and taint the kernel, but that is strictly best effort and is =
a bad idea in a highly security sensitive environment.

And that goes for everyone else here too. If you all have a brilliant id=
ea to lazily fix RMP faults (and the actual semantics are reasonable) an=
d you want my NAK to go away, I want to see a crystal clear explanation =
of what you plan to put in fault.c, how the locking is supposed to work,=
 and how you bound retries such that the system will reliably OOPS if so=
mething goes wrong instead of retrying forever or deadlocking.

Otherwise can we please get on with designing a reasonable model for gue=
st-private memory please?

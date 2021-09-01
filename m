Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D8D3FE0F2
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 19:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345586AbhIARKA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 13:10:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345576AbhIARJ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 13:09:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49D3D60F4B;
        Wed,  1 Sep 2021 17:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630516142;
        bh=FgqmBF9pAQuRJ8MfI1iVwUu38OuSlVWhrjnWchd6bao=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=Nq+JbNXETB6lKGII/0+WzRzFpug4bXCYq1+sFBosCC68sWu+xK7t+m0j078vvd14l
         jxVtQ/jLIHKPEIImuNNzQOGJtplpMXBtB9Ee8vKx7yVay3Jr8Fczw1iIoTdypWAoOa
         SBpkZuRM4i9TCaGsjSQ56VHM054KcrMwt2wyhGjPV7hE0fGa/nahqXOkwl9pmvcwoV
         /9VjZLrB/dr0IP4k+gQ6e/LPC/3CRNDpVkNA12k8nLwfbeU4DNUwd4eceQYB0Zt51w
         0Nt7jUiY44Kd/S9TwLTB0WY+9r9sSHRXD3yW9zu8KcqrH72LcQULdi3QwQ4VUthGOT
         SECOLIPbxxSJQ==
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailauth.nyi.internal (Postfix) with ESMTP id 5EFB627C0054;
        Wed,  1 Sep 2021 13:08:59 -0400 (EDT)
Received: from imap2 ([10.202.2.52])
  by compute6.internal (MEProxy); Wed, 01 Sep 2021 13:08:59 -0400
X-ME-Sender: <xms:p7MvYVnB9crANmd-sPKrc-oRqKST_TroDjpFr6qUqeimq2SdaHntNw>
    <xme:p7MvYQ1lW-rTx3ZpOD2qcSgB8T1Tf6K-DvFpgROwK7AC4WJfnOf5nHBWZqeol1w4M
    8XCcevVVx_GGgtlKMA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddvfedguddtkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvufgtgfesthhqredtreerjeenucfhrhhomhepfdet
    nhguhicunfhuthhomhhirhhskhhifdcuoehluhhtoheskhgvrhhnvghlrdhorhhgqeenuc
    ggtffrrghtthgvrhhnpedvleehjeejvefhuddtgeegffdtjedtffegveethedvgfejieev
    ieeufeevuedvteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpegrnhguhidomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudduiedu
    keehieefvddqvdeifeduieeitdekqdhluhhtoheppehkvghrnhgvlhdrohhrgheslhhinh
    hugidrlhhuthhordhush
X-ME-Proxy: <xmx:p7MvYboMEEsqjNvrT5lgJx0Iv8_l_h735RMb93bltBtrJWJoTe8HWg>
    <xmx:p7MvYVnzn62wP1LAuTkDeE0N9oPlCJizm5ySMdeCBNGYmzHAH9FMVQ>
    <xmx:p7MvYT1XDGJ2sIEgnkZnSFuCAntQihVkbRs62cQKiJVQp58bRKEdfg>
    <xmx:q7MvYZE9bw9eolz7IOKHiRPAtCwXue3oINe2o8_XqtCOahV6DeUEYZNeqD4>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id EAD2EA002E5; Wed,  1 Sep 2021 13:08:54 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-1126-g6962059b07-fm-20210901.001-g6962059b
Mime-Version: 1.0
Message-Id: <85b1dabf-f7be-490a-a856-28227a85ab3a@www.fastmail.com>
In-Reply-To: <bd22ef54224d15ee89130728c408f70da0516eaa.camel@linux.ibm.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
 <YSlkzLblHfiiPyVM@google.com>
 <61ea53ce-2ba7-70cc-950d-ca128bcb29c5@redhat.com>
 <YS6lIg6kjNPI1EgF@google.com>
 <f413cc20-66fc-cf1e-47ab-b8f099c89583@redhat.com>
 <9ec3636a-6434-4c98-9d8d-addc82858c41@www.fastmail.com>
 <bd22ef54224d15ee89130728c408f70da0516eaa.camel@linux.ibm.com>
Date:   Wed, 01 Sep 2021 10:08:33 -0700
From:   "Andy Lutomirski" <luto@kernel.org>
To:     "James Bottomley" <jejb@linux.ibm.com>,
        "David Hildenbrand" <david@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>
Cc:     "Paolo Bonzini" <pbonzini@redhat.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        "Wanpeng Li" <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>, "kvm list" <kvm@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Borislav Petkov" <bp@alien8.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Joerg Roedel" <jroedel@suse.de>,
        "Andi Kleen" <ak@linux.intel.com>,
        "David Rientjes" <rientjes@google.com>,
        "Vlastimil Babka" <vbabka@suse.cz>,
        "Tom Lendacky" <thomas.lendacky@amd.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Ingo Molnar" <mingo@redhat.com>,
        "Varad Gautam" <varad.gautam@suse.com>,
        "Dario Faggioli" <dfaggioli@suse.com>,
        "the arch/x86 maintainers" <x86@kernel.org>, linux-mm@kvack.org,
        linux-coco@lists.linux.dev,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        "Sathyanarayanan Kuppuswamy" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Yu Zhang" <yu.c.zhang@linux.intel.com>
Subject: =?UTF-8?Q?Re:_[RFC]_KVM:_mm:_fd-based_approach_for_supporting_KVM_guest_?=
 =?UTF-8?Q?private_memory?=
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On Wed, Sep 1, 2021, at 9:18 AM, James Bottomley wrote:
> On Wed, 2021-09-01 at 08:54 -0700, Andy Lutomirski wrote:
> [...]
> > If you want to swap a page on TDX, you can't.  Sorry, go directly to
> > jail, do not collect $200.
>=20
> Actually, even on SEV-ES you can't either.  You can read the encrypted
> page and write it out if you want, but unless you swap it back to the
> exact same physical memory location, the encryption key won't work.=20
> Since we don't guarantee this for swap, I think swap won't actually
> work for any confidential computing environment.
>=20
> > So I think there are literally zero code paths that currently call
> > try_to_unmap() that will actually work like that on TDX.  If we run
> > out of memory on a TDX host, we can kill the guest completely and
> > reclaim all of its memory (which probably also involves killing QEMU
> > or whatever other user program is in charge), but that's really our
> > only option.
>=20
> I think our only option for swap is guest co-operation.  We're going to
> have to inflate a balloon or something in the guest and have the guest
> driver do some type of bounce of the page, where it becomes an
> unencrypted page in the guest (so the host can read it without the
> physical address keying of the encryption getting in the way) but
> actually encrypted with a swap transfer key known only to the guest.  I
> assume we can use the page acceptance infrastructure currently being
> discussed elsewhere to do swap back in as well ... the host provides
> the guest with the encrypted swap page and the guest has to decrypt it
> and place it in encrypted guest memory.

I asked David, and he said the PSP offers a swapping mechanism for SEV-E=
S.  I haven=E2=80=99t read the details, but they should all be public.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75373388DF1
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 14:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350930AbhESMZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 08:25:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:48570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347770AbhESMZR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 08:25:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0886860FE8;
        Wed, 19 May 2021 12:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621427036;
        bh=qf5m2Nia+4DoUNrww0bmk5cQtJEm5cWAINMR8yRdz/A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YfCZvauDRbYUmSAlgtaMrkiKYI1UYEyinYzXVIPR7xRh1CtNh0+9OVD9OrNltg37F
         ahwtG1OzCfm+TPgAP2KCQ/seEJB4ce2EP9qVSocsEdEVaEDy5NMlr35rgUFUsut7E7
         UvuvRtU/TJAcTlN9lW3pCF7Im0grQPZmNY7SFmII=
Date:   Wed, 19 May 2021 14:23:54 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Anup Patel <anup@brainfault.org>, Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-staging@lists.linux.dev
Subject: Re: [PATCH v18 00/18] KVM RISC-V Support
Message-ID: <YKUDWgZVj82/KiKw@kroah.com>
References: <20210519033553.1110536-1-anup.patel@wdc.com>
 <YKSa48cejI1Lax+/@kroah.com>
 <CAAhSdy18qySXbUdrEsUe-KtbtuEoYrys0TcmsV2UkEA2=7UQzw@mail.gmail.com>
 <YKSgcn5gxE/4u2bT@kroah.com>
 <YKTsyyVYsHVMQC+G@kroah.com>
 <d7d5ad76-aec3-3297-0fac-a9da9b0c3663@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7d5ad76-aec3-3297-0fac-a9da9b0c3663@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19, 2021 at 01:18:44PM +0200, Paolo Bonzini wrote:
> On 19/05/21 12:47, Greg Kroah-Hartman wrote:
> > > It is not a dumping ground for stuff that arch maintainers can not seem
> > > to agree on, and it is not a place where you can just randomly play
> > > around with user/kernel apis with no consequences.
> > > 
> > > So no, sorry, not going to take this code at all.
> > 
> > And to be a bit more clear about this, having other subsystem
> > maintainers drop their unwanted code on this subsystem,_without_  even
> > asking me first is just not very nice. All of a sudden I am now > responsible for this stuff, without me even being asked about it.
> > Should I start throwing random drivers into the kvm subsystem for them
> > to maintain because I don't want to?:)
> 
> (I did see the smiley), I'm on board with throwing random drivers in
> arch/riscv. :)
> 
> The situation here didn't seem very far from what process/2.Process.rst says
> about staging:
> 
> - "a way to keep track of drivers that aren't up to standards", though in
> this case the issue is not coding standards or quality---the code is very
> good---and which people "may want to use"

Exactly, this is different.  And it's not self-contained, which is
another requirement for staging code that we have learned to enforce
over the years (makes it easier to rip out if no one is willing to
maintain it.)

> - the code could be removed if there's no progress on either changing the
> RISC-V acceptance policy or ratifying the spec

I really do not understand the issue here, why can this just not be
merged normally?

Is the code somehow not ok?  Is it relying on hardware in ways that
breaks other users?  Does it cause problems for different users?  Is it
a user api that you don't like or think is the "proper" one?

All staging drivers need a TODO list that shows what needs to be done in
order to get it out of staging.  All I can tell so far is that the riscv
maintainers do not want to take this for "unknown reasons" so let's dump
it over here for now where we don't have to see it.

And that's not good for developers or users, so perhaps the riscv rules
are not very good?

> Of course there should have been a TODO file explaining the situation. But
> if you think this is not the right place, I totally understand; if my
> opinion had any weight in this, I would just place it in arch/riscv/kvm.
> 
> The RISC-V acceptance policy as is just doesn't work, and the fact that
> people are trying to work around it is proving it.  There are many ways to
> improve it:

What is this magical acceptance policy that is preventing working code
from being merged?  And why is it suddenly the rest of the kernel
developer's problems because of this?

thanks,

greg k-h

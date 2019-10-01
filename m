Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D858C4101
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 21:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbfJAT1C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 15:27:02 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:45973 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbfJAT1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 15:27:01 -0400
Received: by mail-io1-f66.google.com with SMTP id c25so50940634iot.12
        for <kvm@vger.kernel.org>; Tue, 01 Oct 2019 12:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CDB4Mr0iG0b8DZwf+9GVE2W/2/4rQLMQuTsEyTKgfxg=;
        b=XWtd59gQjCBrAcOGNEPfbnOmeyLmC8q+y7bnqdcqPPAzsEIqnwuf8b7G/Ykbf2omhf
         qSOmk8/mV4JnCZvGjSKNBoEX0S1OOYXBxd+7YRWt/O52zkwcPPb/2fJAe5SqAVMTWyK5
         zjjkfAkywB0pP1bzx9ZlwC2xNzUCzeJ63dltV9z/0FMtS9BNIXcnUixa1nmw7tGWks2r
         7HDJCH54iauzKpQMM0kDcgTdg/NeUOCNYTAfxxvPhJIOCP8r7ISWPPZkqCL73GmmeOz6
         4fhbzzAZ1mZfgJZD49knx5oA/icUZ1tdbNKPlfgZuRJf+kHsRsqFGT9syWeP9yFVtGRN
         bI3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CDB4Mr0iG0b8DZwf+9GVE2W/2/4rQLMQuTsEyTKgfxg=;
        b=nygdVP1EP3uyW8uCGmikI3GJBwxaUDWA6sXsNi4/4rePMO0SWtAXTr5i6SNbrMPAdb
         5qViCqHG9IREyAHRt2AVa4DasxKCfNaeX/XlFe5f5YVxltt9hSvJN8HV5sXFr98UVbfK
         F907QZTHg2XiCb6lhYcZr1yxpNyw1/MmrDBfbswbqsYFBtsXTpl86CFelEw0BiJWKt5s
         APrldJgqt70ZwxPYjy5VNNNjecdImX/urC6POB1pS1UFtWDikvJrP/9jR86x4YQH3dYE
         ymJZkZdYSe3RTgONq54vCdtiWoQzW5O72k5b/VNHBzChFz2CIdesIQPphTIA4nkubg1b
         Q4aw==
X-Gm-Message-State: APjAAAUiD/aEiX9+IJYd4SnuCSW+qe4lBWAOCruVS0O1yJmKM9iyUKWB
        7rJHj7KdZKqiorE4e2a6mdfll+nar7yVAdRWaaTP4g==
X-Google-Smtp-Source: APXvYqxa+XAZgS+BaZXqlx3MCcJxVxQdpqq/kdyykgpz0c7smVyWi9Y90pI/20bwlYl6cLmvD7qHH6A0LIJEnSELKek=
X-Received: by 2002:a6b:6a01:: with SMTP id x1mr6160792iog.119.1569958020338;
 Tue, 01 Oct 2019 12:27:00 -0700 (PDT)
MIME-Version: 1.0
References: <1545227503-214403-1-git-send-email-robert.hu@linux.intel.com>
 <CALMp9eRZCoZbeyttZdvaCUpOFKygTNVF_x7+TWh6MktmF-ZK9A@mail.gmail.com>
 <263d31d9-b21e-ceb9-b47c-008e30bbd94f@redhat.com> <CALMp9eRFWq+F1Dwb8NcBd-Bo-YbT6KMOLo8DoinQQfK9hEi5Qg@mail.gmail.com>
 <20190930175449.GB4084@habkost.net> <CALMp9eR88jE7YV-TmZSSD2oJhEpbsgo-LCgsWHkyFtHcHTmnzw@mail.gmail.com>
 <9bbe864ab8fb16d9e64745b930c89b1db24ccc3a.camel@intel.com>
 <CALMp9eSe_7on+F=ng05DkvvBpnWhSirEpSVz9Bua4Sy606xJnw@mail.gmail.com>
 <20191001170646.GA27090@linux.intel.com> <CALMp9eSj=KJC6SjOnPfN7R0vHB_75KjBeF3aYD2J75Sy3L7tcA@mail.gmail.com>
 <20191001175415.GB27090@linux.intel.com>
In-Reply-To: <20191001175415.GB27090@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 1 Oct 2019 12:26:48 -0700
Message-ID: <CALMp9eTrP2FHA0+cwU7SPwsitJ7PA1gRe1i2xAJ0Lx9QWxV17A@mail.gmail.com>
Subject: Re: [PATCH] x86: Add CPUID KVM support for new instruction WBNOINVD
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "ehabkost@redhat.com" <ehabkost@redhat.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Hu, Robert" <robert.hu@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 1, 2019 at 10:54 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Oct 01, 2019 at 10:23:31AM -0700, Jim Mattson wrote:
> > On Tue, Oct 1, 2019 at 10:06 AM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > On Tue, Oct 01, 2019 at 07:20:17AM -0700, Jim Mattson wrote:
> > > > On Mon, Sep 30, 2019 at 5:45 PM Huang, Kai <kai.huang@intel.com> wr=
ote:
> > > > >
> > > > > On Mon, 2019-09-30 at 12:23 -0700, Jim Mattson wrote:
> > > > > > On Mon, Sep 30, 2019 at 10:54 AM Eduardo Habkost <ehabkost@redh=
at.com> wrote:
> > > > > > I had only looked at the SVM implementation of WBNOINVD, which =
is
> > > > > > exactly the same as the SVM implementation of WBINVD. So, the q=
uestion
> > > > > > is, "why enumerate WBNOINVD if its implementation is exactly th=
e same
> > > > > > as WBINVD?"
> > > > > >
> > > > > > WBNOINVD appears to be only partially documented in Intel docum=
ent
> > > > > > 319433-037, "Intel=C2=AE Architecture Instruction Set Extension=
s and Future
> > > > > > Features Programming Reference." In particular, there is no
> > > > > > documentation regarding the instruction's behavior in VMX non-r=
oot
> > > > > > mode. Does WBNOINVD cause a VM-exit when the VM-execution contr=
ol,
> > > > > > "WBINVD exiting," is set? If so, does it have the same VM-exit =
reason
> > > > > > as WBINVD (54), or a different one? If it does have the same VM=
-exit
> > > > > > reason (a la SVM), how does one distinguish a WBINVD VM-exit fr=
om a
> > > > > > WBNOINVD VM-exit? If one can't distinguish (a la SVM), then it =
would
> > > > > > seem that the VMX implementation also implements WBNOINVD as WB=
INVD.
> > > > > > If that's the case, the question for VMX is the same as for SVM=
.
> > > > >
> > > > > Unfortunately WBNOINVD interaction with VMX has not been made to =
public yet.
> > >
> > > Hint: WBNOINVD uses a previously ignored prefix, i.e. it looks a *lot=
*
> > >       like WBINVD...
> >
> > Because of the opcode selection, I would assume that we're not going
> > to see a VM-execution control for "enable WBNOINVD." To avoid breaking
> > legacy hypervisors, then, I would expect the "enable WBINVD exiting"
> > control to apply to WBNOINVD as well, and I would expect the exit
> > reason to be the same for both instructions. The exit qualification
> > field is cleared for WBINVD exits, so perhaps we will see a bit in
> > that field set to one for WBNOINVD.
>
> Those are all excellent assumptions.
>
> > If so, will this new behavior be indicated by a bit in one of the VMX
> > capability MSRs?
>
> My crystal ball came up blank on this one.
>
> > That seems to be a closely guarded secret, for some reason.
>
> Not a closely guarded secret, just poor documentation.
>
> > > > > I am reaching out internally to see when it can be done. I agree =
it may not be
> > > > > necessary to expose WBNOINVD if its implementation is exactly the=
 same as
> > > > > WBINVD, but it also doesn't have any harm, right?
> > > >
> > > > If nested VMX changes are necessary to be consistent with hardware,
> > > > then enumerating WBNOINVD support in the guest CPUID information at
> > > > this time--without the attendant nested VMX changes--is premature. =
No
> > > > changes to nested SVM are necessary, so it's fine for AMD systems.
> > > >
> > > > If no changes to nested VMX are necessary, then it is true that
> > > > WBNOINVD can be emulated by WBINVD. However, it provides no value t=
o
> > > > specifically enumerate the instruction.
> > > >
> > > > If there is some value that I'm missing, then why make guest suppor=
t
> > > > for the instruction contingent on host support for the instruction?
> > > > KVM can implement WBNOINVD as WBINVD on any host with WBINVD,
> > > > regardless of whether or not the host supports WBNOINVD.
> > >
> > > Agreed.  To play nice with live migration, KVM should enumerate WBNOI=
NVD
> > > regardless of host support.  Since WBNOINVD uses an ignored prefix, i=
t
> > > will simply look like a regular WBINVD on platforms without WBNOINVD.
> > >
> > > Let's assume the WBNOINVD VM-Exit behavior is sane, i.e. allows softw=
are
> > > to easily differentiate between WBINVD and WBNOINVD.
> >
> > That isn't the case with SVM, oddly.
>
> Assuming AMD uses the same opcode as Intel, maybe they're expecting VMMs
> to use the decode assist feature to check for the prefix?

There are no specific decode assists for WBINVD/WBNOINVD in the
EXITINFO* fields. The "generic" decode assist, where the instruction
bytes are stored in the VMCB, only applies to nested page faults and
#PF intercepts.

> > > In that case, the
> > > value added would be that KVM can do WBNOINVD instead of WBINVD in th=
e
> > > unlikely event that (a) KVM needs to executed WBINVD on behalf of the
> > > guest (because the guest has non-coherent DMA), (b) WBNOINVD is suppo=
rted
> > > on the host, and (c) WBNOINVD is used by the guest (I don't think it =
would
> > > be safe to assume that the guest doesn't need the caches invalidated =
on
> > > WBINVD).
> >
> > I agree that there would be value if KVM implemented WBNOINVD using
> > WBNOINVD, but that isn't what this change does. My question was, "What
> > is the value in enumerating WBNOINVD if KVM is just going to implement
> > it with WBINVD anyway?"
>
> Ah, I was stating what I would expect the KVM change to be, I didn't
> realize this patch was merged almost a year ago.
>
> I suppose theoretically it would allow live migrating from an old kernel
> to a new kernel and gaining actual WBNOINVD support along the way?

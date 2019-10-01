Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0EAC3E7D
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 19:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbfJARXo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 13:23:44 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:36642 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729625AbfJARXn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 13:23:43 -0400
Received: by mail-io1-f68.google.com with SMTP id b136so50005562iof.3
        for <kvm@vger.kernel.org>; Tue, 01 Oct 2019 10:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8xozfczvIWG0Y2vsrBbOpjZK317MVtMR97uRKfEeqqs=;
        b=cwXFvZRlT7iYMECk+nNP180Y0aucbUjcyJov1D5QuGO2uZr2rRh4Mq2uGjUthqxsra
         FeMmWE4H2lp+LiYAOWCerSOH3FFIUo0moHdI7b4IxQBaI6Po7FTskocmUBJHeRPfCAGI
         v9ZG8w8ILLflo9F/M8CBomqGCu/tOk0VhjZkBbzKT0BMNHEYX9mjotEySUGWkiyvnsbs
         vvGE9nlapb/d1D0fki74tiZv+cjDIsCuu8JsaPahBZQKEex1KXHZsFZaO37wZKlgFK50
         bUKtOgDJmAlwEVHCAXnB5upt3kG1foE/gXe6eKnt7FuX1a+ZW/cbuOzShxqufNyTfO7V
         yIoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8xozfczvIWG0Y2vsrBbOpjZK317MVtMR97uRKfEeqqs=;
        b=HuoZOYH+FCKtK0xfkazqmZ1JqmVEXkORLmgFFJxylsSN2efKBh4THEjr9ZjYqb37FY
         xCOmnMTv6KL4gJREioXbOeocKMCLZmzxpwj6xYgQIlwoa83Y5/2LhTDpl4G2Na4WgxT5
         KP+E7+87FWNfo2XWkPJ2PD9TdXp0n1Vhkgz2QD0qAn2DwtgWeEHamdMR1d+c5mVzMwAP
         5sF7eJ6+F8qEdIO3eJYuy3or9eTYj0dadzQZ4uhLoYO3hMAq7gAC7FgVvGEI3SFplpXY
         beOhx1EpmZy/6sXjha8o/0hO6TTqnX696VIj68W+Ucnk7/CztT6qZjcdhfGbYCXT5Gdi
         CdcQ==
X-Gm-Message-State: APjAAAVH5qpNOnxaiiKBMZTOLuvD9LDHC+JmVTQzTS3wiisEG5y+5mmX
        JhvEh6WBYdBr+qH7NiiZrFdaiwfxcXsDvARB/gR+aA==
X-Google-Smtp-Source: APXvYqwMMYqnkgfTd4cRC9oaitJxx48ATAxxvxhvOAer3742O+Ste/bSfS0iuYPZeoQWV8SeZgu9/xodXpUII3N6ILk=
X-Received: by 2002:a92:5e0b:: with SMTP id s11mr27925232ilb.26.1569950622482;
 Tue, 01 Oct 2019 10:23:42 -0700 (PDT)
MIME-Version: 1.0
References: <1545227503-214403-1-git-send-email-robert.hu@linux.intel.com>
 <CALMp9eRZCoZbeyttZdvaCUpOFKygTNVF_x7+TWh6MktmF-ZK9A@mail.gmail.com>
 <263d31d9-b21e-ceb9-b47c-008e30bbd94f@redhat.com> <CALMp9eRFWq+F1Dwb8NcBd-Bo-YbT6KMOLo8DoinQQfK9hEi5Qg@mail.gmail.com>
 <20190930175449.GB4084@habkost.net> <CALMp9eR88jE7YV-TmZSSD2oJhEpbsgo-LCgsWHkyFtHcHTmnzw@mail.gmail.com>
 <9bbe864ab8fb16d9e64745b930c89b1db24ccc3a.camel@intel.com>
 <CALMp9eSe_7on+F=ng05DkvvBpnWhSirEpSVz9Bua4Sy606xJnw@mail.gmail.com> <20191001170646.GA27090@linux.intel.com>
In-Reply-To: <20191001170646.GA27090@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 1 Oct 2019 10:23:31 -0700
Message-ID: <CALMp9eSj=KJC6SjOnPfN7R0vHB_75KjBeF3aYD2J75Sy3L7tcA@mail.gmail.com>
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

On Tue, Oct 1, 2019 at 10:06 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Oct 01, 2019 at 07:20:17AM -0700, Jim Mattson wrote:
> > On Mon, Sep 30, 2019 at 5:45 PM Huang, Kai <kai.huang@intel.com> wrote:
> > >
> > > On Mon, 2019-09-30 at 12:23 -0700, Jim Mattson wrote:
> > > > On Mon, Sep 30, 2019 at 10:54 AM Eduardo Habkost <ehabkost@redhat.c=
om> wrote:
> > > > I had only looked at the SVM implementation of WBNOINVD, which is
> > > > exactly the same as the SVM implementation of WBINVD. So, the quest=
ion
> > > > is, "why enumerate WBNOINVD if its implementation is exactly the sa=
me
> > > > as WBINVD?"
> > > >
> > > > WBNOINVD appears to be only partially documented in Intel document
> > > > 319433-037, "Intel=C2=AE Architecture Instruction Set Extensions an=
d Future
> > > > Features Programming Reference." In particular, there is no
> > > > documentation regarding the instruction's behavior in VMX non-root
> > > > mode. Does WBNOINVD cause a VM-exit when the VM-execution control,
> > > > "WBINVD exiting," is set? If so, does it have the same VM-exit reas=
on
> > > > as WBINVD (54), or a different one? If it does have the same VM-exi=
t
> > > > reason (a la SVM), how does one distinguish a WBINVD VM-exit from a
> > > > WBNOINVD VM-exit? If one can't distinguish (a la SVM), then it woul=
d
> > > > seem that the VMX implementation also implements WBNOINVD as WBINVD=
.
> > > > If that's the case, the question for VMX is the same as for SVM.
> > >
> > > Unfortunately WBNOINVD interaction with VMX has not been made to publ=
ic yet.
>
> Hint: WBNOINVD uses a previously ignored prefix, i.e. it looks a *lot*
>       like WBINVD...

Because of the opcode selection, I would assume that we're not going
to see a VM-execution control for "enable WBNOINVD." To avoid breaking
legacy hypervisors, then, I would expect the "enable WBINVD exiting"
control to apply to WBNOINVD as well, and I would expect the exit
reason to be the same for both instructions. The exit qualification
field is cleared for WBINVD exits, so perhaps we will see a bit in
that field set to one for WBNOINVD. If so, will this new behavior be
indicated by a bit in one of the VMX capability MSRs? That seems to be
a closely guarded secret, for some reason.

> > > I am reaching out internally to see when it can be done. I agree it m=
ay not be
> > > necessary to expose WBNOINVD if its implementation is exactly the sam=
e as
> > > WBINVD, but it also doesn't have any harm, right?
> >
> > If nested VMX changes are necessary to be consistent with hardware,
> > then enumerating WBNOINVD support in the guest CPUID information at
> > this time--without the attendant nested VMX changes--is premature. No
> > changes to nested SVM are necessary, so it's fine for AMD systems.
> >
> > If no changes to nested VMX are necessary, then it is true that
> > WBNOINVD can be emulated by WBINVD. However, it provides no value to
> > specifically enumerate the instruction.
> >
> > If there is some value that I'm missing, then why make guest support
> > for the instruction contingent on host support for the instruction?
> > KVM can implement WBNOINVD as WBINVD on any host with WBINVD,
> > regardless of whether or not the host supports WBNOINVD.
>
> Agreed.  To play nice with live migration, KVM should enumerate WBNOINVD
> regardless of host support.  Since WBNOINVD uses an ignored prefix, it
> will simply look like a regular WBINVD on platforms without WBNOINVD.
>
> Let's assume the WBNOINVD VM-Exit behavior is sane, i.e. allows software
> to easily differentiate between WBINVD and WBNOINVD.

That isn't the case with SVM, oddly.

> In that case, the
> value added would be that KVM can do WBNOINVD instead of WBINVD in the
> unlikely event that (a) KVM needs to executed WBINVD on behalf of the
> guest (because the guest has non-coherent DMA), (b) WBNOINVD is supported
> on the host, and (c) WBNOINVD is used by the guest (I don't think it woul=
d
> be safe to assume that the guest doesn't need the caches invalidated on
> WBINVD).

I agree that there would be value if KVM implemented WBNOINVD using
WBNOINVD, but that isn't what this change does. My question was, "What
is the value in enumerating WBNOINVD if KVM is just going to implement
it with WBINVD anyway?"

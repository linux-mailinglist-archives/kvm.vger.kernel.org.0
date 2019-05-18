Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0FE220D9
	for <lists+kvm@lfdr.de>; Sat, 18 May 2019 02:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbfERAGK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 20:06:10 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:42734 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728869AbfERAGK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 May 2019 20:06:10 -0400
Received: by mail-qk1-f193.google.com with SMTP id d4so5510746qkc.9
        for <kvm@vger.kernel.org>; Fri, 17 May 2019 17:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qUU/PCHJ10Cnm4pEYGt2NYLBE8MczWcaqgp3zO0rTb0=;
        b=XpHCXZ0vlW6ZB0LjNM3gSWk+gqE+tUaKl7t5x0Uy0r30UxhLbJy+WPkVwwq+x9/KQw
         +CRNhMn/4++Gq8rK/DF2O3PN4lwDVocPTCjf90D6TQL/JFiByl1VKPohza0LgoggQUBz
         PBQbfib83VzeF6lJ7d6/ERQaZw7rah61nnorKe+b9YXK0B+pXNDa5VZsNEEl7foC4tjD
         1/Bh+WHotDx8JFM0DJ3sa09ujJ/a8zWFMl0O2QphX/caCiFP54RYDbSlvUZFlGbJK594
         7fySsbMJ780nVzcYMRutROAriGZ/5rGlAuaXRPOzLRCsbglNSZkVH0rCdmrEB4TiipDl
         cTYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qUU/PCHJ10Cnm4pEYGt2NYLBE8MczWcaqgp3zO0rTb0=;
        b=npE6+Nie69zmgMMYIxty2EACbutYfX6fFEHtO6kxStD2M2I1RvEv6HXVtqmytO+sfh
         mvyz37P6+kt2H4KSTCylHmmCimEevk0aTAzM08QDYuEG/oqFBpL09PKQEGdKYsh095pA
         RYMpSZd6kaaRCBIgZXb8SZxOdr1OZV2TKeW8BcNSI15ClTgciS5Pl2oTj234SzZ1+RCg
         X7HtLv1jUjAfm7TB6IhWZzYgbcoC6fyxKAQonNYmvxKh/1l+sycBVbX3vHilDkvsNCHg
         mjxNwAY4Mj8YCC6n+BeP0k9ry/lEMf/whuEFypnj06QK85rDaUDUVL5Kl9uTzSHGd5Jo
         Ih2w==
X-Gm-Message-State: APjAAAUTg/o+FUsfAWf0WilAdL7iUEoX6UmSPkuArcKgXjKKyb6zbOtD
        w1c01rc6jRjPSMLJsC9C2LdvI9pcbKbP74+tJUFm
X-Google-Smtp-Source: APXvYqx9dlDkMrn2MOaCbua3SEWTUfkJSCGmXC5rRUtuNpy08kKWyNNzYC2LUnAUQvuDM1Xcl2tLkYeLd/8PvwCfoRM=
X-Received: by 2002:a37:4948:: with SMTP id w69mr49213504qka.122.1558137968878;
 Fri, 17 May 2019 17:06:08 -0700 (PDT)
MIME-Version: 1.0
References: <b8487de1-83a8-2761-f4a6-26c583eba083@oracle.com>
 <B447B6E8-8CEF-46FF-9967-DFB2E00E55DB@amacapital.net> <4e7d52d7-d4d2-3008-b967-c40676ed15d2@oracle.com>
 <CALCETrXtwksWniEjiWKgZWZAyYLDipuq+sQ449OvDKehJ3D-fg@mail.gmail.com>
 <e5fedad9-4607-0aa4-297e-398c0e34ae2b@oracle.com> <20190514170522.GW2623@hirez.programming.kicks-ass.net>
 <20190514180936.GA1977@linux.intel.com> <CALCETrVzbBLokip5n0KEyG6irH6aoEWqyNODTy8embpXhB1GQg@mail.gmail.com>
 <20190514210603.GD1977@linux.intel.com> <A1EB80C0-2D88-4DC0-A898-3BED50A4F5A8@amacapital.net>
 <20190514223823.GE1977@linux.intel.com>
In-Reply-To: <20190514223823.GE1977@linux.intel.com>
From:   Jonathan Adams <jwadams@google.com>
Date:   Fri, 17 May 2019 17:05:32 -0700
Message-ID: <CA+VK+GOL_sY5aWYijg1_X6VgvDtFbRX2ymuSXhsZeZH2_tO2qg@mail.gmail.com>
Subject: Re: [RFC KVM 18/27] kvm/isolation: function to copy page table
 entries for percpu buffer
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Setje-Eilers <jan.setjeeilers@oracle.com>,
        Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 14, 2019 at 3:38 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
> On Tue, May 14, 2019 at 02:55:18PM -0700, Andy Lutomirski wrote:
> > > On May 14, 2019, at 2:06 PM, Sean Christopherson <sean.j.christophers=
on@intel.com> wrote:
> > >> On Tue, May 14, 2019 at 01:33:21PM -0700, Andy Lutomirski wrote:
> > >> I suspect that the context switch is a bit of a red herring.  A
> > >> PCID-don't-flush CR3 write is IIRC under 300 cycles.  Sure, it's slo=
w,
> > >> but it's probably minor compared to the full cost of the vm exit.  T=
he
> > >> pain point is kicking the sibling thread.
> > >
> > > Speaking of PCIDs, a separate mm for KVM would mean consuming another
> > > ASID, which isn't good.
> >
> > I=E2=80=99m not sure we care. We have many logical address spaces (two =
per mm plus a
> > few more).  We have 4096 PCIDs, but we only use ten or so.  And we have=
 some
> > undocumented number of *physical* ASIDs with some undocumented mechanis=
m by
> > which PCID maps to a physical ASID.
>
> Yeah, I was referring to physical ASIDs.
>
> > I don=E2=80=99t suppose you know how many physical ASIDs we have?
>
> Limited number of physical ASIDs.  I'll leave it at that so as not to
> disclose something I shouldn't.
>
> > And how it interacts with the VPID stuff?
>
> VPID and PCID get factored into the final ASID, i.e. changing either one
> results in a new ASID.  The SDM's oblique way of saying that:
>
>   VPIDs and PCIDs (see Section 4.10.1) can be used concurrently. When thi=
s
>   is done, the processor associates cached information with both a VPID a=
nd
>   a PCID. Such information is used only if the current VPID and PCID both
>   match those associated with the cached information.
>
> E.g. enabling PTI in both the host and guest consumes four ASIDs just to
> run a single task in the guest:
>
>   - VPID=3D0, PCID=3Dkernel
>   - VPID=3D0, PCID=3Duser
>   - VPID=3D1, PCID=3Dkernel
>   - VPID=3D1, PCID=3Duser
>
> The impact of consuming another ASID for KVM would likely depend on both
> the guest and host configurations/worloads, e.g. if the guest is using a
> lot of PCIDs then it's probably a moot point.  It's something to keep in
> mind though if we go down this path.

One answer to that would be to have the KVM page tables use the same
PCID as the normal user-mode PTI page tables.  It's not ideal (since
the qemu/whatever process can see some kernel data via meltdown it
wouldn't be able to normally see), but might be an option to
investigate.

Cheers,
- jonathan

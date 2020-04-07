Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B820D1A0473
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 03:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgDGBXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 21:23:24 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37605 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgDGBXY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Apr 2020 21:23:24 -0400
Received: by mail-lf1-f67.google.com with SMTP id t11so1056904lfe.4
        for <kvm@vger.kernel.org>; Mon, 06 Apr 2020 18:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8xLjgb+qGG1qiDMfAEEmGgrAB+VQUtcxURJEWn+sb/E=;
        b=LXXGsD2rAjvNbJ25G+PeWz1PdGgiEBdPoOmIDPFW1l76hp18A8PCL0Qt+lECooczdV
         0PkgRztrvi5F61Pbl95AdPnsDwC0iH/Xvr33BJ+zKqIucp040ByHEeGsZZu+VTX0VOjT
         O2kilg4Fy/BcQp6OKQPU2Z6zj6zjUPOEuOASXbrphTpNKCVkd22Q8gQCh1mtuvfpAQse
         V0YMUAPR2foHEsWS4N4AagOTiQw1rNDE/tPBE5jTO3hbeHTtOeeWQH++9RWZm2ido8gd
         hHdMIlmZIdT0OF7mjJhPoMiRKbcoj0RT85iAIaGyN5ouV8TPpHNJsX1DgfEFSx4Uad32
         rrTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8xLjgb+qGG1qiDMfAEEmGgrAB+VQUtcxURJEWn+sb/E=;
        b=NU7zj83j0W4VLmuOBRSQMBvb2NufwJ4A1uC3XsUYrHGtLHtxibXn0D5RSF1MvbDj7q
         aVWlXhHmYTC7Mw8cGYWCLJ0gvLZQtfANLYKWqZemZXxbgK/bOQijXz5zvAyz0YqtRgJH
         cgX92dl56QTFymSIhmgkzn61jkZNcjFuiQy+Dg1kEVt9XuFukHhzpJFvjRLOvFyJu+oG
         Z8XuxP1unph1Fbd/pfuEVyyYwQCmca3jr8oQRPxzG49MYNLnClL/VBEYCyiT7+69X3m3
         O4NX3uWrxbNY0eiXv2WBNyBGwG1TXeUFOOgnSoxx3LZtxY92RQE1suwLAgWot6IoB4e/
         uZNg==
X-Gm-Message-State: AGi0PubXrPM48Os3r8WuE4Ar1NLeN42y1mk+EJAFaHKyEnDD/4OypTbC
        kT8RITD6RSN035K4B2Aj+nIUFIEL488AMExuSB2Pgw==
X-Google-Smtp-Source: APiQypIAztOmACBrFlcA1sIVqbnFab4W16i+LdbWBEUI4zmOCh5q8+HTubZsrBnZPKZ9UvovS5gU+1cUMbg54YRVGGQ=
X-Received: by 2002:a19:f20c:: with SMTP id q12mr14873243lfh.34.1586222600886;
 Mon, 06 Apr 2020 18:23:20 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1585548051.git.ashish.kalra@amd.com> <6dda7016ab64490ac3d8e74f461f9f3d0ee3fc88.1585548051.git.ashish.kalra@amd.com>
 <9d1f29da-2d63-dfed-228f-b82b3cc2b777@oracle.com>
In-Reply-To: <9d1f29da-2d63-dfed-228f-b82b3cc2b777@oracle.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 6 Apr 2020 18:22:44 -0700
Message-ID: <CABayD+d3RQeokU9vfNiChF5hwvmkBM4C3fh19M1wYi4oY4nD_Q@mail.gmail.com>
Subject: Re: [PATCH v6 07/14] KVM: x86: Add AMD SEV specific Hypercall3
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 2, 2020 at 4:56 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
> On 3/29/20 11:21 PM, Ashish Kalra wrote:
> > From: Brijesh Singh <Brijesh.Singh@amd.com>
> >
> > KVM hypercall framework relies on alternative framework to patch the
> > VMCALL -> VMMCALL on AMD platform. If a hypercall is made before
> > apply_alternative()
>
> s/apply_alternative/apply_alternatives/
> > is called then it defaults to VMCALL. The approach
> > works fine on non SEV guest. A VMCALL would causes #UD, and hypervisor
> > will be able to decode the instruction and do the right things. But
> > when SEV is active, guest memory is encrypted with guest key and
> > hypervisor will not be able to decode the instruction bytes.
> >
> > Add SEV specific hypercall3, it unconditionally uses VMMCALL. The hyper=
call
> > will be used by the SEV guest to notify encrypted pages to the hypervis=
or.
> >
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: "Radim Kr=C4=8Dm=C3=A1=C5=99" <rkrcmar@redhat.com>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Borislav Petkov <bp@suse.de>
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Cc: x86@kernel.org
> > Cc: kvm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > ---
> >   arch/x86/include/asm/kvm_para.h | 12 ++++++++++++
> >   1 file changed, 12 insertions(+)
> >
> > diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm=
_para.h
> > index 9b4df6eaa11a..6c09255633a4 100644
> > --- a/arch/x86/include/asm/kvm_para.h
> > +++ b/arch/x86/include/asm/kvm_para.h
> > @@ -84,6 +84,18 @@ static inline long kvm_hypercall4(unsigned int nr, u=
nsigned long p1,
> >       return ret;
> >   }
> >
> > +static inline long kvm_sev_hypercall3(unsigned int nr, unsigned long p=
1,
> > +                                   unsigned long p2, unsigned long p3)
> > +{
> > +     long ret;
> > +
> > +     asm volatile("vmmcall"
> > +                  : "=3Da"(ret)
> > +                  : "a"(nr), "b"(p1), "c"(p2), "d"(p3)
> > +                  : "memory");
> > +     return ret;
> > +}
> > +
> >   #ifdef CONFIG_KVM_GUEST
> >   bool kvm_para_available(void);
> >   unsigned int kvm_arch_para_features(void);
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

Nit: I'd personally have named this kvm_vmmcall3, since it's about
invoking a particular instruction. The usage happens to be for SEV.

Reviewed-by: Steve Rutherford <srutherford@google.com>

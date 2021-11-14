Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1752844F72D
	for <lists+kvm@lfdr.de>; Sun, 14 Nov 2021 08:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbhKNH5T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Nov 2021 02:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhKNH5N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Nov 2021 02:57:13 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327ADC061766
        for <kvm@vger.kernel.org>; Sat, 13 Nov 2021 23:54:16 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id n66so27495265oia.9
        for <kvm@vger.kernel.org>; Sat, 13 Nov 2021 23:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mt/vtZHK8U1Y/g0MBAk3dgrCqujD9uU9xm4N+TPiSC4=;
        b=tBOhWBAxKbwGO/xAhEYg4SBgMOy31mURG+gnZgnfLWd0BcqM4s6mHLkFKKh9U20tqm
         j21UFff0YGhDA2L5IMJge6yKksxUep3zESPktW08MvFCpLVyt4Nv7r1BxR82ws+hY6/S
         UWFfsFPKT5q+ifV7sZMKU3O57gCLfybInChsSP9l+tNHzXKzudrCgvtFkc+sKedNIXgN
         MZOYa7Mkq5SglN22g7X9lmOWUZyx3TZKvHGcvEV8BYWbZRIYtB/Bmh51jSluTwi6ATE6
         SYXOwfYZXzFY2gYXfZ8NxFvzsR6AMs36aseiZileJ5s2gFJx+8bgkzF0VXINlm21cWq8
         /XwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mt/vtZHK8U1Y/g0MBAk3dgrCqujD9uU9xm4N+TPiSC4=;
        b=iHixQ87kdt8nNBRZHVIIdl96/jepaGuVgTBLfOnWIRToliIHZDfGgwcS53yL7JGKsF
         1my5m0/Z+FqLaoFkocMbJ7g7fSb1YXm7nZ1bRFi5xtUlyJZMDy1JQX+pO1Bh9Ydt2LE/
         v08H5PBQWHwOI9WedQmb14Llh9Cj7vLsSIXb0dJNeh+Hj8rgfKj9OR5mnSi3VNI+W0H9
         SZxKlaRaZLc/E2gRHN2Lc9tCOSKn7rDmys10bwsF3EkBORBhGN5vGSLScwCewM7xj1p/
         7Eg/SqmCAeI7nWE1nSps9Zrevwn1MkoSVvi74xVzIEhAq0nJLeUCdcS4mibTEi/ILSmI
         7sdA==
X-Gm-Message-State: AOAM5307sHF0t7ooHSJKM0t8UqMO+og80xCwRAKmi8ovxft69ZQXAPp0
        NxqK69NuoWScC4DuXg6uijn4Mw62x/IUWmfMntwLvg==
X-Google-Smtp-Source: ABdhPJxjgt74dMqwnlL+VtqSOado4iTXu/hJhaIpCUKV4d77eCrVnjV65nNKQFkeuwmKVjJ2koqS4DBKBgoEFCPKGW8=
X-Received: by 2002:aca:2319:: with SMTP id e25mr37402844oie.164.1636876455060;
 Sat, 13 Nov 2021 23:54:15 -0800 (PST)
MIME-Version: 1.0
References: <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com> <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com> <YY7I6sgqIPubTrtA@zn.tnic> <YY7Qp8c/gTD1rT86@google.com>
 <YY7USItsMPNbuSSG@zn.tnic> <CAMkAt6o909yYq3NfRboF3U3V8k-2XGb9p_WcQuvSjOKokmMzMA@mail.gmail.com>
 <YY8AJnMo9nh3tyPB@google.com> <CAA03e5G=fY7_qESCuoHW3_VdVbDWekqQxmvLPzWNepBqJjyCXg@mail.gmail.com>
 <YZAFTBXtC/yS7xtq@google.com>
In-Reply-To: <YZAFTBXtC/yS7xtq@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Sat, 13 Nov 2021 23:54:03 -0800
Message-ID: <CAA03e5Hhmji-uhv4eh4cgyu0XBf9=C5r8MtGtWcB480eaVGvSg@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Gonda <pgonda@google.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <Michael.Roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 13, 2021 at 10:35 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Nov 12, 2021, Marc Orr wrote:
> > > > > If *it* is the host kernel, then you probably shouldn't do that -
> > > > > otherwise you just killed the host kernel on which all those guests are
> > > > > running.
> > > >
> > > > I agree, it seems better to terminate the single guest with an issue.
> > > > Rather than killing the host (and therefore all guests). So I'd
> > > > suggest even in this case we do the 'convert to shared' approach or
> > > > just outright terminate the guest.
> > > >
> > > > Are there already examples in KVM of a KVM bug in servicing a VM's
> > > > request results in a BUG/panic/oops? That seems not ideal ever.
> > >
> > > Plenty of examples.  kvm_spurious_fault() is the obvious one.  Any NULL pointer
> > > deref will lead to a BUG, etc...  And it's not just KVM, e.g. it's possible, if
> > > unlikely, for the core kernel to run into guest private memory (e.g. if the kernel
> > > botches an RMP change), and if that happens there's no guarantee that the kernel
> > > can recover.
> > >
> > > I fully agree that ideally KVM would have a better sense of self-preservation,
> > > but IMO that's an orthogonal discussion.
> >
> > I don't think we should treat the possibility of crashing the host
> > with live VMs nonchalantly. It's a big deal. Doing so has big
> > implications on the probability that any cloud vendor wil bee able to
> > deploy this code to production. And aren't cloud vendors one of the
> > main use cases for all of this confidential compute stuff? I'm
> > honestly surprised that so many people are OK with crashing the host.
>
> I'm not treating it nonchalantly, merely acknowledging that (a) some flavors of kernel
> bugs (or hardware issues!) are inherently fatal to the system, and (b) crashing the
> host may be preferable to continuing on in certain cases, e.g. if continuing on has a
> high probablity of corrupting guest data.

I disagree. Crashing the host -- and _ALL_ of its VMs (including
non-confidential VMs) -- is not preferable to crashing a single SNP
VM. Especially when that SNP VM is guaranteed to detect the memory
corruption and react accordingly.

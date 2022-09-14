Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7899F5B8D29
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 18:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiINQdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 12:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbiINQc6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 12:32:58 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903AE56BAD
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 09:32:20 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-333a4a5d495so187258887b3.10
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 09:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=TLSZ0fG4jkVsKxHaOJUp349np8FVF8YfoTMtMUTuG8A=;
        b=lYAYteHJi3IbnOFnnIGskPJm4LFXQyIlElbzGWypdvdmuOzPYj/pxEWqsuDYmXdtDT
         +J1fUhuR0nhJSF9vE2IpcB6JMQQVhOxL1FrdrpmKfq/+Pf/0NtZGKAKyIJNPCIIbB3kj
         vWi4nL+PVud7ZLGOFm7hlsQsP4WGqcGQY5y652IsMJt0X4Satpn4pwnGti6aqOjR7WNb
         b5tss/uSLmxVOvAGyxZK6jMqSNUzxkIwbjBSIb/bf0uu+j7cYjltNEAMKT0SrlRij08o
         vO6mJbmXCXzYCHWU2jM86xagKPMTdIsdFaNh0fAXa8lsKrIt9q1/gcJSJ01jSLIuS/+g
         IKcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=TLSZ0fG4jkVsKxHaOJUp349np8FVF8YfoTMtMUTuG8A=;
        b=BkR3vPYzntw+Mt1hwRnRJI2Yh6t+aSQ9rbPgpLbfFX3R5aoMcBH7d8W0FaZtanj2mV
         aZJNqhr0q87fbPqiGnaeaUzPDU707cgMQJOgRgkDpAoRqPRI+mJW51V+PckRV1/cC8PN
         DhP+iK467RxzXkkluFShYVSXP8NTkDE58CQD5ak2GlawAcCSRuEJ7Mq4Ae5botzqJWEs
         0xXcgjvK5xq4KNVkgnEk2Cu2Ty4Dajer7R3emMCPjxwZbmZ7BLtTHVT/joB2syn0TCFp
         fBgJl393ZkP+MWeQRdYr4rHPIavuw6xW27beHuqYuh2KMM+706KKFKUILBQhTzzEL5Tf
         aShg==
X-Gm-Message-State: ACgBeo2+vrTLvAwQalneQ1GKbYrK2g1LcpyCt67uOFR1N+LTXp1/0JI8
        TnJeYznCY/K5yA/958eh7ycIqfgQQEPHVFl0qRdZZQ==
X-Google-Smtp-Source: AA6agR5JyKlU4G6TTbmq/f1TwUurqwIm3Dn+pMyu//jmSXVD3ZQAN3lmbo6PGjQVmw+oTh1R9/QR0RnFraMNNxG5k98=
X-Received: by 2002:a81:7cd7:0:b0:345:221c:5671 with SMTP id
 x206-20020a817cd7000000b00345221c5671mr30574218ywc.297.1663173139128; Wed, 14
 Sep 2022 09:32:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com> <20210820155918.7518-40-brijesh.singh@amd.com>
 <YWYm/Gw8PbaAKBF0@google.com> <YWc+sRwHxEmcZZxB@google.com>
 <4e41dcff-7c7b-cf36-434a-c7732e7e8ff2@amd.com> <YWm3bOFcUSlyZjNb@google.com>
 <20220908212114.sqne7awimfwfztq7@amd.com> <YyGLXXkFCmxBfu5U@google.com>
 <CAA03e5H-V+axMiXTLXi7bf+mBs8ZMvaFZTSHSfktZDTSfu=HZQ@mail.gmail.com> <YyH+IGpBBsjfHdDC@google.com>
In-Reply-To: <YyH+IGpBBsjfHdDC@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Wed, 14 Sep 2022 17:32:08 +0100
Message-ID: <CAA03e5FndJnwSXQVg9RCvEqAsx4o52h59mBAEWatkyZHzT3T2g@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 39/45] KVM: SVM: Introduce ops for the post gfn
 map and unmap
To:     Sean Christopherson <seanjc@google.com>
Cc:     Michael Roth <michael.roth@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        Linux Memory Management List <linux-mm@kvack.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>, jarkko@profian.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 14, 2022 at 5:15 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Sep 14, 2022, Marc Orr wrote:
> > On Wed, Sep 14, 2022 at 9:05 AM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Thu, Sep 08, 2022, Michael Roth wrote:
> > > > On Fri, Oct 15, 2021 at 05:16:28PM +0000, Sean Christopherson wrote:
> > > > So in the context of this interim solution, we're trying to look for a
> > > > solution that's simple enough that it can be used reliably, without
> > > > introducing too much additional complexity into KVM. There is one
> > > > approach that seems to fit that bill, that Brijesh attempted in an
> > > > earlier version of this series (I'm not sure what exactly was the
> > > > catalyst to changing the approach, as I wasn't really in the loop at
> > > > the time, but AIUI there weren't any showstoppers there, but please
> > > > correct me if I'm missing anything):
> > > >
> > > >  - if the host is writing to a page that it thinks is supposed to be
> > > >    shared, and the guest switches it to private, we get an RMP fault
> > > >    (actually, we will get a !PRESENT fault, since as of v5 we now
> > > >    remove the mapping from the directmap as part of conversion)
> > > >  - in the host #PF handler, if we see that the page is marked private
> > > >    in the RMP table, simply switch it back to shared
> > > >  - if this was a bug on the part of the host, then the guest will see
> > >
> > > As discussed off-list, attempting to fix up RMP violations in the host #PF handler
> > > is not a viable approach.  There was also extensive discussion on-list a while back:
> > >
> > > https://lore.kernel.org/all/8a244d34-2b10-4cf8-894a-1bf12b59cf92@www.fastmail.com
> >
> > I mentioned this during Mike's talk at the micro-conference: For pages
> > mapped in by the kernel can we disallow them to be converted to
> > private?
>
> In theory, yes.  Do we want to do something like this?  No.  kmap() does something
> vaguely similar for 32-bit PAE/PSE kernels, but that's a lot of complexity and
> overhead to take on.  And this issue goes far beyond a kmap(); when the kernel gup()s
> a page, the kernel expects the pfn to be available, no exceptions (pun intended).
>
> > Note, userspace accesses are already handled by UPM.
>
> I'm confused by the UPM comment.  Isn't the gist of this thread about the ability
> to merge SNP _without_ UPM?  Or am I out in left field?

I think that was the overall gist: yes. But it's not what I was trying
to comment on :-).

HOWEVER, thinking about this more: I was confused when I wrote out my
last reply. I had thought that the issue that Michael brought up
applied even with UPM. That is, I was thinking it was still possibly
for a guest to maliciously convert a page to private mapped in by the
kernel and assumed to be shared.

But I now realize that is not what will actually happen. To be
concrete, let's assume the GHCB page. What will happen is:
- KVM has GHCB page mapped in. GHCB is always assumed to be shared. So
far so good.
- Malicious guest converts GHCB page to private (e.g., via Page State
Change request)
- Guest exits to KVM
- KVM exits to userspace VMM
- Userspace VM allocates page in private FD.

Now, what happens here depends on how UPM works. If we allow double
allocation then our host kernel is safe. However, now we have the
"double allocation problem".

If on the other hand, we deallocate the page in the shared FD, the
host kernel can segfault. And now we actually do have essentially the
same problem Michael was describing that we have without UPM. Because
we'll end up in fault.c in the kernel context and likely panic the
host.

I hope I got this right this time. Sorry for the confusion on my last reply.

> > In pseudo-code, I'm thinking something like this:
> >
> > kmap_helper() {
> >   // And all other interfaces where the kernel can map a GPA
> >   // into the kernel page tables
> >   mapped_into_kernel_mem_set[hpa] = true;
> > }
> >
> > kunmap_helper() {
> >   // And all other interfaces where the kernel can unmap a GPA
> >   // into the kernel page tables
> >   mapped_into_kernel_mem_set[hpa] = false;
> >
> >   // Except it's not this simple because we probably need ref counting
> >   // for multiple mappings. Sigh. But you get the idea.
>
> A few issues off the top of my head:
>
>   - It's not just refcounting, there would also likely need to be locking to
>     guarantee sane behavior.
>   - kmap() isn't allowed to fail and RMPUPDATE isn't strictly guaranteed to succeed,
>     which is problematic if the kernel attempts to kmap() a page that's already
>     private, especially for kmap_atomic(), which isn't allowed to sleep.
>   - Not all kernel code is well behaved and bounces through kmap(); undoubtedly
>     some of the 1200+ users of page_address() will be problematic.
>
>     $ git grep page_address | wc -l
>     1267
>   - It's not sufficient for TDX.  Merging something this complicated when we know
>     we still need UPM would be irresponsible from a maintenance perspective.
>   - KVM would need to support two separate APIs for SNP, which I very much don't
>     want to do.

Ack on merging without UPM. I wasn't trying to chime in on merging
before/after UPM. See my other comment above. Sorry for the confusion.
Ack on other concerns about "enlightening kmap" as well. I agree.

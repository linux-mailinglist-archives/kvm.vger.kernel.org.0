Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B2A7B585F
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 18:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238360AbjJBQt4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 12:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238506AbjJBQtv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 12:49:51 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70600DC
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 09:49:48 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d8153284d6eso23841680276.3
        for <kvm@vger.kernel.org>; Mon, 02 Oct 2023 09:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696265387; x=1696870187; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/NStGJqIAfzxqmZKJo1jqWKDF2/XWhgoYCwHuSutwVs=;
        b=SKvht2WuY5SteMoxDMaP1lKFglc/q4FJUKgzvElPO8pbAKi2pOsA0W3V4p6/6wXfxN
         rYFrKZbFQHbim0AlMTbPeHlbKR0eWFaTcMxfMoe4Wmj6khJOh3oZCyfL0UO2IZjQhP6X
         BEuVM13PU8YPBI8stFAktdt8DCfGg0e4GIjq6vahnWs3GehXuZvhUppTFs1FhDFzwpB4
         Qpbk4XVBrwhFp5U4yKF9QoHM0JGX5OKKc2rc/jX6WKlyl+ZHz3jXlP3qDeYOEAGEyJ3D
         e4fKddGpJevJyIGad6Qx9zS0yEhymqjvpElBJaGfa4Fi63qPOe8S3XS6hsahBWZt28AC
         cBtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696265387; x=1696870187;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/NStGJqIAfzxqmZKJo1jqWKDF2/XWhgoYCwHuSutwVs=;
        b=xKOxVBpDeuIvyMmr7zm9eRvf5EZHiEIBYvIk8CThGs0giRD5x8/Md7yqcGi8DzMcBr
         Xz9HzTbEg57N/mxfTYt4t91Swm+5nTp/TtjM2dh2Sb346gLXcll40tLDoDtJ0jtwpsja
         waFDMaWlcrLV95FEuTQNrNsi42XpB+Gqpnh/39hXsxV0u/MPZxODKO8bSJktLBnqBDTD
         rk91xwZlRrFvs3FWWeGPh4lKnIjLL38ozMNsBxCBpFSrQLW9DTqDfkMC759fZXYb4VbV
         JZr7Q4YfWk70zwV2KEIdAFwPjTindyBLWNn/ZgIE2UUA7jxal9ArTiP/0A5aW8Qf2x98
         ttFw==
X-Gm-Message-State: AOJu0Yxzvsg1aaBWe75oWI5pZ0ooRicz5KWr1Bx96LdI7S70LyR6KdK/
        2Jg0Y9ZISS1tmMLfek+ipeplMZ5y3nY=
X-Google-Smtp-Source: AGHT+IEsB5LCDJg4oleh71+UlutWTjEVI8m3tSshlzhn1JD6VtpE5PMMw65GMVMmiSbNHEOFxZtC45ZXJJk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:aa8a:0:b0:d80:eb4:9ca with SMTP id
 t10-20020a25aa8a000000b00d800eb409camr200372ybi.0.1696265387716; Mon, 02 Oct
 2023 09:49:47 -0700 (PDT)
Date:   Mon, 2 Oct 2023 09:49:45 -0700
In-Reply-To: <20231002155330.lguyhqgy64rhko4p@amd.com>
Mime-Version: 1.0
References: <20230921203331.3746712-1-seanjc@google.com> <20230921203331.3746712-7-seanjc@google.com>
 <20230922224210.6klwbphnsk5j2wft@amd.com> <ZRXGl44g8oD-FtNy@google.com> <20231002155330.lguyhqgy64rhko4p@amd.com>
Message-ID: <ZRr0qUeSVxZfK-w2@google.com>
Subject: Re: [PATCH 06/13] KVM: Disallow hugepages for incompatible gmem
 bindings, but let 'em succeed
From:   Sean Christopherson <seanjc@google.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 02, 2023, Michael Roth wrote:
> On Thu, Sep 28, 2023 at 11:31:51AM -0700, Sean Christopherson wrote:
> > On Fri, Sep 22, 2023, Michael Roth wrote:
> > > On Thu, Sep 21, 2023 at 01:33:23PM -0700, Sean Christopherson wrote:
> > > > +	/*
> > > > +	 * For simplicity, allow mapping a hugepage if and only if the entire
> > > > +	 * binding is compatible, i.e. don't bother supporting mapping interior
> > > > +	 * sub-ranges with hugepages (unless userspace comes up with a *really*
> > > > +	 * strong use case for needing hugepages within unaligned bindings).
> > > > +	 */
> > > > +	if (!IS_ALIGNED(slot->gmem.pgoff, 1ull << *max_order) ||
> > > > +	    !IS_ALIGNED(slot->npages, 1ull << *max_order))
> > > > +		*max_order = 0;
> > > 
> > > Thanks for working this in. Unfortunately on x86 the bulk of guest memory
> > > ends up getting slotted directly above legacy regions at GFN 0x100, 
> > 
> > Can you provide an example?  I'm struggling to understand what the layout actually
> > is.  I don't think it changes the story for the kernel, but it sounds like there
> > might be room for optimization in QEMU?  Or more likely, I just don't understand
> > what you're saying :-)
> 
> Here's one example, which seems to be fairly normal for an x86 boot:
> 
>   kvm_set_user_memory AddrSpace#0 Slot#0 flags=0x4 gpa=0x0 size=0x80000000 ua=0x7f24afc00000 ret=0 restricted_fd=19 restricted_offset=0x0
>   ^ QEMU creates Slot 0 for all of main guest RAM
>   kvm_set_user_memory AddrSpace#0 Slot#0 flags=0x0 gpa=0x0 size=0x0 ua=0x7f24afc00000 ret=0 restricted_fd=19 restricted_offset=0x0
>   kvm_set_user_memory AddrSpace#0 Slot#0 flags=0x4 gpa=0x0 size=0xc0000 ua=0x7f24afc00000 ret=0 restricted_fd=19 restricted_offset=0x0
>   kvm_set_user_memory AddrSpace#0 Slot#3 flags=0x6 gpa=0xc0000 size=0x20000 ua=0x7f2575000000 ret=0 restricted_fd=33 restricted_offset=0x0
>   kvm_set_user_memory AddrSpace#0 Slot#4 flags=0x6 gpa=0xe0000 size=0x20000 ua=0x7f2575400000 ret=0 restricted_fd=31 restricted_offset=0x0
>   ^ legacy regions are created and mapped on top of GPA ranges [0xc0000:0xe0000) and [0xe0000:0x100000)
>   kvm_set_user_memory AddrSpace#0 Slot#5 flags=0x4 gpa=0x100000 size=0x7ff00000 ua=0x7f24afd00000 ret=0 restricted_fd=19 restricted_offset=0x100000
>   ^ QEMU divides Slot 0 into Slot 0 at [0x0:0xc0000) and Slot 5 at [0x100000:0x80000000)
>     Both Slots still share the same backing memory allocation, so same gmem
>     fd 19 is used,but Slot 5 is assigned to offset 0x100000, whih is not
>     2M-aligned
> 
> I tried messing with QEMU handling to pad out guest_memfd offsets to 2MB
> boundaries but then the inode size needs to be enlarged to account for it
> and things get a bit messy. Not sure if there are alternative approaches
> that can be taken from userspace, but with normal malloc()'d or mmap()'d
> backing memory the kernel can still allocate a 2MB backing page for the
> [0x0:0x200000) range and I think KVM still handles that when setting up
> NPT of sub-ranges so there might not be much room for further optimization
> there.

Oooh, duh.  QEMU intentionally creates a gap for the VGA and/or BIOS holes, and
so the lower DRAM chunk that goes from the end of the system reserved chunk to
to TOLUD is started at an unaligned offset, even though 99% of the slot is properly
aligned.

Yeah, KVM definitely needs to support that.  Requiring userspace to align based
on the hugepage size could work, e.g. QEMU could divide slot 5 into N slots, to
end up with a series of slots to get from 4KiB aligned => 2MiB aligned => 1GiB
aligned.  But pushing for that would be beyond stubborn.

Thanks for being patient :-)

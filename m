Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A962F85A2
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 20:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388323AbhAOTgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 14:36:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728293AbhAOTgh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 14:36:37 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2985C061793
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 11:35:54 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id d8so9650634otq.6
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 11:35:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L6A2UzRCRt8w1pfam8I4qqQpYsRwRHB2ucWTZwYFSKQ=;
        b=lctjjCHd0mRY2yIaitglAwYI2VLnEOj7PX0bK0OAUF2luT4iEjTsICtK2KkRrobrDz
         +UMXUqT0SsGRUFWtMrnoRTv5kCN0WWPxzs5WEswE/gTHrQox0PquyzX9Ll31YnzImFzN
         som/A3BEKakMzIl+N4OImMr9U7k0W1se4y2pfU9YRY86xFGZuyVIaQJx+2yBNdAJRH2o
         8Um304ttLN0u2hpXrctJrKwoKC87rCJIj8TsmoBV/GdRxcldGOMTqLQj9f+yru66x3tS
         fTxBbX9rLrEb9EqV+QfXErsh3Bl1qN4x8EMZAMh5zyRUhkZMr4Yucb833V4S/R9lFXun
         SEJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L6A2UzRCRt8w1pfam8I4qqQpYsRwRHB2ucWTZwYFSKQ=;
        b=ecvrur/BB4HCsoSaHgmGMWSc5KHUT2ysutXDVnKkw5S6wHjiGHxa/S6i9dO7VNgEGd
         kZvRCS4d4dKmVVww0vP+63zgB+srrhvdzdmLvOkjYlaf5PHGERNGf4ahq0CXPp0p5PAB
         LzI1ewqaFdPhVnNlpiXGyHgmjI/vPoFC4+VcwVPFhYeXvAvCBgKh2t4oHVIn4KJiHIqY
         hel67Ps55nL8nU8PLm++HUzF0RnWWZLLtrFGw2gefKJrDO3emqKZGY1lKBXA6XIOPaoO
         Dk3lVPljHd/HkBVahr72xljfl3Hc+ycC97F6fbuUIt2wkKM1gGSJZ9ZOAcRoVN42UUp9
         w09Q==
X-Gm-Message-State: AOAM531/dYkk4B3F/k4/xOfxLcGmbAIidmKYl7hFAC7z4j50wOCBJFfj
        wcj8y3ga/SkMfi2WZ1tRE2JHWZpE8SumGQDucL/rvg==
X-Google-Smtp-Source: ABdhPJz6/ji210QtYTzusmDKOUSnUYJNxbMjIE8TQfSbsP9cr+trdik/Pj8x6e+RFKb3K+ufVbrmYs2Nx2IqGa4wwjw=
X-Received: by 2002:a9d:5f9a:: with SMTP id g26mr9622406oti.241.1610739354185;
 Fri, 15 Jan 2021 11:35:54 -0800 (PST)
MIME-Version: 1.0
References: <20200710154811.418214-1-mgamal@redhat.com> <20200710154811.418214-8-mgamal@redhat.com>
 <CALMp9eSbY6FjZAXt7ojQrX_SC_Lyg24dTGFZdKZK7fARGA=3hg@mail.gmail.com>
 <CALMp9eTFzQMpsrGhN4uJxyUHMKd5=yFwxLoBy==2BTHwmv_UGQ@mail.gmail.com>
 <20201023031433.GF23681@linux.intel.com> <498cfe12-f3e4-c4a2-f36b-159ccc10cdc4@redhat.com>
 <CALMp9eQ8C0pp5yP4tLsckVWq=j3Xb=e4M7UVZz67+pngaXJJUw@mail.gmail.com>
 <f40e5d23-88b6-01c0-60f9-5419dac703a2@redhat.com> <CALMp9eRGBiQDPr1wpAY34V=T6Jjij_iuHOX+_-QQPP=5SEw3GQ@mail.gmail.com>
 <4463f391-0a25-017e-f913-69c297e13c5e@redhat.com>
In-Reply-To: <4463f391-0a25-017e-f913-69c297e13c5e@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 15 Jan 2021 11:35:42 -0800
Message-ID: <CALMp9eRnjdJtmU9bBosGNAxa2pvMzB8mHjtbYa-yb2uNoAkgdA@mail.gmail.com>
Subject: Re: [PATCH v3 7/9] KVM: VMX: Add guest physical address check in EPT
 violation and misconfig
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Mohammed Gamal <mgamal@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 23, 2020 at 10:43 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 23/10/20 19:23, Jim Mattson wrote:
> >> The information that we need is _not_ that provided by the advanced
> >> VM-exit information (or by a page walk).  If a page is neither writable
> >> nor executable, the advanced information doesn't say if the injected #PF
> >> should be a W=1 or a F=1 fault.  We need the information in bits 0..2 of
> >> the exit qualification for the final access, which however is not
> >> available for the paging-structure access.
> >>
> > Are you planning to extend the emulator, then, to support all
> > instructions? I'm not sure where you are going with this.
>
> I'm going to fix the bit 8=1 case, but for bit 8=0 there's not much that
> you can do.  In all likelihood the guest is buggy anyway.

Did this drop off your radar? Are you still planning to fix the bit8=1
case to use advanced EPT exit qualification information? Or did I just
miss it?

> It would be possible to only do the decode part of the emulator to get
> the PFEC (matching the GVA from the vmexit to the memory operand, for
> example, and retrying if the instruction is unexpected).  Then one would
> only need enough VEX/EVEX parsing to process the decoding.
>
> Paolo
>

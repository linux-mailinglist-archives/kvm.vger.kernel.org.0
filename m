Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2ADC4E1AEF
	for <lists+kvm@lfdr.de>; Sun, 20 Mar 2022 10:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240594AbiCTJsX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Mar 2022 05:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236014AbiCTJsW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Mar 2022 05:48:22 -0400
Received: from twosheds.infradead.org (unknown [IPv6:2001:8b0:10b:1:aaa1:59ff:fe2f:55f7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 815E84B1E1
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 02:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=twosheds.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Cc:To:From:Subject:Date:References:In-Reply-To:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=ONQGFbN48ZFUljxo9kGDnwnkAvX8Pt785Sac58aV6Dk=; b=O4QL41kNLalK+cTbk9ajme73C5
        0uT6eNhTu2eZ59a8jDjSBaJdSxuLZxMqdpupa4mFGmRZ4/0MCBxZXxeW/wDzco6qp8wojWdmfpUua
        OTUrvViXC7KseFN1RnyPtyQuD/D2wwT0IICB0zLAgX4zEimKyS5pb3A5Sd9s++gkLLLFwQ2h2zZ+n
        OiMO77wwRJm+kxz5CyYEO79CSC0WiHkLpu7rs6oSpZOcUqnLiH7EkiRYnfGhlpMTZEAQ/tVAdDPpW
        iGigZmXSUPLk4P25MOrdNudbxc07ZmpJ38I7OP1RFGJ8dksnd7sbfSxzYIYxR7WJWATuGopC5KvFU
        fE5ecrQg==;
Received: from localhost ([127.0.0.1] helo=twosheds.infradead.org)
        by twosheds.infradead.org with esmtp (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nVs8x-008Xnk-DM; Sun, 20 Mar 2022 09:46:35 +0000
Received: from 2a01:4c8:1091:2e98:1:1:292f:7a40
        (SquirrelMail authenticated user dwmw2)
        by twosheds.infradead.org with HTTP;
        Sun, 20 Mar 2022 09:46:35 -0000
Message-ID: <1680281fee4384d27bd97dba117f391a.squirrel@twosheds.infradead.org>
In-Reply-To: <YjbrOz+yT4R7FaX1@google.com>
References: <20220316045308.2313184-1-oupton@google.com>
    <34ccef81-fe54-a3fc-0ba9-06189b2c1d33@redhat.com>
    <YjTRyssYQhbxeNHA@google.com>
    <0bff64ae-0420-2f69-10ba-78b9c5ac7b81@redhat.com>
    <YjWNfQThS4URRMZC@google.com>
    <e48bc11a5c4b0864616686cb1365dfb4c11b5b61.camel@infradead.org>
    <a6011bed-79b4-72ab-843c-315bf3fcf51e@redhat.com>
    <3548e754-28ae-f6c4-5d4c-c316ae6fbbb0@redhat.com>
    <100b54469a8d59976bbd96f50dd4cd33.squirrel@twosheds.infradead.org>
    <9ca10e3a-cd99-714a-76ad-6f1b83bb0abf@redhat.com>
    <YjbrOz+yT4R7FaX1@google.com>
Date:   Sun, 20 Mar 2022 09:46:35 -0000
Subject: Re: [PATCH] Documentation: KVM: Describe guest TSC scaling in
 migration algorithm
From:   "David Woodhouse" <dwmw2@infradead.org>
To:     "Oliver Upton" <oupton@google.com>
Cc:     "Paolo Bonzini" <pbonzini@redhat.com>,
        "David Woodhouse" <dwmw2@infradead.org>, kvm@vger.kernel.org,
        "Sean Christopherson" <seanjc@google.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        "Wanpeng Li" <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>
User-Agent: SquirrelMail/1.4.23 [SVN]-7.fc34.20220108
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by twosheds.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RDNS_NONE,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> The offset interface completely punts the decision around guest clocks
> to userspace. We (KVM) have absolutely no idea what userspace is about
> to do with the guest. The guest could be paused for 5 seconds or 5
> years. Encouraging host userspace to just read/write a { TOD, TSC } pair
> and let KVM do the heavy lifting could completely wreck the guest's
> monotonic clock.
>
> Additionally, it is impossible for userspace to enforce policy/limits on
> how much to time travel a guest with a value-based interface. Any event
> could sneak in between the time userspace checks the value and KVM sets
> the L1 offset. Offsets are idempotent and will still uphold userspace's
> intentions even if an inordinate amount of time elapses until KVM
> processes it.

Thanks for the detailed explanation. One part which confuses me here...
Why can't userspace impose those same limits using a (TOD, value) tuple?
Userspace can still look at that TOD from before the brownout period
started, and declare that is too far in the past.

If the event happens *after* userspace has decided that the migration was
quick enough, but before the vCPUs are actually running again, even the
offset based interface doesn't protect against that.


> Apologies for grandstanding, but clocks has been a real source of pain
> during migration. I do agree that the documented algorithm is a mess at
> the moment, given that there's no good way for userspace to transform
> host_tsc -> guest_tsc. Poking the host TSC frequency out in sysfs is
> nice to have, but probably not ABI to hang this whole thing off of.
>
> What do you folks think about having a new R/O vCPU attribute that
> returns a { TOD, guest_tsc } pair? I believe that would immediately
> satisfy the needs of upstream to implement clock-advancing live
> migration.

Hm, I need to do some more thinking here. I poked at this because for TSC
scaling even before we think about clock jumps it was just utterly hosed —
userspace naively just creates a bunch of vCPUs and sets their TSC
frequency + value, and they all end up with unsynced TSC values.

But coincidentally since then I have started having conversations with
people who really want the guest to have an immediate knowledge of the
adjtimex maxerror etc. on the new host immediately after the migration.
Maybe the "if the migration isn't fast enough then let the guest know it's
now unsynced" is OK, but I'll need to work out what "immediately" means
when we have a guest userspace component involved in it.

I'll need to do that with a real screen and keyboard though, and fingers
that aren't freezing as I sit by a 9-year-old's hockey training...

-- 
dwmw2


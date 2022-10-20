Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3031606667
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 18:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbiJTQ6s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 12:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbiJTQ6r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 12:58:47 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E9219ABD0
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:58:46 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id 204so98060pfx.10
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8935ZvtZiRbZjYV7d1qMgPT7v+s2zf9y7IQuLogoWZQ=;
        b=kcFnpMz5ME7R9lYIvj98Oo1cJwe/en+7NlHtnOOSQy+HvIzwsrwTGWhkFcxoT5juo1
         Y0eZAuXN4C+AFwCG9dx3V0RzRiZlQJtATauhkTBgLxBVeT6q4NHjvV9rZ1ICGIXnfTj5
         Z/0RBh096GAMMFuIJ8p86pLk2d+c2T4TN7OuG/OGKdopOF7K5mONZuHlI5zu0Ock9sr4
         Ha5N9rqCCmDSlH8jNuktMM11iJbPKQ5ApETu3lgH1GNT53D4J0+KYJaRZRY/ICgFhT4k
         JnZPOzGDzx7KgJk7Wjqf0n8Fqjxo6MvHhWjk5TXbIWSWOM6liB2ZCh3q+e4dNIV2IxiN
         tt9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8935ZvtZiRbZjYV7d1qMgPT7v+s2zf9y7IQuLogoWZQ=;
        b=Rmff2Tsp+p4Sz3u4QVuVaDcFHu3Ab5tsc1gJPNSKbw4kN/FqMWzYHyD/QcXqM5Uv0K
         jwiB0kYZQSPBUKwAfj/cBHKUTp3xdZYlZo3xxBl2nfuTP8fZlmRgSboCA2DXKOYrlJVj
         UuSxL/QNVqgsJ+skThkzhurmqCFvXSinTVrqtH4WgRGVsBdSxLDU4ku9ix6KgXCz8Mn8
         SHb+LK2Ck200ofe0RqUnnyRr82wYf8USxNhcF9r2JYX5sDyt+LpChK3XMOeW13OismTs
         Ly2b5F2lpC3beaM/BBUA3ZLtHcT24Zh3oDoNJwggeCSEKBarSazCngFndl21mu9Rphra
         OpIw==
X-Gm-Message-State: ACrzQf12rvF322ITv4E+6GXieSoWkqzqwBLDB8hUVqn0ZRX1RMW6sIXG
        oHUbR3bMFGhrk904t13DnuLeFQ==
X-Google-Smtp-Source: AMsMyM5by8ljg8Uhs3fMduuZ/I4VL7G/YtVMvmWxRmdkK/ou5MinXBKnsNlj92EomREt0rfJuTPkDQ==
X-Received: by 2002:a63:6905:0:b0:43c:d4:eef4 with SMTP id e5-20020a636905000000b0043c00d4eef4mr12264795pgc.126.1666285125636;
        Thu, 20 Oct 2022 09:58:45 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h3-20020aa796c3000000b0055fc0a132aasm13948176pfq.92.2022.10.20.09.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 09:58:45 -0700 (PDT)
Date:   Thu, 20 Oct 2022 16:58:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 8/8] KVM: x86: Fix NULL pointer dereference in
 kvm_xen_set_evtchn_fast()
Message-ID: <Y1F+QdQglodavC1V@google.com>
References: <YySujDJN2Wm3ivi/@google.com>
 <20220921020140.3240092-1-mhal@rbox.co>
 <20220921020140.3240092-9-mhal@rbox.co>
 <Y0SquPNxS5AOGcDP@google.com>
 <Y0daPIFwmosxV/NO@google.com>
 <Y0h0/x3Fvn17zVt6@google.com>
 <0574dd3d-4272-fc93-50c0-ba2994e272ba@rbox.co>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0574dd3d-4272-fc93-50c0-ba2994e272ba@rbox.co>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 20, 2022, Michal Luczaj wrote:
> On 10/13/22 22:28, Sean Christopherson wrote:
> > On Thu, Oct 13, 2022, Sean Christopherson wrote:
> >> On Mon, Oct 10, 2022, Sean Christopherson wrote:
> >>> On Wed, Sep 21, 2022, Michal Luczaj wrote:
> >>> If this fixes things on your end (I'll properly test tomorrow too), I'll post a
> >>> v2 of the entire series.  There are some cleanups that can be done on top, e.g.
> >>> I think we should drop kvm_gpc_unmap() entirely until there's actually a user,
> >>> because it's not at all obvious that it's (a) necessary and (b) has desirable
> >>> behavior.
> >>
> >> Sorry for the delay, I initially missed that you included a selftest for the race
> >> in the original RFC.  The kernel is no longer exploding, but the test is intermittently
> >> soft hanging waiting for the "IRQ".  I'll debug and hopefully post tomorrow.
> > 
> > Ended up being a test bug (technically).  KVM drops the timer IRQ if the shared
> > info page is invalid.  As annoying as that is, there's isn't really a better
> > option, and invalidating a shared page while vCPUs are running really is a VMM
> > bug.
> > 
> > To fix, I added an intermediate stage in the test that re-arms the timer if the
> > IRQ doesn't arrive in a reasonable amount of time.
> > 
> > Patches incoming...
> 
> Sorry for the late reply, I was away.
> Thank you for the whole v2 series. And I'm glad you've found my testcase
> useful, even if a bit buggy ;)
> 
> Speaking about SCHEDOP_poll, are XEN vmcalls considered trusted?

I highly doubt they are trusted.

> I've noticed that kvm_xen_schedop_poll() fetches guest-provided
> sched_poll.ports without checking if the values are sane. Then, in
> wait_pending_event(), there's test_bit(ports[i], pending_bits) which
> (for some high ports[i] values) results in KASAN complaining about
> "use-after-free":
> 
> [   36.463417] ==================================================================
> [   36.463564] BUG: KASAN: use-after-free in kvm_xen_hypercall+0xf39/0x1110 [kvm]

...

> I can't reproduce it under non-KASAN build, I'm not sure what's going on.

KASAN is rightly complaining because, as you already pointed out, the high ports[i]
value will touch memory well beyond the shinfo->evtchn_pending array.  Non-KASAN
builds don't have visible failures because the rogue access is only a read, and
the result of the test_bit() only affects whether or not KVM temporarily stalls
the vCPU.  In other words, KVM is leaking host state to the guest, but there is
no memory corruption and no functional impact on the guest.

I think this would be the way to fix this particular mess?

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 93c628d3e3a9..5d09a47db732 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -961,7 +961,9 @@ static bool wait_pending_event(struct kvm_vcpu *vcpu, int nr_ports,
        struct kvm *kvm = vcpu->kvm;
        struct gfn_to_pfn_cache *gpc = &kvm->arch.xen.shinfo_cache;
        unsigned long *pending_bits;
+       unsigned long nr_bits;
        unsigned long flags;
+       evtchn_port_t port;
        bool ret = true;
        int idx, i;
 
@@ -974,13 +976,19 @@ static bool wait_pending_event(struct kvm_vcpu *vcpu, int nr_ports,
        if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode) {
                struct shared_info *shinfo = gpc->khva;
                pending_bits = (unsigned long *)&shinfo->evtchn_pending;
+               nr_bits = sizeof(shinfo->evtchn_pending) * BITS_PER_BYTE;
        } else {
                struct compat_shared_info *shinfo = gpc->khva;
                pending_bits = (unsigned long *)&shinfo->evtchn_pending;
+               nr_bits = sizeof(shinfo->evtchn_pending) * BITS_PER_BYTE;
        }
 
        for (i = 0; i < nr_ports; i++) {
-               if (test_bit(ports[i], pending_bits)) {
+               port = ports[i];
+               if (port >= nr_bits)
+                       continue;
+
+               if (test_bit(array_index_nospec(port, nr_bits), pending_bits)) {
                        ret = true;
                        break;
                }


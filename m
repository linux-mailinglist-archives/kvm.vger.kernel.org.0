Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A47A4E1E84
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 01:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343939AbiCUAjv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Mar 2022 20:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbiCUAju (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Mar 2022 20:39:50 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31F734BA2
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 17:38:26 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id b16so15187717ioz.3
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 17:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=widVsuh/CTpcZz844G5yvPtGn0Sviz1m3Tr6JzrSjVU=;
        b=XudWOgJb03XSXyjSSmVvMhLkhqYCcubg8sJJsF2JNOPxnplrj4AIwmTM6zL/Qv3GrH
         C3E9GDCFbb302naKXDzc94A5VgIp0Rp+WKv6uTEMbOD6bM3rpGp+XqUSPbldGD0ZaNzG
         8luuqxnlgZr+CEJg5TqPBtdM4sVac8ISEkyYPLCBh1H8GyBOtFWhKsIHukeJW5c9N5sI
         rRGOoNP15SzBcyla4VhK150mOEE/z3jvLCJ4rsv7UJhqENN30aRYMj6hMehhpjUSUVDB
         r2DCLyOrAPQlfFswg/+mH8bgwuiXvRlyn8nfVsPNAKCC6qTU4d5HvVSmbQjotZpgu36e
         kfpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=widVsuh/CTpcZz844G5yvPtGn0Sviz1m3Tr6JzrSjVU=;
        b=DqkfTK39KPHwGp0VEli5x5nCydDcyDnFlpqqKr6PlsI24vkCEU5l9G67ldI7PZ90Ey
         8t/zFsVqQILAjJtLKwCUdl40GV/gCI2NHI4olal/4W2NhPImfrzBTTSjO06KaV/lHX7Z
         wZqJHNGcfYLWEGgj5ZaZcKmumilxrI1PYsBdit2Mw9yM9ucUxFPUZWucyPk48xujl41k
         94QiWbCsYh1LMNlbBgL2634QO7fExk0cd4Kgnrkpa41S7LLG7PZ73OQFUOAz9hyQQh58
         ZOAVZbvtExPxc1WS7GHCMUN2GACGZYajfLrBpbL9c3WNo+iC3wt1oq4k6y9A2wtPaoGC
         edCA==
X-Gm-Message-State: AOAM531qAd1O49gaosFzOP+ez37VppPSzKVnbHLTKArNl1yInl9N3Irv
        UEcXn9CdU67wY8zarhppwwI7jA==
X-Google-Smtp-Source: ABdhPJwoaEXo2+gOGSY7/1rA4Ji5Tb12RkKATmGUO2l4Q1XXTSH/unQ8O0K+slwSbfx/WfBdvHYKqg==
X-Received: by 2002:a5d:8796:0:b0:645:bd36:3833 with SMTP id f22-20020a5d8796000000b00645bd363833mr8848971ion.158.1647823105836;
        Sun, 20 Mar 2022 17:38:25 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id a8-20020a923308000000b002c268520d16sm8384500ilf.22.2022.03.20.17.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Mar 2022 17:38:25 -0700 (PDT)
Date:   Mon, 21 Mar 2022 00:38:21 +0000
From:   Oliver Upton <oupton@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] Documentation: KVM: Describe guest TSC scaling in
 migration algorithm
Message-ID: <YjfI/Sl3lFEFOIWc@google.com>
References: <YjTRyssYQhbxeNHA@google.com>
 <0bff64ae-0420-2f69-10ba-78b9c5ac7b81@redhat.com>
 <YjWNfQThS4URRMZC@google.com>
 <e48bc11a5c4b0864616686cb1365dfb4c11b5b61.camel@infradead.org>
 <a6011bed-79b4-72ab-843c-315bf3fcf51e@redhat.com>
 <3548e754-28ae-f6c4-5d4c-c316ae6fbbb0@redhat.com>
 <100b54469a8d59976bbd96f50dd4cd33.squirrel@twosheds.infradead.org>
 <9ca10e3a-cd99-714a-76ad-6f1b83bb0abf@redhat.com>
 <YjbrOz+yT4R7FaX1@google.com>
 <1680281fee4384d27bd97dba117f391a.squirrel@twosheds.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1680281fee4384d27bd97dba117f391a.squirrel@twosheds.infradead.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 20, 2022 at 09:46:35AM -0000, David Woodhouse wrote:
> 
> > The offset interface completely punts the decision around guest clocks
> > to userspace. We (KVM) have absolutely no idea what userspace is about
> > to do with the guest. The guest could be paused for 5 seconds or 5
> > years. Encouraging host userspace to just read/write a { TOD, TSC } pair
> > and let KVM do the heavy lifting could completely wreck the guest's
> > monotonic clock.
> >
> > Additionally, it is impossible for userspace to enforce policy/limits on
> > how much to time travel a guest with a value-based interface. Any event
> > could sneak in between the time userspace checks the value and KVM sets
> > the L1 offset. Offsets are idempotent and will still uphold userspace's
> > intentions even if an inordinate amount of time elapses until KVM
> > processes it.
> 
> Thanks for the detailed explanation. One part which confuses me here...
> Why can't userspace impose those same limits using a (TOD, value) tuple?
> Userspace can still look at that TOD from before the brownout period
> started, and declare that is too far in the past.
> 
> If the event happens *after* userspace has decided that the migration was
> quick enough, but before the vCPUs are actually running again, even the
> offset based interface doesn't protect against that.

Right, if nastiness happens after the offset was calculated, the guest
is still going to feel it. The benefit is that we've at least stopped
the bleeding on the monotonic clock. Guests of KVM are probably happier
having a messed up realtime clock instead of a panicked kernel that
threw a fit over monotonic stepping too far.

> > Apologies for grandstanding, but clocks has been a real source of pain
> > during migration. I do agree that the documented algorithm is a mess at
> > the moment, given that there's no good way for userspace to transform
> > host_tsc -> guest_tsc. Poking the host TSC frequency out in sysfs is
> > nice to have, but probably not ABI to hang this whole thing off of.
> >
> > What do you folks think about having a new R/O vCPU attribute that
> > returns a { TOD, guest_tsc } pair? I believe that would immediately
> > satisfy the needs of upstream to implement clock-advancing live
> > migration.
> 
> Hm, I need to do some more thinking here. I poked at this because for TSC
> scaling even before we think about clock jumps it was just utterly hosed —
> userspace naively just creates a bunch of vCPUs and sets their TSC
> frequency + value, and they all end up with unsynced TSC values.

And thank you for addressing that. I think there is a broader
generalization that can be made about guest timekeeping that you've
started poking at with that patch set, which is that we should only
really care about these at a VM scope. There's nothing we can do
to cover up broken hardware, so if the host's TSCs are out of whack then
oh well.

To that end, we could have a single host<->guest offset that is used
across all vCPUs. Guest fiddling with TSC_ADJUST or even worse direct
writes to the TSC can then be treated as solely a part of guest state,
and get added on top of the host<->guest offset.

> But coincidentally since then I have started having conversations with
> people who really want the guest to have an immediate knowledge of the
> adjtimex maxerror etc. on the new host immediately after the migration.
> Maybe the "if the migration isn't fast enough then let the guest know it's
> now unsynced" is OK, but I'll need to work out what "immediately" means
> when we have a guest userspace component involved in it.

This has also been an area of interest to me. I think we've all seen the
many ways in which doing migrations behind the guest's can put software
in an extremely undesirable state on the other end. If those
conversations are taking place on the mailing lists, could you please CC
me?

Our (Google) TSC adjustment clamping and userspace notification mechanism
was a halfway kludge to keep things happy on the other end. And it
generally has worked well, but misses a fundamental point.

The hypervisor should tell the guest kernel about time travel and let it
cascade that information throughout the guest system. Regardless of what
we do to the TSC, we invariably destroy one of the two guest clocks along
the way. If we told the guest "you time traveled X seconds", it could
fold that into its own idea of real time. Guest kernel can then fire off
events to inform software that wants to keep up with clock changes, and
even a new event to let NTP know its probably running on different
hardware.

Time sucks :-)

--
Thanks,
Oliver

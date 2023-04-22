Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D64D6EB6B4
	for <lists+kvm@lfdr.de>; Sat, 22 Apr 2023 03:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbjDVBuq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 21:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjDVBun (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 21:50:43 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB033C0B
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 18:50:42 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-b8f6269ad66so4308899276.1
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 18:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682128241; x=1684720241;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+ZpCuuwL5CiHwf0V2L320v5NReoRv4sFrEiCLQFLVHU=;
        b=f8aqJFKksnFDTpfT7mAsIcRbqwuB7dbcVU3w5aY0BUCSwMDAor9YOo5PKFihZ6Ofy1
         6SKpgKkLFHpqtBn6eq2+v6iYoEvBHCbbQcFVkyU5pgVEFyfQAm0AiOb8feinxAS2eOXl
         HFCEKoDlE1YhBQg4+cSL+It088jY9YC2KHuUifcQoC/zIIlN6wDtPYRQCSeUEM+O+IVM
         VqzfjeVUFkunkbIFhp9iYd81Hd55x/9Gb9O91cdxBIe+oMDZSyotJRd/MiegE/YPWKNj
         DFwmXwSE0+SEDN+umu/gfE4gjRQzhQuhyHpQqs1YcX2BajSu+rQ/VifJ/CB+r4d4XDvn
         tjDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682128241; x=1684720241;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+ZpCuuwL5CiHwf0V2L320v5NReoRv4sFrEiCLQFLVHU=;
        b=BDIaoDARLroAW2YlzfCIqy7ZpRx8oY6c/P+TlZfPRAHMXzL+3IUKkKR3Hnf3BaQPeK
         aBkOy/2OrEqnjq/N+b/+z/PQymiSit/S0T4xdAyJdfOw7OAz8vz7Aj/gpirz9kXCB7/h
         O5vwJ2bbTcQDPHFHAu8hsIGw9QVtYKL6zkRhIjWy/B23Wz3LEKqOOoOdwlxJKmmKy4oB
         VvnbSrBm8eXear67hyNB0Ese6JuAP4/xDv7uDaRhT9fGpDWKQVS8HXGn92Yvku2WMWc/
         aBRx2P7EdScb6lqMEBmAVRHqVER2PeJdg8oJ7732vH/iZKlbn6YochOJqFQsRmHbHIWV
         E5DQ==
X-Gm-Message-State: AAQBX9eT2Kn6HSGj64v4BvD0mK6xIOVadqTyytaH4HNLbE5rC9PMnsR4
        AXlTaHyb7nbh+DJTfy/+MDNfp4TOXE0=
X-Google-Smtp-Source: AKy350arJc7/XHyKuHZgjSbzsUXnwm9/8TWbi0IHEcBRvBdbahS9kkw01OC7GeuQcEkj6Qfth9or7hnOelU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d78c:0:b0:b8b:eea7:525e with SMTP id
 o134-20020a25d78c000000b00b8beea7525emr2833867ybg.5.1682128241485; Fri, 21
 Apr 2023 18:50:41 -0700 (PDT)
Date:   Fri, 21 Apr 2023 18:50:39 -0700
In-Reply-To: <100c4e47-9d8d-8b3a-b70b-c0498febf23c@redhat.com>
Mime-Version: 1.0
References: <ZELftWeNUF1Dqs3f@linux.dev> <100c4e47-9d8d-8b3a-b70b-c0498febf23c@redhat.com>
Message-ID: <ZEM9b13OTjq9+4ZY@google.com>
Subject: Re: Getting the kvm-riscv tree in next
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 22, 2023, Paolo Bonzini wrote:
> On 4/21/23 21:10, Oliver Upton wrote:
> > I've also noticed that for the past few kernel release cycles you've
> > used an extremely late rc (i.e. -rc7 or -rc8), which I fear only
> > draws more scrutiny.
> 
> Heh, I just wrote the same thing to Anup.  In particular, having kvm-riscv
> in next (either directly or by sending early pull requests to me) would have
> helped me understand the conflicts between the core and KVM trees for
> RISC-V, because Stephen Rothwell would have alerted me about them.

Speaking of not-early pull requests, I'm not going to get the x86 pull requests
sent until Monday.  Everything has been in place for a few weeks now, but I buried
myself too deep in UPM/restrictedmem stuff and ran out of time today (and I don't
trust my brain to not make stupid mistakes at this point).

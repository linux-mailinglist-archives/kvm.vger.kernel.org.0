Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B61877CF5A
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 17:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236014AbjHOPk4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 11:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238195AbjHOPkk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 11:40:40 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FE7172A
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 08:40:33 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-589e3ac6d76so40498247b3.1
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 08:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692114033; x=1692718833;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DkqPfyTuN5Y84MSYp5WDrp4NhwpHYJuziuRrHuQEYHA=;
        b=Q1fVRdWnoGe8VhwQFwEbYpEUTJwmUQyaHjSsyZynarhEDCmLG3FRW/0Fapeu++jUdC
         z5IIZnJnTWE3lpthJXMcw8DTJQT0ikJId/mqf9AgBWLAolLceJQK6Zg1uSDBImk8rH/D
         x7J+KI30ZeHDtuNv5cwonAn9jPgwxO2Wdsuks8h+E7s7C5yOS8aXysYAQ0hgO5C4vZ4T
         tdXhMp9vWeLAD7/gjTylpAp1dx/JzqVzeL+JE7/SsGo8RVhzegqxEVxrhoeLLUbrHjyR
         z9XAYJZ9bGWr7KkZLp2XCiDmsUrxsYAaunX41jQLxv+rux/BvP1mrVhXL5xHiuf/SYdp
         +Qdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692114033; x=1692718833;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DkqPfyTuN5Y84MSYp5WDrp4NhwpHYJuziuRrHuQEYHA=;
        b=LGs8v+9ee5PWMcftKE9q2RiKc2utfR+H5HD7Hjlb2PjUbZeQYPy4q00yW2Yqtau7C/
         JKYnmFnAIfut6Cd/Y4PgfN/QRjL6b3trrCQ4QPkr9fKwJ28wLJsPtU/S8zFCeh1SB+a3
         9dyy3XAOZHz2v9ZXH+UGg08dIYdqkVxj3IYqNSTlYIHiyrPK33WsKx/MtwquMhG15YWj
         ZlcssFOSC5T4QC8OA6RnFQTOU/NSZeLK82uk9w/CCejSZC1bQJ7B3EMbUkFPRWnDubWQ
         6Mg//AXCdyn9R6LXaUwlGIK2JsDQD3h81I5DCXPHb+CJPykht8WwGCjF1DBhCN8+Pyma
         rltA==
X-Gm-Message-State: AOJu0Yzuq4Mm83ysC6QbWIK8wc2/o8SmvNzb8TMxcxiF0baAzf0LDgWl
        OZwUYEoGq+sVESiBLygIJoFwaoYQPC8=
X-Google-Smtp-Source: AGHT+IHB3sonpGN/+tnipgCOUt5hWvztUjPvJTHLFo/+JuaJcTBPMW7FDJeVytbuM0VDOd5Bx3dGCe1el5I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:4291:0:b0:d47:5cc3:9917 with SMTP id
 p139-20020a254291000000b00d475cc39917mr168695yba.9.1692114032911; Tue, 15 Aug
 2023 08:40:32 -0700 (PDT)
Date:   Tue, 15 Aug 2023 08:40:31 -0700
In-Reply-To: <2c823911-4712-4d06-bfb5-e6ee3f7023a7@rbox.co>
Mime-Version: 1.0
References: <20230728001606.2275586-1-mhal@rbox.co> <169100872740.1737125.14417847751002571677.b4-ty@google.com>
 <ZNrLYOiQuImD1g8A@google.com> <2c823911-4712-4d06-bfb5-e6ee3f7023a7@rbox.co>
Message-ID: <ZNucb6NQ6ozi1vqz@google.com>
Subject: Re: [PATCH 0/2] sync_regs() TOCTOU issues
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, shuah@kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 15, 2023, Michal Luczaj wrote:
> On 8/15/23 02:48, Sean Christopherson wrote:
> > ...
> > Argh, apparently I didn't run these on AMD.  The exception injection test hangs
> > because the vCPU hits triple fault shutdown, and because the VMCB is technically
> > undefined on shutdown, KVM synthesizes INIT.  That starts the vCPU at the reset
> > vector and it happily fetches zeroes util being killed.
> 
> Thank you for getting this. I should have mentioned, due to lack of access to
> AMD hardware, I've only tested on Intel.
> 
> > @@ -115,6 +116,7 @@ static void *race_events_exc(void *arg)
> >  	for (;;) {
> >  		WRITE_ONCE(run->kvm_dirty_regs, KVM_SYNC_X86_EVENTS);
> >  		WRITE_ONCE(events->flags, 0);
> > +		WRITE_ONCE(events->exception.nr, GP_VECTOR);
> >  		WRITE_ONCE(events->exception.pending, 1);
> >  		WRITE_ONCE(events->exception.nr, 255);
> 
> Here you're setting events->exception.nr twice. Is it deliberate?

Heh, yes and no.  It's partly leftover from a brief attempt to gracefully eat the
fault in the guest.

However, unless there's magic I'm missing, race_events_exc() needs to set a "good"
vector in every iteration, otherwise only the first iteration will be able to hit
the "check good, consume bad" scenario.

For race_events_inj_pen(), it should be sufficient to set the vector just once,
outside of the loop.  I do think it should be explicitly set, as subtly relying
on '0' being a valid exception is a bit mean (though it does work).

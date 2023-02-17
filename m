Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603E869B108
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 17:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbjBQQfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 11:35:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjBQQfj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 11:35:39 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6832F270F
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 08:35:38 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id g6-20020a17090a3c8600b002368c5a30bdso349602pjc.5
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 08:35:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2xwV8QwiJ8aWQ8hwiGkNwOehUthYfx2IQNg1I6DFbnw=;
        b=VYlQvn5C9YWZ+nMlDfKWs9SHOaXFAcn4vRz4TrBrlccFaB2rFVlnD9yOk1ux6NVAUR
         sRc3SCKHH+pFBJ7HXijef2ZY+GOarFuncXmW5suU5PMfO2r2/V4B6a12IVkR9k0NN2Bg
         zVTNAmuwxIwh0qR08MP3l4QfBRimWXy3o5pFsMDpre7ljOC2p2F87paCrX/887ga+TZa
         HVMfv4BbxbLfxfzhNuQvFyKpIPqP0jYjnvID1h6XovLWFsCZM6JBMMcIMZVJMsXg+tzp
         6qFydczmCYvbFpYfZZZQrirb7W15bU6BBCEEVNs5xFQygkKrkXUCIa0NrNk2fNQWdJcS
         z6Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2xwV8QwiJ8aWQ8hwiGkNwOehUthYfx2IQNg1I6DFbnw=;
        b=XymM9uC+0vn2FbtX/T1uO9Z3OCylqP1bpY0VpF/sOiP6fKlj/5mTaqDSEGO/SSEK0f
         BqqYBYFSdDdsOSU6BlKtCOAicI9W85sZB44wrx52l0SrpkkbStl1Ui23so0QPAEoloEq
         q4fxkqmiTQb0d6eedG3DX/e1mZc06emsG3JOJ2066KBDVAq9J2TyAYZw/m/zjvq6WseL
         felBfm98PaLIz38s6kG/yGLk6JCpRGm6gytTPnQkh+feUFJVPjncp4QXVqYJ1ln/dL65
         W6Oys6huWbOjoq8MzhC+qMZR8rOxgvYcV+XNkItYKO69rJ5CqFMSp5qFuQPZfxh1ouP9
         rfsQ==
X-Gm-Message-State: AO0yUKUPUjuSyZpyU79h/aKn9ommectotYMRXs/rXULt7SO36xYzj/gm
        UNJJgeTu0WqYV7k/pWbYLlzSf8NlmR4=
X-Google-Smtp-Source: AK7set+SPIdreQ0xICBrX5EUbbO9bo4w9lh0o4BHZKmVvfdc5VCXtXgeq7oDdMKWjVlPSAxdJzvZZ6yXwbo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:3247:b0:194:6fc1:801f with SMTP id
 ji7-20020a170903324700b001946fc1801fmr270489plb.6.1676651737851; Fri, 17 Feb
 2023 08:35:37 -0800 (PST)
Date:   Fri, 17 Feb 2023 08:35:36 -0800
In-Reply-To: <2c2f77a3-1d77-0d88-991a-60dcdc370ea8@grsecurity.net>
Mime-Version: 1.0
References: <20230213163351.30704-1-minipli@grsecurity.net>
 <Y+pt5MGR+EjLH4qQ@google.com> <13deaeb6-dfb2-224c-0aa3-5546ad426f63@grsecurity.net>
 <Y+5okhlB4rkXjKWS@google.com> <2c2f77a3-1d77-0d88-991a-60dcdc370ea8@grsecurity.net>
Message-ID: <Y++s2LvnBxydxhVM@google.com>
Subject: Re: [PATCH 0/5] KVM: Put struct kvm_vcpu on a diet
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 17, 2023, Mathias Krause wrote:
> On 16.02.23 18:32, Sean Christopherson wrote:
> > I'm not necessarily opposed to such aggressive optimization, but the ROI is likely
> > very, very low.  For optimized workloads, there simply aren't very many VM-Exits,
> > e.g. the majority of exits on a modern CPU are due to timer ticks.  And even those
> > will hopefully be eliminiated in the not-too-distant future, e.g. by having hardware
> > virtualize the TSC deadline timer, and by moving to a vCPU scheduling scheme that
> > allows for a tickless host.
> 
> Well, for guests running grsecurity kernels, there's also the CR0.WP
> toggling triggering VMEXITs, which happens a lot! -- at least until
> something along the lines of [1] gets merged *hint ;)*

Ha!  It's high on my todo list for 6.4, catching up on other stuff at the moment.

That series is also _exactly_ why the ROI for aggressive cache line optimization
is low.  The better long term answer is almost always to avoid the VM-Exit in the
first place, or failing that, to handle the exit in a fastpath.  Sometimes it takes
a few years, e.g. to get necessary hardware support, but x86 virtualization is fast
approaching the point where anything remotely performance critical is handled entirely
within the guest.

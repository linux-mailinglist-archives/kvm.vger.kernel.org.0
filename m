Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B85272EE7E
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 23:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239026AbjFMV7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 17:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239795AbjFMV7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 17:59:01 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE322968
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 14:58:24 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bc68c4e046aso82810276.0
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 14:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686693498; x=1689285498;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jl3T9X01wbOvln0P81lpxrPxbx876fBi8hsjBo6kZSE=;
        b=Fo8TNWHW+0x6UYXvqaix0T2gAuHxiszbzFgrJ8TGUs/r/lMFxHpnKS8Wu6BBFvHypL
         0QydELvdjzgPzYURsqdbLXpSizM2X6XXzHxMdHMPBybmutkulpmmDMn/AMBFDo2IxidZ
         C1Yyj+0rYZsBdeWQReqbV2tsynw8ot5DwfcNYLu/a1qOvJOBS6pwIxzxxAMT6sYRsqux
         XhP2PNVChhWm9NWGB1DvGpFltt6cvNa8l5hmmCQFPriEkrAI/iYTR9mD06jHchA25sXU
         TqgLeJGDebiDJRcfcrPkW25siw1mmZhqk6XcFdgwvHDmvNoh1toDWQV/HTStuNasxiJF
         FOpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686693498; x=1689285498;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jl3T9X01wbOvln0P81lpxrPxbx876fBi8hsjBo6kZSE=;
        b=fnkB/r0bIWpviB4HIa3GQiBORK9ihyik4pQjegfa23w7gANBmzlp5IWpkqZakHgWhO
         bzVSX8Z53WmtweoF/jKN06fE1azj3d8puyQujnEqRmYUOCWuNX5eu66WzNwhWXZzTuMh
         BAqJndFIHtHiIK3eneANcZdVf8ezyuPjL7GwCP2qxO2iFXVM5kSZYlWYzJl95RQk3z5w
         zEvUzh29Oc1Gd7fZxe8q9Cyu4ggS9DqbR974yYaRE8+V9Ub1SiS1RMdZoaMGS4elQ/y6
         AyGzvqvLq07f9DdYhec+HtpKEwsnJYIGHZ9YcHcy6kWjoRaa5sbCWVAzTJ5kKqcrEf9G
         dQ0w==
X-Gm-Message-State: AC+VfDys/snHhV0PsBCT1LQefiy1Dp3N97z/m4tYaosIRIkdgSCllGa5
        VZ81dwSc+as2fpUE7jCUieGO2rxWtRI=
X-Google-Smtp-Source: ACHHUZ6YA3mqzLR6OTagfaklpQ7TWS7PGMnhyzkYvYNCOMsF+i+pa+Js5h5eZURnRO9IMq5g1+lv3Rtn1S4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d604:0:b0:bc5:4150:8e8d with SMTP id
 n4-20020a25d604000000b00bc541508e8dmr72755ybg.4.1686693498786; Tue, 13 Jun
 2023 14:58:18 -0700 (PDT)
Date:   Tue, 13 Jun 2023 14:58:16 -0700
In-Reply-To: <b75c9696-9abb-7a3f-0fb2-56af8ef21bb6@redhat.com>
Mime-Version: 1.0
References: <20230525153204.27960-1-rdunlap@infradead.org> <ZHqSYbYscprsU2qT@google.com>
 <b75c9696-9abb-7a3f-0fb2-56af8ef21bb6@redhat.com>
Message-ID: <ZIjmeC4binNWlYoi@google.com>
Subject: Re: [PATCH v2] KVM: MAINTAINERS: note that linux-kvm.org isn't current
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023, Paolo Bonzini wrote:
> On 6/3/23 03:07, Sean Christopherson wrote:
> > It's definitely stale, though unless Red Hat (presumed hoster) plans on decomissioning
> > the site, I'd prefer to keep the reference and instead improve the site.  We (Google)
> > are planning on committing resources to update KVM documentation that doesn't belong
> > in the kernel itself, and updatingwww.linux-kvm.org  instead of creating something new
> > seems like a no-brainer.  I can't promise an updates will happen super quickly, but I
> > will do what I can to make 'em happen sooner than later.
> 
> We don't plan to decommission the website (especially not the old KVM Forum
> content), though we might move it over to the same (container-based) setup
> as wiki.qemu.org.
> 
> What content do you have in mind that doesn't fit in the kernel
> Documentation/ tree?

Mostly developer focused stuff, e.g. using KVM to test/debug kernels and/or KVM
itself, using 9PFS to hoist modules from into a VM without having to install the
kernel in the guest image, in-depth walkthroughs of various code flows (e.g. how
KVM takes an EPT violation and turns that into a mapping), etc.

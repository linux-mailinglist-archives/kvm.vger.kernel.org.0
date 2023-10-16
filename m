Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2BB7CB0ED
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 19:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233990AbjJPREZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 13:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343581AbjJPREJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 13:04:09 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFFCEAF86
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 09:45:41 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c9c939cc94so35503245ad.1
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 09:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697474741; x=1698079541; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rhtOnbGRFFBp+H16zPlnIGSaINfrMiTw1jYZM4m9Lsw=;
        b=wQtkoguHXxRj6nl9t1QlBh+gV7CRofBq0fFqk2wGQNrDqjh658ulFSxZmY3GOK3ZfI
         jZhN038kW2ZojP8g98FzfVGf+K5lm6HFX2Hf0lXjfeCpHSNxKCKka8ezu1XW/h29zx3N
         OtheCUrNWQ8hLiWvvSOKwKUQuk5/UhAuPw4h8SctXzWPGcdUkQ/8j/LRQoHS6LE5fM5A
         hpQAYrHko1ecIVoTIehKgD6IhGgqRpUaUX332ER2YXlMhUnsVLpwtypFVby5qB1m0Lej
         27DJGfeQLiaZsAWRfIGPpMwLKUZqYisoZt5bcqF/F0dtn2UGB1vXvLjcfCzPYcz6zVFA
         PmCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697474741; x=1698079541;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rhtOnbGRFFBp+H16zPlnIGSaINfrMiTw1jYZM4m9Lsw=;
        b=NdXiJFaJQs5N5v/iLlaOtVLlaxmdnzZPD0IKpqEGlUP7EubYPClg06UQg1K6BguoHe
         WWvSsxBU6EELIuhCBkSwLEEvHF2MCN9eT4C9iEc1ItMw6fzayIGCiFp1Bp96X4JN+I4v
         McqVvgC8o43gsWIVlsFfFg7QA++ZCGDFHDl4YiWqpR6rI+3T5t3dMr2OWF/Jt8kczyVY
         cCgVhFo0zR6z62bmoRuPI9VJxd1L2IoezLnfsuWcR1cSXQP52ERc77OzHWrNlJ3y9VTM
         uT9XQ3v/68/8EGS5+VXGRKPDfIdRQvaMjfg9grSJf230Zsi2H8VX5L9TWtWRSCcA+zDv
         S4yw==
X-Gm-Message-State: AOJu0Yyucx9ob0yUiGHSOQQV4IBJGpTTcnnumVmRs++JBIHottDX6Mbg
        UXPArTK4uvQHKyfKOmR7kB1srReo4O8=
X-Google-Smtp-Source: AGHT+IG2Gv2dCJ2zKV6XwZCcBImXIwLqP92ORv7R/GMdiI6leJKP2/Q3sGXhTu7mniytn5fYu/P/2rLUvFM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f54d:b0:1c9:b785:bc46 with SMTP id
 h13-20020a170902f54d00b001c9b785bc46mr387819plf.12.1697474741006; Mon, 16 Oct
 2023 09:45:41 -0700 (PDT)
Date:   Mon, 16 Oct 2023 09:45:39 -0700
In-Reply-To: <877cnm8te9.fsf@redhat.com>
Mime-Version: 1.0
References: <20231010160300.1136799-1-vkuznets@redhat.com> <20231010160300.1136799-8-vkuznets@redhat.com>
 <708a5bb2dfb0cb085bd9215c2e8e4d0b3db69665.camel@redhat.com>
 <87h6mq91al.fsf@redhat.com> <ZS1VGvbcmH93-KyH@google.com> <877cnm8te9.fsf@redhat.com>
Message-ID: <ZS1os-rIcdVu91Co@google.com>
Subject: Re: [PATCH RFC 07/11] KVM: x86: Make Hyper-V emulation optional
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
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

On Mon, Oct 16, 2023, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Mon, Oct 16, 2023, Vitaly Kuznetsov wrote:
> >> Maxim Levitsky <mlevitsk@redhat.com> writes:
> >> 
> 
> ...
> 
> >> >
> >> > "Provides KVM support for emulating Microsoft Hypervisor (Hyper-V).
> >
> > I don't think we should put Hyper-V in parentheses, I haven't seen any documentation
> > that calls it "Microsoft Hypervisor", i.e. Hyper-V is the full and
> > proper name.
> 
> Ha :-) From
> https://lore.kernel.org/linux-hyperv/1696010501-24584-1-git-send-email-nunodasneves@linux.microsoft.com/
> 
> """
> This series introduces support for creating and running guest machines
> while running on the Microsoft Hypervisor. [0]
> ...
> [0] "Hyper-V" is more well-known, but it really refers to the whole stack
>     including the hypervisor and other components that run in Windows
>     kernel and userspace.
> """

LOL indeed.  :-)

> I'm fine with keeping the staus quo though :-)
> 
> >
> >> > This makes KVM expose a set of paravirtualized interfaces,
> >
> > s/makes/allows, since KVM still requires userspace to opt-in to exposing Hyper-V.
> >
> >> > documented in the HyperV TLFS, 
> >
> > s/TLFS/spec?  Readers that aren't already familiar with Hyper-V will have no idea
> > what TLFS is until they click the link.
> >
> >> > https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/reference/tlfs,
> >> > which consists of a subset of paravirtualized interfaces that HyperV exposes
> >
> > We can trim this paragraph by stating that KVM only supports a subset of the
> > PV interfaces straightaway.
> >
> >> > to its guests.
> >
> > E.g.
> >
> >   Provides KVM support for for emulating Microsoft Hyper-V.  This allows KVM to
> >   expose a subset of the paravirtualized interfaces defined in Hyper-V's spec:
> >   https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/reference/tlfs.

To fold in the whole "Microsoft Hypervisor" thing, what if we take the verbiage
verbatim from the TLFS intro?

  Provides KVM support for emulating Microsoft Hyper-V.  This allows KVM to
  expose a subset of the paravirtualized interfaces defined in the Hyper-V
  Hypervisor Top-Level Functional Specification (TLFS):
  https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/reference/tlfs


> LGTM, thanks!
> 
> >
> >> >
> >> > This improves performance of modern Windows guests.
> >
> > Isn't Hyper-V emulation effectively mandatory these days?  IIRC, modern versions
> > of Windows will fail to boot if they detect a hypervisor but the core Hyper-V
> > interfaces aren't supported.
> >
> 
> It's rather a rule of thumb: normally, modern Windows and Hyper-V
> versions (Win10/11, WS2019/22) boot and pretend to work but without
> Hyper-V enlightenment it's not uncommon to see a blue screen of death
> because of a watchdog firing. It's hard to say for sure as things keep
> changing under the hood so even different builds can behave differently;
> pretending we're a genuine Hyper-V was proven to be the most robust
> approach.

We should capture something to that effect in the help.  I want to avoid bug
reports of Windows not working on KVM because someone turned off CONFIG_KVM_HYPERV
because the help implies that it _only_ improves performance.

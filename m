Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 129256B51C5
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 21:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbjCJU0t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 15:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjCJU0r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 15:26:47 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2428139045
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 12:26:46 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id m9-20020a17090a7f8900b0023769205928so4829875pjl.6
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 12:26:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678480006;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lokPgRlxX9cxwO/toEB1KI/GEc/NMcQYix4Ij5mDESQ=;
        b=O8+lzod85mxI8Vh/hu7XXdMIrp6e5svIoEwa69k2hHl5g+Z+SPRZmLiZvHwFiErJBr
         E9tHbrfRLQtMbDn97LWzGz4DuNRI6aQwAjs6NDvoZIhP6N4txuSH66HOILoFqthcZYIZ
         62ImNGaL9Y8tyzSUdvgQWrG/yv7uT8ps63ZOzA97fyz6qQ9Zqfputxz7ZTN6/CKs0sqt
         hjniu+9SMYi3h9JdgdTg/MCoIuB2m0rMfZAerSl8s7msN9cBJGneGX4xdU5SL3eKD9ED
         XOqlcgTn/tHcTS1u0Q4hStUzGzv6gTPzA8c361tuO5pH56iQ7CdvKT2zMf8gzyEk2z1p
         X3DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678480006;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lokPgRlxX9cxwO/toEB1KI/GEc/NMcQYix4Ij5mDESQ=;
        b=jCByVSQ92/zuHLHqR2e8qRHNxKD1y7fTx//wN2Zmi4trbUlcqlDBXeVmx5jUZWjqFT
         uBztXumcgQnRdiNh0tdyLtgbdXzb6q0/sCZBITgZNl5h+13qI9iRT8dfFIPPx6XFFq4Z
         F8ciaasrP2tH7HZ4h1vukYCxwhkYpF+TiQhIbtNyQAxOQYwIwMYBqQuUXfsK4Oujia9r
         1i7oXIAoCxKzA8SHbcNB3AfFm3vCldSieXb+hNsTqENySbkrAoF45nRhAbzEQgHOuqHt
         Ku1y3Sr0UCKsscxxNRnF+IB+FLDq/ylLtlqPSesCPtUeW6u264HChhZP78wlBh+Cq52g
         kqpQ==
X-Gm-Message-State: AO0yUKWjbzQfUxDRL1wR/vINOXxF5VqlQnCU3gT09st99Z8d/amHE+cQ
        +40Yct2mmHtQDgiZKAREf46DGcKHb1I=
X-Google-Smtp-Source: AK7set889VM2/Sx0n/OUON/Qyrosj+eYWAk5tHA688KrVsqqMw/ZWYmQ3DVyyhWLyGL2Ym61jrPN+yBYz1Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:7fcd:b0:19a:7bd4:5b0d with SMTP id
 t13-20020a1709027fcd00b0019a7bd45b0dmr10136384plb.8.1678480006141; Fri, 10
 Mar 2023 12:26:46 -0800 (PST)
Date:   Fri, 10 Mar 2023 12:26:44 -0800
In-Reply-To: <52e5514d-89f3-f060-71fb-01da3fe81a7a@linux.intel.com>
Mime-Version: 1.0
References: <20230227084547.404871-1-robert.hu@linux.intel.com>
 <20230227084547.404871-5-robert.hu@linux.intel.com> <79b1563b-71e3-3a3d-0812-76cca32fc7b3@linux.intel.com>
 <871716083508732b474ae22b381a58be66889707.camel@linux.intel.com> <52e5514d-89f3-f060-71fb-01da3fe81a7a@linux.intel.com>
Message-ID: <ZAuShCqn/U034jZN@google.com>
Subject: Re: [PATCH v5 4/5] KVM: x86: emulation: Apply LAM mask when emulating
 data access in 64-bit mode
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     Robert Hoo <robert.hu@linux.intel.com>, pbonzini@redhat.com,
        chao.gao@intel.com, kvm@vger.kernel.org
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

On Fri, Mar 03, 2023, Binbin Wu wrote:
> 
> On 3/2/2023 9:16 PM, Robert Hoo wrote:
> > On Thu, 2023-03-02 at 14:41 +0800, Binbin Wu wrote:
> > > __linearize is not the only path the modified LAM canonical check
> > > needed, also some vmexits path should be taken care of, like VMX,
> > > SGX
> > > ENCLS.
> > > 
> > SGX isn't in this version's implementation's scope, like nested LAM.
> 
> LAM in SGX enclave mode is not the scope of the this version.

I'm not merging half-baked support.  Not supporting nested LAM _may_ be ok, because
KVM can _prevent_ exposing LAM to L2.  I say "may" because I would still _very_
strongly prefer that nested support be added in the initial series.

But omitting architectural interactions just because is not going to happen.

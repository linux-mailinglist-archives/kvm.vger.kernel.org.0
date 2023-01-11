Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33C2B665044
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 01:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235592AbjAKANp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 19:13:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235550AbjAKANa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 19:13:30 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B16C5B164
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 16:13:29 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id p12so6841671qkm.0
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 16:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Yp3JBjB7tUuFMsajmJ3bAPYZcj+Fk8Scb4kzxl2ZOaQ=;
        b=CmTJCaH4bg3dcVAmU2gQrctGL5VpPwS09Wz2s710hyBySidlskESG0Epja7VKd70mw
         9zXcGF9bD2YGLHBVAbiNG0MtDnVvVvtN9daev7xuAgNAU4xjccHF+L94AyJPehPsx7lZ
         3W9+/W2UgtfvJUO9voIHa+poavRUUCOaW004/O6LpZ7dW84d5CiLHOS7is3EC8Qg2MBw
         yhY6gRMTfU8KxsIZi8dkT2NHJupAUJWnFS0yRxv9+XSbzFZNh2roh4TBSYhCe7vW8U90
         yQ789gW1jZgY0cFLu+xpFP9RCRT6BXehtasUYJMvbugdL9WeBvTQ9jLqQ+PC14XDIv8e
         GyXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yp3JBjB7tUuFMsajmJ3bAPYZcj+Fk8Scb4kzxl2ZOaQ=;
        b=ZVG7J7D6A9Mj101VBpUHUMSZUcwvOw+kdenG5rsjoKWSwE3SSLd6vyS3d2LVGovehT
         kZf+HBOMZ0awo+6MMiK1oZvAvnFHaSDheWvK3iDhYRCyP7vFiSrIjY6gykEVsPUjtBDg
         acs5wjo7NkCicvoFmb5HKjdsRNceoztXWrrfiF0JUSdT26FclnLifOU8LE9gpWPQT6Ps
         uc5al5aVu6krQ1h5x80QvYCbFFL3FnY3PpsPzm7PKGZ+o/INSsuYkzHjcN3dXcI+iE+T
         qNyROBuUYuvMcXIwAMKFBYltD8zcNntZKb7QkNe4S/zqjIyiIzxQtvFcJ/HyolFDR++8
         uz8A==
X-Gm-Message-State: AFqh2ko6U+5PJ3cifGMxLRF4+jVX+F1u9UHeo0L1FHpLy6IB24MC15rV
        gTszpqgIUa+3W2/C1NnF5bo7geGRUHU5wkjrnvRYbw==
X-Google-Smtp-Source: AMrXdXs2tcDSd7cUsxvpiJsd1B3COzW8vycd3OZlh/Wcbs/Wde9LFZ3beTYZ4JZx/MRfMeSPSNyoeKkTde1LTumraqk=
X-Received: by 2002:a05:620a:2618:b0:6ff:7e5c:a4f4 with SMTP id
 z24-20020a05620a261800b006ff7e5ca4f4mr2620622qko.115.1673396008293; Tue, 10
 Jan 2023 16:13:28 -0800 (PST)
MIME-Version: 1.0
References: <20221228192438.2835203-1-vannapurve@google.com>
 <20221228192438.2835203-3-vannapurve@google.com> <Y7xZLB+1isqZTJCj@google.com>
In-Reply-To: <Y7xZLB+1isqZTJCj@google.com>
From:   Vishal Annapurve <vannapurve@google.com>
Date:   Tue, 10 Jan 2023 16:13:17 -0800
Message-ID: <CAGtprH981oz8VVjMHnD_PSmYLF1SmiVERXkgF45-JmErSAzRyQ@mail.gmail.com>
Subject: Re: [V4 PATCH 2/4] KVM: selftests: x86: Add variables to store cpu type
To:     Sean Christopherson <seanjc@google.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
        shuah@kernel.org, bgardon@google.com, oupton@google.com,
        peterx@redhat.com, vkuznets@redhat.com, dmatlack@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 9, 2023 at 10:13 AM Sean Christopherson <seanjc@google.com> wrote:
>
> In shortlogs and changelogs, try to provide a synopsis of the change, not a
> literal description of the change.  As suggested in the previous patch, this:
>
>   KVM: selftests: Cache host CPU vendor (AMD vs. Intel)
>
> is more precise (vendor instead of "cpu type") and hints at the intent (caching
> the information), whereas this doesn't capture the vendor part, nor does it provide
> any hint whatsoever as to (a) how the variables will be used or (b) why we want to
> add variables to store
>
>   KVM: selftests: x86: Add variables to store cpu type
>
> On Wed, Dec 28, 2022, Vishal Annapurve wrote:
> > Add variables to hold the cpu vendor type that are initialized early
> > during the selftest setup and later synced to guest vm post VM creation.
> >
> > These variables will be used in later patches to avoid querying CPU
> > type multiple times.
>
> Performance is a happy bonus, it is not the main reason for caching.  The main
> reason for caching is so that the guest can select the native hypercall instruction
> without having to make assumptions about guest vs. host CPUID information.

Ack, that makes sense.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1B523263D
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 22:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgG2Uhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 16:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726816AbgG2Uhg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 16:37:36 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516B8C0619D4
        for <kvm@vger.kernel.org>; Wed, 29 Jul 2020 13:37:36 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id e64so25939284iof.12
        for <kvm@vger.kernel.org>; Wed, 29 Jul 2020 13:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=feuGkbN2E+CY4DYEzbMyw1G53COndnQfGzu4PNYGrlE=;
        b=IOAAJ9NsSUh5yPDkFHrM/yn3ArdUgh3ru5J4RxxujQQYlhEtwasJPcFfg1ZH9GjWCC
         akWYg59be45KQkJHM5B0zSMQR7QpIGxQVNncfQurnOShEO9Kb4ZivhYBsLqBAyUapySW
         v5lblsElXPV/9TvCxpQBLNIREiWtyULDcKxU7cshmtZKAaTwriPNj3GdOFEfFzlcQ3NR
         GEJQa3d7nGpTv+76mckr7sfY6gircJtEylXlfquXn4VRA8QeBDtqVbGnxkKxOtJxt90b
         byAThQy067Cg8IjzQw8D2as8g1XRE3oMeC4gSaFhDXo18AyV7G0RPYTN+/wG4RBLAcWm
         RXnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=feuGkbN2E+CY4DYEzbMyw1G53COndnQfGzu4PNYGrlE=;
        b=aWaiI8Yv/XiptWdlM+be0lae/7Sx0zjU0JxwGUengWJSXVbmwAlNhRJSByvNH7Qb5U
         KZgN5oRZBLviz8i4vqr5xBKxvUo1Fvxm2XUjcyhcUkAXJ4aGqUCcP5PvXU4XGY3150dD
         +c5tHws/YkkHtzv6ZMXjEENiarC/bplKRLHMoI1NJ3UU/A78IpOHDVn/ylQzhIEa8jyf
         fdUFEHs222hVZDWsRtTr/S6DoiyMyXOpJEIWQyBuWGNCLqQHFVhcbkNgMFrzvIjXJPir
         UoYq35siLT42mae0gyrqntw6ewGXVMi87rREKRzL1LBMBiJLCbRUjlVmCoufXyJuvuj6
         I7sA==
X-Gm-Message-State: AOAM530Vrl7I1zEcyrLU5J8T8iodvfcUpH1Jfea3FIrIRN8iQ4ilVkah
        BMvRHjzjgK8AiiN9JzFoHeJGUlLLLhPLVWD1B05a8w==
X-Google-Smtp-Source: ABdhPJzJnBn4g3Z3/OC6fL9PkJmR/5alLnXd4E6YmWDnugeSVP+FbZ742waST/DjPHmcFtTyupDePhDtpQu8+Chiwbw=
X-Received: by 2002:a05:6638:1685:: with SMTP id f5mr17236458jat.48.1596055055453;
 Wed, 29 Jul 2020 13:37:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200728004446.932-1-graf@amazon.com> <87d04gm4ws.fsf@vitty.brq.redhat.com>
 <a1f30fc8-09f5-fe2f-39e2-136b881ed15a@amazon.com> <CALMp9eQ3OxhQZYiHPiebX=KyvjWQgxQEO-owjSoxgPKsOMRvjw@mail.gmail.com>
 <14035057-ea80-603b-0466-bb50767f9f7e@amazon.com> <CALMp9eSxWDPcu2=K4NHbx_ZcYjA_jmnoD7gXbUp=cnEbiU0jLA@mail.gmail.com>
 <69d8c4cd-0d36-0135-d1fc-0af7d81ce062@amazon.com>
In-Reply-To: <69d8c4cd-0d36-0135-d1fc-0af7d81ce062@amazon.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 29 Jul 2020 13:37:24 -0700
Message-ID: <CALMp9eSD=_soihVJD_8QVKkgGAieeaBcRcNf2gKBzKE7gU1Tjg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Deflect unknown MSR accesses to user space
To:     Alexander Graf <graf@amazon.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 29, 2020 at 1:29 PM Alexander Graf <graf@amazon.com> wrote:

> Meanwhile, I have cleaned up Karim's old patch to add allow listing to
> KVM and would post it if Aaron doesn't beat me to it :).

Ideally, this becomes a collaboration rather than a race to the
finish. I'd like to see both proposals, so that we can take the best
parts of each!

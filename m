Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13944409A00
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 18:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240395AbhIMQxE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 12:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239698AbhIMQxD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 12:53:03 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA97FC061574
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 09:51:47 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id i12so21570267ybq.9
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 09:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3/SIYclYJBA8R/7MLXxAd/hpBEuATYrK81iK2vA0aLI=;
        b=UaGSj5rF9TV4TbKEczi4abu9Nvmk3QFlrNsZ94RkSIZo5XRGdw1+Yp8wU1bW9ZIKU7
         qVYpBNuU+BqPWj1VV0lFT/GWawzyPNcOXttDDmhFRg+yEyIx+9mPVAx48lK+heY3iA3U
         HfCW9WvnXI6sbmUfIeRc2nkS12QocvHXtxiMMfataHdNLwYk/dbbfasez2yumAPudGYC
         n/k5QceOvkIZ5XWqkUBFnHcWLXjV0SJXVTJO0j+H5/1iEevGYv+hiF5UfvY0YT6vNala
         zKfQdTpdroaT4Tu5XUNzVCE60Q3x49dFineIsNw6rXKH899hYBUZPrQ4vrEEBC5tbuni
         gB4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3/SIYclYJBA8R/7MLXxAd/hpBEuATYrK81iK2vA0aLI=;
        b=q8G7w6kHes4BwUBpjnXMNWkLr9CmR6A+CYIQSRMU3ZJkx/HVKHGGvk1JBApF4aAoiI
         U1tX0Dw4AWmtvuqkU3jlXoXDja1FhiiimdvYCJT+RiY6UtqjU6i9t/j2p58MgnMHo1YO
         7WBBjO63DfxQ8W89mO/g1QUKmwtzS+e5Oy8QcQFqGKqDQTzEVvMTyLAfqhU1+i7Hx66V
         G6iZSfzq+ZDSq1PQNuZdryxUXn9r9FRvi6kPPH/YMToz/JSiqbTi95U2/VovhxDKRp6g
         yYzcGdP3eJERpdEWdbSb0tMOa2HHe36r4WXShgUfvW0oXk0QKykDaafmI0lWjdhaoQ9k
         0gyg==
X-Gm-Message-State: AOAM532tlaUiAMNLchc5sDQSyCw/ahhvlURGBAk0u3aGrdv6XcGt74ZR
        5ZSRsZQ1zuc7B75YUwNZ0F7DlgHXYol2pBTXWjpMTw==
X-Google-Smtp-Source: ABdhPJxF0MJAT41gnQOnRX7DjWFM0GLtwxdoVZIW+Gw+fILuc0cKnD6bHktwWwOauF6yqJrWs2OzSb/bX+FogXn7Y8c=
X-Received: by 2002:a25:50c7:: with SMTP id e190mr17068088ybb.439.1631551907001;
 Mon, 13 Sep 2021 09:51:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com> <20210909013818.1191270-10-rananta@google.com>
 <CAAeT=Fw0Z1USVpdi2iRMRq0ktTP4+VFzfy31FWV36VPOCTq6_w@mail.gmail.com> <20210913073512.x774i5hi3s4wmopx@gator.home>
In-Reply-To: <20210913073512.x774i5hi3s4wmopx@gator.home>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 13 Sep 2021 09:51:35 -0700
Message-ID: <CAJHc60wVJP4=s3r16nLWXA8o=k71OagvLFrWVWwJJnLycHMQyw@mail.gmail.com>
Subject: Re: [PATCH v4 09/18] KVM: arm64: selftests: Add guest support to get
 the vcpuid
To:     Andrew Jones <drjones@redhat.com>
Cc:     Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 13, 2021 at 12:35 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Sun, Sep 12, 2021 at 12:05:22AM -0700, Reiji Watanabe wrote:
> > Hi Raghu and all,
> >
> > On Wed, Sep 8, 2021 at 6:38 PM Raghavendra Rao Ananta
> > <rananta@google.com> wrote:
> > >
> > > At times, such as when in the interrupt handler, the guest wants
> > > to get the vcpuid that it's running on. As a result, introduce
> > > get_vcpuid() that returns the vcpuid of the calling vcpu. At its
> > > backend, the VMM prepares a map of vcpuid and mpidr during VM
> > > initialization and exports the map to the guest for it to read.
> >
> > How about using TPIDR_EL1 to hold the vcpuid ?
> > i.e. have aarch64_vcpu_setup() set the register to vcpuid and
> > guest_get_vcpuid() simply return a value of the register.
> > This would be a simpler solution to implement.
>
> That is a great suggestion. It's arch-specific, but maybe the
> other architectures can mimic it with their own capabilities.
> And, in the unlikely event a unit test wants that register for
> itself, then it can build its own mpidr-vcpuid map if necessary.
> Ship it :-)
>
Thanks for the suggestion, Reiji. I'll send out a patch soon for this.

Regards,
Raghavendra
> Thanks,
> drew
>

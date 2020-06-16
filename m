Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EECBE1FBC24
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 18:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730431AbgFPQxH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 12:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728928AbgFPQxG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 12:53:06 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C16BC061573
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 09:53:06 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id j19so15395248ilk.9
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 09:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=35fJVpimnPIUIwkluAKTPDeW39MIuCPNhgYXzeFLeCI=;
        b=FrdhN4XbBCzcjxgqatMcyw636L7XhrL/fbg/YYPrrAO7BMtJXMQTeIHZqJZRz9REyE
         jNx/O+9nb5urZAYd5dXGI4W2wdlubrf6P2pf3Obm8CYuYngCyOqavnX112jiFHocm8qb
         Z47p7BdD8hWjBkKEpY1rTtoQOYwOpvws8Q/lQ3cLFda/nTem+nAKnskDIONifD6PrYlL
         Y85Fl/Vj05mZigg5G87IV2BIR5S93gtHcjPZveSZw68S9yCXfhpdwL3EtxWThKtKSZl6
         WSGNnOuy8YmwP2rp2pGKCgxttgReEIKZqiBn/f8s/GF4rHCTR0LE3wYA0LU5zj8ljPNs
         NOaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=35fJVpimnPIUIwkluAKTPDeW39MIuCPNhgYXzeFLeCI=;
        b=E08RN/aWDDp1NU6zEikdFbbX5KFyws+AJjX4T7sq9MlvYlCeUutuWW4bp4IK07bfwm
         lKjSifGd8h0GMEKBNy0Tg7Pen6fJc9bkWRpcrIm3PZa37dTXJcZCfcJ5TK8YO/ahtZIN
         oAm5Kaf8kWvWAlE9nELVF+CIrol5d5LpPRe/PXsNn1pxRH4x48WLDc7CKyzomwSB+pVV
         XSXyJrJ51BFCXV5PHxOOkFHeYgymfj7w4Evtpt7LxGJeEOOFY4l5HTozEJ+kAhCcOmgg
         ir3oXrAXX9oxtQIujabHCJfwuAM51s5BTI6TLydTHrktiZXiQaIbjFCaaJ5Gbp/QXij3
         5LXQ==
X-Gm-Message-State: AOAM533GqWAAmHPYeP0csXbWJFkth7NqOGEijl3OPAtAy3hhDm4JLIp4
        JNv960aCZNE7Bu1+9LSCypC0L3Vj/ANhn/8HRlhsSQ==
X-Google-Smtp-Source: ABdhPJwH3LniTJNmavisyNTcdSi95okyd/Pkfo1xifTdxT8dZZTARF4tN4WcB5PUfmX0LvB95lJY5m/qnwlN8UsUCms=
X-Received: by 2002:a05:6e02:1208:: with SMTP id a8mr4162289ilq.118.1592326385013;
 Tue, 16 Jun 2020 09:53:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200616161427.375651-1-vkuznets@redhat.com> <CALMp9eSWXGQkOOzSrALfZDMj5JHSH=CsK1wKfdj2x2jtV4XJsw@mail.gmail.com>
 <87366vhscx.fsf@vitty.brq.redhat.com>
In-Reply-To: <87366vhscx.fsf@vitty.brq.redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 16 Jun 2020 09:52:54 -0700
Message-ID: <CALMp9eQ1qe4w5FojzgsUHKpD=zXqen_D6bBg4-vfHa03BdomGA@mail.gmail.com>
Subject: Re: [PATCH] KVM: SVM: drop MSR_IA32_PERF_CAPABILITIES from emulated MSRs
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Like Xu <like.xu@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 16, 2020 at 9:45 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Jim Mattson <jmattson@google.com> writes:
>
> > On Tue, Jun 16, 2020 at 9:14 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >>
> >> state_test/smm_test selftests are failing on AMD with:
> >> "Unexpected result from KVM_GET_MSRS, r: 51 (failed MSR was 0x345)"
> >>
> >> MSR_IA32_PERF_CAPABILITIES is an emulated MSR indeed but only on Intel,
> >> make svm_has_emulated_msr() skip it so it is not returned by
> >> KVM_GET_MSR_INDEX_LIST.
> >
> > Do we need to support this MSR under SVM for cross-vendor migration?
> > Or, have we given up on that?
>
> To be honest I'm not sure about the status of cross-vendor migration in
> general and PMU implications in particular, hope Paolo/Sean can shed
> some light. In this particular case my shallow understanding is that
> MSR_IA32_PERF_CAPABILITIES has only one known feature bit which unlocks
> an MSR range with additional counters. If the feature bit is not set
> this, I guess, can easily be migrated (basically, let's allow writing
> '0' there on AMD and return '0' on read). But what if the feature was
> enabled? We'll have to support the new MSR range and do something with
> it after migration (run intel_pmu in fully emulated mode?).
>
> Anyway, the immediate issue I'm trying to fix here is: whatever is
> returned by KVM_GET_MSR_INDEX_LIST can be successfully queried with
> KVM_GET_MSRS as some userspaces count on that.

That's a nice property. Is it documented somewhere?

Reviewed-by: Jim Mattson <jmattson@google.com>

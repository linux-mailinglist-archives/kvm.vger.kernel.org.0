Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B545E258627
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 05:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgIADZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 23:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgIADZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 23:25:14 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B33C0612FE;
        Mon, 31 Aug 2020 20:25:13 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id j21so2935301oii.10;
        Mon, 31 Aug 2020 20:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WswF+eY/uav4Y6QJBkqqfte8Y8u+EHxBxZsHaGmjFJY=;
        b=jsAI596KQhVTKEwRIlLDcd0UBrvQ6A4UALEQdAbroJcdY5MRb35wWEcLhhkiS1ykB4
         GEf9UTpSeGmk666SqUcAYtaseiK/ULBT1Thal+Ze6vb0VjggYUONHCYDJ1ZPFaK/0h7X
         9qu4ZqsFs92C3Qbm+PnmFQRoRruHxvYaFDfah1O/DLkzV/NS690bKkFSShHxqu/+sutu
         55nfQSfYyQ9vXOzQr7KFwMmPIwGJn30frbRsH0YLZfh2PxQ2482wv52jHGKlkroGKYkZ
         sRL7eZQW7T8nvwZGlOF2w6AiW9DTIgCqULKNBa8/yDznw7p94QwoJNAgCBo7aqVODncS
         wlqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WswF+eY/uav4Y6QJBkqqfte8Y8u+EHxBxZsHaGmjFJY=;
        b=tw51vPP3GrWbd8UAx8OnTN699dkijEEC6Z2XBzv5M4QNubKRAMGkMPzYtWG7vaVkOB
         amvbP1RM8MuVPVOyjSWVh7RUqs/55/OF1JdleYZzFvnlhPIJmdpKWAuhD6LAuT5BQ4si
         EMdq+MHQhr4ds2Cdbq90T43OGUDR1sTpJdlPkzPjxW3NXFIs9nw7A6KWhiLGX5iyLf/T
         /WPumTJkWS/86dp8V00EtetVF1H9HV5srwCSq/dh9+JdLm0ykdguTLrU01qB1n5lvRG6
         V+G+E1l5w7cV0thQ/gcS44FkSnekO6ca3iqchunGh+tBWbtPael5h/ifWONWUU3QTdW3
         8jrg==
X-Gm-Message-State: AOAM532VQpelBQE6MSm+wAprEB9NQ9OcUfFlcnd+JCoLq0ID4s20f8oA
        Jl1J/WKZgEcbKKeyP8E9jJ42H/KfN2GFGJsW1qo=
X-Google-Smtp-Source: ABdhPJwX3CuPHma/90d6+Dt1FjXkU5q11qUWGRHuFk9S8I9vtGYmF64t9kSOHELsSS3kHs17pBd36jtMcp8oR50z36A=
X-Received: by 2002:aca:cd93:: with SMTP id d141mr701oig.33.1598930712741;
 Mon, 31 Aug 2020 20:25:12 -0700 (PDT)
MIME-Version: 1.0
References: <1598578508-14134-1-git-send-email-wanpengli@tencent.com> <87a6ybx9pv.fsf@vitty.brq.redhat.com>
In-Reply-To: <87a6ybx9pv.fsf@vitty.brq.redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 1 Sep 2020 11:25:01 +0800
Message-ID: <CANRm+CwHiZjh3w94Xdd=ZQXP6XWysz87OG+LFR2ekQn5A2P7Dw@mail.gmail.com>
Subject: Re: [PATCH] KVM: LAPIC: Reset timer_advance_ns if timer mode switch
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 31 Aug 2020 at 20:48, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Wanpeng Li <kernellwp@gmail.com> writes:
>
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > per-vCPU timer_advance_ns should be set to 0 if timer mode is not tscdeadline
> > otherwise we waste cpu cycles in the function lapic_timer_int_injected(),
>
> lapic_timer_int_injected is just a test, kvm_wait_lapic_expire()
> (__kvm_wait_lapic_expire()) maybe?

Both the check in lapic_timer_int_injected(), the check in
__kvm_wait_lapic_expire(), and these function calls, we can observe
~1.3% world switch time reduce w/ this patch by
kvm-unit-tests/vmexit.flat vmcall testing on AMD server. In addition,
I think we should set apic->lapic_timer.expired_tscdeadline to 0 when
switching between tscdeadline mode and other modes on Intel in order
that we will not waste cpu cycles to tune advance value in
adjust_lapic_timer_advance() for one time.

Wanpeng

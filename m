Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA08343923F
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 11:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbhJYJ1q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 05:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbhJYJ1q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Oct 2021 05:27:46 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D9EC061745
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 02:25:24 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id l13so555829ilh.3
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 02:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+R7tv8qiGWmyQ39BNBDNWy3Y8nx1ucJhdbMLNxEg+wg=;
        b=PXf3zbZyoJZHm/NdGg8YmWmsJKNaW8+GIVThMbUZEyMnP3BHhQhOgvvSYuFPgJRcT1
         XkILQ3fYHga54Xa84NWrbB5PxWmKdSt7p30UW9PriGV76uXhau4WYuksgXetrV45qTLM
         kYiX1nbkHezmmkgfm7lhzg4drTEkxHtxTbElEUSMphx7DhvQfTfrVOpYhdx7RJsloLug
         dC1YiMeGvHMHsywHdYBUiJtenaUqHJp3yu2Sm6ykszmmklQDZmfYey3z6bkymnJfGi//
         iUzWR3BJw6qZ3fH62SRGcGIFNcptSHVBfGwS2f+3/hMM8+T9fPnZ9SUkgP5DBS35jp4L
         2FRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+R7tv8qiGWmyQ39BNBDNWy3Y8nx1ucJhdbMLNxEg+wg=;
        b=jIkoQlMMgQlIFYXFyiehI4/bPVWWpgR97q47ywGD2Zhf3xSoycmtmBx8A6UCzAEi3/
         jdYvl5mazEky7t6yCboM3cIweZVGwmb1vJWEesxtePffAbNKS6fsrEkUGemM7oE48Mrs
         hZyhv6K1riQOZ69Lr8ueMhXGMX2cvJV6axkcq5DCJ3oW/82GlguCO9kNBxk9Gd4NnsCQ
         G5n2nzu7VB4klItTNlat55AAJMSJaxLcBdTee/Poe4Wi1njUDs14aC/2E9LV3K05nXJY
         YdSq99yoW+F6PCLhpSGsONIPlPezi0q4LcmvlxMj/Yp6NtjHQe8rzlAkH6C/kO3EJP1U
         guNA==
X-Gm-Message-State: AOAM533Y4i+xfjxfCN6iW8oHh3PN6qIMdH5zU/fQ7Dpa40kq5vEHbhNR
        hebAQ5Ya2HtBNWXtpqYq4gLJzPa5Erk0KwR6o08=
X-Google-Smtp-Source: ABdhPJwCeauerAG2rJdX0ZvBFLfdAlHFIAsJgtVOqafxahv+gVplAmI+8ZUoN2FjqdC1Y2cAM3kb8RP1gtRCWlfQ/Zk=
X-Received: by 2002:a05:6e02:168b:: with SMTP id f11mr8105908ila.260.1635153923810;
 Mon, 25 Oct 2021 02:25:23 -0700 (PDT)
MIME-Version: 1.0
References: <20211006173113.26445-1-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
From:   Mathieu Tarral <mathieu.tarral@gmail.com>
Date:   Mon, 25 Oct 2021 11:25:12 +0200
Message-ID: <CAPXUdKGnKNrGb3cOyFWSpgjVwT93GnvMtc+U1xEav5ew1h6GSw@mail.gmail.com>
Subject: Re: [PATCH v12 00/77] VM introspection
To:     =?UTF-8?Q?Adalbert_Laz=C4=83r?= <alazar@bitdefender.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Tamas K Lengyel <tamas@tklengyel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Adalbert,

> The KVM introspection subsystem provides a facility for applications
> running on the host or in a separate VM, to control the execution of
> other VMs (pause, resume, shutdown), query the state of the vCPUs (GPRs,
> MSRs etc.), alter the page access bits in the shadow page tables (only
> for the hardware backed ones, eg. Intel's EPT) and receive notifications
> when events of interest have taken place (shadow page table level faults,
> key MSR writes, hypercalls etc.). Some notifications can be responded
> to with an action (like preventing an MSR from being written), others
> are mere informative (like breakpoint events which can be used for
> execution tracing).  With few exceptions, all events are optional. An
> application using this subsystem will explicitly register for them.
>
> The use case that gave way for the creation of this subsystem is to
> monitor the guest OS and as such the ABI/API is highly influenced by how
> the guest software (kernel, applications) sees the world. For example,
> some events provide information specific for the host CPU architecture
> (eg. MSR_IA32_SYSENTER_EIP) merely because its leveraged by guest software
> to implement a critical feature (fast system calls).
>
> At the moment, the target audience for KVMI are security software authors
> that wish to perform forensics on newly discovered threats (exploits)
> or to implement another layer of security like preventing a large set
> of kernel rootkits simply by "locking" the kernel image in the shadow
> page tables (ie. enforce .text r-x, .rodata rw- etc.). It's the latter
> case that made KVMI a separate subsystem, even though many of these
> features are available in the device manager. The ability to build a
> security application that does not interfere (in terms of performance)
> with the guest software asks for a specialized interface that is designed
> for minimum overhead.

thank you for the effort of rebasing your code and submitting a new series here.
I'm very enthousiast about the introspection features you are adding
to KVM (and so is the KVM-VMI community in general).

On a side note, working for the Hardware and Software Laboratory (LAM)
at ANSSI (National Cybersecurity Agency of France),
we are closely following these new introspection capabilities, and
waiting to see when they will hit upstream to orient more
research based on KVM.

Best regards,
Mathieu Tarral

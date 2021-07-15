Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420383C9886
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 07:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239173AbhGOFwa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 01:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239135AbhGOFwa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jul 2021 01:52:30 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83883C06175F
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 22:49:37 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 141so7024403ljj.2
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 22:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A/PvA1DB0W5wp+a8Jesrkmf512SBcdKf2TLwujd0mHs=;
        b=EQxYapb1uUstI3d8aTGl3fY9z0le160jeIBGmL2nJsbgqr8ux2VlwMfhBbvyrU8pQo
         bNR8hbUCicTntkRekvIJrfI1oiY8jMQY6LG2RqZZ8rH4Qk+K1mfaRAubuliuOGn32wYq
         2ULQBmdyU0Zc8yZGWfUCbNYWnEUB1DckK5blR+j56gTolJ6G15pHDB3xLyijxHdOSvIJ
         teEKXgBkGGVXZiuFZKv90lxPVqjmPUSJf52lERWJOC5tqrLXA7MNI6VM+rFKlxR5PKOA
         1/PvL9UtKxnKFn96ge3mQdQ136cbmM6nqN26LgtTtrvmyw056OBZ+Hsy9h3uVUYLcwHB
         J7pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A/PvA1DB0W5wp+a8Jesrkmf512SBcdKf2TLwujd0mHs=;
        b=gkqG+4TidqB5NTVS6pwUsF1s80b7exk72lVtC2r7TunLUM48Xt68F6mb5QXOQxXuxK
         DqLMEc/IeYuvVxKTd0Ipnu60QSzPjlRyk06tYFYQYS1vWVkJFpfes9SOPQEero/cucsn
         GrIV8ZGxZvh5RV+5vZWQh77pl8lz7Nj14BF2yw6XXeYIx4fFjvx6rL0ovhFdZS1bHkKm
         L/Kj/RjNMabTtzn8DfALYn95XT/VOmof+xEHSdacf8Nu66IBA3/7oQPa1vuIsshPIk3K
         0CWovgEVw05fTxvBYJlnAFv+OiphQ7Va2Ve2A0C5f1jz4e6UF7UoipDgu9ErkzFGbNcQ
         QKMA==
X-Gm-Message-State: AOAM531CCi6iHpu3AIruLMPJFHG+64htPRxDfV1KJwSDbv8iliIdTxx2
        TA3xjA34eSjgzk7KD6VwS4HyCCswD7Co3+LKvQc=
X-Google-Smtp-Source: ABdhPJyu6X9WsZWORN2UOxa5XsxOWtYz/s7oZ1sB/2kxB204aN6CUmy6sAFqeT/NuDU/UphlBBt0ssJTs6NraAsRDJU=
X-Received: by 2002:a2e:3515:: with SMTP id z21mr2142470ljz.250.1626328175946;
 Wed, 14 Jul 2021 22:49:35 -0700 (PDT)
MIME-Version: 1.0
References: <CA+-xGqNUX4dpzFV7coJSoJnPz6cE5gdPy1kzRKsQtGD371hyEg@mail.gmail.com>
 <d79db3d7c443f392f5a8b3cf631e5607b72b6208.camel@redhat.com>
 <CA+-xGqOdu1rjhkG0FhxfzF1N1Uiq+z0b3MBJ=sjuVStHP5TBKg@mail.gmail.com>
 <d95d40428ec07ee07e7c583a383d5f324f89686a.camel@redhat.com>
 <YOxYM+8qCIyV+rTJ@google.com> <CA+-xGqOSd0yhU4fEcobf3tW0mLb0TmLGycTwXNVUteyvvnXjdw@mail.gmail.com>
 <YO8jPvScgCmtj0JP@google.com>
In-Reply-To: <YO8jPvScgCmtj0JP@google.com>
From:   harry harry <hiharryharryharry@gmail.com>
Date:   Thu, 15 Jul 2021 00:49:34 -0500
Message-ID: <CA+-xGqOkH-hU1guGx=t-qtjsRdO92oX+8HhcO1eXnCigMc+NPw@mail.gmail.com>
Subject: Re: About two-dimensional page translation (e.g., Intel EPT) and
 shadow page table in Linux QEMU/KVM
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, stefanha@redhat.com,
        mathieu.tarral@protonmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

> No, each vCPU has its own MMU instance, where an "MMU instance" is (mostly) a KVM
> construct.  Per-vCPU MMU instances are necessary because each vCPU has its own
> relevant state, e.g. CR0, CR4, EFER, etc..., that affects the MMU instance in
> some way.  E.g. the MMU instance is used to walk guest page tables when
> translating GVA->GPA for emulation, so per-vCPU MMUs are necessary even when
> using TDP.
>
> However, shadow/TDP PTEs are shared between compatible MMU instances.  E.g. in
> the common case where all vCPUs in a VM use identical settings, there will
> effectively be a single set of TDP page tables shared by all vCPUs.

What do you mean by "MMU instance"? Do you mean VMCS? MMU is hardware.
Could you please share me the code of the MMU instance in KVM? Thanks!

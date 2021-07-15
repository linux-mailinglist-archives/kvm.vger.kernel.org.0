Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4935A3CAF17
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 00:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbhGOW1Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 18:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbhGOW1X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jul 2021 18:27:23 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7474C06175F
        for <kvm@vger.kernel.org>; Thu, 15 Jul 2021 15:24:28 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id 17so6950108pfz.4
        for <kvm@vger.kernel.org>; Thu, 15 Jul 2021 15:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2lQDk68Sg2ZcVfZoZUpcNk+B0eVf8vhZQYIFh/6ss3c=;
        b=oxwBnn1jSOaB6+KZAq7l+6dV6lmn2zeQyJ69rrNgm+dKEY+pzQZQ62yxFpf4m1G6jZ
         itXUe2AvaJ3SumTdAArdH6qy5jsvFVDJs4Y4bDQd4AmRsjm6B91BUyMlAzMREMJ4FHaF
         db9GBUCph88kknuQbH2as6UB+FBPUUw+gZvaxvBmVXB1wGIIx0yXcNpbcFcgkt38SRCE
         z+jxc8mxLxiRViX62tml0U7r8ArkYPlLX24ZLdL4gZdPgC5+T3MUp67jotAGqw0RLpHN
         1YxSy2VL0OZjwMW3L5nB4tEdYn2NmOBmvWkomOyxF8kyicvBWkoiLYbJs0qC9J4Klevv
         UGxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2lQDk68Sg2ZcVfZoZUpcNk+B0eVf8vhZQYIFh/6ss3c=;
        b=VWF+76t33W8tvNOhRE8OsITa+FYlBh6tIkfw/OrvpdfiAHx82Nh5Kh7IuzmLiIID7i
         8ESfDdfxWFr0+XkS1mZ4yIk+Mi37o+NeKyDc+7hyrTOOpbm405SpAIRK9BhNwDAXT0MV
         sgkaPkGYGl2OX2wZHX0zHhroLOQ1mCQBcL1Gv7SDzyp3TIZtVgLycf/AZaRnQ9uTjGpl
         Pik9SoOgc30/emKoVtTJ4gkgq7itN3iwcYVRauCkPzTUxOWPk79tPwja91dHjY6N8P4D
         DIPRIhk0FsRC0ntwGahkOeDzWiGeRITfb0uHMu1lWIkLquqWomnmVyQGXykcv3iCzLKY
         Sq7Q==
X-Gm-Message-State: AOAM531lxH0v7pK+Qau2L79ejuRBSpoopxOTBHkghEOh5cH+BhdYG0TO
        QEXLaszn4rvvMElWt4xkPnfttg==
X-Google-Smtp-Source: ABdhPJzPCzT3r4sxyQ8lS3dX63H0wq99U0HEg0khmmtGLlGyV2wHrFFVp+loksaPbmyCezZbvpkHZA==
X-Received: by 2002:a63:2b91:: with SMTP id r139mr6606926pgr.242.1626387867089;
        Thu, 15 Jul 2021 15:24:27 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c7sm8073897pgq.22.2021.07.15.15.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 15:24:26 -0700 (PDT)
Date:   Thu, 15 Jul 2021 22:24:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     harry harry <hiharryharryharry@gmail.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, stefanha@redhat.com,
        mathieu.tarral@protonmail.com
Subject: Re: About two-dimensional page translation (e.g., Intel EPT) and
 shadow page table in Linux QEMU/KVM
Message-ID: <YPC1lgV5dZC0CyG0@google.com>
References: <CA+-xGqNUX4dpzFV7coJSoJnPz6cE5gdPy1kzRKsQtGD371hyEg@mail.gmail.com>
 <d79db3d7c443f392f5a8b3cf631e5607b72b6208.camel@redhat.com>
 <CA+-xGqOdu1rjhkG0FhxfzF1N1Uiq+z0b3MBJ=sjuVStHP5TBKg@mail.gmail.com>
 <d95d40428ec07ee07e7c583a383d5f324f89686a.camel@redhat.com>
 <YOxYM+8qCIyV+rTJ@google.com>
 <CA+-xGqOSd0yhU4fEcobf3tW0mLb0TmLGycTwXNVUteyvvnXjdw@mail.gmail.com>
 <YO8jPvScgCmtj0JP@google.com>
 <CA+-xGqOkH-hU1guGx=t-qtjsRdO92oX+8HhcO1eXnCigMc+NPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+-xGqOkH-hU1guGx=t-qtjsRdO92oX+8HhcO1eXnCigMc+NPw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 15, 2021, harry harry wrote:
> Hi Sean,
> 
> > No, each vCPU has its own MMU instance, where an "MMU instance" is (mostly) a KVM
> > construct.  Per-vCPU MMU instances are necessary because each vCPU has its own
> > relevant state, e.g. CR0, CR4, EFER, etc..., that affects the MMU instance in
> > some way.  E.g. the MMU instance is used to walk guest page tables when
> > translating GVA->GPA for emulation, so per-vCPU MMUs are necessary even when
> > using TDP.
> >
> > However, shadow/TDP PTEs are shared between compatible MMU instances.  E.g. in
> > the common case where all vCPUs in a VM use identical settings, there will
> > effectively be a single set of TDP page tables shared by all vCPUs.
> 
> What do you mean by "MMU instance"? Do you mean VMCS? MMU is hardware.

No, an MMU is not a hardware-exclusive term, e.g. a software emulator will have
an MMU to emulate the MMU of the target hardware.

The terminology we use in KVM is roughly that a KVM MMU is KVM's presentation of
a hardware MMU to the guest.  E.g. when shadow paging is used, there is both the
hardware MMU that is stuffed with KVM's shadow PTEs, and the KVM MMU that models
the guest's MMU (the guest thinks its configuring a hardware MMU, but in reality
KVM is intercepting (some) guest PTE modifications).  When TDP (EPT) is used, the
hardware MMU has two parts: the TDP PTEs that are controlled by KVM, and the IA32
PTEs that are controlled by the guest.  And there's still a KVM MMU for the guest;
the KVM MMU in that case knows how to connfigure the TDP PTEs in hardware _and_
walk the guest IA32 PTEs, e.g. to handle memory accesses during emulation.

Even more fun, when nested TDP is used, there is a KVM MMU for L1, a KVM MMU for
L1's EPT for L2, a KVM MMU for L2 (L2's legacy page tables), and the hardware MMU.

> Could you please share me the code of the MMU instance in KVM? Thanks!

struct kvm_mmu, and generally speaking everything under arch/x86/kvm/mmu/.

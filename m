Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01073D964F
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 22:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbhG1UB0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 16:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbhG1UBZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 16:01:25 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D869FC061757
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 13:01:23 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id t3so1955013plg.9
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 13:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5V+3TulVXEpX/pMbaAYmxkuA071az55HT2aQQNzw7t0=;
        b=bSKcByMzvPLm7BSPPR3H4n9NyxqF2iNg0oXrCBrVhce4Nj84UHSbEY4rlJDSPmi3Xn
         phpRFe23OLEKyIkQ4gCWRzrAYct0IyodFdLq37IJJ8yU9hydxE7+JeWLzAFyfj6sPBTw
         7FK+4crJwWQlDIxQeTx05qLAyG06knq0293gXfCAo/DpDspwvYzGbAU/DeLfHMKhDYCB
         9xvuMP9kLkMD8Ni/k3UI10v7uMFFOtJLCs2BWkj4jmLyKxg7gtI+lv7fB9nTBk8n49EY
         xSCKZwFW2XDobOHIaqIqb0xcD3Rxc9u//VjGhZyYHzXBoMit6hvGqsba2KwLP+OOIknA
         W8gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5V+3TulVXEpX/pMbaAYmxkuA071az55HT2aQQNzw7t0=;
        b=IT+3BHVUKoBt8lNJQCi+YplkJHQdc27rHHyBDsVWI9Kw8SdFUYg9MdvpJY6nR/+kp9
         HYjVIWwzFx2Oo11c0vJJrLoz8OCa7BI2wTSNTx22jRpH9xodnjaet6c8wtMRmCfwpfPH
         2nc6TkjzA5tGUwJWqACPkhkRsds9XQcIzXLIG6N0RUOUC1sgK05K104NFu75ZpLfBiED
         pBQ6pFJ6kv1NaaMnVTYrOgLozBruqPgRkPK59VnOY4rW+xJZE9dqqsOqkh0VjnJzvLkT
         B0HJVLm4C2e72l8rB8RNu/pqNy/SBfdQ5lxsNZ0MG8EF/eficyEcdGG/ABAB03ab3bDn
         fkFw==
X-Gm-Message-State: AOAM530xHA+nsqa2QNCIwmH+U4I5/UOFiXM8pBsKWm62Y2yhT8Ds3Il5
        P84xTY1jrJ1EqlGKdOghOnWFyyPuRjrg6A==
X-Google-Smtp-Source: ABdhPJzOYCEbSuawoSYEZLeDPr383fnT41sSJYHqTkot1VEMVQ+3sJU9slGWbeKrG6TyJvglvWdlIg==
X-Received: by 2002:a63:5f87:: with SMTP id t129mr541168pgb.85.1627502483188;
        Wed, 28 Jul 2021 13:01:23 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b184sm856993pfg.72.2021.07.28.13.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 13:01:22 -0700 (PDT)
Date:   Wed, 28 Jul 2021 20:01:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     harry harry <hiharryharryharry@gmail.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, stefanha@redhat.com,
        mathieu.tarral@protonmail.com
Subject: Re: About two-dimensional page translation (e.g., Intel EPT) and
 shadow page table in Linux QEMU/KVM
Message-ID: <YQG3jg9kSqfzmbPB@google.com>
References: <CA+-xGqOdu1rjhkG0FhxfzF1N1Uiq+z0b3MBJ=sjuVStHP5TBKg@mail.gmail.com>
 <d95d40428ec07ee07e7c583a383d5f324f89686a.camel@redhat.com>
 <YOxYM+8qCIyV+rTJ@google.com>
 <CA+-xGqOSd0yhU4fEcobf3tW0mLb0TmLGycTwXNVUteyvvnXjdw@mail.gmail.com>
 <YO8jPvScgCmtj0JP@google.com>
 <CA+-xGqOkH-hU1guGx=t-qtjsRdO92oX+8HhcO1eXnCigMc+NPw@mail.gmail.com>
 <YPC1lgV5dZC0CyG0@google.com>
 <CA+-xGqN75O37cr9uh++dyPj57tKcYm0fD=+-GBErki8nGNcemQ@mail.gmail.com>
 <YPiLBLA2IjwovNCP@google.com>
 <CA+-xGqP7=m47cLD65DhTumOF8+sWZvc81gh+04aKMS56WWkVtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+-xGqP7=m47cLD65DhTumOF8+sWZvc81gh+04aKMS56WWkVtA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021, harry harry wrote:
> Sean, sorry for the late reply. Thanks for your careful explanations.
> 
> > For emulation of any instruction/flow that starts with a guest virtual address.
> > On Intel CPUs, that includes quite literally any "full" instruction emulation,
> > since KVM needs to translate CS:RIP to a guest physical address in order to fetch
> > the guest's code stream.  KVM can't avoid "full" emulation unless the guest is
> > heavily enlightened, e.g. to avoid string I/O, among many other things.
> 
> Do you mean the emulated MMU is needed when it *only* wants to
> translate GVAs to GPAs in the guest level?

Not quite, though gva_to_gpa() is the main use.  The emulated MMU is also used to
inject guest #PF and to load/store guest PDTPRs.  

> In such cases, the hardware MMU cannot be used because hardware MMU
> can only translate GVAs to HPAs, right?

Sort of.  The hardware MMU does translate GVA to GPA, but the GPA value is not
visible to software (unless the GPA->HPA translation faults).  That's also true
for VA to PA (and GVA to HPA).  Irrespective of virtualization, x86 ISA doesn't
provide an instruction to retrive the PA for a given VA.

If such an instruction did exist, and it was to be usable for a VMM to do a
GVA->GPA translation, the magic instruction would need to take all MMU params as
operands, e.g. CR0, CR3, CR4, and EFER.  When KVM is active (not the guest), the
hardware MMU is loaded with the host MMU configuration, not the guest.  In both
VMX and SVM, vCPU state is mostly ephemeral in the sense that it ceases to exist
in hardware when the vCPU exits to the host.  Some state is retained in hardware,
e.g. TLB and cache entries, but those are associated with select properties of
the vCPU, e.g. EPTP, CR3, etc..., not with the vCPU itself, i.e. not with the
VMCS (VMX) / VMCB (SVM).

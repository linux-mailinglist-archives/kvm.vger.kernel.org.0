Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD3E25C848
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 19:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgICR6M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 13:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbgICR6L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 13:58:11 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07615C061244
        for <kvm@vger.kernel.org>; Thu,  3 Sep 2020 10:58:10 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id y5so3525982otg.5
        for <kvm@vger.kernel.org>; Thu, 03 Sep 2020 10:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R7ZL8pTZbj4JiHniG1B9lUVGN1DSqomiXYlNdiGH0zI=;
        b=VJ/LoYWgjxcPKdh3qVWyDDMIR2oPoCRxoVXtgB2kLRI3RdpBQrAHXT2TM0WA0Y+ns6
         hy7M151o0a/Z2WK5PFoc+5HzHc1J7u2M7jMZC3m1875Ew02+6wBINxncBe1uv8gpCKNs
         u8aXYBf1U91KlLHKBCkSdNIPPFFavY9fr3P6vVNGI936lxJxwLkLZ7oVbaplpMZmoRTD
         mGp4xT6Me1FA0RLIIOhaeoNYp6P3eYaU2366hHzgrmgM63DuZKcUmYp05uyWulSe7HYo
         usQnnU23yce9b8IwnyCODAnkJaeI/1o+khG9cN4rghPQtk5tZigaOLFWG6lbqaUhLF4u
         00kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R7ZL8pTZbj4JiHniG1B9lUVGN1DSqomiXYlNdiGH0zI=;
        b=JOTNXWTxOBz1vK/fqnhnZNEZkWabVI6eMI016lvJCZI2S6f3L7Nyi2iPfO0KUgJbbw
         6DkxApvORwsZZpJqINkFw5CthlNSbonm8Vhe2vXET7ZkhBEHLeiVcbU84vooLCZfkput
         MXjJG3wYZu33wmC6YuIKdbhVIMZwVMYVUwZQ3Ct+GeJyy0TQ69cFaPlTtlfvz2NP/SJq
         6JnPk0JpRS8l9AA+1kCAmAzvVU+jHKVv70Yks1wrMXuv/Orrn7/ERISZcwTJNkW8EoiN
         0P3vvdalZYhxxtYOiZGvkrZYfcBHNRqNIcKX0h2ZHOs1UFyt1OAbU55R5R8eOE1MKXWE
         yreQ==
X-Gm-Message-State: AOAM531vxoQ+Ng6vCU3JKTZUFA7yMCLyhTTcDWhbkp4PpUXWu0dOvLje
        p0DOQdU2XxOdU8OsCqFHZw1qSiNkPJiWFBA6ZA0P5Q==
X-Google-Smtp-Source: ABdhPJyFWBT9j5hFf9r5pcOgceu17AyR9gOLouFVVzWPvUtc/tAKFK4iiifRwJDL0FxA8g7h7oZ+5bsvB9YSHNT9BCU=
X-Received: by 2002:a05:6830:18ca:: with SMTP id v10mr2589170ote.295.1599155890126;
 Thu, 03 Sep 2020 10:58:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200903141122.72908-1-mgamal@redhat.com>
In-Reply-To: <20200903141122.72908-1-mgamal@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 3 Sep 2020 10:57:58 -0700
Message-ID: <CALMp9eTrc8_z3pKBtLVmbnMvC+KtzXMYbYTXZPPz5F0UWW8oNQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: VMX: Make smaller physical guest address space
 support user-configurable
To:     Mohammed Gamal <mgamal@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 3, 2020 at 7:12 AM Mohammed Gamal <mgamal@redhat.com> wrote:
>
> This patch exposes allow_smaller_maxphyaddr to the user as a module parameter.
>
> Since smaller physical address spaces are only supported on VMX, the parameter
> is only exposed in the kvm_intel module.
> Modifications to VMX page fault and EPT violation handling will depend on whether
> that parameter is enabled.
>
> Also disable support by default, and let the user decide if they want to enable
> it.
>
> Signed-off-by: Mohammed Gamal <mgamal@redhat.com>

I think a smaller guest physical address width *should* be allowed.
However, perhaps the pedantic adherence to the architectural
specification could be turned on or off per-VM? And, if we're going to
be pedantic, I think we should go all the way and get MOV-to-CR3
correct.

Does the typical guest care about whether or not setting any of the
bits 51:46 in a PFN results in a fault?

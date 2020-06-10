Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5AE1F59C4
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 19:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbgFJRLy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 13:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728336AbgFJRLx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 13:11:53 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD0BC03E96F
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 10:11:52 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id q8so3089515iow.7
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 10:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SbsE0+B0P8frLwxQJdTPZKfsaWPnfG0PYAG3BHter6I=;
        b=nHFMyDoX1ZRneSZnzjWlUSdmZCxhP8i2hwnyouel/90ri5jqN6XXyPfjtdeokytvZo
         FG7EOchl6gbjtmYsQDyxVG3SV1uVo9MHQtIoJADI3/aaBJByFTanhFJXFBWr7PIafOCu
         V1Kl/FEUatLNd+J6d+Sdm2KAg/h+Ud4nXqTiUhq9TdwgAtDfP8IK+m9Y/Hvtm2iVCjdQ
         6iRQr1DHqBml/HeJkQZPwogYzby/SthO1fN2Go7zKjsblnSkieqhUYuknRPHqwoDTMBG
         B/LF0+Rt4DXknqkAU2c4GnwH9JSR0txzTcJaFg3CmwtuCe9re6xV+tqy/IsXMaH7Lu8D
         PREA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SbsE0+B0P8frLwxQJdTPZKfsaWPnfG0PYAG3BHter6I=;
        b=PVON3+iF1xHT9GGDaBlf91AoKzZEDcFRMX3cli1xk63S3XnoiLd/+Smi6i9mmRIRDe
         a4rV3SdYZcUACYAAiDxo1LTM5Kw8yQtUaF0VmGxMURWHcif1UPci/B7jWH5dPA6MXJ+Y
         TNwrob9bIjaPRHc/PXL2kq8phk5MSdhmeOD1GRsm63qCQX0gC0pTzedMJ8rcFAG2dW0G
         cDuW/6gjzzJIlLeqQ5oPJvnJjbxG1+oNiSiQ14zqWB0CgZwlTLA6BtNGzgOwowXm8+jR
         bxS+QgVIQxQRg8EiU8pHBaJIoe2B9SPkcabGoUyBRofaApsCkFGLba4nmxQ/XfSeUiNW
         OTsw==
X-Gm-Message-State: AOAM531Yt1PXGANjzQV53yBJcC57Rr1KsBsD4G4u5syG2ia2UlXmDFQF
        6fYDmlboRTFmTgQhh9MV9Po6qPAWaA+Gk2DHu+KErA==
X-Google-Smtp-Source: ABdhPJzay3APGt06fR9CIbahbDWXLVT+dG8MV0BfB+m73PiOwK29ACp9wDlNtEBpmgVkosGrs1ejTIdn9AMF70xCpsQ=
X-Received: by 2002:a02:ce56:: with SMTP id y22mr4098658jar.18.1591809110794;
 Wed, 10 Jun 2020 10:11:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200610164116.770811-1-vkuznets@redhat.com>
In-Reply-To: <20200610164116.770811-1-vkuznets@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 10 Jun 2020 10:11:38 -0700
Message-ID: <CALMp9eRzMC=6hFUeDP9V_CnJ29EbrC6KzWNXzbAsq7Uqqr=f6g@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: fix sync_with_host() in smm_test
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Marcelo Bandeira Condotta <mcondotta@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 10, 2020 at 9:41 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> It was reported that older GCCs compile smm_test in a way that breaks
> it completely:
>
>   kvm_exit:             reason EXIT_CPUID rip 0x4014db info 0 0
>   func 7ffffffd idx 830 rax 0 rbx 0 rcx 0 rdx 0, cpuid entry not found
>   ...
>   kvm_exit:             reason EXIT_MSR rip 0x40abd9 info 0 0
>   kvm_msr:              msr_read 487 = 0x0 (#GP)
>   ...
>
> Note, '7ffffffd' was supposed to be '80000001' as we're checking for
> SVM. Dropping '-O2' from compiler flags help. Turns out, asm block in
> sync_with_host() is wrong. We us 'in 0xe, %%al' instruction to sync
> with the host and in 'AL' register we actually pass the parameter
> (stage) but after sync 'AL' gets written to but GCC thinks the value
> is still there and uses it to compute 'EAX' for 'cpuid'.

That smells like VMware's hypercall madness!

> smm_test can't fully use standard ucall() framework as we need to
> write a very simple SMI handler there. Fix the immediate issue by
> making RAX input/output operand. While on it, make sync_with_host()
> static inline.
>
> Reported-by: Marcelo Bandeira Condotta <mcondotta@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>

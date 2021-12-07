Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646E346C6B1
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 22:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbhLGVbk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 16:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232971AbhLGVbj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 16:31:39 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8FEC061746
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 13:28:08 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id e11so503347ljo.13
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 13:28:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CXomiDWCuNQ6gJYE5Et4P54uUCBaEQ8u4XJdHj07maM=;
        b=bKX3DeWIdFkRBxNQYZbdFrV3QYV130tjpn8D4leN4i8yq79IgbkX+gPHPsucn5n0vo
         DSJVLa0GBvCs+aV/cwsQBvTLojNU7SN5XajhI8zKfyAO1qqV90qvPfJXjj2Rz0ufOkbS
         /In5sJ8v0EZzJZhAe55jg1Ldxb2fYZMusCpM70TlhdNn2LF2oLLzTZoB5z4ZjitA1dEj
         O9IaWv2kfTk3GxaCjo6MCDH71wXnjTBdUoulCG+bJTOAAqS1kgWQzNxmHppZ0ZoYA6Wk
         lQKq+JO16J0WR2QgH4eGp244vK3xxfdvplzbR1jTKtb//hMvUXc+ZaPh4uAPj8KLIz9z
         vgmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CXomiDWCuNQ6gJYE5Et4P54uUCBaEQ8u4XJdHj07maM=;
        b=QoxTY5nLT2gkH2EFHvXrCihF7Uts6O7Rs+wjoKjapUDJMrXrDyVJqUgxYXtz0riBE4
         wM8UNFVM6HewwWthR1G12V1j04oSLBr89zpDZy28ClOd9az+BuAXyGmHNc3WHFEZSUAR
         nRyCdZwyObkh+gGQeiXJcI7Yc/Fk6AxzTqmssjXpa0I2ZtFfh5j5+BfZ/WV8IH8P9K9/
         fSHLKqzIRjbnkr9tvvtNvVjrne82ogucv0OwWeI6UzS2fSaUtvQsdloz8hOO3JtrY818
         gT2+bnosQQ0sDsFPtJGK6wDeu/PWe6k1laEEjONPlV2lFgBK6l7fEn98dYhfiXTrFYwP
         k1zw==
X-Gm-Message-State: AOAM531FTJRTnI8Cmyxu6ajAbyWd89/AfBLXL76cb3B8PYzHkuGsGLzh
        sYbQxuOb46ix/lE1AsPLDLrhl74SikKhOpVZDLuq6A==
X-Google-Smtp-Source: ABdhPJwAMV4Mof6EKI9oYdGZZgVcPctfqy2/zHuWwJfj5fRlrUDwbQWRmFBQ6+bP3kNo+v56Xe9A/oT6YIHXyEUjBaE=
X-Received: by 2002:a2e:7807:: with SMTP id t7mr43113018ljc.426.1638912486674;
 Tue, 07 Dec 2021 13:28:06 -0800 (PST)
MIME-Version: 1.0
References: <20211207201034.1392660-1-pgonda@google.com> <Ya/RJiTOQjJ+fj73@google.com>
In-Reply-To: <Ya/RJiTOQjJ+fj73@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 7 Dec 2021 14:27:55 -0700
Message-ID: <CAMkAt6qy+F_QH-Uhc7mLPD9bitmCEAjZYZeqguwAgMsX1e39Og@mail.gmail.com>
Subject: Re: [PATCH] selftests: sev_migrate_tests: Fix sev_ioctl()
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Orr <marcorr@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 7, 2021 at 2:25 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Dec 07, 2021, Peter Gonda wrote:
> > TEST_ASSERT in SEV ioctl was allowing errors because it checked return
> > value was good OR the FW error code was OK. This TEST_ASSERT should
> > require both (aka. AND) values are OK. Removes the LAUNCH_START from the
> > mirror VM because this call correctly fails because mirror VMs cannot
> > call this command.
>
> This probably should be two separate patches.  First remove the bogus LAUNCH_START
> call, then fix the assert.

Thanks Sean. I'll split the patch and add your suggestion to the second one.

>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: Marc Orr <marcorr@google.com>
> > Signed-off-by: Peter Gonda <pgonda@google.com>
> > ---
> >  tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c | 7 ++-----
> >  1 file changed, 2 insertions(+), 5 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> > index 29b18d565cf4..8e1b1e737cb1 100644
> > --- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> > +++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> > @@ -31,7 +31,7 @@ static void sev_ioctl(int vm_fd, int cmd_id, void *data)
> >       int ret;
> >
> >       ret = ioctl(vm_fd, KVM_MEMORY_ENCRYPT_OP, &cmd);
> > -     TEST_ASSERT((ret == 0 || cmd.error == SEV_RET_SUCCESS),
> > +     TEST_ASSERT(ret == 0 && cmd.error == SEV_RET_SUCCESS,
> >                   "%d failed: return code: %d, errno: %d, fw error: %d",
> >                   cmd_id, ret, errno, cmd.error);
>
> Hmm, reading cmd.error could also consume uninitialized data, e.g. if the ioctl()
> fails before getting into the PSP command, the error message will dump garbage.
>
> And theoretically this could get a false negative if the test stack happens to have
> '0' for cmd.error and KVM neglects to fill cmd.error when the ioctl() succeeds.
>
> So in additional to fixing the assert itself, I vote we also do:
>
> diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> index 29b18d565cf4..50132e165a8d 100644
> --- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> +++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> @@ -26,6 +26,7 @@ static void sev_ioctl(int vm_fd, int cmd_id, void *data)
>         struct kvm_sev_cmd cmd = {
>                 .id = cmd_id,
>                 .data = (uint64_t)data,
> +               .error = -1u,
>                 .sev_fd = open_sev_dev_path_or_exit(),
>         };
>         int ret;

Good idea will do in the 2/2.

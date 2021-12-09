Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2BB46E21D
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 06:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbhLIFs4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 00:48:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbhLIFsy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 00:48:54 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F09C061746
        for <kvm@vger.kernel.org>; Wed,  8 Dec 2021 21:45:21 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id 35-20020a9d08a6000000b00579cd5e605eso5178231otf.0
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 21:45:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jPO824oWCqCAIylGScuHcjXuh3MiVM0SEMprq9fJc/Y=;
        b=WMzwG7UOLY4168mrKFiRMptFiXBJl+31LJ0dy3IJIMLhcM6bcR8SqPSdxrJsJBRpMI
         F0hMwJNaZkk38qgLWETeaM68s1XFZ73xPJQlTW/Vlub5Ovu9YX5G5Beh140447JM5CIh
         OzVMeJPZdFD6EVQswHE1L0PAt5DSPIJsxdbnJczYskmIIRSe2lk8tcrWzuZ2I69TkP40
         9Br9vXC9cfxCamf6orYvfu8oJ5kYfF++uesT0JK4/xRl59q6XWyfdnfFZKte35AJ5ybJ
         WbOQzjZWy2XTr1aLIxF4Z7eb5vR+Hl1rKB37LaMs8uDtv/0AGfeI2fPprEm5uOdaVxa9
         6zVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jPO824oWCqCAIylGScuHcjXuh3MiVM0SEMprq9fJc/Y=;
        b=FIHK+oOBudexQJzhX46M7bmx266vIaSH7WDr5iojr9DsqGWQdzktTKYihES2uboEI7
         sncloPxPiXsZadhB9bDes31EvJ8/JmVoeWqxnhYRj4B5pR4ke7JCroN+g+uFaPYxxv2y
         TQ/dnQBhRADnIyBATrXebXDWgVJZiIFcf7aV6Mj+tX26qD0Dix4XcFxJ8V7xg1GuDmLj
         rjgJ19tNO6sJJ642OznQCTZmUVrtAc42WazRTZ6Vv5hdQ7cbL3Fdk5EEOXB1p1p/zXWK
         hKltzmC6JLwx5CzyWuhFOvw79C3TrgxSmcCf0f8NtNQskVjEOm2VXmH92C5L1cQVy9X/
         uH8A==
X-Gm-Message-State: AOAM531Z+3d82XVNSLk7p//yrAuoEv1jg6kn03zxIsllXmWTq524Eb7h
        ZNagP8xQ9ek6pMjbaeuB1O98ifOEv5Fzvn3DjRrhcA==
X-Google-Smtp-Source: ABdhPJyEb3+1aoSxlf1ofj1Dity6vMLR7eXtunxwDH83OfJkfcr7Q5xflQstjPI17uGGO1g1ACIGNW84/t9UOIqkumU=
X-Received: by 2002:a9d:ed6:: with SMTP id 80mr3657304otj.35.1639028721086;
 Wed, 08 Dec 2021 21:45:21 -0800 (PST)
MIME-Version: 1.0
References: <20211208191642.3792819-1-pgonda@google.com> <20211208191642.3792819-3-pgonda@google.com>
In-Reply-To: <20211208191642.3792819-3-pgonda@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Wed, 8 Dec 2021 21:45:09 -0800
Message-ID: <CAA03e5EX7NtaPvMo=xz0t3rEGCvDfeRUW9J-5pPVPicS1T5w8A@mail.gmail.com>
Subject: Re: [PATCH 2/3] selftests: sev_migrate_tests: Fix sev_ioctl()
To:     Peter Gonda <pgonda@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 8, 2021 at 11:16 AM Peter Gonda <pgonda@google.com> wrote:
>
> TEST_ASSERT in SEV ioctl was allowing errors because it checked return
> value was good OR the FW error code was OK. This TEST_ASSERT should
> require both (aka. AND) values are OK. Removes the LAUNCH_START from the
> mirror VM because this call correctly fails because mirror VMs cannot
> call this command. Currently issues with the PSP driver functions mean

This commit description is now stale. The previous patch removes the
LAUNCH_START -- not this patch.

> the firmware error is not always reset to SEV_RET_SUCCESS when a call is
> successful. Mainly sev_platform_init() doesn't correctly set the fw
> error if the platform has already been initialized.
>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Marc Orr <marcorr@google.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> ---
>  tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> index fbc742b42145..4bb960ca6486 100644
> --- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> +++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> @@ -30,8 +30,9 @@ static void sev_ioctl(int vm_fd, int cmd_id, void *data)
>         };
>         int ret;
>
> +

nit: Looks like you picked up an extra new line. Since you need to
fixup the commit description, let's fix this up too.

>         ret = ioctl(vm_fd, KVM_MEMORY_ENCRYPT_OP, &cmd);
> -       TEST_ASSERT((ret == 0 || cmd.error == SEV_RET_SUCCESS),
> +       TEST_ASSERT(ret == 0 && cmd.error == SEV_RET_SUCCESS,
>                     "%d failed: return code: %d, errno: %d, fw error: %d",
>                     cmd_id, ret, errno, cmd.error);
>  }
> --
> 2.34.1.400.ga245620fadb-goog
>

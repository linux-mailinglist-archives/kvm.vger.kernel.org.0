Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B502846E232
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 06:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbhLIF5K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 00:57:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhLIF5J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 00:57:09 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE2FC0617A1
        for <kvm@vger.kernel.org>; Wed,  8 Dec 2021 21:53:36 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id 35-20020a9d08a6000000b00579cd5e605eso5192640otf.0
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 21:53:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n17CfDjkfVu1x0A2zg/wbnx62qbr1TlYzDoDW7maqgM=;
        b=BGxKtZWLm9X8tukgLULrnrgzzuYmOH3Lm3z4cFC/ithx5Do/8r6DEv/dZGvCIVDzUa
         pMAiZ+u1J8JyUrIQVVxFDQO/vSlGNxHRd6JPkqE0a9N5VG9d0d2D7Lez+QVWffs1FB9f
         cd+4gWsBTa4MRDnf8UYWcMYP/Jmrp30+Cg60J1VjFEa4SKfYTtYLq0Fr42LTOlLdI7Lj
         ZTzFU0MbgGJmf+30j9R2FpXPSPD0Vre59NJgNjcVGWtFGe9p2ogsU0M9M1c5/4fgbGVU
         +zBLnvwkGMIE05TkimwOGZcARqpGumwAHaWOxA92Qy71YO6olYgYrAdPYUf4hb72fZMr
         1+ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n17CfDjkfVu1x0A2zg/wbnx62qbr1TlYzDoDW7maqgM=;
        b=IkmM9TdN3wmJ7UhCCfhGAXZaESMqvR1UCvypSb4nBgKubdBniTiOyv0p19fTuy4TN7
         jhM1du6X4DMN4GUPcgs+BGQXTfJvSOsf42b0BGd03+saZfRpgjLSj7qotelF5YamgoDz
         /2MWhtmaixqtG+pWqCn4Q8FkliSTZzydtrvwAC38LkevrSxsVzsHCt6QXzyhpjcl5sc/
         JgVez36QcasR0S5O3gzq+bXLo//+cvYz8cL5DXQ+URnx0fajDSlhvxZlSAYGptj1+tCY
         BSAK9XWLrmXeB4oBq+Mi7d+4RD2Wn7hIQ/c10hwHfsyX5hQMv9mLiIEPocsiVOT9zOOz
         GQfw==
X-Gm-Message-State: AOAM5315yu4w7vAVKrz5VoCwqfHDS1lZe89ufq+yH0t1QoIftyxWh6Vs
        HAGIydraZOl7P1pumRAO+5rmzecYig16phtdQB7upA==
X-Google-Smtp-Source: ABdhPJyafxz4N1Yt1dER7ZAjF/Xyv4Biy1XVnYWlMNPW6NSIkD6ZBaHO6FfdJtHuCY1sHUNKXyuGzxG+Xb+JJT285QI=
X-Received: by 2002:a9d:ed6:: with SMTP id 80mr3678667otj.35.1639029216036;
 Wed, 08 Dec 2021 21:53:36 -0800 (PST)
MIME-Version: 1.0
References: <20211208191642.3792819-1-pgonda@google.com> <20211208191642.3792819-4-pgonda@google.com>
In-Reply-To: <20211208191642.3792819-4-pgonda@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Wed, 8 Dec 2021 21:53:25 -0800
Message-ID: <CAA03e5H6TxcL6WVYcBs5aX5zHLB=sCYcrBLggAtmLZADn_BHyA@mail.gmail.com>
Subject: Re: [PATCH 3/3] selftests: sev_migrate_tests: Add mirror command tests
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
> Add tests to confirm mirror vms can only run correct subset of commands.
>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Marc Orr <marcorr@google.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> ---
>  .../selftests/kvm/x86_64/sev_migrate_tests.c  | 55 +++++++++++++++++--
>  1 file changed, 51 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> index 4bb960ca6486..80056bbbb003 100644
> --- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> +++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> @@ -21,7 +21,7 @@
>  #define NR_LOCK_TESTING_THREADS 3
>  #define NR_LOCK_TESTING_ITERATIONS 10000
>
> -static void sev_ioctl(int vm_fd, int cmd_id, void *data)
> +static int __sev_ioctl(int vm_fd, int cmd_id, void *data, __u32 *fw_error)
>  {
>         struct kvm_sev_cmd cmd = {
>                 .id = cmd_id,
> @@ -30,11 +30,20 @@ static void sev_ioctl(int vm_fd, int cmd_id, void *data)
>         };
>         int ret;
>
> -
>         ret = ioctl(vm_fd, KVM_MEMORY_ENCRYPT_OP, &cmd);
> -       TEST_ASSERT(ret == 0 && cmd.error == SEV_RET_SUCCESS,
> +       *fw_error = cmd.error;
> +       return ret;
> +}
> +
> +static void sev_ioctl(int vm_fd, int cmd_id, void *data)
> +{
> +       int ret;
> +       __u32 fw_error;
> +
> +       ret = __sev_ioctl(vm_fd, cmd_id, data, &fw_error);
> +       TEST_ASSERT(ret == 0 && fw_error == SEV_RET_SUCCESS,
>                     "%d failed: return code: %d, errno: %d, fw error: %d",
> -                   cmd_id, ret, errno, cmd.error);
> +                   cmd_id, ret, errno, fw_error);
>  }
>
>  static struct kvm_vm *sev_vm_create(bool es)
> @@ -226,6 +235,42 @@ static void sev_mirror_create(int dst_fd, int src_fd)
>         TEST_ASSERT(!ret, "Copying context failed, ret: %d, errno: %d\n", ret, errno);
>  }
>
> +static void verify_mirror_allowed_cmds(int vm_fd)
> +{
> +       struct kvm_sev_guest_status status;
> +
> +       for (int cmd_id = KVM_SEV_INIT; cmd_id < KVM_SEV_NR_MAX; ++cmd_id) {
> +               int ret;
> +               __u32 fw_error;
> +
> +               /*
> +                * These commands are allowed for mirror VMs, all others are
> +                * not.
> +                */
> +               switch (cmd_id) {
> +               case KVM_SEV_LAUNCH_UPDATE_VMSA:
> +               case KVM_SEV_GUEST_STATUS:
> +               case KVM_SEV_DBG_DECRYPT:
> +               case KVM_SEV_DBG_ENCRYPT:
> +                       continue;
> +               default:
> +                       break;
> +               }
> +
> +               /*
> +                * These commands should be disallowed before the data
> +                * parameter is examined so NULL is OK here.
> +                */
> +               ret = __sev_ioctl(vm_fd, cmd_id, NULL, &fw_error);
> +               TEST_ASSERT(
> +                       ret == -1 && errno == EINVAL,
> +                       "Should not be able call command: %d. ret: %d, errno: %d\n",
> +                       cmd_id, ret, errno);
> +       }
> +
> +       sev_ioctl(vm_fd, KVM_SEV_GUEST_STATUS, &status);

Why is this here? I'd either delete it or maybe alternatively move it
into the `case KVM_SEV_GUEST_STATUS` with a corresponding TEST_ASSERT
to check that the command succeeded. Something like:

...
               switch (cmd_id) {
               case KVM_SEV_GUEST_STATUS:
                    sev_ioctl(vm_fd, KVM_SEV_GUEST_STATUS, &status);
                    TEST_ASSERT(ret == 0 && fw_error == SEV_RET_SUCCESS, ...);
                    continue;
               case KVM_SEV_LAUNCH_UPDATE_VMSA:
               case KVM_SEV_DBG_DECRYPT:
               case KVM_SEV_DBG_ENCRYPT:
                       continue;
               default:
                       break;
               }

> +}
> +
>  static void test_sev_mirror(bool es)
>  {
>         struct kvm_vm *src_vm, *dst_vm;
> @@ -243,6 +288,8 @@ static void test_sev_mirror(bool es)
>         if (es)
>                 sev_ioctl(dst_vm->fd, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL);
>
> +       verify_mirror_allowed_cmds(dst_vm->fd);
> +
>         kvm_vm_free(src_vm);
>         kvm_vm_free(dst_vm);
>  }
> --
> 2.34.1.400.ga245620fadb-goog
>

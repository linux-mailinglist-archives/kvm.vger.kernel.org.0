Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE555454B6A
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 17:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbhKQQzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 11:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhKQQzv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 11:55:51 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1C2C061570
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 08:52:52 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id c32so11660444lfv.4
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 08:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VOa3TesNpUFtajdDalCiYTG5enk9ovoBPDHsNu+qckc=;
        b=SrMusUwZx5MSEu0uVmPCdhpFlEJKv6X9Y6Gjhv4Io4+ktOwK14xzkMTh6dRTMQsYjM
         mK2RRNChjy882MF4REXCLLSedNxjfzznVfJK60BQLEkyzKcZa2i3IFOURcwMjwn6uu0W
         IgQxkU5NqtZJTOCnsBoJqTn0igdN2BFfKeeqKnPQ5m+gA/eB4t7ZJhDBhFczj6gK4Hfw
         RSpOtnfNqA8fE7uX/96tWQwTE53EuR7bbWM2/ojC79nUNXWTg4/iLPLyzZXd5TJ+1Ssk
         XEqUJDrzKXhhRx+YAOrz+AddzYkMrPUK020kijPZ/+iYor03Jdfs/ySZm4JkxOD8Az2Y
         K49w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VOa3TesNpUFtajdDalCiYTG5enk9ovoBPDHsNu+qckc=;
        b=ER8Z8J7m5HU9oK3m5fghrHwCJ2NACh9vDdiJrLp2gFxe32MaIXSpxkEu0TrJReParj
         jp7BtVHgZLECNg6FVUr8lM30tlvGnsdhFkjmNUYAxRMw1CuKhlCST8gsoM6kW905SiVw
         nlyUc26nNpWNz7LrZAwu4QARMTX5Mntg+BuOHeARMvi+6eV6mqOTggPdLud1svWG++BQ
         OS9URJbF/cIpFeoV4CrmMnca/G+vX36lCtsQPM5LogVbhKhNMpTo8F9Cwk+qr4pFFgEs
         hstqmws+3hd+BWlzStRsyQ+AmZnLcL0QK6Vi6iiER3dFZS1a0rzD/srGsD8KRPgrWc3L
         g2Ew==
X-Gm-Message-State: AOAM532PrUghj42CHOoMS2VjJeYxbiQKLJ60PPAMCdAo3arsosk6O6Ao
        IcxDg76Rr+7q0OiBbXKAkg7ipYDR4cLbxfP7bUYUW2Ug1zBPKg==
X-Google-Smtp-Source: ABdhPJwdD34HxiEUDjKYUrxzkQ4KxD1cL4JPta0cHUGmnmnzLyDl3GSvhBYwTctYp3bu7CnKAkF3tv4wTqYCynWOtwU=
X-Received: by 2002:a19:7902:: with SMTP id u2mr16553310lfc.644.1637167970168;
 Wed, 17 Nov 2021 08:52:50 -0800 (PST)
MIME-Version: 1.0
References: <20211117163809.1441845-1-pbonzini@redhat.com> <20211117163809.1441845-2-pbonzini@redhat.com>
In-Reply-To: <20211117163809.1441845-2-pbonzini@redhat.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Wed, 17 Nov 2021 09:52:38 -0700
Message-ID: <CAMkAt6q15oP9MwBDGabD5+wJWVevUVxOwYVCgzwGTi64syL-9g@mail.gmail.com>
Subject: Re: [PATCH 1/4] selftests: sev_migrate_tests: free all VMs
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I think we are still missing the kvm_vm_free() from
test_sev_migrate_locking(). Should we have this at the end?

for (i = 0; i < NR_LOCK_TESTING_THREADS; ++i)
    kvm_vm_free(input[i].vm);


On Wed, Nov 17, 2021 at 9:38 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Ensure that the ASID are freed promptly, which becomes more important
> when more tests are added to this file.
>
> Cc: Peter Gonda <pgonda@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> index 5ba325cd64bf..4a5d3728412b 100644
> --- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> +++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> @@ -162,7 +162,6 @@ static void test_sev_migrate_parameters(void)
>         sev_ioctl(sev_es_vm_no_vmsa->fd, KVM_SEV_ES_INIT, NULL);
>         vm_vcpu_add(sev_es_vm_no_vmsa, 1);
>
> -
>         ret = __sev_migrate_from(sev_vm->fd, sev_es_vm->fd);
>         TEST_ASSERT(
>                 ret == -1 && errno == EINVAL,
> @@ -191,6 +190,12 @@ static void test_sev_migrate_parameters(void)
>         TEST_ASSERT(ret == -1 && errno == EINVAL,
>                     "Migrations require SEV enabled. ret %d, errno: %d\n", ret,
>                     errno);
> +
> +       kvm_vm_free(sev_vm);
> +       kvm_vm_free(sev_es_vm);
> +       kvm_vm_free(sev_es_vm_no_vmsa);
> +       kvm_vm_free(vm_no_vcpu);
> +       kvm_vm_free(vm_no_sev);
>  }
>
>  int main(int argc, char *argv[])
> --
> 2.27.0
>
>

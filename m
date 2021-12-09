Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6250A46E219
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 06:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbhLIFrL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 00:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbhLIFrJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 00:47:09 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A098C0617A1
        for <kvm@vger.kernel.org>; Wed,  8 Dec 2021 21:43:36 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id i5-20020a05683033e500b0057a369ac614so5068076otu.10
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 21:43:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Au8cIAk26/MRJY9HsdbjV4w48DvK6VK2iUZHG3PEHHE=;
        b=r5r8wABEQsbS2wVZ9VLdVuOogMqmvTq/REBY7p+otznPODfbDRicJbpwQQPCGOTtnK
         b2HLjAl25N6mnCGUzeTIF4J3eQRr4Z9nHgjTxifgxSXeYTrmAeJDK+7MFM+zgr1tjWcn
         55ZeD406MRYaLPvQBudQbSRX988gIgKBKRKiu/eBb6h/x/eCVuadLuw/8Yn0cbAm+wBu
         0A7KAQJ2SvmCZXtIhOx6Zjus1cWrDu9h4LI2OSndi90miIaN6iCLpF1dUFfVJH2+CLLL
         9JNZt/JGlk1IAaX9N9VOHhmxH7C6YuF3mBn5JSQoBmTPJ0iP8p8vVE29QH9hrDpcSTDT
         LERw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Au8cIAk26/MRJY9HsdbjV4w48DvK6VK2iUZHG3PEHHE=;
        b=CdvZkc36QNJBBIcB0O4oTbH6OQVflfvTiM4vpLc4LANFefdjRtC723d91DgVRMkspJ
         iBUp08jOfhLb4BRRRsAOCUCTp3iIJb0uJ82cLaDpX8h3RMN7H/PyVD/68phSpOc9se/B
         LmmE7EHHLg3cOkLGRh7PW0pUNYTPK90f/Ck+Zw8gQjloqq0Ak+xgm0k831LWwQNXlJWY
         w1mUs09sejdyVFVvO2bMSBIGJwO03upHl2ekXR7zUd3AqduC0rGV+ft0mtuv+urREO4I
         EveH3i2+QK2G1NJr0fuP8jIU/eRlEmx+ER9fXOxukYTth9TDx+/a8f1Be6d9MTF2ZyaG
         iujg==
X-Gm-Message-State: AOAM532fIMQ3FR8kCmmYLxs4C7eLutgqdHjDI7TYYyjDhkgcgXtFHdga
        d6YD41ESTt5sXWsR9ozlN8ejDPkDxYlj15x04Nwg2w==
X-Google-Smtp-Source: ABdhPJxx2QkTtNLwO6JrfDQYLyrwMb60g9IYrSG7ewxivjWs/62hFfxCoNz9tPAevnR7e+UQiQUmfN4kGqowOQnBL3w=
X-Received: by 2002:a9d:ed6:: with SMTP id 80mr3652653otj.35.1639028615193;
 Wed, 08 Dec 2021 21:43:35 -0800 (PST)
MIME-Version: 1.0
References: <20211208191642.3792819-1-pgonda@google.com> <20211208191642.3792819-2-pgonda@google.com>
In-Reply-To: <20211208191642.3792819-2-pgonda@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Wed, 8 Dec 2021 21:43:23 -0800
Message-ID: <CAA03e5EePeCmasD211f0UVz45S3CUXNWyd+S=Wps6G=5SX0JJw@mail.gmail.com>
Subject: Re: [PATCH 1/3] selftests: sev_migrate_tests: Fix test_sev_mirror()
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
> Mirrors should not be able to call LAUNCH_START. Remove the call on the
> mirror to correct the test before fixing sev_ioctl() to correctly assert
> on this failed ioctl.
>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Marc Orr <marcorr@google.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> ---
>  tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> index 29b18d565cf4..fbc742b42145 100644
> --- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> +++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> @@ -228,9 +228,6 @@ static void sev_mirror_create(int dst_fd, int src_fd)
>  static void test_sev_mirror(bool es)
>  {
>         struct kvm_vm *src_vm, *dst_vm;
> -       struct kvm_sev_launch_start start = {
> -               .policy = es ? SEV_POLICY_ES : 0
> -       };
>         int i;
>
>         src_vm = sev_vm_create(es);
> @@ -241,7 +238,7 @@ static void test_sev_mirror(bool es)
>         /* Check that we can complete creation of the mirror VM.  */
>         for (i = 0; i < NR_MIGRATE_TEST_VCPUS; ++i)
>                 vm_vcpu_add(dst_vm, i);
> -       sev_ioctl(dst_vm->fd, KVM_SEV_LAUNCH_START, &start);
> +
>         if (es)
>                 sev_ioctl(dst_vm->fd, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL);
>
> --
> 2.34.1.400.ga245620fadb-goog
>

Reviewed-by: Marc Orr <marcorr@google.com>

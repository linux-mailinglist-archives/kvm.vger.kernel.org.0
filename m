Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BABBA389873
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 23:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhESVQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 17:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhESVQq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 17:16:46 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15E2C06175F
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 14:15:25 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id p20so17215409ljj.8
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 14:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PxJaX9+cSgRTHlBAsFIxSmvTqGzvSiPWv/rstzcIJhg=;
        b=EiRwqkOi0NoXeHtaB8be9cWZ1TIce5jQI45sSM4KpTDMWa9soITUnMOGCWDNDbdjyd
         7/Zg3mwFyeJU0YG0HSs1kdZDsiSSP/Tf98KUAb2jjTwMBccTCJaL7C/1yXnLEUzJzl+b
         aUo/GViKFhLeAiZbt1MfMgzVgXG7STlCZ4/9+mJjCtp0l88U4PKWETpMDizYE0cjtepp
         QSFYvd6mddD8m6zPzcj2inV/HdHhqR3/tSUH/OZwhcvTPS+8oTtHMGkuIZdBJxGf0NZ/
         11WCpCRwfG51yutXAGoE9FZ+4Vv7KoYJW/whjm1bRWm6B0cO4tOn+gqY14I9wDGfBaNZ
         WXgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PxJaX9+cSgRTHlBAsFIxSmvTqGzvSiPWv/rstzcIJhg=;
        b=hpwHKk/xFtsUor0YxKDWpFhPxB8NFLiqZtNf2KVB+PMavNCejnu+mQDeBpDhgrCgqu
         uKypk2Kp2pjEQTKzWBU7CFm4bs+XcbZHq1Z9+gUMebYoZQvprIeSPYrxpFnvf62c+VPc
         F5v0bUwgeduOd/BIuClzNkyabDi4DoyysnDC+FJJzC9vfvfmaTptjkZkHiYNu/PTlX1m
         Rlw6Dxw60NKA8N5W+BEFMNdpH9uKMYPWRJqHVzVLuIxzIOGdbhfQB6RJ2bFj1ZlWEecx
         6MJguru6xXHFE4VKaTqeIBU9fJLu8xFWUGep9YMfLbhkW+ctXD9kjwtIyAR7L23usV1r
         kMQA==
X-Gm-Message-State: AOAM531WR08Yg5bn7XjCh1WJolXSQkUNeG8JAJQQZSDCOePvPOlVV6EZ
        T603bTy+1A1SzDg3cxvoPqCzgB77nzT/REqbTwiz7Vd2UrRQSw==
X-Google-Smtp-Source: ABdhPJyZAc5iqXZXUm/spl/tLUpeIuhOKbwdVJPkUiuIy7r63e0qCUQt8YWscNiAgci5yTccDqZPTe0KaEdUTpRhFsc=
X-Received: by 2002:a2e:5d7:: with SMTP id 206mr795069ljf.448.1621458923496;
 Wed, 19 May 2021 14:15:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210519211345.3944063-1-dmatlack@google.com>
In-Reply-To: <20210519211345.3944063-1-dmatlack@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 19 May 2021 14:14:57 -0700
Message-ID: <CALzav=e6twDSprDYd=pfKPp87qE5RXoi-7qM9xdtWCWSpFSebw@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Ignore CPUID.0DH.1H in get_cpuid_test
To:     kvm list <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19, 2021 at 2:13 PM David Matlack <dmatlack@google.com> wrote:
>
> Similar to CPUID.0DH.0H this entry depends on the vCPU's XCR0 register
> and IA32_XSS MSR. Since this test does not control for either before
> assigning the vCPU's CPUID, these entries will not necessarily match
> the supported CPUID exposed by KVM.
>
> This fixes get_cpuid_test on Cascade Lake CPUs.
>
> Signed-off-by: David Matlack <dmatlack@google.com>

Apologies, forgot to add:

Suggested-by: Jim Mattson <jmattson@google.com>

> ---
>  tools/testing/selftests/kvm/x86_64/get_cpuid_test.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/get_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/get_cpuid_test.c
> index 9b78e8889638..8c77537af5a1 100644
> --- a/tools/testing/selftests/kvm/x86_64/get_cpuid_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/get_cpuid_test.c
> @@ -19,7 +19,12 @@ struct {
>         u32 function;
>         u32 index;
>  } mangled_cpuids[] = {
> +       /*
> +        * These entries depend on the vCPU's XCR0 register and IA32_XSS MSR,
> +        * which are not controlled for by this test.
> +        */
>         {.function = 0xd, .index = 0},
> +       {.function = 0xd, .index = 1},
>  };
>
>  static void test_guest_cpuids(struct kvm_cpuid2 *guest_cpuid)
> --
> 2.31.1.751.gd2f1c929bd-goog
>

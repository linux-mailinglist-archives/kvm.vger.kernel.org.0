Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15B91D98C0
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 19:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390649AbfJPRwC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 13:52:02 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:45081 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390071AbfJPRwB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 13:52:01 -0400
Received: by mail-io1-f65.google.com with SMTP id c25so54842318iot.12
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 10:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AGbc0FlmkWrHsH3Cy2stZhhl4/aniuj/RVFzH7BYYGo=;
        b=irCmEZMq3/At1rnuxsoudMvm3jJniNnBavlGwsbNHmlpFgLj8ZMZe21GNP8XeGqdA9
         Sjr/FONvMbHaUonJ0SvRiTKAqPzAsA72jP5tgJ2XqopeYYf0wvJVXXiKnOV7QR6Iyzq9
         o75nyfUH7QJsMfUKcKuqZUynWvdR59UJSqaDQFD4k2IPMsDcOFZ0Id0fDT1bMIJDRUT8
         Ix93NiH+nkgbaLlcBF0Slj+UJnVEhvCVdC+SRdOlTtrp1Zs9FZ7HxM3kdt3+FZxC+4qk
         ByhcvNPpF76fL6aI1Zf7ecc9tAhDdTLDWWXHPjIIuHn+zg9NY/ft+uJZzqOnc+B5aFJI
         Ntdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AGbc0FlmkWrHsH3Cy2stZhhl4/aniuj/RVFzH7BYYGo=;
        b=JRSs6Ea3N8g5JWtX2+JAvp794O7JLdC8vxJttm2ZCx/7Jv9iRKnDCgK+Ij5ai0rybL
         09nMmEYOgLsJTS7tHpNxMo/TDmnDa7/SyPtGDsPkUanbMJj62axjTJbQqmcjC0GoBygm
         BNTyV2osvF3zchse27MZ2XNhb3PiGjSSgmJ17OAA8t8MqS9+rpr4b3fAdN9O/Dftxgf5
         7GjPOGIFBuyWe6VF1ke3EOipkIMrJFB+Q43H86XGYFsIJPQpQYPybVyCAyyvbBQO6Q6j
         NbFcaJZPcUbyBFrG/gCVqsE5li6NJzkU+QEVGPwck5l8OGjTzub7dzzxslvEIYxdfH3p
         ukNA==
X-Gm-Message-State: APjAAAXplAVeEDkka0wvJtf2OuzmGatuuhcnacd9ZoNqv51vpD4WqjT/
        fVEfASGGEF570zS0M9wpuH2OMUziX18ouvvPX3JmMw==
X-Google-Smtp-Source: APXvYqzAXDyfPz+py13P4Vj+zqF8p4uu9mNlMOD0BuM0aYN1b8rax5ks4FjZyFJ8eIREJZPqT0tea1SmHDIIg0GA9jo=
X-Received: by 2002:a02:741a:: with SMTP id o26mr49562342jac.48.1571248320669;
 Wed, 16 Oct 2019 10:52:00 -0700 (PDT)
MIME-Version: 1.0
References: <20191015001633.8603-1-krish.sadhukhan@oracle.com> <20191015001633.8603-5-krish.sadhukhan@oracle.com>
In-Reply-To: <20191015001633.8603-5-krish.sadhukhan@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 16 Oct 2019 10:51:49 -0700
Message-ID: <CALMp9eQmMYz55cYN+mPUKq2K5RKS1q_Eh6rtKiuNvxDd6zt_0g@mail.gmail.com>
Subject: Re: [PATCH 4/4] kvm-unit-test: nVMX: Use #defines for exit reason in advance_guest_state_test()
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 14, 2019 at 5:52 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> ---
>  x86/vmx_tests.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index d68f0c0..759e24a 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -5043,7 +5043,7 @@ static void guest_state_test_main(void)
>  static void advance_guest_state_test(void)
>  {
>         u32 reason = vmcs_read(EXI_REASON);
> -       if (! (reason & 0x80000000)) {
> +       if (! (reason & VMX_ENTRY_FAILURE)) {
Nit: Drop the superfluous space while you're here?
>                 u64 guest_rip = vmcs_read(GUEST_RIP);
>                 u32 insn_len = vmcs_read(EXI_INST_LEN);
>                 vmcs_write(GUEST_RIP, guest_rip + insn_len);
> --
> 2.20.1
>
Reviewed-by: Jim Mattson <jmattson@google.com>

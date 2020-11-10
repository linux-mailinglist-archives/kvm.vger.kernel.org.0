Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870A92AE25D
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 23:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732224AbgKJWAP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 17:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731687AbgKJV71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 16:59:27 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79437C0613D1
        for <kvm@vger.kernel.org>; Tue, 10 Nov 2020 13:59:27 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id p7so41935ioo.6
        for <kvm@vger.kernel.org>; Tue, 10 Nov 2020 13:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I30fPwLI9kAI3uCTskpQFx215wSP38HR6kIs2VX3/oQ=;
        b=v+pZfPYtQPWtT5SCnVJovwbP0bToPD5i3gtyjlO/oI/JEdsOnBWr3PbndWa9gvrJva
         7xhbD91fFnBWrwjrBWDDTE8EQl/jwkZjOLyP2N0cK/ifsu8dX3np+n9qiNGVhCSxR9pW
         SP+7CMi5rjIZXDyQyQY1hKHCv9WOC8wkfqCkus9OH2F+jRTFgRMMJkh/tIyiwLj105CH
         r1djR2flrmyxSR7vWM2cJW8TCpcsmVfpuJdVz8+rAG0vWcNWcUtVQ78XG89PHhI+K1IQ
         kDWG5wiWsZ+0BMWCI25hnjvfxOG2xPNpZXgPy5X0ssI0gAhJSHErMKaUtQDmodOm8+t1
         DKug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I30fPwLI9kAI3uCTskpQFx215wSP38HR6kIs2VX3/oQ=;
        b=SkXlvbY9lgh/9JS9LDidLp7cD2ciSnNNgE0RIfkkGWds0/Yk5iTUrbo1SoqHhMFW1o
         pdJLG+7EvKCGtUeQLi5L42jpJTtPJ61GoL6q+4Jdj4IV9hB6EljR0Dt5v8g6XXhcVNzc
         YtzH8gf0r1+qCZ067buOcqxUDwlzhEeZAkm02cKBhzmsZLJVcORjuPaI7+6YSJJm+J3/
         M+FHMMSqVIN4DKQx/UUwsaB9PEOGQtdfN4LjAPWCwo12fARUmP4Iup/L1ljAjbMzeLPT
         cuJah3DzyidCC64uGkINLF9vB24GHHnfU4lVC4ImsOQRpQXXCL/yVTO69iQ5lNyBS617
         QJhw==
X-Gm-Message-State: AOAM532g1rrndaDLZLXPU75uIE3tIQ/FBLMrgmbCXTJiqTHuD2aaiM/R
        zQQ8h0dZPJUuOVbiTOQh1HzUqGq71fijqV9Ktz76ER/nJoE=
X-Google-Smtp-Source: ABdhPJyxiTcfyXUETZLMlGYnOpd0VANuQJ6vLLL2xdS5GwA8xKs2XLVBEwJTD1wuw2lysTTaW70jO72zpIoYNVtSbm4=
X-Received: by 2002:a6b:8f8d:: with SMTP id r135mr15153162iod.134.1605045566748;
 Tue, 10 Nov 2020 13:59:26 -0800 (PST)
MIME-Version: 1.0
References: <20201110204802.417521-1-drjones@redhat.com> <20201110204802.417521-2-drjones@redhat.com>
In-Reply-To: <20201110204802.417521-2-drjones@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 10 Nov 2020 13:59:16 -0800
Message-ID: <CANgfPd8j_2mBLHbXaabia=9dZt5Cqmb=sQ-wEp1D5XetN9x5kw@mail.gmail.com>
Subject: Re: [PATCH 1/8] KVM: selftests: Update .gitignore
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 10, 2020 at 12:48 PM Andrew Jones <drjones@redhat.com> wrote:
>
> Add x86_64/tsc_msrs_test and remove clear_dirty_log_test.
>
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  tools/testing/selftests/kvm/.gitignore | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 7a2c242b7152..ceff9f4c1781 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -18,13 +18,13 @@
>  /x86_64/vmx_preemption_timer_test
>  /x86_64/svm_vmcall_test
>  /x86_64/sync_regs_test
> +/x86_64/tsc_msrs_test
>  /x86_64/vmx_apic_access_test
>  /x86_64/vmx_close_while_nested_test
>  /x86_64/vmx_dirty_log_test
>  /x86_64/vmx_set_nested_state_test
>  /x86_64/vmx_tsc_adjust_test
>  /x86_64/xss_msr_test
> -/clear_dirty_log_test
>  /demand_paging_test
>  /dirty_log_test
>  /dirty_log_perf_test
> --
> 2.26.2
>

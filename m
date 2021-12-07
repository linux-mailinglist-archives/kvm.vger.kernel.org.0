Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A7946B1A5
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 04:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234442AbhLGDwp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 22:52:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234400AbhLGDwp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 22:52:45 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9149C061746
        for <kvm@vger.kernel.org>; Mon,  6 Dec 2021 19:49:15 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id x19-20020a9d7053000000b0055c8b39420bso16438957otj.1
        for <kvm@vger.kernel.org>; Mon, 06 Dec 2021 19:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EFHg0mqSMJZdXhaHf3uyIQ25Dg/7z8OZgmdlB0EjFm4=;
        b=EURL0pffFdW0Uz2jTcim+IfQRO/qa67zAT6K9WYrGIUcbW2BtsBROj/zODl+ypVjek
         oiQjyFcoDO1fAxzYZpayWtGi6JsvTd2qpebGIXgid3nvfTMfcemmPzkj/NEIjgdMFUAI
         pSTkCCEY4ikoqwBsY+/yLrzGd+7ckGxXju72H0jHv7Za4nelHOnBlEoFfs956vqb7urV
         kAiz7paIjVPcU09RgJVIyxogD7EctW2mRyRHLch0dxjwPUrypozgqyWXtx0IHd3sx36P
         isW2LLSTnIEHNLdvHg+or1fQNRrShh9Y8nAOWiduPrHpBonI1NGAJfnxJsWXWwBo3+UE
         Ygow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EFHg0mqSMJZdXhaHf3uyIQ25Dg/7z8OZgmdlB0EjFm4=;
        b=M+tCDKOJbDMeyot10mDWzFf6cQl48l+GCPZ8+Q9RP4R/NhbEVK2PLDOnsIE85M+qpv
         R85GgGVr1K6/2oj/vwIclMUaoR2GnxG/8NuXznM9pSODBtxA2T9JX2MptIitsnQC3d5C
         a/0XcCpxhOgBMtVwCOr8ohjujz6oX0fUDeVNRVuuy7MVKmeYSy9c91+Xo/3bwHW+Qx6U
         /J5qswOq9MqnFY06Bf9HhWHJqw8XHN4zAjPUs9jUIFucAAf5x8mPCW03eVb9R1vgJkPN
         mL5Gz5KCanD77gG4I/y8X2RfzmOZ1IrGQoaTgpNFxFYwqOEUfiJgOgsKqt1mMBpkitH1
         dPbA==
X-Gm-Message-State: AOAM530b/vWPOtMgz/hAWBUtpKN1E0BHAEDEDOj7uSKeaX5CHMSoqp4A
        ZTga/J0hE7c6uu2KhKsVXgjhRoctiuCvucUCZwq/LA==
X-Google-Smtp-Source: ABdhPJwckLcXYCcsFCurBGw6obt/h4NfTGrTjvl+3kOcymE/SgUuCV4hUayFPCsxNLTOcDiZ870CwhL+ivpeOBOxoC4=
X-Received: by 2002:a9d:6389:: with SMTP id w9mr33144038otk.29.1638848955107;
 Mon, 06 Dec 2021 19:49:15 -0800 (PST)
MIME-Version: 1.0
References: <20211117134752.32662-1-varad.gautam@suse.com> <20211117134752.32662-3-varad.gautam@suse.com>
In-Reply-To: <20211117134752.32662-3-varad.gautam@suse.com>
From:   Marc Orr <marcorr@google.com>
Date:   Mon, 6 Dec 2021 19:49:04 -0800
Message-ID: <CAA03e5HZiie6Fe1+dcw53xxn5eEj2QWu6cO7AFPp8314PGfZPw@mail.gmail.com>
Subject: Re: [RFC kvm-unit-tests 02/12] x86: Move svm.h to lib/x86/
To:     Varad Gautam <varadgautam@gmail.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 17, 2021 at 5:49 AM Varad Gautam <varadgautam@gmail.com> wrote:
>
> to share common definitions across testcases and lib/.
>
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
>  {x86 => lib/x86}/svm.h | 0
>  x86/svm.c              | 2 +-
>  x86/svm_tests.c        | 2 +-
>  3 files changed, 2 insertions(+), 2 deletions(-)
>  rename {x86 => lib/x86}/svm.h (100%)
>
> diff --git a/x86/svm.h b/lib/x86/svm.h
> similarity index 100%
> rename from x86/svm.h
> rename to lib/x86/svm.h
> diff --git a/x86/svm.c b/x86/svm.c
> index 3f94b2a..7cfef9e 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -2,7 +2,7 @@
>   * Framework for testing nested virtualization
>   */
>
> -#include "svm.h"
> +#include "x86/svm.h"
>  #include "libcflat.h"
>  #include "processor.h"
>  #include "desc.h"
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 8ad6122..5cc4642 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -1,4 +1,4 @@
> -#include "svm.h"
> +#include "x86/svm.h"
>  #include "libcflat.h"
>  #include "processor.h"
>  #include "desc.h"
> --
> 2.32.0
>

Reviewed-by: Marc Orr <marcorr@google.com>

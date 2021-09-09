Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E614E405D05
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 20:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236112AbhIISx7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 14:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbhIISx6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 14:53:58 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC116C061574
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 11:52:48 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id y47-20020a4a9832000000b00290fb9f6d3fso878740ooi.3
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 11:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uVD2x9EihIyN2B4fdthpE2K1Xp1g+FVw3ZQoJtQJLFg=;
        b=B5XYq7YVSwk185hVVXcXlslLX7jDvP6/qBIhPQFJjg3vTdFt+L/sP6qe7v7cOe8YqN
         O+TDl37P82V9GOvYzZP9vdEJtqwsmihixYP7MI5gpdImMlJEWTSFCF0Bm7C3PVdRmk2R
         TzphAoFFfC+1Aa+4qzphxz4CAI7X5g4W4lapCN8xajipY+aOti3WB8tPrLIJnjw2emCZ
         b/fLnI4y3UDfSLTl0e9u+5H5Nc7OyXvU8z3vcRxd0wJUIoU2sN0BkXbb6S31VRMtL+gC
         gRGO0ZPx0Qq7dSiudVeTglKT0PE2GvVTnWpTJQQHAllFUCQIC47TFL77/r2E+9QMO2Hd
         QkdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uVD2x9EihIyN2B4fdthpE2K1Xp1g+FVw3ZQoJtQJLFg=;
        b=Ja/UYCcjBW3hCvfUje95edb3RZVzws92cH1HRZnwSjJyc4z0X3iPaWCu68vVcuE+Hp
         5AP6/dmOag9icxXV5OkBzBKcmmqLUzLqVpDlEXKyRm7G4hv99mxiwHLi1cTTk0H95pKH
         PSuscQj/Ik6HpGsxgnV7F5zQAGPCipu+X3WIJFAC76c2i3+wMOLdFw9RRa0PkmlFlct3
         PLaayVuEfUOl5lBOCQl2yOvUSWIP45dfwmyQQfOjAPoPveucHpddb2NWrRGePtFTvRV8
         PBbIsR4lQla1BW2FkLMyGfENnQaTCb3GxUcyJsciz8IZBLQ09asJutpw2l9b/sEpqUJ8
         6ofg==
X-Gm-Message-State: AOAM530og+N6ebtmPX4ZBpfYp2BbrfQ8YkLv9c9Bpm8V5Vca9TDSg1qF
        2nKUz6pXPl4uKkkNv4Kjv30/qajnSZgIW8T2ILHcoA==
X-Google-Smtp-Source: ABdhPJytgyXGETI2FKO0gkXy9OkRd1rAa4i99jaiC3FTatRtw8siVTi1qN7718tQa2pzMc+cspGyOxSYrlvqSmFYKpA=
X-Received: by 2002:a4a:2549:: with SMTP id v9mr1114120ooe.28.1631213567843;
 Thu, 09 Sep 2021 11:52:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210909183207.2228273-1-seanjc@google.com> <20210909183207.2228273-8-seanjc@google.com>
In-Reply-To: <20210909183207.2228273-8-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 9 Sep 2021 11:52:36 -0700
Message-ID: <CALMp9eTz6H=APscyPE0PT5D7Ur2wRFkeFjZnSX=L51m=1Da1xw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 7/7] x86: vmx: mark some test_*
 functions as noinline
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 9, 2021 at 11:32 AM Sean Christopherson <seanjc@google.com> wrote:
>
> From: Bill Wendling <morbo@google.com>
>
> Some test_* functions use inline asm that define globally visible labels.
> Clang decides that it can inline these functions, which causes the
> assembler to complain about duplicate symbols. Mark the functions as
> "noinline" to prevent this.
>
> Signed-off-by: Bill Wendling <morbo@google.com>
> [sean: call out the globally visible aspect]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>

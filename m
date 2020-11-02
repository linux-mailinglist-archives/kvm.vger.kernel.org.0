Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80532A3735
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 00:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbgKBXgG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 18:36:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgKBXgG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 18:36:06 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0809C0617A6
        for <kvm@vger.kernel.org>; Mon,  2 Nov 2020 15:36:05 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id s21so16545841oij.0
        for <kvm@vger.kernel.org>; Mon, 02 Nov 2020 15:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8hxYOW8pR2NwE15ZJctlrjxNnNVuqyM4eoKhVtl3B9s=;
        b=UsO3t0+YbB2N6o9wo6uV/oq1AfCxiUsMRvKMNzcHhdL628pLYL2j+j2G1qfLDS/Os7
         5a1qyUkluFsXheSS0zpPhREFIE8UdiQ100w4wDMcgQODzc2h2BEVu/3KGeEuqzgcMlwD
         EDxtA56094MC3gEEAaWBCcwTQwjWowFIGQzXomIaBOO3AthY4qaaHQfJvU439c1IYRhK
         WhJ/64G8pT4eiJ+ZHI25AXRO58IxADkT4lIF8s3z27E27NcmCtFpiIASaLCCwai+vH0+
         FrwNlUDKsWikg26zAPZqSz9v2pbp/nJ6W4DnjIMo9DG7wuBe5yGc/FOBXKj9BnATiaYZ
         Ss3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8hxYOW8pR2NwE15ZJctlrjxNnNVuqyM4eoKhVtl3B9s=;
        b=Yz0Zf7pQGXZEbVmyO5SAypL1u40VYSKo23xO5b5JVIhBRUJb0A9V81NmMlcF0sJjgV
         ncuPJL3GY9AfHFZPmYRcbXY3/u7gm2r6h/NSqSRhK4n+4a7/NcO1eT8smRMFZ2AyqlNM
         JWKnLz8Di8C94+A9NeK/0ftUuhyLeZFGuwot44kvVG6mO5K2xP2iiVvCO8vogmg6D9iv
         kuAQn0e7wt0N0gyQtL3eCapt5VYcg++lA/8DZzsHlAd2JxzdqJsZDlIS6ogpbFenJBqq
         3x5P908bUyQ6GgZ48cgQra+JzfrJ/TVFWo1HBTytytYxYrgxfuCvJYF2Ab0FFqAwzKt/
         LmSQ==
X-Gm-Message-State: AOAM533E/kATD8hB29mMazxQnZQljt16NeSKsCLgPvFHE/yg9CJFxtmM
        WYTmTaosU24RWVwsfbeAc3BqUeI5UZZIahcLnrD2lw==
X-Google-Smtp-Source: ABdhPJxXBErbx6RboQGmLsFmKBiStRfa/obDfV5jJFH2dDfJqPxaRnT+rG9yN3LqN6PEH5T3PjrJtBxOhUgDOe51Pgs=
X-Received: by 2002:aca:f557:: with SMTP id t84mr366142oih.13.1604360164329;
 Mon, 02 Nov 2020 15:36:04 -0800 (PST)
MIME-Version: 1.0
References: <20201031144052.3982250-1-pbonzini@redhat.com>
In-Reply-To: <20201031144052.3982250-1-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 2 Nov 2020 15:35:53 -0800
Message-ID: <CALMp9eQGPd4KfeE-o1pO8did=2e+TcO-PdmfnbVGk05LbnqSug@mail.gmail.com>
Subject: Re: [PATCH kvm-unit-tests] reduce number of iterations for apic test
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 31, 2020 at 7:41 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> The test generally fails quite quickly, 1 million iterations is
> a lot and, on Azure cloud hyperv instance Standard_D48_v3, it will
> take about 45 seconds to run this apic test.
>
> It takes even longer (about 150 seconds) to run inside a KVM instance
> VM.Standard2.1 on Oracle cloud.
>
> Reported-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76AC371FCA
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 20:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhECSid (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 14:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbhECSid (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 14:38:33 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C42C06174A
        for <kvm@vger.kernel.org>; Mon,  3 May 2021 11:37:40 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id e25so6337413oii.2
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 11:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ycjp9YKakzYJfMsw68/OJmOAmJ2d7LEiKPPYJZM/rhQ=;
        b=ngo0XmaWH5gTZxwbdEUVi8ZstccnjudOjkpneq3evNOJjp+jxg1I9zTk8ZehM/RrrK
         EapVgxlcDwuiQTt7N5U2ErUj/l+pfH9VKEwkZ0YunRBgUHZju+/MpnoYaBZyK9ryjYTJ
         FNEAm3jQ3oITai4X8mJfI+caeZRLxgDen5HE2KYUUh5EsU530ipb8Hxcrgd9TaxRFqIw
         b6/M76u8bjAZvmldevIDhSSM2TK/lx6lJgTlZdznOnx9P+plb+KdzkLyDKuOmyske4iA
         3RhoNFg+xP5c4kqETaxiNKCB1t9ZTDeR+gKs1SL8+W2pcRD7oHu+gfiTlG4dk07DiUdC
         G9Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ycjp9YKakzYJfMsw68/OJmOAmJ2d7LEiKPPYJZM/rhQ=;
        b=ikCLGkhXuYNKsag8q1uY9zaCPHFwuIECghGl8bFzaRhrzFzR60Nof0Ea9lpsZ47PX5
         bbgecqkhclJuVzH5WF+wxAUZLhDuYtivemvArAy1BkmiqyiC8vsXdNGkJMbgMX5fljQg
         NTswrEN0/gGjDxAhiduvYlIBCo6fZh6O191pho3TlYTxAsZB9QtNGxiq6d/hPgMxwtNd
         1megFIjR9m/7FzSCqCaPPQHboQAslyod1DicyxIwPEQoMEL3MnGKJz2jQb/zDVhV5IGw
         rvTOvTk6Hz8UhgOPPQp3NtUAWVT4HZMqKq3zW1be95DHRnGGkFSMwnin1TLBXJPxh4eq
         eDBg==
X-Gm-Message-State: AOAM5329xZZQdL9Xot4mOvKoVaFdjNWdfzx6QAC54n263SXUv6hRtJcd
        eRavc5+rBQGed8bnCt4UHvNXIKxXeU+rMskAFi3wgw==
X-Google-Smtp-Source: ABdhPJyvGARaa5/iBTRXxOzi1F2QBL9c4NbR422WtoBAs2wDqjdJ7B52sjIRwxQ/gDIso+WgslIEI/xGyZ7fT3Eb2v4=
X-Received: by 2002:a05:6808:b2f:: with SMTP id t15mr21641896oij.6.1620067059263;
 Mon, 03 May 2021 11:37:39 -0700 (PDT)
MIME-Version: 1.0
References: <X9LJE6ElVfKECnno@google.com> <20201211012317.3722214-1-morbo@google.com>
In-Reply-To: <20201211012317.3722214-1-morbo@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 3 May 2021 11:37:28 -0700
Message-ID: <CALMp9eSvMtaXndor9=h40utaefQs9BPKknV7nbWFQi0phr_TvA@mail.gmail.com>
Subject: Re: [PATCH v2] selftests: kvm: remove reassignment of non-absolute variables
To:     Bill Wendling <morbo@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Shuah Khan <shuah@kernel.org>, Jian Cai <caij2003@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 10, 2020 at 7:58 PM Bill Wendling <morbo@google.com> wrote:
>
> Clang's integrated assembler does not allow symbols with non-absolute
> values to be reassigned. Modify the interrupt entry loop macro to be
> compatible with IAS by using a label and an offset.
>
> Cc: Jian Cai <caij2003@gmail.com>
> Signed-off-by: Bill Wendling <morbo@google.com>
> References: https://lore.kernel.org/lkml/20200714233024.1789985-1-caij2003@gmail.com/
Reviewed-by: Jim Mattson <jmattson@google.com>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7BE3546C1
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 20:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235036AbhDES1u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 14:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234865AbhDES1s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 14:27:48 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552D6C061788
        for <kvm@vger.kernel.org>; Mon,  5 Apr 2021 11:27:40 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id c18so4284855iln.7
        for <kvm@vger.kernel.org>; Mon, 05 Apr 2021 11:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WCxby3Jp5TDKJXrr4ksAkJ+LF8mSCwQ/NlCo5Zzkrdo=;
        b=IUDndj+NlOsbnvqLrJrA4zHuJt9Vs7IworFD6VxxbROtpkqg0l2ynBlNto+4cLzSjv
         CBqCXCrn7WDsHK41/JMb2NgQwLVmTdMQTnrxCAXmS8Qdqk1W5NnVnKJWYrVMMN6mJ8sE
         Sd4VQc3CyR1Po4veid4ACzu0WGqPi+dh7nmptm7mxALpp5JyCX4c3QAX5eLlfGADiWCo
         BWDXyf8f38hNv/BaDmFZp61lDr0ByYbljch++BE2NJPOHMahZF7ygmcfYx2H9aKCnhRN
         Aycyc1u6/yoa6o5urIRmSi+f+7FAXxJN3oiSyUEyRw7LA7cQtMgqqMIw4/VK6b6bK/ys
         FGSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WCxby3Jp5TDKJXrr4ksAkJ+LF8mSCwQ/NlCo5Zzkrdo=;
        b=jH2G0TgVlHghJ974c0+5pXfJbhQ8ouwCVeirnRphOSUEcW252bRFakBPheqvvK7heh
         kamJVl8Qr0TkakX0W9OXlCJa47xdOxGsPGq6JIm8Kb+XZtCNyLPNHO/8O/OoDgJIQDvd
         VXjo/FbSWvY7emQdeLc/kCDHdwUdaACrrHOd673JFOgXwBcZl+1rbpmgUUyS7bpKnumk
         rkvI936aCWKgSSOxZbAKEzO5fHtoeUjTK7OEA0a7ogFwQu/PGprV7bve9H3wU5t3psfM
         uUHLmUMQiB1sF060NPBeW2ZHTX0Sbgfgl3WCcP/GSiWILm0weuW9Tn78DBWPK39Yjs1G
         DuVA==
X-Gm-Message-State: AOAM530k2Fnlymvg7m96E928bWrZv1zQcA4Iy+XwvbIrB8jYBiqOy76F
        2YKegzma+j15q/zi9n3gRi2HJ2PnmclGk5cSLySVIw==
X-Google-Smtp-Source: ABdhPJxS8I/5yEmMhDbQWAaiuF3BBv1UnvC6mGDWjwLfslnVX8VqYQJmI6QNB80ecemQTE2HG6SIkG+u1KcaJimmJtQ=
X-Received: by 2002:a05:6e02:792:: with SMTP id q18mr8124507ils.212.1617647259435;
 Mon, 05 Apr 2021 11:27:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1617302792.git.ashish.kalra@amd.com> <CAMkAt6oWF23YFiOGW_h+iyhjkaAp6uaMNjYKDXNxvNCWR=vyWw@mail.gmail.com>
In-Reply-To: <CAMkAt6oWF23YFiOGW_h+iyhjkaAp6uaMNjYKDXNxvNCWR=vyWw@mail.gmail.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 5 Apr 2021 11:27:03 -0700
Message-ID: <CABayD+dDFMEBTzSxEax=wJLwg7-xQi2C5smPiOh=Ak6pi72ocw@mail.gmail.com>
Subject: Re: [PATCH v11 00/13] Add AMD SEV guest live migration support
To:     Peter Gonda <pgonda@google.com>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 5, 2021 at 8:17 AM Peter Gonda <pgonda@google.com> wrote:
>
> Could this patch set include support for the SEND_CANCEL command?
>
That's separate from this patchset. I sent up an implementation last week.

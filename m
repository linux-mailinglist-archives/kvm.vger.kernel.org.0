Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92DE3EF167
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 20:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbhHQSJE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 14:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbhHQSJD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 14:09:03 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754D5C061764
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 11:08:30 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id i8so18283971ybt.7
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 11:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ONK5GMsw6Z2jdg3q0ewBdbX45fnfcEKY0NCemn7k1jM=;
        b=W7uFNzyv5JEkceJi8ykWuavNKT3LRNaAW+qfvyOSlC4c79sfmcjNvIgjAX92pLdVeN
         z0tj8+4pswB44jPoA9YarDqFKcnJ4BxzA0uEwXSg8RnmAmcuPWpRye7zq0GKtD516Ml8
         Tc/hnFWZJttrk5ekh3JxShTRPIrGZG4oWG0wqq+hWmc+1jKt/NQ/Os/6yh6QD0+3dgii
         3AFRb6sgZpzYbiD7VxnSnUZWqn5QuJJDFLoHuWHd1bExcYu8BEt3x0WZvKGiUnN78ewQ
         J9HEtEHRrzwOrvdI85B5jvmZUHdLvVCopwgdjq6l622eRLrF1m66fxkEqdxCwK5CPheX
         DxMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ONK5GMsw6Z2jdg3q0ewBdbX45fnfcEKY0NCemn7k1jM=;
        b=s2tMwxiG0lEYlCC4K8NmBqBX/a/3Vdh3XJudNj3cqYpmPdvYx+CZYbRoJScJt78/yh
         F5Vb5hTEmwcrN1pGs68fMjgeNYQARVuZWt8EMf3KZhxfkfFz0Dx9vC/IkNxFCzslapt+
         Hek8YH4Y5ANSpTsD1nzjktiaWCZ5w/TSyw1m+PuPtaACUVJY3jC6tifDx4Wu0l8f4bS3
         jWQbOJVALvYPgWgorZLDvFskYs1TgD2qwtp+lSQSYG0cRPeiz4wbqAakQFIkkQ10nggR
         YEH4D6KcEi4Kqvv3dxf5Jf8RYDGIkQrYPKWFwb+8p6Zh1fL/EWahqQWUIbdgGfUxFsPM
         3PNg==
X-Gm-Message-State: AOAM532pQJPT8FIIHzcKV/5l79nCXdQerIGpBJ+OkwSmzFvIQ7ppj6BH
        0qYNHFgYxn+NyXJm3StzMj4pQhuJH1bWWIpZilgsVg==
X-Google-Smtp-Source: ABdhPJxsGzUlxMjKR3elob/wHPc1HBxtF4Y+RRC8pe7iDaGSGTLe46suMf8KgSl+hgtGHEd8la8rZoAK0KwAKG/BF+k=
X-Received: by 2002:a25:d88e:: with SMTP id p136mr5994164ybg.92.1629223709541;
 Tue, 17 Aug 2021 11:08:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210816202441.4098523-1-mizhang@google.com> <c66484d2-3524-d061-1e65-70dab0703cc3@redhat.com>
In-Reply-To: <c66484d2-3524-d061-1e65-70dab0703cc3@redhat.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Tue, 17 Aug 2021 11:08:18 -0700
Message-ID: <CAL715WJ4aREKC-5dOoNSuZi4qm6PqmoqYN+CVm9Y-cEwQZ7mow@mail.gmail.com>
Subject: Re: [PATCH 0/3] clean up interface between KVM and psp
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Alper Gun <alpergun@google.com>,
        Borislav Petkov <bp@alien8.de>,
        David Rienjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>, Peter Gonda <pgonda@google.com>,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Thanks for the prompt reply. I will update the code and will be
waiting for Tom and other AMD folks' feedback.

Thanks. Regards
-Mingwei

On Tue, Aug 17, 2021 at 1:54 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 16/08/21 22:24, Mingwei Zhang wrote:
> > This patch set is trying to help make the interface between KVM and psp
> > cleaner and simpler. In particular, the patches do the following
> > improvements:
> >   - avoid the requirement of psp data structures for some psp APIs.
> >   - hide error handling within psp API, eg., using sev_decommission.
> >   - hide the serialization requirement between DF_FLUSH and DEACTIVATE.
> >
> > Mingwei Zhang (3):
> >    KVM: SVM: move sev_decommission to psp driver
> >    KVM: SVM: move sev_bind_asid to psp
> >    KVM: SVM: move sev_unbind_asid and DF_FLUSH logic into psp
>
> No objections apart from the build failure on patch 1.  However, it's up
> to Tom whether they prefer this logic in KVM or the PSP driver.
>
> Paolo
>

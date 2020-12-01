Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D846E2CA1DB
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 12:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389469AbgLALzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 06:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727183AbgLALzM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Dec 2020 06:55:12 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D5EC0613CF
        for <kvm@vger.kernel.org>; Tue,  1 Dec 2020 03:54:32 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id f23so3572149ejk.2
        for <kvm@vger.kernel.org>; Tue, 01 Dec 2020 03:54:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BSp+fq8LvCYxL+tAjipD3SNRBEkrUwAJlgzMD1hu4No=;
        b=GDqc/6stCinaXZb07ex33bw3JlhuLZmgquF34i87+FjBf26yioFj++a2nWHCVBad9C
         ZjNUNectCWXeQkPuvZaasOz4Z9cj0gKoPKbpsR/6msJ6Vor0iY5rtU2YEVRRqR+jsxpa
         iV9UG/tVd1W6B1aq9NY+yhxyB+Jv6Q8WO/ItE666E1wSyWDGJk6JfXqeQZ2dDrt8gF7n
         RIgnPaAntGOlhZ2e6QmqyNe+LvMA8zj7Te7ICYMsQGJpvLl9uDtaaXpf7ePPQcmCoQtn
         DquJU//zOzthljwxD/5XUcHH++fk3GFccNBbDI2CLK8iwRQ3Wj/HdGkJiD8UdmX1j9p9
         AhkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BSp+fq8LvCYxL+tAjipD3SNRBEkrUwAJlgzMD1hu4No=;
        b=VJp3oN7FYMMkrN9mOP6XNYZQ42wf4KYfyxYuXiVS6kcx7zPGRgcSnicTcJXG0AD6v5
         JXh8kc33sTlLDGzRdHZFiA0wCquLlFtuMb+judsQ3rNqr4rTOIKfJWhspBNtaC1smV5e
         kMz/fiQaHJLgL9FvnzU2e/NfbAAGEO8gwPGf5rtvImWDI8wyo8emrdG8bUnISWMJpeE9
         szpZ1m7e7/eOYgZLu4A80F0SXqDWLlLGS0Bg8+/VY9F5+XTM5jDmv3DcYgWYvC2reWt3
         PQgh2dVSf4H9BAjyLiYYI6VG8yBI5gkNFnNgTWj6U6/jjzu3pFLqGuDhQxg0IcipY20m
         hmRg==
X-Gm-Message-State: AOAM5339+s+GFU2JYoj4Hs/tJG5jtyh8ago3aTvp4nXr8zGobA0FLlkZ
        KRV0JKMUEMLDQ3C6AtRRpj7/q7abS2kOLOVCepeJ9g==
X-Google-Smtp-Source: ABdhPJxq425o/0S4gddVffNbNVH9SInCANGpqpelDExjknpcgteEd0bqb2+W3D3pfYNWcDkwUqGHTUkgsz57EVyWvvQ=
X-Received: by 2002:a17:906:b53:: with SMTP id v19mr2689197ejg.250.1606823671071;
 Tue, 01 Dec 2020 03:54:31 -0800 (PST)
MIME-Version: 1.0
References: <cover.1605316268.git.ashish.kalra@amd.com> <aa90b9f98f7314ae8c197a16e2acedbd29e16200.1605316268.git.ashish.kalra@amd.com>
In-Reply-To: <aa90b9f98f7314ae8c197a16e2acedbd29e16200.1605316268.git.ashish.kalra@amd.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 1 Dec 2020 11:54:20 +0000
Message-ID: <CAFEAcA-bFd-hk2aDr14kkbsOFFa5p_jPAbAtYPh1ZcZRiUmCRQ@mail.gmail.com>
Subject: Re: [PATCH 06/11] monitor/i386: use debug APIs when accessing guest memory
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, ssg.sos.patches@amd.com,
        Markus Armbruster <armbru@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 Nov 2020 at 19:29, Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> Update the HMP commands to use the debug version of APIs when accessing
> guest memory.
>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  monitor/misc.c        |  4 ++--
>  softmmu/cpus.c        |  2 +-
>  target/i386/monitor.c | 54 ++++++++++++++++++++++++-------------------
>  3 files changed, 33 insertions(+), 27 deletions(-)
>
> diff --git a/monitor/misc.c b/monitor/misc.c
> index 32e6a8c13d..7eba3a6fce 100644
> --- a/monitor/misc.c
> +++ b/monitor/misc.c
> @@ -824,8 +824,8 @@ static void hmp_sum(Monitor *mon, const QDict *qdict)
>
>      sum = 0;
>      for(addr = start; addr < (start + size); addr++) {
> -        uint8_t val = address_space_ldub(&address_space_memory, addr,
> -                                         MEMTXATTRS_UNSPECIFIED, NULL);
> +        uint8_t val;
> +        cpu_physical_memory_read_debug(addr, &val, 1);

Don't introduce new uses of cpu_* memory read/write functions, please.
They're an old API that has some flaws, like not being able to report
read/write access errors.

If debug accesses are accesses with a MemTxAttrs that says debug=1,
then you should just provide the right MemTxAttrs here.

thanks
-- PMM

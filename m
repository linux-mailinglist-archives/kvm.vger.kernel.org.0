Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5E07D3C2
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 05:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbfHADjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 23:39:22 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:40408 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfHADjW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 23:39:22 -0400
Received: by mail-ot1-f68.google.com with SMTP id l15so15434664oth.7
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 20:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EVsoW03bnJnM3ix4ADkBj5P+u3h7qEgC2Ua1WOX+7+8=;
        b=uf1iW1QQE/gRuVsnj4WotzVEILDbFZsF88YQYt4idtbhD0+lijZjR3+eJ4vd5tEDRy
         756ghwz3wC00dn6gkJGM8BouxTHrQJOOKxBON5tIqo8AT6knfgh+ZfkJ0D7o850nNLJH
         8FC3u5R51YnHGhBSR3lHBnTI3HDDpGDiscY0nwfQw/mSXQERPoxejCAk4WqsN37iuAgS
         Pic7P6otDTeK/ZqEraoroggsPnqDurKZ3V0zQEpi0zgKFPjd6QpUGH6DDouyeTNdo7Y1
         gDDaho9zt5oJd++/eePFCUwGUH2oxn/PvTxKR7lrxkqHarFlCClZMoAjh8yFah7vs/lw
         vqvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EVsoW03bnJnM3ix4ADkBj5P+u3h7qEgC2Ua1WOX+7+8=;
        b=JHEFgEiVI518gUT3AQ2QQb3Mw2YaULB5FO8rEgfKl5yh1KwNH3Egu76+Y4I16WTMB8
         W5b4bglZgxYKDoi/USARNr2eoTLL7LsppAxx/id5hin8oS2RBoIdaiW0DaXcCT9rwsR6
         expoDSPyMCeW393tbIlq272UszNgQInc58XkbmnUI2TLwDsv2uL2K1ozXneyL8zGbjEn
         3D+DLlY3K6535IS1uw/xhStgfNIslbpk62iUyGIzxQCBJe+Lo0ixpMGrY9UBFEew0t77
         R/8pzwvHpLjKdI2n2EksdEgc1fEmfkdLJNkbgVkgIzCEqUWZWujbaVEXPQnb6pNg1nLw
         XDLg==
X-Gm-Message-State: APjAAAXzrwbW7dgXrWHKSv+v4Lc1tStWvjZiXt67sDwZK97fkjirzaPh
        4euFoWNTPOBh+81qyHsI8CxUudvXd+W95APLzvyM2E1s5YY=
X-Google-Smtp-Source: APXvYqwT4noTjZ2hegFbRxGRNNvTZ8qZ7va9pMoKPLu0mS8Qm34ezheCKpv4MSCXmOkiMdSYMGL6iaKUvvPiAKedALU=
X-Received: by 2002:a9d:4590:: with SMTP id x16mr40511834ote.254.1564630761341;
 Wed, 31 Jul 2019 20:39:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190729053243.9224-1-peterx@redhat.com> <20190729053243.9224-3-peterx@redhat.com>
In-Reply-To: <20190729053243.9224-3-peterx@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 1 Aug 2019 11:39:04 +0800
Message-ID: <CANRm+CxkdBXZ170nXiKiQ-a-xzZObEXZdBgsAx5jrE=aroTR5w@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: X86: Remove tailing newline for tracepoints
To:     Peter Xu <zhexu@redhat.com>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 29 Jul 2019 at 13:35, Peter Xu <zhexu@redhat.com> wrote:
>
> It's done by TP_printk() already.
>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/kvm/trace.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index 26423d2e45df..76a39bc25b95 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -1323,7 +1323,7 @@ TRACE_EVENT(kvm_avic_incomplete_ipi,
>                 __entry->index = index;
>         ),
>
> -       TP_printk("vcpu=%u, icrh:icrl=%#010x:%08x, id=%u, index=%u\n",
> +       TP_printk("vcpu=%u, icrh:icrl=%#010x:%08x, id=%u, index=%u",
>                   __entry->vcpu, __entry->icrh, __entry->icrl,
>                   __entry->id, __entry->index)
>  );
> @@ -1348,7 +1348,7 @@ TRACE_EVENT(kvm_avic_unaccelerated_access,
>                 __entry->vec = vec;
>         ),
>
> -       TP_printk("vcpu=%u, offset=%#x(%s), %s, %s, vec=%#x\n",
> +       TP_printk("vcpu=%u, offset=%#x(%s), %s, %s, vec=%#x",
>                   __entry->vcpu,
>                   __entry->offset,
>                   __print_symbolic(__entry->offset, kvm_trace_symbol_apic),
> @@ -1368,7 +1368,7 @@ TRACE_EVENT(kvm_hv_timer_state,
>                         __entry->vcpu_id = vcpu_id;
>                         __entry->hv_timer_in_use = hv_timer_in_use;
>                         ),
> -               TP_printk("vcpu_id %x hv_timer %x\n",
> +               TP_printk("vcpu_id %x hv_timer %x",
>                         __entry->vcpu_id,
>                         __entry->hv_timer_in_use)

The last one is handled by commit 7be373b6de503 .

Regards,
Wanpeng Li

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D89748BEDD
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 18:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfHMQn6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 12:43:58 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33446 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfHMQn6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 12:43:58 -0400
Received: by mail-wr1-f67.google.com with SMTP id n9so108491609wru.0
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 09:43:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=R+TQ2SRZqheh/+m+AgbCNj23H0NoT711BBAwP7NZvNk=;
        b=LGWTAeSvzO4q8U4Gldr//V00MUKnHFQk1fbJBD/6CZP4oPfa/+3LyocQaArwNOAksf
         MLI4ucgxNOdSF6VtB8LIjwHVcThA2rUPOjphKUtBrw6wLxEsvNjmKhuVqSqwynQN6SuM
         v1aJcHxxouzS3Cwmz5DVgLzQ7tXtpuNuqr1Gb9/lcg/xw0TfKNfJfetiDrY9HUYJoCpU
         lJmeHPD/Ake9vVKOo4PAcs3P2Y4UFINb+trFj45Bv81TEbVKuHuO3k0xENvbsR5z2B1v
         jWKCrZE0nnVzoSY6kKYjEFNrpXP4SrGe7iVY78aHBe3ELhuqzipqGfYP/24/VrAM9L5c
         Jhhw==
X-Gm-Message-State: APjAAAViJODSAk7dLoej50OP/yFWE4XKFvF931ptP0HH7acRhQEogbq/
        +s39YmduV2uT57WJuX6IchRqig==
X-Google-Smtp-Source: APXvYqyLJEa/u5ApuHODI1ChbVsHPnV50CLirBt9pvSGLUI9pb/mMfHDZJd6oyXT4LApa3VSEoT/Tw==
X-Received: by 2002:a5d:568e:: with SMTP id f14mr46435405wrv.167.1565714636124;
        Tue, 13 Aug 2019 09:43:56 -0700 (PDT)
Received: from xz-x1 ([195.112.86.171])
        by smtp.gmail.com with ESMTPSA id o20sm272367456wrh.8.2019.08.13.09.43.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 09:43:55 -0700 (PDT)
Date:   Tue, 13 Aug 2019 18:43:54 +0200
From:   Peter Xu <peterx@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Peter Xu <zhexu@redhat.com>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/3] KVM: X86: Remove tailing newline for tracepoints
Message-ID: <20190813164354.GA14469@xz-x1>
References: <20190729053243.9224-1-peterx@redhat.com>
 <20190729053243.9224-3-peterx@redhat.com>
 <CANRm+CxkdBXZ170nXiKiQ-a-xzZObEXZdBgsAx5jrE=aroTR5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANRm+CxkdBXZ170nXiKiQ-a-xzZObEXZdBgsAx5jrE=aroTR5w@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 01, 2019 at 11:39:04AM +0800, Wanpeng Li wrote:
> On Mon, 29 Jul 2019 at 13:35, Peter Xu <zhexu@redhat.com> wrote:
> >
> > It's done by TP_printk() already.
> >
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >  arch/x86/kvm/trace.h | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> > index 26423d2e45df..76a39bc25b95 100644
> > --- a/arch/x86/kvm/trace.h
> > +++ b/arch/x86/kvm/trace.h
> > @@ -1323,7 +1323,7 @@ TRACE_EVENT(kvm_avic_incomplete_ipi,
> >                 __entry->index = index;
> >         ),
> >
> > -       TP_printk("vcpu=%u, icrh:icrl=%#010x:%08x, id=%u, index=%u\n",
> > +       TP_printk("vcpu=%u, icrh:icrl=%#010x:%08x, id=%u, index=%u",
> >                   __entry->vcpu, __entry->icrh, __entry->icrl,
> >                   __entry->id, __entry->index)
> >  );
> > @@ -1348,7 +1348,7 @@ TRACE_EVENT(kvm_avic_unaccelerated_access,
> >                 __entry->vec = vec;
> >         ),
> >
> > -       TP_printk("vcpu=%u, offset=%#x(%s), %s, %s, vec=%#x\n",
> > +       TP_printk("vcpu=%u, offset=%#x(%s), %s, %s, vec=%#x",
> >                   __entry->vcpu,
> >                   __entry->offset,
> >                   __print_symbolic(__entry->offset, kvm_trace_symbol_apic),
> > @@ -1368,7 +1368,7 @@ TRACE_EVENT(kvm_hv_timer_state,
> >                         __entry->vcpu_id = vcpu_id;
> >                         __entry->hv_timer_in_use = hv_timer_in_use;
> >                         ),
> > -               TP_printk("vcpu_id %x hv_timer %x\n",
> > +               TP_printk("vcpu_id %x hv_timer %x",
> >                         __entry->vcpu_id,
> >                         __entry->hv_timer_in_use)
> 
> The last one is handled by commit 7be373b6de503 .

Right, I'll rebase. Thanks.

-- 
Peter Xu

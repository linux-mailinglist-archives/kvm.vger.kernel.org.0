Return-Path: <kvm+bounces-216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 706007DD4D8
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 18:44:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BA881C20C61
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 17:44:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF24F20B2F;
	Tue, 31 Oct 2023 17:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TQ0VlSZ0"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B1320B07
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 17:44:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBFCDA
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698774255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=++yDpu2AH/a5plJrgjGi13e3Lbz8agKll4JzdkwLo3c=;
	b=TQ0VlSZ0pgVSrUgb+T9ms8tz6qZGfJ292LVf8YuzRa4q53v5j3UyNF+wAZDevQjckoZaLC
	ogH7vOTpyhJf52UVVrK/UfNsv+M2OAd10sbk6fHCC+WxD0ATWw+LXztFRk64BYpI+sds4Q
	TcXkS7gG6GynjwamXpIkfQc3linSBLk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-101-6tzPe-3JO2e1UxabrFwY1w-1; Tue, 31 Oct 2023 13:44:13 -0400
X-MC-Unique: 6tzPe-3JO2e1UxabrFwY1w-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40845fe2d1cso42276095e9.0
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:44:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698774252; x=1699379052;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=++yDpu2AH/a5plJrgjGi13e3Lbz8agKll4JzdkwLo3c=;
        b=B3C9lRbNLrj15oNF1LV7xqUesK/Qzd6K5LKhqsQzUUvJHdGZAfWlRGyaFPl/cgJId5
         nBITX3YfyzsTmwCCLOepfyleKn7mppV/8DgIuOHdslL1mBHvTJBb2oZ5exRprKYW+ZW6
         W8z7d9bQwfRv9ea5idXiWOWR/Ar/h9xLdIlcQPEwLxtvL+Kib9UVwhpI5wyxOlfXl/I4
         1VTUamR0qdI+Jn/oSFvq3TufkSKz3e7R8/WwOlJOrGRtRLa3KvjA7F1meBPnI9/JEwJo
         uaybPdFMO8EU+kUnDxmq83J5slkGyIsFpQYpqpWGx49XWQpF7/hONX3+s7CIMBLtCoQ6
         qI3Q==
X-Gm-Message-State: AOJu0YyaXqKy0PlK4V50iC6Trq96U7xdn6ylVwtZvFOxqTCE/4FlqU+v
	EMTXoTc4etC3MuxlxjfHDYMClYbPzj1s7d60HAqsjkR1P+5AlzN3bUmIpH6EmOfS1aUkctRlLqt
	oa/4w1twhsdrZ2jGjB+/Z
X-Received: by 2002:a05:600c:4748:b0:3fb:feb0:6f40 with SMTP id w8-20020a05600c474800b003fbfeb06f40mr11485648wmo.11.1698774252077;
        Tue, 31 Oct 2023 10:44:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFSNJUJBUqj9XPNa0b67Y7ewok9q49Kfxkcww19RJ/8jirv7SXyzphejJgey48N/jWBUfCjKw==
X-Received: by 2002:a05:600c:4748:b0:3fb:feb0:6f40 with SMTP id w8-20020a05600c474800b003fbfeb06f40mr11485630wmo.11.1698774251754;
        Tue, 31 Oct 2023 10:44:11 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id z18-20020a05600c079200b0040772934b12sm2296222wmo.7.2023.10.31.10.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 10:44:10 -0700 (PDT)
Message-ID: <dc1aa5ca99f56351ad15f6d4158288644ac6a23c.camel@redhat.com>
Subject: Re: [PATCH v6 03/25] x86/fpu/xstate: Add CET supervisor mode state
 support
From: Maxim Levitsky <mlevitsk@redhat.com>
To: "Yang, Weijiang" <weijiang.yang@intel.com>, "Edgecombe, Rick P"
 <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
 "pbonzini@redhat.com" <pbonzini@redhat.com>, "Christopherson,, Sean"
 <seanjc@google.com>,  "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>
Cc: "peterz@infradead.org" <peterz@infradead.org>, "Hansen, Dave"
 <dave.hansen@intel.com>, "Gao, Chao" <chao.gao@intel.com>,
 "john.allen@amd.com" <john.allen@amd.com>
Date: Tue, 31 Oct 2023 19:44:08 +0200
In-Reply-To: <c72f3ef9-ee82-84c8-c802-c9593a1dd5d1@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
	 <20230914063325.85503-4-weijiang.yang@intel.com>
	 <35393ed30962125fd6ce1f91f71595d1111413ec.camel@intel.com>
	 <c72f3ef9-ee82-84c8-c802-c9593a1dd5d1@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2023-09-15 at 14:30 +0800, Yang, Weijiang wrote:
> On 9/15/2023 8:06 AM, Edgecombe, Rick P wrote:
> > On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
> > > Add supervisor mode state support within FPU xstate management
> > > framework.
> > > Although supervisor shadow stack is not enabled/used today in
> > > kernel,KVM
> >           ^ Nit: needs a space
> > > requires the support because when KVM advertises shadow stack feature
> > > to
> > > guest, architechturally it claims the support for both user and
> >           ^ Spelling: "architecturally"
> 
> Thank you!!
> 
> > > supervisor
> > > modes for Linux and non-Linux guest OSes.
> > > 
> > > With the xstate support, guest supervisor mode shadow stack state can
> > > be
> > > properly saved/restored when 1) guest/host FPU context is swapped
> > > 2) vCPU
> > > thread is sched out/in.
> > (2) is a little bit confusing, because the lazy FPU stuff won't always
> > save/restore while scheduling.
> 
> It's true for normal thread, but for vCPU thread, it's a bit different, on the path to
> vm-entry, after host/guest fpu states swapped, preemption is not disabled and
> vCPU thread could be sched out/in, in this case,  guest FPU states will  be saved/
> restored because TIF_NEED_FPU_LOAD is always cleared after swap.
> 
> > But trying to explain the details in
> > this commit log is probably unnecessary. Maybe something like?
> > 
> >     2) At the proper times while other tasks are scheduled
> 
> I just want to justify that enabling of supervisor xstate is necessary for guest.
> Maybe I need to reword a bit :-)
> 
> > I think also a key part of this is that XFEATURE_CET_KERNEL is not
> > *all* of the "guest supervisor mode shadow stack state", at least with
> > respect to the MSRs. It might be worth calling that out a little more
> > loudly.
> 
> OK, I will call it out that supervisor mode shadow stack state also includes IA32_S_CET msr.
> 
> > > The alternative is to enable it in KVM domain, but KVM maintainers
> > > NAKed
> > > the solution. The external discussion can be found at [*], it ended
> > > up
> > > with adding the support in kernel instead of KVM domain.
> > > 
> > > Note, in KVM case, guest CET supervisor state i.e.,
> > > IA32_PL{0,1,2}_MSRs,
> > > are preserved after VM-Exit until host/guest fpstates are swapped,
> > > but
> > > since host supervisor shadow stack is disabled, the preserved MSRs
> > > won't
> > > hurt host.
> > It might beg the question of if this solution will need to be redone by
> > some future Linux supervisor shadow stack effort. I *think* the answer
> > is no.
> 
> AFAICT KVM needs to be modified if host shadow stack is implemented, at least
> guest/host CET supervisor MSRs should be swapped at the earliest time after
> vm-exit so that host won't misbehavior on *guest*  MSR contents.

I agree.

> 
> > Most of the xsave managed features are restored before returning to
> > userspace because they would have userspace effect. But
> > XFEATURE_CET_KERNEL is different. It only effects the kernel. But the
> > IA32_PL{0,1,2}_MSRs are used when transitioning to those rings. So for
> > Linux they would get used when transitioning back from userspace. In
> > order for it to be used when control transfers back *from* userspace,
> > it needs to be restored before returning *to* userspace. So despite
> > being needed only for the kernel, and having no effect on userspace, it
> > might need to be swapped/restored at the same time as the rest of the
> > FPU state that only affects userspace.
> 
> You're right, for enabling of supervisor mode shadow stack, we need to take
> it carefully whenever ring/stack is switching. But we still have time to figure out
> the points.
> 
> Thanks a lot for bring up such kind of thinking!
> 
> > Probably supervisor shadow stack for Linux needs much more analysis,
> > but trying to leave some breadcrumbs on the thinking from internal
> > reviews. I don't know if it might be good to include some of this
> > reasoning in the commit log. It's a bit hand wavy.
> 
> IMO, we have put much assumption on the fact that CET supervisor shadow stack is not
> enabled in kernel and this patch itself is straightforward and simple, it's just a small
> brick for enabling supervisor shadow stack, we would revisit whether something is an
> issue based on how SSS is implemented in kernel. So let's not add such kind of reasoning :-)

Overall the patch looks OK to me.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

> 
> Thank you for the enlightenment!
> > > [*]:
> > > https://lore.kernel.org/all/806e26c2-8d21-9cc9-a0b7-7787dd231729@intel.com/
> > > 
> > > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > Otherwise, the code looked good to me.







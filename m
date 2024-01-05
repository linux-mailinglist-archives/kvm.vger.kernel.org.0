Return-Path: <kvm+bounces-5748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10A11825B99
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 21:28:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33F811C2341E
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 20:28:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED291360A3;
	Fri,  5 Jan 2024 20:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EhNo3h5F"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CC33608B
	for <kvm@vger.kernel.org>; Fri,  5 Jan 2024 20:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704486503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LBcU8Ucgw9WvEv4ml+FP6D15OBNp3BTNZQ7NFOWnOwY=;
	b=EhNo3h5FTACEnupvtX8TcFwI5fQ1jrSOT27varr5S4/7psNY5d4AgjyssZFkrqeq7Z5DoP
	s4uJFcBton0KXr8wQwcljxxcRPXOloJ9inKgND3JXCUI0Ddak8ok+x0dodFCoti6hm9Pr4
	CUmYKz6wfNMUERpUyY0CBxUnB8SsOfY=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-303-c-zEuH5cN5eJEjk2fUqHPA-1; Fri, 05 Jan 2024 15:28:22 -0500
X-MC-Unique: c-zEuH5cN5eJEjk2fUqHPA-1
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-4b743afa504so981540e0c.0
        for <kvm@vger.kernel.org>; Fri, 05 Jan 2024 12:28:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704486502; x=1705091302;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LBcU8Ucgw9WvEv4ml+FP6D15OBNp3BTNZQ7NFOWnOwY=;
        b=DzIX+JoCKzOyDsTe4xsGocX77YZk+YFrkpfHZEWnVM/fsE4W+TBweBUyeWjpb3sTuY
         aV/W0/J9Ib0DALouaXZks0X460ZB3fimdoizXAKXLLYsGZKr0MDxu5l8WLddMv91iwEE
         ozpDpuOHxTyYdPbjMmnw1ZuHJJMbIUKB2RWXEmdndG9szs5Q9LjSw5ED4iQ+vT2O/InH
         +XJMgQBYvXDUA4Q070RDbahP+IHTNBAeCwY8fFqhIGqwMXSiD09lJ9ohufgwDHvzCZ/N
         obO4FhVP2lkQnBFCNXyizfD+F9u9E/aBLscZr8+0l+Vg8qG08ISlEtQMF/jWwZO0KVvS
         mXug==
X-Gm-Message-State: AOJu0Yye42p5iSZ+nxLYRR/G8U8QegBVbQUz88dApE9soeVypMCuxqaY
	owYGg3+nBvE65/KCKvy/p/upT5vdyV4FWWmmTraZCqDGCI31dpRwIhd3MMM+4QhG9HBM8B4HNLq
	eA/xvfp374cXEHUwZngZwQ/fY+WragWM3spze
X-Received: by 2002:a05:6122:45aa:b0:4b7:49f9:c6f4 with SMTP id de42-20020a05612245aa00b004b749f9c6f4mr2001562vkb.4.1704486501819;
        Fri, 05 Jan 2024 12:28:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGpDQHytoso1sLg6hnmUDkdBNPRRBqKeJtkvYB7/gPCh6lk57PZqRfGAY6qPDWdrCcQuJAioLMk24w/y+nIyFA=
X-Received: by 2002:a05:6122:45aa:b0:4b7:49f9:c6f4 with SMTP id
 de42-20020a05612245aa00b004b749f9c6f4mr2001554vkb.4.1704486501520; Fri, 05
 Jan 2024 12:28:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240104205959.4128825-1-pbonzini@redhat.com> <20240104205959.4128825-2-pbonzini@redhat.com>
 <ZZhUzm9r5Z5l567Z@google.com>
In-Reply-To: <ZZhUzm9r5Z5l567Z@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 5 Jan 2024 21:28:09 +0100
Message-ID: <CABgObfYvuBeN6Vhp7TUBP9g8G8H2DvMQ=RJGWGNdCoS8k+AWfw@mail.gmail.com>
Subject: Re: [PATCH 1/4] KVM: introduce CONFIG_KVM_COMMON
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, ajones@ventanamicro.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 5, 2024 at 8:13=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
> > Start by introducing such a new Kconfig symbol, CONFIG_KVM_COMMON.
> > Unlike CONFIG_HAVE_KVM, it is selected by CONFIG_KVM, not by
> > architecture code.
>
> Why?  I don't get it, just have code that cares do IS_ENABLED(CONFIG_KVM)=
.  Except
> for the MIPS usage of HAVE_KVM that you solved by adding CPU_SUPPORTS_VZ,=
 I got
> all the way there using just CONFIG_KVM[*].
>
> Ah, and so does this series for the most part, the only usage of CONFIG_K=
VM_COMMON
> is in scripts/gdb/linux/constants.py.in.  Honestly, adding a Kconfig just=
 so that
> VMX's posted interrupts that arrive in the host can be printed when KVM i=
s built
> as a module is a waste of a Kconfig.

There is one extra thing that CONFIG_KVM_COMMON does, which is to
avoid having to select common requirements in all architectures.

I jotted this to solve the reported randconfig failure, which is why
CONFIG_KVM_COMMON only requires "select EVENTFD", but looking more
closely it should also select PREEMPT_NOTIFIERS and INTERVAL_TREE.
Both are used by virt/kvm/kvm_main.c, and loongarch + riscv both lack
INTERVAL_TREE so I do think it's a good idea to introduce this symbol
(though it requires a v2).

> [*] https://lore.kernel.org/all/20230916003118.2540661-12-seanjc@google.c=
om

I guess you mean
https://lore.kernel.org/all/20230916003118.2540661-8-seanjc@google.com/.

Paolo



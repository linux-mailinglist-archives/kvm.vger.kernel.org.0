Return-Path: <kvm+bounces-543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F00757E0BE4
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 00:10:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 52795B2075E
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 23:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B71FF250EF;
	Fri,  3 Nov 2023 23:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1GA1Hxyk"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279DE219E7
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 23:10:18 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E331BD
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 16:10:16 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-da0631f977bso3090664276.2
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 16:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699053016; x=1699657816; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NGYqbU2Pt3l58GxHHNn56r5S3wILmJgK40ILXYIhwmI=;
        b=1GA1HxykMWMhRIIVzJToDwLykI31ZDNJ+f1IWQ1dDKzLMbcbYGlMd98qGfCkweN/UE
         InUiKT7mHfx005NI5Qibdlm30xqO4CfuUcwDdEUEHtTkBmUHKQ5wLiH6nn5llGGGjDhC
         P/38oEXdHlVbp0dJi06wiUtx7xTrpWrAHpnp6jOtu1/uXK4V0l3HrWD6Y3wOLieu2MDr
         XrzdCfKGe+PwXckv2kTmtEq0ym0MkH7npz3xxD0H5TsTlu9PhVT1v8zk5d44vQDeOGmV
         hcHa1IoF81NZndHAFB6gfO4Vs6Vx7gbzjrF+N4g8UzfMSmDBTBVrdYJdKt7h4klRabdB
         cn1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699053016; x=1699657816;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NGYqbU2Pt3l58GxHHNn56r5S3wILmJgK40ILXYIhwmI=;
        b=laARMgb+u3EAZJAyTd2iKWmnaUbBoiJLAKINWmCd+Zgn5fGJmVGuzp/nfdJPltYDFu
         KBOrIlzO+koDXvH10zdjWS31lzywa4A+aevyC3ocXcMkPt0jaW+xc9Izm5loPExzf0Sm
         jV9QHuLU538uR3rrdGAaQxJZMHZ0GjY4TUsrpMG5Bs0aiOk7j5+h8Vei6GTL59xf4gKL
         vtGhd1S/GVUU6qZWWRKdk/tH15bba/fE03CxHkPShFHLNCMUO2nU/Co93g+l2MAPTefv
         TrWdOMfzg0W5lz5bpv7UZ9Q6dxJ0BTf0rQqoyGZvCWMyfVCLevxwP2h2oH8tHKjBJgEQ
         QJJw==
X-Gm-Message-State: AOJu0YyF+AUtYOi4LT+GvzUNy0BzGl4fHxNQbLUWYO4XWnM7UW8Afy8g
	G2oUtPfYbo+eNwb9/IJ1LfE/Utwc6dk=
X-Google-Smtp-Source: AGHT+IHqfufR9/zt4mNTXWa535MIbE/HOSJFf3xf59ZPSkzAgrlvBxT9Wi3CSIEs6ia/QcBMUrxJuOinaz8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2516:0:b0:d8b:737f:8246 with SMTP id
 l22-20020a252516000000b00d8b737f8246mr415633ybl.2.1699053016128; Fri, 03 Nov
 2023 16:10:16 -0700 (PDT)
Date: Fri, 3 Nov 2023 16:10:14 -0700
In-Reply-To: <b47e82a4-2c01-4207-b4f8-296243061202@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231002095740.1472907-1-paul@xen.org> <20231002095740.1472907-5-paul@xen.org>
 <ZUGQhfH3HE-y6_5C@google.com> <b47e82a4-2c01-4207-b4f8-296243061202@xen.org>
Message-ID: <ZUV91k9cUZt9jTbm@google.com>
Subject: Re: [PATCH v7 04/11] KVM: pfncache: base offset check on khva rather
 than gpa
From: Sean Christopherson <seanjc@google.com>
To: paul@xen.org
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	David Woodhouse <dwmw2@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 02, 2023, Paul Durrant wrote:
> On 31/10/2023 23:40, Sean Christopherson wrote:
> > On Mon, Oct 02, 2023, Paul Durrant wrote:
> > > From: Paul Durrant <pdurrant@amazon.com>
> > > 
> > > After a subsequent patch, the gpa may not always be set whereas khva will
> > > (as long as the cache valid flag is also set).
> > 
> > This holds true only because there are no users of KVM_GUEST_USES_PFN, and
> > because hva_to_pfn_retry() rather oddly adds the offset to a NULL khva.
> > 
> > I think it's time to admit using this to map PFNs into the guest is a bad idea
> > and rip out KVM_GUEST_USES_PFN before fully relying on khva.
> > 
> > https://lore.kernel.org/all/ZQiR8IpqOZrOpzHC@google.com
> 
> Is this something you want me to fix?

Yes?  I don't want to snowball your series, but I also really don't like the
confusion that is introduced by relying on khva while KVM_GUEST_USES_PFN is still
a thing.

Can you give it a shot, and then holler if it's a bigger mess than I'm anticipating?
I'm assuming/hoping it's a relatively small, one-off patch, but I haven't actually
dug through in-depth to figure out what all needs to change.


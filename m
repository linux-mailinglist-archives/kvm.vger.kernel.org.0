Return-Path: <kvm+bounces-1218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E55E97E5B9B
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 17:43:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21CE41C20B31
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 16:43:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D09C43032C;
	Wed,  8 Nov 2023 16:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="weZvbPdw"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5864E18C21
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 16:43:12 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8C11FE7
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 08:43:11 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-da0631f977bso8399629276.2
        for <kvm@vger.kernel.org>; Wed, 08 Nov 2023 08:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699461791; x=1700066591; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4E/b9HBc1xBMsLHpP255Zqp8aT/FkdqVSdO5buB1hG4=;
        b=weZvbPdw0xyq0UAvqqRPDVjh5FFMN2laAPi3dmbN2YezAPDJn/Pv7YZwA++UGMa6q+
         EiOsZKBOxCZ8TIYr/K/Fi2qMg5pbdEYLN2xdATbjS9FaVnifBzoFc11s0913svrOeIY2
         5WxRtchHPSrhM00N02QmCo2E7pdRhRQdkrC95Fb/CZicT3zrrvKdvAyazKF0LtuWOeCn
         nc5MQY4QgmC2TRuaSTAwfuSEochcLt/r1xYOrGFWXLsyUHqdSGS9bHNhaIe5in8DGN0h
         4cRgeNXVWfnXRLO/2Iclp83p3SGtF0fAlqAsp6itmuxgWCii+0Z7PMFMtUoGguxnhuuy
         966g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699461791; x=1700066591;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4E/b9HBc1xBMsLHpP255Zqp8aT/FkdqVSdO5buB1hG4=;
        b=amgcaaBcXw0/22GOYUUCG7tMwqqXk2CmX+b8RyYkj5qBOhUNmtMHV6IfGk8ZYkuIbs
         4Xq3x2VDAewhouqA4SH3M/TJs2QFtZ/hC4iZDim4z2N79ZL8ROEbz/Y+GkFBqKlyLCiR
         W44xIq2nIn6Z+4bquCioE+U2bR8zYb8m3djPz9+9sH4AVAORkWNFxf6lnJ3rynJHHIs0
         SZkMkZmPfkZ/HVxc9Yo8qPH5rGO/eCPEpX8ExXDwII9/zWJsYvtgUPUpZylWTXvVU2+D
         jlGHmO6vkkIjSRf/DNv+6ns71dsCnRqTiu4PbyI9A8ceO7Y6uiWAoCiLwvmK/zzKqrmP
         mVKQ==
X-Gm-Message-State: AOJu0YzaC8xOsy6b+c0m/q7l0CrtPM/5txdBDdLhloeYr3x/rkZQCX//
	MPgbHbRilr5krN5XfBq5BjfmxuP5VxA=
X-Google-Smtp-Source: AGHT+IHUR9RD0SVwOOmAqAjm9rgqqd/alRUffuaUxofCzdpXVbic9A9T6fssT2FkYnEvva7bggL135WgKdA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:3247:0:b0:d9a:ca58:b32c with SMTP id
 y68-20020a253247000000b00d9aca58b32cmr43372yby.1.1699461790981; Wed, 08 Nov
 2023 08:43:10 -0800 (PST)
Date: Wed, 8 Nov 2023 08:43:09 -0800
In-Reply-To: <075453e1-830e-43bc-8888-7e5e4888223f@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108111806.92604-1-nsaenz@amazon.com> <20231108111806.92604-26-nsaenz@amazon.com>
 <075453e1-830e-43bc-8888-7e5e4888223f@amazon.com>
Message-ID: <ZUu6nSk0jqpYpxoM@google.com>
Subject: Re: [RFC 25/33] KVM: Introduce a set of new memory attributes
From: Sean Christopherson <seanjc@google.com>
To: Alexander Graf <graf@amazon.com>
Cc: Nicolas Saenz Julienne <nsaenz@amazon.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com, 
	anelkz@amazon.com, dwmw@amazon.co.uk, jgowans@amazon.com, corbert@lwn.net, 
	kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com, 
	x86@kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 08, 2023, Alexander Graf wrote:
> 
> On 08.11.23 12:17, Nicolas Saenz Julienne wrote:
> > Introduce the following memory attributes:
> >   - KVM_MEMORY_ATTRIBUTE_READ
> >   - KVM_MEMORY_ATTRIBUTE_WRITE
> >   - KVM_MEMORY_ATTRIBUTE_EXECUTE
> >   - KVM_MEMORY_ATTRIBUTE_NO_ACCESS
> > 
> > Note that NO_ACCESS is necessary in order to make a distinction between
> > the lack of attributes for a gfn, which defaults to the memory
> > protections of the backing memory, versus explicitly prohibiting any
> > access to that gfn.
> 
> 
> If we negate the attributes (no read, no write, no execute), we can keep 0
> == default and 0b111 becomes "no access".

Yes, I suggested this in the initial discussion[*].  I think it makes sense to
have the uAPI flags have positive polarity, i.e. as above, but internally we can
invert things so that the default 000b gives full RWX protections.  Or we could
make the push for a range-based xarray implementation so that storing 111b for
all gfns is super cheap.

Regardless of how KVM stores the information internally, there's no need for a
NO_ACCESS flag in the uAPI.

[*] https://lore.kernel.org/all/ZGfUqBLaO+cI9ypv@google.com


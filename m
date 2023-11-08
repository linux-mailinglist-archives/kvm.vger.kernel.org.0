Return-Path: <kvm+bounces-1215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 54D7D7E5AD3
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 17:11:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F33B281646
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 16:11:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A54230D08;
	Wed,  8 Nov 2023 16:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z38J8OwT"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A611BDDA
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 16:11:05 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429C91FE8
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 08:11:05 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-da0c7d27fb0so8050194276.1
        for <kvm@vger.kernel.org>; Wed, 08 Nov 2023 08:11:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699459864; x=1700064664; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SCyKbBYBcpAJ2v4LwtdWLPucCqpggSO4tuF11LbpeUo=;
        b=Z38J8OwTOMzg0ZKkMEdHyv/RLPGlEISvgB2MZxpkcqKIVJ57SAWDNtLcnc6lpO2LFY
         rhFGFVjHqk2YojbL83tOAT7vSypb3F9pCi0O8cgCArtCwQjz48vcdqd8P+LWtMY0z8Gq
         tvII1XfL0uCq1JjvGeuXx3nRHD4TzZBmkvkB4v1YKeXH+l+Zs6a6hbzqhr9GVdbh9Loz
         ZZAkIEag3smj3s/F5WuSHnX8CvZ+nRSVpRTJ2I12w/mp/fPpaOjHzBaB56ZjAmdzIPd+
         3zW469u2DJ+wQk8CeRN0grCRH7l7w4e0t0JQWVzxHdF0rX70kqjbmUi90+nHKosnakKR
         vF5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699459864; x=1700064664;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SCyKbBYBcpAJ2v4LwtdWLPucCqpggSO4tuF11LbpeUo=;
        b=QrsDEg9KLrkklRHRpV1eY+x0Lv8lOdYGbLQ1A4N+MiNEyTyd50TL2MUy7wOV1X+A3P
         jZvLRbcXVeAxa5WwMVjDPwLFPNXjt1CBkTJuf0A8Q1gdh0bMIe+4L0UYXiqKBLH4UFQj
         dOXB6KD/RDQ5r6PkWAS6HOtdOZ6mCGURFvO7aePTtDFL7XUrl0+I7+Ze7WQy5m6eIcBv
         8XV8wQD5tyZmTMlv1yzlqY2S9pi0pkau5LhYKW1CSkgrqMvHmNzAcvP1FhZcJcm03fKM
         mHrno+e+wCYcOv5Mj1A4uqAWAY9lgdNWOmb4qN97hoPktUH81WjNoFAMUR7/K8PZRUWY
         6M3w==
X-Gm-Message-State: AOJu0YyfFuU0jX6zjER+iAcxfw23TdVsR7t/wKAGtmqFppg5huEeKzi6
	wxRpI9GfqWz4JG6MyQCH+srHCBrCW5I=
X-Google-Smtp-Source: AGHT+IElPBL0TUz47UKKevcrQ52vnzXf3uBAKsqEBbIPFRFkQe5teIswfhYivY589qMtJ1q1v1W1c+yk5QU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:24c:b0:da3:ba0f:c84f with SMTP id
 k12-20020a056902024c00b00da3ba0fc84fmr40900ybs.4.1699459864456; Wed, 08 Nov
 2023 08:11:04 -0800 (PST)
Date: Wed, 8 Nov 2023 08:11:02 -0800
In-Reply-To: <20231108111806.92604-2-nsaenz@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108111806.92604-1-nsaenz@amazon.com> <20231108111806.92604-2-nsaenz@amazon.com>
Message-ID: <ZUuzFshjO7NO5k3b@google.com>
Subject: Re: [RFC 01/33] KVM: x86: Decouple lapic.h from hyperv.h
From: Sean Christopherson <seanjc@google.com>
To: Nicolas Saenz Julienne <nsaenz@amazon.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com, 
	anelkz@amazon.com, graf@amazon.com, dwmw@amazon.co.uk, jgowans@amazon.com, 
	corbert@lwn.net, kys@microsoft.com, haiyangz@microsoft.com, 
	decui@microsoft.com, x86@kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 08, 2023, Nicolas Saenz Julienne wrote:
> lapic.h has no dependencies with hyperv.h, so don't include it there.
> 
> Additionally, cpuid.c implicitly relied on hyperv.h's inclusion through
> lapic.h, so include it explicitly there.
> 
> Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
> ---

FWIW, feel free to post patches like this without the full context, I'm more than
happy to take patches that resolve header inclusion issues even if the issue(s)
only become visible with additional changes.

I'll earmark this one for 6.8.


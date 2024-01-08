Return-Path: <kvm+bounces-5835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53A4582732F
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 16:31:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0028285E39
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 15:31:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FCA65027B;
	Mon,  8 Jan 2024 15:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I23rHSrz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FA75100F
	for <kvm@vger.kernel.org>; Mon,  8 Jan 2024 15:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6d9c07b2372so1945658b3a.1
        for <kvm@vger.kernel.org>; Mon, 08 Jan 2024 07:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704727873; x=1705332673; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eVwH1RL2tUEUDKe0d7KFQLzt8tFJlNZHVTEPUbq4Tr8=;
        b=I23rHSrz6sYOW6xFP4ymdxyf9pB/FHS0eyAYShk7dFDmZ/L2gWBTE9/xyRWr+m6nh4
         JUdZMtu8IznQ1Lp3QeDRY1cvu8eWu/mpMrE2zz/buoHxem+/QQEoecL+p/y8B+qRbBbg
         cqoV+OJMSsLrIH8GLevC+3SLrt9+Or6EsAgBTyKE27QFu870+JzPpWeFw5mVKBZz7GWS
         IDd+SektVB/stzqsHMKIPMPqzLvUyB3/gTBr4b7x31FMNGPHUqrcMioiVtyzs8SD3cKG
         4EGVQlc60L6W8gn/OH2AZeO6n72Czmj65mKgbGH6PAv3PdL7omqyHaw3FjN758RONcF4
         6MDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704727873; x=1705332673;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eVwH1RL2tUEUDKe0d7KFQLzt8tFJlNZHVTEPUbq4Tr8=;
        b=vzFgpk5mvEfD405dbx8Brm3DpWW9lgw+dPnoz1O7gzxTqL42s2txnEzzHTXUhqjcrP
         52drXsG9Pe/VviMiSCwXJsN+5T5OnS2WhRE5X8gGpL2iRtuYUD5qi9eDVIL9KSXpiZqR
         fvPIhX552NC2qrgIviJn4UfTy5a3MzSRA5iVY5MPo/g/lneYBq+FxiOA123kTCOOgVh1
         JvfYjuz6yANS6NwSeW/BK5HTYCFwWeW4JuxYNui21QbCWytbXAzraaKyikUUFwSyj/py
         Jp07aFC3Ajpwm2bd80Emgb162q1ONdSY5j19Z/y8OwMb+3FiTI/Y4mbXTVpXH+/tIeuh
         wzYA==
X-Gm-Message-State: AOJu0Yy2ThucWbnm0UI4OLQqtCmZljkEXreFo5+pDMIJspBwhe+hygnK
	qd+WtmvCMe6XRztlLAWE61aZW+kD4hQVXcN57g==
X-Google-Smtp-Source: AGHT+IGn5/q07JNwWlMgGSFZqxloursLKBN2q/lnhLIJj2dqxL54a6Uoanxg9la8tfBTT0f+IFjpkVnm+zU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:acd:b0:6d9:bcaf:5f16 with SMTP id
 c13-20020a056a000acd00b006d9bcaf5f16mr362033pfl.3.1704727873475; Mon, 08 Jan
 2024 07:31:13 -0800 (PST)
Date: Mon, 8 Jan 2024 07:31:12 -0800
In-Reply-To: <20240108125228.115731-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240108125228.115731-1-pbonzini@redhat.com>
Message-ID: <ZZwVQCnrg0ZmEP2B@google.com>
Subject: Re: [PATCH] KVM: x86: add missing "depends on KVM"
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 08, 2024, Paolo Bonzini wrote:
> Support for KVM software-protected VMs should not be configurable,
> if KVM is not available at all.
> 
> Fixes: 89ea60c2c7b5 ("KVM: x86: Add support for "protected VMs" that can utilize private memory")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Good job, me.

Reviewed-by: Sean Christopherson <seanjc@google.com>


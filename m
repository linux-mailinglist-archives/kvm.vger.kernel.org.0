Return-Path: <kvm+bounces-492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 874AF7E042A
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 15:02:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F4E4281C15
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 14:02:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6035D19461;
	Fri,  3 Nov 2023 14:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hYvYIue6"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD28C18643
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 14:02:12 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3F0D42
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 07:02:11 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a7bbe0a453so28101597b3.0
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 07:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699020130; x=1699624930; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vb+9RYEjnomUPpbNpxqOTLjP3moxOF2MeghLG8Ocm5Q=;
        b=hYvYIue6naFKM5SdZNzv3pM4bor9uY+uQjF4or5O9sGazevZ+YOhkEBNnBYwD8SIPJ
         TnNaYTeFZFgQ6kzYn1WaCpLWp6oqiIISEJTLhIhblinHLs24mY18dx/Lw7q03KU9f43l
         v0CCPKNbKHa7Z1N7uoqtVGlKTfJU1DaglNOvH9ueMO7mIfZocnFakr3PNVDbiMU5mT1R
         q3p5Zy451LivN8EHZc2p4hMyJb5KUrNoQkk29vj11w5YU++BiF3ph14PpNq5Xw99j6Jz
         1BsEPWoEf2nD+idkA8GAzWsyJm5D9bEP0ze4lh8BUsiFGE2Y9nl/lXVVUBjsIg/wNyR4
         YCUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699020130; x=1699624930;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vb+9RYEjnomUPpbNpxqOTLjP3moxOF2MeghLG8Ocm5Q=;
        b=g+g67nvdJrRLPd1RHQnZ7anUT3Wtt3Q40bpXioZnTh82NtbAUIOlRdReOQuKb26IYe
         RRXjs20yNv0wPzfVm+Nz6uhHBBIUriztJ7CcH1kj0eTRgE0psGgQnvIGkl9Eej5VfNUY
         /PjwVKezjsTYwqmFNpka/rUfjGIPFTSF0el31WxbNQBeNYzCJF3/buiOI9Oov3IDa3YW
         NTHUuyh5qq+5pZwcAA9Hmalnl/9iJBnRj1I8FQqxgJDWIKB6zrGmQPvYky31cullZ2L5
         df1zY5RTVO5WufFCTd4yIbtC1qhLNhyapqkhuP4kvz/pYOfqloU8JZtyRMsIZT+wtHm9
         BS0g==
X-Gm-Message-State: AOJu0YzaCZmImVQuO4KS09YEPMrXECNFhPlnhW2aonSIdXh5KFdv39Jq
	joF8PTb4YnvrFZXC5+xEjAVvi7HMofY=
X-Google-Smtp-Source: AGHT+IGEA1BvGiRWNQjrbq7aKq8bZ+jodDO8Ix7KIjtF8dmXoXMo1O1r7lSdH3mz9BX0C3GycpAGBkiz/BY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:5215:0:b0:5a7:acc1:5142 with SMTP id
 g21-20020a815215000000b005a7acc15142mr55197ywb.8.1699020129602; Fri, 03 Nov
 2023 07:02:09 -0700 (PDT)
Date: Fri, 3 Nov 2023 07:02:07 -0700
In-Reply-To: <10fd9a3e-1bc2-7d4d-0535-162854fc5e9d@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-15-weijiang.yang@intel.com> <2b1973ee44498039c97d4d11de3a93b0f3b1d2d8.camel@redhat.com>
 <ZUKTd_a00fs1nyyk@google.com> <10fd9a3e-1bc2-7d4d-0535-162854fc5e9d@intel.com>
Message-ID: <ZUT9X9GbDbkHRhd5@google.com>
Subject: Re: [PATCH v6 14/25] KVM: x86: Load guest FPU state when access
 XSAVE-managed MSRs
From: Sean Christopherson <seanjc@google.com>
To: Weijiang Yang <weijiang.yang@intel.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dave.hansen@intel.com, peterz@infradead.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 03, 2023, Weijiang Yang wrote:
> On 11/2/2023 2:05 AM, Sean Christopherson wrote:
> > /*
> >   * Returns true if the MSR in question is managed via XSTATE, i.e. is context
> >   * switched with the rest of guest FPU state.
> >   */
> > static bool is_xstate_managed_msr(u32 index)
> 
> How about is_xfeature_msr()? xfeature is XSAVE-Supported-Feature, just to align with SDM
> convention.

My vote remains for is_xstate_managed_msr().  is_xfeature_msr() could also refer
to MSRs that control XSTATE features, e.g. XSS.


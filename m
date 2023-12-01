Return-Path: <kvm+bounces-3051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30E61800158
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 02:56:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0C8C1B20FAF
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 01:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B30A4C63;
	Fri,  1 Dec 2023 01:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="flXo4wpJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F38619E
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 17:56:38 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5d032ab478fso28145117b3.0
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 17:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701395797; x=1702000597; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iI4oVwt8TD6xPM293sLOSQhO8NJlm+MJKlwZRhcjGtY=;
        b=flXo4wpJ+b0zdsz3T81Jxzr1ovb8MjzJIbJhC95EmQCHnnUCOPYDD+594dWwP3XjvL
         nTKAXVl/I+pKt1WSPxrAyS7AqfcNdeL3miagcSoIde9zGeyvs7/xhcbZ+DFLS9n6YzFM
         CYwhJz1UK1wVIYEL6ljQcbcJAswcOiu8bYdzNhRZYjv0rPKqm34zgH1F1Ple81D6R35p
         +UGO5fCUa6fXWrxO3rY/FIMGJAxx8x3ih9+0n6/TTS1hxPKPLnyaLI7gG5HJb2qXjyPW
         daNGXR1PXu6G7KUKnOzVVtzYN2IRKFGmVggE1YrR6KjA5Y3L8oqb8adT9ducECRe+gBI
         STWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701395797; x=1702000597;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iI4oVwt8TD6xPM293sLOSQhO8NJlm+MJKlwZRhcjGtY=;
        b=DzttG3gu4irbwUbhzyctKqmj0zjaO64nZLz8wOzDM8SMYo6fNjh57+176SJFQCaToX
         vROD2FE/FHRKySzrrZg1Bb0J3bhocoTlJO1gTBzExktXpC+vcxyDMhxZCKi/e9ezbSGe
         eHNG3Fd06Eh0SGOHTcS0l5SQdWOtd8T4gFDY+e+wDYNGIciwzBrM0O7P6Y8/vbF44Ury
         RwwIQ2GlCFrMHwyz6c1b7ymd1F5SIyXjWxbtIVQVGzViBBOidgjO7Rv0NSwsmvr+DJj/
         yQuheNTz+XFbly4Z266FHtlxTF7XRU21WTdF/Q3V5HF9YzBsIVDJAhn9JnmcggkGxQWe
         qG9A==
X-Gm-Message-State: AOJu0YzjZ9fVuzvWGFAR1omfpHbiVLvxPGxp1RdblJmCdi2Cl5cM2ELg
	2FZ622h8S6vGog1QOcyKGgCmOxKqGhM=
X-Google-Smtp-Source: AGHT+IETi2Qic31wESuQIdytaz+n6fY1W/iil7+kMH3zUIefQfN66dqXBkfgXXc0+CDA4lvTWk2F/VuX1V8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2e87:b0:5cc:3d0c:2b60 with SMTP id
 eu7-20020a05690c2e8700b005cc3d0c2b60mr651819ywb.4.1701395797734; Thu, 30 Nov
 2023 17:56:37 -0800 (PST)
Date: Thu, 30 Nov 2023 17:52:30 -0800
In-Reply-To: <20231018192021.1893261-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231018192021.1893261-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <170137748541.663660.2513750001573904834.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: SVM: Don't intercept IRET when injecting NMI and
 vNMI is enabled
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Santosh Shukla <santosh.shukla@amd.com>, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 18 Oct 2023 12:20:21 -0700, Sean Christopherson wrote:
> When vNMI is enabled, rely entirely on hardware to correctly handle NMI
> blocking, i.e. don't intercept IRET to detect when NMIs are no longer
> blocked.  KVM already correctly ignores svm->nmi_masked when vNMI is
> enabled, so the effect of the bug is essentially an unnecessary VM-Exit.
> 
> KVM intercepts IRET for two reasons:
>  - To track NMI masking to be able to know at any point of time if NMI
>    is masked.
>  - To track NMI windows (to inject another NMI after the guest executes
>    IRET, i.e. unblocks NMIs)
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/1] KVM: SVM: Don't intercept IRET when injecting NMI and vNMI is enabled
      https://github.com/kvm-x86/linux/commit/72046d0a077a

--
https://github.com/kvm-x86/linux/tree/next


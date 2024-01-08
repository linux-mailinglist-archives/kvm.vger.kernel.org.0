Return-Path: <kvm+bounces-5815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D23CB826F39
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 14:06:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B2BC1F22933
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 13:06:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DF684121E;
	Mon,  8 Jan 2024 13:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QYTxQ3iM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7439F4438E
	for <kvm@vger.kernel.org>; Mon,  8 Jan 2024 13:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704719153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MSX3nYbKAInL2lO53hdL7SWj/GcywMaxIpVqkN2c9ew=;
	b=QYTxQ3iMVScDRTOBaZwFP4MuNrJ5mexWi8w8kmnt3AVuVYmwifuZgtKkI/3J1ZKJqyhj6S
	ptq6BY655NmTzwcqf50T8qI0lwySi0ftmG8bjE8Ev9wohg5SHTJXVdFe5k9Q0l22uZLRZj
	WZKA8xmbyjUqPCXiF1h4sI7Adh0eANY=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-235-ZN_ySsxNMguJLlIJL5Jv-Q-1; Mon, 08 Jan 2024 08:05:52 -0500
X-MC-Unique: ZN_ySsxNMguJLlIJL5Jv-Q-1
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-6dbfcff597bso2480249a34.1
        for <kvm@vger.kernel.org>; Mon, 08 Jan 2024 05:05:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704719151; x=1705323951;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MSX3nYbKAInL2lO53hdL7SWj/GcywMaxIpVqkN2c9ew=;
        b=PQk3rVSLUwbi0YIO6NPy2cbUgP0FxuJUcMtShMLM9qfA4S8v3SQpjkfAs23jL0Pw5k
         aPY1c0vdc8lAHy0WCx3Mpfo/G53PcnbEIxKYEGiDXqpJPnXHriWWSFpXfJF8lBl9nj3t
         UVCa2VymZvAQw7DCqcGcWRraQS6yfQIqpNEhKWRVrncza0dGrCAnR0A2m6cJnHiiRTPE
         wKD8MMSKSyy9bzrWiN8O7oznmBWJzs2iGJDfMuTNaKWoDpoPBhAam5vlWsg3kalqfhJZ
         dqNh4bWpnWhaSEVnKY3x60qyG3ZrM5DgGCnJUfB3PmP4BnRUeQZOZxZuxvYnizbOirDz
         q8aw==
X-Gm-Message-State: AOJu0YzXq3nyhpH+bPg3qS8WxiTFQI/GvqJw9EpUyX5nlefOyoLJqYUU
	AjPwJD96XyOAB2DjItcHAH/KodFySupqZzqB82Yh5tjUMarD5uxpF5O8oRIuu0q47MqOq1Y1u9t
	EBKst6G0r3Wfhznt2zaFs/FujhEPaWsMvwQHnB2MTUpzWsto=
X-Received: by 2002:a9d:7542:0:b0:6dd:ddd8:51e5 with SMTP id b2-20020a9d7542000000b006ddddd851e5mr145283otl.43.1704719151064;
        Mon, 08 Jan 2024 05:05:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFMeJIU5WG9Qip1T66Sz6kbbrtlIm+lDRKZqrxLIR7uVSQGfZR4nk+nvhq5Z3kGqX2QTEcSfX47y9kgru6C8D4=
X-Received: by 2002:a9d:7542:0:b0:6dd:ddd8:51e5 with SMTP id
 b2-20020a9d7542000000b006ddddd851e5mr145268otl.43.1704719150318; Mon, 08 Jan
 2024 05:05:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240104193303.3175844-1-seanjc@google.com> <20240104193303.3175844-8-seanjc@google.com>
In-Reply-To: <20240104193303.3175844-8-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 8 Jan 2024 14:05:38 +0100
Message-ID: <CABgObfaS3gFM3RZBjm9fiY0VAB2u3NrAMJ2QcyB23Di8XjXgBQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: SVM changes for 6.8
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 4, 2024 at 8:33=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> A few minor fixes and cleanups, along with feature "enabling" for flush-b=
y-ASID
> to play nice with newer versions of VMware Workstation that require it.
>
> The following changes since commit e9e60c82fe391d04db55a91c733df4a017c28b=
2f:
>
>   selftests/kvm: fix compilation on non-x86_64 platforms (2023-11-21 11:5=
8:25 -0500)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-svm-6.8
>
> for you to fetch changes up to 72046d0a077a8f70d4d1e5bdeed324c1a310da8c:
>
>   KVM: SVM: Don't intercept IRET when injecting NMI and vNMI is enabled (=
2023-11-30 12:51:22 -0800)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVM SVM changes for 6.8:
>
>  - Revert a bogus, made-up nested SVM consistency check for TLB_CONTROL.
>
>  - Advertise flush-by-ASID support for nSVM unconditionally, as KVM alway=
s
>    flushes on nested transitions, i.e. always satisfies flush requests.  =
This
>    allows running bleeding edge versions of VMware Workstation on top of =
KVM.
>
>  - Sanity check that the CPU supports flush-by-ASID when enabling SEV sup=
port.
>
>  - Fix a benign NMI virtualization bug where KVM would unnecessarily inte=
rcept
>    IRET when manually injecting an NMI, e.g. when KVM pends an NMI and in=
jects
>    a second, "simultaneous" NMI.
>
> ----------------------------------------------------------------
> Sean Christopherson (4):
>       Revert "nSVM: Check for reserved encodings of TLB_CONTROL in nested=
 VMCB"
>       KVM: nSVM: Advertise support for flush-by-ASID
>       KVM: SVM: Explicitly require FLUSHBYASID to enable SEV support
>       KVM: SVM: Don't intercept IRET when injecting NMI and vNMI is enabl=
ed
>
>  arch/x86/kvm/svm/nested.c | 15 ---------------
>  arch/x86/kvm/svm/sev.c    |  7 +++++--
>  arch/x86/kvm/svm/svm.c    | 18 ++++++++++++++++--
>  3 files changed, 21 insertions(+), 19 deletions(-)
>



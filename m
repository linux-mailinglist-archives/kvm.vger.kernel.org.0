Return-Path: <kvm+bounces-206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B4807DCFBF
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 15:55:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C8B81C20BF7
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 14:55:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D06091DFD5;
	Tue, 31 Oct 2023 14:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V3HMxBgN"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D651D525
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 14:55:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43B7E8
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 07:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698764138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1YCRruDl6OMQ5U1GQ6BskW58Z9wjcFbobewT68lDnqA=;
	b=V3HMxBgNym4xDD4o8jecPMcs0DdKONul2sNyirfjZ21c/mDZ4qUTMQvtSCy78oU3mFddEy
	ESKAMDWKtYw0TEUYqXcsFO1JShKMrsXJEASUWD11qM0JLlYRyhiJAje3iSrJzn8eZPfiHC
	o50yH/MKDHaBHfcki5pnH4/QCwrRD2c=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-Om-JIFTWNmSAxYuNoUDHnA-1; Tue, 31 Oct 2023 10:55:31 -0400
X-MC-Unique: Om-JIFTWNmSAxYuNoUDHnA-1
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-7ba867fd1f1so85106241.2
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 07:55:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698764131; x=1699368931;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1YCRruDl6OMQ5U1GQ6BskW58Z9wjcFbobewT68lDnqA=;
        b=fRALv2Sg9yQASzMMud1sv2L8ppf5qMgC0Dkgjf/F9oAM2vL7ws+YUk2i/UJspXswfN
         LAQT91d5jGixubJ5XgOxm1ymHUQs/HA7CMJSTC3mJMkeBRejFUMzr6yuFh7U4Ofx/t9p
         w+NDGOiGyK9mQ7a11T4cdEz9n64mvtrZvMI8SR1rK0KrLfCNNeupm2o8I/GpZyKWtpZ1
         W9YGQkBGvi/ePjQITXUVg9IM/9huDPnbXIL6/fT1KaZwT2tE22gQHqsB42aABDuJXAxk
         Miw9k4Ka2yWP663oBLQlQehDv07wff/4n9yek85qmSJ+LcHKVGpW3/9mbtI9vGejAuLk
         EVsA==
X-Gm-Message-State: AOJu0YxrtP4TZFwf78uXc1DwHUZdKc1VZuQjDX/878NdF6RyMSxRn3/l
	gJ9MtvqxUQNTFg03aHxqwFN5eoQO/CO6JG0Y2DLZvSHVWn9EwwwJDnE/3x5KCFagIzodd8mp/Vx
	nNqiw8e8ogywX98lYrWZJHM+tFuDUJLMpzrA4
X-Received: by 2002:a67:c29c:0:b0:457:fbe2:b8f with SMTP id k28-20020a67c29c000000b00457fbe20b8fmr11706255vsj.10.1698764130183;
        Tue, 31 Oct 2023 07:55:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFAXxnaP57nokfR3Tx/vX2Yin3rTsz3GNvzufgEQz//hZr645kybcUed77JHMhu9kMGhV4N9spVToWKcQqNL2c=
X-Received: by 2002:a67:c29c:0:b0:457:fbe2:b8f with SMTP id
 k28-20020a67c29c000000b00457fbe20b8fmr11706218vsj.10.1698764129460; Tue, 31
 Oct 2023 07:55:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231027204933.3651381-1-seanjc@google.com> <20231027204933.3651381-7-seanjc@google.com>
In-Reply-To: <20231027204933.3651381-7-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 31 Oct 2023 15:55:17 +0100
Message-ID: <CABgObfarUg_qsGBnDyHGEXdazq8NPuzjpwdnHbDE6o5jOOou8g@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: SVM changes for 6.7
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 27, 2023 at 10:49=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> An enhancement to help userspace deal with SEV-ES guest crashes, and clea=
nups
> related to not being able to do "skip" emulation for SEV guests.
>
> The following changes since commit 5804c19b80bf625c6a9925317f845e497434d6=
d3:
>
>   Merge tag 'kvm-riscv-fixes-6.6-1' of https://github.com/kvm-riscv/linux=
 into HEAD (2023-09-23 05:35:55 -0400)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-svm-6.7
>
> for you to fetch changes up to 00682995409696866fe43984c74c8688bdf8f0a5:
>
>   KVM: SVM: Treat all "skip" emulation for SEV guests as outright failure=
s (2023-10-04 15:08:53 -0700)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVM SVM changes for 6.7:
>
>  - Report KVM_EXIT_SHUTDOWN instead of EINVAL if KVM intercepts SHUTDOWN =
while
>    running an SEV-ES guest.
>
>  - Clean up handling "failures" when KVM detects it can't emulate the "sk=
ip"
>    action for an instruction that has already been partially emulated.  D=
rop a
>    hack in the SVM code that was fudging around the emulator code not giv=
ing
>    SVM enough information to do the right thing.
>
> ----------------------------------------------------------------
> Peter Gonda (1):
>       KVM: SVM: Update SEV-ES shutdown intercepts with more metadata
>
> Sean Christopherson (2):
>       KVM: x86: Refactor can_emulate_instruction() return to be more expr=
essive
>       KVM: SVM: Treat all "skip" emulation for SEV guests as outright fai=
lures
>
>  arch/x86/include/asm/kvm-x86-ops.h |  2 +-
>  arch/x86/include/asm/kvm_host.h    |  4 +--
>  arch/x86/kvm/svm/svm.c             | 50 ++++++++++++++++----------------=
------
>  arch/x86/kvm/vmx/vmx.c             | 12 ++++-----
>  arch/x86/kvm/x86.c                 | 22 +++++++++++------
>  5 files changed, 45 insertions(+), 45 deletions(-)
>



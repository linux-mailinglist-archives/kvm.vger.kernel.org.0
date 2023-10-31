Return-Path: <kvm+bounces-204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 026E97DCEEC
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 15:22:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 323E01C20C57
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 14:22:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B710C1DFCE;
	Tue, 31 Oct 2023 14:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CRMRbyHj"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BFB1DFC0
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 14:22:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C91BC9
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 07:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698762134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xTQ9peqnSDJoBFuGuy2zfzNkYJ1d26aC7/ftaOk3pZs=;
	b=CRMRbyHjdfSQlptg95125FTYvhVgIp9b2l27+2U2zhMWAIbKf+0VS7yCZ2h5vzY9uOoWOa
	rlC7bM97mzAFZrganxPJ4M6NZDDWZn2Sje5ROm5GaWAX+B77JILKP1nNDWNcKiLJLK8PDu
	lum9Gni6u7N8JZu68gpx1H3IvcVZf7E=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-Za_KaI2uN0aOzewhXB7psA-1; Tue, 31 Oct 2023 10:22:13 -0400
X-MC-Unique: Za_KaI2uN0aOzewhXB7psA-1
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-7ba0dce992cso1051876241.2
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 07:22:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698762132; x=1699366932;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xTQ9peqnSDJoBFuGuy2zfzNkYJ1d26aC7/ftaOk3pZs=;
        b=vAqDRYGQiO60v70JFCvDyOp1xZySKqdQRX+hwjUTmxHZKhPRhEF0Dal53U4T07hDNj
         UvlKNiDu70KYGdblFdZ7j3TlUQ8E/PjDcpH6CICqzqNrPPfyXvMHpRABRWadBM6Aark5
         4SkzbH1dCw3O1z2Cjpp9/YEME0FTusrQKuiu9X1M8d8+qtUU4XFDHn943yPEercMKCUf
         R7MAhmmQaFQANPmcCui4+PJ42Yt8402XtZ+Ok3mRu9VFS8G6EA26LFCCrGr1j5rg/yVI
         Yfz2wOhTjhogpZEJnOUWWqUFtFjB6FdcGPZbEqdf0eJsnFrPgFwTg8jWhdVQjViXtTkX
         4AXg==
X-Gm-Message-State: AOJu0YwBfXR1TfxBJU42suZ1Ei5UNlPmPBfNpq0Z2PokEPNJzmIJJpo4
	l//TGrySDfyhNJ4xdqSAKr1HTHRjzTPxmMaKdoke2/3dxhItY5Q7pTeGwKJq0eMMVTvOLzywfEm
	P4nqUkEStLwortttMsKe7Yt22oXoW6H1Es8NT
X-Received: by 2002:a67:e08b:0:b0:457:bbd5:23fd with SMTP id f11-20020a67e08b000000b00457bbd523fdmr11490501vsl.9.1698762132337;
        Tue, 31 Oct 2023 07:22:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHX1VOGY6Vv0/6Cc+cQHaz240fhBPnWaKTAJjlxBn/ZofHFAxyJMKJ0y2qNcZbeqg1kqPA40cyHEWFvomJiS5Q=
X-Received: by 2002:a67:e08b:0:b0:457:bbd5:23fd with SMTP id
 f11-20020a67e08b000000b00457bbd523fdmr11490495vsl.9.1698762132102; Tue, 31
 Oct 2023 07:22:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231027204933.3651381-1-seanjc@google.com> <20231027204933.3651381-8-seanjc@google.com>
In-Reply-To: <20231027204933.3651381-8-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 31 Oct 2023 15:22:00 +0100
Message-ID: <CABgObfYewNZd-X4KWeRiFw5M+dj_-b4WPG+Gs-2GRpAsTHnA9w@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: Xen changes for 6.7
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 27, 2023 at 10:49=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> Read the tag, I couldn't figure out how to summarize this one without sim=
ply
> regurgitating the tag :-)
>
> The following changes since commit 5804c19b80bf625c6a9925317f845e497434d6=
d3:
>
>   Merge tag 'kvm-riscv-fixes-6.6-1' of https://github.com/kvm-riscv/linux=
 into HEAD (2023-09-23 05:35:55 -0400)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-xen-6.7
>
> for you to fetch changes up to 409f2e92a27a210fc768c5569851b4a419e6a232:
>
>   KVM: x86/xen: ignore the VCPU_SSHOTTMR_future flag (2023-10-04 15:22:58=
 -0700)

Pulled, thanks.

Paolo

>
> ----------------------------------------------------------------
> KVM x86 Xen changes for 6.7:
>
>  - Omit "struct kvm_vcpu_xen" entirely when CONFIG_KVM_XEN=3Dn.
>
>  - Use the fast path directly from the timer callback when delivering Xen=
 timer
>    events.  Avoid the problematic races with using the fast path by ensur=
ing
>    the hrtimer isn't running when (re)starting the timer or saving the ti=
mer
>    information (for userspace).
>
>  - Follow the lead of upstream Xen and ignore the VCPU_SSHOTTMR_future fl=
ag.
>
> ----------------------------------------------------------------
> David Woodhouse (1):
>       KVM: x86/xen: Use fast path for Xen timer delivery
>
> Paul Durrant (1):
>       KVM: x86/xen: ignore the VCPU_SSHOTTMR_future flag
>
> Peng Hao (1):
>       KVM: X86: Reduce size of kvm_vcpu_arch structure when CONFIG_KVM_XE=
N=3Dn
>
>  arch/x86/include/asm/kvm_host.h |  5 +++-
>  arch/x86/kvm/cpuid.c            |  2 ++
>  arch/x86/kvm/x86.c              |  2 ++
>  arch/x86/kvm/xen.c              | 55 +++++++++++++++++++++++++++++++++++=
++----
>  4 files changed, 58 insertions(+), 6 deletions(-)
>



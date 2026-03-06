Return-Path: <kvm+bounces-73176-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QLy9LEdXq2lpcQEAu9opvQ
	(envelope-from <kvm+bounces-73176-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 23:37:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 26B96228592
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 23:37:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C5447302A196
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 22:37:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C72B435C1AB;
	Fri,  6 Mar 2026 22:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YzXdMi6Q"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1511359A8D
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 22:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772836675; cv=none; b=skjtrp3uruUwHpK++EG+3TaXIICdo+Mc4xBHIYg7ILLEqsctaYljK5H+JLGpNwvBxLx4dwAWe4CbW3jevByS+wCnZn8sMJc7qEwLIivIU7y6/YU7u92GT4bHL+f0stjvwURs6pDlXSuk1ao0yhzsaEElXPFh0eP2GSLyTilDJOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772836675; c=relaxed/simple;
	bh=uSQuH5SJioM3VvPfP0ldVxRnb2zAnZ8kuQ4ya3ZuBs8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FsaJdCxZst/sAXSV7c1PhT1J04HnkSZbinXlEti8Ohir1Sj7R8FgX3qXyY9KgzAGwCcbTscAvqo3+GU+Y5h2Y2jPPOLZpphBStTV9a2HNCQy1I4Y2bFvmkgOEaDQJHR59lYOxuJPQqf8Eyk+u4loFqSO07fv3oU7ZZW3Uvs+nUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YzXdMi6Q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C7EC2BCAF
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 22:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772836674;
	bh=uSQuH5SJioM3VvPfP0ldVxRnb2zAnZ8kuQ4ya3ZuBs8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=YzXdMi6Q1WrHbsMNzd77+ROxKfuzsBJh65k00VkQaKK1NbMInsYF0TT4flPIP+rc9
	 q7d9NJN6KU+4Jw1h/iAqsNLsGhAZFJf2Ba1gunYIGeqMtgxF/h6Mj5/ly4W5xxAVR6
	 KVJhHSPnwV4Vxetd2cSfiUdd9yOWubXprf7UKwOTUhqOfAssMlUKNZe/WlJTIRP6ex
	 H0jh3eeYji+szl/xTdiBZqXDEOnREPnb1OHcVF5MV7UM6zt+GrnWQ83mFQ8tYjzpo/
	 rmEjDjHAHp6k6ZP7Vsmz6BWqFXBsi/HkCMRJGueKqXENgi0J3WVeLhBZZCUCBbcXJP
	 F1Di66qTGYT0g==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b942424d231so201467066b.0
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 14:37:54 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWHw8/04zlb5h6kq9emmEHm8YEpLSPz7MGNfvUnjZ10L+aK7jQ0EcTmiaiC/ltae2OimeY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+TOogil5D/izghyNHGm0MV2fIJ7/w/BhmUtzT3Iq9yOgJEoY0
	P2hceU5Ni6xv4is/gmNYIy+03stN4CW/V03pbn1wjNdac3hbanVo6Mx7wzULEKROTHidu7pEeXb
	ICviVi3KHfOE0vkheQMHyC04jP/f2DSc=
X-Received: by 2002:a17:907:72d2:b0:b94:da7:f3eb with SMTP id
 a640c23a62f3a-b942ddf51abmr248495466b.26.1772836673343; Fri, 06 Mar 2026
 14:37:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306210900.1933788-1-yosry@kernel.org> <20260306210900.1933788-2-yosry@kernel.org>
 <CALMp9eRWwPwUSyQmizy8i2tF1CVO4iLY6x0vX1OoPUiRdCm4NQ@mail.gmail.com>
In-Reply-To: <CALMp9eRWwPwUSyQmizy8i2tF1CVO4iLY6x0vX1OoPUiRdCm4NQ@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 6 Mar 2026 14:37:42 -0800
X-Gmail-Original-Message-ID: <CAO9r8zOhaDeYWq_6TNdPGyEE323o_8xsWTozGdro9Oni8310kA@mail.gmail.com>
X-Gm-Features: AaiRm53KGGHGD3csW1QExTMpQC22Z0YpTT1bW2OiAkKJ7P0jD_PatUxAEzbsN9s
Message-ID: <CAO9r8zOhaDeYWq_6TNdPGyEE323o_8xsWTozGdro9Oni8310kA@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] KVM: SVM: Use maxphyaddr in emulator RAX check for VMRUN/VMLOAD/VMSAVE
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 26B96228592
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73176-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.956];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Action: no action

On Fri, Mar 6, 2026 at 2:27=E2=80=AFPM Jim Mattson <jmattson@google.com> wr=
ote:
>
> On Fri, Mar 6, 2026 at 1:09=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
> >
> > Architecturally, VMRUN/VMLOAD/VMSAVE should generate a #GP if the
> > physical address in RAX is not supported. check_svme_pa() hardcodes thi=
s
> > to checking that bits 63-48 are not set. This is incorrect on HW
> > supporting 52 bits of physical address space, so use maxphyaddr instead=
.
> >
> > Note that the host's maxphyaddr is used, not the guest, because the
> > emulator path for VMLOAD/VMSAVE is generally used when virtual
> > VMLOAD/VMSAVE is enabled AND a #NPF is generated. If a #NPF is not
> > generated, the CPU will inject a #GP based on the host's maxphyaddr.  S=
o
> > this keeps the behavior consistent.
> >
> > If KVM wants to consistently inject a #GP based on the guest's
> > maxphyaddr, it would need to disabled virtual VMLOAD/VMSAVE and
> > intercept all VMLOAD/VMSAVE instructions to do the check.
> >
> > Also, emulating a smaller maxphyaddr for the guest than the host
> > generally doesn't work well, so it's not worth handling this.
>
> If we're going to throw in the towel on allow_smaller_maxphyaddr, the
> code should be removed.
>
> In any case, the check should logically be against the guest's
> maxphyaddr, because the VMLOAD/VMSAVE instruction executes in guest
> context.

Right, but I am trying to have the #GP check for VMLOAD/VMSAVE behave
consistently with vls=3D1, whether it's done by the hardware or the
emulator.

>
> Note that virtual VMLOAD/VMSAVE cannot be used if the guest's
> maxphyaddr doesn't match the host's maxphyaddr.

Not sure what you mean? Do you mean it wouldn't be correct to use it?
AFAICT that doesn't prevent it from being enabled.


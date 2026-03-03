Return-Path: <kvm+bounces-72447-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SLk1CjslpmlrLAAAu9opvQ
	(envelope-from <kvm+bounces-72447-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:03:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BC7A21E6F3A
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:03:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 759FF30743C0
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 00:02:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A243C2FF;
	Tue,  3 Mar 2026 00:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QIKlPJ/P"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC2279DA
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 00:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772496170; cv=none; b=FWVMCH65SXUzclH1I7sZ/555G4W9LEnZNWOhscjPHTu46Ktu4J/Fcp5UcQYlE8XVuUVnx8wsrVsBeDRAkXs97mgxEx1XflINA5Iyehq/kKEIdtk01F37vWdF6X1L9XE/6vNO0V364VNafrj3aV8Wo4yk38+G9jRxP/4yoJKhMas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772496170; c=relaxed/simple;
	bh=WX4Kfbk1UC+WfBaWknXMNYC4lGlwBh5i6bNd91PkLTs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EyFX50pZuD046Lhq9mNkOeTm6kYFWKenuPrfkAUG1YCzCgcfVFkzSE1+hxYmlG8bSDfE17q7tVikBPpnQPd5QbVg1Hs0eoYJFCxPuUUJXixNbIpAoGlkge4PZyYSDri95dTXa8vsPUIPFhBFO5YY5V6L5Bn7pnOpqiPnO9ArpLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QIKlPJ/P; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DFADC2BC9E
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 00:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772496170;
	bh=WX4Kfbk1UC+WfBaWknXMNYC4lGlwBh5i6bNd91PkLTs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QIKlPJ/PRzozWxgcbsgq52twJPRbUb9Z+8e5lRmcOmw6Oo0iYcJma6FCW9+0gjLEU
	 mlc6ueyL85VS9ksUsfu03Ftexoy4gdnK6K64iF3q33AIM8Fqhk8Wssn1SozdWgTBQt
	 P4gFwwgaj1osQgOSQshzt/5UZVifO2Tg/0me2R2BmaU7bwwZQyakk638sbQ3CBKoH3
	 rDsMuHJ6VAg9oJRZDGOtJ7tzGYyjRtD0+uzdXhLjj48AlaJSCbNJiWNDMzRianpsZB
	 y1fkOHf0xga0901j9se35dB3KwTfBas9fauRtN8WB9glU0p6mT7ufp/ctEZPgNizIy
	 pyIa19IWh+y+g==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b9382e59c0eso558873366b.0
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 16:02:50 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVs0CYxDGLAMDHf0lZ1DAyaZw29yzs1tsOek2c8xXZ+qeajrCBKDuqniTqogFIoGBwd4U0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4I/34iSGbtcMEA8SiLdPLBQEh47QAHveBPWWiVnVhhAsp4SDs
	wHPofQbE7UNAixuf6j9Vh89tFwZ8J8fGxVNQRr79wmjlKES3JpWdLTFEMwLvtABfivd7kuTh1ij
	ZwZrVufEbOLQU424CpimDVopLf3AZo6Y=
X-Received: by 2002:a17:906:248a:b0:b8f:87a9:27b5 with SMTP id
 a640c23a62f3a-b9376554a31mr712078566b.41.1772496169335; Mon, 02 Mar 2026
 16:02:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260224223405.3270433-1-yosry@kernel.org> <20260224223405.3270433-4-yosry@kernel.org>
In-Reply-To: <20260224223405.3270433-4-yosry@kernel.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 2 Mar 2026 16:02:37 -0800
X-Gmail-Original-Message-ID: <CAO9r8zPnt0-Orsw7ydk20eFDTSmWpWJeb0f=Wp0Mzi4-LgwzTw@mail.gmail.com>
X-Gm-Features: AaiRm53foBwo6LrAAHTZbpLp9-PEwXWUoG7egRPETAidxARRhocwKJqS0KCXqHw
Message-ID: <CAO9r8zPnt0-Orsw7ydk20eFDTSmWpWJeb0f=Wp0Mzi4-LgwzTw@mail.gmail.com>
Subject: Re: [PATCH v6 03/31] KVM: SVM: Add missing save/restore handling of
 LBR MSRs
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BC7A21E6F3A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72447-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Action: no action

On Tue, Feb 24, 2026 at 2:34=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> MSR_IA32_DEBUGCTLMSR and LBR MSRs are currently not enumerated by
> KVM_GET_MSR_INDEX_LIST, and LBR MSRs cannot be set with KVM_SET_MSRS. So
> save/restore is completely broken.
>
> Fix it by adding the MSRs to msrs_to_save_base, and allowing writes to
> LBR MSRs from userspace only (as they are read-only MSRs). Additionally,
> to correctly restore L1's LBRs while L2 is running, make sure the LBRs
> are copied from the captured VMCB01 save area in svm_copy_vmrun_state().
>
> Fixes: 24e09cbf480a ("KVM: SVM: enable LBR virtualization")
> Cc: stable@vger.kernel.org
> Reported-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Yosry Ahmed <yosry@kernel.org>
> ---
>  arch/x86/kvm/svm/nested.c |  3 +++
>  arch/x86/kvm/svm/svm.c    | 24 ++++++++++++++++++++++++
>  arch/x86/kvm/x86.c        |  3 +++
>  3 files changed, 30 insertions(+)
>
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index f7d5db0af69ac..52d8536845927 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1100,6 +1100,9 @@ void svm_copy_vmrun_state(struct vmcb_save_area *to=
_save,
>                 to_save->isst_addr =3D from_save->isst_addr;
>                 to_save->ssp =3D from_save->ssp;
>         }
> +
> +       if (lbrv)
> +               svm_copy_lbrs(to_save, from_save);

We need to clear reserved bits here, similar to
nested_vmcb02_prepare_save(), as this is stuff by userspace.

>  }


Return-Path: <kvm+bounces-72779-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CMsqB3b+qGm/0AAAu9opvQ
	(envelope-from <kvm+bounces-72779-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 04:54:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 2215820AAD5
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 04:54:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DB8263033674
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 03:54:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D669A286419;
	Thu,  5 Mar 2026 03:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RxT1wcA+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62E015E5DC
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 03:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772682858; cv=pass; b=R5fZ1wmgBGuGpS0c+UdnrTZMWElfVi+kHEulMAY5bbZdKesMAjVsoP80MYKQR0ulh0fVSiAyrF4LSBsWGjIEfYDTJIOk51wPK6sUU0dJUu4hGXL1aJ3oxL34se7gFAQoxrCUIwN4g5VLcBFJ0h6medeoxdqfcRzj8ikaauRpnUU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772682858; c=relaxed/simple;
	bh=WvlM7a43QODGHKc1Fto84R0iH0GOyoKeEtJn+SP67rY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MV4X1pkMop+NJG7z/NIDT7fsG5AvI+rgc8qvwGqj2ZIbEoALBiclwqyqectojEQfHUskVVOh/9bS0UbqxE/qRNvNfzvUxqwxsKpA0+y1qbx0TEwJN1M35kJ81U0bpiI6XdMIPvsEf4Md12f/Q1ZVC59xWQGaVHkdS3QymwvBu2w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RxT1wcA+; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-503347dea84so82011781cf.3
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 19:54:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772682856; cv=none;
        d=google.com; s=arc-20240605;
        b=OPPQV4tKT88jo5MiFgV1sTYBckIZxWOdqA+R/PugzX3j4oij4LgKtW3gngXfB87nTs
         xWCTPiXGNtsGfQK158zilUDhfbWJnnGqWxvy8iagJui+0CHNURSVagzZkBfKsDgkkoLJ
         NkiY72CisYY+/dVzXGSue6uzXKLfcEZodB3ztaQgX9Lrhmay/2P/KW4e5SvmhqnWAICH
         d9U2C2+HutBz85WdcKYDung4SUNdcTkZp0+ZniiLWeopTanPPHvPWDRIcgt0vbVOlDkh
         AKFlUb7sCr92c1vOXuXb8LNv1OYQ4gda5g+68SeM5t5r6HIjlFvF4Syb2nuSCivWlGRT
         +2cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PRMIiRgSC49b/kmQPx8OV5oToWVQOLhQWlku7hSYi8Y=;
        fh=JQNPsXOQw6WcDaZ0EVaJrUzXfxQ6yrtG1VplQTHbtdo=;
        b=dKAkgOi0wdtmONztsLmas8RRsOloafm7HjAJAoBSkCLUvB9tLerhcGBdi1HTficePc
         sQFGKooKhfOhkDmSNB43yTPZb7GAXHHt0OHYSCL06pkOPGA7kHr9akjHPgf9bwsjVqLT
         Un0moy5GRehrdwTUXdRHOAZ+9P946ulUpp5voVthFvrwzhx/b3GG/R5U+KUK6Hjnv6D9
         7qk2NYc/50GvP6How1oSBYPVtQET+pCs0cjLsDuR5a/fTTj7FjKpYVz6eWnf04pka1aL
         rwPh2O0Y2I6nhz3rYZaIqilj5AIXLo0PF7SivpFQmeGqRt7HBppUpE725JaTDr335aXh
         LBKg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772682856; x=1773287656; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PRMIiRgSC49b/kmQPx8OV5oToWVQOLhQWlku7hSYi8Y=;
        b=RxT1wcA+pMv5xXmg9eX4XIxRnLGjEmAY5d7aGsN99Yw3dWsHUcuR4oklKj47WUDRU7
         Q+Wl8HwONS0Zds9u6m+TfjndDjoNPnMp5iI2MIc7PwD7PGCJMt1wvl1oSFtMCla32pso
         rK0BAzuoJa8hUu7lguHl913l62F+d4C4Vp0PjI790gR6P96PkFf20RioYWk0B9HU4+OT
         ugNHOl2fJ64cJV5kicqOELE2n/fdSTTVsNKGaiL15udJL7DA6oxgFrFO2TcLj2d7pwsx
         PR6YWoUK9XoSXRUy+/+X4Zt9aMmruOrQ/4gNeA1mzktr2VxNWf+qcabkIcM2OnOqeuoT
         Ohqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772682856; x=1773287656;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PRMIiRgSC49b/kmQPx8OV5oToWVQOLhQWlku7hSYi8Y=;
        b=OAzRD7zXMrFYdxY5GaQuHPRJMVVc4bzBeDHZI4Z+cC5HWEKQyRFC3NbpjVM2+l5J+6
         wqsATf/Pbx1dWE0jxIqzgpcjRtCIcpuG8N1v7HzJFldTpCprGx+92haTU/phS2W5TQmv
         utb8C3mYnzTkgYNhOZ1ZrIKi8uoH2ufy7WDpEsU4Z670Ej0GYXX5PIuq/383N80UjpGf
         bteqqZlX20v0NlJ3WdzpuGdp8kJLNXRmFyFsepInsttmFQLb64shtm9GreSPr9KAcLNE
         +FQPsRTOjehIyEv13gPJLXQnDL4rKXc1U9v7rXcxmijUPsHQErElhf5nMhLM0yKUxEwY
         QpKA==
X-Forwarded-Encrypted: i=1; AJvYcCUar93vLhQXMznwE169wqr8v2hnqyvdpIdMd2AA+VJQK9FF8q2At7Fr/Zn/d/XUSOGLKoo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4eR8kJQSxXr+gBsqWgo8/Btx6U/8W26SjKADwuG7dHMXTB0kr
	kVMmAAxnQ9+cMukut5Y8xXcBW+VxY493DH5krSneMJMA66zI+fEAZmIMRG28CyFEox0zOfXiB6y
	WYeyzuO+/i53/SBQzndo/mhS6ncvuLt3PDjCZ5CFc
X-Gm-Gg: ATEYQzy9sw7kz5JPin+2nHgTWY65f3oJwtbjEpOuLLehjgnwvMesxSd848ct27aacGi
	IDnqjJbdgk619tQ6JM/TsCYqu8A+cK1EP2on0demtVgcLGi6a8WLQ4GYnKKnAm5+OXjtvUToigE
	o8BFag1AzhQLrCtvtozJdgeMzx08jHjsByFZpd1gUlegNmIWCdMV3+BS+KKiH/rx05QM4u2Zg7F
	O+t9wm6UahPZ2TOyh46CIgsj8B353WlflzOWJ2HKzGK4An/RMvl1twBpJRPa1CqImuCg1QG87dU
	DkkwoCmrZ8+AWd4ryTuZVu6xlR83D1RwaUkw23u72w==
X-Received: by 2002:ac8:5f0c:0:b0:502:6ed5:7b0d with SMTP id
 d75a77b69052e-508db35ac64mr59680931cf.48.1772682855420; Wed, 04 Mar 2026
 19:54:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260224071822.369326-1-chengkev@google.com> <20260224071822.369326-5-chengkev@google.com>
 <aZ3h508kM-rDYKIs@google.com>
In-Reply-To: <aZ3h508kM-rDYKIs@google.com>
From: Kevin Cheng <chengkev@google.com>
Date: Wed, 4 Mar 2026 22:54:04 -0500
X-Gm-Features: AaiRm53QX_SaKyfjppt--XT04LuzNnNYOco-9qMWY1HzfS3jPg6X-fRc6ag1uX0
Message-ID: <CAE6NW_anhi1EwtZHeuWdFJ6vd5i2N14YmdFNf8CQsVVNP-4CAA@mail.gmail.com>
Subject: Re: [PATCH V2 4/4] KVM: selftests: Add nested page fault injection test
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2215820AAD5
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72779-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chengkev@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Feb 24, 2026 at 12:37=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Tue, Feb 24, 2026, Kevin Cheng wrote:
> > Add a test that exercises nested page fault injection during L2
> > execution. L2 executes I/O string instructions (OUTSB/INSB) that access
> > memory restricted in L1's nested page tables (NPT/EPT), triggering a
> > nested page fault that L0 must inject to L1.
> >
> > The test supports both AMD SVM (NPF) and Intel VMX (EPT violation) and
> > verifies that:
> >   - The exit reason is an NPF/EPT violation
> >   - The access type and permission bits are correct
> >   - The faulting GPA is correct
> >
> > Three test cases are implemented:
> >   - Unmap the final data page (final translation fault, OUTSB read)
> >   - Unmap a PT page (page walk fault, OUTSB read)
> >   - Write-protect the final data page (protection violation, INSB write=
)
> >   - Write-protect a PT page (protection violation on A/D update, OUTSB
> >     read)
>
> Either in this test or in KUT, we need coverage for validating faults tha=
t are
> reported by hardware, i.e. for faults that _don't_ go through the emulato=
r.
>
> E.g. there's this "todo" of sorts in KUT:
>
>         case VMX_EPT_VIOLATION:
>                 /*
>                  * Exit-qualifications are masked not to account for adva=
nced
>                  * VM-exit information. Once KVM supports this feature, t=
his
>                  * masking should be removed.
>                  */
>                 exit_qual &=3D ~EPT_VLT_GUEST_MASK;
>
>
> Or maybe both?  I generally prefer selftests for maintenance purposes, an=
d you've
> already written this test...

Does https://lore.kernel.org/all/20260113003153.3344500-9-chengkev@google.c=
om/
count :) These exercise nested_svm_inject_npf_exit()

Actually running these tests, I realized that the expected_fault is
incorrect in those KVM unit tests. Because PFERR_GUEST_PAGE_MASK was
previously hardcorded, the KUTs had that set in the expected_fault.
However, with the NPF injection fixes, I will need to change the KUTs
to expect PFERR_GUEST_FINAL_MASK to be set for the different test
cases which is actually the correct expectation.


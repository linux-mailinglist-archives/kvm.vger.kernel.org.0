Return-Path: <kvm+bounces-71003-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GKZmDZwWjmmZ/AAAu9opvQ
	(envelope-from <kvm+bounces-71003-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 19:06:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D2A6E130272
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 19:06:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0A7DB30A0C09
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 18:06:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8660C26CE23;
	Thu, 12 Feb 2026 18:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OqUhuym5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE1820299B
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 18:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770919565; cv=none; b=sCOOmEzZDrGtN+IuAiUzWQmJ7z5Vsu/OiwkY8rlWdnO+xmoyBttFbvVZSmq33rd++dzwWdfAOXOMUKVy9Vz4+rtCDVdl//2SSNFfW5gN5vBq8KTYmGqi154PH29wdIvgQRAfj2ip8wc7r01I4E7uEdfXvWo8V1RYpjaJW4/LqB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770919565; c=relaxed/simple;
	bh=/PhTShLKJnFrNnpl1K3iXkufMll13s2vVyT8kh98aS8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RPVyO28Z1PzErAWEcA/ODfIJD+/xd/gBpCkGhPRBG/jmtNdGCsPn66BwN96MU/cYfScStGur43RVNpyFXtVP74OLOkAqfSmdymz8k1z+NyC6VK/C/VkXMDMT5oqs+rkFeazshsBnIGx1oL6/ipeAhjnQB88l6qXpUHiuV8Vxh4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OqUhuym5; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a7701b6353so1291195ad.3
        for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 10:06:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770919564; x=1771524364; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZMIgyP3ebwffaPtNSS2oFUqMF8kt/CpMxALQFuPMxGE=;
        b=OqUhuym5zhRiheoRS7rSSfbBXgJhgVLaETTbvIax4116n7glB3939k65vZZJtlAx0o
         1792DO2BKTmbP9g6itWPGEAJSUBrGutIQV2BLGYBL6oiaWduLPHvQvkMF7Juc/1m2cwH
         C4uSIczx1uWZwx0Bu1A4eYsBvIJWXKjc4TVkRxiZEavqnPuCA6/+FyPL0QUMXsQnFAnz
         DaNSm5BDhTV7HDQvypXfurOMi4HDgp87eAxh1t0SBs67+jfG8KyTVhddXA4BVzABUB+t
         65oNQQuddZ4dLivQkpSYKy4x5mHPGqjtuLsKZICfeOChJWc5GxIqq5k9SdaenOraUOdn
         q+dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770919564; x=1771524364;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZMIgyP3ebwffaPtNSS2oFUqMF8kt/CpMxALQFuPMxGE=;
        b=Ttv5TDGWQLABTZY2a69F0+R243yShD3AT2LYFyHtrOdu+PW4kuNtTvZXXKR0DZvBwk
         p81qSWC9hIYi2RDRK912PvV0o/NocFp0R7JWn+vFBW8UlGKmk8ReQ9C/02K0AGDY6MCU
         NEVTxnTw8e7qlzrF1lqQCgn431sQJBOHrt9EvxZDetWPHEx/j5Yc0oN0xB5XtJSRQN6o
         HpGjyUkWh7Tf7E8hWYGDuWaE3boND2mN8JNDPt3QMahEAbsPA/iyLYUmckzE/jW+IFTe
         HN8IKcEMhQBEOm2JrjYMszNHL2qdtR4t+utLO8zbhtPkDTEsS3XuXsK2He13hZXll+Wz
         ZVmQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDMkzzUSYlTuRJR/7qZbC170NpvmojuoNsT52UwXuHbrezkeOKwczNNfuOWuEUZJOMymQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywg7VaASc/ThAzPFRYkvYkhWDey5f8kQOXJTuD7NMcaYsdPPJhz
	NMiVtoniz0kJRqy9ubNrcvtkxYhcTrthzmcR+ZXKKkcIjY3az5m1hefseE4EIhUxMaFjU70W4vM
	SXkpL0Q==
X-Received: from plblq5.prod.google.com ([2002:a17:903:1445:b0:2aa:d708:7f2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:67c8:b0:38f:86c0:449
 with SMTP id adf61e73a8af0-3944880f8dfmr3589217637.49.1770919563816; Thu, 12
 Feb 2026 10:06:03 -0800 (PST)
Date: Thu, 12 Feb 2026 10:06:02 -0800
In-Reply-To: <CAFULd4Yyc=smi+bsY3FPLVd_jZxuHFUYOkH4enPQ=Z=OLe-GOw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260212102854.15790-1-ubizjak@gmail.com> <0a1ad845-a15b-4901-a65c-2668580751ed@redhat.com>
 <CAFULd4Yyc=smi+bsY3FPLVd_jZxuHFUYOkH4enPQ=Z=OLe-GOw@mail.gmail.com>
Message-ID: <aY4WioQAkcmSpbq9@google.com>
Subject: Re: [PATCH] KVM: x86: Fix incorrect memory constraint for FXSAVE in emulator
From: Sean Christopherson <seanjc@google.com>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71003-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D2A6E130272
X-Rspamd-Action: no action

On Thu, Feb 12, 2026, Uros Bizjak wrote:
> On Thu, Feb 12, 2026 at 2:05=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.co=
m> wrote:
> >
> > On 2/12/26 11:27, Uros Bizjak wrote:
> > > The inline asm used to invoke FXSAVE in em_fxsave() and fxregs_fixup(=
)
> > > incorrectly specifies the memory operand as read-write ("+m"). FXSAVE
> > > does not read from the destination operand; it only writes the curren=
t
> > > FPU state to memory.
> > >
> > > Using a read-write constraint is incorrect and misleading, as it tell=
s
> > > the compiler that the previous contents of the buffer are consumed by
> > > the instruction. In both cases, the buffer passed to FXSAVE is
> > > uninitialized, and marking it as read-write can therefore create a
> > > false dependency on uninitialized memory.
> > >
> > > Fix the constraint to write-only ("=3Dm") to accurately describe the
> > > instruction=E2=80=99s behavior and avoid implying that the buffer is =
read.
> >
> > IIRC FXSAVE/FXRSTOR may (at least on some microarchitectures?) leave
> > reserved fields untouched.
> >
> > Intel suggests writing zeros first, and then the "+m" constraint would
> > be the right one because "=3Dm" would cause the memset to be dead.
>=20
> Please note that the struct is not initialized before fxsave, so if
> "+m" is required, the struct should be initialized.

Regardless of CPU behavior with respect to reserved fields, I believe "+m" =
is
correct and "=3Dm" is wrong, strictly speaking.  The SDM very explicitly sa=
ys:

  Bytes 464:511 are available to software use. The processor does not write=
 to
  bytes 464:511 of an FXSAVE area.

I.e. the entirety of the struct isn't written by FXSAVE, and so using "=3Dm=
" is
technically wrong because those bytes are "read".  In practice, it shouldn'=
t
matter because fxstate_size() (correctly) truncates the size to a max of 46=
4
bytes, so that KVM-as-the-virutal-CPU honors the architecture and doesn't w=
rite
to the software-available fields.  I.e. those bytes should never truly be r=
ead
by software.

Given that emulating FXSAVE/FXRSTOR can't possibly be hot paths, explicitly
initializing the on-stack structs seems prudent, e.g.

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index c8e292e9a24d..20ed588015f1 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3708,7 +3708,7 @@ static inline size_t fxstate_size(struct x86_emulate_=
ctxt *ctxt)
  */
 static int em_fxsave(struct x86_emulate_ctxt *ctxt)
 {
-       struct fxregs_state fx_state;
+       struct fxregs_state fx_state =3D {};
        int rc;
=20
        rc =3D check_fxsr(ctxt);
@@ -3738,7 +3738,7 @@ static int em_fxsave(struct x86_emulate_ctxt *ctxt)
 static noinline int fxregs_fixup(struct fxregs_state *fx_state,
                                 const size_t used_size)
 {
-       struct fxregs_state fx_tmp;
+       struct fxregs_state fx_tmp =3D {};
        int rc;
=20
        rc =3D asm_safe("fxsave %[fx]", , [fx] "+m"(fx_tmp));


Return-Path: <kvm+bounces-72572-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yDHfCDY0p2k9fwAAu9opvQ
	(envelope-from <kvm+bounces-72572-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:19:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A5241F5DBD
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:19:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 60E6B313688F
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 19:15:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0117A3537ED;
	Tue,  3 Mar 2026 19:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZUxTEg82"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3563237C91C
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 19:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772565323; cv=none; b=tM9ie8XBKkMVUJKCc9A3i/r1GIezrtnNDsbbZB7nH4xt6z25Q3GHUlvici/zXUnXW77Bo0VYAAceLEnfBB77gsDfnETYuGlLWw3mYTcavBpZFZCX3MU2sYXmwZma9/NcCrdqZBzsew3LoIbnmtcmIhKTGq5SwEGotVOOe2Lbqxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772565323; c=relaxed/simple;
	bh=/rl3qigKuas4Cyi7xfTy/F7A0pzFwg0QJf91k9QOXM4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ov4eb5otKHmYhwLmw/70RWG6QS7LTiN/vjyxwcqX0GqAC5E6pky1P6q/we0pq0irqemrEiqHA4IxZ5cPLvISP3spjtKUI0lhfWejLMJr5eOZNHCJGdB00qNoDP49pjR9TxCs3fucFEmyRnlOZijq3ivWOZpYI3oKF0Ua/zBKfq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZUxTEg82; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16F1C2BC87
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 19:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772565322;
	bh=/rl3qigKuas4Cyi7xfTy/F7A0pzFwg0QJf91k9QOXM4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ZUxTEg82+ZAGSMLMW0fLPlAcwS6FPeEBt8FGB8gyH1B8imPGrqaaMHkrYSemEHGLk
	 i/4m8paNxZMQr5GsDKf/nrt2w0hq1EIcPoDV72vIEhPgCoaxids6bZhOyGy/rhLSvQ
	 afdPTzyKrMfVHG2RUOsuhTDW8uV8k1ne0nt15HZEhHamIYOfLBz9n5h7HgS6f1AUO2
	 t67kvGWX/WJUY2HAUcqtu5InASotQ5r5W68h4lxHbVVNGky1o9SyaMjOncKObFpy6O
	 STqcZIjvsCWceqGA+Gphm+mN/wgjTlpNRbn95B32FJWHRI4l07RK94RL/O++zP3ucf
	 cszX98qQft8gg==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b93698bb57aso353504766b.0
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 11:15:22 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW95dnsvdXE4K5yMcyDbOLRZcX8Uc4+f/4VgnW7nN57HH50gJpThLsFlhF5eVKL2VlS08g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxT9bfN18Md4/uP5omQ95rPgGMG0O5vcdHcs3SA/mkgflMj1/j8
	1is7TytMj+0sDnDAX0/GpkEKpBjOO9HyQ3U9isXx8CmCo2meXl0Lp8As5jaPRnZj2yHiGT7drgP
	Gx2u8e9lFSzGPj6qPJ/ypA8Baepv+AjU=
X-Received: by 2002:a17:906:7951:b0:b89:ec1f:40f6 with SMTP id
 a640c23a62f3a-b93d440f7d1mr212163866b.17.1772565321688; Tue, 03 Mar 2026
 11:15:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260303003421.2185681-1-yosry@kernel.org> <20260303003421.2185681-10-yosry@kernel.org>
 <aacRCz2bmxbma6g4@google.com>
In-Reply-To: <aacRCz2bmxbma6g4@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 3 Mar 2026 11:15:08 -0800
X-Gmail-Original-Message-ID: <CAO9r8zO7eiugNmxtTzWe_1_Qk+YOmp_i8LRzrL8--vXuT4m-1A@mail.gmail.com>
X-Gm-Features: AaiRm50BCHcoGgG7S6yvxaxQ9mW1R6zZPLSe1kXGrtU1BXwZmw6MEPbTGujk5FU
Message-ID: <CAO9r8zO7eiugNmxtTzWe_1_Qk+YOmp_i8LRzrL8--vXuT4m-1A@mail.gmail.com>
Subject: Re: [PATCH v7 09/26] KVM: nSVM: Triple fault if restore host CR3
 fails on nested #VMEXIT
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8A5241F5DBD
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72572-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Action: no action

On Tue, Mar 3, 2026 at 8:49=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Tue, Mar 03, 2026, Yosry Ahmed wrote:
> > If loading L1's CR3 fails on a nested #VMEXIT, nested_svm_vmexit()
> > returns an error code that is ignored by most callers, and continues to
> > run L1 with corrupted state. A sane recovery is not possible in this
> > case, and HW behavior is to cause a shutdown. Inject a triple fault
> > ,nstead, and do not return early from nested_svm_vmexit(). Continue
>
> s/,/i

Not sure how that happened lol.

>
> > cleaning up the vCPU state (e.g. clear pending exceptions), to handle
> > the failure as gracefully as possible.
> >
> > >From the APM:
> >       Upon #VMEXIT, the processor performs the following actions in
> >       order to return to the host execution context:
> >
> >       ...
> >       if (illegal host state loaded, or exception while loading
> >           host state)
> >               shutdown
> >       else
> >               execute first host instruction following the VMRUN
>
> Uber nit, use spaces instead of tabs in changelogs, as indenting eight ch=
ars is
> almost always overkill and changelogs are more likely to be viewed in a r=
eader
> that has tab-stops set to something other than eight.  E.g. using two spa=
ces as
> the margin and then manual indentation of four:

Yeah I started doing that recently but I didn't go back to change old ones.

[..]
> >
> > Fixes: d82aaef9c88a ("KVM: nSVM: use nested_svm_load_cr3() on guest->ho=
st switch")
> > CC: stable@vger.kernel.org
>
> Heh, and super duper uber nit, "Cc:" is much more common than "CC:" (I'm =
actually
> somewhat surprised checkpatch didn't complain since it's so particular ab=
out case
> for other trailers).
>
> $ git log -10000 | grep "CC:" | wc -l
> 38
> $ git log -10000 | grep "Cc:" | wc -l
> 11238

That was a mistake, I think I generally use Cc.


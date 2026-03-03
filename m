Return-Path: <kvm+bounces-72450-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +EkgIOgmpmnwLAAAu9opvQ
	(envelope-from <kvm+bounces-72450-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:10:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F2B731E6FD8
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:10:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 68B0630312F3
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 00:10:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB3CF1684B4;
	Tue,  3 Mar 2026 00:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V6nGsYu7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D901F14EC73
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 00:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772496599; cv=none; b=TyqEoUPylKNALWZalEA9ak1mehlMxfRxlo7jVTvVA9rM2ev3BxGCJyxrgJDyeyTNH5bjpwaYWZHPLTjcPJEc1mDVwVlZ8my/Ia83rjzhIt4QvfhkcryH3AB5JJHgUWeveHtwu6PzgHTf8nhMxFrsrZPC/iW7UNOgdhO/2WDkn2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772496599; c=relaxed/simple;
	bh=tDCx+wrVcW7oxDITeHDBDVpGFNi3v8MH29hT9SE3gu0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OwgFHnAdQqsHn0FHCPT6APdr3s0dWfkj/2shO0lvwx3zvFl8LZaucJjj3dv7+5wp10TpaCwc0udfZa6H1AMmDhScDgHR/F2E5w5enZHyCOK1Yb50QsGNofpEJBNu9RQxyVKiYpoQnYIwzXS00Rq2HOIn95MvVU7ZqYuPV4S7qgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V6nGsYu7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD22C2BCAF
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 00:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772496599;
	bh=tDCx+wrVcW7oxDITeHDBDVpGFNi3v8MH29hT9SE3gu0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=V6nGsYu7YI33DpbzmtE+LPx1azL7p/MN6tjWZfonJEAhHlSXPqeRtmDrT00LaYHsy
	 ZyBH6252GmFyTfhsZm++v+Z1z0hn+UZNRR17Lqx37yJV9LjfzL3hyrp1ZpE8rXgOpr
	 jdDAv2t6J2ViM6rqZj6TcmbawwwI5ggWxrrX74Mn8s0iNy/im2Lh7NZcImdxG53y43
	 sYVtofs8Y09wzhUCKok86MEwCNZfAp23n0iDoKeqwNt+WC1Fj1w3Q0RBCp5Q1Jjtqx
	 +4vQUqow9Ejh3yQjUBkK/VcbRumuiYNpXUNn1i8wfL7beAQKBiD1dHchSAE7VSXzIR
	 2ofaZ8tg4bXbw==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b936331787bso811472966b.3
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 16:09:59 -0800 (PST)
X-Gm-Message-State: AOJu0YwMrM6UNtzWuv8gI4R/qbDjlsaR2dvZBHXPO42MqU6gqZcNtxHw
	8+gieDDwZV2bWjHU+ryjRgKbP9r0O7v5Q5KGKfmJqvfSPjjElf7oWDGaq8v52BTGkqL5Nsq5smX
	mel3ftRlyYkw5DKBcV+OmXkK7PiPLfbM=
X-Received: by 2002:a17:907:9349:b0:b88:5957:2d65 with SMTP id
 a640c23a62f3a-b93764d4404mr812643166b.37.1772496598373; Mon, 02 Mar 2026
 16:09:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260227213849.3653331-1-jmattson@google.com> <CAO9r8zNzhK90=+Pezqbea0aihMEp-dGidcJuXqZQKnmsM2JTDA@mail.gmail.com>
 <CALMp9eRP7-u+6r8-RoVru6PLSPr6fu+EuRgtsNLJE_1EpMJq8Q@mail.gmail.com>
In-Reply-To: <CALMp9eRP7-u+6r8-RoVru6PLSPr6fu+EuRgtsNLJE_1EpMJq8Q@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 2 Mar 2026 16:09:47 -0800
X-Gmail-Original-Message-ID: <CAO9r8zNe9_vhspg4T=zswZ3Hr31XJGPz8=aDbqVvL1Wa9_mrAQ@mail.gmail.com>
X-Gm-Features: AaiRm53Gu2sZPwWAS41BfOVw_wz49tiZkwawaVz7QWPr4iNzWuel1QFSSrB_wgw
Message-ID: <CAO9r8zNe9_vhspg4T=zswZ3Hr31XJGPz8=aDbqVvL1Wa9_mrAQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: nVMX: Add retry loop to advanced RTM
 debugging subtest
To: Jim Mattson <jmattson@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: F2B731E6FD8
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-72450-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Action: no action

On Mon, Mar 2, 2026 at 4:08=E2=80=AFPM Jim Mattson <jmattson@google.com> wr=
ote:
>
> On Fri, Feb 27, 2026 at 4:55=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > On Fri, Feb 27, 2026 at 1:39=E2=80=AFPM Jim Mattson <jmattson@google.co=
m> wrote:
> > > +#define RTM_RETRIES 30
> > > +#define ONE_BILLION 1000000000ul
> >
> > I think the name would be more descriptive as RTM_DELAY_CYCLES or sth,
> RTM_RETRY_DELAY?

SG.

>
> > IIUC this will be in the order of 100s of milliseconds. Do we need to
> > wait that long between retries? If the CPU is in a state where it will
> > always abort RTM, 30 retries will end up taking seconds or 10s of
> > seconds, right?
>
> I tried reducing the delay by a factor of 10. At 200 retries, I still
> see a 2% skip rate on a Skylake Xeon E5 @ 2GHz. I'd like to get the
> skip rate under 1%. But, maybe others don't care as much?
>
> Yes, 30 billion cycles is going to be on the order of 10 seconds.

I personally care more about the test time than the fact that it won't
test RTM 2% of the time, but my opinion doesn't really matter :P


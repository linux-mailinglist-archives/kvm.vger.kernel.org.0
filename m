Return-Path: <kvm+bounces-69146-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oITXDVCGd2m9hgEAu9opvQ
	(envelope-from <kvm+bounces-69146-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 16:20:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id CF8158A0B7
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 16:20:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8AF923006816
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 15:20:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01F5533EB0C;
	Mon, 26 Jan 2026 15:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YtoiXDU4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADCD33CEB7
	for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 15:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769440843; cv=pass; b=A0wrS0Gu1tIeOhcjJ+SRkYIlxJAo0bH4K80XamoUTQw35KottsjnKK+0dhEGJEJFof9NayzKdpPzcL3XB5MKwVhcUTHB0AzLOC2M6uUZfpaPLrbdxGB0R6/YI8eG/UF6ItrdUf5O+MmlHe4XCOZey1ONo8XuQFSciFmYLhWZCSc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769440843; c=relaxed/simple;
	bh=TC3baaDX/6rFNUOc4W12KBURx7GTtV7qaXLEMYX1P9w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QZPU2R6yFMIUUQTEIS9ue2vRh0c0CKL/EMC6gUtG/vl0xwsnfLjjyU1+81bHZQ0ygjNeciJsYCIs86tSYB/SVwl5hRP8I252w9nY7/EOif0VubsHLhFg4P/uuh+edw0hLW22rpig7fyK9aPnadyaFnWX+mD0iIyJPkbfldEs+Xo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YtoiXDU4; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5014db8e268so75479211cf.1
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 07:20:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769440841; cv=none;
        d=google.com; s=arc-20240605;
        b=He4647CsjJdeDeJ5oUq4JfIelTfebpwEzy/KllXAqdxF40i1bcy5rhmR+RURXapTSm
         TFP4CBvD64iQig7NSPcKG7/MYC3WFKJmSmEpRcwkEsNj7EsbtyhcGh3abnu86OQsnow+
         GSn6EXRwbU98Co4VHJk3nFo5HLPQ1xrivf485LNFwG77NKO07wEIZTdwqcoTwTqMGHM+
         PbiwJrK8ouhGdJi7KvSXLxHdCJdTpqZJzszEIZXKG6VB8JcpcYkE4Cqkp8cSkhi05PPq
         XRAgt1CigcvBcetbjEwxasPaU3E2LFWQfnyMlcEoIo8U8Vp9rCav6Lj/H8zqOgEk7KY1
         nsLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n4aXoXhV1+Jkl0JeaP+K3SiKzpvUnjm/UfLBA8oksx4=;
        fh=t6nivt08u02+YDpMKFjfMOzLO5e/jSNfxjNaK5jN4Ho=;
        b=OyLDq8eOQGm7p7B/2mwoUA2eUTOlgbyzYxLl7zdeDL9pJLM/kpqPqbMUYyT0TrQREC
         S4pfUzin7zBeVTPzIAk3EItbh/tm7/fmqoJZk6WVppz/gnT3t/Tv/wWeBY06QpY6dYeI
         XDkGwmHfCAWomF2o9DOVcs5L2djq2mEy/MyMyu6PY4E5ZKka3bThX8Dhn0MJS9kQNg4k
         E62WXQs+Kt8x/ExD6PmgiqP53ZnkiI5s/J6C2A3KtrM/sP6QEEzPAutFHRfvgK/lxeVe
         qzdWdB6NLHbcG7fu5+3vM2rKqV5VAMnikEVdu1Zpz8hY7KiFSpnLd+k1uj6hoFLY9J4c
         /4Gg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769440841; x=1770045641; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n4aXoXhV1+Jkl0JeaP+K3SiKzpvUnjm/UfLBA8oksx4=;
        b=YtoiXDU4xHGcFjtlaf7SJkY7OOKjmOFQogIPvYYNpnTSYOf64fvokV+3tYIDZk0w3H
         2Vr/9RmkFrxp3r5f+kFEVmqxW3cH0Hu9ll6WYcSh0XSovs5GcbwWi2rdN5EPSpJl5lLg
         BC+zcE2HL8R4eoW3dzhx3Ocfjng+ETMcjHmA4SxDbNfsiWiWVA9PcCv+vxgrYde5ndqa
         PDIFntcCdSuiFYMqeeDeIJjQAsE3mCXx11JgrmNn01ygdL3k4s/CmlRKfuuJOyHnVQUz
         UqrFn/zBjprGHmJpMcAPNlt99e4I7EVQ1ptGZHtebaTAp4/aoVgJcncEfC0fbpmL4Yz6
         A2og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769440841; x=1770045641;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n4aXoXhV1+Jkl0JeaP+K3SiKzpvUnjm/UfLBA8oksx4=;
        b=VytdkROX9cbOlr/poxXh/IbuyvUs99fEop0KktbHj+3AI9W095boPR4BUKRzrYozbf
         MOqtz82tE2OFgaPgpHm45PLOnbs1TnsTOEVXVsqHfIpAZrj1S002LWnNu8A+yGzHgY4h
         PoPzIw585KjvT55hGa2AhlqqdbH3IJ8Z+rljsFTKXSRiyJgzrN1OA6YvS213vaih8Wh/
         DNL18UKpPI7hpVaISRez2tmz4QWacPBnSLji5+wV3s/PZqY9uqLt0H34Ujfojs0t6ElA
         EzIkpBsJAsMloRgyRvQfkOA5tzDUpNfL88+CJ77F+SvI48Ac+VsVYmRgwdwDwynOzmdg
         0VLQ==
X-Forwarded-Encrypted: i=1; AJvYcCW8PooDpX9mVIC8is96m+rC+atJknV9yp+yVkQZR3U1qCRYGne/XVrPxabnrZaUzMJRwFo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqBZ8MGwEX8L3MuGjma3EpxG++KBq9N4OvFJffwYM17z+PcYz7
	77WTsJBtlsU+DE4eKJ/Rhe3I+AvbC0FEYicqiBGzmv62FS6vPEd48yQ/04vhh1f3Dzxobk6h9O3
	a40RgTUJXkX+8sCaHpVk5n4hNoVeiOJs=
X-Gm-Gg: AZuq6aLB2H1prYg8bpjRDA+zkVriUv5vnAOcKZZ200M59/6TXm76a+VRyRGp0aWxLVB
	hCtLLdaQA+203N+d1f348sdqpsolvm+ZQY2uHQ72R1yHNNzKnAbnsia2MCXTydOoXMbzJmKHgap
	+wBh7m0GX4cVwcKeK2VpamNqdg60IqXbRdlS0A2BlVNEbV94pDoqCzH6m38+9cDYZUkD/4VFw1J
	aWMwZte0BNyvB7cl60v9eYiYl216ucj+zrSwqFWV8u5a1vVQFM8Q5E2h4YxESrvJ+V0mIy9jxJm
	MtY5VzHY3W6b5UqOCIrFiJMRpok=
X-Received: by 2002:ac8:7d96:0:b0:4ee:60a6:ee03 with SMTP id
 d75a77b69052e-50314c3b9b6mr56475751cf.41.1769440840871; Mon, 26 Jan 2026
 07:20:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260106183620.2144309-1-marcandre.lureau@redhat.com>
 <aV41CQP0JODTdRqy@redhat.com> <87qzrzku9z.fsf@pond.sub.org>
 <aWDMU7WOlGIdNush@redhat.com> <87jyxrksug.fsf@pond.sub.org>
 <aWDTXvXxPRj2fs2b@redhat.com> <87cy3jkrj8.fsf@pond.sub.org>
 <aWDatqLQYBV9fznm@redhat.com> <871pjzkm4y.fsf@pond.sub.org>
In-Reply-To: <871pjzkm4y.fsf@pond.sub.org>
From: =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@gmail.com>
Date: Mon, 26 Jan 2026 19:20:29 +0400
X-Gm-Features: AZwV_QiWDJZzB7DvgpJJkKN3Qa8Yby82KkUTkKUZVgpA8IHUW9I7VV_iHDCLVV0
Message-ID: <CAJ+F1CLR4wt-bA+V+oV6N4iKTK_=Hn8TSD0pP7Uwj=jWHWvZRA@mail.gmail.com>
Subject: Re: [PATCH] Add query-tdx-capabilities
To: Markus Armbruster <armbru@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: qemu-devel@nongnu.org, Eric Blake <eblake@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, 
	"open list:X86 KVM CPUs" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-69146-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[marcandrelureau@gmail.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: CF8158A0B7
X-Rspamd-Action: no action

Hi

On Fri, Jan 9, 2026 at 4:27=E2=80=AFPM Markus Armbruster <armbru@redhat.com=
> wrote:
>
> Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:
>
> > On Fri, Jan 09, 2026 at 11:29:47AM +0100, Markus Armbruster wrote:
> >> Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:
> >>
> >> > On Fri, Jan 09, 2026 at 11:01:27AM +0100, Markus Armbruster wrote:
> >> >> Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:
> >> >>
> >> >> > On Fri, Jan 09, 2026 at 10:30:32AM +0100, Markus Armbruster wrote=
:
> >> >> >> Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:
> >> >> >>
> >> >> >> > On Tue, Jan 06, 2026 at 10:36:20PM +0400, marcandre.lureau@red=
hat.com wrote:
> >> >> >> >> From: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com>
> >> >> >> >>
> >> >> >> >> Return an empty TdxCapability struct, for extensibility and m=
atching
> >> >> >> >> query-sev-capabilities return type.
> >> >> >> >>
> >> >> >> >> Fixes: https://issues.redhat.com/browse/RHEL-129674
> >> >> >> >> Signed-off-by: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redha=
t.com>
> >> >>
> >> >> [...]
> >> >>
> >> >> >> > This matches the conceptual design used with query-sev-capabil=
ities,
> >> >> >> > where the lack of SEV support has to be inferred from the comm=
and
> >> >> >> > returning "GenericError".
> >> >> >>
> >> >> >> Such guesswork is brittle.  An interface requiring it is flawed,=
 and
> >> >> >> should be improved.
> >> >> >>
> >> >> >> Our SEV interface doesn't actually require it: query-sev tells y=
ou
> >> >> >> whether we have SEV.  Just run that first.
> >> >> >
> >> >> > Actually these commands are intended for different use cases.
> >> >> >
> >> >> > "query-sev" only returns info if you have launched qemu with
> >> >> >
> >> >> >   $QEMU -object sev-guest,id=3Dcgs0  -machine confidential-guest-=
support=3Dcgs0
> >> >> >
> >> >> > The goal of "query-sev-capabilities" is to allow you to determine
> >> >> > if the combination of host+kvm+qemu are capable of running a gues=
t
> >> >> > with "sev-guest".
> >> >> >
> >> >> > IOW, query-sev-capabilities alone is what you want/need in order
> >> >> > to probe host features.
> >> >> >
> >> >> > query-sev is for examining running guest configuration
> >> >>
> >> >> The doc comments fail to explain this.  Needs fixing.
> >> >>
> >> >> Do management applications need to know more than "this combination=
 of
> >> >> host + KVM + QEMU can do SEV, yes / no?
> >> >>
> >> >> If yes, what do they need?  "No" split up into serval "No, because =
X"?
> >> >
> >> > When libvirt runs  query-sev-capabilities it does not care about the
> >> > reason for it being unsupported.   Any "GenericError" is considered
> >> > to mark the lack of host support, and no fine grained checks are
> >> > performed on the err msg.
> >> >
> >> > If query-sev-capabilities succeeds (indicating SEV is supported), th=
en
> >> > all the returned info is exposed to mgmt apps in the libvirt domain
> >> > capabilities XML document.
> >>
> >> So query-sev-capabilities is good enough as is?
> >
> > IIUC, essentially all QEMU errors that could possibly be seen with
> > query-sev-capabilities are "GenericError" these days, except for
> > the small possibility of "CommandNotFound".
> >
> > The two scenarios with lack of SEV support are covered by GenericError
> > but I'm concerned that other things that should be considered fatal
> > will also fall under GenericError.
> >
> > eg take a look at qmp_dispatch() and see countless places where we can
> > return GenericError which ought to be treated as fatal by callers.
> >
> > IMHO  "SEV not supported" is not conceptually an error, it is an
> > expected informational result of query-sev-capabilities, and thus
> > shouldn't be using the QMP error object, it should have been a
> > boolean result field.
>
> I agree that errors should be used only for "abnormal" outcomes, not for
> the "no" answer to a simple question like "is SEV available, and if yes,
> what are its capabilities?"
>
> I further agree that encoding "no" as GenericError runs the risk of
> conflating "no" with other errors.  Since query-sev itself can fail just
> one way, these can only come from the QMP core.  For the core's syntax
> and type errors, the risk is only theoretical: just don't do that.
> Errors triggered by state, like the one in qmp_command_available(), are
> a bit more worrying.  I think they're easy enough to avoid if you're
> aware, but "if you're aware" is admittedly rittle.
>
> Anyway, that's what we have.  Badly designed, but it seems to be
> workable.
>
> Is the bad enough to justify revising the interface?  I can't see how to
> do that compatibly.
>
> Is it bad enough to justify new interfaces for similar things to be
> dissimilar?
>

Maybe query-{sev,tdx,*}-capabilities should only be called when the
host is actually capable, thus throwing an Error is fine.

What about a new "query-confidential-guest-supports" command that
checks the host capability and returns ["sev", "tdx", "pef"...] then ?

Or maybe this should be provided at the MachineInfo level instead
(query-machines).

--=20
Marc-Andr=C3=A9 Lureau


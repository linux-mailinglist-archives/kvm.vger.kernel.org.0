Return-Path: <kvm+bounces-68656-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kIKkEXQAcGmUUgAAu9opvQ
	(envelope-from <kvm+bounces-68656-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 23:23:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id EF4ED4CE8F
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 23:23:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 2404092C3B4
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 21:45:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBA163BF2E3;
	Tue, 20 Jan 2026 21:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cLPsVBdX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E264F3A4AC9
	for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 21:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768945509; cv=pass; b=vE00iUkZeUu9HJXufXQrMA5ovW08M/YnrswoQdYoU2D4IDiIwALo7mWLWCFyYlBAGoH7SF3hUsOahitq6dmIjK2+sSbae+4kpe83PZIIs07hRu35tjy7ZlM88KCT+/frcpwmJ3oQ9nmcecdVCcWpb/k3vsse1Vf5O7CGaB2b+iA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768945509; c=relaxed/simple;
	bh=wuCVfUPWIgiHPOiSZst2gWx1Ux871B7BayzTg87bd3o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HAKFSP2l4YA964OlV6m8Vk4mB/tqVAXIvzxN5Q+rD9KX9EGuxQ4HjArBdNdC1tx2pEfonU/SMir49L34sEfY819A3+s9RdgYfFbbNhsOdHG38VuaGZL+Lv+K2sQs4xWmhXq3DAtub2e/LReSNxOKiRdwFj8S3ceaH0Ma6CM+Wvw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cLPsVBdX; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-65813e3bdaaso355273a12.1
        for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 13:45:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768945505; cv=none;
        d=google.com; s=arc-20240605;
        b=lS0kHZy8PvVrsE3UV9ZZljy0Op4bBrZ+5GbDA7CygYMuEdILrF4MgaxlsniPOo2z2R
         IiGD3jULjsJE5nRBJHfnEual+Vq07GHPsxPFF3K5OcoGJZQznggD4ErpOQnEOWRj7QLA
         jzMoDIcbF8H8cOz87FcQWy5E3mE1Kdjg6yhw5k9Xok9b+IRtu/muyR62Ad6mmoj81frf
         M7hqsklXt2pp0vfeW6/fg5lODeuZpYShsFl36mQQ4Vg2eAGEbSkpwsrXay7KPEXVw/4R
         auekEWQEU4SIC2yAj7XgPUrYoKcT2FHW1umnS8ZX5+F5jxFr2+V6lZNmBZKrSGhzE5qq
         RBCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wuCVfUPWIgiHPOiSZst2gWx1Ux871B7BayzTg87bd3o=;
        fh=8SbfFRqUX7WvBn6BoK8PV8OrJDTsUKlwQVohs9ydedw=;
        b=L4NSLxUE7eF0rvj0sQeNFHP5XCBcjkktTHDkd4j2xp3qdx59yURGsSDi80lvYXfSOX
         qgBX38OmF+RZtSH/8PZqNYWAmPPpBEHiT5I/BLnbrzaBQ1fDmiLrUtbjqBYmIewavrRe
         VKmTHagKQ/qAzKAREZMWwAWmp+uxJWsrzn7Ved84pkaHUARYJa131JYmIuIhNLA+WCUa
         rTCQ2AebwNSjqzlmFD6I4EYjmzA39L3+FcyGpdbAS7tdIs5A2y7be/pcZgWoY3EnCDlK
         G1idjjN3pBVOAiqIyGJNIq0FE25kbdD6W63CHW5NRj0s83MZQBUIbHlmqf6qY4SPlU+R
         HnLw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768945505; x=1769550305; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wuCVfUPWIgiHPOiSZst2gWx1Ux871B7BayzTg87bd3o=;
        b=cLPsVBdXTH/5Gd/wVBrEfn4Xt5KWcHCXvnDQjHhggbNkfp7/Ji/ui89Xgq/4vECIEN
         qICACGkfVb/dT0rZHzbEH/WoOOJwsfGIbdb1TO7BcDipX09qI8K+mWPrA2n3PscEYkjF
         JXJ0WuHM43BQ21lXqr02lqjQqU6ILKe9FsWdYmLiCJuuGQP1dXQeK4MoHCwavZb0xFxe
         lGpBZN4WQWru4Lf5qsaHKx6bb0Rf/ic/8zSzGyXXwslm7hAxu5gr3w92gC2RJKcnBDOE
         MFwFlE/JnwAM2XHmWez+oUd3jcYn3Hhxpk3F19ds07ucg2BS3EDpSh68NdC/YAj//Hcq
         TIFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768945505; x=1769550305;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wuCVfUPWIgiHPOiSZst2gWx1Ux871B7BayzTg87bd3o=;
        b=ZdeLPpNPVdqCrFzZ0bdbXL5hlr3cHbVKfaTlFR7FXn2tNUF0Q+N4aj8N6MFiyF4Kka
         9zpW4lcAbIbvsXdDUyVVS9yOxktOAZFFWn5hYoW943ruKzrUbqyYbfD/WtxxPZIMIdx/
         XBN8+DGe7SlISu5GexxWHUyVkqpOKKXdlyuD/RxwU78x14fb0ROKbvj7Jfkifj06Y2ZY
         U0urfy00kVwWWKNgrO8QTIcOBcUXYc8S/qGDdu2uR/kkzuEMvtIhN4gIrZZhu70oWEK/
         PSS1yCCEubvqHz3c4eMH4vFlA2Ar+h46Oc35+mM+atZyIi4hCs59qe8waMFMFIij5C3W
         YtIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWE4ZM+rMPheIlWukT6Zi2AC/C1j0ctktYzN9uDlliPIfxfy/Goq4pEAjh+bgChyn6Ua0Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzP0gdiaULeI5LcueMiJ7/lvu1Hz6poj1IbtiCaVFcSi3+ZKaJJ
	pK1vrY8YGfTajXHQ7JGhhlo2rjvT1zjeH+nGKKK5q/qeaGdy+sInz1IFHZNKPX5fLZw5mF9ehAq
	UOYVGz1SBD1QxYz9hJX7QOoezcfY0SuM=
X-Gm-Gg: AZuq6aKSNJ/Y7JIXq3Zh+8PWYaAq+4J4R85BFt+yyGZ8OYdGzHueWGAbabJPdq9ntdE
	MaDQe4J8JCG0QtyGCYoixPFgyALfmo9I7oM4CMlYzLB7oAYpeYpWYXwsq3h2D91/N+hacTc9I+V
	OsEtIqgI40kWVSiCk/1ekrM7Nhl2Z8jHCPT2lu87HffW8tAoV7065SfXYa4oQc6R55tl0iQfO4t
	ChKEwmy9jXWhg4uZJVNNU9Gdre1a8cOAWA8krQOVH224fwXCriS0JAC32xrOCUHqHBBjR9vj6Ya
	b6tu
X-Received: by 2002:a05:6402:35c3:b0:64d:4149:4924 with SMTP id
 4fb4d7f45d1cf-654529cf529mr14135804a12.4.1768945504621; Tue, 20 Jan 2026
 13:45:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
 <CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
In-Reply-To: <CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Tue, 20 Jan 2026 16:44:52 -0500
X-Gm-Features: AZwV_Qhh6g_HYOVxqiQtxYan6TAF-zvhLHQ20pLxk2ebb7UlLitz7roLdsUNLgk
Message-ID: <CAJSP0QVXzXL60S=4kdRGbLd-i5iNU4Ah2zr6iXzEFPHuA-pTyw@mail.gmail.com>
Subject: Re: Call for GSoC internship project ideas
To: =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Markus Armbruster <armbru@redhat.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>, 
	Helge Deller <deller@gmx.de>, Oliver Steffen <osteffen@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Matias Ezequiel Vara Larsen <mvaralar@redhat.com>, Kevin Wolf <kwolf@redhat.com>, 
	German Maglione <gmaglione@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Thomas Huth <thuth@redhat.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, 
	Alex Bennee <alex.bennee@linaro.org>, Pierrick Bouvier <pierrick.bouvier@linaro.org>, 
	"Daniel P. Berrange" <berrange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68656-lists,kvm=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[nongnu.org,vger.kernel.org,gmx.de,redhat.com,linaro.org,ilande.co.uk];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[gmail.com,none];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[stefanha@gmail.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,qemu.org:url,mail.gmail.com:mid]
X-Rspamd-Queue-Id: EF4ED4CE8F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Markus and Marc-Andr=C3=A9,
Any thoughts on the Marc-Andr=C3=A9's HMP internship project idea?

Markus: Would you like to co-mentor this project with Marc-Andr=C3=A9?

=3D=3D=3D External HMP Implementation via QMP =3D=3D=3D

'''Summary:''' Implement a standalone HMP-compatible monitor as an
external binary (Python or Rust) that communicates with QEMU
exclusively through QMP, enabling future decoupling of the built-in
HMP from QEMU core.

QEMU provides two monitor interfaces:
* '''QMP''' (QEMU Machine Protocol): A JSON-based machine-readable
protocol for programmatic control
* '''HMP''' (Human Monitor Protocol): A text-based interactive
interface for human operators

Currently, HMP is tightly integrated into QEMU, with commands defined
in `hmp-commands.hx` and `hmp-commands-info.hx`. Most HMP commands
already delegate to QMP internally (e.g., `hmp_quit()` calls
`qmp_quit()`), but HMP parsing, formatting, and command dispatch are
compiled into the QEMU binary.

This project aims to externalize HMP functionality, providing a
standalone tool that offers the same user experience while
communicating with QEMU purely through QMP.

'''Add `CONFIG_HMP` build option''':
* Create a new Meson configuration option to disable built-in HMP
* Allow QEMU to be built without HMP
* Facilitate testing of external HMP as a replacement

'''Create an external HMP implementation''' in Python or Rust that:
* Connects to QEMU via QMP socket
* Parses HMP command syntax and translates to QMP calls
* Formats QMP responses as human-readable HMP output
* Supports command completion and help text

'''Use `hmp-commands.hx` for code generation''':
* Parse the existing `.hx` files to extract command definitions
* Generate boilerplate code (command tables, argument parsing, help text)
* Produce a report of implemented vs. unimplemented commands
* Enable tracking of HMP/QMP parity

'''Identify and address QMP gaps''':
* Audit all HMP commands for QMP equivalents
* For critical missing commands, propose QAPI schema additions
* Document commands that cannot be externalized
* Provide patches or RFCs for missing QMP functionality

'''Future Work''' (out of scope):

* Seamless replacement of built-in HMP

'''Links:'''
* https://wiki.qemu.org/Documentation/QMP - QMP documentation
* https://wiki.qemu.org/Features/QAPI - QAPI schema system
* https://www.qemu.org/docs/master/interop/qemu-qmp-ref.html - QMP referenc=
e
* https://www.qemu.org/docs/master/system/monitor.html - HMP documentation

'''Details:'''
* Skill level: intermediate
* Language: Python or Rust (student choice), with C for QMP gap patches
* Mentor: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com> (elmarco on =
IRC)
* Markus?
* Suggested by: Marc-Andr=C3=A9 Lureau

Stefan


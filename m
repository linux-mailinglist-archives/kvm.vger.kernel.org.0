Return-Path: <kvm+bounces-69248-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mPZVOS3JeGmNtQEAu9opvQ
	(envelope-from <kvm+bounces-69248-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 15:18:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 558E8957E7
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 15:18:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C89C4305C4B5
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 14:15:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 382A829E11A;
	Tue, 27 Jan 2026 14:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iFLH2hUz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15EC91F5842
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 14:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769523350; cv=pass; b=rbfcOqNBmXdfN8ot2sUuUqVKtXxZJJU7aRm0FRmP8M6+o3ajRzC4dMxulAsFAFD4LlL2R8He+BhoSG9QiDx7pocifWk+qxWJDaY/2CKSL24WKu2v7DPLSWqyUvXxARDBq9cwhj7fnUI8yiZyzR2CqkA7tizvq2jxFuOr5q9IxjM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769523350; c=relaxed/simple;
	bh=GLbiF1IyZPp/T8r4kh3zX4pVEjDnyrX1mrjLQME69P0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YMKzIfoFTYQGYxxLzQAnUDPPS4gMvGggV5pJtnlnuv01qkmeroy1GdV7J5jxgksBzmdi97hCScvDcN0o5VpQa5o+ssGFOM8eYXUaX4UGih8TSNKKN7qR7fHbeyAnYcCBYLODqON/YyS4XPT7QDVfzVZT2E8y8ubr8zRzDW2e1I0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iFLH2hUz; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-658ad86082dso576813a12.0
        for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 06:15:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769523347; cv=none;
        d=google.com; s=arc-20240605;
        b=U83EDnoQCNM1jGQeJp7TZgMbBxby46eO2lAMOn3wt3MxH+5dT8P3d93ZkXl/Wfx6xn
         rvEKSryPXDzxb7VhaOX+V5iK7zSk40UUbrXm9Ts8BSRZBLlDwqO18ElYbOA2VBISmMRp
         IZAPL5DJfaJ8QZex/BSecj7ZHP9MrInwymnRGLsRZmkWrw/q9FGRgBszqrfbuNvXNrAD
         o5hZtEdQnWbWolXX34uUMft5JlwXB8zT0GoNmmtZvkzW+wh3J/hVoIYZcGQEj7DXAjUL
         dcS2zqmIjoL1Rw36SDkvbJx1xAkS6eumlFMVhsvnZwZ2L+vw6vXddmH1FPl/7ueDGxjD
         EtGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GLbiF1IyZPp/T8r4kh3zX4pVEjDnyrX1mrjLQME69P0=;
        fh=VS22uNc1HHwoj5xEkceMVRoS+U8RW3M6zXc9wR7sJc4=;
        b=Hnu9q5Se2WYRvR5SikX6LjY6c7YtWneSUaK2/tfjhB6qAm26eOPXkmAuJFqiiClUPS
         lWPV9FOFp98I7SkkTswYqYmN87zERVUBGEgI960dZRkwr5WwEhBEtcUeSJ1GdA15/qmp
         q4Y+0aaLAYiMFG89hnSX1ki7uVtnnWDC/j3a645u89aTg+cTL2tNLEjNdUWLU9lgjBY/
         UFHtMJuElkxjYVC2TNB/Ak9uwKgtei1bFu5EFhTqY6cIdJQlCK1oxQZcJ+GkMze66VsJ
         3P76gTTANAQOHbrewRBOMzDiwW4uyYcQBi5evuT5gKG7Hr3vPcpr2u2MqcObbvA/TzXy
         HR8Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769523347; x=1770128147; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GLbiF1IyZPp/T8r4kh3zX4pVEjDnyrX1mrjLQME69P0=;
        b=iFLH2hUzgs+juymJelneDtNCT3VI3/s0bIMW+xTv5SApx7Z/Rg29Hg0C1undyh+O1f
         ZdPE2tiv7Q9XjjYIEyJnPDrWYQ+4hphHa/WP5GiTDbTINgZyOlk/cDU7DXrLhdjeMWdj
         CqkyI2+MHYKbpTxK8UH7byQmVRaaxTCjcVd51Iwf96qelc4woqhjxj1dvolHaa9RzK3C
         QJEr0Wq22Ewvg6w4GdANk7dRQKlfXFn3nItTD/XpinYtwK5Y/XnTmJ+5C6l3JTIN80AI
         XTIiXfZXUA5R3IlRAw77IsXUvkWV2+oK7ZW4xvG+JND3VAVnnAqyTJAVB1oqRlPucX1P
         KNVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769523347; x=1770128147;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GLbiF1IyZPp/T8r4kh3zX4pVEjDnyrX1mrjLQME69P0=;
        b=JYc2ueCxGHVzOew0hHiS+3CJERfQvdfyGW3CySSrT89vgOdMoEDYHtrgke4fbNPeqd
         Rl968IqnnUa2L0eEbIj1O1CPIQ369ZQEBATs6n8OjDoAmyQ5AMg618dNbMVYwA3eCxcf
         fkojXjPRbR47sNB9eV086fNEbv2zCbqIiVTBZnL5aJufxNuhDnWdEDsHDvu9OUOmxbUj
         2SZCW09YkZBYSSyPrpe6VrG48iHF7g20eqUJ/gC8ZEWiVEWayq1B7hKU4hmaPvoXr6TH
         rS6cF8yM2UczkoBQPdSKb78EEOkbP+QWkc1rp9cqn4h/eWh4BTqPThJg67ez/vADkALd
         eCDA==
X-Forwarded-Encrypted: i=1; AJvYcCVE5I9obLr854g3E5H/FPPf3iyomkovfpbrl2+RZdqDa81ogVJt8Jax/sdu49d3nYm0LNQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRYxnVDMcF7C/XjAfyGpyuV5SsXZaQlFI6TuHa/fuKRpAobQB4
	63nP8Y4piz6tq3siz23ztbmWJb/vQX1X1OV0iDnTnbqbaFBcBJyTT7hkwULM2qwuuppEbSsjLE2
	7zCr74u6GtGLEeiTIFWNzSwbOIFJedfw=
X-Gm-Gg: AZuq6aJG1pkZig0S1i0FSHn5HYX5lnTqV5/Jyi2f+0WXPCtc3alioLOJNJp3HY2dDn7
	o2GBRG9npc2BNFSP/y3eW8l7KxL7aLkuzh3+ZO6SZ6OlYmnTHEqYWcQPRVHF8FZvnkW+G/ogwZ/
	L9+cH6xu3m2FSODyBnE71kOWBwZBoTfdtv/rLjanDtJL0ukc56FB6ccfobL0PCzrrMejasJ6BWt
	NCOMec+Oc+wjtR3R7e9udNv+LmbYJMP6P6nehvifZhJ0hf16dQeeau7d5B69Dl+ADs/IFH+tyXO
	W3oE
X-Received: by 2002:a17:906:6a01:b0:b8a:f9d7:1aec with SMTP id
 a640c23a62f3a-b8dab15b734mr150184266b.10.1769523346927; Tue, 27 Jan 2026
 06:15:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
 <aXiFBwcLg4PQ/4m7@fedora>
In-Reply-To: <aXiFBwcLg4PQ/4m7@fedora>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Tue, 27 Jan 2026 09:15:34 -0500
X-Gm-Features: AZwV_QgT0Rw1U9KUEEVJyOOVyteHUrByewQIHIWfVSpxhCJGe_pPA2lGbCMICRg
Message-ID: <CAJSP0QU9aQTa9_7w1XnBchhmxMTUQjqG79tm-MS7fmhtW27ahg@mail.gmail.com>
Subject: Re: Call for GSoC internship project ideas
To: Matias Ezequiel Vara Larsen <mvaralar@redhat.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>, 
	Helge Deller <deller@gmx.de>, Oliver Steffen <osteffen@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Kevin Wolf <kwolf@redhat.com>, 
	German Maglione <gmaglione@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Thomas Huth <thuth@redhat.com>, danpb@redhat.com, 
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Alex Bennee <alex.bennee@linaro.org>, 
	Pierrick Bouvier <pierrick.bouvier@linaro.org>, Francesco Valla <francesco@valla.it>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69248-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[nongnu.org,vger.kernel.org,gmx.de,redhat.com,linaro.org,ilande.co.uk,valla.it];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[stefanha@gmail.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 558E8957E7
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 4:27=E2=80=AFAM Matias Ezequiel Vara Larsen
<mvaralar@redhat.com> wrote:
>
> On Mon, Jan 05, 2026 at 04:47:22PM -0500, Stefan Hajnoczi wrote:
> > Dear QEMU and KVM communities,
> > QEMU will apply for the Google Summer of Code internship
> > program again this year. Regular contributors can submit project
> > ideas that they'd like to mentor by replying to this email by
> > January 30th.
> >
>
> Hello,
>
> We came up with the following idea.

Great project idea! I have edited it to get closer to the new 2-5
sentence recommendation and posted it here:
https://wiki.qemu.org/Google_Summer_of_Code_2026#virtio-rtc_vhost-user_devi=
ce

I listed the project size as 175 or 350 hours. This will depend on the
intern's experience level. Someone familiar with Rust and who has done
their research on virtio-rtc could implement it more quickly. Someone
less experienced or investing more time in testing could spend more
time on the project.

Feel free to edit the project idea on the wiki.

Stefan


Return-Path: <kvm+bounces-70243-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OKHiDP1yg2mFmwMAu9opvQ
	(envelope-from <kvm+bounces-70243-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 17:25:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AC31EA2EB
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 17:25:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8440031032EE
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 16:12:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51A9E423A7A;
	Wed,  4 Feb 2026 16:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fnLwhQGv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D643AEF49
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 16:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770221543; cv=pass; b=ihiZoeKX8Pw3fLhF+PZ4W9YsBysL5rkiau1iCJ6s599si6vGeuZG0yUbxL7UOrSXOVv1EMhqzrde2Ls3ilF/Xdd5l57NjBqSPc87nmhy7p9HcGb0WTZ13HQSecvGIy5LhSAIgzbhkCwB9/NKOBicKqafRih7nrFleLKCZXBDzEk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770221543; c=relaxed/simple;
	bh=kA3kkGkRy1EoHSUrG2Cy3FfnE3rgBk/8wS8Bi5b9XyE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p8u9+E0zW0m7qeEuRb2eTfrW63ok1ruq4vJ5Pd5ZPwafx4biKRVoBx931JTqKuBVvKX3YMzqymVda0psmzE02vVVsPGfRb2blcUtECYSCwP5tJ1oviJuYHe4xj9KMRDMM5UuVaNSB+gWEFAuiouYvKUH2B/imgNzjkRb2OREv28=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fnLwhQGv; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6581327d6baso10165065a12.3
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 08:12:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770221541; cv=none;
        d=google.com; s=arc-20240605;
        b=lFg+yk8yzaiTGDQETSivc/AOOXs5AMjEyAnCUCVkZZj8qQkzSkJwXOof9V0eAkSTP8
         2N8oXTNMhKOxPhdqYht4XLmMUHwGvmvdEKfF8i5zyM9oWzNB5yI+LaJJ/nPtD5FBtkj9
         rbCxDXa5a+fzOGkpwQ6581tEhWqMN3E0p1SKc8nzkG/CSRxbxJzXsGXwGa1Puud7BDwB
         tgRTGEtSTCvATtOxiDJNJfYZLuzbqR3Jepad/PzNRyfPxH6Nn0RhTGtXKHlo5MGkBL3Y
         /3lm755ZSHki0+352Z7CMq5yeaWr0rqVoBY9DKcMUv4yoRaI9ZR05w8Yn/XYQ8h3zrQ/
         u1lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kA3kkGkRy1EoHSUrG2Cy3FfnE3rgBk/8wS8Bi5b9XyE=;
        fh=L/eXldFgyMPWmDMWyEKcf7NE56mq5zKkOYYoOOslGik=;
        b=JGAeznPo890JrZc3AMehtjvsj/vasbW4P6R3XISN6F+ttpnU+X4ilpPE1TjVJzW3fD
         Y5Hw+3WbIXei1DgTOeRGXHCcZWnw/MYio48GGzMcKfF+bVhWlcz9gplh47qZt1Q6cOgf
         h0KTzmrgHLJi/y8/MXJEKIpfKiFeAfqEcr+iHetZWUbo6lVkGf4tIz9feIoMTb6qmKYv
         xC5hRbjUik+dToTQe+J5tB82NMES2LIUOzC9DA98sQjbcB5D7MovyTCAUzbxndtBgyCG
         fXszmQZbws5+1ptCR+B+/GA1wv/xqIV9cnp6pINAtOIOt9BiHeeTQF42nDswE9IWaJn0
         +L7A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770221541; x=1770826341; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kA3kkGkRy1EoHSUrG2Cy3FfnE3rgBk/8wS8Bi5b9XyE=;
        b=fnLwhQGvcT3mH2CY9B+VWY4NtP7Kv+GX+bWQWsLMZyTcvFl5e8//GVxvi3doQjE79V
         ZwqYcUPDyuVnexfdo8KygTy05fGQP/OTzidIZwRN8K0q+SsXqMTaFR7CBK5YUrtZd0A7
         rOO0bcmTNlMpoEQrqDe6/il4oMY+aMuWKA6A5ntYEffAQXw9yOGCm9nIgSDOblfXREp5
         0lb+9R+Xtxa4nN0TPMYbTPPDEl6aaqz1sNSAlTQdgnGJpmJZHsLvOgjXs/YhgfNrS+wE
         yGJ+4VvPQY9xsWayz+vdROkx+BxanvgRWL8uvREyI5F6em28B3s/5ZUIBXcBSne1OXKV
         DA/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770221541; x=1770826341;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kA3kkGkRy1EoHSUrG2Cy3FfnE3rgBk/8wS8Bi5b9XyE=;
        b=JZnhD88gtM1NnIJg0+c5d5ed2Y+8WVSEn58BgPyIlm/4pqF3TMPXbuYKIAvFgh+3c+
         bU9TeGIjh/vbgvUDT4Ih8lE4vwr29i3qyCSnN2Yq6IukEg/30ubwf4IvMQaMHfyqSai0
         xnzL/x3PqGDy6Wf5aT6BxgHEhSm9NUkgXKGyUdnNDFDwtDO0fGnUDAm3FmqtTawzaYeB
         ZvPffvp3+H55QpcQkJXV5QoYbE0Lb+dnuO/AxyQR02tOuXZp0PBxFVkb5Rq8cGYLvcUo
         W6HaX06QK3olg8HvFgJFAlyn2PB/VMxF4vI+Ve7a0C8zLLrdiFuBpRS52Lyf/qQq+6S8
         ZJtg==
X-Forwarded-Encrypted: i=1; AJvYcCW/9oN4NRiuWats7kH2e7uUxfadJKb+Toz52Ntdut7MCoaa0JbKYS8Cv7R2ISNDkpjH4Z8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/qt58n9EFYbQtxkM6etgVI5o6qoCUUIW0aRftJ5asIfzeJZRn
	5w6FGOYQSuvmiQNeZK1v+GxnUsVPHb/NKWlPbSfu5iJDCqagSlH4d/DMHPxinORfuct4IIS+qUK
	Bo8bBd3QPoDvEG75zZscNgZXpHSaMxY8=
X-Gm-Gg: AZuq6aKOyRb67E37jJ2+Pa7ZPRAmYHp2zk1Q0Sa+h2bTLJMuhbvlAkDgvbeFWB7m4tQ
	8hLebcNBiTPAnZFTo0+XX1oGEx6SuVswJiRcE+IHjCMk8mq5cVfB8Ulifvb6M6fusLSnQW8HV9O
	c1OLE46x1fST2EIQhfb5GQrJlSFoQoR527C8dZ4+0BovfjV2G0NT1STdW6eLF1XBrz4g88+PNmV
	uxJIzagJmJm1FS7K94SvuMdre81Bm0P7POB0kCaU1j77t3e7DCrnL2AWIVjTpNJ/8OQWg==
X-Received: by 2002:a05:6402:1ed5:b0:659:408e:b7e6 with SMTP id
 4fb4d7f45d1cf-65949ecd24emr2079778a12.29.1770221541257; Wed, 04 Feb 2026
 08:12:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
 <h4uue2ekbnlh26rylj4ilsqzyxdrfzrq7czleysrkbowlgp4q2@wtbm7zi4kev5>
 <CAJSP0QXu+fmKuOKLw=OXL0GqTQS58pM_-REtnnOCiSaZJp9=LQ@mail.gmail.com> <2dzs6ukw6gwndluqlzarsmrueug5t7vtic6toxs74k2zewrzwe@337u533iprja>
In-Reply-To: <2dzs6ukw6gwndluqlzarsmrueug5t7vtic6toxs74k2zewrzwe@337u533iprja>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Wed, 4 Feb 2026 11:12:09 -0500
X-Gm-Features: AZwV_Qi34AfCTqThZTWIsGY-3u8Y3efuATqJR74FppYiIUTjW6dmESozfgaiWhg
Message-ID: <CAJSP0QXV5GK=wecHQcdJoa-ORGg6yM0zgeunezW0pPJiXRrqBA@mail.gmail.com>
Subject: Re: COCONUT-SVSM project ideas for GSoC 2026
To: =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>, 
	Helge Deller <deller@gmx.de>, Oliver Steffen <osteffen@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Matias Ezequiel Vara Larsen <mvaralar@redhat.com>, Kevin Wolf <kwolf@redhat.com>, 
	German Maglione <gmaglione@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Thomas Huth <thuth@redhat.com>, danpb@redhat.com, 
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Alex Bennee <alex.bennee@linaro.org>, 
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70243-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[nongnu.org,vger.kernel.org,gmx.de,redhat.com,linaro.org,ilande.co.uk];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[8bytes.org:email,mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8AC31EA2EB
X-Rspamd-Action: no action

On Wed, Feb 4, 2026 at 8:24=E2=80=AFAM J=C3=B6rg R=C3=B6del <joro@8bytes.or=
g> wrote:
>
> Hi Stefan,
>
> On Thu, Jan 29, 2026 at 09:18:15AM -0500, Stefan Hajnoczi wrote:
> > I think the mentors should provide the extension to the SVSM protocol
> > specification. That way the intern can start the coding period by
> > diving straight into the implementation and there is no risk that the
> > project is held up because the community does not like the design.
>
> Thanks a lot for your feedback. You are right the the project as describe=
d is
> too big for GSoC.
>
> So we settled on defining the protocol on our own before GSoC starts and
> provide it to the student. Updated proposal below:

Excellent! I posted your project description here:
https://wiki.qemu.org/Google_Summer_of_Code_2026#Observability_Support_for_=
COCONUT-SVSM

Please add a link to the protocol by February 19th when accepted
organizations will be announced and interns can begin researching
project ideas.

Thanks,
Stefan


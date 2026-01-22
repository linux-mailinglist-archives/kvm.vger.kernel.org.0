Return-Path: <kvm+bounces-68876-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gLgxLPAFcmmvZwAAu9opvQ
	(envelope-from <kvm+bounces-68876-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 12:11:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CC4165C53
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 12:11:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 11FFF5ABF86
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 10:56:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F41BF37E31D;
	Thu, 22 Jan 2026 10:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="T8vC8utP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9989E15746E
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 10:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769079297; cv=pass; b=W1iiyQCFI4RLDMJE30J44pCcGU9Jd+VE5rgZqvRllw2O/qGzK90wLC0zb2QQv/fCuG6GPzRyVtLBbHzxs5RgA5TnBbbFW5oDPQdHn4juQGNKYiLdMWFmrvadTDbAuxoyuwy6kdrgiyWAdWgYqBd0gyf6qkaG/AZrpPRTztGnNKg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769079297; c=relaxed/simple;
	bh=KBLZUlYPi9OL0gX4++Jxct32vanQpImbAVqWFhCNfPQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h6ZypOTTq4yqaKWriKSZXhKuiyGjnFSOB0b1FSoyZFDljD8C0PMCq/R1kHlf413fx3aBBW6WcaSyIz/dx9sEBwrpgsc7rydpYDQKXvimkNmouYLeJscfxUWa+zcBpudtem6Jfhobg7OUzO7gRzlmJMXWkjiwv0hyYZ7HME7uOPw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=T8vC8utP; arc=pass smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-78fdb90b670so7217237b3.2
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 02:54:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769079294; cv=none;
        d=google.com; s=arc-20240605;
        b=k/gw0SJYKdwrK8NzpYRmTBSDq8UO0ZdqaDhzKVDuvb3Jyfk/JBsONYOOP+iLYzdYDB
         OZyifY/255aCGfuqjv13yFqHm7RDUEuWqC+d8TFVFufdxxHzddiwpro3BVSTXzwhD71R
         lHg5oQYKtS9nrJlNkQEOLXeW0JGg3Zr8Gki5Etldcbr0eUt3ixnsAVIyhQPOOX/ET2Mq
         6iuCVFiPyYo3GqPMxj60f8dzKYeV3hFVa/elfB0hI16HnEXvXGOaxFQJ5rSMEaSOLdz9
         5bekeDtL3Y1TbDoNpJMXtDB5KvKfJPPH8+ZS4C1Jh8gm0+u6SQ8beuidJVmdqnEe8vpl
         lt8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KBLZUlYPi9OL0gX4++Jxct32vanQpImbAVqWFhCNfPQ=;
        fh=smTL7QBzxxdtwbB9OswdoJv5NKAgNtpZPEQNaeOGjhY=;
        b=auDN0kw0r2A/TaEOYK0EKJXEUwXXMNaGoxJY1eGZ7CbfAyhgKYuqG9Ety8OGbf1G7Z
         ye3QDCoSUpHkUTgLmR/pguP4WbO75IwsOdjdm7WgZZcnC/JtZnXQRehEFNELeAlivKPy
         6gDp8ULldzQNdr9EmHftzgFO/foEt69CBT2osToWFQtoBrr1XoWm5CVQW6ZF49v6R2Jc
         VPG6CP8QLWnLLFEO2YajzUDAbOWTIstgWDDPsCVEKEuMZ0rIomBh7OuMBipybrcgroPY
         gAiPhArZefrn7VJkXG+NHf8dLNo3Y+REMjRISoyISvLNijhKWf5cGPCNgV++9zJ4VYpc
         5n5w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1769079294; x=1769684094; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KBLZUlYPi9OL0gX4++Jxct32vanQpImbAVqWFhCNfPQ=;
        b=T8vC8utPD2FsmUJkarapsAU9pbnwyJq+dU5x94DIZXKYBGZFFTToHFXVGxY6rEc8Ag
         fMCSzi4iMw2H6T94CNLtODsI4S+vB5O7vQaP5XaP54GLXmbEH5LQt/K3JVB6tvTYcNKy
         8Jw+kloAtwe625s3frbU6Y3Eq1l2cXf8Df7KAP0oAB6DMizuGm+dRb3/yqVPUMA3CmJJ
         vzFOOtRxeN0taQNE1TqStUntZhS+Wns5YtQYpVvV3u6d07rmr39tjPN/ud69Ml3D5ir0
         hpLopdjnS5ZO+Zro7VuxMOgkUDosu80EMOAlBC8SXah24aJe70d5xVRdCz7h9uERCWeO
         KkNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769079294; x=1769684094;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KBLZUlYPi9OL0gX4++Jxct32vanQpImbAVqWFhCNfPQ=;
        b=ds8JaKrxQO8h8cvxFrgwlEEF9XY6fFtEbGaqtVjWftMTOfOfe9JvDjHDjVgVCxntyP
         Z+02SVhW+pm/dxcg0MT/A/H+PZeYHi7mRTpGHs2o68iYVhhtl2rJ1L+aRQLUcfjJZvIU
         INpL6+j7/RvDv7fNpmaW232a2EhEJ2R+h9NvOWrOxkSxxvAaijt7MG+ufoxkDEx7ssnx
         uj+GDx58CZfZWkytoumz5+pQXI/svhpVs7Of/Uk0qLXYFkSdwAl/yUnY2tBPa1z6Agr2
         dpVyEdri4YGzvs1MQFDEMd8AAGkG2Q6HDk0IqM4S9pM7rAOM1Zff6yPHen/DeN5lD+Cg
         NPCA==
X-Forwarded-Encrypted: i=1; AJvYcCUU74eYRvIfrVHYrZaehpDw3Do/Jd6kN1nU24bM/F2FR7o0X/5iXmKiZaiT4fxFDq7htm8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3BVRcos7G0bhd6mdCHRrDty8Hgh/MdTszcYZ5MRPxjSRTO9gZ
	Kjphpj78rko/SPo1FIGPgbCMrTrWGAam2AAx4WAfwRSmnre+ys5d4dFZq1zMpbPzp5Q2ppCby0q
	T9vvCDCuvk8h1nafClGhwUSvvBJRi7+klOR4r2eg99w==
X-Gm-Gg: AZuq6aLsPAbJlHPnAcFFEbekFOBPfwg74ILMH6eWSH68kzbK44kNCcJsikLpNBmHWgk
	4ZM1B74XxSKkXx7fzhiirxTqZvqR1OfrpL+OAUWRzULJrRuykxrR61Vs1770a0/a0VumH2zZVDv
	pet/8hxTB/oWAjqCntOY0rX49Tbw7uTYQWoOtdpBToSNRkyRYi/A/ueC+0Gxxp0RLuohGrlFCxX
	PoF6INGHYaFZIBt+SZkliEej7N9nSHDpAirM/62yWvWVfS18v2Op7AbaMUbGZP1C0YBAQ==
X-Received: by 2002:a05:690c:6612:b0:78c:5c75:c4a4 with SMTP id
 00721157ae682-793c523afa0mr186863137b3.4.1769079294240; Thu, 22 Jan 2026
 02:54:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
 <CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
 <CAJSP0QVQNExn01ipcu4KTQJrmnXGVmvFyKzXe5m9P3_jQwJ6cA@mail.gmail.com>
 <CAJSP0QW4bMO8-iYODO_6oaDn44efPeV6e00AfD5A42pQ9d+REQ@mail.gmail.com>
 <aXH4PpkC4AtccsOE@redhat.com> <CAMxuvaw04pDNzHyw5+Qcv_KfrhDTiyp+MNxpECp+HfTa5iLOGw@mail.gmail.com>
 <aXH-TlzxZ1gDvPH2@redhat.com>
In-Reply-To: <aXH-TlzxZ1gDvPH2@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 22 Jan 2026 10:54:42 +0000
X-Gm-Features: AZwV_Qg8al33RpykEsKfUtlazBeorOsv3iS7Irhtzt5-pkGepdY89pm5xR88IRo
Message-ID: <CAFEAcA_u6QUhs+6-cyYm_qttsDiV2zHbsc-_FbTb8QzWXk6+tw@mail.gmail.com>
Subject: Re: Call for GSoC internship project ideas
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Stefan Hajnoczi <stefanha@gmail.com>, Thomas Huth <thuth@redhat.com>, 
	qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>, 
	Helge Deller <deller@gmx.de>, Oliver Steffen <osteffen@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Matias Ezequiel Vara Larsen <mvaralar@redhat.com>, Kevin Wolf <kwolf@redhat.com>, 
	German Maglione <gmaglione@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Alex Bennee <alex.bennee@linaro.org>, 
	Pierrick Bouvier <pierrick.bouvier@linaro.org>, John Levon <john.levon@nutanix.com>, 
	Thanos Makatos <thanos.makatos@nutanix.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68876-lists,kvm=lfdr.de];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_CC(0.00)[redhat.com,gmail.com,nongnu.org,vger.kernel.org,gmx.de,linaro.org,ilande.co.uk,nutanix.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[linaro.org,none];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peter.maydell@linaro.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linaro.org:+];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns,linaro.org:dkim]
X-Rspamd-Queue-Id: 9CC4165C53
X-Rspamd-Action: no action

On Thu, 22 Jan 2026 at 10:40, Daniel P. Berrang=C3=A9 <berrange@redhat.com>=
 wrote:
> Once we have written some scripts that can build gcc, binutils, linux,
> busybox we've opened the door to be able to support every machine type
> on every target, provided there has been a gcc/binutils/linux port at
> some time (which covers practically everything). Adding new machines
> becomes cheap then - just a matter of identifying the Linux Kconfig
> settings, and everything else stays the same. Adding new targets means
> adding a new binutils build target, which should again we relatively
> cheap, and also infrequent. This has potential to be massively more
> sustainable than a reliance on distros, and should put us on a pathway
> that would let us cover almost everything we ship.

Isn't that essentially reimplementing half of buildroot, or the
system image builder that Rob Landley uses to produce toybox
test images ?

thanks
-- PMM


Return-Path: <kvm+bounces-71122-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8EzlIyIck2mM1gEAu9opvQ
	(envelope-from <kvm+bounces-71122-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 14:31:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id B546B143CE5
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 14:31:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 92B113002D12
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 13:31:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BA96286D53;
	Mon, 16 Feb 2026 13:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="C+JYKjLd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453E41D95A3
	for <kvm@vger.kernel.org>; Mon, 16 Feb 2026 13:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771248664; cv=pass; b=QHNqAQrk2RMcEsNzh4VoarwzvnQKfv7nHW97c9WFM2ioNgBNSS+50Rd+STsQCgO2JD6Js0y8aHBTzkzhe5GtgULkvAoGFdMUGBeiArZT3p6RGaXVONP6rFA0JkC9OEFWMsEouuxfMw9ImolkcImTGbO4TPy82cVoAwxxX7aCp2s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771248664; c=relaxed/simple;
	bh=KYwDyE5sgL5bnvQDKuNcqwkPWVqjsboFUT0Et0w39IE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=haetiJEAMLzanQ0+2c3B4jbMJqKuaMSw8E5sQ7IXn3qj4UzlxGD7Wag31syvJv/E0W/lVrjWBhrCmSHyndlJxNi+eHE5MWU7I2rX6heLd6HReIhW8IjIOwXFaqunI9WzICmf6LDv0BUsPWdPL1CgVNk2yPAAo8LhNMLKB2xjk8g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=C+JYKjLd; arc=pass smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-79456d5ebf9so28151367b3.2
        for <kvm@vger.kernel.org>; Mon, 16 Feb 2026 05:31:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771248662; cv=none;
        d=google.com; s=arc-20240605;
        b=Efbuq/yX7yuGgK2mWYz2TLCKcoBkivmtOnAUCIVGhlWYjdG+yRyNnbWDjK5qaBm6X2
         o6F38hPNedzTRvcn+mYukaGoKBrsDmWXD5q2eS4zs7GX5bYrE32t+7G7+4ZAJ0ijV/1r
         U3/6/i/zUpR+Jf9xfr5J3AxWr3ZlZJC7nMzUktIt4GIGTi+ntd5nI6nxq0WdP5i6L0jr
         7h2dBju54jJG9PpR+RK7ncq6wQnmFjc8nCOUZG67xUW0B3rC27LoOfLw7nDRNYnZCrt4
         FWIR31GbI2Sw5sv34u2WGlIpwY+GLltlm5cmuoR7UXPHH9//hjzIr8A/l5YinBr1jPd+
         hAYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=o3wOtoDZJ0p0jz0Xtoq03ZP4KLyE4lMLqKI4YU+J1SA=;
        fh=DtH1uT6Kv9oi0A8Ef5RgNk1UngMf/DZrCB4LXtcKmz0=;
        b=ks2reZJKd688Fim5sGSt96pMChk+24NUgaz8X9e0JLkGrJ98xtpz4i4Sn3Z6dmvbRf
         R0L1TBHh8MbWy6Sp8BA8y9UyflCuBdl64qDVyBhWnpUm+CVHnjASJqvVTW9Vg+HJ2UCj
         a8YspMNp7CxbCe1l9okGFih/M+QvJcwhaODQIsaMXAvZbbm+U5yX6oL+f8Lb9rylXNFh
         7nNMU+Txf45qu5sPo+0ohQOwJ9Jv//UlMEf4aTmqjv2iHqKY407y3/mcyAOEO692l1F1
         S6IAMWpv2boc5vkgcZnMeRZawZm5FMR492r87UHE+lcaV+mhQO5N60MMjLP7wvt7V7OV
         GVkA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771248662; x=1771853462; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o3wOtoDZJ0p0jz0Xtoq03ZP4KLyE4lMLqKI4YU+J1SA=;
        b=C+JYKjLdQ6RcUfRaIpBmanMH3afsqryT7C8S39/QASnkCLvd5IWPwnrhlN1mM3c+FJ
         AX93JBrcFyiHfe72SYDVyOlYoMi0SeASqwAnE7WvMG2Hk33Doyl1uPAfAR0YEQZwdxTP
         ixi+r/URqa251Cx8iEVtoZSmknMqmTRnAuHmCG+4ONuuVBNa+747UJb5O8yZpS7IRxwm
         +XovX5Cv/gOyO98S3vvSRWo/jFDHRXoirS/nPwXsRoWZfAWmqLmqshfkeOkeRtsViN+J
         9n3cC6vfBnCfpxwLJrDtvI49li12cqfAEltnDmyir6ieoYg4TAwK+M8OK9xQc930Z89Y
         Ya+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771248662; x=1771853462;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o3wOtoDZJ0p0jz0Xtoq03ZP4KLyE4lMLqKI4YU+J1SA=;
        b=lUIG9vwyR1UgxMJ2ZTR5cyx4UikX2brOrLW3GfLTcRWyVz8cLdFKMQH777QsYyatUN
         NG2iC++gPTj8xnlYt29mf1YRTFAE+BJDa/9fz+NlOHrbzDoVBrcQbnmrV7GG17PZ5KbB
         NEouO1ExsrRvWU7Xit7Jz67rzw8KSAVjMW9lJYJBc41oQekaaupxaq64kHWVfOuG5mmS
         gg4ZWpvOp0GO3aiYiTc/WjTncNuXw7yWSdaSqWxFTl2InoPXTgGD84t+s/gFkErjMkYb
         jiCy1YvDxx5UhwW9qYmFhqvJkh+6ckX7QgsG2d3H/acXvagcU3tGJabjrDoOnq0UuZ5S
         qxwg==
X-Forwarded-Encrypted: i=1; AJvYcCXJarR3v1qP7/Ofr4lVL/laz+8n+3Q/N0vAmh+rsZgHWTaNvfzDK/kdf/ucEce26UAVYDA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy40BrYuIVoxXjc16iYAkNTdbV0xUj1Y4A4teS7PqqMmztnFclm
	DEFNtBUohotyw1jwLkSSHmxkW30Tt+HOTIAXCBcFQyeoaO8HzRGcqU5cvoqNpxklFZ8Tn9Q9ETZ
	bYzk9hXH+BX3Hc1F4hNiO0fb3EHdGBC5TwXkJhvmhpA==
X-Gm-Gg: AZuq6aItycecqYY7vUuxvKr1hyOObzUF2Oewc8XA4f1VUyv11fKcTpemfSibUKPYbJ1
	BOLpPdAIOkOK1NxLet3txTJwds3VNaXlJdUZDUZhPtAORMB/pm2Ij2NXxDO+/0yObEpt2jIx2PW
	FxYTLp4GWVBp2FpQEH1/sAPVwlhZdLSYas+FeJAoW5IE4vS7kGRGoa7yfrhJzeAZr1PhnW+wJVd
	rTzC3vX2G4Szk1UQHPOB2tazsxxfFxqREUg2E12gHLAdwm84FGjLkUG2gWIPkqPBG/69uyhKthj
	54xwLm/0XBZjnj1PQgIJXVOfk7/Mh3KkR6sO76M+sV+hobXn5abiumfAzy3+7CktI20yTT4TgBW
	Mzw==
X-Received: by 2002:a53:b20c:0:b0:64a:d720:f259 with SMTP id
 956f58d0204a3-64c21b80db0mr4529065d50.85.1771248662214; Mon, 16 Feb 2026
 05:31:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251202160853.22560-1-sebott@redhat.com> <20251202160853.22560-3-sebott@redhat.com>
 <CAFEAcA8oi1Xs2kv66dFV9NZore+Q2vHUsgMikveVdN1c+3SBJQ@mail.gmail.com>
 <9b04a20f-b708-208d-1e4e-466ec30b7bb9@redhat.com> <CAFEAcA-A+zW=QFdCY7z==+Z=xXfhJvPeyHhbG_MpEmpkQfrmaw@mail.gmail.com>
 <4e9470d5-ef3e-cf5c-4117-fb589d56323c@redhat.com>
In-Reply-To: <4e9470d5-ef3e-cf5c-4117-fb589d56323c@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 16 Feb 2026 13:30:51 +0000
X-Gm-Features: AZwV_QhGoaC3Vnb64FdYsO_8xJx-bd5rBrEQJ8-6M3I7JiVPCm-6tAEOuq08bHQ
Message-ID: <CAFEAcA8V9bjQUzUYAW7qj5fEn_f9xaPJAYpTRgvdaFq0cY3pRA@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] target/arm/kvm: add kvm-psci-version vcpu property
To: Sebastian Ott <sebott@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Auger <eric.auger@redhat.com>, qemu-arm@nongnu.org, 
	qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peter.maydell@linaro.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-71122-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,mail.gmail.com:mid,linaro.org:dkim];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[linaro.org:+]
X-Rspamd-Queue-Id: B546B143CE5
X-Rspamd-Action: no action

On Wed, 11 Feb 2026 at 16:04, Sebastian Ott <sebott@redhat.com> wrote:
>
> On Wed, 11 Feb 2026, Peter Maydell wrote:
> > On Wed, 11 Feb 2026 at 15:37, Sebastian Ott <sebott@redhat.com> wrote:
> >>
> >> Hi Peter,
> >>
> >> On Fri, 6 Feb 2026, Peter Maydell wrote:
> >>> On Tue, 2 Dec 2025 at 16:09, Sebastian Ott <sebott@redhat.com> wrote:
> >
> >>>> +static char *kvm_get_psci_version(Object *obj, Error **errp)
> >>>> +{
> >>>> +    ARMCPU *cpu = ARM_CPU(obj);
> >>>> +    const struct psci_version *ver;
> >>>> +
> >>>> +    for (ver = psci_versions; ver->number != -1; ver++) {
> >> [...]
> >>>> +        if (ver->number == cpu->psci_version)
> >>>> +            return g_strdup(ver->str);
> >>>> +    }
> >>>> +
> >>>> +    return g_strdup_printf("Unknown PSCI-version: %x", cpu->psci_version);
> >>>
> >>> Is this ever possible?
> >>
> >> Hm, not sure actually - what if there's a new kernel/qemu implementing
> >> psci version 1.4 and then you migrate to a qemu that doesn't know about
> >> 1.4?
> >
> > Oh, I see -- we're reporting back cpu->psci_version here, which
> > indeed could be the value set by KVM. I misread and assumed
> > this was just reading back the field that the setter sets,
> > which is kvm_prop_psci_version (and which I think will only
> > be set via the setter and so isn't ever a value the setter
> > doesn't know about).
> >
> > That does flag up a bug in this patch, though: if I set
> > a QOM property via the setter function and then read its
> > value via the getter function I ought to get back what
> > I just wrote.
> >
>
> Meaning this should be something like below?
>
> static char *kvm_get_psci_version(Object *obj, Error **errp)
> {
>      ARMCPU *cpu = ARM_CPU(obj);
>
>      return g_strdup_printf("%d.%d",
>         (int) PSCI_VERSION_MAJOR(cpu->kvm_prop_psci_version),
>         (int) PSCI_VERSION_MINOR(cpu->kvm_prop_psci_version));

I guess we need to define what we want. Things we need:

 - user/QMP/etc setting a value and reading it back should
   get back what they set
 - QEMU needs to keep working on a new kernel that defines a
   new PSCI version in the future
 - user reading the default value and then writing it back
   should succeed

Things we might like:
 - ideally the setter would fail if the user picks a version
   KVM can't support, but I don't think we can conveniently
   determine this, so "fail vcpu init" may be as good as we
   can get without unnecessarily large amounts of effort

I think this probably adds up to:
 - setter should accept any a.b value (for a,b fitting in [0,65535])
 - getter can handle any value and turn it into a.b
 - make sure that setting it to an invalid value gives a helpful
   error on vcpu start

Doing it this way, do we need a separate cpu->kvm_prop_psci_version,
or could we directly read and write cpu_>psci_version ?

thanks
-- PMM


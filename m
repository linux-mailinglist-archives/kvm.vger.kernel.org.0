Return-Path: <kvm+bounces-70861-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cCjVHlKijGlhrwAAu9opvQ
	(envelope-from <kvm+bounces-70861-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:37:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AB0EE125BE0
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:37:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9A8943017273
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 15:37:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 047703090C2;
	Wed, 11 Feb 2026 15:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ffGQCWvN";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="nXuR+2uQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E60306490
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 15:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770824265; cv=none; b=Ze/u6Oz8vYGo3U/WB/PSB5O2PLzO2TKUDcxdbjqpUAfwp0Rn67NTOd6+d42p7JiaFgE9H1E+hHLKTGIe/OvUNGtG1mAtO5nA7NtG/wiGTLrTULqj83MXnCsgn0uX6kF4U1AMNvhvMgtZ6Qj9vFPcI/rMsar8/bOPPuBpXOcuoTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770824265; c=relaxed/simple;
	bh=xHy9RX/mmBJnwO1e26QwOS7d3Cg1h3No9+gcl/OXM+E=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=rKyeT9XllEN9ymshU9ACZZtYYL5Y6amhMc7exEMNgkaV/OOnd6wquga0mH5l6KxDBkr8t0PgtxuGFmpLT5MUIM42E5z970tjJKrX62qzjEaJcIh8MJrh5EtpBZXbLwFtFOf4pN72fIcPX154+r3jCLoV3H+CKwe79nM4drK3WTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ffGQCWvN; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=nXuR+2uQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770824263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0t2ls4USNVIXwkkL2q2g6u6o8wxKJkSwfzOXqzXvmPo=;
	b=ffGQCWvNQtGKImm9wsfCppiSQC6wT4qrnZsLz4kcFl0P8xogq3auFpLN0Y6j52EdTmLbrU
	Pnm7omW73Y8orORzbHllMia9tz8lWbKRjz4JecCFeXnxUUfdtkEu1RKFIKNZzGLzqdiZHd
	sSJjD2YauiX+J1y2+xQg8hDB0WzvhmQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-113-X--cDbUwNe2AvHuSiEzUdw-1; Wed, 11 Feb 2026 10:37:41 -0500
X-MC-Unique: X--cDbUwNe2AvHuSiEzUdw-1
X-Mimecast-MFC-AGG-ID: X--cDbUwNe2AvHuSiEzUdw_1770824261
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4806cd00e02so33259735e9.0
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 07:37:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770824261; x=1771429061; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0t2ls4USNVIXwkkL2q2g6u6o8wxKJkSwfzOXqzXvmPo=;
        b=nXuR+2uQaNO/FS20iaoBZiekDDuzzT/SVPW0VAD9DYCs0lxA47d6UHPpoEndUGG0yx
         HslH0Dq/wlWfA6fh4T35zoHTxbP/X8QfUPZ1EiCw4lpkVWZ6AzqhxRtQ/bO4kivSPMoE
         soWlttTLzvb6KHu5neI5CVYXvCIX2DveBwpkXt7PX4jGLvpuV03J84s4h1rJbYHZy8gg
         H5KhdJuI60Yxt6wBszJa4MIRWu1MZmf0T08TBclmfOKyaI7HQ5CUIInLulQCGaKwcbAb
         SL2t5sMiw5Vf0D1ELU7L4L5qoHAdN7ymazFo1i1SEun4gacJn5stCRGwU+NfGEfpAgkE
         85eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770824261; x=1771429061;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0t2ls4USNVIXwkkL2q2g6u6o8wxKJkSwfzOXqzXvmPo=;
        b=CkTj1ACs25Yz2X35GPcvhJyKY336eYgpLYzdnrs/0M5nBCLb+o0ZZDOkLlY0CFyFg0
         doH3pVBcW7YbiDhX6HoJqQKNh0Y3YJZD7BDU2lkvr/haR17jyd4SpUUBIQ8g+5IWt8E3
         vdUMhXrRoBjPGkGhNxRoyg3HDyu/J64pitdkoY5kdIzEZhL/bRVW3oU/Dv5BZgG801e4
         NRg0bGGJ/30oL/DiJC+ol1EJ6qQNpPqoNx4LWlKgaT6SroKPG2gYa8EeZ2YdMsIulISh
         K3yZYyetkZCW48LYpofdIilGjZGGJNqvUEaZV+2AjFITWhTmw+OxHjXPsVKCZdwpBTmQ
         stdw==
X-Forwarded-Encrypted: i=1; AJvYcCUEV+SB+iN331wnCADBwH4SOwzgIDCxXnf0CzUrGYrom7ge/47DKhfrT0FcYl/hMQ0lBN0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8rFXyp69Ra7MBf6Fp1UVLi/Qs1G03lmI9ZqVZXsoGZMIDChcX
	+eWGdsbNm+gLKjUdNiz0BwsmY74anlL4Pahq3UroR+hnZt4UI1bydFoQEb6k1w4eRMA6lZeTUu0
	83oA0ufPs16YPSvxVCaxN0On9C3leUbRyYLuwkplKOfJ/VIwBSSG2Lg==
X-Gm-Gg: AZuq6aJUy695yizlqtv1tiOeE+fUoco2ZutmpC5zE0+t+weGcW72wHTVrM/w99400LP
	gqn5xsToY/io1ulFMf6blqkcJnXcDB/gKv5MEsFLeTOs0FvQiTK5/2tcOzPYv7ieq2ledbIatrm
	88ko3FNeCSUjxXKiZ3an75dWdyDPxwuGcn84Qw9hsSXlTesYGtZ+FYsDRTmjsYCLGoPARWFM8ZL
	h7Z4aDXIJhSfFzv6UWhKDB6IXfxK4mzxXz5y6fLMh82PpBxYNuQMD4UycSgvw8SV6iBXhaJPufu
	6uD1E4YRbfx2vXcz60OXj5A6+T/lArT/D8kVIhD7ZtXxWFKqOdsmgw8JTjYPMA5HU8vFZWuHAt9
	0hv9SmN03KypZJFeY1fjSuG4i2M9ULNZKV0uDVze15bLf78jSVbR5VHbJ3i6wwdeuEt3B2U0=
X-Received: by 2002:a05:600c:638f:b0:47f:1a8d:4f30 with SMTP id 5b1f17b1804b1-4835b936b47mr41117145e9.26.1770824260593;
        Wed, 11 Feb 2026 07:37:40 -0800 (PST)
X-Received: by 2002:a05:600c:638f:b0:47f:1a8d:4f30 with SMTP id 5b1f17b1804b1-4835b936b47mr41116775e9.26.1770824260146;
        Wed, 11 Feb 2026 07:37:40 -0800 (PST)
Received: from rh (p200300f6af2d8700b4c2d356c3fafe63.dip0.t-ipconnect.de. [2003:f6:af2d:8700:b4c2:d356:c3fa:fe63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4834d82a4c4sm245868605e9.10.2026.02.11.07.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 07:37:39 -0800 (PST)
Date: Wed, 11 Feb 2026 16:37:38 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Auger <eric.auger@redhat.com>, 
    qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
    kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 2/2] target/arm/kvm: add kvm-psci-version vcpu
 property
In-Reply-To: <CAFEAcA8oi1Xs2kv66dFV9NZore+Q2vHUsgMikveVdN1c+3SBJQ@mail.gmail.com>
Message-ID: <9b04a20f-b708-208d-1e4e-466ec30b7bb9@redhat.com>
References: <20251202160853.22560-1-sebott@redhat.com> <20251202160853.22560-3-sebott@redhat.com> <CAFEAcA8oi1Xs2kv66dFV9NZore+Q2vHUsgMikveVdN1c+3SBJQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70861-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sebott@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AB0EE125BE0
X-Rspamd-Action: no action

Hi Peter,

On Fri, 6 Feb 2026, Peter Maydell wrote:
> On Tue, 2 Dec 2025 at 16:09, Sebastian Ott <sebott@redhat.com> wrote:
>>
>> Provide a kvm specific vcpu property to override the default
>> (as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
>> by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
>>
>> Note: in order to support PSCI v0.1 we need to drop vcpu
>> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
>>
>> Signed-off-by: Sebastian Ott <sebott@redhat.com>
>> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  docs/system/arm/cpu-features.rst |  5 +++
>>  target/arm/cpu.h                 |  6 +++
>>  target/arm/kvm.c                 | 64 +++++++++++++++++++++++++++++++-
>>  3 files changed, 74 insertions(+), 1 deletion(-)
>
> Hi; this patch seems generally reasonable to me as a way to handle
> this kind of "control" register; for more discussion I wrote a
> longer email in reply to Eric's series handling other kinds of
> migration failure:
> https://lore.kernel.org/qemu-devel/CAFEAcA-gi42JObOjLuPudABX8WRdWf5SzSbkzU-bd06ecF1Vog@mail.gmail.com/T/#me03ebff8dbd8f58189cd98c3a21812781693277e
>
> Unless discussion in that thread reveals that we have so many of
> this kind of "control" knob that we would prefer a generic
> solution rather than per-knob user-friendly names and values,
> I'm OK with taking this patch without completely resolving the
> design discussion on that other series first.
>
> My review comments below are fairly minor, and patch 1 of
> this series has already been applied upstream now.

Thanks for your comments! I've addressed them all and sent out V5.


>> +static char *kvm_get_psci_version(Object *obj, Error **errp)
>> +{
>> +    ARMCPU *cpu = ARM_CPU(obj);
>> +    const struct psci_version *ver;
>> +
>> +    for (ver = psci_versions; ver->number != -1; ver++) {
[...]
>> +        if (ver->number == cpu->psci_version)
>> +            return g_strdup(ver->str);
>> +    }
>> +
>> +    return g_strdup_printf("Unknown PSCI-version: %x", cpu->psci_version);
>
> Is this ever possible?

Hm, not sure actually - what if there's a new kernel/qemu implementing
psci version 1.4 and then you migrate to a qemu that doesn't know about
1.4?

Thanks,
Sebastian



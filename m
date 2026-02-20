Return-Path: <kvm+bounces-71407-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kKt9BdlPmGkBGAMAu9opvQ
	(envelope-from <kvm+bounces-71407-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 13:13:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9777216772C
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 13:13:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4B4213070DF2
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 12:12:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94565342CB8;
	Fri, 20 Feb 2026 12:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RQA5LcYi";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="JZwnDXLk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954A833C52A
	for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 12:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771589569; cv=none; b=owCz5f8HBE5plKaIxATfzEo9W3QK2D9/e5/gSEeUSLqyVNFnWfKHHDch9eGqrbFMCA2QbrRDASFLjSg46LPK5kGMXXWhKQSi2rDerPkr5ZEeqTWMkI4BlPha/bEvnTeHDmNYbFoTM22pWBZPWs0yAhz7ZTSqCsMc4pk/9VwvtgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771589569; c=relaxed/simple;
	bh=nCHPyfglxdRriYc9YqLZ0QhFT6ATlTe18O5vbwZW1Rs=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=mWipTuzuXSdSDk8WG27SrMQbYLhWBHFKiiQQp4lYY2C2fZa2BrUbZUPRKGK2iZ5XDnT+1lHCCPb8JecsSn6pE6hHykIq3W6Af12MtiHdhhV57lcKor7J7UGgZBi6gihlx7qt77KGvg7u23GO95wV8YTABrzQ893cywEyABwRc8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RQA5LcYi; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=JZwnDXLk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771589567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=a6WnYkUv+1p2RXUoYer9jX6Ro906Av76rOQTzY8hn48=;
	b=RQA5LcYiquEiuV3yr6KMg2yaxT3olW/TQ6RsqCFzfL8+/8NESH1zoJHjifMq+hU+k9DBCV
	mSMA/AMxEz/c+6cSpI6MZRZJZGOcsvHDdfc32nZs53+pNi4dLZwHeSY9ihuBQbriOMOk03
	Z7ydDns6Sa6ltq0LqGRVpwYJ/BsNrEM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-332-JyyJTLeuOei7kPcHTVGr4w-1; Fri, 20 Feb 2026 07:12:46 -0500
X-MC-Unique: JyyJTLeuOei7kPcHTVGr4w-1
X-Mimecast-MFC-AGG-ID: JyyJTLeuOei7kPcHTVGr4w_1771589565
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48079ae1001so14137615e9.0
        for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 04:12:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771589565; x=1772194365; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a6WnYkUv+1p2RXUoYer9jX6Ro906Av76rOQTzY8hn48=;
        b=JZwnDXLk+Zs2uTzg9Ddwj4BkTSIOCyV6O39xFlUB9JA8Dz+1pxzgtckW3p8zByAlJS
         0/Tp9cwT/HQ2KZUKj1B8sHmMQAH3LcHydTRE1nRwgXw18LnzxM5R+MtI0fPsgIqexWin
         sQTpz2w2xisAP80cJZRJlSmdA71DgnLXySOX6VjGZzm8Gqg7aeidygNw+17J+p6h+muh
         mAPpMVzDzNcwXasvtivJwV1Ok2GiwAsEEBxOoT6CbD7cpQar8t32j3FxjYvyfoTukZGs
         h7yAJuhJK6+ol8nsE3pbfR1aFSP7QBB3fqpF4tGbAUt33bDcyFL6rYr6MQ/W2hb+MGJW
         0XcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771589565; x=1772194365;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a6WnYkUv+1p2RXUoYer9jX6Ro906Av76rOQTzY8hn48=;
        b=lRFDT0Rlmni3ovlXN4LBdaDMYftfk5956lku269UGChlbp/w3vOlTnI4mxaAYqIknK
         ooWhcRhEec9BikwsfNTkmBplDIFRWssaXHSux0eC0MpZoIXv9mPnOnfKHaQkIkvSbMS/
         MQbO6zVjKBrWfmph223cheNBmQGgfnqTvq4d8sy39eiCEWkfZX9gmhwhvSVav6LdZCa3
         7uB8jyN3N+8tMQjdJacW+eQox4aJTSYhMM55V/ZbiENHzaDVuMgXoctGF2plJ4v5TgXP
         YcYWtMr+cHalHp/mEpi0kS2x7LE1PhHmvF+VEbh18fUpo86fMye/lp27WoZ64R0CESCP
         oCfg==
X-Forwarded-Encrypted: i=1; AJvYcCV+5TDKgSU/KWK3gXvWUncsgai7BFkLhados4kpIRpgGaJ2w2HvrL2QSOBQSH434DDCJdk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7eSth+04xOOVr1eJlzIshqnbkvx7/8xZX33uuPR/+VwDATs0y
	ZWSdiyJXQblc/ph0DSbXCQIF7yNotOr4NOCYnLkIXLpcg3ylrDE8Uew36hgAwp+ucXYIISHV1QS
	h/OG03EGx6+2I3v4lmhXWmjKNbUp/sAFNh3vQzdj0mfiA3VgAiuyq+w==
X-Gm-Gg: AZuq6aKfOWnC56WWB/VW8H/nBv1LOp2Dwn7a8/5FNIhKkpRoE35eYOG3uxRdVukAK6x
	HKuK8gIpz61uvSpbv7ywrfEeYLsjKAn/LS/+I8x8R5WloUwuAQbKPzWQ+kMl+0exJeLoN+o8e86
	fHxu5e8gMnhnRyhBBgqqdI9DlwaKInCNvQk5DC8XWkYYekcoZasxip6FjinSK03g8Pkjg3RJqYs
	v6/rgIPz0mvQLHXe+fRICrnoiDdxjGAA/5FNxlqjqFX026y311CfLjcZ5TjB0MA57S51IsjalGa
	SCAEZRtXfFFnnurC/FiKBnln9IRIaZYVl9hm/03zlTe/XOqIC8l9RGjyHXkCJnm3eoNT2qSPMuj
	HF2q2s2hS3HChkEbSUrddntcQhlLrdYI4a58C8Qdru2CN/WxE6QsqCKIkgpAM0MfRQEznbQo=
X-Received: by 2002:a05:600c:5491:b0:480:1c2f:b003 with SMTP id 5b1f17b1804b1-48379bfd732mr370818655e9.20.1771589564983;
        Fri, 20 Feb 2026 04:12:44 -0800 (PST)
X-Received: by 2002:a05:600c:5491:b0:480:1c2f:b003 with SMTP id 5b1f17b1804b1-48379bfd732mr370818155e9.20.1771589564568;
        Fri, 20 Feb 2026 04:12:44 -0800 (PST)
Received: from rh (p200300f6af2d8700b4c2d356c3fafe63.dip0.t-ipconnect.de. [2003:f6:af2d:8700:b4c2:d356:c3fa:fe63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a316eb08sm77575655e9.0.2026.02.20.04.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Feb 2026 04:12:44 -0800 (PST)
Date: Fri, 20 Feb 2026 13:12:43 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Auger <eric.auger@redhat.com>, 
    qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
    kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 2/2] target/arm/kvm: add kvm-psci-version vcpu
 property
In-Reply-To: <CAFEAcA8V9bjQUzUYAW7qj5fEn_f9xaPJAYpTRgvdaFq0cY3pRA@mail.gmail.com>
Message-ID: <a4fffa2d-119a-cd78-44b6-b0c53d873833@redhat.com>
References: <20251202160853.22560-1-sebott@redhat.com> <20251202160853.22560-3-sebott@redhat.com> <CAFEAcA8oi1Xs2kv66dFV9NZore+Q2vHUsgMikveVdN1c+3SBJQ@mail.gmail.com> <9b04a20f-b708-208d-1e4e-466ec30b7bb9@redhat.com> <CAFEAcA-A+zW=QFdCY7z==+Z=xXfhJvPeyHhbG_MpEmpkQfrmaw@mail.gmail.com>
 <4e9470d5-ef3e-cf5c-4117-fb589d56323c@redhat.com> <CAFEAcA8V9bjQUzUYAW7qj5fEn_f9xaPJAYpTRgvdaFq0cY3pRA@mail.gmail.com>
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
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71407-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sebott@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9777216772C
X-Rspamd-Action: no action

On Mon, 16 Feb 2026, Peter Maydell wrote:
> On Wed, 11 Feb 2026 at 16:04, Sebastian Ott <sebott@redhat.com> wrote:
>>
>> On Wed, 11 Feb 2026, Peter Maydell wrote:
>>> On Wed, 11 Feb 2026 at 15:37, Sebastian Ott <sebott@redhat.com> wrote:
>>>>
>>>> On Fri, 6 Feb 2026, Peter Maydell wrote:
>>>>> On Tue, 2 Dec 2025 at 16:09, Sebastian Ott <sebott@redhat.com> wrote:
>>>
>>>>>> +static char *kvm_get_psci_version(Object *obj, Error **errp)
>>>>>> +{
>>>>>> +    ARMCPU *cpu = ARM_CPU(obj);
>>>>>> +    const struct psci_version *ver;
>>>>>> +
>>>>>> +    for (ver = psci_versions; ver->number != -1; ver++) {
>>>> [...]
>>>>>> +        if (ver->number == cpu->psci_version)
>>>>>> +            return g_strdup(ver->str);
>>>>>> +    }
>>>>>> +
>>>>>> +    return g_strdup_printf("Unknown PSCI-version: %x", cpu->psci_version);
>>>>>
>>>>> Is this ever possible?
>>>>
>>>> Hm, not sure actually - what if there's a new kernel/qemu implementing
>>>> psci version 1.4 and then you migrate to a qemu that doesn't know about
>>>> 1.4?
>>>
>>> Oh, I see -- we're reporting back cpu->psci_version here, which
>>> indeed could be the value set by KVM. I misread and assumed
>>> this was just reading back the field that the setter sets,
>>> which is kvm_prop_psci_version (and which I think will only
>>> be set via the setter and so isn't ever a value the setter
>>> doesn't know about).
>>>
>>> That does flag up a bug in this patch, though: if I set
>>> a QOM property via the setter function and then read its
>>> value via the getter function I ought to get back what
>>> I just wrote.
>>>
>>
>> Meaning this should be something like below?
>>
>> static char *kvm_get_psci_version(Object *obj, Error **errp)
>> {
>>      ARMCPU *cpu = ARM_CPU(obj);
>>
>>      return g_strdup_printf("%d.%d",
>>         (int) PSCI_VERSION_MAJOR(cpu->kvm_prop_psci_version),
>>         (int) PSCI_VERSION_MINOR(cpu->kvm_prop_psci_version));
>
> I guess we need to define what we want. Things we need:
>
> - user/QMP/etc setting a value and reading it back should
>   get back what they set
> - QEMU needs to keep working on a new kernel that defines a
>   new PSCI version in the future
> - user reading the default value and then writing it back
>   should succeed
>
> Things we might like:
> - ideally the setter would fail if the user picks a version
>   KVM can't support, but I don't think we can conveniently
>   determine this, so "fail vcpu init" may be as good as we
>   can get without unnecessarily large amounts of effort
>
> I think this probably adds up to:
> - setter should accept any a.b value (for a,b fitting in [0,65535])
> - getter can handle any value and turn it into a.b
> - make sure that setting it to an invalid value gives a helpful
>   error on vcpu start
>
> Doing it this way, do we need a separate cpu->kvm_prop_psci_version,
> or could we directly read and write cpu_>psci_version ?
>

Thanks for your suggestions! I've implemented them all and sent out a V6.

Sebastian



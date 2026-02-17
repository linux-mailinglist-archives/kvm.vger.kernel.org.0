Return-Path: <kvm+bounces-71143-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GVNlDrLTk2kI9AEAu9opvQ
	(envelope-from <kvm+bounces-71143-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 03:34:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 99726148816
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 03:34:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 40E763017261
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 02:34:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1844F23D7F5;
	Tue, 17 Feb 2026 02:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tour4Yee"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242D717A30A
	for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 02:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771295662; cv=none; b=Xaek3yeRxNblu3wOe2JePQIVfablQQX+fXyTOI1SaM5tw8hiqnfnBIIlwSA2kdSszVESSBQ8Aquqma1DAQak3Ko4yMiLNPJGyWa2rOoX23IrR6wUt1/bkWOn6T8RsYVQe75DxYH8oC4KhDcHUFDpbtPjubZEr1wVxH2W/8bWdXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771295662; c=relaxed/simple;
	bh=fR0pXU0J+oaz2qGssuJqKA427+EjQUevzaMYat/Abaw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JY5VyCcOawYQ4Zyv928Zf0QyryJsFmX9BntR/xKNKCmkd4Fi4SDvc7mJS6vyCfODZNnBDFzV+avb4oFfwdnrkTr1zHfu8Ff91y0JRPr7wsJTgX+/VB/DPimvnWYI+rzkoCArlnvqX3NrTnNT2lEli5K+VXlGg8Hanp2rn/wfTMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tour4Yee; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-824a829f9bbso1861648b3a.0
        for <kvm@vger.kernel.org>; Mon, 16 Feb 2026 18:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771295660; x=1771900460; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XmXY1QviZxB2hKo7UR8Y0OZQaQwvQtFEtllw98Jpok0=;
        b=tour4YeeAYktrDmSIjIDTojgwsPgrtWcNghf0q5WNHf4OkkvLRYzN6LQPsq/b5rAmV
         b+zdpC2cZmprVL0HpAo4bamfC6cDks3MFhctMGu2XexRm/9st/0y1DOIN8I6N62rGbmT
         p9jeBWym1ScWoeC0X1iLAsrHluSUKt3o8lH1OBdJtgbnfPr4NScyAx9z/u0caeAbogUb
         7IGtBqQoFBiIkFGwG6erHZ5d0MyWgogWVMu67ND9AyTuNEym9WK0/87lBXKjn9K+7Clc
         2o8/+5142dAV/8zuTbI6yuJFzBjamOtpFLUqQ666gVDZ5XTzz6MRnc7yKGwCBEQB3Jwy
         lp2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771295660; x=1771900460;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XmXY1QviZxB2hKo7UR8Y0OZQaQwvQtFEtllw98Jpok0=;
        b=g1ezTMd/1fWx+YJGew7SGQIhkdkCs1ujcmphDH8FACtorHVX2+75pwO7a71aEccg+Z
         pWmqu9GS/YKtZ7yV16/wwroJjacwPLdq1iAdFtEOezxxzBdn4baOJ6rz02qWlanSkH6G
         enMq5dftnmkulrGDzZddh2xQaA0ghAGhSikeolGcqubrGVWW1pGI2oqdGrCX0rlGRfMh
         xuWAq6/1lhO9EKtBN7h0Oga/B6pxVo+MwBWvQuXT6Fnc7D2g3/PKUN8fp916KOjNkQIS
         ZVwZ1xCTnS6t/XKCEs2M5jxqOdWOqNar0ieN49XMfRhEEnanv50uE5TtFv9Gp2cxMS6G
         4Izg==
X-Forwarded-Encrypted: i=1; AJvYcCW2KCycpMDEKbspryzZt+JF9n8RFXWGO2fX9q3DLhmEhd2bpc7MAp3EQyVntLl0jieN4xM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyxeB5N7WO7aSJ3cg1yjt7E16ikG9FPVl9XseCNDP8/1sABq+X
	Y9P9yp72YRa9Dz87/c7T8D2CESVau6u+uZ1gORqWMGSSQN6chT8Hzl/fr3+unOKS+RY=
X-Gm-Gg: AZuq6aIy4MfuAFcobr30FMBusl+Hx0S/nubZKFbrpcpoQGs39razht6dPp6JOeIHA/K
	bTFaRFtCHSSilW1qFSBdiFQ4NYaO1Ek1ronXPVpAVHJTrWfLiKSvKRkWsbNAB6Bhg04A4SZlPlg
	ZV84+m2t1Z4P6rxU0E1en9SRsYhjKaCT5zfJ1wGZ3ct3JKj36jc/If7iySVqVDwJ86ziKyFoxqK
	wHw5BE5zjbUm2wLYR740m0IsF0x7eyp7dmlgTuF4bX31F4TFjmjqz+LzLiwFRBE1f1my6cVbIEs
	4rWuowTBPa8B17rFUGrmokLFjzunNfKSLY9F03bRtYKKiZsKuzqUeZkUhwkeWm8VFPKIP4ED2MR
	7b2A9LdNIlSKPzJoCb1FzMDAm1gdIBTHMGBvMedt7hXv9PBmqUupnd3ji+cPlw8VpyPqpNgx/X8
	fo2IQGhn7N96WjhGbj3XDr9/ic454EbmLu5oIMuuHZEawC+3hmHPudut+FYpXCmrwDorjY
X-Received: by 2002:a05:6a00:3e0c:b0:81f:41c8:765a with SMTP id d2e1a72fcca58-824c945491cmr12355955b3a.4.1771295660218;
        Mon, 16 Feb 2026 18:34:20 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824c6a2e936sm11334871b3a.6.2026.02.16.18.34.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 18:34:19 -0800 (PST)
Message-ID: <ae364123-5b24-44cd-8330-9afde7e99ace@linaro.org>
Date: Mon, 16 Feb 2026 18:34:20 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/12] target/arm: single-binary
Content-Language: en-US
To: Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org, anjo@rev.ng,
 Jim MacArthur <jim.macarthur@linaro.org>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, qemu-arm@nongnu.org,
 Richard Henderson <richard.henderson@linaro.org>
References: <20260210201540.1405424-1-pierrick.bouvier@linaro.org>
 <93f8f250-7899-4528-b277-1ddd469c192c@linaro.org>
 <CAFEAcA9YUOxko51ziY3yAOaDfTCEAwqmXnifF=q_mkyotFHTcg@mail.gmail.com>
 <CAFEAcA8XCSjjb2opkf2A5WZwCa5THNswOOUO=fpj7kUJEc79qQ@mail.gmail.com>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Autocrypt: addr=pierrick.bouvier@linaro.org; keydata=
 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
 ZtfdHNZotF092MIH0IQC3poExQpV/WBYFAI=
In-Reply-To: <CAFEAcA8XCSjjb2opkf2A5WZwCa5THNswOOUO=fpj7kUJEc79qQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[linaro.org:+];
	TAGGED_FROM(0.00)[bounces-71143-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linaro.org:mid,linaro.org:dkim,linaro.org:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 99726148816
X-Rspamd-Action: no action

On 2/16/26 7:52 AM, Peter Maydell wrote:
> On Thu, 12 Feb 2026 at 10:59, Peter Maydell <peter.maydell@linaro.org> wrote:
>>
>> On Tue, 10 Feb 2026 at 20:19, Pierrick Bouvier
>> <pierrick.bouvier@linaro.org> wrote:
>>>
>>> On 2/10/26 12:15 PM, Pierrick Bouvier wrote:
>>>> This series continues cleaning target/arm, especially tcg folder.
>>>>
>>>> For now, it contains some cleanups in headers, and it splits helpers per
>>>> category, thus removing several usage of TARGET_AARCH64.
>>>> First version was simply splitting 32 vs 64-bit helpers, and Richard asked
>>>> to split per sub category.
>>>>
>>>> v3
>>>> --
>>>>
>>>> - translate.h: missing vaddr replacement
>>>> - move tcg_use_softmmu to tcg/tcg-internal.h to avoid duplicating compilation
>>>>     units between system and user builds.
>>>> - eradicate TARGET_INSN_START_EXTRA_WORDS by calling tcg_gen_insn_start with
>>>>     additional 0 parameters if needed.
>>>>
>>>> v2
>>>> --
>>>>
>>>> - add missing kvm_enabled() in arm-qmp-cmds.c
>>>> - didn't extract arm_wfi for tcg/psci.c. If that's a hard requirement, I can do
>>>>     it in next version.
>>>> - restricted scope of series to helper headers, so we can validate things one
>>>>     step at a time. Series will keep on growing once all patches are reviewed.
>>>> - translate.h: use vaddr where appropriate, as asked by Richard.
>>
>>> Patches 1-11 are reviewed and ready to be pulled.
>>
>> Looks like patch 12 has also now been reviewed, so I've applied
>> the whole series to target-arm.next.
> 
> I meant to send this to the list, but accidentally sent it to
> Pierrick only:
> 
> I just ran this (plus some other patches) through gitlab CI, and
> it fails to build on the kvm-only and xen-only jobs:
> 
> https://gitlab.com/pm215/qemu/-/jobs/13131658696
> 
> In file included from /builds/pm215/qemu/include/exec/helper-gen.h.inc:9,
>                   from /builds/pm215/qemu/include/exec/helper-gen-common.h:11,
>                   from ../target/arm/helper.h:7,
>                   from ../target/arm/helper.c:13:
> /builds/pm215/qemu/include/tcg/tcg.h:35:10: fatal error: tcg-target.h:
> No such file or directory
>     35 | #include "tcg-target.h"
>        |          ^~~~~~~~~~~~~~
> 
> 
> https://gitlab.com/pm215/qemu/-/jobs/13131658593
> 
> In file included from /builds/pm215/qemu/include/exec/helper-gen.h.inc:9,
>                   from /builds/pm215/qemu/include/exec/helper-gen-common.h:11,
>                   from ../target/arm/helper.h:7,
>                   from ../target/arm/debug_helper.c:11:
> /builds/pm215/qemu/include/tcg/tcg.h:35:10: fatal error: tcg-target.h:
> No such file or directory
>      35 | #include "tcg-target.h"
>         | ^~~~~~~~~~~~~~
> 
> I think the problem looks like it's in "move exec/helper-* plumbery to
> helper.h", which has put the "emit the TCG gen_helper_foo inline
> functions" into target/arm/helper.h, when they were previously
> handled by target/arm/tcg/translate.h and so only in source files
> that are part of the TCG translate-time code. helper.h only needs the
> prototypes of the helper functions themselves.
> 
> Some of the other new helper-foo.h files look like they would
> also have this problem, except they happen to only be included
> from tcg files. For instance target/arm/helper-mve.h is only
> included from files in target/arm/tcg (so it maybe could be
> in target/arm/tcg itself).
> 
> I couldn't see an obvious easy fixup for this, so I'm afraid
> I've removed the series from target-arm.next.
> 
> thanks
> -- PMM

Thanks for reporting Peter, and trying to fix it. It's definitely not
configurations I had under my radar.

Regards,
Pierrick


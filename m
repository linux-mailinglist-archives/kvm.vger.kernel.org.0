Return-Path: <kvm+bounces-839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5DE67E36CA
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 09:38:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 009551C20B9A
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 08:38:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BF1FB64C;
	Tue,  7 Nov 2023 08:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GEWQYkxR"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBD528F7
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 08:37:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6050718F
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 00:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699346270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rrf9M0yg1iFKGMAdaP8YMM5yDFIo4Qz87x7Angm1feY=;
	b=GEWQYkxRU/AsbKlqY4N3xwaF6btKAolZ8Do3G/fu1ZbugvZfUZ1j/W8fEw7CWoQ/2FQhb/
	wrL/IVFVqPQkagExr3n0zVhrBtc1DbyYPsNC4L4cZhdgcQ/XOAZ2VxOJj3wpRgGvMZfIY+
	7Ovtw2W0CQ4mV99+ojaP0fbi9nJK/Ss=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-C1xUiIyEMxmtrfGSn3l2Ew-1; Tue, 07 Nov 2023 03:37:49 -0500
X-MC-Unique: C1xUiIyEMxmtrfGSn3l2Ew-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-41cbb2970f4so58334191cf.2
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 00:37:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699346269; x=1699951069;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rrf9M0yg1iFKGMAdaP8YMM5yDFIo4Qz87x7Angm1feY=;
        b=dm/NFOrwI44i3KSt6cOziJ5WU2xIIDdLynkI6oekgYWMMa37C84TOxKu6B6eIxRRY6
         atfPEjGoTBeBQkHak0fWfNRlbPFXVLoIjqyTh1d3L5tQxfsMzrzMYoZxy1eFpAoiyDcV
         HXD9GeekmpwvkKCxhNmPZy7gZiRN1amnHRWAsYQaVc8Y7uprtcJRN3tUfdfyfkZNkjED
         jfHm+Dz2lhJZijBvBEub9f6JJb13XcLUQzar09IL8o/MWUKHBFb4+0GGAIaHKTPHwNZg
         lheQXuljJzM0hy0TYky3kZWw4wmRzGtL3vdjBuvRsRXhcxtDiHV0kfCmlT67Mdpy3X4u
         oX9w==
X-Gm-Message-State: AOJu0YwFpsiM9BV+cDlV2XmrVWSVHpxvanpiwDsPKUxzgVjqqVEZ75vJ
	QDv3A7F0ZyoDZiHll1W8BlmHqR9IwaB+3DEJhSnuHzd0Rn4/nDD46QRPG02OEs1JIJS9W6rGX0Y
	qf5mAevTqbegI95xACxrU
X-Received: by 2002:a05:622a:24b:b0:418:1365:9b4e with SMTP id c11-20020a05622a024b00b0041813659b4emr38594943qtx.20.1699346268726;
        Tue, 07 Nov 2023 00:37:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGj96uBnFkczY3xtB+XXEgGhNWzX6io7rIzu4SzpkseDfWVLha9iYywQdIUBiwc7nYLV7BhAw==
X-Received: by 2002:a05:622a:24b:b0:418:1365:9b4e with SMTP id c11-20020a05622a024b00b0041813659b4emr38594927qtx.20.1699346268388;
        Tue, 07 Nov 2023 00:37:48 -0800 (PST)
Received: from [192.168.0.6] (ip-109-43-179-224.web.vodafone.de. [109.43.179.224])
        by smtp.gmail.com with ESMTPSA id ew3-20020a05622a514300b0041520676966sm4148868qtb.47.2023.11.07.00.37.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Nov 2023 00:37:48 -0800 (PST)
Message-ID: <2fd73726-5696-4398-9c81-95b5c9fa6713@redhat.com>
Date: Tue, 7 Nov 2023 09:37:44 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v1 02/10] powerpc: properly format
 non-kernel-doc comments
Content-Language: en-US
To: Nico Boehr <nrb@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: frankja@linux.ibm.com, david@redhat.com, pbonzini@redhat.com,
 andrew.jones@linux.dev, lvivier@redhat.com, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org
References: <20231106125352.859992-1-nrb@linux.ibm.com>
 <20231106125352.859992-3-nrb@linux.ibm.com>
 <20231106175316.1f05d090@p-imbrenda>
 <169929081714.70850.5803437896270751208@t14-nrb>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <169929081714.70850.5803437896270751208@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06/11/2023 18.13, Nico Boehr wrote:
> Quoting Claudio Imbrenda (2023-11-06 17:53:16)
>> On Mon,  6 Nov 2023 13:50:58 +0100
>> Nico Boehr <nrb@linux.ibm.com> wrote:
>>
>>> These comments do not follow the kernel-doc style, hence they should not
>>> start with /**.
>>>
>>> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
>>> ---
>>>   powerpc/emulator.c    | 2 +-
>>>   powerpc/spapr_hcall.c | 6 +++---
>>>   powerpc/spapr_vpa.c   | 4 ++--
>>>   3 files changed, 6 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/powerpc/emulator.c b/powerpc/emulator.c
>>> index 65ae4b65e655..39dd59645368 100644
>>> --- a/powerpc/emulator.c
>>> +++ b/powerpc/emulator.c
>>> @@ -71,7 +71,7 @@ static void test_64bit(void)
>>>        report_prefix_pop();
>>>   }
>>>   
>>> -/**
>>> +/*
>>>    * Test 'Load String Word Immediate' instruction
>>>    */
>>
>> this should have the name of the function first:
>>   * test_lswi() - Test 'Load String ...
>>
>> (same for all the other functions here)
> 
> Since none of these comments really follow kerneldoc style and are mostly
> static anyways, the idea was to convert them to non-kerneldoc style, by
> changing the comment from:
> /**
> 
> to:
> /*
> 
> But I am just as fine to make the comments proper kerneldoc style, if we
> see value in that.

I think it makes sense to do that for the files in the lib/ folder ... for 
the other ones, I think it is not really necessary (but it wouldn't hurt 
either).

  Thomas



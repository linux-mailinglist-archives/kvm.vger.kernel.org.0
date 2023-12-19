Return-Path: <kvm+bounces-4826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B905818B3F
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 16:29:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C5EA01F23AA5
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 15:29:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 098611CF90;
	Tue, 19 Dec 2023 15:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eLIii52/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27DD1CF86
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 15:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702999772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oJLjshCrE3U3sivTkzx8GxEZrX/oIf3uM0FDP3SAPeA=;
	b=eLIii52/N4Y8lHvGgCF3fS7jAUi4q5gh3cF3Tb5VuBJ/X40IULkaTmkdkVcnU9qKHT9RnN
	XVssvA75M7R3EAM3I+nwTyaKpP1Dy+kkOe+ePYjniuLjFGdm3ZlevML8QcOx4rBmBiq9On
	0d6wydqXpKeKeuaTsU/oYvTkLxw4+xg=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-jsui375FMzOw9caMrQ7VTA-1; Tue, 19 Dec 2023 10:29:30 -0500
X-MC-Unique: jsui375FMzOw9caMrQ7VTA-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-67aa0c94343so91528826d6.1
        for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 07:29:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702999770; x=1703604570;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oJLjshCrE3U3sivTkzx8GxEZrX/oIf3uM0FDP3SAPeA=;
        b=bnb2MKtMGDW8mCS3BI5GT1mUvsoqmJgAjGyko7saeYezdRkQQOraT5cfi0Xzh5aClk
         M2P8//uaH3c1ZE0IQyTezTUBhgQmzSM8XWGEsEvQQe7CIZ1Rj4R3JJS4dUpnEOCO8+2O
         yYcouDhJYwlTn+/6tvaVaSrOTIzRczwT2Ousmb/Lic23uQX6ndGR+HvEl2xvMASFYFVB
         2/3TK42becnIgdHm1XHUKyePpTZC2NmPTP9KKB9ztxtMEWjAU0vZeX1xa3AkF17NYuaw
         Qjx8lTJpfT8BjDTDTs00s+o5WwlnF9A8H+7gu369OlldVEk2Jj9iGyNaajDYV5wZN2ys
         s6ZQ==
X-Gm-Message-State: AOJu0Yyp5RxIYwyqA7vGJjjffRbM7lmnbPXt5wQrweB7omBudxVIJ0gl
	nZBll9Xn8wR/ySXddALMzAAWW3NPCEPqIcIzbYaUe6kUNrx/tmfoEH9Pe54CcDP3TtTtMmKul4G
	mxCg/JKK/aGvPkeE7YQm1
X-Received: by 2002:a05:622a:648:b0:423:9a04:a37 with SMTP id a8-20020a05622a064800b004239a040a37mr1988298qtb.16.1702999769892;
        Tue, 19 Dec 2023 07:29:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHsG1k0LPXcbLdxS6t1Vz9BPdsuwaXfBHtV/iZbnV866p1upJqNvXeDN7/pqhj8Dci3jmiuRA==
X-Received: by 2002:a05:622a:648:b0:423:9a04:a37 with SMTP id a8-20020a05622a064800b004239a040a37mr1988285qtb.16.1702999769664;
        Tue, 19 Dec 2023 07:29:29 -0800 (PST)
Received: from [192.168.0.6] (ip-109-43-177-45.web.vodafone.de. [109.43.177.45])
        by smtp.gmail.com with ESMTPSA id ey6-20020a05622a4c0600b00427692bc384sm1323895qtb.66.2023.12.19.07.29.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Dec 2023 07:29:29 -0800 (PST)
Message-ID: <1d6ab266-ae6f-4f48-a6b0-ac05e53c3768@redhat.com>
Date: Tue, 19 Dec 2023 16:29:26 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH] scripts/pretty_print_stacks.py: Silence
 warning from Python 3.12
Content-Language: en-US
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>, kvm@vger.kernel.org
Cc: Andrew Jones <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
References: <20231219132313.31107-1-thuth@redhat.com>
 <36675f5872ce8343b9909f3e3445e34339cb5e60.camel@linux.ibm.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <36675f5872ce8343b9909f3e3445e34339cb5e60.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 19/12/2023 15.52, Nina Schoetterl-Glausch wrote:
> On Tue, 2023-12-19 at 14:23 +0100, Thomas Huth wrote:
>> Python 3.12 complains:
>>
>>   ./scripts/pretty_print_stacks.py:41: SyntaxWarning:
>>    invalid escape sequence '\?'
>>    m = re.match(b'(.*) at (.*):(([0-9]+)|\?)([^:]*)', line)
>>
>> Switch to a raw string to silence the problem.
>>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>   scripts/pretty_print_stacks.py | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/scripts/pretty_print_stacks.py b/scripts/pretty_print_stacks.py
>> index d990d300..5bce84fc 100755
>> --- a/scripts/pretty_print_stacks.py
>> +++ b/scripts/pretty_print_stacks.py
>> @@ -38,7 +38,7 @@ def pretty_print_stack(binary, line):
>>           return
>>   
>>       for line in out.splitlines():
>> -        m = re.match(b'(.*) at (.*):(([0-9]+)|\?)([^:]*)', line)
>> +        m = re.match(r'(.*) at (.*):(([0-9]+)|\?)([^:]*)', line)
> 
> Did you test this? Should this not be rb'<regex>'?
> I get
> TypeError: cannot use a string pattern on a bytes-like object

Drat, of course I only tested it in the sense that I made sure that the 
python warning goes away when running the run_test.sh script, but I did not 
trigger a backtrace ...

You're right of course, it has to be rb'...' here instead. I'll send a v2.

  Thomas



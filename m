Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D58204E53
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 11:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732214AbgFWJpz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 05:45:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24044 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732023AbgFWJpx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 05:45:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592905552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v1cUq5GB5w5hvGz3iK20MqeK6w3F8BO4HrRD4p54MN0=;
        b=UDrlwMs0pvaYUVyphwUtT/3DHoOa/vlYo47+gGfUTrBQFgE3OHDM1n8U2yv99unciuDF5C
        6ctM4ANsLPr2siL6h6e8LnLcAluvlntMOg3EF9JWUxkPVGX6DhOQqlb6Io4RWT9HuJ0X3L
        AOSnmpVaisBpPAiQkdPylY5jWCazwJo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-Z57Z_YDjMkaMrQEMKEtAdA-1; Tue, 23 Jun 2020 05:45:50 -0400
X-MC-Unique: Z57Z_YDjMkaMrQEMKEtAdA-1
Received: by mail-wr1-f69.google.com with SMTP id a6so8339116wrq.3
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 02:45:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v1cUq5GB5w5hvGz3iK20MqeK6w3F8BO4HrRD4p54MN0=;
        b=GAxsjbY0MOl3hQOJ9RkYkxxrMw97zMf/MxUf8D+NfdGRzZO0ifzUA9fNpxEadz13Eu
         kbRUCu0iyRNKbfcxcIxZBsZeSsrmiWQ/raiI0yx8KalqDAHwoy8D5DDe+mYsOwwqGm/i
         1bsXYlkb+Sh0YGiDt4w1myPpYshPFT3n4vpjsk4kO++ONyI8Aqzy9Pw3sj4MZ4M5qwF7
         LpbE7Uyg8RLql2AVV7MX+NGrM2qvfeSYa7vbp6MF/V6KAF4x/BwwYloJ+LcObHXfDTG2
         tIDlIijdm4lt/dpgYAHyz8tQuK+Qj+FmVmx6CaMRwhfB28RGoAUbLUgvXeSXUXy8PcI8
         Mi9A==
X-Gm-Message-State: AOAM533Wfa31e7137dnS0aIVGj4r8Xym1EAVXvR0oRR3v6UEN3ub8qh1
        6WPaaEUkZ3GDIL0eOLkBsWZeOb8raSTObbRwO3E1aQ46hUF8VcT0S+rZN4+2FHYuY5bg1gm3vNy
        pN9/ImamCzBWM
X-Received: by 2002:a5d:40ca:: with SMTP id b10mr17266082wrq.56.1592905548932;
        Tue, 23 Jun 2020 02:45:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsrlyLy+pRLKO4rzU5LOxIFwgYdSshjfPxIaM8gsctZkUKqFcNk3nbdx0Yzf70fDzDZRCqcg==
X-Received: by 2002:a5d:40ca:: with SMTP id b10mr17266019wrq.56.1592905548137;
        Tue, 23 Jun 2020 02:45:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:24f5:23b:4085:b879? ([2001:b07:6468:f312:24f5:23b:4085:b879])
        by smtp.gmail.com with ESMTPSA id u20sm1751230wmm.15.2020.06.23.02.45.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 02:45:47 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] x86: disable SSE on 32-bit hosts
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
References: <20200616140217.104362-1-pbonzini@redhat.com>
 <84a04af0-ea52-31a5-eb9f-d29fc5d7df51@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <aad6855e-2721-35e9-3bda-0183b59964c8@redhat.com>
Date:   Tue, 23 Jun 2020 11:45:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <84a04af0-ea52-31a5-eb9f-d29fc5d7df51@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/06/20 17:17, Thomas Huth wrote:
> On 16/06/2020 16.02, Paolo Bonzini wrote:
>> On 64-bit hosts we are disabling SSE and SSE2.  Depending on the
>> compiler however it may use movq instructions for 64-bit transfers
>> even when targeting 32-bit processors; when CR4.OSFXSR is not set,
>> this results in an undefined opcode exception, so tell the compiler
>> to avoid those instructions on 32-bit hosts as well.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>  x86/Makefile.i386 | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/x86/Makefile.i386 b/x86/Makefile.i386
>> index d801b80..be9d6bc 100644
>> --- a/x86/Makefile.i386
>> +++ b/x86/Makefile.i386
>> @@ -1,6 +1,7 @@
>>  cstart.o = $(TEST_DIR)/cstart.o
>>  bits = 32
>>  ldarch = elf32-i386
>> +COMMON_CFLAGS += -mno-sse -mno-sse2
> 
> That's likely a good idea, but it still does not fix the problem in the
> gitlab-ci:
> 
>  https://gitlab.com/huth/kvm-unit-tests/-/jobs/597747782#L1934

Hmm, it does fix everything here.  How does one go debugging what's
happening in the CI?

Paolo


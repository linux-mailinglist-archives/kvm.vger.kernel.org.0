Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C3741979B
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 17:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235073AbhI0PVD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 11:21:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23512 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234972AbhI0PVB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Sep 2021 11:21:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632755963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wXxx/mWjZvI5CKydBAcRP5EsO0jhBZkFq3UTyMZjQpw=;
        b=E6PEBn7fqk11WaU6W/XATZ/tpFGs6GoNlCN8e8dTjXIVjeh7ElEWwL8dCt1k/wYpD4xx29
        YWGjw+lxdZ9DBvS9zzlSu7MO/88hK/OmQmxVyu19e0nsvsf5Gb7peZ50ICTs4aGH4d3ha8
        QVBVr7zROauJXnw1SqlzGXCmeWv3uiA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296--PARD0yFOx2Ai3ksJdWAPA-1; Mon, 27 Sep 2021 11:19:21 -0400
X-MC-Unique: -PARD0yFOx2Ai3ksJdWAPA-1
Received: by mail-wm1-f72.google.com with SMTP id 5-20020a1c00050000b02902e67111d9f0so376846wma.4
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 08:19:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wXxx/mWjZvI5CKydBAcRP5EsO0jhBZkFq3UTyMZjQpw=;
        b=yhPfxyA6ZzDqY0tVMCWJjhhYJOi3bO69UdOmhBpVN1SvyaAbKqJEkype6hBX3WERZ0
         oq9mfid+AiEDoIIoZzvujUwXa4m+shSCofYU0PyoyGMBGawvkPwHbttSjhvL1HixLI0B
         gA8aGMB1PFOMJJH79n7EYHQ4Qdhp8yNr6v1U+yhtRkum8Ii8UGscGUFbSdClqm76f2ts
         s5tw/lEuUGnQnSl5l9whoecsPbdPM5Bj2in8SvPEF2DcBSu4S28UfNumm+S31at71OfY
         HeCFnkJ4NO3LCNPhSQ4du0MrHP57XDe8QwXCzd7rZ6wCL6j8KLUM18FDNPk1vGOH9YJ1
         DZXQ==
X-Gm-Message-State: AOAM5315wsXzWc+58/3nwRpqurC0hcqY9zsO4jGGC2t6CP6wxKA1bDfM
        Czkm2zY24f7ZhxpkXhkHMbkaKYG1IYSS9JOVvnp9khe/tfvO41fFV9H+8QKFP/ILWPQKntG6VPY
        4qn7IPcJwq8vP
X-Received: by 2002:a05:600c:4293:: with SMTP id v19mr5948341wmc.113.1632755960788;
        Mon, 27 Sep 2021 08:19:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzklb4Y9OgrluZRSquXFubQOTHk8hh4uL420+KWG6nBseRr7rAuICcnZhxEuK691gegSgWdhw==
X-Received: by 2002:a05:600c:4293:: with SMTP id v19mr5948326wmc.113.1632755960608;
        Mon, 27 Sep 2021 08:19:20 -0700 (PDT)
Received: from thuth.remote.csb (p549bb2bd.dip0.t-ipconnect.de. [84.155.178.189])
        by smtp.gmail.com with ESMTPSA id g143sm21051419wme.16.2021.09.27.08.19.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 08:19:20 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 1/9] s390x: uv: Tolerate 0x100 query return
 code
To:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, linux-s390@vger.kernel.org,
        seiden@linux.ibm.com
References: <20210922071811.1913-1-frankja@linux.ibm.com>
 <20210922071811.1913-2-frankja@linux.ibm.com>
 <20210922111256.04febb7e@p-imbrenda>
 <75c8d08e-3b93-c001-cc84-5f77aaee5248@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <7f1dba57-59b2-81de-1ea5-691b8de71a98@redhat.com>
Date:   Mon, 27 Sep 2021 17:19:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <75c8d08e-3b93-c001-cc84-5f77aaee5248@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/2021 13.36, Janosch Frank wrote:
> On 9/22/21 11:12 AM, Claudio Imbrenda wrote:
>> On Wed, 22 Sep 2021 07:18:03 +0000
>> Janosch Frank <frankja@linux.ibm.com> wrote:
>>
>>> RC 0x100 is not an error but a notice that we could have gotten more
>>> data from the Ultravisor if we had asked for it. So let's tolerate
>>> them in our tests.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
>>>   s390x/uv-guest.c | 4 ++--
>>>   s390x/uv-host.c  | 2 +-
>>>   2 files changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
>>> index f05ae4c3..e7446e03 100644
>>> --- a/s390x/uv-guest.c
>>> +++ b/s390x/uv-guest.c
>>> @@ -70,8 +70,8 @@ static void test_query(void)
>>>   	report(cc == 1 && uvcb.header.rc == UVC_RC_INV_LEN, "length");
>>>   
>>>   	uvcb.header.len = sizeof(uvcb);
>>> -	cc = uv_call(0, (u64)&uvcb);
>>> -	report(cc == 0 && uvcb.header.rc == UVC_RC_EXECUTED, "successful query");
>>> +	uv_call(0, (u64)&uvcb);
>>> +	report(uvcb.header.rc == UVC_RC_EXECUTED || uvcb.header.rc
>>> == 0x100, "successful query");
>>
>> if you want to be even more pedantic:
>> 	report(cc == 0 && uvcb.header.rc == UVC_RC_EXECUTED ||
>> 		cc == 1 && uvcb.header.rc == 0x100, ...
> 
> Yeah I pondered about that but at the end I chose to drop the cc check

Well, but we're in the kvm-unit-tests here where we check for the exact 
behavior of the system ... so I'd vote for keeping/extening the cc checking, 
even if it's more code to read in the end.

  Thomas


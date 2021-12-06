Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80EF84690A9
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 08:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238382AbhLFHPr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 02:15:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39292 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238367AbhLFHPr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Dec 2021 02:15:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638774738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s80mS0oS6VA8hHFmNGuRkp6f0ywSZXv8mbp9txN0j8M=;
        b=XwU5Wx5GzVKc6Tq8NltREYnfuzYEqPy2q2okGGB8OL0EvLdr7xXEWPQP5ji6rS6wX3lXfj
        DHlnDAnbTJ0qxU4S3JuCVKmRmv8trqIYYwA7IWO5W5+U2lG0Gtyl0z4SHnWoftsofdiqw1
        9qqPwpUGVox03qMtXRkzOhQzP7hFkmI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-542-NwpJsSj0PgKP52CvjfhtWA-1; Mon, 06 Dec 2021 02:12:17 -0500
X-MC-Unique: NwpJsSj0PgKP52CvjfhtWA-1
Received: by mail-wm1-f70.google.com with SMTP id 69-20020a1c0148000000b0033214e5b021so5664612wmb.3
        for <kvm@vger.kernel.org>; Sun, 05 Dec 2021 23:12:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=s80mS0oS6VA8hHFmNGuRkp6f0ywSZXv8mbp9txN0j8M=;
        b=QqStGao20ITl/zzjANHh9ZuinrE+WpH70jfbXWbqvXGsAfLed9wsS8nGjfxJ+eyrKu
         Li9ML2u0m5s20beEZLEKbJR4mC48XtOplHem94ZBgcvTUNLwtTNus1r3+pqUt8pN2G7e
         ff32eKHxlyqVFTlnLDWiV2oMsxYFrpJ/BT5E/Lfh/1r0CULBU6Mn+yzUUSKw8TzcFADo
         BwkC/GUtcMENh2jhiAuKejSW7gU6MF4uRLrn25dmnCJLviGtB7Ala2Lq9CJCKfY1sRh/
         jPOCN1w8tgxHtVCqTWRaZiCDK9DQVwyxbG4/XKpCF0VWUcqBknb3OFV5WUqz5pcFrhZg
         j9tQ==
X-Gm-Message-State: AOAM532Vtqh3Uasu/8+Z9ysoJxz/qi4/HFWDaLruCbtLs7H9Y4JmkLCr
        wDCnp/Pvc8o3bGjw9UPRQYFSnLIruAw9xkpZLqa8UOQJPoS0kNXkgLSQIUHegXIleA3R+1JT6fT
        6T6TF5hgaFfVs
X-Received: by 2002:a05:600c:1083:: with SMTP id e3mr36133110wmd.167.1638774735935;
        Sun, 05 Dec 2021 23:12:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwmgj5d1pHUsIBWklPylwjGlJ3R+iMEI+cUrriNE82Ux1hGbXdVPcGawwYcCauy2yVUmATaaA==
X-Received: by 2002:a05:600c:1083:: with SMTP id e3mr36133090wmd.167.1638774735719;
        Sun, 05 Dec 2021 23:12:15 -0800 (PST)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id b11sm12363197wmj.35.2021.12.05.23.12.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Dec 2021 23:12:15 -0800 (PST)
Message-ID: <babd1100-844b-e00c-3e5b-30f7bca65636@redhat.com>
Date:   Mon, 6 Dec 2021 08:12:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sebastian Mitterle <smitterl@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org
References: <20211202123553.96412-1-david@redhat.com>
 <20211202123553.96412-3-david@redhat.com>
 <11f0ff2f-2bae-0f1b-753f-b0e9dc24b345@redhat.com>
 <20211203121819.145696b0@p-imbrenda>
 <fa95d6e6-27be-7abf-7b1e-bb6bb9d62214@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/2] s390x: firq: floating interrupt
 test
In-Reply-To: <fa95d6e6-27be-7abf-7b1e-bb6bb9d62214@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/12/2021 19.23, David Hildenbrand wrote:
> 
>>>> +	if (smp_query_num_cpus() < 3) {
>>>> +		report_skip("need at least 3 CPUs for this test");
>>>> +		goto out;
>>>> +	}
>>>> +
>>>> +	if (stap()) {
>>>> +		report_skip("need to start on CPU #0");
>>>> +		goto out;
>>>> +	}
>>>
>>> I think I'd rather turn this into an assert() instead ... no strong opinion
>>> about it, though.
>>
>> I agree, including the part about no strong opinions (which is why I
>> did not comment on it before)
> 
> Would it be the case on any system we might end up running, even under
> LPAR ... and whoever could run these tests ?

Well, ok, since it likely doesn't happen in real life anyway, simply keep 
the report_skip().

>>
>>>
>>>> +
>>>> +	/*
>>>> +	 * We want CPU #2 to be stopped. This should be the case at this
>>>> +	 * point, however, we want to sense if it even exists as well.
>>>> +	 */
>>>> +	ret = smp_cpu_stop(2);
>>>> +	if (ret) {
>>>> +		report_skip("CPU #2 not found");
>>>
>>> Since you already queried for the availablity of at least 3 CPUs above, I
>>> think you could turn this into a report_fail() instead?
>>
>> either that or an assert, but again, no strong opinions
>>
> 
> Just because there are >= 3 CPUs doesn't imply that CPU #2 is around.

Ok, fair point. But if #2 is not around, it means that the test has been run 
in the wrong way by the user... I wonder what's better in that case - to 
skip this test or to go out with a bang. Skipping the test has the advantage 
of looking a little bit more "polite", but it has the disadvantage that it 
might get lost in automation, e.g. if somebody enabled the test in their CI, 
but did something wrong in the settings, they might not notice that the test 
is not run at all...

> What we could remove is the "if (smp_query_num_cpus() < 3) {" check, though!

Yes, that seems to be redundant, indeed.

  Thomas


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2338619ACA9
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 15:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732603AbgDANXJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 09:23:09 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28772 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732557AbgDANXJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Apr 2020 09:23:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585747387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oTquWraz7XWs5ih6+UEe0ar6i1xbS28rKJSUAjhnxVM=;
        b=fl8yVuRfNit78y61GecBhrXDVT/B6xer7GtfITVQIcYqGmBcl7KY+FntvTI9t1LDNq5GO/
        DBpgeIiFwbL3puExv2kZj/auZgSVTD0fgO/2yMbexowZwuJkL9doOEUQuoffSJYT+We6CP
        B7DD6bgJAHrTk/KCwaFQ5eS6QoAvtCM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-dbF55adaM1qU7u-iv-XwmA-1; Wed, 01 Apr 2020 09:23:05 -0400
X-MC-Unique: dbF55adaM1qU7u-iv-XwmA-1
Received: by mail-wr1-f69.google.com with SMTP id m15so14627495wrb.0
        for <kvm@vger.kernel.org>; Wed, 01 Apr 2020 06:23:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oTquWraz7XWs5ih6+UEe0ar6i1xbS28rKJSUAjhnxVM=;
        b=OVwtkzW6NJRpDKZBABnDmfmcMX8iVd1wZJv2EZEi6eTwSSVO8F/Atd5xHrBtXFm3iW
         SQPez0h0SjZhz4zdcZn3abktSJ693jE62rjvRNx0L6WQlooIKZnQ1sc/qCe+mr6WFlAQ
         EsXdZ7TAVWtJbig0csnDT2oWjKi0ZUK3UhL0LY8YYJzvxCgUC3UmxpjTQdJp85Zyyu8U
         eQcBFG5SqanCzQ8JMHuOfwitsI+uHyIwE54RqnvAXMogVtJygYKf6OCsR4lmpYhPz3nv
         nEaQCUU1QLAbHUTPDmLv/1niTpCMGYWkeVXgdSFiVdQpYWW4RNgRJy9wfMhZQzlf0pwN
         JmCg==
X-Gm-Message-State: ANhLgQ22tPi8NNeupPWTFuZFS0SK4PpGUcI7JpNOmzb2Vbl2WbCeYtf5
        nbn8d8mmwM6KM3YkSm8sQ3tqjuV8TPdObH33NxEi92v0CJ/9X1Z9T3zDav1QrAb85OD5zksTqLP
        NTRKAzf4CbsnU
X-Received: by 2002:a05:6000:11c6:: with SMTP id i6mr27154528wrx.115.1585747384038;
        Wed, 01 Apr 2020 06:23:04 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vt3/+cqY0Z3hSZ6JnnNK38dywOSkRykjqQS/PB9Cl5jtmzocxM2/vHNX3g9RN5LSAr7hLvHiw==
X-Received: by 2002:a05:6000:11c6:: with SMTP id i6mr27154509wrx.115.1585747383813;
        Wed, 01 Apr 2020 06:23:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3dd0:bddb:3deb:b557? ([2001:b07:6468:f312:3dd0:bddb:3deb:b557])
        by smtp.gmail.com with ESMTPSA id 189sm2650787wme.31.2020.04.01.06.23.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2020 06:23:03 -0700 (PDT)
Subject: Re: [PATCH 1/3] tools/kvm_stat: add command line switch '-z' to skip
 zero records
To:     Stefan Raspl <raspl@linux.ibm.com>, kvm@vger.kernel.org
References: <20200331200042.2026-1-raspl@linux.ibm.com>
 <20200331200042.2026-2-raspl@linux.ibm.com>
 <6edd0cda-993b-3565-8781-d2da786766a2@redhat.com>
 <648fea4a-ec81-2090-33b8-f1af25c5491f@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e0624575-9f5c-8c14-6003-23f1e1cd42f2@redhat.com>
Date:   Wed, 1 Apr 2020 15:23:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <648fea4a-ec81-2090-33b8-f1af25c5491f@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/04/20 10:19, Stefan Raspl wrote:
> On 2020-03-31 23:45, Paolo Bonzini wrote:
>> On 31/03/20 22:00, Stefan Raspl wrote:
>>> @@ -1523,14 +1535,20 @@ def log(stats, opts, frmt, keys):
>>>      """Prints statistics as reiterating key block, multiple value blocks."""
>>>      line = 0
>>>      banner_repeat = 20
>>> +    banner_printed = False
>>> +
>>>      while True:
>>>          try:
>>>              time.sleep(opts.set_delay)
>>> -            if line % banner_repeat == 0:
>>> +            if line % banner_repeat == 0 and not banner_printed:
>>>                  print(frmt.get_banner())
>>> -            print(datetime.now().strftime("%Y-%m-%d %H:%M:%S") +
>>> -                  frmt.get_statline(keys, stats.get()))
>>> +                banner_printed = True
>>
>> Can't skip_zero_records be handled here instead?
>>
>>     values = stats.get()
>>     if not opts.skip_zero_records or \
>>         any((values[k].delta != 0 for k in keys):
>>        statline = frmt.get_statline(keys, values)
>>        print(datetime.now().strftime("%Y-%m-%d %H:%M:%S") + statline)
> 
> I wanted to avoid such an extra check for performance reasons. Granted, I have
> to do something likewise (i.e. checking for non-zero values) in my patch for csv
> records, but at least for the standard format things are a bit less costly
> (avoiding an extra pass over the data).

I don't think it's a perceivable difference, and it simplifies the code
noticeably.

Paolo


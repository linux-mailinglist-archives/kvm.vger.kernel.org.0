Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C1B271470
	for <lists+kvm@lfdr.de>; Sun, 20 Sep 2020 15:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgITNQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Sep 2020 09:16:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31384 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726380AbgITNQV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Sep 2020 09:16:21 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Sep 2020 09:16:20 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600607780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2V15ZxenVAjPKeDIDqr8ZmFP4OT+OuHu0OvG5XzUocc=;
        b=PKXhxT2M3Z5NtSwCB7VamA8fA9g71AT0pMutgFvPOGhKUe8MDZHaADE6iKbJx7os+hnoFI
        tSdR5u8ZcOwMF1MQUVNu1nsgDjEZsFxdsRbwC9O2ZzltDSDVaRy/0GCqp1liQ05p4LlgIb
        RVXlw7BceLDo+1hBYsEanRY5aWvOBvM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-by1IJmrXN8yqDXwjU2Cf5w-1; Sun, 20 Sep 2020 09:16:18 -0400
X-MC-Unique: by1IJmrXN8yqDXwjU2Cf5w-1
Received: by mail-wr1-f70.google.com with SMTP id s8so4572225wrb.15
        for <kvm@vger.kernel.org>; Sun, 20 Sep 2020 06:16:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2V15ZxenVAjPKeDIDqr8ZmFP4OT+OuHu0OvG5XzUocc=;
        b=G86FfvQRssMJ/iben52qzKfIqw9AYtJp4j3bRPzeep9BfeKXOkVywCQ2+Zq/5slfT5
         mQ4jgxKZHGOipS/TyHBz5XqG4P0ojCYFcWbvSY8M2Q8uQMQCZGvqJGeLl5vCJPHuRU5b
         faDihUr5+EulRtAQ1TWjknBy3XAnV5hDBbm7TmMCH0UMqniuA2e2ZfvfOsQeomsSl3YG
         jFON/cSMzSJ9CMcv93Pn8QN9q6N/0uY1eOWaDMhKNXzPD62Ltr/Yuv7h8W/vv0WAn7PI
         UI5lEdqBw4k9qXudHrUdSZCrZ/ZYZ13c38IgaSgYPQqPw8M9BiDpQXBrDTlyZv7WPiwW
         wHYA==
X-Gm-Message-State: AOAM532VhWOcBp+okOT0+RKOPEyOvFqPYMJNyOfcRwaRQFLLFsoVuIrN
        PIURnERkGd51elGIU8YoiFiLSjMhQz22aj58CLb8MnjqUGdY0lgeChRmMyi2bCYdAcQaceZJNwR
        WgAJHZgaPYqTh
X-Received: by 2002:adf:fd01:: with SMTP id e1mr44636090wrr.44.1600607776769;
        Sun, 20 Sep 2020 06:16:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGGTEHw/0rbsJt+G5fIJCQ6uEXtHxv2bG0np9KdCndDi4JTg2CnriFtDQLR39C+C5bSERRtQ==
X-Received: by 2002:adf:fd01:: with SMTP id e1mr44636079wrr.44.1600607776602;
        Sun, 20 Sep 2020 06:16:16 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:458b:b280:cf0:4acf? ([2001:b07:6468:f312:458b:b280:cf0:4acf])
        by smtp.gmail.com with ESMTPSA id y1sm14589029wmi.36.2020.09.20.06.16.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Sep 2020 06:16:16 -0700 (PDT)
Subject: Re: [kvm-unit-tests GIT PULL 0/3] s390x skrf and ultravisor patches
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.vnet.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
References: <20200901091823.14477-1-frankja@linux.ibm.com>
 <34c80837-208f-bb29-cb0b-b9029fdad29d@redhat.com>
 <71b38000-70ee-f45a-b80d-95f42dbcc497@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0c48075c-a922-6155-ff59-8ffa100cd209@redhat.com>
Date:   Sun, 20 Sep 2020 15:16:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <71b38000-70ee-f45a-b80d-95f42dbcc497@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/09/20 18:24, Thomas Huth wrote:
> On 02/09/2020 19.41, Paolo Bonzini wrote:
>> On 01/09/20 11:18, Janosch Frank wrote:
>>>   git@gitlab.com:frankja/kvm-unit-tests.git tags/s390x-2020-01-09
>>
>> Pulled, thanks.
>>
>> (Yes, I am alive).
> 
>  Hi Paolo,
> 
> I don't see the patches in the master branch - could you please push
> them to the repo?

Oops, pulling had failed because Janosch used an ssh reference to the
repo.  Fixed and pushed.

Paolo


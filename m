Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEBF936C966
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 18:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238762AbhD0Q0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 12:26:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26705 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238832AbhD0QZz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Apr 2021 12:25:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619540711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gzuRZqb1juDTzGpDl1vUojCFy5dVyv3daxCpY+ZKJow=;
        b=euHQsBGUdzDWsFKA/iC/n/zbu0NUc0GOVI28eHE4fHI4WD9EXiJhui+TEtSIdykLc1aZ64
        VoqGvtmrTEfAIEYm5NiSUhCDxEWQpqjnPBSV5nbL16GhgFnbt+jCXLmQO//LqSCoRuXbTM
        X6Jyq1dd69AmgaarHwW+4+F8gVQSofE=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-566-7uED6_IOPrmeF-WMAusjlQ-1; Tue, 27 Apr 2021 12:25:09 -0400
X-MC-Unique: 7uED6_IOPrmeF-WMAusjlQ-1
Received: by mail-ej1-f70.google.com with SMTP id x21-20020a1709064bd5b029037c44cb861cso11413634ejv.4
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 09:25:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gzuRZqb1juDTzGpDl1vUojCFy5dVyv3daxCpY+ZKJow=;
        b=if4Wc4IgJZfiKr7maT88+TJ4TsXZQ3a5/jOGtczBFFlrrIr6w378Hwf0kIPdpGpqQ/
         opt+aTjU8IMvGj/uzLHiR4MVXNxwqgzzHaRx15ZzfgJL/AxOnwHsdrM/HoGvPQ6X5GBZ
         Q+wuG4ix11Ugw3IDNlont0sxNUngYZZA3O21hxoUNPxZHRw1Ag9IPwgyjj3pajUKh1VL
         ZSdBDOU1TfMoHO4KNaaHs3Xwpl6dgCAFg+GMXNjF5+iGXsDFJ8JKDxs0OrFIrLUNnPTF
         Ifb81d550XLKrcsKHRcnCIbtpQP3EPhdpanF/ydOpM7PSmQikLY/aH7v/kacmds7ICj6
         SUKw==
X-Gm-Message-State: AOAM532KRCx2GxUO5VXorzvzmr/cs10cNDV54ElSXqYGwkEpFhY+aYvi
        uAEOnbR425rQtv/oJZZ1Hp3sQ8sFcHEwOjuI5zm1ygoaf6nN/Adw4M+iibu+Jx8xAbZDwbQN6o9
        jwjZFMNkyTxcp
X-Received: by 2002:a05:6402:154a:: with SMTP id p10mr5475732edx.77.1619540708026;
        Tue, 27 Apr 2021 09:25:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJysNB3W4iZSXLyIKvQJzMdITFkM0kuW9B8xw3PvbGsDiw/uSjWbytZ8Y6cnUIn/EEm7QRciwQ==
X-Received: by 2002:a05:6402:154a:: with SMTP id p10mr5475716edx.77.1619540707885;
        Tue, 27 Apr 2021 09:25:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id w13sm2603427edc.81.2021.04.27.09.25.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Apr 2021 09:25:07 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v1 1/1] MAINTAINERS: s390x: add myself as
 reviewer
To:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, cohuck@redhat.com, david@redhat.com
References: <20210427121608.157783-1-imbrenda@linux.ibm.com>
 <79941660-77f8-e243-80b4-be5754f5bafb@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <217a23a5-53c4-d76f-a9bc-6ad44a77327e@redhat.com>
Date:   Tue, 27 Apr 2021 18:25:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <79941660-77f8-e243-80b4-be5754f5bafb@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/04/21 15:18, Janosch Frank wrote:
> On 4/27/21 2:16 PM, Claudio Imbrenda wrote:
>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> ---
>>   MAINTAINERS | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index e2505985..aaa404cf 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -85,6 +85,7 @@ M: Thomas Huth <thuth@redhat.com>
>>   M: David Hildenbrand <david@redhat.com>
>>   M: Janosch Frank <frankja@linux.ibm.com>
>>   R: Cornelia Huck <cohuck@redhat.com>
>> +R: Claudio Imbrenda <imbrenda@linux.ibm.com>
> 
> Currently we are very limited by review, so I appreciate more
> reviewers/reviews very much.
> 
>>   L: kvm@vger.kernel.org
>>   L: linux-s390@vger.kernel.org
>>   F: s390x/*
> 
> @Paolo: Do you want to pick this or should I put it in my next pull request?
> 

Pick it up yourself, it's your turf. :)


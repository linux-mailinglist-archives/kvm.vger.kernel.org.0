Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D483BBA6C
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 11:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbhGEJoj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 05:44:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37649 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230000AbhGEJoi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Jul 2021 05:44:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625478121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HNV9OaYdnxR15a4jV7psRkuzfog3J+Wb9pPXNeHN/OU=;
        b=Ytintvrw+mGXY+nM3M1jd/udsBh857x2LI7Oa7ays/8WdJFIGEdPS+/y2Qj5aTbx5hezvj
        bRXonZD8PofK9Ei9tQ5LlgWQly0rN9oeOj4a2gqQKViZOcI/6rSYHz+4CUym/0WVDa4GlC
        WIMDM8xkpEY3Shp92SwFlgzr+aou5+c=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-8JPT-l5UOQKz6rSgUSodRQ-1; Mon, 05 Jul 2021 05:42:00 -0400
X-MC-Unique: 8JPT-l5UOQKz6rSgUSodRQ-1
Received: by mail-wr1-f69.google.com with SMTP id w4-20020a05600018c4b0290134e4f784e8so877284wrq.10
        for <kvm@vger.kernel.org>; Mon, 05 Jul 2021 02:42:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HNV9OaYdnxR15a4jV7psRkuzfog3J+Wb9pPXNeHN/OU=;
        b=AbLxcnh11O5Jb3zlsWrEMxt3f449q3siUiCH4UOUhg6x2VLXsWVutX1z3wlXSaoLvM
         VPqC95EHwZXbrgzpuqeHchy7Vg48NfUDcTX/Yr2mf/9kVW7MzgjeyCIVoPqi56yU9WdO
         AGIO4lBnW6O/ETqQRpgWrKqlBRCR8IM2WuIY+ipzjw1vDYauswLHluGTZxCFg4VAX1C0
         0hsKmOFvAhCXOkCMn/lDlSMf4Tb8NJ3/s4VDVn/LYRvviN92lDEt1DuhMmih9Gd5hBQ9
         ZnB85TeCrwQkYE2JNMctuiMzkES0cyHjHt8BKOr9meq0nMA4bf+818UfiYS6Imi63a94
         IAyQ==
X-Gm-Message-State: AOAM530U66/SS8m/JJ0Ec9jThJT6wG4z2Obu+U9nKxAqJUpk9ztURE6J
        RpcIBrTPsA0C3fj6PUp/zkDnMXC3rUdp2LZdRfA9byi9ZX/ewW4mIDRoT76KyZBH2L5niy9SLzD
        UkgBvByzMM4Dv
X-Received: by 2002:a5d:59ac:: with SMTP id p12mr14401732wrr.372.1625478119420;
        Mon, 05 Jul 2021 02:41:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwROn59GNG7B7qUvOnlsTSj0bjCriNcmIjYmQhXrt9GtxEi3rru9PFkq9tYjW1KOwe9du/eQg==
X-Received: by 2002:a5d:59ac:: with SMTP id p12mr14401716wrr.372.1625478119214;
        Mon, 05 Jul 2021 02:41:59 -0700 (PDT)
Received: from thuth.remote.csb (pd9575e1e.dip0.t-ipconnect.de. [217.87.94.30])
        by smtp.gmail.com with ESMTPSA id b20sm12203150wmj.7.2021.07.05.02.41.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jul 2021 02:41:58 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 3/5] lib: s390x: uv: Int type cleanup
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <20210629133322.19193-1-frankja@linux.ibm.com>
 <20210629133322.19193-4-frankja@linux.ibm.com>
 <d2798bf7-3018-e311-1dfb-120144fb343d@redhat.com>
 <3876955c-24bd-2052-e634-8436f7558df4@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <b06633be-3832-7a07-37c3-1beaecd2202a@redhat.com>
Date:   Mon, 5 Jul 2021 11:41:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <3876955c-24bd-2052-e634-8436f7558df4@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/07/2021 11.33, Janosch Frank wrote:
> On 7/4/21 9:51 AM, Thomas Huth wrote:
>> On 29/06/2021 15.33, Janosch Frank wrote:
>>> These structs have largely been copied from the kernel so they still
>>> have the old uint short types which we want to avoid in favor of the
>>> uint*_t ones.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
>>>    lib/s390x/asm/uv.h | 142 +++++++++++++++++++++++----------------------
>>>    1 file changed, 72 insertions(+), 70 deletions(-)
>>>
>>> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
>>> index dc3e02d..96a2a7e 100644
>>> --- a/lib/s390x/asm/uv.h
>>> +++ b/lib/s390x/asm/uv.h
>>> @@ -12,6 +12,8 @@
>>>    #ifndef _ASMS390X_UV_H_
>>>    #define _ASMS390X_UV_H_
>>>    
>>> +#include <stdint.h>
>>> +
>>>    #define UVC_RC_EXECUTED		0x0001
>>>    #define UVC_RC_INV_CMD		0x0002
>>>    #define UVC_RC_INV_STATE	0x0003
>>> @@ -68,73 +70,73 @@ enum uv_cmds_inst {
>>>    };
>>>    
>>>    struct uv_cb_header {
>>> -	u16 len;
>>> -	u16 cmd;	/* Command Code */
>>> -	u16 rc;		/* Response Code */
>>> -	u16 rrc;	/* Return Reason Code */
>>> +	uint16_t len;
>>> +	uint16_t cmd;	/* Command Code */
>>> +	uint16_t rc;	/* Response Code */
>>> +	uint16_t rrc;	/* Return Reason Code */
>>>    } __attribute__((packed))  __attribute__((aligned(8)));
>>
>> Hmm, for files that are more or less a copy from the corresponding kernel
>> header, I'm not sure whether it makes sense to convert them to the stdint.h
>> types? It might be better to keep the kernel types so that updates to this
>> header can be ported more easily to the kvm-unit-tests later?
> 
> sie.h contents are 90% sblk which came directly from KVM...
> Do you really want to have exceptions for one file? Because if that's
> the case then I see no sense in changing other things over since I
> prefer using short types.

Completely inaccurate checks with the lib directory of the kvm-unit-tests:

$ grep -r u64 lib/ | wc -l
234
$ grep -r uint64 lib/ | wc -l
245

$ grep -r u8 lib/ | wc -l
137
$ grep -r uint8 lib/ | wc -l
193

... I guess that's an indication that we do not really have a prevailing 
style here?
I personally prefer the stdint.h types, I'm just not sure whether it makes 
sense to keep some headers close to the kernel or not...?

  Thomas


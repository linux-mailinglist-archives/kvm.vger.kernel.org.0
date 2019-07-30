Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB5FF7B32B
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 21:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388270AbfG3TWU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 15:22:20 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52921 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387766AbfG3TWT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 15:22:19 -0400
Received: by mail-wm1-f65.google.com with SMTP id s3so58225917wms.2
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 12:22:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LoxzZqL4rhHsJTxBksx+F5wXjx24fSM9vNw+iyy4BQU=;
        b=pMJXiNVnjtl2lc2ItaIlvPgiZBxydF2nvqpolPN362YWkry2yezslpQ/Hbiuf39hJG
         5GqsCFvxxuZJoClorESngvK4dg7phRI0431kWbyckOJawFMq1KpKgE+3ZMP6Osp2RoaN
         QKfmUvvvivty0uO/4JY2Y2LhpVBURwWbjenSL0dysAmsSuf/+5wkIf8urqlqjSu36oZk
         rg9KS4cxt5XuyxX+zmzduL6Iuc6cjHIaxeKv5gmdwWEArFiXP3WCazG2ZWotkWXlHfrz
         oRMa9BCli95P7qkfW4S6AOMk5EIEA5UlnaLaL3rguRKYFcVAZp9OpmO31fTdZjGZM+US
         jm3A==
X-Gm-Message-State: APjAAAVdb+fLtXbz5bVkygkdo89ijjP7Zf/I4fCYKrdJbKQB9zTWDSMN
        G2YGT5+YuHDfjfrOKg0wlgxTkA==
X-Google-Smtp-Source: APXvYqyFy1aLUMyEsySGDUGajP8VOabfhm2ghFvA90w3+/SyneqYZnpsW4CjvlPmMn33cc5PtNCNRg==
X-Received: by 2002:a1c:6643:: with SMTP id a64mr109438149wmc.154.1564514537202;
        Tue, 30 Jul 2019 12:22:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:29d3:6123:6d5f:2c04? ([2001:b07:6468:f312:29d3:6123:6d5f:2c04])
        by smtp.gmail.com with ESMTPSA id 5sm53607581wmg.42.2019.07.30.12.22.16
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 12:22:16 -0700 (PDT)
Subject: Re: [Qemu-devel] [PATCH 3/3] i386/kvm: initialize struct at full
 before ioctl call
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>,
        qemu-devel@nongnu.org, qemu-block@nongnu.org
Cc:     vsementsov@virtuozzo.com, berto@igalia.com, ehabkost@redhat.com,
        kvm@vger.kernel.org, mtosatti@redhat.com,
        mdroth@linux.vnet.ibm.com, armbru@redhat.com, den@openvz.org,
        rth@twiddle.net
References: <1564502498-805893-1-git-send-email-andrey.shinkevich@virtuozzo.com>
 <1564502498-805893-4-git-send-email-andrey.shinkevich@virtuozzo.com>
 <7a78ef04-4120-20d9-d5f4-6572c5676344@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b876f6e4-5469-ae03-2a8d-d433ec35d735@redhat.com>
Date:   Tue, 30 Jul 2019 21:22:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <7a78ef04-4120-20d9-d5f4-6572c5676344@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/07/19 18:44, Philippe Mathieu-Daudé wrote:
>> +++ b/target/i386/kvm.c
>> @@ -190,6 +190,7 @@ static int kvm_get_tsc(CPUState *cs)
>>          return 0;
>>      }
>>  
>> +    memset(&msr_data, 0, sizeof(msr_data));
> I wonder the overhead of this one...
> 

There is just one MSR in the struct so it is okay.

Paolo

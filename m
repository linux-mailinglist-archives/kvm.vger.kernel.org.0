Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 319EF10565D
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 17:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfKUQCt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 11:02:49 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27429 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727020AbfKUQCs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Nov 2019 11:02:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574352167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=rcqdeTgChHnCDo5l36uHf88TY7b96FHBlN+sSTw6btQ=;
        b=BmVtjoxIr5/kEVcZAGQEG9/n33t+2C5KAAe3WQ1Moe8EfYTCkq3Ub9NVIDH3X8gQlxJQac
        egxxbRY8mkJ8Xy8lHJWl3S2dsAHraHWq/iBzaYLsPieamtDQJcH52QP6FOqMP6kQDQ0S6X
        l0CNvcmuW3wPynZrxYChEVQsejv7Gbo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-BdEIowUaNEStgCkaAQSFQQ-1; Thu, 21 Nov 2019 11:02:45 -0500
Received: by mail-wr1-f70.google.com with SMTP id h7so2351646wrb.2
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2019 08:02:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qM2tyh78ojNvdG7Z8M8T/3nGHyd1QQztV+4YABQwg58=;
        b=XrjbxAwDa+LRjRjJX4Mgzf5KGoKJPl6U9tL3jr8+kWdsK02OOdOakavhNz+eNQti8B
         /0LEK3zyJZe9GyFWaWur8jtDssfw3UmO0akraEIoaxSq2RMY5uWkJKouzvMef+WaMVFt
         ztH9UjxyQVmEnMgDnMIb8AU9i0CVRe7JM6AfLGVhjCUKQIWRkct8tO7EY6xBgLrKQ/0Y
         22DLS//FnN+38cmVd6pFrX/T5rBTkiL0oA2fRG1OPUW+zzdh8xnZFKht+tEHNNk75DR2
         ZAjbtrcDBP6nmce30tWK9+ik7l65WpTv+EHeYGsfBuxZWRu2nbnp9r1/55wm5u3ziI/e
         nrMg==
X-Gm-Message-State: APjAAAV5wEVHhZas8nQbJC8uYt3ks1OuHJE07wYBJ67iIZBt+C789Xam
        TW5UKJ5deXvJdVLD6yrRknmqu4sU2Od6xuCqTuJApCviWC9scNIoPRB8M7GSIBW99ovSAZgwE6J
        L5jJogRU0a69O
X-Received: by 2002:a1c:6641:: with SMTP id a62mr10623030wmc.54.1574352164372;
        Thu, 21 Nov 2019 08:02:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqz/tD9hcxHhcQWoHQpZcdfK2t0X0v9XjAW7cHY4kYJ0mn+rkqwZ9CmqXq9Xn2xNMJAol/s4ww==
X-Received: by 2002:a1c:6641:: with SMTP id a62mr10623001wmc.54.1574352164065;
        Thu, 21 Nov 2019 08:02:44 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:71a5:6e:f854:d744? ([2001:b07:6468:f312:71a5:6e:f854:d744])
        by smtp.gmail.com with ESMTPSA id x5sm94545wmj.7.2019.11.21.08.02.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 08:02:43 -0800 (PST)
Subject: Re: [PATCH v7 2/9] vmx: spp: Add control flags for Sub-Page
 Protection(SPP)
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jmattson@google.com, sean.j.christopherson@intel.com,
        yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com
References: <20191119084949.15471-1-weijiang.yang@intel.com>
 <20191119084949.15471-3-weijiang.yang@intel.com>
 <d6e71e7b-b708-211c-24b7-8ffe03a52842@redhat.com>
 <20191121153442.GH17169@local-michael-cet-test>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <58b4b445-bd47-d357-9fdd-118043624215@redhat.com>
Date:   Thu, 21 Nov 2019 17:02:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191121153442.GH17169@local-michael-cet-test>
Content-Language: en-US
X-MC-Unique: BdEIowUaNEStgCkaAQSFQQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/11/19 16:34, Yang Weijiang wrote:
> On Thu, Nov 21, 2019 at 11:04:51AM +0100, Paolo Bonzini wrote:
>> On 19/11/19 09:49, Yang Weijiang wrote:
>>> @@ -228,6 +228,7 @@
>>>  #define X86_FEATURE_FLEXPRIORITY=09( 8*32+ 2) /* Intel FlexPriority */
>>>  #define X86_FEATURE_EPT=09=09=09( 8*32+ 3) /* Intel Extended Page Tabl=
e */
>>>  #define X86_FEATURE_VPID=09=09( 8*32+ 4) /* Intel Virtual Processor ID=
 */
>>> +#define X86_FEATURE_SPP=09=09=09( 8*32+ 5) /* Intel EPT-based Sub-Page=
 Write Protection */
>>
>> Please do not include X86_FEATURE_SPP.  In general I don't like the VMX
>> features word, but apart from that SPP is not a feature that affects all
>> VMs in the same way as EPT or FlexPriority.
>>
> So what's a friendly way to let a user check if SPP feature is there?

QEMU for example ships with a program called vmxcap (though it requires
root).  We also could write a program to analyze the KVM capabilities
and print them, and put it in tools/kvm.

Thanks,

Paolo


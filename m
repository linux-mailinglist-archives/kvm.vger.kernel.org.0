Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1A45168444
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 17:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgBUQ6P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 11:58:15 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54880 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726387AbgBUQ6P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Feb 2020 11:58:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582304293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p7XbHrCaOSwrBpqaeeYKNxlSBdnjl6OZnbi6u5hXQjU=;
        b=MgaXNeX0Qo5hX5JZPimfM2HGg7pgCGGs0JXRPXXEgr0Qs3bNXCiYyMKvQWp1S2ooRMbNDH
        rr+vtz9rW7YqpuOLvdDwBK27k3wvs5ULWWeb/f8YM1ZPw7UH47/XB7QyOnprbmgPirTV9A
        J7jE538+V/DOLCiUc168q8P18bAAfLM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-i4raXlyMOcyn8daQobvsTQ-1; Fri, 21 Feb 2020 11:58:07 -0500
X-MC-Unique: i4raXlyMOcyn8daQobvsTQ-1
Received: by mail-wm1-f69.google.com with SMTP id m4so822745wmi.5
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 08:58:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p7XbHrCaOSwrBpqaeeYKNxlSBdnjl6OZnbi6u5hXQjU=;
        b=igF+SoKn61Bt5CtIQC3IHsZi/k4JSZ0h1O1elj+jOMd+nEoB6nFN3nZB7bK1bF6lvh
         F/vC6W7x2qwbjX8oui0Ql4FdXVbNdYwCpGpFijoZk5lnf3Il9A3jD1ukj++if829IRuE
         6AvOvoD2WQcaOCfdy8CfzkUMc9YR/hUuoUVyOBCxDx5+QaEjKDhbjLEfdpUDOlk2YEw6
         /9XhKtkU2hcG3NGIxM7WkRgx2Jx6to9H5rUVu+6RGnbXs9Lj2ik7HoB804ZU4ZUz9sTj
         +MUISldCGtFKiukqnVdaS2toWRL+AjCCB7RzTcyX7zEz8QX9a7tt6qpkprFFkIN0Arne
         wZlQ==
X-Gm-Message-State: APjAAAXp6KLlYcMuf3U9uDnKgNmW0xjLlK5N3R+iVhm+L8nLccfxifvl
        pOGy7QMG2OaBk1h0yE+rQIVAA/shrsXq7RqNSNrCMzscZ9MM3NcWMc/p/+PRu2v+dfxyTOJknYV
        wEk0nIVKvUBCa
X-Received: by 2002:a1c:6a16:: with SMTP id f22mr4689105wmc.53.1582304286616;
        Fri, 21 Feb 2020 08:58:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqzx8SYVdFspf+9GbrjK1CHBzdPkEu/p7HgFD9HSQD4u8DmNh/L0Ceyu9qjuA96m3QzgfpFyXA==
X-Received: by 2002:a1c:6a16:: with SMTP id f22mr4689097wmc.53.1582304286341;
        Fri, 21 Feb 2020 08:58:06 -0800 (PST)
Received: from [192.168.178.40] ([151.20.135.128])
        by smtp.gmail.com with ESMTPSA id h205sm4700577wmf.25.2020.02.21.08.58.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 08:58:05 -0800 (PST)
Subject: Re: [PATCH][resend] KVM: fix error handling in svm_cpu_init
To:     linmiaohe <linmiaohe@huawei.com>,
        "Li,Rongqing" <lirongqing@baidu.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
References: <b7a41c2ec0e644119180ba61d10ab4b9@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e77238c5-94a6-0695-b49a-6ce6f4ccab70@redhat.com>
Date:   Fri, 21 Feb 2020 17:58:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <b7a41c2ec0e644119180ba61d10ab4b9@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/02/20 09:40, linmiaohe wrote:
> Li,Rongqing <lirongqing@baidu.com> writes:
>>> Hi,
>>> Li RongQing <lirongqing@baidu.com> writes:
>>>>
>>>> sd->save_area should be freed in error path
>>> Oh, it's strange. This is already fixed in my previous patch : [PATCH v2] KVM:
>>> SVM: Fix potential memory leak in svm_cpu_init().
>>> And Vitaly and Liran gave me Reviewed-by tags and Paolo queued it one 
>>> month ago. But I can't found it in master or queue branch. There might 
>>> be something wrong. :(
>>
>> In fact, I send this patch 2019/02/, and get Reviewed-by,  but did not queue
>>
>> https://patchwork.kernel.org/patch/10853973/
>>
>> and resend it 2019/07
>>
>> https://patchwork.kernel.org/patch/11032081/
>>
> 
> Oh, it's really a pit. And in this case, we can get rid of the var r as '-ENOMEM' is actually the only possible outcome here, as
> suggested by Vitaly, which looks like this: https://lkml.org/lkml/2020/1/15/933

I queued your patch again, sorry to both of you.

Paolo


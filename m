Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048201C4061
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 18:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729675AbgEDQpF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 12:45:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34320 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729395AbgEDQpF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 12:45:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588610704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RgNAr5ePUPXCOlMMjdyI2n+4U4LTYkHptNR+Gklm4AM=;
        b=AatNBJXydi8JWILzosIZevKnNkG6U/1gNsuNCqgFjfUrnGagQgT85idy/k8/sNTtoL4/9y
        X/4qTYjE5Hr+pZP9q8aRdQspLbt6FsEEYO2YqnarAWa5cPNfkAVWa3BnbbaKD5n72f6aG2
        ODsNo8gVTj0BXC/OfWjftDc7S/WMFps=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-1K44en0YOZmZ7OysCzBQlw-1; Mon, 04 May 2020 12:44:59 -0400
X-MC-Unique: 1K44en0YOZmZ7OysCzBQlw-1
Received: by mail-wm1-f71.google.com with SMTP id s12so89272wmj.6
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 09:44:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RgNAr5ePUPXCOlMMjdyI2n+4U4LTYkHptNR+Gklm4AM=;
        b=IVpDZ5HDg61YZChGGMhSY62bf/B4zamRtS5yh6AARpRgb/tffj0U8SFnuJn8RUBefM
         eekp6Z7NWO8ChlrmwYWZjAUE3ADwZ8I8wp2vk5jV3TxDb6/yqR5p6wr/rgRgdapWw8pb
         zIlhnOT45IHKAb75uHC8HRH061BLgNtKjW20PLVzPq8dh8k4Mxb8Kt/KTQFCGbdzY5lR
         f4fO2++roRX7UxupCGg4HzqhguaIx58URjuErdEZOeqiHmLdR8ZAzgQF4avrDiL16CQc
         rWPA4dp0eIgaDJgHh/wjrYIUpaTaVuk/qa7bKE9iRLqC4SzxTjlQYD7pxlIkaHtq6kkN
         QEGg==
X-Gm-Message-State: AGi0PuanwOWAuNKlQ4WzLDwA5YdhBRKioC1J2VjJNgpMsctEPS9A9UlG
        CMUDhvIAvcuHYTAC9kzzV1N0gd4BxYsZhgJceDVr9w2lwkXJR1QO1IojSnoFx1Jos33TmAxtQ9N
        +f2J6ih1660/J
X-Received: by 2002:a05:600c:225a:: with SMTP id a26mr15643696wmm.104.1588610698590;
        Mon, 04 May 2020 09:44:58 -0700 (PDT)
X-Google-Smtp-Source: APiQypKAceuiic+rg2tWFVV1HrVcmieBoZp9SufVEvQbCPNh1/dooxyE98gmWg3zzUAgW98Do+zfDg==
X-Received: by 2002:a05:600c:225a:: with SMTP id a26mr15643675wmm.104.1588610698405;
        Mon, 04 May 2020 09:44:58 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id y11sm18766137wrh.59.2020.05.04.09.44.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 09:44:57 -0700 (PDT)
Subject: Re: [kvm-unit-tests PULL 00/17] s390x updates
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
References: <20200430152430.40349-1-david@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7ff41e72-06e7-efc1-9e74-3709340c1135@redhat.com>
Date:   Mon, 4 May 2020 18:44:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200430152430.40349-1-david@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/04/20 17:24, David Hildenbrand wrote:
>   https://github.com/davidhildenbrand/kvm-unit-tests.git tags/s390x-2020-04-30

Pulled, thanks.

Paolo


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0D61EA04A
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 10:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbgFAIq5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 04:46:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40040 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725876AbgFAIqz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 04:46:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591001213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C02MG+QK6H+u53KSuGOiYPyl9UBkarcNf8ZS3cPl7w4=;
        b=RWh5V5jk+SU5cHqn4+YpKHLj3EeSt57WryhDPptDAWnu3upca3RhbL69R6pDEPKoJnBQni
        oC5NEvEtz4lB5/JdQDtC9vlMtKHi9yrnBtGFQF6AswMA+jaJzk5Sfo+9BbhNnMBdlQ/RzL
        iNM53y02qu9ptSdQCyup6cqbdwvzghU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-HRwqnNc1PjilK6vfiAfsvw-1; Mon, 01 Jun 2020 04:46:50 -0400
X-MC-Unique: HRwqnNc1PjilK6vfiAfsvw-1
Received: by mail-wr1-f72.google.com with SMTP id w16so4598562wru.18
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 01:46:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C02MG+QK6H+u53KSuGOiYPyl9UBkarcNf8ZS3cPl7w4=;
        b=mjSzf7UhqVkuZ6nAHq0VmsIS6x2hDeVVqffNXE4r2RjD5kRazK6WHke6TP4UInTCV0
         0HNx35rvbKjxbMEPlPBX6DPy5Ag5sFHwRBNc3uDNLVJirIg/lywM/NjC13b9FdbC5cqf
         uUtXJKh2v3qNckx4Y+fh+U/M5qmZAwgRF5SQkIaJfO5HZ6XOekiUTzUSdnjOGGJdwThg
         fnj2y3c8q4Thf1xlsIcYEFy4xD3UGppF5o5aJzd9cbyN/KCaoyrzzCCEGjwV+Nb/7Kls
         Ey0MGQrz9rAZx856XX0Fl7qnGwCIr3h2VKN1BLstr8W2+oU7SX7TX5M74FETjWQwNp3r
         kcyA==
X-Gm-Message-State: AOAM533jcnFjOmgolvvLmWbUwtcuyIwl9St0UE2gAROBU36pn+pDUrL9
        2GMRFTjDfEhpsJd+65epSqEcXMpfg6aNuHpCd8YUgXpr3s6RfbgvPEyGrbdXN7QEnLkaP5Vq3Zf
        as/6HetOBin/a
X-Received: by 2002:a5d:6305:: with SMTP id i5mr13517769wru.268.1591001209376;
        Mon, 01 Jun 2020 01:46:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyEYY8mkL9Gi6Wprd77cQqEWyWHRjuAU8MMixFROUGrmjIE9m2xWDMlSexm+nSaLiFIQTBeWg==
X-Received: by 2002:a5d:6305:: with SMTP id i5mr13517755wru.268.1591001209199;
        Mon, 01 Jun 2020 01:46:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e044:3d2:1991:920c? ([2001:b07:6468:f312:e044:3d2:1991:920c])
        by smtp.gmail.com with ESMTPSA id q1sm10003248wmc.12.2020.06.01.01.46.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 01:46:48 -0700 (PDT)
Subject: Re: [PATCH] KVM: Use previously computed array_size()
To:     Denis Efremov <efremov@linux.com>, Joe Perches <joe@perches.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200530143558.321449-1-efremov@linux.com>
 <0c00d96c46d34d69f5f459baebf3c89a507730fc.camel@perches.com>
 <6088fa0f-668a-f221-515b-413ca8c0c363@linux.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cbf8741e-ede4-af17-309c-666b52883b17@redhat.com>
Date:   Mon, 1 Jun 2020 10:46:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <6088fa0f-668a-f221-515b-413ca8c0c363@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/05/20 19:28, Denis Efremov wrote:
>> On Sat, 2020-05-30 at 17:35 +0300, Denis Efremov wrote:
>>> array_size() is used in alloc calls to compute the allocation
>>> size. Next, "raw" multiplication is used to compute the size
>>> for copy_from_user(). The patch removes duplicated computation
>>> by saving the size in a var. No security concerns, just a small
>>> optimization.
>>>
>>> Signed-off-by: Denis Efremov <efremov@linux.com>
>> Perhaps use vmemdup_user?
> vmemdup_user() uses kvmalloc internally. I think it will also require
> changing vfree to kvfree.
> 

Yes, it would be a good idea.

Paolo


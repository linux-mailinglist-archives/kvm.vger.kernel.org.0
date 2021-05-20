Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D124438B421
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 18:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233834AbhETQUI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 12:20:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37142 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233311AbhETQUH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 May 2021 12:20:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621527524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6OgNPYxA7i+etU7xLj3nrXr95skp7dY81DNzdhoz9rg=;
        b=Zd7iM2bp3fIdSnGaXw77Io0Dlrm8JtyXR+xTj4Xg7hOWpM6GxYqPIXRQOn7ysOuo1SZ6sn
        F091bBOdEmlFWxPhdxxFW8zjj8YLx8WLEp6w1HxEXRztuL6sV2pBsxUlcDWxG4YkVeazPy
        pHWVSia7BnmLzUZwMcWLCwNlx4Mq7IY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-ooHWfan1MhapKc5txBClwA-1; Thu, 20 May 2021 12:18:43 -0400
X-MC-Unique: ooHWfan1MhapKc5txBClwA-1
Received: by mail-wr1-f70.google.com with SMTP id u5-20020adf9e050000b029010df603f280so8764626wre.18
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 09:18:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6OgNPYxA7i+etU7xLj3nrXr95skp7dY81DNzdhoz9rg=;
        b=f4OnEq1F8JKjxKRkrZkOaMX+H1s8z7q5LEh75uUxBXoEf8TIZVlwlQ5jJmycV/p9k3
         a2bmdnZ5kMNTlCy33jsC9XksBV/ZXhwRX3TpnV0RKgHe2obM50eHweIODUquA+YzgXjA
         rVz8Ex6/dH9tM+tAxHqWFcFaWFDYLwHATJEyBqY6BfqXYYfFsiM5OL3nj9ojiZverRm/
         PtDH0yOAphk6Hl7TC6oqlV1ny082JKmu+Yr6sqKSsoezizUoo6la+b3zxd0iHN66ZRl/
         KjWTJ+06i9riXi5FRkIclGYJyUtq6ziKps4wUtZ5/k1vOB7WSzGKM2sNlxKTATudr7NV
         9LmQ==
X-Gm-Message-State: AOAM533IcTnlAJtzaKVECimkyuEIxJ6ZfmESoI7f/jCWswZISlNUzLbd
        RJTCl3oeLw6NV3anRs0qoV2FFf5dWz02m1ts/kaUxcTeU1tB8BvKmxleRMRIWLxiaVBXCA+QDdH
        boacOyI0/253c
X-Received: by 2002:a5d:59a4:: with SMTP id p4mr5320585wrr.248.1621527522005;
        Thu, 20 May 2021 09:18:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyHdHvZnHkFtg16t/tFIWUALZddO72xh0A6mKZ4eMSItEm7NWMHJO7CM8CAVLCm09/8wvuHlw==
X-Received: by 2002:a5d:59a4:: with SMTP id p4mr5320562wrr.248.1621527521813;
        Thu, 20 May 2021 09:18:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b8sm3978942wrx.15.2021.05.20.09.18.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 09:18:40 -0700 (PDT)
Subject: Re: [PATCH] Move VMEnter and VMExit tracepoints closer to the actual
 event
To:     Sean Christopherson <seanjc@google.com>,
        Stefano De Venuto <stefano.devenuto99@gmail.com>
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, rostedt@goodmis.org,
        y.karadz@gmail.com, Dario Faggioli <dfaggioli@suse.com>
References: <20210519182303.2790-1-stefano.devenuto99@gmail.com>
 <YKaBEn6oUXaVAb0K@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ab44e5b1-4448-d6c8-6cda-5e41866f69f1@redhat.com>
Date:   Thu, 20 May 2021 18:18:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YKaBEn6oUXaVAb0K@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/21 17:32, Sean Christopherson wrote:
> On VMX, I think the tracepoint can be moved below the VMWRITEs without much
> contention (though doing so is likely a nop), but moving it below
> kvm_load_guest_xsave_state() requires a bit more discussion.

Indeed; as a rule of thumb, the tracepoint on SVM could match the 
clgi/stgi region, and on VMX it could be placed in a similar location.

Paolo

> I 100% agree that the current behavior can be a bit confusing, but I wonder if
> we'd be better off "solving" that problem through documentation.


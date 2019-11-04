Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E88BEEB9B
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 22:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387430AbfKDVt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 16:49:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52760 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387416AbfKDVt2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 16:49:28 -0500
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5BA6659455
        for <kvm@vger.kernel.org>; Mon,  4 Nov 2019 21:49:28 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id f2so6678210wmf.8
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2019 13:49:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W1pvkDm/bRbn3kdRoJ6Q6xczs+3XdUKsiWuExVkhMuM=;
        b=swm/3ij845d7mBL2tRV154S4Ez9l8qa2Pn77hi002vEMaMjaWxBRpRxeAIKtYnEcDB
         2sS4cw8kNFcwRIDuAuonSgE+nf1f/3h5fg31kRHgfj4yfW8KmPcflLy3nQfLueV7Dkp2
         5rgBt/qOxIYVJjYcQBi9thirvZZyECgfZST99iwJ4w7GffDxBVeLzjNKKP1tvImuHTmX
         6LPK1f8idmfBUDqI13p0gQgCjJpcoFbloymTXGiBtx0vd9/LHsHDMGvvNF059vugN2ST
         gAyjlN6iaiRJ+0SEttv2T5a+Y0wYrUxU3iIoO6OpzPLm81bTbWwO8UC9yi5BNLo9gs0t
         6fcA==
X-Gm-Message-State: APjAAAVvEobEi8Iw+rjCuW/vE7P3kT/j9KY51ENmRteI3lDTJG3HJkDn
        wvuQjeIwM/kN2TKHunWmSH8Ugaze7vVdIbfq5Se8L9nvg5g+kbWDnL8AGgSN0bB74H4UTOCQ2D1
        Ye1nCVZPqPiHy
X-Received: by 2002:a05:6000:14a:: with SMTP id r10mr24262366wrx.310.1572904166933;
        Mon, 04 Nov 2019 13:49:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqxr5lZKbDC827foBtsWDyIPHBvd/JG3405gPU7PHIv2F6m5M4w1exAgx8KkInvk6L+S8M3/3A==
X-Received: by 2002:a05:6000:14a:: with SMTP id r10mr24262343wrx.310.1572904166588;
        Mon, 04 Nov 2019 13:49:26 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:4051:461:136e:3f74? ([2001:b07:6468:f312:4051:461:136e:3f74])
        by smtp.gmail.com with ESMTPSA id p15sm15682395wmb.10.2019.11.04.13.49.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 13:49:26 -0800 (PST)
Subject: Re: [PATCH v4 13/17] kvm: i8254: Deactivate APICv when using
 in-kernel PIT re-injection mode.
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "rkagan@virtuozzo.com" <rkagan@virtuozzo.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
References: <1572648072-84536-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1572648072-84536-14-git-send-email-suravee.suthikulpanit@amd.com>
 <70fb2b49-2198-bde4-a38b-f37bc8bc9847@redhat.com>
 <b4e61499-7247-d39e-cd46-c53388ba347a@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <4e4bd2c3-50c4-b23e-2924-728a37a5f157@redhat.com>
Date:   Mon, 4 Nov 2019 22:49:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <b4e61499-7247-d39e-cd46-c53388ba347a@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/11/19 19:54, Suthikulpanit, Suravee wrote:
> I see you point.
> 
>> We can work around it by adding a global mask of inhibit reasons that
>> apply to the vendor, and initializing it as soon as possible in vmx.c/svm.c.
>>
>> Then kvm_request_apicv_update can ignore reasons that the vendor doesn't
>> care about.
>
> What about we enhance the pre_update_apivc_exec_ctrl() to also return 
> success/fail. In here, the vendor specific code can decide to update 
> APICv state or not.

That works for me, too.  Something like return false for deactivate and
true for activate.

Paolo

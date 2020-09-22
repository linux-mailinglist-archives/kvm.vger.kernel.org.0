Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7430274357
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 15:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgIVNj3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 09:39:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54173 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726662AbgIVNj2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 09:39:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600781967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kOI1WpHi1dirYs0ZwrGaNH1l5VP48PNKICMJarwnWG8=;
        b=WqYtmV5RuBRi85boOgYHJvZV/Y5orpiljDrTenDK0x79mrtQan9Eu8c5SCM2smVXBKwVma
        Y7EzyvujnMaIbkq5j+eCKBqecP9YAUmFxV27t50+48hnIljmuBsvgZpZ1FtC3tdrZbIaxa
        jPcxZYwPOJNX9K0eFCPwcCWPGSz7xwE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-AUtZNnGuNmOY28aKml3Yrg-1; Tue, 22 Sep 2020 09:39:25 -0400
X-MC-Unique: AUtZNnGuNmOY28aKml3Yrg-1
Received: by mail-wm1-f70.google.com with SMTP id t8so585366wmj.6
        for <kvm@vger.kernel.org>; Tue, 22 Sep 2020 06:39:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kOI1WpHi1dirYs0ZwrGaNH1l5VP48PNKICMJarwnWG8=;
        b=H/VPsYbjrNX0gdN52gMAv6lCl7zdqNrwCUKYhNNre6yBqFMEcGwWm8cCjyUn9lkiDJ
         FVb/yaXGreAsnIqpt28qYD/fyzaM7QvAiScSxXl4FuCxCMISOgXxXCy4u+yfk3XtG7q2
         qBF8BUyz/Br7uWs697OhrFGgmRVtW/kOkh9jB0SssYd/z2H1HI6twgg/df/ColsMotcI
         ZmOmjq0i3TzyXOGwmRc8eYcAwwcYS0v+WETYd+Do3m+hHzYOHTNaeEe3YHZv5SvA/Adx
         pOph6s4kXylpG6srimP67qTig7u7zOvSh64CjVk46nw/a9xBqrUY8zIy/vfh2k3cfnKS
         fxpA==
X-Gm-Message-State: AOAM532vDN+YW6CQSF4zCOwOk2t6KNmxrvGk8QQn875ntTA/Lya4zULN
        LEJZQ/wsbkLU9Ah/dLRuZW4Qb1wRWqwR02PAR1JP6HTJYkRkgUII4aKHp4GKvOMVUV6KUHPxmTs
        0SDHSIjtL37KN
X-Received: by 2002:adf:f042:: with SMTP id t2mr5210226wro.385.1600781963809;
        Tue, 22 Sep 2020 06:39:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwr0vCFA8qgUEqKKr5lLX6Qwfl1aK55d38FwPyZh9anbVWG3qPboRxwPNc0l5Hj4TOj9QOH1w==
X-Received: by 2002:adf:f042:: with SMTP id t2mr5210193wro.385.1600781963572;
        Tue, 22 Sep 2020 06:39:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec2c:90a9:1236:ebc6? ([2001:b07:6468:f312:ec2c:90a9:1236:ebc6])
        by smtp.gmail.com with ESMTPSA id h1sm25477745wrx.33.2020.09.22.06.39.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 06:39:22 -0700 (PDT)
Subject: Re: [PATCH v6 04/12] KVM: SVM: Modify intercept_exceptions to generic
 intercepts
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Babu Moger <babu.moger@amd.com>, vkuznets@redhat.com,
        jmattson@google.com, wanpengli@tencent.com, kvm@vger.kernel.org,
        joro@8bytes.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
References: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
 <159985250037.11252.1361972528657052410.stgit@bmoger-ubuntu>
 <1654dd89-2f15-62b6-d3a7-53f3ec422dd0@redhat.com>
 <20200914150627.GB6855@sjchrist-ice>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e74fd79c-c3d0-5f9d-c01d-5d6f2c660927@redhat.com>
Date:   Tue, 22 Sep 2020 15:39:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200914150627.GB6855@sjchrist-ice>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/09/20 17:06, Sean Christopherson wrote:
>> I think these should take a vector instead, and add 64 in the functions.
> 
> And "s/int bit/u32 vector" + BUILD_BUG_ON(vector > 32)?

Not sure if we can assume it to be constant, but WARN_ON_ONCE is good
enough as far as performance is concerned.  The same int->u32 +
WARN_ON_ONCE should be done in patch 1.

Thanks for the review!

Paolo


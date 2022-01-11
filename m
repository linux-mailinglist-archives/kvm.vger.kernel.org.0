Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B7F48A7AE
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 07:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348143AbiAKGY2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 01:24:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232725AbiAKGY2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 01:24:28 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0184CC06173F;
        Mon, 10 Jan 2022 22:24:28 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id o3so5311089pjs.1;
        Mon, 10 Jan 2022 22:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:from:to:cc
         :references:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=3AbMTJp+scsKh0PggMwmUYkYlbPH3KwJj4i9E8ycZus=;
        b=SjEVfTOPNfLbvyaLoZBhlW1cPZ8y3zwopX3SVU4XBsORjJcIQGHCjq5ilXJtz9MiU8
         I3y8QKRPdLSarRP9v2A+0MX9za9oiWj1/r4DT0OrvGTdsaomGd6/cpzHtJrl6YWYP4l5
         vm/VZJAQfAoWtkMld1EG5dFbxTAsti7osbFCqLU/+4ZEysy7HUEpv/1YW1OVwHX2pTNO
         Thx89yf4AocS7nBta1afPnifDkRHWJ31suQq1zg+y/nRPLDB8Ybq9vxuSGL5MsYiKLdf
         llQiQpUipB1Tk3KZ9uE659S2Azmn/wFLvD43FIG/vKFmt2a0a884cpueCVv0579uPkTT
         YV0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:from:to:cc:references:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=3AbMTJp+scsKh0PggMwmUYkYlbPH3KwJj4i9E8ycZus=;
        b=jlRnRMNm1b7m908XOWlDPgjqXgY18y50CrV0W9Vd6mh5cSWBrd1qVHJlUxwy80ytYv
         Xp16uVCf8GYXqkk46E19yzaxA7EzqeABDC7QN86PYucr1zxahtax4l3+XvURP8x2aC/U
         HwjfLxAyRz7kQtXoPItJlE7RclLvMZKZsKh6ifnAE3uiP6aWv7jIz24oMCUGT3HMb5Ey
         2ntLlvfRuaTaCjvNm2vIgerKI439+nSJyiHEmquwKTxXI4KIHHNzd/56GdL/Ge5eQuNv
         3pqa4rsQvdl/TZFIe/h7gCpeIR60209IzMcs1V7d8DmweUqJDVyzBPzJxFDGy/ihmPhV
         hN8Q==
X-Gm-Message-State: AOAM533OIeAFvYGr7aUNiEK21ZXAu31eomgvJrm9D9B3T2nEoe6j0tar
        mho0HKtOAd4x+EN1po0Ozy0=
X-Google-Smtp-Source: ABdhPJyMOI8YNb/db8KbqDSWdvKtuKA21LtGDqvTisPX8uzizPF3zy6gNnhenH5IgGaC9okRtFNRIA==
X-Received: by 2002:a17:902:e752:b0:14a:4743:be6e with SMTP id p18-20020a170902e75200b0014a4743be6emr3058956plf.122.1641882267503;
        Mon, 10 Jan 2022 22:24:27 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 20sm4390445pge.68.2022.01.10.22.24.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 22:24:27 -0800 (PST)
Message-ID: <a50909dd-fbe5-8e9c-4b98-784d3d0db178@gmail.com>
Date:   Tue, 11 Jan 2022 14:24:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220110034747.30498-1-likexu@tencent.com>
 <YdzV33X5w6+tCamI@google.com>
 <80b40829-0d25-eb84-7bd7-f21685daeb20@gmail.com>
Organization: Tencent
Subject: Re: [PATCH v2] KVM: x86/pt: Ignore all unknown Intel PT capabilities
In-Reply-To: <80b40829-0d25-eb84-7bd7-f21685daeb20@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/1/2022 12:20 pm, Like Xu wrote:
>> And is there any possibility of a malicious user/guest using features to cause
>> problems in the host?  I.e. does KVM need to enforce that the guest can't enable
>> any unsupported features?
> 
> If a user space is set up with features not supported by KVM, it owns the risk 
> itself.

I seem to have misunderstood it. KVM should prevent and stop any malicious guest
from destroying other parts on the host, is this the right direction ?

> 
> AFAI, the guest Intel PT introduces a great attack interface for the host and
> we only use the guest supported PT features in a highly trusted environment.
> 
> I agree that more uncertainty and fixes can be triggered in the security motive,
> not expecting too much from this patch. :D

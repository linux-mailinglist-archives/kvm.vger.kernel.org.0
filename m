Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38B530F3F6
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 14:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236357AbhBDNgw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 08:36:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24213 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236260AbhBDNgo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Feb 2021 08:36:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612445717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U3GD799EgQD9bFUcn9Xf4GO5bQgMB0Zdmj0Kjv/iqkc=;
        b=YboHDV23sQ5KlT6ebDxWmCKaJvnyo4pkP+gulq0VD2YsYobqcmkVOGWjQSOFDx1xSIzud9
        oAI4l274rqG51WFfFmJZ2Q3Mjfrgljv9zO+frStSsG8jf11J6ScNSy6gZdqnv48VlsCq0x
        0C29B01RrYExY5jBId0HaqzP6TAF4h0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-RCIVimzGMxORHNcdfZlbAw-1; Thu, 04 Feb 2021 08:35:15 -0500
X-MC-Unique: RCIVimzGMxORHNcdfZlbAw-1
Received: by mail-ed1-f69.google.com with SMTP id l23so146139edt.23
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 05:35:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U3GD799EgQD9bFUcn9Xf4GO5bQgMB0Zdmj0Kjv/iqkc=;
        b=Yo2R+S9B5kEILzYVWe7LytshnUp0NrF72d7xKJcEaEwcW3M11Os7Oyv7vxR0mAhzJc
         O9PVfmHasNN6jfilYg1YYBQI9xPqAwvXWucQo0b04RnFgxO0bjShZtCv75CrX5KwVyFw
         7fw5vz9IamBQN7lnCn/5L3E3OGrdxNIN7A6jkYnRYowzWDL6xUHAF7XS/TY3pphGszSs
         8WeDKYgQ7A6I6FipVpUN0nE+1f1gxhbJy5fnTwOPwVvRkJgxzEFQ+Pcrl9QNaJ/zFU9s
         QVSW4GVZxW5jixmGsxm+xQ0lbNglVJ/ng04Zr3FoxmvI27bZqtY0LHcbcGXV3ZL6b2eQ
         H6Dw==
X-Gm-Message-State: AOAM532x/ItnwT19HprI8GXynp3zNjbjEFctdMyyp27LZRFG7+f9fDkO
        1ar6ZD+YL40Ecdi2Qj0v06k5K3EZsjyVSLEXb5p9NT27wqnc56i4NYcLUGa/ITaVqLndp/1EdHy
        NLO0DUHBCS/Ow
X-Received: by 2002:a05:6402:3514:: with SMTP id b20mr7733023edd.100.1612445714525;
        Thu, 04 Feb 2021 05:35:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzQLBN1lxvXkMBIYBzyZuKXKYPsiD7X13LlmdDLwaAeM4tQaBC7P8yPaC7gXPc6PqHFTNongg==
X-Received: by 2002:a05:6402:3514:: with SMTP id b20mr7733007edd.100.1612445714398;
        Thu, 04 Feb 2021 05:35:14 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b25sm1726949ejz.100.2021.02.04.05.35.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 05:35:13 -0800 (PST)
Subject: Re: Optimized clocksource with AMD AVIC enabled for Windows guest
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Kechen Lu <kechenl@nvidia.com>
Cc:     "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Somdutta Roy <somduttar@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-discuss@nongnu.org" <qemu-discuss@nongnu.org>
References: <DM6PR12MB3500B7D1EDC5B5B26B6E96FBCAB49@DM6PR12MB3500.namprd12.prod.outlook.com>
 <5688445c-b9c8-dbd6-e9ee-ed40df84f8ca@redhat.com>
 <878s85pl4o.fsf@vitty.brq.redhat.com>
 <DM6PR12MB35006123BF3E9D8B67042CC9CAB39@DM6PR12MB3500.namprd12.prod.outlook.com>
 <87zh0knhqb.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <721b7075-6931-80f1-7b28-fc723ad14c13@redhat.com>
Date:   Thu, 4 Feb 2021 14:35:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <87zh0knhqb.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/02/21 13:24, Vitaly Kuznetsov wrote:
> I checked Linux VMs on genuine Hyper-V and surprisingly
> 'HV_DEPRECATING_AEOI_RECOMMENDED' is not exposed.

Did the host have APICv/AVIC (and can Hyper-V use AVIC)?  AutoEOI is 
still a useful optimization on hosts that don't have 
hardware-accelerated EOI or interrupt injection.

Paolo


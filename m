Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E61A403665
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 10:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348407AbhIHIy5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 04:54:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37212 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348212AbhIHIy4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Sep 2021 04:54:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631091228;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nc4j4dl7Mfy3UaeeqIQE2VyK+XGgfMm1ZSIO7tBQvPo=;
        b=AC9Xxfcn1IjltHqgPDwtMYgm1u74KfE77UZWRh4dCQppR7kWPW9saItnXCcrbD+2qXXwLE
        i48LysebnrOrXaX2HKS1PAnH+bUrNRLb0Yd5C+ttbXX75Eubc2xgVwKcMS5zya88K2PHAn
        ApfNzTzVZL8+zcEyAGnj+Ht4O60JXeg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-JA-AFcCIMwqBR6HvntfeSw-1; Wed, 08 Sep 2021 04:53:47 -0400
X-MC-Unique: JA-AFcCIMwqBR6HvntfeSw-1
Received: by mail-wr1-f70.google.com with SMTP id h15-20020adff18f000000b001574654fbc2so297897wro.10
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 01:53:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=Nc4j4dl7Mfy3UaeeqIQE2VyK+XGgfMm1ZSIO7tBQvPo=;
        b=dYoi1cHHeN1MyoBPriwSkiXWCYWJWanZ5XVGoBRhbnyrd7Ihk0w2GXw50fLVG1yVgK
         yHEPvffF1iRAzruf4JukE671n9MPsr7/U3HA+E2DR5c3AQVM+f4rWgltkm2CgSybnqaB
         qo86+qUXUcSZfTflkWerzcVi9zeXMUJqxvHWlBAWwMXXzzeSPsZVI3UfodTbMG5huU6P
         Yi7GthYGvVrrqO8tBxODrCRzTJ1KYwnjopyIn0FS4WM0gg36Ki6MsALCOMBo1/F2AWS4
         3lqeQaA8iMs95UrCKeVM77wqUi0u4eQg/NVsJDzxdmB5i4YW/yANHXdS1BVegu5qXXhz
         jjYg==
X-Gm-Message-State: AOAM531OaIcbSwwh0cTUxHJcgKind7B0l/XyBFYfLGwtrihqQ1hIRAJI
        IirFMbLuimoGqFrNszsFgeo8Hx9B9BVMSKSN7NWhnXREgKZOMDlP2h9zkK+Jwxrc0sdd7IPBpfh
        JO8yff/DnmAW2
X-Received: by 2002:a5d:4c4c:: with SMTP id n12mr2683928wrt.19.1631091226540;
        Wed, 08 Sep 2021 01:53:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0OyQfyVtK5Exxd/DvtUJw960vgzgLYmRmmpe68nxixS4vZOHSGJ0zd5nIoDWIHANb9FHFng==
X-Received: by 2002:a5d:4c4c:: with SMTP id n12mr2683914wrt.19.1631091226349;
        Wed, 08 Sep 2021 01:53:46 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id z6sm1426152wmp.1.2021.09.08.01.53.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 01:53:45 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 3/3] docs/system/arm/virt: Fix documentation for the
 'highmem' option
To:     Peter Maydell <peter.maydell@linaro.org>,
        Marc Zyngier <maz@kernel.org>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Andrew Jones <drjones@redhat.com>,
        kvmarm <kvmarm@lists.cs.columbia.edu>,
        kvm-devel <kvm@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>
References: <20210822144441.1290891-1-maz@kernel.org>
 <20210822144441.1290891-4-maz@kernel.org>
 <CAFEAcA_J5W6kaaZ-oYtcRcQ5=z5nFv6bOVVu5n_ad0N8-NGzpg@mail.gmail.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <fd41f05a-5ddb-6263-9efb-b130f7ac6817@redhat.com>
Date:   Wed, 8 Sep 2021 10:53:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAFEAcA_J5W6kaaZ-oYtcRcQ5=z5nFv6bOVVu5n_ad0N8-NGzpg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 9/7/21 2:51 PM, Peter Maydell wrote:
> On Sun, 22 Aug 2021 at 15:45, Marc Zyngier <maz@kernel.org> wrote:
>> The documentation for the 'highmem' option indicates that it controls
>> the placement of both devices and RAM. The actual behaviour of QEMU
>> seems to be that RAM is allowed to go beyond the 4GiB limit, and
>> that only devices are constraint by this option.
>>
>> Align the documentation with the actual behaviour.
> I think it would be better to align the behaviour with the documentation.
>
> The intent of 'highmem' is to allow a configuration for use with guests
> that can't address more than 32 bits (originally, 32-bit guests without
> LPAE support compiled in). It seems like a bug that we allow the user
> to specify more RAM than will fit into that 32-bit range. We should
> instead make QEMU exit with an error if the user tries to specify
> both highmem=off and a memory size that's too big to fit.

That's my opinion too

Thanks

Eric
>
> thanks
> -- PMM
>


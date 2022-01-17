Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A1C4903F9
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 09:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238248AbiAQIgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 03:36:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56480 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238242AbiAQIgg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 03:36:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642408595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uNhzno0wWEhzgVxHRwjARVs6TzvvxzJQTz1ejQZ7JqQ=;
        b=eB5flHWivkfApg8EwMa84DhxkY/Te3nLbDZZU9UNZxsfzpeFMorEtjHjaANwFFqx0rD1j2
        1gzu3B3GThjhNpYvDsyCq3seq4OzXrPGLtcqIgJZIvaqOD1zhXhGehIQ/+bsEM4CYPsnXI
        qxvRrAepWJrFHjCherYBOt1z/1Cv4ZU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-cInIT_59O4S2ZX_ubVy11w-1; Mon, 17 Jan 2022 03:36:33 -0500
X-MC-Unique: cInIT_59O4S2ZX_ubVy11w-1
Received: by mail-wm1-f70.google.com with SMTP id n25-20020a05600c3b9900b00348b83fbd0dso10522635wms.0
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 00:36:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uNhzno0wWEhzgVxHRwjARVs6TzvvxzJQTz1ejQZ7JqQ=;
        b=wd7ft5oolEfsyzY5HpJy1vOKxFC6hLMfLv/cjqiZXhEW2jyQ9iG1+G3ioiOJ6WVKqe
         eUkPOnLRw9bxrIH3bIiFOCveM9SCZ+U5APq+omol8VccRdERS/SYN2f5esq6VPp/wD7Y
         TjP25CZ7hP3rrCi96tnD0EhnStrZZzsATxjHa/ux7E0FKODpdlWkhFYePW86xruDKRUB
         WyW0MPCy+Gvi0lwlhPO78k47nUzy5LK03Z22ja0XqN9iNIajyXOKakiH/96lLvBo37u4
         3ypcObzx1pNYTlBEKdnHKy+4XppAaZnp9KIOhclEV75l0MvnEpFV0WBwROim0TAIcasE
         OAug==
X-Gm-Message-State: AOAM5306NhOck8HQFjX9brZI9XL6Ckx4Wy5LORjhZLEZMEoRYGW8aesf
        xXYIKnfQt20B/mzl6eIiYH3UkGBshnJMu+J6SUAaaumsZoHdmnEaurWCo4tz3rooF8MxYh7RBx8
        WdbjOXWF0Ug6l
X-Received: by 2002:adf:e84f:: with SMTP id d15mr18256191wrn.15.1642408592054;
        Mon, 17 Jan 2022 00:36:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxj2pp45Ih4MGk2jlOZCfHILaORsUuOFs80diJwXqRhG219ra8KDaGLXAInm8r0EuFBpb0QPA==
X-Received: by 2002:adf:e84f:: with SMTP id d15mr18256174wrn.15.1642408591893;
        Mon, 17 Jan 2022 00:36:31 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id r19sm12674076wmh.42.2022.01.17.00.36.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 00:36:31 -0800 (PST)
Message-ID: <4ca0ec95-6552-ac86-64e4-4b50e65c776e@redhat.com>
Date:   Mon, 17 Jan 2022 09:36:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: x86/svm: Add module param to control PMU
 virtualization
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211117080304.38989-1-likexu@tencent.com>
 <c840f1fe-5000-fb45-b5f6-eac15e205995@redhat.com>
 <CALMp9eQCEFsQTbm7F9CqotirbP18OF_cQUySb7Q=dqiuiK1FMg@mail.gmail.com>
 <ad3cc4b9-11d4-861b-6e31-a75564539216@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <ad3cc4b9-11d4-861b-6e31-a75564539216@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/17/22 03:33, Like Xu wrote:
>>>
>>
>> Whoops! The global 'pmu' is hidden by a local 'pmu' in get_gp_pmc_amd().
> 
> Indeed, I wonder if Poalo would like to take a look at this fix:
> https://lore.kernel.org/kvm/20220113035324.59572-1-likexu@tencent.com/

Yes, my mistake.

Paolo


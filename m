Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5004B30C296
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 15:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbhBBOzh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 09:55:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32196 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234607AbhBBOvk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 09:51:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612277402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9RQsTX71NL19IDLfCoq3ZLQUlhLj824QwkOpBMNAD80=;
        b=dvWyMdUH09a4pa1Va3mnIo2EKdDtEuBvRrpKmU5YsgTg8sbTyAHGfgQTPQpR8L7qvYM9sD
        7ZCR2fIpIZ5bfjKpUUWwR/xHp9yy+f2WJiiYj3k3TCoS6/SqcNFjgLpCxRkoSvu0ZA2izE
        xoZ0rs4abpRr2RihqKViv9xw0vFuNX4=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-g8aap5qaOuakQByu486uNA-1; Tue, 02 Feb 2021 09:50:00 -0500
X-MC-Unique: g8aap5qaOuakQByu486uNA-1
Received: by mail-ej1-f69.google.com with SMTP id ar27so8995372ejc.22
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 06:50:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9RQsTX71NL19IDLfCoq3ZLQUlhLj824QwkOpBMNAD80=;
        b=OKGrhsr02bnIL0CyU9vphzN28BHfGnfUyCgBwpOS9u6KCRDFGnKwAUyJ7udTRqzwVQ
         Mxhmzne1NCafm8FOcY0nHf8Ty8QQVEa7ktzI4bYUdqLDlI47EUUz5kSVPRSBg5mKc2CK
         fORFGSs0N752CK/L/cuWDpNsoC7vup6BppdB/w+KcMUC5IyMlvGK1m2HMO57yscs/CLv
         zd1FUbUv/D+ANCGuk9jOmt1E53KttJAa2qYFG6T8FROxXyMU9fOY5fsOOgD4tJ+fVgHO
         qCXUsv4NuyQybiSzvFlo2Ycho63UA2HhWBNh2fFh8MhTmIuY8MR+MmAHJmSBSki72SsY
         6lOw==
X-Gm-Message-State: AOAM533NBgDWwbk4YARCLqxbDKF+hs7pQS5FQMk+88CvR+OpIElpPXj/
        3oDqwOiyPU+/4dGhGAP54Om8BACw8k67xGDSOeXrgrJ9fWrDyGM2a6WNA1M5ThfrhJvpI41XBa9
        Jet+lmGIR5qON
X-Received: by 2002:a05:6402:3494:: with SMTP id v20mr16071032edc.146.1612277399344;
        Tue, 02 Feb 2021 06:49:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwXyL+UoR1XVxrp6tYLe4iwa2Xkd4MHKYs+ajSZvDy+STf2K3TUHQvditVmgXlOTLse3lOHuQ==
X-Received: by 2002:a05:6402:3494:: with SMTP id v20mr16070993edc.146.1612277398764;
        Tue, 02 Feb 2021 06:49:58 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j23sm10153810edv.45.2021.02.02.06.49.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 06:49:57 -0800 (PST)
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210202090433.13441-1-chenyi.qiang@intel.com>
 <20210202090433.13441-2-chenyi.qiang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 1/3] KVM: X86: Rename DR6_INIT to DR6_ACTIVE_LOW
Message-ID: <3db069ba-b4e0-1288-ec79-66ac44938682@redhat.com>
Date:   Tue, 2 Feb 2021 15:49:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210202090433.13441-2-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/02/21 10:04, Chenyi Qiang wrote:
> 
>  #define DR6_FIXED_1	0xfffe0ff0
> -#define DR6_INIT	0xffff0ff0
> +/*
> + * DR6_ACTIVE_LOW is actual the result of DR6_FIXED_1 | ACTIVE_LOW_BITS.
> + * We can regard all the current FIXED_1 bits as active_low bits even
> + * though in no case they will be turned into 0. But if they are defined
> + * in the future, it will require no code change.
> + * At the same time, it can be served as the init/reset value for DR6.
> + */
> +#define DR6_ACTIVE_LOW	0xffff0ff0
>  #define DR6_VOLATILE	0x0001e00f
>  

Committed with some changes in the wording of the comment.

Also, DR6_FIXED_1 is (DR6_ACTIVE_LOW & ~DR6_VOLATILE).

Paolo


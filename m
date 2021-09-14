Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25EF340A5FF
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 07:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239684AbhINFiI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 01:38:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38696 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239673AbhINFiH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 01:38:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631597809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qZQpALJRO2DRj77s2ycL1tcep9ZQbvDn5QtKFTncmIU=;
        b=H7Kp3yNeFhoQ0hWL0UoejFWcroaSK/CJTfN5erwvTmabbaU6HxAdccCJa+HucNkYV3U/Jb
        i8IF/asWuO7JqYg3HBGLMeDzzyasN9/aZGdOBDDvf2KSOTskcA9XQ+oBQjXShHlRDZrZMj
        3kX2PykxH/HwmtZTdhgiCqstHsEzpcs=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-CNlNqMeNOFCsOf7uBqO61g-1; Tue, 14 Sep 2021 01:36:48 -0400
X-MC-Unique: CNlNqMeNOFCsOf7uBqO61g-1
Received: by mail-ej1-f70.google.com with SMTP id k23-20020a170906055700b005e8a5cb6925so4793500eja.9
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 22:36:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qZQpALJRO2DRj77s2ycL1tcep9ZQbvDn5QtKFTncmIU=;
        b=m2tN2XqGnqHij2Q2EMiQbGExhria1F2pLryKusikVzB9fjP5oF08P7cORpRDte91jk
         J+sFlTBUpBRv7N9qkDGH1TRhT30VDjubr0kcRE75hqOArvgxtkSaf0DgZCO3DAvc0Ufx
         /OQc6DwTOCvqsjoVLvGx1jyCJaGcf77mSgKGs3q5hu/c/86mlvk3DJ7iZUGe1OmprFkW
         XiNCprVCAT+3jDuisvT3PJxIyAaoloxdWsaYZ5sowwEYU5CjOfvi1ErZlDyA53iffdLi
         nCTFu5x9hs/F/TyX3xcziF/4EqCXLBFArDn69zKEbHUXVgOG7/RwtetSBdlxxwdZy1rr
         Ay/A==
X-Gm-Message-State: AOAM532meIqHg7/8X+R//ZbFIONh/m7RN48Jm5YBZfunNx2Dboh5D9gP
        w/RkBmOUaKTF4TFp2OWYAKT7m0g8Z0b/1sWN/uytmDP5ym/uxfSQiDCIVaVtqQWnkdaNAhYkLVp
        7oXAT1DcLQLEa
X-Received: by 2002:aa7:d619:: with SMTP id c25mr17109537edr.365.1631597806944;
        Mon, 13 Sep 2021 22:36:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwmANg/+bLpe7zpuvdvos4IkOjD3/HKp62bKU9//cD9FY70/rlU7rBvF5UxBlMBoRQft30l5g==
X-Received: by 2002:aa7:d619:: with SMTP id c25mr17109523edr.365.1631597806770;
        Mon, 13 Sep 2021 22:36:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id e11sm1494456ejm.41.2021.09.13.22.36.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 22:36:45 -0700 (PDT)
Subject: Re: [PATCH 1/2] x86: sgx_vepc: extract sgx_vepc_remove_page
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        dave.hansen@linux.intel.com, yang.zhong@intel.com
References: <20210913131153.1202354-1-pbonzini@redhat.com>
 <20210913131153.1202354-2-pbonzini@redhat.com>
 <dc628588-3030-6c05-0ba4-d8fc6629c0d2@intel.com>
 <8105a379-195e-8c9b-5e06-f981f254707f@redhat.com>
 <06db5a41-3485-9141-10b5-56ca57ed1792@intel.com>
 <34632ea9-42d3-fdfa-ae47-e208751ab090@redhat.com>
 <3409573ac76aad2e7c3363343fc067d5b4621185.camel@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <734abf89-8be2-dd13-b649-fde5744ba465@redhat.com>
Date:   Tue, 14 Sep 2021 07:36:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <3409573ac76aad2e7c3363343fc067d5b4621185.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/09/21 23:13, Jarkko Sakkinen wrote:
>> Apart from reclaiming, /dev/sgx_vepc might disappear between the first
>> open() and subsequent ones.
>
> If /dev/sgx_vepc disappears, why is it a problem *for the software*, and
> not a sysadmin problem?

Rather than disappearing, it could be that a program first gets all the 
resources it needs before it gets malicious input, and then enter a 
restrictive sandbox.  In this case open() could be completely forbidden.

I will improve the documentation and changelogs when I post the non-RFC 
version; that could have been done better, sorry.

Paolo


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5873D6868
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 23:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233230AbhGZUYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 16:24:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56172 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232772AbhGZUYi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 16:24:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627333506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nsAdnl9z18qs+3xP5OpyMQ6xLIDE+aQIuQ62ZMIj5qo=;
        b=drPHbmBcotkaPqnqHPQ4TnWethu7zlOZZsGsIjNGX+P/ZB/JCjQ8CNosUs0jGZIh2xgIMH
        gMONzSd72odexRHzLjPoggkUrr0QfG+4+hI1iqZI1QUf5uY7sLv187U6fMAi2OBy8Q7+hG
        wTjasPd4myewEcGDLOzoDy13UzNek7M=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-Y0ev6wepOV6w3W4ZjMJAaw-1; Mon, 26 Jul 2021 17:05:05 -0400
X-MC-Unique: Y0ev6wepOV6w3W4ZjMJAaw-1
Received: by mail-ed1-f69.google.com with SMTP id c20-20020a0564021014b029039994f9cab9so5325074edu.22
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 14:05:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nsAdnl9z18qs+3xP5OpyMQ6xLIDE+aQIuQ62ZMIj5qo=;
        b=j80XxO20QeNekr1osS5wyXWV24oTlzmvignUAJYDBkDTADb3W9qQhC0hjm5nP5QDoQ
         dVqgFspvsrKL2QeThhQ6KfLORKs6E0tE9uSOcypfoV2PxsyQdKluJX2HyOGk5nmtF3B3
         L9zr1o3vUXbeo2Ti13dopMgUL6f/GAInBL9Vp0EQYMfweR7cAIjanukE+TKoxwuVCSDA
         0U4RYsDLsayWO9QfQJ5clyoXo2URoaVAIWOTkd0wqT8cWfUQuk43jPxVz76pH/OcE6vL
         pH0LAaoB5XiNXx9A2uCApY56elEX3YXTPGd6IRMGubjV+MaGvJxH0w9nmf+gY9BugECB
         bEdw==
X-Gm-Message-State: AOAM533An1xyqBcj7wjIGpc9M77QdFTE7POD6iMfvolyrnCXzCnnsRHn
        f0ouRs7xVoneOFFEOZfMTudZI1cEjVOARK0JBqUqMqt6GrMJaC0AyA8TM9UzMYL3T0tT6CD7nmF
        +aV1u9bXXiH+Q
X-Received: by 2002:a17:906:4097:: with SMTP id u23mr4283059ejj.98.1627333504002;
        Mon, 26 Jul 2021 14:05:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJmpito0eoGb/asuoiq9cKZaDuLXEqU/j/+/G2DXClJMx/169UBBWWLSlR+E4w1QqdfrbbWA==
X-Received: by 2002:a17:906:4097:: with SMTP id u23mr4283049ejj.98.1627333503819;
        Mon, 26 Jul 2021 14:05:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id n13sm389090eda.36.2021.07.26.14.05.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 14:05:03 -0700 (PDT)
Subject: Re: [PATCH v2 45/46] KVM: SVM: Drop redundant clearing of
 vcpu->arch.hflags at INIT/RESET
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
References: <20210713163324.627647-1-seanjc@google.com>
 <20210713163324.627647-46-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <47679db7-5662-100d-c9be-b3df8e2d647e@redhat.com>
Date:   Mon, 26 Jul 2021 23:04:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210713163324.627647-46-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/07/21 18:33, Sean Christopherson wrote:
> Drop redundant clears of vcpu->arch.hflags in init_vmcb() now that
> init_vmcb() is invoked only through kvm_vcpu_reset(),

Not true if patch 9 is kept, but at this point hflags is zero anyway, so 
the patch is okay.

Paolo

> which always clears
> hflags.  And of course, the second clearing in init_vmcb() was always
> redundant.


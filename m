Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEE13B34FB
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 19:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbhFXRuM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 13:50:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51166 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229573AbhFXRuL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 13:50:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624556871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F4zUnvKWC3ykOgNFbozTcI2nRZpt5SoQCavjNVNgrBc=;
        b=eNf3ipMkFZSJABPaLuD73Z2pb0Nwh7iJ7aFogHqigY8qtMocZ3Q5ccDnY5D5dToieazKZa
        zlNzg3FJ6MYZliYMPSFX+Rb8/Il69dlmzCIgR/VbyPfESomfQiHPYcdjd7eSFSv0pkiHSA
        Arp9Swzu3LVbF95aiq+EkmsAixyeiQc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-EtzauXl-OwK7jXLZsf5fWw-1; Thu, 24 Jun 2021 13:47:49 -0400
X-MC-Unique: EtzauXl-OwK7jXLZsf5fWw-1
Received: by mail-ej1-f70.google.com with SMTP id l6-20020a1709062a86b029046ec0ceaf5cso2297075eje.8
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 10:47:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F4zUnvKWC3ykOgNFbozTcI2nRZpt5SoQCavjNVNgrBc=;
        b=tiCBDb8VxbpTiZ3ELAgK09xvtYbNDhe6Gxr7CuN1m+9sGTXAKu3wgtd3121nvo5xF4
         3i9JWK18xiPwLMORkPn1g+fEmQjUoclXivU/zInqc91dgw3p5MdnndHPWDrbAtHaCHyi
         EiF9wiUZSGhUkYSOOm4WbmACfxRmk/QICfLnA0W21S2dqUtmOS3CGP/e/DaS/o4G1HzB
         UxOvDw3RF5OaefQ1N+OhxlrXkssclwlOWsImSczGBeAvTvE/uODHbV63GAEpkLnw1lbc
         QG55GWnYrYG+mEv7OO1Caw7VXbfMymx8ul0tfnd5Ju5JG3wtSFNdSBbLm72/Jvkhuq/Z
         0xdg==
X-Gm-Message-State: AOAM532lIJLx1sNSjRXeUKRl0AiKsnXH4tR3BCjOIp2v13mAWfKAg0XU
        tyQyVwDVWshFbmBzWIllVJ9h4R0kstNZ6ccJ/7+LXMsz+hkUPcZnA2McYB4SXZNvR7X+PFAbp1r
        dRZzMD7ArWhui
X-Received: by 2002:a17:906:716:: with SMTP id y22mr6638685ejb.266.1624556868331;
        Thu, 24 Jun 2021 10:47:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJynPu9OspGwPGsT4lVNm2bTB7gIfgbYTqWXkYgKbEMLtaCbnHfy8UX2eNxxwJfVYFiTCb1ZUg==
X-Received: by 2002:a17:906:716:: with SMTP id y22mr6638675ejb.266.1624556868144;
        Thu, 24 Jun 2021 10:47:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i6sm1493366ejr.68.2021.06.24.10.47.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 10:47:47 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 05/12] nSVM: Remove NPT reserved bits tests
 (new one on the way)
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
References: <20210622210047.3691840-1-seanjc@google.com>
 <20210622210047.3691840-6-seanjc@google.com>
 <2f1c2605-e588-2eea-d2c1-ab2f4fdc531d@redhat.com>
 <YNTESd1rtU6RDDP0@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6ae872e2-0de6-9c17-89df-ff29c43228d0@redhat.com>
Date:   Thu, 24 Jun 2021 19:47:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YNTESd1rtU6RDDP0@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/06/21 19:43, Sean Christopherson wrote:
>> 	./x86/run x86/svm.flat -smp 2 -cpu max,+svm -m 4g \
>> 		-append 'npt_rw npt_rw_pfwalk'
> Any chance you're running against an older KVM version?  The test passes if I
> run against a build with my MMU pile on top of kvm/queue, but fails on a random
> older KVM.

I'm running it against the current kvm/queue.

Paolo


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A39D416B9E
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 08:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244211AbhIXGd6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 02:33:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43577 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244198AbhIXGdz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 02:33:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632465142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uBkIEJDbBxNlkgRFQ8/A7W9IW8llN+C89N+NmBdxBxI=;
        b=ei5/XZ5zj6blC4g6MU4KHkkboYTMHS1GSpSeRYSPJvsfpI3yvXz23jqW47mllwA8yLbce0
        i2CQPhZdR/t6VVWmREFtmrOwWZUapuPewsTA5KQNvUIfKMa5gJXfzO6S+XoOM1dJzNUaQW
        6CbrR2/jrbhkKflXFFQj2yPLwJkP7uM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-fXnY3W5LPiq2EdGGKB12uA-1; Fri, 24 Sep 2021 02:32:20 -0400
X-MC-Unique: fXnY3W5LPiq2EdGGKB12uA-1
Received: by mail-ed1-f70.google.com with SMTP id r11-20020aa7cfcb000000b003d4fbd652b9so9183462edy.14
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 23:32:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uBkIEJDbBxNlkgRFQ8/A7W9IW8llN+C89N+NmBdxBxI=;
        b=3EY0ZkRXik8v2kd3i6SkjCE/hkguiMkIdU1DxMpKtc/Maa31Y8+XRzC+WXvmtJyQN7
         pJCd7G0oK1YrxhRjGhG7g4ce84B49JBvg32c0O/sn+UZViyaDCnv2zCuApeJ9CGKhFi6
         GQJtXq7q/ccY12uKdqRCi5lw+g/+8WFZuvvfY9imErQMp1hvJ+JxWGXNGrr+J6vMe9sw
         QFpgA04VVBGp5XbFekMOtxXJe/MhMuHecDmvC2+GCSxlW4Mbu+6L2n8/HlMV9ILLztHF
         Kj3ZcJqcrRFdAZghrZrmPqiS5oYgPRCQvEfffkjuF6auHZvwI4rrGXxN+Se6zs1t4lfv
         EJfQ==
X-Gm-Message-State: AOAM531zAd5qZAJWU9AYm1tZ30LXLFJWUVYB2IQpS51UYf4yWFhAZpcL
        yq3PeqOXRin3jKXu+4k04ttBFc1aLVtXihB69vMo2+CWGj1LH10hKNgggJlwvkF6gX5uLLyzvPS
        9Yky/jpVNqENJ
X-Received: by 2002:a17:906:a08a:: with SMTP id q10mr9422226ejy.100.1632465139706;
        Thu, 23 Sep 2021 23:32:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxHd4Z7Fb67q6/aljQvFd/oji25j39N16vuz/cbgsNufLPXtff1UfRG/aqAS1OzSfftRTGLw==
X-Received: by 2002:a17:906:a08a:: with SMTP id q10mr9422207ejy.100.1632465139453;
        Thu, 23 Sep 2021 23:32:19 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id m13sm4383956ejn.3.2021.09.23.23.32.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 23:32:18 -0700 (PDT)
Message-ID: <f32ec41b-792c-3db3-3940-5d78f19a3d8f@redhat.com>
Date:   Fri, 24 Sep 2021 08:32:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] selftests: KVM: Call ucall_init when setting up in
 rseq_test
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jim Mattson <jmattson@google.com>,
        Andrew Jones <drjones@redhat.com>
References: <20210923220033.4172362-1-oupton@google.com>
 <YU0XIoeYpfm1Oy0j@google.com>
 <CAOQ_QsgScBRB+BEMC0Ysdq8EjLx3SLB9=pV=P4kQ3bfchm15Mw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAOQ_QsgScBRB+BEMC0Ysdq8EjLx3SLB9=pV=P4kQ3bfchm15Mw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/21 02:10, Oliver Upton wrote:
>>>         */
>>>        vm = vm_create_default(VCPU_ID, 0, guest_code);
>>> +     ucall_init(vm, NULL);
>> Any reason not to do this automatically in vm_create()?  There is 0% chance I'm
>> going to remember to add this next time I write a common selftest, arm64 is the
>> oddball here.
> I think that is best, I was planning on sending out a fix that does
> this later on. Just wanted to stop the bleeding with a minimal patch
> first.

For now I've queued it, for 5.16 we can do it in vm_create().

Paolo


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9F2392D56
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 13:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbhE0L7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 07:59:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53695 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234474AbhE0L7A (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 07:59:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622116646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kas3balWHSMX4J6TlBrNl8de4KZiKhjPUh/O+MCK4cU=;
        b=Igwiz3/hrX2ADWIgPJlnixSjYP4gGgcQVjxDb9u5FuT8KTQf0gcVQi872c3HmsG4uzbchQ
        gHv0UUkj1E9gf0QZjXZBAMw8BZc4QawPBCtFC4ckj3BA0FpbhLblDdVqdiW1uMTE9jD6I4
        55TLRJfA9USX0yc+GuomJPj+TL0GzcQ=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-2W_RWfU7Mly_MAmMyK0hsw-1; Thu, 27 May 2021 07:57:25 -0400
X-MC-Unique: 2W_RWfU7Mly_MAmMyK0hsw-1
Received: by mail-ej1-f71.google.com with SMTP id p5-20020a17090653c5b02903db1cfa514dso1570797ejo.13
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 04:57:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kas3balWHSMX4J6TlBrNl8de4KZiKhjPUh/O+MCK4cU=;
        b=NR3CSF3Boe+sAzdPxHocebflpzKk2H29p/j1vf/pAIe7k/oSO7KERXXnspa3ARvDMX
         fJWr15oOjlkP9vtvRJFHQGdqz4Bm4JrycE1HjNpB5UAKXOfXGzdnK+FdI3rArO4osKW5
         DIpf7hHDc+ZipsKA4FLb4d9tBYf91Tmo3+EXBV0mC91rDs9X14fmFCU93iZUyGvPF1+n
         3eP450yBsbcKF0s0ZVPT6HPUrDE4I/xcSmRbCC/M9KgiSc5FswaUZiEQn3maz/bo53FY
         fD+LjQXXe15CGgAQiYUWumb4ZLtEN7bnhlrz11ub1nNGLsY0b9LSILNDSQz4sf1rZ6ha
         xppA==
X-Gm-Message-State: AOAM532NH1i51sbo7WT3lyBkCPMsyTtKWSF1lwNaV/6U0Rnwioo8TGpZ
        NU4gI+qSo9e7Cwy4Sd4trji2XqJ1qdm6WJwv7vDC4KLSPQRtUNmKdKBiW14vnzfV8C04zSvDQZH
        NOuTjczf9smmn
X-Received: by 2002:a17:906:2dd4:: with SMTP id h20mr3402995eji.131.1622116644144;
        Thu, 27 May 2021 04:57:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZ8kCeFbqDqZJ8PB2tas9tz3UmhXd1XkwUVux0fSZvCAVzgzZaNcUWiK/9cSzYiNZfNUoTlw==
X-Received: by 2002:a17:906:2dd4:: with SMTP id h20mr3402973eji.131.1622116644006;
        Thu, 27 May 2021 04:57:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id m2sm988670edv.7.2021.05.27.04.57.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 04:57:23 -0700 (PDT)
Subject: Re: [patch 2/3] KVM: rename KVM_REQ_PENDING_TIMER to KVM_REQ_UNBLOCK
To:     Peter Xu <peterx@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <20210525134115.135966361@redhat.com>
 <20210525134321.303768132@redhat.com> <YK1MmcHqJGCR631n@t490s>
 <20210525192637.GC365242@fuller.cnet> <YK1VZogK5n7Anqy8@t490s>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4add2ef3-7ed3-364b-0ef0-2e55179872f2@redhat.com>
Date:   Thu, 27 May 2021 13:57:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YK1VZogK5n7Anqy8@t490s>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/05/21 21:52, Peter Xu wrote:
> Didn't think further on how to make it better, e.g. simply dropping
> kvm_cpu_has_pending_timer() won't work since it seems to still be
> useful for non-x86..

It should be possible to use KVM_REQ_UNBLOCK in other architectures, and
drop kvm_cpu_has_pending_timer().

Paolo


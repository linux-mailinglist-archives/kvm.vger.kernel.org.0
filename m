Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3120F1A7FDA
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 16:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390960AbgDNOc5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 10:32:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58115 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390946AbgDNOcx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 10:32:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586874772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GA+frwKgLLT3M5PQMy+v1/9lKB1rwChFWEmr5bbzqXU=;
        b=PLvw6VK5b7RnOJDr1ER77XGVgvL8NSR8AFWRl8De7RH4q8yrymIbnbhrN7mk7l/dkxt//N
        xYrphSnX10w2ztZ7boBsWhPwAqBQF8hAUfVWJ0Ifa8ixa/OESORCFHu+JaZcrEgui522rF
        5StpBwcnoDLegAgvnzOurvW/3weijGI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-BL8rjPjsM_C2npki0-k_IQ-1; Tue, 14 Apr 2020 10:32:51 -0400
X-MC-Unique: BL8rjPjsM_C2npki0-k_IQ-1
Received: by mail-wr1-f72.google.com with SMTP id e5so207278wrs.23
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 07:32:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GA+frwKgLLT3M5PQMy+v1/9lKB1rwChFWEmr5bbzqXU=;
        b=eXrruT4jZLwYQLSbv+Lrtb6gvndP8D70QdtFSCgrXSl/ZM6mG9+42G+jqqFtx2lTvT
         aNpHg+YIu6ni5BvC1E2Cv0IJGR37fbhw+vJttbasgp7o2nzxS7tHeuzdw7oXwVNOcIby
         TGWF+5/czk2WfvcRgKI9VsAi1habk5/qbdNMjgWbvibxIal+sFRkjCloofp5V8aU7znO
         lVrhsOvTdbf/l+s3l+DaIKCbno2F1USHrLUsOALhB5jjKIZta1Tt/nH+L6UHOBbOo7zR
         KPJ2pEsw2xmgtul6GGQ7OQS3oc/Y42RFR0HGyxefBScQkUFcjog08/vgeBG4QuMZrXKT
         K/Sw==
X-Gm-Message-State: AGi0PuZgbUCSOJTj6xiGVzf/kfvXg0MjSO0UJpFHgqgf8fTTv4N9zZqo
        XgU5JltNCloOxffiDtiv3l64/aoljx20c/FIG9wXi5PjJiBfok+YOVgf7ow//0C+NeHTOibdDfX
        eN8VhbIwtdTQ+
X-Received: by 2002:a7b:cf2b:: with SMTP id m11mr127614wmg.147.1586874767607;
        Tue, 14 Apr 2020 07:32:47 -0700 (PDT)
X-Google-Smtp-Source: APiQypIa9+oVWt3N560QxrzJKOW8Tsg35lciK5O/O4rwOyTrXXw041seQ/Ho54Jrb3dyHhylHWYUxQ==
X-Received: by 2002:a7b:cf2b:: with SMTP id m11mr127587wmg.147.1586874767155;
        Tue, 14 Apr 2020 07:32:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:503c:7b97:e286:9d8e? ([2001:b07:6468:f312:503c:7b97:e286:9d8e])
        by smtp.gmail.com with ESMTPSA id b7sm19340308wrn.67.2020.04.14.07.32.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 07:32:46 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] ioapic-split: fix hang, run with -smp 4
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20200414141147.13028-1-pbonzini@redhat.com>
 <873696yw9o.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d7105f07-5a8e-41d2-01cc-841590bebb06@redhat.com>
Date:   Tue, 14 Apr 2020 16:32:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <873696yw9o.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/04/20 16:30, Vitaly Kuznetsov wrote:
> Thank you but this particular change causes the test to start failing
> for me:

Yes, it's in the commit message.  Technically it's not _starting_ to
fail, since it was hanging before!

Paolo

> timeout -k 1s --foreground 90s /usr/libexec/qemu-kvm --no-reboot
> -nodefaults -device pc-testdev -device
> isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio -device
> pci-testdev -machine accel=kvm -kernel x86/ioapic.flat -smp 4 -cpu
> qemu64,+x2apic -machine kernel_irqchip=split # -initrd
> /tmp/tmp.OcMOvh1e7x


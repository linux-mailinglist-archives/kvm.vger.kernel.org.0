Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2746324183B
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 10:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgHKI3D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 04:29:03 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54654 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728224AbgHKI3D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Aug 2020 04:29:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597134542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Krbl59lVgdIaVHFIqHsULDB7P5tPQ/ZmDROWkw57zBg=;
        b=P5X8U21PXOWHBQFX4JAU0I1ryQ4GnEZOeqgeNyFl3Wy0oqwdlUIgRONGHkI6M0uR/zgYLG
        1AK8FAIc7+ezBn6jt2WatU9ztJqvpvEdOvYXx22pYxB3EXMrdzpMaqFTEYvlWKivrMw9RQ
        xl2KlgEORI6XpxXsYythkwLdIYnvKSM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-WvBAqCruMnONmQn016SbiA-1; Tue, 11 Aug 2020 04:28:58 -0400
X-MC-Unique: WvBAqCruMnONmQn016SbiA-1
Received: by mail-ed1-f71.google.com with SMTP id p26so4285907edt.11
        for <kvm@vger.kernel.org>; Tue, 11 Aug 2020 01:28:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Krbl59lVgdIaVHFIqHsULDB7P5tPQ/ZmDROWkw57zBg=;
        b=id7j44hdRb99AQY8tU/Bcqf9MPnl7ugnscbcp5w+adrACOrlOm3ANqqucQCs/A2U6R
         U8YkvAcXE4aFuN7Qh0SdCCq0lh0QYbGYU7NGfxQ6Jm7uCe32S1n5e7l+uJnL7x+gDSjY
         qCfDIhSmcozEhMj/IbSzfj3wmeuoLVPo5WXqvkw/kOocqVyDVrdVKExqXnBWCUmkd7d2
         7f7s1ADlz7897UQIji4AVaQ0cBecOtzfoRuaLosaoJFwTvfJ/ITVpKvaETm9zcNwYJuf
         hiNewyeQfMHlmfg59W6O5ct+KCVts1xzNy9OLGa2L0+v/MYMyFxfqMICYQdaW61LUmPR
         MeQg==
X-Gm-Message-State: AOAM533SZ+r76oR1CyYeYtklLI8ITBxlBxkP+PinbYPwjzcuwmTAx4Sc
        0+Co8SFmEhkcQYyRcPrjDyL1GPdwYx3HUyGZmUQqJAnOiLlxMpoF/hpicHqS4a5wvJZT/an51It
        eepn7IvbR6lZ3
X-Received: by 2002:a17:906:c406:: with SMTP id u6mr26518301ejz.47.1597134537428;
        Tue, 11 Aug 2020 01:28:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQoSfGdOEJTj0vof5G8y97JMED6X5COIn9LMmeJ/9OtCYydJfL+5UrjguBX6GLh128ND/pmw==
X-Received: by 2002:a17:906:c406:: with SMTP id u6mr26518290ejz.47.1597134537250;
        Tue, 11 Aug 2020 01:28:57 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.12.249])
        by smtp.gmail.com with ESMTPSA id e14sm14003787edl.86.2020.08.11.01.28.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2020 01:28:56 -0700 (PDT)
Subject: Re: IPI broadcast latency in the guest is worse when AVIC is enabled
To:     Wanpeng Li <kernellwp@gmail.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Cc:     kvm <kvm@vger.kernel.org>, Wei Huang <wei@redhat.com>
References: <CANRm+Cx597FNRUCyVz1D=B6Vs2GX3Sw57X7Muk+yMpi_hb+v1w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <95c26b17-66c6-0050-053b-faa4d63a2347@redhat.com>
Date:   Tue, 11 Aug 2020 10:28:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CANRm+Cx597FNRUCyVz1D=B6Vs2GX3Sw57X7Muk+yMpi_hb+v1w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/08/20 04:04, Wanpeng Li wrote:
> We found that the IPI broadcast latency in the guest when AVIC=1,
> exposing xapic is worse than when AVIC=0, exposing xapic. The host is
> AMD ROME, 2 sockets, 96 cores, 192 threads, the VM is 180 vCPUs. The
> guest boots with kvm-hint-dedicated=on, --overcommit cpu-pm=on, -smp
> 180,sockets=2,cores=45,threads=2, l3-cache=on qemu command-line, the
> pCPU which vCPU is running on is isolated. Both the guest and host
> kernel are 5.8 Linus' tree. (Note, if you fails to boot with
> --overcommit cpu-pm=on, you can comments out commit e72436bc3a52, I
> have a report here, https://lkml.org/lkml/2020/7/8/308)
> 
> IPI microbenchmark(https://lkml.org/lkml/2017/12/19/141, Destination
> Shorthand is All excluding self)
> 
> avic0_xapic:   12313907508.50 ns
> avic1_xapic:   19106424733.30 ns
> avic0_x2apic: 13073988486.00 ns

I think it depends on the microarchitecture implementation of AVIC?

Paolo


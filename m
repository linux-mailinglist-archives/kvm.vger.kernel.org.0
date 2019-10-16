Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFAFFD8A0F
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 09:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391233AbfJPHnZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 03:43:25 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36368 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727646AbfJPHnZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Oct 2019 03:43:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571211804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=2TZPYczZMoe38v6J5VmGL4LQBizJV5OWL5TaFj5ByLo=;
        b=Zg+XMJAst9xvzV+tdQ/bZRxBfHPEto4K8GEvkGmZUrTmHhjYDeQCZZQg6g1FiG3TrPZhhk
        3bHIblFlVx3dXw+e9jiukKaP8n6fM7EO5EhU3iLfNuwTRWODR11EDy4qDVLVjkAE+lhr1U
        R4gOaAPJYhp4m9zni12FSDnyxpSE8X4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-Xt0gEwjDMl-WUwGifhGCbQ-1; Wed, 16 Oct 2019 03:43:21 -0400
Received: by mail-wr1-f71.google.com with SMTP id o10so11303331wrm.22
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 00:43:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2TZPYczZMoe38v6J5VmGL4LQBizJV5OWL5TaFj5ByLo=;
        b=CJGdX7WGnJE2hFjSwWZLfLHKNx6PShNss8WV4HvBYVcJ1NOnxpZMh+xwqGW5SjV7Vs
         GWzTsJY6ZEUjrr+Vs5zfL9rhID3JNDWEGOhc6ORgfG3rtF9MjBVtirfP6yvHy1xup3ND
         iyRCI2UCyflzLj+sakmW2opW0DmzXnQ7XhBLvvROl5NslTXRX6dhhyTAZ92dX3khUwDD
         8I+Woc+LNjoyGaJMOoFVeDaAW0w0pkeBVdDPZsVZXco/M8fGpl57FE1ca//oRnJ/3gYY
         KCJN5KQSQMPEKlKzUUJ7UqusOfHeAwvRqSNPe4m/Kynr8jRrvY1po01FfDdDbgIFVlc5
         oA2g==
X-Gm-Message-State: APjAAAUHcmgGrL+TYBTgyTgJHKRnP+V0ahlYMysLleDICS5e5M4TEDkz
        HCj/biq+/iKMFq7xQoTFOe8FLuGJxwvzhM9egDqQrwd1FIOUbkpxkIyQjZRQCEKsllv21EOYfMN
        wdlMWoPCVfiRC
X-Received: by 2002:a5d:6203:: with SMTP id y3mr1414797wru.142.1571211799707;
        Wed, 16 Oct 2019 00:43:19 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzYE+zEFsYqXUGvnl9sFNQ8c4wx17KGf+Az81W3+WtMXjrT9dBRLwLjKr90BAhiAxvpImSuwQ==
X-Received: by 2002:a5d:6203:: with SMTP id y3mr1414773wru.142.1571211799459;
        Wed, 16 Oct 2019 00:43:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ddc7:c53c:581a:7f3e? ([2001:b07:6468:f312:ddc7:c53c:581a:7f3e])
        by smtp.gmail.com with ESMTPSA id d78sm1595639wmd.47.2019.10.16.00.43.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2019 00:43:18 -0700 (PDT)
Subject: Re: [PATCH v5 4/6] psci: Add hvc call service for ptp_kvm.
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Jianyong Wu <jianyong.wu@arm.com>, netdev@vger.kernel.org,
        yangbo.lu@nxp.com, john.stultz@linaro.org,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Steve.Capper@arm.com, Kaly.Xin@arm.com,
        justin.he@arm.com, nd@arm.com
References: <20191015104822.13890-1-jianyong.wu@arm.com>
 <20191015104822.13890-5-jianyong.wu@arm.com>
 <9641fbff-cfcd-4854-e0c9-0b97d44193ee@redhat.com>
 <alpine.DEB.2.21.1910160929500.2518@nanos.tec.linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5e344920-1460-337c-9950-858165d37d14@redhat.com>
Date:   Wed, 16 Oct 2019 09:42:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1910160929500.2518@nanos.tec.linutronix.de>
Content-Language: en-US
X-MC-Unique: Xt0gEwjDMl-WUwGifhGCbQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/19 09:31, Thomas Gleixner wrote:
>> 3) move the implementation of the hypercall to
>> drivers/clocksource/arm_arch_timer.c, so that it can call
>> ktime_get_snapshot(&systime_snapshot, &clocksource_counter);
>
> And then you implement a gazillion of those functions for every
> arch/subarch which has a similar requirement. Pointless exercise.
>
> Having the ID is trivial enough and the storage space is not really a
> concern.

Ok, good.

Paolo


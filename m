Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26A92D895B
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 09:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729738AbfJPHZH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 03:25:07 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42613 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726719AbfJPHZF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Oct 2019 03:25:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571210704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S5d0V9S8ommJVGUrWAIephbxJ0dHyW1i5xgUqQkwiWw=;
        b=izrUhR1m9GQmr/R4nFLnw1JlaOYJZD0AYbmiLSOd6Bx70oxacKuavN2XZ+dkBfQt15YmZU
        0eOZX8LqBs6PfPNl1ZjtLW5dIE2PMLEZtCaHXjwHfEX0SgXm/20aoFygycI4I0uoqczrZH
        ZkPDPGwhEoK2P1ExnBOGoUAwGQx1NLg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-fbgYdB_sORSfOjsdbj16hg-1; Wed, 16 Oct 2019 03:25:00 -0400
Received: by mail-wr1-f72.google.com with SMTP id z17so11310507wru.13
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 00:25:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7pVDKMRb0iY8vtAwjOLtISUgtFuBYzCTEpSdAuatOfE=;
        b=JUBZI6CLee3n6y6p7Pmp6crNkQMgklcp4fQq96GOVZIUkzR8ZakOK8G8aoU96W7Oxg
         9NTUiQEGow43AwLidj2RPpMkfyBb+1nFCT6ma9+k58AilYUkCMt1pMPcPbUcJT/w0+vu
         5WPL2fGNiOw0YOrPxK6M2xnoLkicOUHFk7BEh48LlAjPlKNnEt3RPDevoN8RyPhRA/1O
         jECQjZNTAFUsGpz7Gtf+zAwnAk+6WXW4YRXsjwobxHJ/p/u9CAGHF7RkUg1i91by6yss
         GlldzBY41zxUUXAD/8BZKP2vKRO5q3cj9Y0JzZAkQN7nmjT9ofUYuD4mUercxx4tTGs9
         2pig==
X-Gm-Message-State: APjAAAWrQbTSfLyzpjOAH3x1hG0HkRt1cLjWX0Vb/OiM+26Nug2D44z4
        Ku0Q22XLIidvpA0UKfw1O5uyexoafs+sF/Dek3sBCGKDdhKCunI4voHpJt5bLcggx/fnHO16P5d
        1eh7wtGjkhO0J
X-Received: by 2002:a1c:2d4d:: with SMTP id t74mr1925348wmt.108.1571210699179;
        Wed, 16 Oct 2019 00:24:59 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw5Hnm/FlYZhsbogxc96HRPT50pfLfmeGENB2+vf8pJDNEMgxSNXlDgdpTAAP/g6kRKVCeDyw==
X-Received: by 2002:a1c:2d4d:: with SMTP id t74mr1925322wmt.108.1571210698895;
        Wed, 16 Oct 2019 00:24:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ddc7:c53c:581a:7f3e? ([2001:b07:6468:f312:ddc7:c53c:581a:7f3e])
        by smtp.gmail.com with ESMTPSA id f20sm1474636wmb.6.2019.10.16.00.24.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2019 00:24:58 -0700 (PDT)
Subject: Re: [PATCH v5 4/6] psci: Add hvc call service for ptp_kvm.
To:     Jianyong Wu <jianyong.wu@arm.com>, netdev@vger.kernel.org,
        yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
        nd@arm.com
References: <20191015104822.13890-1-jianyong.wu@arm.com>
 <20191015104822.13890-5-jianyong.wu@arm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9641fbff-cfcd-4854-e0c9-0b97d44193ee@redhat.com>
Date:   Wed, 16 Oct 2019 09:24:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191015104822.13890-5-jianyong.wu@arm.com>
Content-Language: en-US
X-MC-Unique: fbgYdB_sORSfOjsdbj16hg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/10/19 12:48, Jianyong Wu wrote:
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/a=
rm_arch_timer.c
> index 07e57a49d1e8..3597f1f27b10 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -1634,3 +1634,8 @@ static int __init arch_timer_acpi_init(struct acpi_=
table_header *table)
>  }
>  TIMER_ACPI_DECLARE(arch_timer, ACPI_SIG_GTDT, arch_timer_acpi_init);
>  #endif
> +
> +bool is_arm_arch_counter(void *cs)
> +{
> +=09return (struct clocksource *)cs =3D=3D &clocksource_counter;
> +}

As Thomas pointed out, any reason to have a void * here?

However, since he didn't like modifying the struct, here is an
alternative idea:

1) add a "struct clocksource*" argument to ktime_get_snapshot

2) return -ENODEV if the argument is not NULL and is not the current
clocksource

3) move the implementation of the hypercall to
drivers/clocksource/arm_arch_timer.c, so that it can call
ktime_get_snapshot(&systime_snapshot, &clocksource_counter);

Paolo


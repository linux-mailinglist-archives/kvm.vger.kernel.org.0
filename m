Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86F49B5F1B
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 10:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730254AbfIRIZm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 04:25:42 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:33533 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730225AbfIRIZm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Sep 2019 04:25:42 -0400
X-Greylist: delayed 71152 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Sep 2019 04:25:41 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1568795141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=sCvYaicCVH8OrDZlwsa8ICj82oK2Vn0GFjH/m8a0EOU=;
        b=MOzjZd6gVZGoeY1WWVJIKKivJSxdWUFjYfmmLqFQ14rgDQPNlrF6KFqFIiS1bIHesotMCr
        gG+PGQatrc99YHb9Wqg3PVq9Z0HEFvcat2C6T+nD3xhxTFQ1SWR4lXgHfgccQF73XjHfh/
        B02GEbuRbMohxpZc5uO77G6QkrzVygw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-CH18sxAnPeiVq_W29CIqyg-1; Wed, 18 Sep 2019 04:25:40 -0400
Received: by mail-wm1-f69.google.com with SMTP id k9so762333wmb.0
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2019 01:25:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+0NSTxt+2cOn/cB86g2+fMxuM9WiNm6PL9JuEvNIK5M=;
        b=ctbNvnMnBrzRbEk367wNDkWYMuw0VuLs+LIkXzamjRDgGRWgVDNFh6riS/fNpilfQQ
         7q0v5NczEjJTQyICo8RkO3a9TePkT8jh8uAb5amXoKG9/Nbr34D/zb74c+uYUEsR3PCT
         2aN0yYxOvX5go6BXMz+uunofxQVBzSnYKEWo7Ec2mp/NMsr3XsETFeT9EZ/xi6rhSpll
         ejJaW/0ozLfgxbyWu4qO6yQMD0sZAXx1/P+Ah9W+Yx2U81MquMtUBbK76K4kP9iF6egL
         Wk5Wc016YZZkMYg3qEnqugKlLXjP5e+kU2obb+pIZfYmRKy26ZoC/WqM8vVnMajxRu6p
         J/FA==
X-Gm-Message-State: APjAAAU4thczyqNqcY+rnYioQPHwFTVstFUQMXNX+2Vvl9ULe+j3aqk9
        P8m+zrfyYVvB0kSy47VmjlcHti16+1baPC9mugSSHLs3cViVcL8P0fUPSi4GvK+7/oA0+pwURFV
        m2FU9slm8v7/Q
X-Received: by 2002:a5d:4983:: with SMTP id r3mr1910628wrq.194.1568795139045;
        Wed, 18 Sep 2019 01:25:39 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwY+BNDBy8hbD47ydvWQhqPwEt4J5QJf1IHJz82EGJ9j3igRSbtePP9u1jlLlqfQ3k5XE2prw==
X-Received: by 2002:a5d:4983:: with SMTP id r3mr1910612wrq.194.1568795138815;
        Wed, 18 Sep 2019 01:25:38 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id s12sm8726472wra.82.2019.09.18.01.25.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Sep 2019 01:25:38 -0700 (PDT)
Subject: Re: [RFC PATCH v3 4/6] psci: Add hvc call service for ptp_kvm.
To:     Jianyong Wu <jianyong.wu@arm.com>, netdev@vger.kernel.org,
        yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com,
        Will.Deacon@arm.com, suzuki.poulose@arm.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
        nd@arm.com, linux-arm-kernel@lists.infradead.org
References: <20190918080716.64242-1-jianyong.wu@arm.com>
 <20190918080716.64242-5-jianyong.wu@arm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <83ed7fac-277f-a31e-af37-8ec134f39d26@redhat.com>
Date:   Wed, 18 Sep 2019 10:25:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190918080716.64242-5-jianyong.wu@arm.com>
Content-Language: en-US
X-MC-Unique: CH18sxAnPeiVq_W29CIqyg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/09/19 10:07, Jianyong Wu wrote:
> +=09case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> +=09=09getnstimeofday(ts);

This is not Y2038-safe.  Please use ktime_get_real_ts64 instead, and
split the 64-bit seconds value between val[0] and val[1].

However, it seems to me that the new function is not needed and you can
just use ktime_get_snapshot.  You'll get the time in
systime_snapshot->real and the cycles value in systime_snapshot->cycles.

> +=09=09get_current_counterval(&sc);
> +=09=09val[0] =3D ts->tv_sec;
> +=09=09val[1] =3D ts->tv_nsec;
> +=09=09val[2] =3D sc.cycles;
> +=09=09val[3] =3D 0;
> +=09=09break;

This should return a guest-cycles value.  If the cycles values always
the same between the host and the guest on ARM, then okay.  If not, you
have to apply whatever offset exists.

Thanks,

Paolo


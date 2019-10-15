Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF4BED83D1
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 00:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389953AbfJOWgr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 18:36:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23552 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389950AbfJOWgr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 18:36:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571179005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=wSh+n+8u5QLmMxe2hYGq+Rqu0J/BQ5npWNcVhzyY+e4=;
        b=IAxU6c4ZWDiDLZQXzywuju9FMVFy3dTbcqQT8SEf2q2usAbv4w3nZhFaEN9RJw4cmhNRYY
        AVdXfs9bCO3JqAjtJmHwWUmURdXLr9S8vz5WyUKozPBK3oZXLDdWH4s/Z1mUySUhqR1rY2
        tpbkwbVFhW5tY2eHpqky1CMKDWGRIRQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308--8fc-qiHPkGeG-4U7RUMYg-1; Tue, 15 Oct 2019 18:36:44 -0400
Received: by mail-wm1-f72.google.com with SMTP id c188so256708wmd.9
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 15:36:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lwwAcBIi9gz4rDVsHFX2Q7ZJ02GG7jdgtvkZrgQZWFY=;
        b=ARXP7CRspNkUsy0SPKtymdmV7pnzE9lD3wQddGLHd4fuwAbSr3R0qDB1njXyhsupR7
         8ikvqFFlaGzy8FiQQwPLIxV4ylW8Q+IpR2LuTMuwU5Bkxsb5amhpHz53powDQvqp2op5
         eynlAxs2fDVWH0Mvw3wu6A/jfvkuw2r0CRQAZrifryuKyN9a1HhyIlBm8AuEphqaEZDj
         6XcZsIsEF4CL0an1bFd41kuB5+inek4GRkqCOWEyQn7ksnMBkUNfRJE8KniQ4JHOdd3r
         wIARmGJnkMYgCUVbu3VlCMR/wS1L2Xvbp4PVubhcmOA91vXLhOlh4W+8bsnUNyvUM8ib
         c+JA==
X-Gm-Message-State: APjAAAVlsL1F/W3mIZPVNvyderTYZy+FbPHRFRR+Upz/bGN6o7NOzT2m
        i+Cqjvnf4b9fDqyal9njcJJMKJwVZs9PY7Db3QGYrxVzCtQBR2Sj7kvjJbLpVSLO5HzScs707xr
        1vrNKRQH8faHB
X-Received: by 2002:a05:600c:3cb:: with SMTP id z11mr537738wmd.134.1571179003423;
        Tue, 15 Oct 2019 15:36:43 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyR41EszL4/UT/53Ec9vQZG6o/Omkzfs8QOJ0pfXMxxw7MFiXPeS9FywecPK4MHNGK9zwKlCQ==
X-Received: by 2002:a05:600c:3cb:: with SMTP id z11mr537711wmd.134.1571179003137;
        Tue, 15 Oct 2019 15:36:43 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ddc7:c53c:581a:7f3e? ([2001:b07:6468:f312:ddc7:c53c:581a:7f3e])
        by smtp.gmail.com with ESMTPSA id c18sm20828908wrv.10.2019.10.15.15.36.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2019 15:36:42 -0700 (PDT)
Subject: Re: [PATCH v5 3/6] timekeeping: Add clocksource to
 system_time_snapshot
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
 <20191015104822.13890-4-jianyong.wu@arm.com>
 <9274d21c-2c43-2e0d-f086-6aaba3863603@redhat.com>
 <alpine.DEB.2.21.1910152212580.2518@nanos.tec.linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <aa1ec910-b7b6-2568-4583-5fa47aac367f@redhat.com>
Date:   Wed, 16 Oct 2019 00:36:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1910152212580.2518@nanos.tec.linutronix.de>
Content-Language: en-US
X-MC-Unique: -8fc-qiHPkGeG-4U7RUMYg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/10/19 22:13, Thomas Gleixner wrote:
> On Tue, 15 Oct 2019, Paolo Bonzini wrote:
>> On 15/10/19 12:48, Jianyong Wu wrote:
>>> =20
>>>
>>
>> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
>=20
> You're sure about having reviewed that in detail?

I did review the patch; the void* ugliness is not in this one, and I do
have some other qualms on that one.

> This changelog is telling absolutely nothing WHY anything outside of the
> timekeeping core code needs access to the current clocksource. Neither do=
es
> it tell why it is safe to provide the pointer to random callers.

Agreed on the changelog, but the pointer to a clocksource is already
part of the timekeeping external API via struct system_counterval_t.
get_device_system_crosststamp for example expects a clocksource pointer
but provides no way to get such a pointer.

Paolo


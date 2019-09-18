Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D081B615D
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 12:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729815AbfIRKXz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 06:23:55 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:60838 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729559AbfIRKXy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Sep 2019 06:23:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1568802233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PzJJIzaT+H0i65urk/DowU+Nu1kZ2zWoYZTl/vMnWsA=;
        b=NBkUq176kVQSB9vtvsFK2KbuEdUGO/D6ecCpIunhu82G0jzJrck64DsaduzznUKbWzDhwU
        8eAFdHBni7jK1MVlmentoyiTGEslp4iHuc+R8VZoGy42x6OdjNifUK7+5D2JHjoFjpQwhK
        Ny9T2LxyAXpzD/wAGi6RkHcLm50mRVo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-ezuLcTA0MYuPg9TKYaNWow-1; Wed, 18 Sep 2019 06:23:51 -0400
Received: by mail-wm1-f72.google.com with SMTP id j125so893386wmj.6
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2019 03:23:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/BXfx7jonw/Kdws8cuIdF1uOWxKnVxEGGX2roqyV5/g=;
        b=mkRk6YdEN84lFbdj6kM81Nbt/aKIdSN4CtBLdfohI7tVD55TYtKq7oghPYquRokIPJ
         ZJ3qXTHuf8GxF6G9wu1Tf1vfKatxrbZ8CEHyL9kj605k9aOrICkLqPzjRDdlo2jsseWC
         1hc8roxdGubhWkvZnNFP5bXzX5HHr6wegXA/bISedb7faK8eM73zvQw6rdCGQ2FFlWiS
         ElKQKEwqeP8jahqtXNwV0CAmqVcLJJQ6Sjvon2bMnnH8EhB6FTAOmq9g76m7tGzIXRjo
         Wzny/36LtYGIWzJrNaaPiXDhMTDAxbf5VP+KPWiQLGEHSu8dYM7NLiBarFCNvdGcgjF8
         TsEg==
X-Gm-Message-State: APjAAAVdQFcIZ1avi7LCdvxyav1KOfOMv9AITA/+SvBBqZDXnEejExeH
        Cq29b9V0kOSPAYwBSU8GE4ccfqL+VzRq2lVG3nrZvrT7ykgLLHVnVeREXV+mHRnzdk/BWn1PnyN
        uy6XCNBtrQGDo
X-Received: by 2002:adf:e443:: with SMTP id t3mr2384775wrm.181.1568802229701;
        Wed, 18 Sep 2019 03:23:49 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwfxmTc5Fm4ZBlmRxUIGfYmFyau7KO9p53RPlq/ZJeTwvrFxtmEzKYq4y8POaEPkTSmkwUKyg==
X-Received: by 2002:adf:e443:: with SMTP id t3mr2384734wrm.181.1568802229356;
        Wed, 18 Sep 2019 03:23:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c46c:2acb:d8d2:21d8? ([2001:b07:6468:f312:c46c:2acb:d8d2:21d8])
        by smtp.gmail.com with ESMTPSA id h125sm2260481wmf.31.2019.09.18.03.23.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Sep 2019 03:23:48 -0700 (PDT)
Subject: Re: [RFC PATCH v3 4/6] psci: Add hvc call service for ptp_kvm.
To:     "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        "Kaly Xin (Arm Technology China)" <Kaly.Xin@arm.com>,
        "Justin He (Arm Technology China)" <Justin.He@arm.com>,
        nd <nd@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <20190918080716.64242-1-jianyong.wu@arm.com>
 <20190918080716.64242-5-jianyong.wu@arm.com>
 <83ed7fac-277f-a31e-af37-8ec134f39d26@redhat.com>
 <HE1PR0801MB1676F57B317AE85E3B934B32F48E0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <629538ea-13fb-e666-8df6-8ad23f114755@redhat.com>
Date:   Wed, 18 Sep 2019 12:23:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <HE1PR0801MB1676F57B317AE85E3B934B32F48E0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
Content-Language: en-US
X-MC-Unique: ezuLcTA0MYuPg9TKYaNWow-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/09/19 11:57, Jianyong Wu (Arm Technology China) wrote:
> Hi Paolo,
>=20
>> On 18/09/19 10:07, Jianyong Wu wrote:
>>> +=09case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
>>> +=09=09getnstimeofday(ts);
>>
>> This is not Y2038-safe.  Please use ktime_get_real_ts64 instead, and spl=
it the
>> 64-bit seconds value between val[0] and val[1].
>>
> As far as I know, y2038-safe will only affect signed 32-bit integer,
> how does it affect 64-bit integer?
> And why split 64-bit number into two blocks is necessary?

val is an u32, not an u64.  (And val[0], where you store the seconds, is
best treated as signed, since val[0] =3D=3D -1 is returned for
SMCCC_RET_NOT_SUPPORTED).

>> However, it seems to me that the new function is not needed and you can
>> just use ktime_get_snapshot.  You'll get the time in systime_snapshot->r=
eal
>> and the cycles value in systime_snapshot->cycles.
>=20
> See patch 5/6, I need both counter cycle and clocksource, ktime_get_snaps=
hot seems only offer cycles.

No, patch 5/6 only needs the current clock (ptp_sc.cycles is never
accessed).  So you could just use READ_ONCE(tk->tkr_mono.clock).

However, even then I don't think it is correct to use ptp_sc.cs blindly
in patch 5.  I think there is a misunderstanding on the meaning of
system_counterval.cs as passed to get_device_system_crosststamp.
system_counterval.cs is not the active clocksource; it's the clocksource
on which system_counterval.cycles is based.

Hypothetically, the clocksource could be one for which ptp_sc.cycles is
_not_ a cycle value.  If you set system_counterval.cs to the system
clocksource, get_device_system_crosststamp will return a bogus value.
So system_counterval.cs should be set to something like
&clocksource_counter (from drivers/clocksource/arm_arch_timer.c).
Perhaps the right place to define kvm_arch_ptp_get_clock_fn is in that file=
?

>>> +=09=09get_current_counterval(&sc);
>>> +=09=09val[0] =3D ts->tv_sec;
>>> +=09=09val[1] =3D ts->tv_nsec;
>>> +=09=09val[2] =3D sc.cycles;
>>> +=09=09val[3] =3D 0;
>>> +=09=09break;
>>
>> This should return a guest-cycles value.  If the cycles values always th=
e same
>> between the host and the guest on ARM, then okay.  If not, you have to
>> apply whatever offset exists.
>>
> In my opinion, when use ptp_kvm as clock sources to sync time
> between host and guest, user should promise the guest and host has no
> clock offset.

What would be the adverse effect of having a fixed offset between guest
and host?  If there were one, you'd have to check that and fail the
hypercall if there is an offset.  But again, I think it's enough to
subtract vcpu_vtimer(vcpu)->cntvoff or something like that.

You also have to check here that the clocksource is based on the ARM
architectural timer.  Again, maybe you could place the implementation in
drivers/clocksource/arm_arch_timer.c, and make it return -ENODEV if the
active clocksource is not clocksource_counter.  Then KVM can look for
errors and return SMCCC_RET_NOT_SUPPORTED in that case.

Thanks,

Paolo

> So we can be sure that the cycle between guest and
> host should be keep consistent. But I need check it.
> I think host cycle should be returned to guest as we should promise
> we get clock and counter in the same time.


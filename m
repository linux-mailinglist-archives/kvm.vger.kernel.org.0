Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BABDD0AB4
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 11:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730179AbfJIJNc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 05:13:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49942 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725942AbfJIJNc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 05:13:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570612411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=cZvwRNK0EK2nVjw8oRG2qh7gftxLlqc06mSiL5eetn4=;
        b=iST+VPN0dhwhOlZQuuDx4R5tRHuuRMGwgCCxulAeItFd1PPFYaJFDRMbyor7iUf5EtKYER
        B86oO1f124k98dQ6VdzklUHqIuQaBWHcUtaMTHdoSzofeeCGE3Si9u1rlBFxtt7RTCfZ3N
        yi8kldUI37fVhBJB81wjfG7jU0E/59A=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-JY7wFSl2N62INYk8PwmAXg-1; Wed, 09 Oct 2019 05:13:29 -0400
Received: by mail-wm1-f71.google.com with SMTP id 190so760678wme.4
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 02:13:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Kg2KEa3btbJJz7gSq4olohGQOCWfoKGhQXiDkLfxFuQ=;
        b=sdvvH+qsmTXoOhWBBdLW5mGgiLpt/KJCL53Lb2Tq0Px4tggVZm/ID431bRvbK55oDE
         wkeVdvopuzId3g8lyugI2pkJ8WOkxM3buoABRVgTqaHV91heYkcBYm7bguIeKlG4ewjV
         kYUNem9AhqYHt7kjPhEw4UClaC0/aJmfEidQfvzrC7WoxG+qcr15z3cN+QFS6zOJFmis
         /SM0BYAETjlWpH8fx+u0Dc++51AyMfQLa0sqVSgf4L2QVrbnx6XHKs8nMwhDezhi+yQR
         j5gGm0UGllr4Duhr7GpmxseOu/JRhx3V1/1FR1Ce2lWazWLSTrZAgBJyIZC1EpiJBF+6
         DC6Q==
X-Gm-Message-State: APjAAAXtP+GJtHPxFFZ1aPZ6JwxLmf4XGhcW1CaUrvLitO/5IcO6JY3r
        ohJPe3Mtm61mOVNIA1y3hZqrPFavxTUh74Op6lBLUOYJemfR61Q8ugWtGVXAFu/zoFJ+diRyICQ
        Q0PRbeNyYP+s2
X-Received: by 2002:a7b:c94f:: with SMTP id i15mr1874120wml.31.1570612408501;
        Wed, 09 Oct 2019 02:13:28 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyLOYwIk6SUEWDWI7Ogctb8DPrp2tNv5YirX6y3gAP4cOVc6ZTZZ4OcRelLJPbF+BRnisnwJw==
X-Received: by 2002:a7b:c94f:: with SMTP id i15mr1874100wml.31.1570612408241;
        Wed, 09 Oct 2019 02:13:28 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id z22sm1311808wmf.2.2019.10.09.02.13.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 02:13:27 -0700 (PDT)
Subject: Re: [RFC PATCH v3 4/6] psci: Add hvc call service for ptp_kvm.
To:     "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
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
 <629538ea-13fb-e666-8df6-8ad23f114755@redhat.com>
 <HE1PR0801MB167639E2F025998058A77F86F4890@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <ef6ab8bd-41ad-88f8-9cfd-dc749ca65310@redhat.com>
 <a1b554b8-4417-5305-3419-fe71a8c50842@kernel.org>
 <56a5b885-62c8-c4ef-e2f8-e945c0eb700e@redhat.com>
 <HE1PR0801MB1676115C248E6DF09F9DD5A6F4950@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <1cc145ca-1af2-d46f-d530-0ae434005f0b@redhat.com>
 <HE1PR0801MB1676B1AD68544561403C3196F4950@HE1PR0801MB1676.eurprd08.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <6b8b59b2-a07e-7e33-588c-1da7658e3f1e@redhat.com>
Date:   Wed, 9 Oct 2019 11:13:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <HE1PR0801MB1676B1AD68544561403C3196F4950@HE1PR0801MB1676.eurprd08.prod.outlook.com>
Content-Language: en-US
X-MC-Unique: JY7wFSl2N62INYk8PwmAXg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/10/19 10:18, Jianyong Wu (Arm Technology China) wrote:
> Hi Paolo,
>=20
>> -----Original Message-----
>> From: Paolo Bonzini <pbonzini@redhat.com>
>> Sent: Wednesday, October 9, 2019 2:36 PM
>> To: Jianyong Wu (Arm Technology China) <Jianyong.Wu@arm.com>; Marc
>> Zyngier <maz@kernel.org>; netdev@vger.kernel.org; yangbo.lu@nxp.com;
>> john.stultz@linaro.org; tglx@linutronix.de; sean.j.christopherson@intel.=
com;
>> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>; Will
>> Deacon <Will.Deacon@arm.com>; Suzuki Poulose
>> <Suzuki.Poulose@arm.com>
>> Cc: linux-kernel@vger.kernel.org; kvm@vger.kernel.org; Steve Capper
>> <Steve.Capper@arm.com>; Kaly Xin (Arm Technology China)
>> <Kaly.Xin@arm.com>; Justin He (Arm Technology China)
>> <Justin.He@arm.com>; nd <nd@arm.com>; linux-arm-
>> kernel@lists.infradead.org
>> Subject: Re: [RFC PATCH v3 4/6] psci: Add hvc call service for ptp_kvm.
>>
>> On 09/10/19 07:21, Jianyong Wu (Arm Technology China) wrote:
>>> As ptp_kvm clock has fixed to arm arch system counter in patch set v4,
>>> we need check if the current clocksource is system counter when return
>>> clock cycle in host, so a helper needed to return the current
>>> clocksource. Could I add this helper in next patch set?
>>
>> You don't need a helper.  You need to return the ARM arch counter
>> clocksource in the struct system_counterval_t that you return.
>> get_device_system_crosststamp will then check that the clocksource
>> matches the active one.
>
> We must ensure both of the host and guest using the same clocksource.
> get_device_system_crosststamp will check the clocksource of guest and we =
also need check
> the clocksource in host, and struct type can't be transferred from host t=
o guest using arm hypercall.
> now we lack of a mechanism to check the current clocksource. I think this=
 will be useful if we add one.

Got it---yes, I think adding a struct clocksource to struct
system_time_snapshot would make sense.  Then the hypercall can just use
ktime_get_snapshot and fail if the clocksource is not the ARM arch counter.

John (Stultz), does that sound good to you?  The context is that
Jianyong would like to add a hypercall that returns a (cycles,
nanoseconds) pair to the guest.  On x86 we're relying on the vclock_mode
field that is already there for the vDSO, but being able to just use
ktime_get_snapshot would be much nicer.

Paolo


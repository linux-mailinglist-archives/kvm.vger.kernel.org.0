Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 354CCD074A
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 08:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729595AbfJIGgL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 02:36:11 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:56138 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729464AbfJIGgL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Oct 2019 02:36:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570602970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=DRp1swJmLGnIlAf7XMxEoZkdOJe88OuGnn8pzjWNfwY=;
        b=BSoNWozu3zOOe/2bdRhWUOLi6n/R9/wDoDsJLoipm0zfTtOVgfIFsWkkUJ+L1RUYsKGUCF
        2YfHWxA5HyAIOPhLEFb/VINP7mS3lH/T7bCRncho4k4q7V8UlctNmuVGhM6oHq/baWEDs4
        E0YtiHfjd+vAQEQgqc32owDckHZYqKM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-sJlDI_h4OqSKK9axhnQAdQ-1; Wed, 09 Oct 2019 02:36:04 -0400
Received: by mail-wr1-f71.google.com with SMTP id j7so624016wrx.14
        for <kvm@vger.kernel.org>; Tue, 08 Oct 2019 23:36:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DRp1swJmLGnIlAf7XMxEoZkdOJe88OuGnn8pzjWNfwY=;
        b=AXUgZqZlPKsNvy+odYUycS4dRTPPJdI67Lf4nDLGXdp1Q/5xHAZ1G414RTLzC421z9
         LLDQQigdZ5JUT0n+NMOzexgFcgrbNrMlSpbgXN9RQUSLsupKhd9Un0Ryt2a/aLhSrvuA
         xYkaI1iPzTvP1jMWMBcKmsbpcMvgs577qd3q5Dj7GbWgQGK7HeYc6UNT50OwRzO5allN
         cuWt6Ft9RYAkjuqh+7Q9wMHK/vtYPQgzN52YrwE6yGesDWtDQ8IciA7G0KpkQTMpPWR0
         09jMscuWtfUmveI0nHPBuJLfp+6nCT8eDRmxsA2Snb0u7fA84OnDCuUfqyMepvGXt+2h
         bWeQ==
X-Gm-Message-State: APjAAAVBVm6ggGt3iTtN88t+s3qKAUqPDk0B4s8ow/A0lRls+zmFZ7bR
        rHhxp4Qe/d12sKmMZv78nL3b8CEyRUnWfAiBv4m7Ny4VXgcY+JgP74VHRArIzoWUocBKdCr2/8p
        MAf3Ec+3fPKu0
X-Received: by 2002:a5d:5610:: with SMTP id l16mr1515942wrv.143.1570602963415;
        Tue, 08 Oct 2019 23:36:03 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwIwCawDi6R5bC55JQUaG89aKMEczYrGrPl67xVSkSyIT2j1JE6iE4/baYaPJLh4Q90kl9l8Q==
X-Received: by 2002:a5d:5610:: with SMTP id l16mr1515916wrv.143.1570602963107;
        Tue, 08 Oct 2019 23:36:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f4b0:55d4:57da:3527? ([2001:b07:6468:f312:f4b0:55d4:57da:3527])
        by smtp.gmail.com with ESMTPSA id m7sm993787wrv.40.2019.10.08.23.36.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2019 23:36:02 -0700 (PDT)
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
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <1cc145ca-1af2-d46f-d530-0ae434005f0b@redhat.com>
Date:   Wed, 9 Oct 2019 08:36:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <HE1PR0801MB1676115C248E6DF09F9DD5A6F4950@HE1PR0801MB1676.eurprd08.prod.outlook.com>
Content-Language: en-US
X-MC-Unique: sJlDI_h4OqSKK9axhnQAdQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/10/19 07:21, Jianyong Wu (Arm Technology China) wrote:
> As ptp_kvm clock has fixed to arm arch system counter in patch set
> v4, we need check if the current clocksource is system counter when
> return clock cycle in host, so a helper needed to return the current
> clocksource. Could I add this helper in next patch set?

You don't need a helper.  You need to return the ARM arch counter
clocksource in the struct system_counterval_t that you return.
get_device_system_crosststamp will then check that the clocksource
matches the active one.

Paolo


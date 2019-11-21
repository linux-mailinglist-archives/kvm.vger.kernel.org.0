Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75CCB104ECA
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 10:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbfKUJNb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 04:13:31 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27474 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726568AbfKUJNa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Nov 2019 04:13:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574327609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=3M6485oZ3h2+O4ro7A8gi/zi3MfoBr4gqzDpttvkg3w=;
        b=hwTNm9U8d7LF4/Ltpp3OYtxfdDJmT224eQGgnbkGBNoNLoOXs4HohsiYsqSPIdzrR51BXz
        bxLzeO1wlisghQCl80ZzqwnCuRjDz0S4ORvaJS5fEE5iThKyYbQ2lfVseA/PayR2l6JZkf
        A3Ly9AxYg2ohsX12aw6JZo/T9WhcqVY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-Jdop3J3vOnWFhODrXJ1mGQ-1; Thu, 21 Nov 2019 04:13:26 -0500
Received: by mail-wr1-f71.google.com with SMTP id c16so1763857wro.1
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2019 01:13:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MnY5vul8wqjyLuAl8HVVCWFLRgO+5Onvt2EnbAjuSA4=;
        b=DttIIRWaXBJ/zpMJqarO/O2M81g30QDqzsfhsGsI7Zmqun+sTnntLq5Tyk3hHxblIQ
         xEU2LaH4/hEiD4SkyBSA4kZDWbxOc3RUVwNQGlD01e65z0jxdI+2kcCUSrrzI/pUkasG
         4CQxWmXTuIgALtB85HW/SHW/+lYfGOdpnQ6H+scBwWzP23DFrSrtb15MxkzaAC0CU4FV
         oPGITmsEIt6oae6KXxVdF4VBVs4EteOZLw6zpLy14P06DlwcUtd+o9o7Nnsrss1BPA5m
         LyGRcvcub7Y+tvdScFwV9k5lVXAO1Z4FiATROTy0rXfmKx72IMu2tHwTeKYMqshft3/S
         6YHg==
X-Gm-Message-State: APjAAAXaNUjdbgV5H/m+l1xNcprkbXmgdB2TKqkqCzvBCSfGszvqEBdt
        CyJj5GNqvwhI5/yd3mhSTi4IbNsdQ4DqUQwD0UvOwTR5ODl19HJ3r0iTnvg3M7ZB+p8hIgzrkFr
        Zj1QjppQY/O/m
X-Received: by 2002:adf:dd0a:: with SMTP id a10mr8457531wrm.299.1574327605109;
        Thu, 21 Nov 2019 01:13:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqy3ZNKHYrKi1bUru69IXv71nFYLjTNHMigtS0mfIn48c69BczlnVWv1kLAz4F0q7IesX+op8w==
X-Received: by 2002:adf:dd0a:: with SMTP id a10mr8457488wrm.299.1574327604841;
        Thu, 21 Nov 2019 01:13:24 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:71a5:6e:f854:d744? ([2001:b07:6468:f312:71a5:6e:f854:d744])
        by smtp.gmail.com with ESMTPSA id s11sm2484895wrr.43.2019.11.21.01.13.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 01:13:23 -0800 (PST)
Subject: Re: [PATCH -next] KVM: x86: remove set but not used variable 'called'
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Mao Wenan <maowenan@huawei.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20191119030640.25097-1-maowenan@huawei.com>
 <87o8x8gjr5.fsf@vitty.brq.redhat.com> <20191119121423.GB5604@kadam>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <61f534ca-7575-6716-10ec-ac5c92258452@redhat.com>
Date:   Thu, 21 Nov 2019 10:13:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191119121423.GB5604@kadam>
Content-Language: en-US
X-MC-Unique: Jdop3J3vOnWFhODrXJ1mGQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/11/19 13:14, Dan Carpenter wrote:
>> Better expressed as=20
>>
>> Fixes: 7ee30bc132c6 ("KVM: x86: deliver KVM IOAPIC scan request to targe=
t vCPUs")
>
> There is sort of a debate about this whether the Fixes tag should be
> used if it's only a cleanup.

The other debate is whether this is a cleanup, since the build is broken
with -Werror.  I agree that code cleanups generally don't deserve Fixes
tags, but this patch IMHO does.

Paolo


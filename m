Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 617BE1737C9
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 14:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbgB1NCS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 08:02:18 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29762 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725805AbgB1NCS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Feb 2020 08:02:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582894937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qOYh55Sc6wrpHyCk5I3nHReNLrRQaG9oThpXrCZTmRs=;
        b=Pn2bCbJBFHyX7ulntuweozwzCXQ/mlBf8iL87UUQ8rNxtGIxit2UmkoQNEZjuZSWvnbOLE
        7z/bLN8XGOH9Z6gn+28Vvm3nFV9Y/xvKWBWrQYFR6tch0cC5U8NViRlar99jGkuTIa3/LG
        EmEKGp8epXsJpAGmEj0BSMV3Q2IvjfQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-iFwuq0-ENFqf4C7waziIXw-1; Fri, 28 Feb 2020 08:02:15 -0500
X-MC-Unique: iFwuq0-ENFqf4C7waziIXw-1
Received: by mail-wr1-f72.google.com with SMTP id z15so1310780wrw.0
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2020 05:02:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qOYh55Sc6wrpHyCk5I3nHReNLrRQaG9oThpXrCZTmRs=;
        b=rpisAcSoM9Keb30SlcpMBhxIkilgHnVwvv4DbBCua6jiitCcDlDRXkMalRbTz/UJUN
         HSVMIL9S0dEvowKbKcHH8LPvtwWbmz4p98kKcW/PLSFwV83/yIaLa3UmH3KstRtIe/+d
         ULe74+7NrsZJwgL/2zfAsQPZvzxx557k1Vm3O3PRVIODz/rOolEKqE2eUGTHg7JsMXMy
         hl+P3CghnpCENzFdAidd9z+ePNB7/EQmgsJFOpHuBjaaNcUnYqErO4Xw99UHRTr4LFsA
         WiYfBMCWBCMpfjQu26/+W2V91VNI6lRcp24zX57lhCZsCvvST5Xhet4qDrFklUNnOQPo
         TZ/w==
X-Gm-Message-State: APjAAAWmgzrjK55xqfZVc/xTwwCgCpwIB4I79hFW3MUIf7uTarri4nVW
        yfmamo+b1/cZIIlONi9UbSFsYnGKnm92/+A2YNJSHQdWaBOWMZg1SLVzRPgcGUh548B8QI8cElC
        jHp2ZHcJz154A
X-Received: by 2002:a05:6000:1142:: with SMTP id d2mr4688920wrx.62.1582894934216;
        Fri, 28 Feb 2020 05:02:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqzp+6kG79EG3wtgSuQFs/Xpq7Y1C/dKtm3Potgr/5etRMRqJSu2nVqLFDrEnuwb0vspTPbt8g==
X-Received: by 2002:a05:6000:1142:: with SMTP id d2mr4688896wrx.62.1582894933882;
        Fri, 28 Feb 2020 05:02:13 -0800 (PST)
Received: from [192.168.178.40] ([151.20.130.54])
        by smtp.gmail.com with ESMTPSA id t3sm12316069wrx.38.2020.02.28.05.02.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 05:02:13 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 2/7] pci: use uint32_t for unsigned long
 values
To:     Andrew Jones <drjones@redhat.com>
Cc:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org,
        oupton@google.com
References: <20200226074427.169684-1-morbo@google.com>
 <20200226094433.210968-1-morbo@google.com>
 <20200226094433.210968-4-morbo@google.com>
 <91b0fdf5-a948-ef61-8b05-1c5757937521@redhat.com>
 <20200228124657.aqgrty74dbki6d4g@kamzik.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c025bd4c-b390-0b8e-f788-dc01ba0040f1@redhat.com>
Date:   Fri, 28 Feb 2020 14:02:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200228124657.aqgrty74dbki6d4g@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/02/20 13:46, Andrew Jones wrote:
> On Fri, Feb 28, 2020 at 12:04:38PM +0100, Paolo Bonzini wrote:
>> On 26/02/20 10:44, Bill Wendling wrote:
>>> The "pci_bar_*" functions use 64-bit masks, but the results are assigned
>>> to 32-bit variables. Use 32-bit masks, since we're interested only in
>>> the least significant 4-bits.
>>>
>>> Signed-off-by: Bill Wendling <morbo@google.com>
>>> ---
>>>  lib/linux/pci_regs.h | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/lib/linux/pci_regs.h b/lib/linux/pci_regs.h
>>> index 1becea8..3bc2b92 100644
>>> --- a/lib/linux/pci_regs.h
>>> +++ b/lib/linux/pci_regs.h
>>> @@ -96,8 +96,8 @@
>>>  #define  PCI_BASE_ADDRESS_MEM_TYPE_1M	0x02	/* Below 1M [obsolete] */
>>>  #define  PCI_BASE_ADDRESS_MEM_TYPE_64	0x04	/* 64 bit address */
>>>  #define  PCI_BASE_ADDRESS_MEM_PREFETCH	0x08	/* prefetchable? */
>>> -#define  PCI_BASE_ADDRESS_MEM_MASK	(~0x0fUL)
>>> -#define  PCI_BASE_ADDRESS_IO_MASK	(~0x03UL)
>>> +#define  PCI_BASE_ADDRESS_MEM_MASK	(~0x0fU)
>>> +#define  PCI_BASE_ADDRESS_IO_MASK	(~0x03U)
>>>  /* bit 1 is reserved if address_space = 1 */
>>>  
>>>  /* Header type 0 (normal devices) */
>>>
>>
>> Removing the "U" is even better because it will then sign-extend
>> automatically.
>>
> 
> We don't want this patch at all though. We shouldn't change pci_regs.h
> since it comes from linux and someday we may update again and lose
> any changes we make. We should change how these masks are used instead.

I will try to get the change into Linux.

Paolo


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B6543554B
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 23:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhJTVds (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 17:33:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42050 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229695AbhJTVdq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 17:33:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634765491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aYMDXU7N1W2/86HQjpNbIN2cQpsLJIkwhXqsVW818sI=;
        b=BCxurt5IrCfRyeB6fd5ilziWJacmcS9ikNfxDapkkYv/H+cLv9eQU0QPdgGCv50v+gY536
        UDg/lyaFd4rrXbHeN06UpgpcRVI6VxD+vfFygceKh65/qbwqOdG65PqdGcVbfHWQsCz6PX
        aobU2/Voacw1/KU9mQZpWflIQ7F2Flw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-94zR3zwlPQ2SFQHDWkdEHA-1; Wed, 20 Oct 2021 17:31:30 -0400
X-MC-Unique: 94zR3zwlPQ2SFQHDWkdEHA-1
Received: by mail-wr1-f70.google.com with SMTP id l8-20020a5d6d88000000b001611b5de796so10481332wrs.10
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 14:31:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aYMDXU7N1W2/86HQjpNbIN2cQpsLJIkwhXqsVW818sI=;
        b=7lk9DU1KQcgzsvd+b+AOH5N0+tRFs3RpcgwjaDZ20VUciJddS+XCwPdCenMUrYWo0f
         oAD3gB3KmHCCZ321Xnzhhe4nJL688JDXonJP2alw8czgw2JvFdfrVO6VkcluctrFVvMd
         nRNop5p7c5gPPSnfYrStFAKT3wtub9DCArb63E0Lm1aW1eZ8oK7VG0PF5Wm50CHxYZXr
         I2TUf1tvwYrqupDyfvkTZZFiEk0caWJ2nPN8bePCkf1i3hhwFf2U+T89ov0VgqRgpBF9
         IJEkUr1xkL6erupsxs26zRya59sfZLPojCW4+F8qWckYLr+bZxUDq4PudYh/OX3OQ1P9
         YIwQ==
X-Gm-Message-State: AOAM530dLhl+jbwaJksscVSyG8/QOsvnlSNc2/AqX2/YtTLfSs25FIAA
        YsUVBSVL2om/i2+klQv+8OCMYyK9r7IHPKl4PYArKdkSt4x/UulS+kJXjsThM9HVIDSWN9Pzsj8
        +UJM/Ih7HwnYs
X-Received: by 2002:a05:600c:b44:: with SMTP id k4mr1432956wmr.57.1634765489058;
        Wed, 20 Oct 2021 14:31:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwaWICrEbIO5xmHssmYXsIywYmeIItYgZtKnyewBdkf9UT5aHpAlYpnwr3uaUyYnec1cggJyg==
X-Received: by 2002:a05:600c:b44:: with SMTP id k4mr1432936wmr.57.1634765488831;
        Wed, 20 Oct 2021 14:31:28 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id l40sm3189628wms.31.2021.10.20.14.31.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 14:31:28 -0700 (PDT)
Message-ID: <9f5e4bae-1400-3c49-d889-66de805bc1c2@redhat.com>
Date:   Wed, 20 Oct 2021 23:31:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 kvm-unit-tests 2/2] replace tss_descr global with a
 function
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, zxwang42@gmail.com, marcorr@google.com,
        seanjc@google.com, jroedel@suse.de, varad.gautam@suse.com
References: <20211020192732.960782-1-pbonzini@redhat.com>
 <20211020192732.960782-3-pbonzini@redhat.com>
 <CALMp9eTbehPFGb2UTDiV8Q7zo6O9_Dq39=V_DdcQKG3-ev1_8w@mail.gmail.com>
 <0a87132a-f7ea-5483-dd9d-cb8c377af535@redhat.com>
 <CALMp9eRY_YYozTv0EZb5rbr27TJihaW3SpxV-Be=JJt2HYaTYQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALMp9eRY_YYozTv0EZb5rbr27TJihaW3SpxV-Be=JJt2HYaTYQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/10/21 23:18, Jim Mattson wrote:
>>>> -       vmcs_write(GUEST_LIMIT_TR, tss_descr.limit);
>>>> +       vmcs_write(GUEST_LIMIT_TR, 0x67);
>>> Isn't the limit still set to 0xFFFF in {cstart,cstart64}.S? And
>>> doesn't the VMware backdoor test assume there's room for an I/O
>>> permission bitmap?
>>>
>> Yes, but this is just for L2.  The host TR limit is restored to 0x67 on
>> every vmexit, and it seemed weird to run L1 and L2 with different limits.
> Perhaps you could change the limits in the GDT entries to match?

So keep it 0x67 and adjust it to the size of the IOPM in the VMware 
backdoor test?

Paolo


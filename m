Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29D51DCE41
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 15:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729431AbgEUNgn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 May 2020 09:36:43 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22678 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726856AbgEUNgn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 May 2020 09:36:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590068202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/siY53tjkun6MuLncCOGE+QWvInBPs5eGByYgtd/XlU=;
        b=OzHOPPDYYz6jkzJDPm67a+5+InvQOGmrSQN3hNtsLj1HAJUsoTViWM8Fki1vz91NOrVcaX
        aqG2aNyEmRKjk5ycb3jbG/9/hYJHcx05DX+MMFVNHea4JZI1cpYlmPwE2yKWSDotXQDWuh
        tlB44fC7ygM3Di4Og3x69ovfvMekP8g=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-P8jfwJuZOVSQpRt0hclf9w-1; Thu, 21 May 2020 09:36:40 -0400
X-MC-Unique: P8jfwJuZOVSQpRt0hclf9w-1
Received: by mail-wm1-f69.google.com with SMTP id n66so2709934wme.4
        for <kvm@vger.kernel.org>; Thu, 21 May 2020 06:36:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/siY53tjkun6MuLncCOGE+QWvInBPs5eGByYgtd/XlU=;
        b=Alqnn5cLsN5GSyk38kG4doQlTpfQ8eezq80tlIA6Fb2q0IELUuulZ1aqtRwnaevF3T
         HOUAvZO6LHTpwMn98gxAZNA7ZSzmdvxEHwTZxpg9c0TsRx+X+GJIRQniPST64QjK9GvB
         mq7pjBiik9L5cobRWpUD+t9jCoMBdk5NVVGheUxTguLSYHYVIVQsrmWdTu7Y9kli6ZOd
         YMSRFZaoO03ISQfHjOZFK9+B7ohBAKZwrnkT2Xxlohfj19all2UdKIHNKr9RUoAYGnU9
         sgT72ycjps6oCXvQxhMW5NIHFz48hLGGMDnwY2v41cXbSs5br/cTP0V/6JuEJI1PKMtP
         AQGQ==
X-Gm-Message-State: AOAM530krmsTWwPVX7ZP1Jp4B3F2xKpg934DvjqXuCRxOm/NFmEMwdPY
        R+p3XvJtaqOiTq8/IJ8huzGPSAZL26MxjrpDmDlDDuaqtGiZmIoySFdJaDoYj6VvOVXDaLYB3ox
        fp224F33Oc/dh
X-Received: by 2002:a5d:560c:: with SMTP id l12mr8376245wrv.309.1590068198820;
        Thu, 21 May 2020 06:36:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxeIwRP/CqWrfPTPPPgHp/nwnuQ1RJeRbxx6qoua72G1WzxTHQr3LB6Ba62DOfYsQHz+Q0nXQ==
X-Received: by 2002:a5d:560c:: with SMTP id l12mr8376228wrv.309.1590068198484;
        Thu, 21 May 2020 06:36:38 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.94.134])
        by smtp.gmail.com with ESMTPSA id c19sm6723507wrb.89.2020.05.21.06.36.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2020 06:36:37 -0700 (PDT)
Subject: Re: [PATCH v3] kvm/x86 : Remove redundant function implement
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        =?UTF-8?B?5b2t5rWpKFJpY2hhcmQp?= <richard.peng@oppo.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <HKAPR02MB4291D5926EA10B8BFE9EA0D3E0B70@HKAPR02MB4291.apcprd02.prod.outlook.com>
 <87h7w9skmr.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <629b1ca1-66a3-f616-71a9-3fda3b03aeb4@redhat.com>
Date:   Thu, 21 May 2020 15:36:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87h7w9skmr.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/05/20 11:27, Vitaly Kuznetsov wrote:
> 彭浩(Richard) <richard.peng@oppo.com> writes:
> 
>> pic_in_kernel(),ioapic_in_kernel() and irqchip_kernel() have the
>> same implementation.
> 'pic_in_kernel()' name is misleading, one may think this is about lapic
> and it's not. Also, ioapic_in_kernel() doesn't have that many users, can
> we maybe converge on using irqchip_*() functions everywhere?
> 

Richard's patch was my recommendation actually.

PIC is not the LAPIC and not the IOAPIC; even though right now the
implementation is the same for pic_in_kernel and ioapic_in_kernel and
irqchip_kernel(), that's more or less an implementation detail.

Paolo


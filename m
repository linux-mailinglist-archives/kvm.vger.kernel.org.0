Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9910C146E21
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 17:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgAWQPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 11:15:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55085 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726621AbgAWQPp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 11:15:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579796144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LO9HhCH9mekw8t8sXZ6dnKaj/lewjwaqZGKpjYdQs98=;
        b=Tjq0WW4ACzpWdzAtwJmbVpVy0ZXmQt0U8mIyxdQGKfUddHqdyoAEYvBhna39R1N5d4Q/gy
        Df601gFZzASbIVUGOz49FpPvfTjfRiVOykur4Ib6ittOag4qp3xRE/wHF2k+Nme9OUQqQZ
        3G79HkWZPOdG8DNVk02VGLm4o9xo7q8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-3NbOM0XIMvyAPihv0NIIsQ-1; Thu, 23 Jan 2020 11:15:42 -0500
X-MC-Unique: 3NbOM0XIMvyAPihv0NIIsQ-1
Received: by mail-wr1-f70.google.com with SMTP id z14so2073670wrs.4
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2020 08:15:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LO9HhCH9mekw8t8sXZ6dnKaj/lewjwaqZGKpjYdQs98=;
        b=pLd5VFUdwcrqT7uVlbPkfPLEBp+6w2TJS5auHikpuH5iOGMpzy7vS9tE+QtmWJA+Kl
         +XlCfS0BuMOTaEmvHkuiJxbLjVonazwjaJQ6txGIEmRv9DV16isWDwChQk5Rs9Onal/a
         hh1HZpZkY15qOEoMUfm3IRSbawVKfLQHgwEnlSBZd/Ca5Rd2qnClwIKn3bDS9P97b2cY
         dpUnIuDjcGCMUL2+r6qACtzhhg/fYVPntgJaC89AUdFDCqo1HlaXfjoAQEmXfl/GE3/Q
         Te2r1JNdb0VcLu9ubDnd9fYKLsDdEA8rJau/wIXzemkjnzTx+XQZp8u/yRvtfGIbT7UH
         djMA==
X-Gm-Message-State: APjAAAXo4Ygti8buirrFo30Xzyjfi+wYaYzlaY9W5u+krvVG5Hm9z0dA
        Js29Sr0wh8NnANnQZye/YGOoOVX/nJ8E3hw8ahG3vYLmGm26648vTPFU0+VCwtjK2xRamuGdgmz
        OLrj9HeFz05A5
X-Received: by 2002:adf:c145:: with SMTP id w5mr18813491wre.205.1579796140755;
        Thu, 23 Jan 2020 08:15:40 -0800 (PST)
X-Google-Smtp-Source: APXvYqx0O23/GNxqaJIeQkBBuwpsVC0lW7ArY0OQtINN4T8QACMLvQkdqn6ejRkCh2gWX98lOdEczA==
X-Received: by 2002:adf:c145:: with SMTP id w5mr18813466wre.205.1579796140546;
        Thu, 23 Jan 2020 08:15:40 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id n8sm3580132wrx.42.2020.01.23.08.15.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 08:15:40 -0800 (PST)
Subject: Re: [PATCH 2/2] kvm: Add ioctl for gathering debug counters
To:     milanpa@amazon.com, Alexander Graf <graf@amazon.de>,
        Milan Pandurov <milanpa@amazon.de>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, borntraeger@de.ibm.com
References: <20200115134303.30668-1-milanpa@amazon.de>
 <18820df0-273a-9592-5018-c50a85a75205@amazon.de>
 <8584d6c2-323c-14e2-39c0-21a47a91bbda@amazon.com>
 <ab84ee05-7e2b-e0cc-6994-fc485012a51a@amazon.de>
 <668ea6d3-06ae-4586-9818-cdea094419fe@redhat.com>
 <e77a2477-6010-ae1d-0afd-0c5498ba2117@amazon.de>
 <30358a22-084c-6b0b-ae67-acfb7e69ba8e@amazon.com>
 <7f206904-be2b-7901-1a88-37ed033b4de3@amazon.de>
 <7e6093f1-1d80-8278-c843-b4425ce098bf@redhat.com>
 <6f13c197-b242-90a5-3f53-b75aa8a0e5aa@amazon.de>
 <b69546be-a25c-bbea-7e37-c07f019dcf85@redhat.com>
 <c3b61fff-b40e-07f8-03c4-b177fbaab1a3@amazon.de>
 <3d3d9374-a92b-0be0-1d6c-82b39fe7ef16@redhat.com>
 <25821210-50c4-93f4-2daf-5b572f0bcf31@amazon.de>
 <2e2cd423-ab6c-87ec-b856-2c7ca191d809@redhat.com>
 <01dc5863-91b4-6ee0-2985-8c2bf41e73e9@amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f71763ad-2336-0436-39fc-bb476b559eee@redhat.com>
Date:   Thu, 23 Jan 2020 17:15:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <01dc5863-91b4-6ee0-2985-8c2bf41e73e9@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/01/20 16:27, milanpa@amazon.com wrote:
>>
>>
>> Paolo
>>
> I agree, extending the API with GET_AVAILABLE_ONE_REGS (and possibly a
> bitmask argument to narrow down which type of registers userspace is
> interested in) is a clean solution. We won't require userspace to rely
> on constants in compile time if it doesn't need to.
> 
> Only concern is that now we need to have some kind of datastructure for
> keeping the mappings between all available ONE_REG IDs and their
> strings/descriptions. Additionally enforcing that newly added ONE_REGs
> always get added to that mapping, is also necessary.

For now just do the implementation for VM ONE_REGs.  We'll worry about
the existing VCPU registers later.

Paolo


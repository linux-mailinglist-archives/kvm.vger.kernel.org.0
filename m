Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA8337BEDF
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 15:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhELNw4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 09:52:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24561 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230347AbhELNwz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 May 2021 09:52:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620827506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hGtfPQ8bGGwrEI29kVoqsA6RSq1vPvN9kmTVPINf3V0=;
        b=AnGclM5wdHiemmW1vT2yWHUJ1LBtLzvY0zqu0GciKaRi2p/44yhgBgMtF5sCHDp5ES1CJa
        Qi7snz3GEQc3poE9/CNp1aoSDxzV5VfVqRgVJaYcWNKGx6XsXvfYbl/gJquneh8ADFrZTN
        PhXwGV+9MK6D0a1Marnqiue1NjkRDv8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-dX24zYanNEqD0ALHfw_puw-1; Wed, 12 May 2021 09:51:45 -0400
X-MC-Unique: dX24zYanNEqD0ALHfw_puw-1
Received: by mail-ej1-f70.google.com with SMTP id z6-20020a17090665c6b02903700252d1ccso7169669ejn.10
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 06:51:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hGtfPQ8bGGwrEI29kVoqsA6RSq1vPvN9kmTVPINf3V0=;
        b=lsR3cR8DKM3mALTCehgZsIy9YhfF3B6zfeHBiUU1mbXC3e31A25DHG4P55wjSA5fyk
         j5Wlkn5WFR6DqHTfqaCYx52OnBQH2nfO5cERgR50aJnQDFgM/W9TsFqPxoT/LrX+Q8K+
         gj0OPT1PQ3I6qRkNMyX+Uq2lrAV3EU8JDzlGbaTqh5oiK8+VmpeyzzAOKaKzJk8NlNcP
         OC11GofGVhoEaN5zljOFzvo2GWptiipsr49WbC7gBtWqLJZHOdRvYjMBJu7im3BWCaEG
         0eLmhNxEGVwzgx4xe18vQdcanNT5Q6jqg+ye3D4+B5YcjzjIZ5sybScoIoMy0BHsvExA
         W2zg==
X-Gm-Message-State: AOAM530nC5PH1KUamoTcRDMHOglkIszmIAG1O3XuoKhMPoDO7J7PupF1
        h6SXJmdUG5w2iPXBJCZyYbKJNM5p0YxhDayrju9WfEpEUapRc+6mHGFXEcdZHhytYRbzgJ1oPDz
        O2lBwtUJ9TwLz8RopGz/zbqVplxCi2/MUdB0iYeteIZabqNFF1/uarWKgyRjYvOEl
X-Received: by 2002:a50:fc99:: with SMTP id f25mr44216208edq.147.1620827502817;
        Wed, 12 May 2021 06:51:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3peCjOlPzPyprCGcFXw/UHqTB6I64tRVTgLMI91qT9rmIcIFkNiWrrS2Thp2wGE9qPtt/jg==
X-Received: by 2002:a50:fc99:: with SMTP id f25mr44216180edq.147.1620827502552;
        Wed, 12 May 2021 06:51:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id bw26sm14278344ejb.119.2021.05.12.06.51.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 06:51:42 -0700 (PDT)
Subject: Re: [PATCH v2 kvm-unit-tests 2/2] arm: add eabi version of 64-bit
 division functions
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
References: <20210512105440.748153-1-pbonzini@redhat.com>
 <20210512105440.748153-3-pbonzini@redhat.com>
 <e1aa58da-c4c9-6bb0-3aef-f17c12349577@arm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2d068920-26c2-610c-c27d-b693e406b180@redhat.com>
Date:   Wed, 12 May 2021 15:51:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <e1aa58da-c4c9-6bb0-3aef-f17c12349577@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/05/21 15:44, Alexandru Elisei wrote:
>> +	bl	__udivmoddi4
>> +	ldr	r2, [sp, #8]             // remainder returned in r2-r3
>> +	ldr	r3, [sp, #12]
>> +	add	sp, sp, #16
>> +	pop	{r11, pc}
> 
> I'm not sure what is going on here. Is the function returning 2 64bit arguments as
> an 128bit vector? Or is the function being called from assembly and this is a
> convention between it and the caller?

It's an eABI convention that spans the runtime and the compiler.

https://developer.arm.com/documentation/ihi0043/e/?lang=en#standardized-compiler-helper-functions 
says it returns a "pair of (unsigned) long longs is returned in {{r0, 
r1}, {r2, r3}}, the quotient in {r0, r1}, and the remainder in {r2, r3}."

Paolo


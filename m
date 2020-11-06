Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19AA2A9567
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 12:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgKFLaD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 06:30:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57439 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726565AbgKFLaC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 06:30:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604662201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z4Dc2EDUcDt8sMcSRnOSCnAN6/ShWvCOK9nzEVZEmSg=;
        b=GQTjcaTgX3XNGfdr0hxjM5G+/tOfzaDsppokXxg40My33V4ZB3BTQlXwvgIasgZGn6MsVs
        4MbQSiPuAcvJTBEmaY1LFLt9hWE2+CuJcBujbcC/Hk5paUeVvyO0noyNbwd4TVZ6C2qfWp
        baOAsYGl1etbq3nD7DOfO/8RqBeJYSE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-Z6gp-hEcNgCzewplO-W2RQ-1; Fri, 06 Nov 2020 06:30:00 -0500
X-MC-Unique: Z6gp-hEcNgCzewplO-W2RQ-1
Received: by mail-wr1-f70.google.com with SMTP id j15so362161wrd.16
        for <kvm@vger.kernel.org>; Fri, 06 Nov 2020 03:29:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z4Dc2EDUcDt8sMcSRnOSCnAN6/ShWvCOK9nzEVZEmSg=;
        b=BAKTFZlJSWT/Bi0dL5p8y8eZSepBrxiJkw00PBLrB7ni9b5LWGklOGayCu/sYYfHay
         lQJwpfWXtah1yCHnYFOU7fO7SRNhCCFTMtdkC4f+vuf0gfU0UneeK5CC/yxmt8XiUw6b
         1qPFkfhxE0a/Ml7Szy6laQqvIilQOqK7VxmqZ4JSgeEjNjvrD+52y8Cs37r6HpLQS9BA
         WBA5kzwnSz+VGk3Jm5/kDQldyUwE4V5leNZPgpZmzO5oTf25oEyXgmmRfKlC1ZYMPLPl
         Ze4BIqC468P0i+L3PRU3Q7UIY2ST5JLJtlP0vcswRvRLjEtXkZwXbBxSJ9l7ZhpDZ+fC
         li4g==
X-Gm-Message-State: AOAM530KRhuLVAVYqL+chl9GZ1PyZ96sBRI9TFw0l1urnngnwBDEw2xq
        0ev8jSpiTHn9hs6TqNXsdP/gzKGinhvULpD90TkjzkrLGT0CqFYF5NMn2P4wBzzbj549u8GSno9
        1ru80YgkW/w5R
X-Received: by 2002:a05:600c:4147:: with SMTP id h7mr1918329wmm.186.1604662198961;
        Fri, 06 Nov 2020 03:29:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz1Hj6UNLB0i8/BP+9y8n+rsSI7AC262P+aNiOYsnmdIHe2BHGh3xW9jjUqpyF50L6FUiUu2w==
X-Received: by 2002:a05:600c:4147:: with SMTP id h7mr1918302wmm.186.1604662198747;
        Fri, 06 Nov 2020 03:29:58 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id w1sm1642255wro.44.2020.11.06.03.29.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 03:29:58 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v2 1/7] lib/list: Add double linked list
 management functions
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
 <20201002154420.292134-2-imbrenda@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <efd594c1-a540-6f7a-537e-7e53815d4e01@redhat.com>
Date:   Fri, 6 Nov 2020 12:29:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201002154420.292134-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/20 17:44, Claudio Imbrenda wrote:
> +#include <stdbool.h>
> +
> +/*
> + * Simple double linked list. The pointer to the list is a list item itself,
> + * like in the kernel implementation.

More precisely, *circular* doubly-linked list.  Just a minor note. :)

Paolo


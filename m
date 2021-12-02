Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A8446624A
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 12:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345845AbhLBL3r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 06:29:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54553 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241462AbhLBL3o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Dec 2021 06:29:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638444382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lDz7Gl7O/a6QxEzSyH8lRwP13RtbZV0kax667QfBu/c=;
        b=EF9rm+keEA60ywDxV1dna3wR2KkANUzHGCsw65kDpGAoU6QDqFBXtu+MsjI7HcYu3G4XYg
        XZ1mgKSGuS1GWeGHBNFhN4LGNpGSOZI35q1P4dsnET4TmUKQ8xplT1Z4QqkildXyMaGYJ+
        3aG+dm/ZOfGKWrRFzXHvVhW4vje6L7I=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-arAzDW3xNzSXdtg9MXmVIQ-1; Thu, 02 Dec 2021 06:26:21 -0500
X-MC-Unique: arAzDW3xNzSXdtg9MXmVIQ-1
Received: by mail-wr1-f69.google.com with SMTP id v18-20020a5d5912000000b001815910d2c0so4941933wrd.1
        for <kvm@vger.kernel.org>; Thu, 02 Dec 2021 03:26:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:organization:in-reply-to
         :content-transfer-encoding;
        bh=lDz7Gl7O/a6QxEzSyH8lRwP13RtbZV0kax667QfBu/c=;
        b=Drc3EJMUZU9L4WtcgdOaB5sPst8HZQpQjw0DhHa79fukTygaA8WgKjFc7hYs2x6qRu
         uBH8Wb42EoCso5PpTNoFD40G5ArRg15/3yqq5FuKgRsjkbXeUT0BbbrhioFJuD8sPdGR
         Wu4okbx7sikxhDRpO0M7Tav9A5qowfr3gh7DSoyukfOs0h9fxe+M8OYGXcBfIFe+0IhY
         617wtFELGP/gt+CEJpjnzxU4JYwvuimRTLa19BxTKbGC5p4EV9cpQsDZvFM8gTymMEpW
         SDZ9+4Gwprs6ajqM7rR/rO5K0I8/O/FwDKFc4z36Qo+ol0AMsFBO3oc+4WplZs7DFN4d
         tfkA==
X-Gm-Message-State: AOAM532s2Rdm7GoU00y2MoC0K1xNrYpJzcuZK8HpYadHXU63zI7ehbsd
        gk8UW9TC5OtVlyykiOSo3XibY9PZ9LRV4RzLvVwS+ryRImLEDMi8Qkj7yxrhJIkzaXzvKqK4RMk
        l1xluKA3FQPnu
X-Received: by 2002:a05:600c:202:: with SMTP id 2mr5681811wmi.134.1638444380196;
        Thu, 02 Dec 2021 03:26:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxMDm2ZHgmwsMQE5O2JaJyj6R5MG6Z9006cnJBbuG9m6i0+3MgupmDqot5W08j+xUfC3Vawig==
X-Received: by 2002:a05:600c:202:: with SMTP id 2mr5681780wmi.134.1638444379976;
        Thu, 02 Dec 2021 03:26:19 -0800 (PST)
Received: from ?IPV6:2003:d8:2f44:9200:3344:447e:353c:bf0b? (p200300d82f4492003344447e353cbf0b.dip0.t-ipconnect.de. [2003:d8:2f44:9200:3344:447e:353c:bf0b])
        by smtp.gmail.com with ESMTPSA id j11sm2402688wrt.3.2021.12.02.03.26.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 03:26:19 -0800 (PST)
Message-ID: <ea6ec055-2682-44b1-2aae-20dfcebf9b85@redhat.com>
Date:   Thu, 2 Dec 2021 12:26:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x: firq: floating interrupt
 test
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sebastian Mitterle <smitterl@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org
References: <20211202095843.41162-1-david@redhat.com>
 <20211202095843.41162-3-david@redhat.com>
 <20211202120113.2dd279a8@p-imbrenda>
 <95160439-2aa9-765f-9f06-16952e42a495@redhat.com>
Organization: Red Hat
In-Reply-To: <95160439-2aa9-765f-9f06-16952e42a495@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02.12.21 12:13, David Hildenbrand wrote:
>>> +static void wait_for_sclp_int(void)
>>> +{
>>> +	/* Enable SCLP interrupts on this CPU only. */
>>> +	ctl_set_bit(0, CTL0_SERVICE_SIGNAL);
>>> +
>>> +	set_flag(1);
>>
>> why not just WRITE_ONCE/READ_ONCE?
> 
> Because I shamelessly copied that from s390x/smp.c ;)

Oh, and also because WRITE_ONCE/READ_ONCE are semantically the wrong
thing to use:

"Prevent the compiler from merging or refetching reads or writes. The
compiler is also forbidden from reordering successive instances of
READ_ONCE and WRITE_ONCE"

We need memory barriers to prevent reordering with surrounding code.

-- 
Thanks,

David / dhildenb


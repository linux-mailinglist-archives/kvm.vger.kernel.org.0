Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFED1B320C
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 23:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbgDUVp7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 17:45:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43039 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726061AbgDUVp6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 17:45:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587505557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hrPqSHzvDqHMhPjGbnbzUJQXRgekl0cm+3+Jn2/BimY=;
        b=S7zywpEMd7LEqFHACldR0UmYKqhAVgxcOOIZuUkbC0818+3Qms+c2mRTXy0/JTGC9gx1Sk
        AoBCXT6yWFNJkl9Y2ER3A+VkuAvq2JguC2LuMd6LCMgCLzmuqGDzW4JXJ4bXIVrFcrOs1h
        9E0JAGMf17J72kgtlo05TgNbyzk5upw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-JFZCpB3SPRmfdN4LxqqkgA-1; Tue, 21 Apr 2020 17:45:55 -0400
X-MC-Unique: JFZCpB3SPRmfdN4LxqqkgA-1
Received: by mail-wr1-f71.google.com with SMTP id r11so8432398wrx.21
        for <kvm@vger.kernel.org>; Tue, 21 Apr 2020 14:45:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hrPqSHzvDqHMhPjGbnbzUJQXRgekl0cm+3+Jn2/BimY=;
        b=ab396y9APq26WLvlqkBF5Ib1fGyqF4qR1UeCu4ZkH5NyxYngIA/bihKDYocFf3fd83
         yIAaOKBwd5ri8VGoUGc357UwypgkbTkLkuKqsav24ZLtj7U4snYW+UpJDKT6uHL4sdVq
         EsGYYZiQequoRi1MXEdi+d2KG2IPHPnZvHqNDMPqwiZV4v3TvtSXd8iLLJcwH/kR32TQ
         qoqHnrfgTQOsWVPfTYDcMbRzkF/BLCV1TRXB54o5WRu+AFhH9dSPCaO/7eZ0FfL+2iDT
         NrGKI7WiWYVYaPGxi9u517NYV7B6+tSUw8nZgee3NDr3d0GwXMQQIz4QK93q2+ayViX8
         wDQA==
X-Gm-Message-State: AGi0Pua+nGrMvCofbhIm5XrcjjOp4w+z3iB8NLKRj2+zReOB/7NysIG3
        54arcNPpFZa8IQvypHONwVhy0pi9RY9VLJ3AdHhsEbc54tJlhA4sl4eYkeWhpjuWKs7I4hCu3xt
        6BZrkD+Hkpg/j
X-Received: by 2002:a1c:bc05:: with SMTP id m5mr6487217wmf.143.1587505554206;
        Tue, 21 Apr 2020 14:45:54 -0700 (PDT)
X-Google-Smtp-Source: APiQypKxMSa7I7p8Lu5YsI0+4oCtBwBPlOn5btcgzQhE21NXEYuoD2a64Zx/AKYlzP5XHQXGdM+iIA==
X-Received: by 2002:a1c:bc05:: with SMTP id m5mr6487200wmf.143.1587505553982;
        Tue, 21 Apr 2020 14:45:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f43b:97b2:4c89:7446? ([2001:b07:6468:f312:f43b:97b2:4c89:7446])
        by smtp.gmail.com with ESMTPSA id q187sm4918951wma.41.2020.04.21.14.45.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 14:45:53 -0700 (PDT)
Subject: Re: [PATCH v1 01/15] nitro_enclaves: Add ioctl interface definition
To:     Randy Dunlap <rdunlap@infradead.org>,
        Andra Paraschiv <andraprs@amazon.com>,
        linux-kernel@vger.kernel.org
Cc:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>, Balbir Singh <sblbir@amazon.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com
References: <20200421184150.68011-1-andraprs@amazon.com>
 <20200421184150.68011-2-andraprs@amazon.com>
 <7e0cb729-60ca-3b2e-909b-8883b24908a8@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <716e0cfb-fa4a-5fc5-f198-6574fa8dc046@redhat.com>
Date:   Tue, 21 Apr 2020 23:45:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <7e0cb729-60ca-3b2e-909b-8883b24908a8@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/04/20 20:47, Randy Dunlap wrote:
>> +
>> +/**
>> + * The command is used to trigger enclave start after the enclave resources,
>> + * such as memory and CPU, have been set.
>> + *
>> + * The enclave start metadata is an in / out data structure. It includes
>> + * provided info by the caller - enclave cid and flags - and returns the
>> + * slot uid and the cid (if input cid is 0).
>> + */
>> +#define NE_ENCLAVE_START _IOWR('B', 0x1, struct enclave_start_metadata)
> Please document ioctl major ('B' in this case) and range used in
> Documentation/userspace-api/ioctl/ioctl-number.rst.
> 

Since it's really just a couple ioctls, I can "donate" part of the KVM
space, for example major 0xAE minor 0x20-0x3f.

Paolo


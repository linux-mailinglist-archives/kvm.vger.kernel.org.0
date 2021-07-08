Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF2CE3C17AD
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 19:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhGHREb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 13:04:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31571 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229580AbhGHREa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Jul 2021 13:04:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625763708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qrTw81pAWG02uTbPb7XSSF4Zb1NaxCpE5fYNmmLl5pU=;
        b=M9ppLJYDetXbse+Aw8sevBjyc9KGwAf01JXaHk7C/W3IbbCaD4Mct5/mbzfZTz+dr0WHZh
        /UswW9rAqHRxRSRoPahdXMRJTR3zsh36icxkQEYc7qh9U1Tio0jQiC+2/hYDdESFmrvvN+
        1mipZ3GeLbljrSdojNp+w3gVIkvsDKg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-Pi4VFvcBPNeWD3fTJ3RCTA-1; Thu, 08 Jul 2021 13:01:47 -0400
X-MC-Unique: Pi4VFvcBPNeWD3fTJ3RCTA-1
Received: by mail-ed1-f71.google.com with SMTP id o8-20020aa7dd480000b02903954c05c938so3661879edw.3
        for <kvm@vger.kernel.org>; Thu, 08 Jul 2021 10:01:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qrTw81pAWG02uTbPb7XSSF4Zb1NaxCpE5fYNmmLl5pU=;
        b=ierkhg/XDojPu+Y4SXRbohNQfNPeHxms3oAskkipkGlmmaeEUo/bMhmPx1TO/Drgd0
         WUfSEshZ8e1E9EYYsb42BFsmDhg1VTJdrdOYxRxu6IhTH/0j25ic47pE+DX8eB4S3YKF
         UhV5D/SUVMiE5AZjKp2UmsePslsWcqdFXqcJ9Vg/5Z/Fjh4NBdksC8iwkHC1A2XpqfQf
         W2fofl2Y/0sgK+EsZ5ouK3zal++KKedbITCty+Cn/TWjEbIhdy+wZ/dAOylqAwFhCoZE
         mjhTk2ScLP2vtBEx/oJbIW0+WlNDBfSw/EE6Q3sb6z/rGIIJc7gYtwynSCFAZucJPu5W
         +LMQ==
X-Gm-Message-State: AOAM531HlnCT5XCcKbrcEwpuVk6DrGIBBRIq6TrQLwd4XyydRDRkp+js
        0O8DWBmioubpd0ceImZfRXiUKHtYxP+wDVzeeVBdplg1KSpQsktSLOTFTdnzUlzckixfFn3svxQ
        ykhZDOzHBcf2N
X-Received: by 2002:aa7:d84a:: with SMTP id f10mr5208312eds.45.1625763706078;
        Thu, 08 Jul 2021 10:01:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxTIJoVBFYN0UNaZ4TmCId++KAC/jy/ikyGen2oMBIt7ifi7GkPOYCPc1N8fllDzrANAf21Pg==
X-Received: by 2002:aa7:d84a:: with SMTP id f10mr5208290eds.45.1625763705950;
        Thu, 08 Jul 2021 10:01:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id jl10sm1231007ejc.56.2021.07.08.10.01.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 10:01:45 -0700 (PDT)
Subject: Re: [GIT PULL 0/2] KVM: selftests: Fixes for 5.14
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20210706083626.10941-1-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d23a0180-8560-b50d-6dfe-17ee24400794@redhat.com>
Date:   Thu, 8 Jul 2021 19:01:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210706083626.10941-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/07/21 10:36, Christian Borntraeger wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-master-5.14-1

Pulled, thanks.

Paolo


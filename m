Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867A144D4DE
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 11:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbhKKKRs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 05:17:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35393 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229668AbhKKKRr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 05:17:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636625698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S6uLPKDqybSu7Fq7/4bbc9+ZGKFbryIRKLHIHdtT3Fo=;
        b=MVb1QDBWn1vBg36kzcgwXjow0u7ENGNWCbtSiD8VxOMP0RYvfDNGu8Meo9RDtjLubM88ji
        XBxIZ0mp9kyEtPbamwsKRPSbYm3AgREJ2qLP7iiV/1Nk3glmAi/gYrOYeX0mNU8z3V4H89
        nqIbRs8+Fm6W9/HPOY+JEdI8ZqcEzL4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-Y2kAwoUuPlKgGljN-4dkWQ-1; Thu, 11 Nov 2021 05:14:56 -0500
X-MC-Unique: Y2kAwoUuPlKgGljN-4dkWQ-1
Received: by mail-wm1-f69.google.com with SMTP id l187-20020a1c25c4000000b0030da46b76daso4536784wml.9
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 02:14:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=S6uLPKDqybSu7Fq7/4bbc9+ZGKFbryIRKLHIHdtT3Fo=;
        b=jaxmG0y49RSFVkmD5sapNK//MbgJRfBmJUwoQ9UTzOyIZrQjVjyKmZs+KH7F7eVf+W
         iFjKDBuh0vP83miVesXBpNj7tYgtwQxLPkixQ1F0zfB98TLbGyS1K1QCQypZC9EogQuC
         4iP6jVXL5ooCujQM2FA73ChkPuz3HzCrLpeIq+mgtYCDpHWRiGSVBfYZOnSl87YG537O
         WTXtzeVjWzedf3DtyAjgSXy4OjVt8k9Pxrx3Fcl/Q7PZ9XB/EKMzapJeIzp+sWEfwHOT
         pB7dreX6iYruiDiVqAhjbnGdBVA2AFnzfS07jMRY+9LL3L9JjMc1VRFsPGRBV8O2pCaO
         XqCw==
X-Gm-Message-State: AOAM533nhv9R1IA9jOrqdV4OgFLUHTRc88ZsanIdEkmc6OPu/SXjzU0Z
        UeV5+jH3TTCoR/MUP3uBWpJWUzAwKy+nmvXIzZ4zZaoSp4sFeUT0GEpXouMPiURnRhy6WXo+X5f
        nXqKXjkjeC3pD
X-Received: by 2002:a05:600c:1f19:: with SMTP id bd25mr6882301wmb.75.1636625695701;
        Thu, 11 Nov 2021 02:14:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzBNrHKgmHWGR0+83D7VSH3NXiNnC//iQeYxy4OUtCQ10rA0WfIOaRC7mFLt2sXKw2rltZXsw==
X-Received: by 2002:a05:600c:1f19:: with SMTP id bd25mr6882280wmb.75.1636625695563;
        Thu, 11 Nov 2021 02:14:55 -0800 (PST)
Received: from [192.168.3.132] (p4ff23ee8.dip0.t-ipconnect.de. [79.242.62.232])
        by smtp.gmail.com with ESMTPSA id v185sm8498685wme.35.2021.11.11.02.14.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 02:14:55 -0800 (PST)
Message-ID: <31f51c84-c7f9-8251-39a8-3ff38496ae5e@redhat.com>
Date:   Thu, 11 Nov 2021 11:14:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH v2] s390x: fixing I/O memory allocation
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <20211111100153.86088-1-pmorel@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20211111100153.86088-1-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11.11.21 11:01, Pierre Morel wrote:
> The allocator allocate pages it follows the size must be rounded
> to pages before the allocation.
> 
> Fixes: b0fe3988 "s390x: define UV compatible I/O allocation"
> 

What's the symptom of this? A failing test? Or is this just a pro-activ fix?


-- 
Thanks,

David / dhildenb


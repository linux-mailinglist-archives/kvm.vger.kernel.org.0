Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 512A93DF09F
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 16:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236738AbhHCOsG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 10:48:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50890 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236627AbhHCOrz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 10:47:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628002047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1pQpxgCQc8toiVPwyKcWNVpCFEDp3kjB+8in0NoN4Xs=;
        b=EgqGCicMjEhkE5GMHu8arPy2ugYCOlkDsDyYKx+8eJGgeInEsNqb65+NPIgijtTeiDa5DZ
        8qZ8v97dHt4bbZwilU90uBCUWYTnZyDHMaENs7PR2uE/1lkWtyeV690kbYTANRQbkFsfqV
        ZpRg+hfRe1h1w89iSMKnIfCN2bvmaww=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-pInDbY2_MbaYqaIpNU8o9A-1; Tue, 03 Aug 2021 10:47:26 -0400
X-MC-Unique: pInDbY2_MbaYqaIpNU8o9A-1
Received: by mail-wr1-f70.google.com with SMTP id d7-20020adffd870000b02901544ea2018fso4563614wrr.10
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 07:47:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1pQpxgCQc8toiVPwyKcWNVpCFEDp3kjB+8in0NoN4Xs=;
        b=EVpvavxTjHSV0n4cFg6cHLOhPph1FEhXuNRwK9cFicyXq5ocDoaOlWvuTHzyK0qWqg
         0Vr1gDSXpQMLA707EsY15Tm9j5ejdiPFgNflRHRsSR7kTx6tJv0Pke+QsiA7kNFbs9zV
         DbhhXN2TVP+bayuuJWI1qwyOQIk7qAiu0oK9/iCtcBEa0XmkA8NZEkgJ4yDDTdyTUDMZ
         14OkmGf03XQEIy2bpIdN65oOkVQ3Vzb1OHKDlvfZaYcco/DpRDgW0Sz91o+xWLA/g3Ds
         TYFw81fTL1EJkeUJxLVLWF6dPP14BEqzMBynzBgBkPTu1V8gk5XX55PjCNE1MugfxtOk
         r9Tg==
X-Gm-Message-State: AOAM530NSa7l9a0Bb8HlR8BI1wJP9WPuQtnNEJtu+LHcxDavwBeGv/Tj
        HdCC+LzCBImVd0h5x3rnZmhMJfBtPVJc0ziWTJyJ5KgLCZgLCdu0APY0rin8pJ9PJBo7U1yaSg4
        2g61GjJ7XqLuQ
X-Received: by 2002:a05:600c:1d11:: with SMTP id l17mr23386933wms.185.1628002045385;
        Tue, 03 Aug 2021 07:47:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzcBnin2htwVSVxF0E3xiuluPsaaFiY7FHl64X8ylZwe0APrrZQ5sAnWY+Tr7UhWRx/ULjnKQ==
X-Received: by 2002:a05:600c:1d11:: with SMTP id l17mr23386915wms.185.1628002045183;
        Tue, 03 Aug 2021 07:47:25 -0700 (PDT)
Received: from thuth.remote.csb (p5791d8a3.dip0.t-ipconnect.de. [87.145.216.163])
        by smtp.gmail.com with ESMTPSA id x21sm2753308wmi.46.2021.08.03.07.47.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 07:47:24 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2] s390x: sie: Add sie lib validity
 handling
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <20210729134803.183358-2-frankja@linux.ibm.com>
 <20210803135739.21624-1-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <bf652d52-fc93-1aca-81d6-85b48343b171@redhat.com>
Date:   Tue, 3 Aug 2021 16:47:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210803135739.21624-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/08/2021 15.57, Janosch Frank wrote:
> Let's start off the SIE lib with validity handling code since that has
> the least amount of dependencies to other files.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   lib/s390x/sie.c  | 40 ++++++++++++++++++++++++++++++++++++++++
>   lib/s390x/sie.h  |  3 +++
>   s390x/Makefile   |  1 +
>   s390x/mvpg-sie.c |  2 +-
>   s390x/sie.c      |  7 +------
>   5 files changed, 46 insertions(+), 7 deletions(-)
>   create mode 100644 lib/s390x/sie.c
> 
> diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
> new file mode 100644
> index 00000000..15ba407c
> --- /dev/null
> +++ b/lib/s390x/sie.c
> @@ -0,0 +1,40 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Virtualization library that speeds up managing guests.

Maybe something like:

Library for managing various aspects of (nested) guests

?

Anyway:
Reviewed-by: Thomas Huth <thuth@redhat.com>


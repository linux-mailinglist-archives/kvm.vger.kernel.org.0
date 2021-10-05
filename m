Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96DF422D16
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 17:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234853AbhJEP5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 11:57:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20923 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234282AbhJEP5Q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 11:57:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633449325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Knrgx1p0E4Syq4cv3Q9wXGfwnzsMCY1cNYGxXsf45qU=;
        b=WFYJzxnIZ2yFabRZ972pRX0KGt5mCSIVy7UuXahyp1OwTIQ3m5Yt58yBV76xfWyCB7jUu5
        KFA2ZeI8xJ4gX9ZIjmzqG3aXDT9t6Ssx9EosGy+P8AiWABV7ZvuIsO8kUNUaITIhCIv3m9
        Bu7q/CKMgXlP/16HlLp8w/NXn4AgSsI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-wsrHBWDUP0i1lwbdt1-qPw-1; Tue, 05 Oct 2021 11:55:22 -0400
X-MC-Unique: wsrHBWDUP0i1lwbdt1-qPw-1
Received: by mail-wm1-f69.google.com with SMTP id 129-20020a1c1987000000b0030cd1616fbfso1486670wmz.3
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 08:55:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Knrgx1p0E4Syq4cv3Q9wXGfwnzsMCY1cNYGxXsf45qU=;
        b=vrIl6UeLPZuCWff4fqvZfWYkFkK8ToZCES8fDvBB8leFRzMp7nu4Mr1qLBb9Urwycl
         PpH1o0JjQBRcduclFeypz3OW6bt8DHMdwMDTlCOxeA/sPiJYOGkj8F9sDktkkTZOuWyp
         Hb+lYWoPM8UcG2d2n8wjpuo8QDkUvcUY7Px6KFYfIBR8SKERR4VM77NHONh9vGFCxMeg
         /Fg4ni5HeEcsdL+gABt1WCPbaP+Km7IoE+SzVxFQZDytpVaCqLFzs/JxSCdxldkZo380
         MWt1CIlj4P1H0mgRINHIKMi9KMJoAapMza2VHdkOcqdGUUWXfoU0np+s643j3f/b+qym
         lhAQ==
X-Gm-Message-State: AOAM533huC6X7oG+MsYIzURR9794vi0mf88je7rVCYZGj+e2j+T+nfpA
        hFmn1juL9EHKRdUnF9oubdTgOmbIEsNeXEpLNfFijTiZ1tZkfAdEMO1CVbUGur40xSa38d5fgrk
        vkNk5XZJia86o
X-Received: by 2002:a5d:598f:: with SMTP id n15mr22077815wri.74.1633449320937;
        Tue, 05 Oct 2021 08:55:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxkx/b64SdlXraxRD5U/8/X/FIi8ODqBzjeS0JNxqNXS+psNHgWCHfWG9+BO7th6t0E8e7bGA==
X-Received: by 2002:a5d:598f:: with SMTP id n15mr22077784wri.74.1633449320676;
        Tue, 05 Oct 2021 08:55:20 -0700 (PDT)
Received: from thuth.remote.csb (p549bb2bd.dip0.t-ipconnect.de. [84.155.178.189])
        by smtp.gmail.com with ESMTPSA id i1sm19158556wrb.93.2021.10.05.08.55.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 08:55:20 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] s390x: remove myself as reviewer
To:     Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20211005154114.173511-1-cohuck@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <a1163106-f9b9-d733-3701-2d0a08acb612@redhat.com>
Date:   Tue, 5 Oct 2021 17:55:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211005154114.173511-1-cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/10/2021 17.41, Cornelia Huck wrote:
> I don't really have time anymore to spend on s390x reviews
> here, so don't raise false expectations. There are enough
> capable people listed already :)
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>   MAINTAINERS | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4fc01a5d54a1..590c0a4fd922 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -87,7 +87,6 @@ S390X
>   M: Thomas Huth <thuth@redhat.com>
>   M: Janosch Frank <frankja@linux.ibm.com>
>   S: Supported
> -R: Cornelia Huck <cohuck@redhat.com>
>   R: Claudio Imbrenda <imbrenda@linux.ibm.com>
>   R: David Hildenbrand <david@redhat.com>
>   L: kvm@vger.kernel.org

Applied.

Thank you very much for your contributions, Cornelia!

  Thomas


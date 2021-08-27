Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1643F982C
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 12:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244945AbhH0Kg7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 06:36:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38187 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233315AbhH0Kg6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 06:36:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630060569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ei+1cHIOQVyfLzvdswZ/VxfoLUx7LjHVn7EKejLifHE=;
        b=MWAPWQyfJEfCN86Ix6vI1vMDq1sU9OpawgutOAZyi4Zbib5WAW6s8t7s+PrWNacQJZpXSE
        wjCh7l05h4RB6uoy+6T+3Td8Q/cZhe8l5MlqBLbkScz/gbuYfESwfAhngVUsUBG5HOJFcS
        9vm0C3DsxUvBXkGj9K6JNBmMD1eF3VY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-UY8xzir8OkSGhQX8-6qrtQ-1; Fri, 27 Aug 2021 06:36:08 -0400
X-MC-Unique: UY8xzir8OkSGhQX8-6qrtQ-1
Received: by mail-wm1-f71.google.com with SMTP id j33-20020a05600c1c21b02902e6828f7a20so1599400wms.7
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 03:36:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ei+1cHIOQVyfLzvdswZ/VxfoLUx7LjHVn7EKejLifHE=;
        b=byZd7AwDeE7556OgxYz3C9W2NIyVarj4Rj9jalLrkvmxyCksIp8OyiC+bPli4exM3h
         RhGxDgLe7OVQUsM75xOe9HrcUqgPFsTvW0WzK4tJaaH0EEh1KqjON7PK1haB9+3yoEEz
         ak/Bb93R6tNj3BOBU8bYrJZxbUVeLrFv/PhwsMO5TJ+OSm2IXGGt52caSKn+PTmGCWFz
         qVb+OxFo57MWaNh2PTWaB7hHsphetiylWZJN4oarharbkUFzY3at2z2C7JNw+URixzSK
         E7W9lBRKV31Vl6YlOC+HX17KYIqzI7ebG1Viee4NUeV4STXJ99ivz3XLZ+4sXZ22xzOd
         xt1A==
X-Gm-Message-State: AOAM531eIsr+fnLTQGx1wkMQbY8tglix9mylHvWEFLLQrPQmHK+ARY8g
        jO/y+G+m3Q07+UZwEC9EeiBw6bUdXK/TkeZO31o80+/AL4/Kcp5FLCtp7+TyTZ81Qn6pBmPOk8b
        8XjQVEGcswe04
X-Received: by 2002:adf:9ccc:: with SMTP id h12mr9310906wre.385.1630060567461;
        Fri, 27 Aug 2021 03:36:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwnlVOby2/EKTguVA+pPT2bseGt95mJtgyNerjyar7lkM9GFfM9TMrbXxge7CyBijFdVrP2Ng==
X-Received: by 2002:adf:9ccc:: with SMTP id h12mr9310895wre.385.1630060567300;
        Fri, 27 Aug 2021 03:36:07 -0700 (PDT)
Received: from thuth.remote.csb (dynamic-046-114-148-182.46.114.pool.telefonica.de. [46.114.148.182])
        by smtp.gmail.com with ESMTPSA id r1sm9621112wmn.46.2021.08.27.03.36.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 03:36:06 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] Makefile: Don't trust PWD
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     pmorel@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, pbonzini@redhat.com
References: <20210827103115.309774-1-drjones@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <566ab64b-03eb-b4e6-ddff-39524f256578@redhat.com>
Date:   Fri, 27 Aug 2021 12:36:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210827103115.309774-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/08/2021 12.31, Andrew Jones wrote:
> It's possible that PWD is already set to something which isn't
> the full path of the current working directory. Let's make sure
> it is.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>   Makefile | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/Makefile b/Makefile
> index f7b9f28c9319..a65f225b7d5c 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,4 +1,5 @@
>   SHELL := /usr/bin/env bash
> +PWD := $(shell pwd)

I think we should rather use $(CURDIR) in Makefiles instead, since this is 
the official way that GNU Make handles the current working directory.

By the way, is this cscope thing also supposed to work in out-of-tree builds?

  Thomas


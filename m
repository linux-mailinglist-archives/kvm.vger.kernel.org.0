Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31D8416E16
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 10:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244832AbhIXIif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 04:38:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48559 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244808AbhIXIie (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 04:38:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632472621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uoccDgu2GmJhRPeasYkI2ZMY0s3OFIWp9qaw8FYPVZU=;
        b=gqkpzoLYNTvD5PNc2tIb7sT+PJBavuGYE6IutD0r33MPtR9k2NQFe+rMTvsTc01WUDq6Z4
        aMOKRxY6kvDQ5nzIjZ3JwkOGCXXAT/fp8lDOPRKePo7+j/lWH3eAvkqhNQjoOHSUWnsZ4w
        9wFc++TYfYWMeVUirJvDrRY/ObGmAbs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-KuZrfzLhOtK-h2Eelc3xEg-1; Fri, 24 Sep 2021 04:37:00 -0400
X-MC-Unique: KuZrfzLhOtK-h2Eelc3xEg-1
Received: by mail-wr1-f72.google.com with SMTP id c15-20020a5d4ccf000000b0015dff622f39so7386572wrt.21
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 01:36:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uoccDgu2GmJhRPeasYkI2ZMY0s3OFIWp9qaw8FYPVZU=;
        b=4GefLoaCnb3TgdKbbe72BRvd2gKfGyPW4VWEwOuyAH9zmDs3rmS1Ih48VhVIr8Nfsb
         6Diwh5SZ5i2JE6uZkgGnz5JJMjoVJvyZmUj+bGbl0B1Cfk/341zO6TuU8V2eYMMVC336
         6rOFunOv6iXfQKvUZqVW12QysI4hwJUJpLRuQ1FsYUqMh/0U7aCZ+WOoMgJLCI/2pQNC
         ++qkQWM6lAMdUlVMWJFRnAwx4r+/lV9gLmGyAtGKFFeEFD0zcWY5O0ECWObVTtb5DqFf
         dpYm/xV2p3OwEGUTZvZlMelkxijKlqAyCufbNlXWPTJjFBP46gTXyQqiCWM508C6LRPs
         kCPQ==
X-Gm-Message-State: AOAM531TDyUVQSePuD293Xef0qZEGAeVH4fFnl2WJOSg4ZvGXzlBWmQQ
        Sf/CYXQ+eHxz2Wq6MKVRNnrDtYeOdduQoTrCVSgXtj/VeG1t29S8AtlglfKMwc/UgTh7HIoWG03
        Mv73n7XohIMwo
X-Received: by 2002:a1c:7d4d:: with SMTP id y74mr747228wmc.181.1632472619007;
        Fri, 24 Sep 2021 01:36:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxrPcl0J71cTLtO5JgmEE344bmxoKlMhYJnZbDHtkn/3Te02cYPEz+o0Ln+CHUwnb0Azs1Ggw==
X-Received: by 2002:a1c:7d4d:: with SMTP id y74mr747209wmc.181.1632472618833;
        Fri, 24 Sep 2021 01:36:58 -0700 (PDT)
Received: from thuth.remote.csb (tmo-097-75.customers.d1-online.com. [80.187.97.75])
        by smtp.gmail.com with ESMTPSA id t22sm3909173wmj.30.2021.09.24.01.36.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 01:36:58 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] MAINTAINERS: add S lines
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Andrew Jones <drjones@redhat.com>
References: <20210923114814.229844-1-pbonzini@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <e8088857-d646-fe57-0d0d-801f701935ca@redhat.com>
Date:   Fri, 24 Sep 2021 10:36:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210923114814.229844-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/2021 13.48, Paolo Bonzini wrote:
> Mark PPC as maintained since it is a bit more stagnant than the rest.
> 
> Everything else is supported---strange but true.
> 
> Cc: Laurent Vivier <lvivier@redhat.com>
> Cc: Thomas Huth <thuth@redhat.com>
> Cc: Janosch Frank <frankja@linux.ibm.com>
> Cc: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   MAINTAINERS | 5 +++++
>   1 file changed, 5 insertions(+)

Acked-by: Thomas Huth <thuth@redhat.com>


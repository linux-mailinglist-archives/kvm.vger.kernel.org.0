Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641B042DA7C
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 15:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbhJNNex (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 09:34:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60552 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230177AbhJNNew (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Oct 2021 09:34:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634218367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NHpcQuHVzP61PCLL+Fjiwo05Qr91Fn/iL+o/xLumkPU=;
        b=CF7zYOruocKaSFrU4eecH9sMNA6hUIKV4m4RW50Hsq8bXj1ybI+OkTrs3joj/FGkfOMBFZ
        hdH6tk/v29fknKRW5T74YMAqLU4seDXtcmB+vWHp4J1zRKByLwB1Fy/XIFowtHNGh5uwoW
        yOfmWg7M+9pYzV5K2LsNerm4+ZJV8qw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328--jcrDmOJO-CLY2h8dKPFog-1; Thu, 14 Oct 2021 09:32:46 -0400
X-MC-Unique: -jcrDmOJO-CLY2h8dKPFog-1
Received: by mail-ed1-f69.google.com with SMTP id c25-20020a056402143900b003dc19782ea8so1651076edx.3
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 06:32:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NHpcQuHVzP61PCLL+Fjiwo05Qr91Fn/iL+o/xLumkPU=;
        b=tjKykJIgctdkD+PSi2M8TM8Ii6QnP3qg56DPcp72bFDQrmWVQeEENyl6LF8vNCAYhe
         hewIYG2FrzNtGpjMWy7Ps1rfqRwwdvRJ2oWo+NH4qIn+UEK7W96EY4uMA0gqMHGMKaot
         hX0DhJAxkzq86jYvHHFl+QQk9Q24JRKytWzjl8p04+EPfiHxLp/G/ps0XVPdqs0pItBM
         nNtODPP3W5eqtOppLct6bMEyGnrulF5lYaGsWLkB+CfUWPBSgVb7o5OnQgHBtjScJu1f
         0URK9YyXtgdhdCdmvi4xJmlP7tOw0xv9zWKhn2k7KG9GRCS/0Q1xQvBy3DGS+S3B74Bc
         I+2w==
X-Gm-Message-State: AOAM532xlyt57knNvHRSNBCS/LevhO/7nPMsNUhwfpIpigTUj64iI6jk
        0+X97w4y8qIMtH7Qo3rsCE44cULMKNzOMk3nrIp5GFF7s3S5apxp8r0Kd96S/UaOw1BXg8NqHnn
        E02hpijDv4gks
X-Received: by 2002:a50:e085:: with SMTP id f5mr8826466edl.9.1634218365238;
        Thu, 14 Oct 2021 06:32:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwrQieYC+gxWyiqle7AAtsptB3GOiT9Cj3s4p5h6SCMnmi+plkM5D/gwwv7wJhtJDbDDRPZjQ==
X-Received: by 2002:a50:e085:: with SMTP id f5mr8826434edl.9.1634218365017;
        Thu, 14 Oct 2021 06:32:45 -0700 (PDT)
Received: from thuth.remote.csb (p549d10d7.dip0.t-ipconnect.de. [84.157.16.215])
        by smtp.gmail.com with ESMTPSA id r3sm2173907edo.59.2021.10.14.06.32.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 06:32:44 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 2/3] lib: s390x: snippet.h: Add a few
 constants that will make our life easier
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, seiden@linux.ibm.com
References: <20211014125107.2877-1-frankja@linux.ibm.com>
 <20211014125107.2877-3-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <7a919ec3-e790-aad1-edd5-463148b5fc37@redhat.com>
Date:   Thu, 14 Oct 2021 15:32:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211014125107.2877-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/10/2021 14.51, Janosch Frank wrote:
> The variable names for the snippet objects are of gigantic length so
> let's define a few macros to make them easier to read.
> 
> Also add a standard PSW which should be used to start the snippet.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   lib/s390x/snippet.h | 34 ++++++++++++++++++++++++++++++++++
>   s390x/mvpg-sie.c    | 13 ++++++-------
>   2 files changed, 40 insertions(+), 7 deletions(-)
>   create mode 100644 lib/s390x/snippet.h

Reviewed-by: Thomas Huth <thuth@redhat.com>


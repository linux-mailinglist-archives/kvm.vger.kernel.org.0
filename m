Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAC83DBB64
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 16:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239236AbhG3OwY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 10:52:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54914 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239262AbhG3OwR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Jul 2021 10:52:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627656732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5SqTy/de3MQFV79yQIm0KsTvukjOKB0/XGcHmMKqxZc=;
        b=ROwN8KPC9CxaOTGgGqPlQcI39QHxiAMl8kzTB4XpNugZVVi7WLgAYU4n2e0Bxfyf1qHIYS
        A1t8ZkvOxKwCYqhmLgFAKllkDrmUXkz7lRxw/J9ZB9sRU8AiS8ZzeFqVCcKRS94/OsFhRK
        Nf2ARgwEu2mm5ia3fvh8RFz5jEKZkws=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-wyNLhRkxNt2M8AxO9HM7WQ-1; Fri, 30 Jul 2021 10:52:10 -0400
X-MC-Unique: wyNLhRkxNt2M8AxO9HM7WQ-1
Received: by mail-wr1-f69.google.com with SMTP id p2-20020a5d48c20000b0290150e4a5e7e0so3269149wrs.13
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 07:52:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5SqTy/de3MQFV79yQIm0KsTvukjOKB0/XGcHmMKqxZc=;
        b=PMDBmbNpQMSYgtdglHsvEUkzqNlNdssoimkgOSISChTWkUYPsIkTDHkSt7RZf/1iVl
         kJ8BdrKJPGciE9Jui7wqSO5zi/F6RwwYBpTlnz9RJTdWPamy6DHZJpmFHAmmk9OsLwgq
         dkWqeFvA+wIAVgVwKLguBJ92Fzx+s32HdcvgRVFQ7vYNwdFQQpP7G8TyLpJ57hG0bRfS
         Q6kSzanSTYWYlfYT3lIoBwDRAjAbfo06GYneM122t+I5Q48R72+xbCfyhfe5OcwGmkeF
         AEBp1fMJsqAZetVq/8j/W8ydX0t/IdBIsgz6FMeYnon12IhD9LFoZMS0MQxIYXFEgXHA
         CcuQ==
X-Gm-Message-State: AOAM532Ax6QExeEKwb2Yj/mS3+mM+QRf64klLMz5AH764h92xmgv7LgV
        x5Nc7yZM7ysoMYiqPJ/92OqgBAEIOEc0PYpBf/VDTCtFJlZWousUI6iXuuMhP8wYR6MHUK2LxM3
        KGEI/P4EEoqN3
X-Received: by 2002:a5d:4251:: with SMTP id s17mr3558263wrr.154.1627656729526;
        Fri, 30 Jul 2021 07:52:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyCT8stFScPka4Ea7HXpA34gjNp9iFpnXrsCNYpP8K5SO8v3uwo57I7c92VW98ISeZWJC0q6A==
X-Received: by 2002:a5d:4251:: with SMTP id s17mr3558252wrr.154.1627656729395;
        Fri, 30 Jul 2021 07:52:09 -0700 (PDT)
Received: from thuth.remote.csb (p5791d280.dip0.t-ipconnect.de. [87.145.210.128])
        by smtp.gmail.com with ESMTPSA id f26sm1964159wrd.41.2021.07.30.07.52.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jul 2021 07:52:08 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 3/4] s390x: lib: sie: Add struct vm
 (de)initialization functions
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <20210729134803.183358-1-frankja@linux.ibm.com>
 <20210729134803.183358-4-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <5746e45d-d7d3-a36e-02d4-a99da029c7d0@redhat.com>
Date:   Fri, 30 Jul 2021 16:52:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210729134803.183358-4-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/07/2021 15.48, Janosch Frank wrote:
> Before I start copying the same code over and over lets move this into
> the library.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   lib/s390x/sie.c  | 30 ++++++++++++++++++++++++++++++
>   lib/s390x/sie.h  |  3 +++
>   s390x/mvpg-sie.c | 18 ++----------------
>   s390x/sie.c      | 19 +++----------------
>   4 files changed, 38 insertions(+), 32 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>


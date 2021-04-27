Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E0836C619
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 14:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236104AbhD0MeR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 08:34:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27155 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235410AbhD0MeQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Apr 2021 08:34:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619526813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KbufCfCF0JKrt3DGyjjtVdLiKUAGXseaRTJue2BhUss=;
        b=iEV4WOKYOGECBLbbl0gU4UuAg3wWtdmAhYEr1INzFVNXXt0api0QkIx1Y64DEOwLk6E31y
        Sh71zAstGXHj9ORsfL/tAghelbKECBIogwNoWA7fqyHVM7PudCOL+QtaP0RNEmzmILLf2j
        QxR22OoTiQsrefO2j4bYkL1NqOU+QAY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-B6B-fAH2O-6oAze2smOO6Q-1; Tue, 27 Apr 2021 08:33:28 -0400
X-MC-Unique: B6B-fAH2O-6oAze2smOO6Q-1
Received: by mail-wm1-f69.google.com with SMTP id d78-20020a1c1d510000b0290132794b7801so4030635wmd.1
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 05:33:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=KbufCfCF0JKrt3DGyjjtVdLiKUAGXseaRTJue2BhUss=;
        b=Y28cHEjtWTHzhOnCBOxGM19p1T1+8+ZyQli0UF7dNtsqCwT6UIr0DdVQB2xDw9g+us
         U4z/zVwpa0hI7h5TCWRU01s51ti8Xbk3YBCIM7V6/+Z8+3/iW2JnEWdR40wPSrpTs6lH
         hgvyhrOq8MH18Z43kTRemSw/uUjxwjeo/SuYg9Bc8mOh/CDQqI79BGagrQuVF0xC085C
         gWzIxIpArriWkCnIC05BKYzQtXbJo9MVAE81pYIX+Z3cNmj6h8+9+S3IaqQ3vL/NmakB
         QdZxbHPFe73DUk8BLPpoKyN/K5uUs/1CUGL5p6+3ForHuFPhF7kx7sE1H827i/mQTk8w
         vO3w==
X-Gm-Message-State: AOAM530EmlIDPdm2w/BrEvkqcCX9a3lBeBbgSYBL5qXRIkBMEIruaB+R
        TNS/gYphVS9lAP/Oc17gNsQVgIhUX0PdhQoyIGEy7gRX215fVDbrPOQaxHv4mq0jLIVtsw72e0C
        56gJaKUTupSRD
X-Received: by 2002:adf:e0c8:: with SMTP id m8mr29677238wri.349.1619526807592;
        Tue, 27 Apr 2021 05:33:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz55ipDEBXwca5M3pEs0PogsFffAo/y0ZK/CysFvRSo5rgKh8TwS6QqWsdm8n5SQ+NMNYvoYA==
X-Received: by 2002:adf:e0c8:: with SMTP id m8mr29677213wri.349.1619526807387;
        Tue, 27 Apr 2021 05:33:27 -0700 (PDT)
Received: from ?IPv6:2003:d8:2f38:2400:62f4:c5fa:ba13:ac32? (p200300d82f38240062f4c5faba13ac32.dip0.t-ipconnect.de. [2003:d8:2f38:2400:62f4:c5fa:ba13:ac32])
        by smtp.gmail.com with ESMTPSA id u17sm2394362wmq.30.2021.04.27.05.33.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Apr 2021 05:33:27 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v1 1/1] MAINTAINERS: s390x: add myself as
 reviewer
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, cohuck@redhat.com
References: <20210427121608.157783-1-imbrenda@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <31a49f98-5e4a-31cc-2fb6-78acbd90d2ef@redhat.com>
Date:   Tue, 27 Apr 2021 14:33:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210427121608.157783-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27.04.21 14:16, Claudio Imbrenda wrote:
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   MAINTAINERS | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e2505985..aaa404cf 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -85,6 +85,7 @@ M: Thomas Huth <thuth@redhat.com>
>   M: David Hildenbrand <david@redhat.com>
>   M: Janosch Frank <frankja@linux.ibm.com>
>   R: Cornelia Huck <cohuck@redhat.com>
> +R: Claudio Imbrenda <imbrenda@linux.ibm.com>
>   L: kvm@vger.kernel.org
>   L: linux-s390@vger.kernel.org
>   F: s390x/*
> 

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb


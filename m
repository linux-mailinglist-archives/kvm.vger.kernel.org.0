Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9F043654A
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 17:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbhJUPN6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 11:13:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21023 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231822AbhJUPN5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 11:13:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634829101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x0T9sFaT53jZvS7u8t2/BNFrp32YelVjtprvyw23bFg=;
        b=Qa95kvOuxyBehQ5U2pCyn2VfrH5hC62NzhUGXV33A+/7cZy6POY5QYuDzeWHLFp6h91llw
        YrSXHMm16SFdrggUwYoi0IVbGiG7dCAykxOmLIOmCfwBuZp2FW9Z38Mw8RCxTUa60jyohK
        FDoz49PSXGhJ74S5eZLEWN2iNvx0LNA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-0_31uKhcO3-coPSTV6Y6GA-1; Thu, 21 Oct 2021 11:11:39 -0400
X-MC-Unique: 0_31uKhcO3-coPSTV6Y6GA-1
Received: by mail-ed1-f71.google.com with SMTP id z20-20020a05640240d400b003dce046ab51so658706edb.14
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 08:11:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=x0T9sFaT53jZvS7u8t2/BNFrp32YelVjtprvyw23bFg=;
        b=QgPJGQtDCaMsOfhaUXpU2fAgIWynt5WXHPsTO1NmTa0flJkBaeS9SbuxPcXCOouUia
         Ak4eM7AM0pzZqBh2N43fJua8ZfIRMXNzFdR8spf3UK1sm5cT8hAXgOhsE1Xu5YbAUgkW
         NDfjgrQC8ycB7B9EwKl9HrdOnOXvpFSKo6Upz8Q7anIIzTZg7vePN3SJvGhfdIP3+pcd
         AzpxHcavUwIeYXEzEEwyq89jMx7sMPewOFgmsn+WXlf969AIUNgRixd80qsPY9exlRgI
         ttpUKPXglRuEP6Zs1yyJR7/LCfR1UAQ77Cs5iLPZnaAcG5tvAmPDqZb3NQz7ajk6I+uT
         7EDQ==
X-Gm-Message-State: AOAM530/6yZ1gZ2/UcNRvxTNPQi/KhMsF2HAwgnftE723oL2rAM8PHyw
        4XKax9yu32sSCxtl64u5mIL34WnBrpES3ebBU067MA5J5ql2NhEUqPK+mbkilt435q/eq9RcUem
        RUTm/PuszKvC7
X-Received: by 2002:a17:907:2d28:: with SMTP id gs40mr8081229ejc.203.1634829098287;
        Thu, 21 Oct 2021 08:11:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvfbRxGC+EgYOwcg2nDZd+DGBjkAcpOLElKfhswN64XOk/c6IFv4/uzuyL3DXLD84T+HVPdg==
X-Received: by 2002:a17:907:2d28:: with SMTP id gs40mr8081207ejc.203.1634829098098;
        Thu, 21 Oct 2021 08:11:38 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id j3sm2620556ejy.65.2021.10.21.08.11.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 08:11:37 -0700 (PDT)
Message-ID: <177ebc1b-62fc-633a-5f49-ef2a1eab26a5@redhat.com>
Date:   Thu, 21 Oct 2021 17:11:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH] MAINTAINERS: Add Claudio as s390x
 maintainer
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, borntraeger@de.ibm.com,
        drjones@redhat.com
References: <20211021145912.79225-1-frankja@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211021145912.79225-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/10/21 16:59, Janosch Frank wrote:
> Claudio has added his own tests, reviewed the tests of others and
> added to the common as well as the s390x library with excellent
> results. So it's time to make him a s390x maintainer.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   MAINTAINERS | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2d4a0872..bab08e74 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -86,8 +86,8 @@ F: lib/ppc64/
>   S390X
>   M: Thomas Huth <thuth@redhat.com>
>   M: Janosch Frank <frankja@linux.ibm.com>
> +M: Claudio Imbrenda <imbrenda@linux.ibm.com>
>   S: Supported
> -R: Claudio Imbrenda <imbrenda@linux.ibm.com>
>   R: David Hildenbrand <david@redhat.com>
>   L: kvm@vger.kernel.org
>   L: linux-s390@vger.kernel.org
> 

Pushed, thanks!

Paolo


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E11902F891
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 10:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfE3Ia3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 May 2019 04:30:29 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50365 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbfE3Ia3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 May 2019 04:30:29 -0400
Received: by mail-wm1-f65.google.com with SMTP id f204so3363654wme.0
        for <kvm@vger.kernel.org>; Thu, 30 May 2019 01:30:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cakd6yX8spRcWU62BwvHvcKXUNux0T+n4hdvHWSmHRI=;
        b=Z9TmbhRNJloj0PO7MimUcexPZQdcstxOJisDoQ4G8+pRsZIozV7WDM4XKMF6cRvURz
         D8KCUbF2XcHer/dbCRB2oZOsZYIfkmecYPEZZxvkQROVDMROYtPDUc6GIKskAvGEGFFF
         FGGSMk1b323Z1td8ZKIx4yCZlZsuS5yIHTNbQKe70XW9y/1v6N5LymV/VpfaV2SYUlbn
         BN2X6xtksU/BzHK2fAJmUZb8Rb2Wgx11Ed7Jds30hUsyd+M2SclQd2MNZYrPvg/6EonT
         JqQ9o8XtIoAKaj0FwBQMXb+x03baqvzO8njkM5wuFclav3/MBL026mrsBT/I4awcdUgN
         bR6g==
X-Gm-Message-State: APjAAAXNCa7t7M8n6YT2BOwijvo6y2Rh6bC5WVFrvB01EcOGDqSceRWS
        VFE6guMxiqG6vy1/i91D5/yUNIFUII1j9w==
X-Google-Smtp-Source: APXvYqz9aBCV+UXQLk4e6KAbVOE20yVgNpoWGimmvRkY5cIZlAJKv+oW03Lf2HhxmWLaaw8t1GScjw==
X-Received: by 2002:a1c:8049:: with SMTP id b70mr1424865wmd.33.1559205027447;
        Thu, 30 May 2019 01:30:27 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3da1:318a:275c:408? ([2001:b07:6468:f312:3da1:318a:275c:408])
        by smtp.gmail.com with ESMTPSA id y8sm1688948wmi.8.2019.05.30.01.30.26
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 01:30:26 -0700 (PDT)
Subject: Re: [PATCH 10/22] docs: amd-memory-encryption.rst get rid of warnings
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
References: <cover.1559171394.git.mchehab+samsung@kernel.org>
 <76b7a2990edd771aa1708862d0c6644a6b2d795d.1559171394.git.mchehab+samsung@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f9f66434-19b5-b219-f719-6dba2e4e363b@redhat.com>
Date:   Thu, 30 May 2019 10:30:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <76b7a2990edd771aa1708862d0c6644a6b2d795d.1559171394.git.mchehab+samsung@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/05/19 01:23, Mauro Carvalho Chehab wrote:
> Get rid of those warnings:
> 
>     Documentation/virtual/kvm/amd-memory-encryption.rst:244: WARNING: Citation [white-paper] is not referenced.
>     Documentation/virtual/kvm/amd-memory-encryption.rst:246: WARNING: Citation [amd-apm] is not referenced.
>     Documentation/virtual/kvm/amd-memory-encryption.rst:247: WARNING: Citation [kvm-forum] is not referenced.
> 
> For references that aren't mentioned at the text by adding an
> explicit reference to them.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  Documentation/virtual/kvm/amd-memory-encryption.rst | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/virtual/kvm/amd-memory-encryption.rst b/Documentation/virtual/kvm/amd-memory-encryption.rst
> index 33d697ab8a58..6c37ff9a0a3c 100644
> --- a/Documentation/virtual/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virtual/kvm/amd-memory-encryption.rst
> @@ -243,6 +243,9 @@ Returns: 0 on success, -negative on error
>  References
>  ==========
>  
> +
> +See [white-paper]_, [api-spec]_, [amd-apm]_ and [kvm-forum]_ for more info.
> +
>  .. [white-paper] http://amd-dev.wpengine.netdna-cdn.com/wordpress/media/2013/12/AMD_Memory_Encryption_Whitepaper_v7-Public.pdf
>  .. [api-spec] http://support.amd.com/TechDocs/55766_SEV-KM_API_Specification.pdf
>  .. [amd-apm] http://support.amd.com/TechDocs/24593.pdf (section 15.34)
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

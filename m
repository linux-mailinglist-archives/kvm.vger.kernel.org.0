Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84B034B0919
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 10:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238199AbiBJJFz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 04:05:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238178AbiBJJFy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 04:05:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B8E59D94
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 01:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644483950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+VOVU28uEg+VeYFn6fPIKbXayXxxCm00kEtsj2qS9E4=;
        b=jTp/p23Vv5gUusgY0y92mjkw2uNRRDuHI2KrQ97hGpcw8ZW+qUut7TAcITyvjOjV6EmEox
        niRN459RkffzJWvA93ytB1rj98XSweSDHQ4X/YKjjXU7dm2VzW1HsXCaTGRcYbIFno1nAA
        jq5v5N1kQ0w1fg+3gGxx0XlEeB14vpM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-39-YchlZrVOOW64mc47a5dvtg-1; Thu, 10 Feb 2022 04:05:49 -0500
X-MC-Unique: YchlZrVOOW64mc47a5dvtg-1
Received: by mail-wr1-f71.google.com with SMTP id b8-20020adfc748000000b001e333edbe40so2214142wrh.6
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 01:05:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+VOVU28uEg+VeYFn6fPIKbXayXxxCm00kEtsj2qS9E4=;
        b=5oYuvcFhznJGcOHXijk9mBGUko8cRIEnPzjv6zM6otL1nXdHfaELl7TLthD9XVS70q
         ZJMUTqEHz4e8n0ZjYI86uCg4uiPuDShtF/g59ZrSSfK2j7Y4+5IMmzDjdwz4FLjDxaDd
         fvnvcV9ILPdbdbS65ISkBSk78ATuAEktLjsmDnyUoi2ZMocUDiZMJc22XJXl9g4sZAce
         wMCaoWnhepiIWo46bms3/TloTScAsWbtR3EAQ67SXYs+la8dgG3KIqoT+9y6EK1xd6Vf
         p5ascSQwtmBtDTiVB53nWoYl59nv8UkmQcLzOnYyFZPNpbTbf7uP29fJJK4cW2t1gokB
         /A5w==
X-Gm-Message-State: AOAM531tP5vpMeEusHKeyNjwcNdXafcPGtgRfQ/tIuzzUfs0hVGDEn3o
        1Dt0JAW444qYRtz43Sm6VlmCQxWNdqJ2gpDEa2od/VnP+wXxp0FjariLOh3GuHMIHWox2huJPhC
        Mxx+dJXOURSBY
X-Received: by 2002:a5d:5850:: with SMTP id i16mr5437644wrf.519.1644483948460;
        Thu, 10 Feb 2022 01:05:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwyBtzTD1Ovs/rO1vUFtla6MQxgaKntQcwkuH+mF+pA1KP5W/+ccgvohdnShFgAliAOSiAYnw==
X-Received: by 2002:a5d:5850:: with SMTP id i16mr5437623wrf.519.1644483948255;
        Thu, 10 Feb 2022 01:05:48 -0800 (PST)
Received: from [192.168.8.104] (tmo-098-218.customers.d1-online.com. [80.187.98.218])
        by smtp.gmail.com with ESMTPSA id t1sm22134179wre.45.2022.02.10.01.05.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 01:05:47 -0800 (PST)
Message-ID: <4281a418-317d-cfd5-3446-edb7c720d761@redhat.com>
Date:   Thu, 10 Feb 2022 10:05:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] KVM: s390: MAINTAINERS: promote Claudio Imbrenda
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
References: <20220210085310.26388-1-borntraeger@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220210085310.26388-1-borntraeger@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/02/2022 09.53, Christian Borntraeger wrote:
> Claudio has volunteered to be more involved in the maintainership of
> s390 KVM.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> ---
>   MAINTAINERS | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f41088418aae..cde32aebb6ef 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10548,8 +10548,8 @@ F:	arch/riscv/kvm/
>   KERNEL VIRTUAL MACHINE for s390 (KVM/s390)
>   M:	Christian Borntraeger <borntraeger@linux.ibm.com>
>   M:	Janosch Frank <frankja@linux.ibm.com>
> +M:	Claudio Imbrenda <imbrenda@linux.ibm.com>
>   R:	David Hildenbrand <david@redhat.com>
> -R:	Claudio Imbrenda <imbrenda@linux.ibm.com>
>   L:	kvm@vger.kernel.org
>   S:	Supported
>   W:	http://www.ibm.com/developerworks/linux/linux390/

Reviewed-by: Thomas Huth <thuth@redhat.com>


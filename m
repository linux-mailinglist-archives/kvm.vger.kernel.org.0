Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79C746616E
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 11:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356786AbhLBKdf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 05:33:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35631 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356760AbhLBKde (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Dec 2021 05:33:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638441012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BYsLP2MP00b1oH3DtRnSUpLrjUtCpztF+PeHvMRQbAg=;
        b=RBSicacWJ11I2/bbfz2s8Rz34gVLHEh9bRK+NxnTHSQG/NBkdpVg6Sd50O1oDkRnt4mnzh
        FmRRZTcaGI18KSmia0fK4QAt4Zupd5X0CttUnkJuLml+xN2FBMMqYV3oOlHVtmbRWeA/aG
        tgnksBaOqQSI3hz+EsNl/KDcT07QXjg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-168-PXL-r0UKMDanZU3Y7XGC5A-1; Thu, 02 Dec 2021 05:30:11 -0500
X-MC-Unique: PXL-r0UKMDanZU3Y7XGC5A-1
Received: by mail-wr1-f70.google.com with SMTP id y4-20020adfd084000000b00186b16950f3so4903113wrh.14
        for <kvm@vger.kernel.org>; Thu, 02 Dec 2021 02:30:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BYsLP2MP00b1oH3DtRnSUpLrjUtCpztF+PeHvMRQbAg=;
        b=CfVUWTSR7ha6hlS1+86wgJvK8hX9w4/WjX+qlFwwYgA8aTIeZaHP55gv+AebuzcjX/
         8Jd8gC0pE5a4BWeOpIHRj0IQwZepR16BPsOFTRYAe0qIfE5PjiahXfCY4A4RWChHw+gX
         Vu/4CL1q7Fc3vk4vkRygIGI+3cOFvJeSanKWSSzzDlNSUWRQTmRq3ApiAsKAF4sUGjWE
         F8yXDMvrvZHkcVvsgQHTCZhbXmS9wBAYAnme3qd9enLaAhsLGsBhPRKFIuOFLf/H6ZzD
         dOBoT318ilNmVutGEi77e6KtCEP5sAYO1BqyxpIOTXzKECNiDVbKm3wZI/C6zPUZb1VW
         obzQ==
X-Gm-Message-State: AOAM531qMgDTe4Z9u/Grp7gV55pdI39FgYMjjWMoVKo/k2THDpy9Qqkr
        0q3aiHILOVVrltkKr1gkSdmo7WwMuBxF7CEjYcDyXz6qTbeAX26HHJOLd+Em4tWEEkePu4Omhws
        txKVuON0SX3w6
X-Received: by 2002:a1c:447:: with SMTP id 68mr5335596wme.69.1638441009880;
        Thu, 02 Dec 2021 02:30:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx4e0l4QmJap0Ltd3O3NXcmX4oslOmpQ87IkX1xwbcf4AZjE1poLYtPmREDNqOy75l9ACRqCA==
X-Received: by 2002:a1c:447:: with SMTP id 68mr5335573wme.69.1638441009708;
        Thu, 02 Dec 2021 02:30:09 -0800 (PST)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id o4sm1955473wmq.31.2021.12.02.02.30.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 02:30:08 -0800 (PST)
Message-ID: <94d78a53-cb59-d712-65c5-d31e909f13d4@redhat.com>
Date:   Thu, 2 Dec 2021 11:30:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH v1 1/2] s390x: make smp_cpu_setup() return
 0 on success
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sebastian Mitterle <smitterl@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org
References: <20211202095843.41162-1-david@redhat.com>
 <20211202095843.41162-2-david@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20211202095843.41162-2-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/12/2021 10.58, David Hildenbrand wrote:
> Properly return "0" on success so callers can check if the setup was
> successful.
> 
> The return value is yet unused, which is why this wasn't noticed so far.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>   lib/s390x/smp.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> index da6d32f..b753eab 100644
> --- a/lib/s390x/smp.c
> +++ b/lib/s390x/smp.c
> @@ -212,6 +212,7 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
>   	/* Wait until the cpu has finished setup and started the provided psw */
>   	while (lc->restart_new_psw.addr != psw.addr)
>   		mb();
> +	rc = 0;
>   out:
>   	spin_unlock(&lock);
>   	return rc;
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>


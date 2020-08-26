Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD082537E1
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 21:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgHZTIH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 15:08:07 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41391 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727047AbgHZTH6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Aug 2020 15:07:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598468877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zVfRzCZn6+ts4feYrw8uCdw680voVQCMoTJdKdW6yBo=;
        b=aaCtYTk7Tk4Bgl0dKyqFVlnJHPwF4xcFB3g/aSu/B0UsLjd3RU2JolZyKsegapIheddQDg
        wYfNP6pw1T78A0t5XR+88QlcIm51h3cVDXWQP/OvsMnFR7Pu81CtiuqH3QjQBxQNRQNhDD
        DeOP0I/Qb3w9u7giCX0+aPlrvlV04YA=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-AFr7FAqDOAaA_hDxN64JEw-1; Wed, 26 Aug 2020 15:07:53 -0400
X-MC-Unique: AFr7FAqDOAaA_hDxN64JEw-1
Received: by mail-qt1-f200.google.com with SMTP id q6so2527491qtn.15
        for <kvm@vger.kernel.org>; Wed, 26 Aug 2020 12:07:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zVfRzCZn6+ts4feYrw8uCdw680voVQCMoTJdKdW6yBo=;
        b=FLX64t77m7u9UEkRt2fTwHsJzVk8lqiPwALosYw4xmuOI6JBw3d/9ijUMOukFEX2Iz
         yj5RIZMhNuqmSyJDbpVhEMYu/NKICJRFRNg3/ao+mIqbxlLpLNgkg0WfDbFKa0paXE+A
         LREcXXnRNZtrZiBGnvUVPxMhFycNEMUNcPL12cfdXRxDxyRt2DhPIgMTq3PrqN7P9TOy
         vk2iIbN39cz71iq9uNztnKHyChX/bXPS5X/WodtPHiVpeXXTbvBt27+LLlognK7Knh8L
         ahj2aVgL4ioztm9zHc8VnLNyf8ffDHb56lnog6P+KY8Imu7Ta8vp6qURWUZXFWUZiAA7
         Gr2Q==
X-Gm-Message-State: AOAM531AuUe4NioG2CKWBePG09u5+NnKmtx2oxHlzKrAXrENoPpBgtOI
        BB6htYDX3U2jEex24Z8TVcPbJisyR8o04V3ezVFJkIKOQjkvHb5lZM3iyrFjlBgWO2iVba8oAcd
        ATLn1BCA/HK8u
X-Received: by 2002:ac8:60c5:: with SMTP id i5mr15888518qtm.268.1598468873281;
        Wed, 26 Aug 2020 12:07:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwKt/sofP3XC1APCt3YLfAwrGBkvCvQK56qB/zFRFY59XZ6fmnPY9uf24qJI+m73tK77o61WA==
X-Received: by 2002:ac8:60c5:: with SMTP id i5mr15888494qtm.268.1598468873067;
        Wed, 26 Aug 2020 12:07:53 -0700 (PDT)
Received: from [192.168.0.172] (ip68-103-222-6.ks.ok.cox.net. [68.103.222.6])
        by smtp.gmail.com with ESMTPSA id r17sm1584791qke.66.2020.08.26.12.07.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 12:07:52 -0700 (PDT)
Subject: Re: [PATCH 4/4] sev/i386: Enable an SEV-ES guest based on SEV policy
To:     Tom Lendacky <thomas.lendacky@amd.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
References: <cover.1598382343.git.thomas.lendacky@amd.com>
 <8390c20d2f7e638d166f7b771c3e11363a7852f6.1598382343.git.thomas.lendacky@amd.com>
From:   Connor Kuehl <ckuehl@redhat.com>
Message-ID: <bb74c9ef-4d50-0e81-3444-0643947b4240@redhat.com>
Date:   Wed, 26 Aug 2020 14:07:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8390c20d2f7e638d166f7b771c3e11363a7852f6.1598382343.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/20 2:05 PM, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Update the sev_es_enabled() function return value to be based on the SEV
> policy that has been specified. SEV-ES is enabled if SEV is enabled and
> the SEV-ES policy bit is set in the policy object.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>   target/i386/sev.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 5146b788fb..153c2cba2c 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -70,6 +70,8 @@ struct SevGuestState {
>   #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
>   #define DEFAULT_SEV_DEVICE      "/dev/sev"
>   
> +#define GUEST_POLICY_SEV_ES_BIT (1 << 2)
> +
>   /* SEV Information Block GUID = 00f771de-1a7e-4fcb-890e-68c77e2fb44e */
>   #define SEV_INFO_BLOCK_GUID "\xde\x71\xf7\x00\x7e\x1a\xcb\x4f\x89\x0e\x68\xc7\x7e\x2f\xb4\x4e"
>   
> @@ -374,7 +376,7 @@ sev_enabled(void)
>   bool
>   sev_es_enabled(void)
>   {
> -    return false;
> +    return (sev_enabled() && (sev_guest->policy & GUEST_POLICY_SEV_ES_BIT));

checkpatch wants these outer parentheses removed :-)

>   }
>   
>   uint64_t
> 


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B5231EC02
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 17:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbhBRQH2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 11:07:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36132 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232464AbhBRMxP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Feb 2021 07:53:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613652656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G1+c/zNnGBxuuXf4uV5rPzBui+5+v2sjTvTk5kBuJec=;
        b=XAnUhkxmUmL5/GnTEe3zh6KcivEePKGVNKTG8seFRpSS0lQKVpjr+yKJCOXfHM5xnOUXu0
        jaUZUP4SfsvhCVseCipjbg5Z4Jd3M8qaaHxto2vTI5IRvPwxg94KmlYof1GAMy82GHnGjw
        YAznB8GEtRxlmeTnilNEVWTh/hDwsic=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-jV5zgdPQMRq_zPssP7Sbbw-1; Thu, 18 Feb 2021 07:50:55 -0500
X-MC-Unique: jV5zgdPQMRq_zPssP7Sbbw-1
Received: by mail-wr1-f70.google.com with SMTP id e11so904558wro.19
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 04:50:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G1+c/zNnGBxuuXf4uV5rPzBui+5+v2sjTvTk5kBuJec=;
        b=DirccvVYL52HykgvJfs5HSXiMg1FuhUJfLrAJIwGkMX/A/eLumJT9lhhA63dSEuHZb
         kdxblLlNIqQ52+71OPvXDYf1CW/ME1UZ2Qvnm/rmBBPR3xArzFgTtWNw22ZXIqRzFmvD
         qNVZIq5gYL6+z6E+0NymOrdXQu52GmAtGYtpLD/Wj+spZTCQHXJdBWZOScKqK1BTbfwU
         DX8UHh2idSdBqgHxNAphMdEE4spPaSseBxOnlodIs88FE/LWN2DuVTyZz7Hx4LoHl95O
         e7WE7FTpa23vIQhBicrjnUywOkjvkQ+D8prsLn6Y/Mu7avRnF3RHMvYmwUc0PuQUhgQL
         V1Vg==
X-Gm-Message-State: AOAM530NcU1FCI0JVRfy/HS1uQvmXXsY+LkDXZmE+rb4+yL/hwySGAGN
        6M3g7wKf1CEC65VdnzX07gIMx4X009Qr6e8U9kt0EyzRliBQI0tjkCK84nvoCsIrQZUU9ncWMSW
        7brqU5E2rxoIU
X-Received: by 2002:a7b:c747:: with SMTP id w7mr3462359wmk.140.1613652653594;
        Thu, 18 Feb 2021 04:50:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy3iHYYfg2haqJPUXVivJv5QYxnqIZdBWANeT/jritdfSj3F3J8C8Vz6tA/beauDMbaoXaXRg==
X-Received: by 2002:a7b:c747:: with SMTP id w7mr3462341wmk.140.1613652653400;
        Thu, 18 Feb 2021 04:50:53 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id a9sm8528035wrn.60.2021.02.18.04.50.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Feb 2021 04:50:52 -0800 (PST)
Subject: Re: [PATCH 10/14] KVM: x86: Further clarify the logic and comments
 for toggling log dirty
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Makarand Sonare <makarandsonare@google.com>
References: <20210213005015.1651772-1-seanjc@google.com>
 <20210213005015.1651772-11-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2d455c2e-1db4-5aff-45eb-529e68127fe7@redhat.com>
Date:   Thu, 18 Feb 2021 13:50:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210213005015.1651772-11-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/02/21 01:50, Sean Christopherson wrote:
> 
> -	 * Nothing to do for RO slots or CREATE/MOVE/DELETE of a slot.
> -	 * See comments below.
> +	 * Nothing to do for RO slots (which can't be dirtied and can't be made
> +	 * writable) or CREATE/MOVE/DELETE of a slot.  See comments below.
>  	 */
>  	if ((change != KVM_MR_FLAGS_ONLY) || (new->flags & KVM_MEM_READONLY))
>  		return;
>  
> +	/*
> +	 * READONLY and non-flags changes were filtered out above, and the only
> +	 * other flag is LOG_DIRTY_PAGES, i.e. something is wrong if dirty
> +	 * logging isn't being toggled on or off.
> +	 */
> +	if (WARN_ON_ONCE(!((old->flags ^ new->flags) & KVM_MEM_LOG_DIRTY_PAGES)))
> +		return;
> +

What about readonly -> readwrite changes?

Paolo


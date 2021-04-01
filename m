Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAEA351909
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 19:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234722AbhDARtB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:49:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21063 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234520AbhDARqQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:46:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GbN00XAl17jTfdcL36pqLI9NxKBduDGkH9PWAr5DUrU=;
        b=Xr7VCzEySmV5b2/mWiF7fTw1qYioaRTFPX2X4VZVsXmtCI3Ayb4i8Rx0lsswVHtGUqRuk/
        wncsuK58UUKcCosC6qMqIm0X0vQ5wgb6t80gTEJ7sbmZfOveoSXUQolHm92jEQ1gpWcVv6
        btRGa57+AF5AfbSnKqRdV9/pYaK1E/M=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-R5pcnLVTMvCC8O1ASRxAQQ-1; Thu, 01 Apr 2021 10:45:32 -0400
X-MC-Unique: R5pcnLVTMvCC8O1ASRxAQQ-1
Received: by mail-ed1-f70.google.com with SMTP id r19so2961538edv.3
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 07:45:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GbN00XAl17jTfdcL36pqLI9NxKBduDGkH9PWAr5DUrU=;
        b=Us/NUnvN34bunRBjNE+bTtgtpgHuxO7Bhs7Hv+fIbl1qAK0JNAz/9wmwj6HUZ81uCT
         i34OwNHmhXP4DjZFfbcQdHO+rQRdCtvx0K9yfECrVwSEBWmg8feQHoW1DChVQikDuYSp
         ya/MN+uL9J6Bwrt82ceEtdpBuGxmryzMHwtccJ77SJHZZCN5WIWQVLsU3HjZW7sEd5yt
         XtAnAQpTRpnTov4+lTnx/W7DmMF4rUqt+TKG8kHcd7UDpP10AmN9sbNTzy7t3JPIJ37Q
         0A+chujt5JWUTE+sXT18+Fff5wtsC3rxkZBEWzRfZXBdIrSxTvZE+1KRAUrSGiELzW8R
         7egw==
X-Gm-Message-State: AOAM5323RogtHGtaOvaemCrgdnj+hOtODjhcW6Ps9PU2xYrtJNx6fpwe
        bvgRv6sTtjpKu6Evskh8Iw+X6ly3JeklqV0LBsHrmktJQoany0nHBseV4eYcW5N7Fmxfu51PKXO
        +Xzz32UNotwE4kci7bP07DKuGFLnDvSj1S4YCZCmmPN1pXPXil2+8jvG1hA51Fl91
X-Received: by 2002:a05:6402:1a3c:: with SMTP id be28mr10314058edb.125.1617288330546;
        Thu, 01 Apr 2021 07:45:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0BiWLs8rgC3v72usoRnhjcbcl9AJPbTfNdkmdteh68PTju1z4CTFTvtjEovIrggDeSZOqqA==
X-Received: by 2002:a05:6402:1a3c:: with SMTP id be28mr10314041edb.125.1617288330328;
        Thu, 01 Apr 2021 07:45:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ho19sm2798579ejc.57.2021.04.01.07.45.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 07:45:29 -0700 (PDT)
Subject: Re: [PATCH -next] KVM: selftests: remove redundant semi-colon
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210401142514.1688199-1-yangyingliang@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c1f44dca-a703-e68f-ec29-0d14671c2e6e@redhat.com>
Date:   Thu, 1 Apr 2021 16:45:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210401142514.1688199-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/04/21 16:25, Yang Yingliang wrote:
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>   tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
> index 804ff5ff022d..1f4a0599683c 100644
> --- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
> @@ -186,7 +186,7 @@ int main(int argc, char *argv[])
>   		vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &st);
>   	}
>   
> -	struct vcpu_runstate_info *rs = addr_gpa2hva(vm, RUNSTATE_ADDR);;
> +	struct vcpu_runstate_info *rs = addr_gpa2hva(vm, RUNSTATE_ADDR);
>   	rs->state = 0x5a;
>   
>   	for (;;) {
> 

Queued, thanks.

Paolo


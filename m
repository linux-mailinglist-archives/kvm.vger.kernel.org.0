Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69034121C3
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 20:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358935AbhITSI4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 14:08:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29114 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358503AbhITSGy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 14:06:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632161126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MQ2nEJldCi7rrPXAbLdRM2HtG7wBW/RDodqNONHFaZI=;
        b=F2pRRfTNFJHmB/wlADRyrEA9xvTXJEzP4zysDfJW8Q2C5mBeVjihsw0mY9sdA3UgvYKIle
        ou4p/ZN+JLKlk4GH8V84NqAHrGkxLDuX3Y6zRP9vGRvG6+DYMjl/Es5Bk1UuyD9N/fAe71
        MXsAz+Kp6qAFnfgN7+k4siG/vmGoFHs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-AM6g02tjPT2vMgFIyUlM6g-1; Mon, 20 Sep 2021 14:05:25 -0400
X-MC-Unique: AM6g02tjPT2vMgFIyUlM6g-1
Received: by mail-wr1-f72.google.com with SMTP id s13-20020a5d69cd000000b00159d49442cbso6759923wrw.13
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 11:05:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MQ2nEJldCi7rrPXAbLdRM2HtG7wBW/RDodqNONHFaZI=;
        b=w9+nWnp7BYCkUaas2+70oPTdF5w+t6SlQPes16zj1V7Iw9Nu6k1jzYr0D/JzdchRfo
         R3T6J4brmLkS0Ckl6ziXf6/z3SIL8Cb3nUGugOywue67PFWCoC1Hf+ztp4f6GUKqZRJy
         JPHEsbm3+ZdWNZqOFwT1spAPid7GJQWNNwURuCN72/lHpuC8rMlxUNbmBnxutygjgL0s
         7M1FGDCOqeOT3VF68z5sHee8BZ4WWDe8E1vXJZJf69DuFzkZqVrguGzQYi+G+XAZgbnB
         LbeoXs80b5jTkgpZoIyK5UarLhJ8Op/ZJudLW9XGD6ztZbYg2fN+/qCN0PvxQvBqWZgu
         tiTg==
X-Gm-Message-State: AOAM53029azF0buYzOY1UgIQnyjdrjKODpiFN+w7wOlXfoGvqzjSkxMc
        b7DJknS/F1WhZZeC7wHk+2svytIvF4VT7/QvU+0lWTBH52IB+ACkGANAWPDk0zRvM9hXPxRg0uZ
        Zhv0pdN1eZUzx
X-Received: by 2002:a5d:598c:: with SMTP id n12mr29456619wri.391.1632161124507;
        Mon, 20 Sep 2021 11:05:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyYp4hW7E1g6b+/rISmMbNzmIAqnwgwgNMeutkchln13LhBXc0BGdLZt9ZAqx8AsyogmjkBZg==
X-Received: by 2002:a5d:598c:: with SMTP id n12mr29456593wri.391.1632161124284;
        Mon, 20 Sep 2021 11:05:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l15sm207553wme.42.2021.09.20.11.05.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 11:05:23 -0700 (PDT)
Subject: Re: [PATCH 0/1] KVM: s390: backport for stable of "KVM: s390: index
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, KVM <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
References: <20210920150616.15668-1-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b9b9e014-d8d9-1a76-679b-cd7af54ad3f9@redhat.com>
Date:   Mon, 20 Sep 2021 20:05:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210920150616.15668-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/09/21 17:06, Christian Borntraeger wrote:
> here is a backport for 4.19 of
> commit a3e03bc1368 ("KVM: s390: index kvm->arch.idle_mask by vcpu_idx")
> This basically removes the kick_mask parts that were introduced with
> kernel 5.0 and fixes up the location of the idle_mask to the older
> place.
> 
> FWIW, it might be a good idea to also backport
> 8750e72a79dd ("KVM: remember position in kvm->vcpus array") to avoid
> a performance regression for large guests (many vCPUs) when this patch
> is applied.
> @Paolo Bonzini, would you be ok with 8750e72a79dd in older stable releases?

Sure, I suppose you're going to send a separate backport that I can ack.

Paolo


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6F449C893
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 12:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240681AbiAZLZ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 06:25:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22672 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240684AbiAZLZS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Jan 2022 06:25:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643196317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RugB18zzKbRgn6LvZeyf1FoU4E7um+w9W1X5QJPzYFM=;
        b=bgW2hP4MTtiL8XbjiHF63F59ukW4RQFZZLyCqyfBfdzGVsUepHv+j0hsx9EsEZXfc07Wof
        tepT1lfmq9IF+HviFnKRK0OjiTFNjm1avAlD6Bg878YKmconbafRcQSw4eaz/5TeQ0V3tV
        KnpjSpWm5mMVVLTXecuSCCC6TvdOGAI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-524-R32uVzVwN1ykyfw6w2J1uQ-1; Wed, 26 Jan 2022 06:25:16 -0500
X-MC-Unique: R32uVzVwN1ykyfw6w2J1uQ-1
Received: by mail-ed1-f72.google.com with SMTP id k10-20020a50cb8a000000b00403c8326f2aso16601122edi.6
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 03:25:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RugB18zzKbRgn6LvZeyf1FoU4E7um+w9W1X5QJPzYFM=;
        b=o0xTbEKV7QdGMquAKo1WOvlD5bhqyKUvLBeeB4y6gf+mQfn+0YdvdF0QuKK5Pz0ALz
         eGKY5+TbFocaLMgj0a3fbRYa3DpW7NlaQA/W695bSvlMezP2wI1Hs46y1cOjhQQRsQVP
         lsGnHRxVITJGbxrNOz3HQCU382NYwJufvIvXcYoh6d7WYlfuThvJ/RNm0appBSgA79qd
         0G0bkkh1LbKhqnFOpBM5sS70aI1uHO9dLN9Qfz9WqjY+M3VivWX5MZeA7Cku7PG21jeW
         mmfsd2zoOgNFMbP0LwJmOTI2cEQG32pBTXdnZhbW6qKmvZ9BcVgZA9W/o6ItIfUzi4rc
         9nnw==
X-Gm-Message-State: AOAM531fwoTkD3tR7vA6Hte8wsbCWzrH0DCYWvNahspbTnkJkC8cZmMr
        DiH2sIAPy/X+J3buunADQZd0c2L4s2kG8szeecew2LB6g0tSU0TSf+WLPrrxS15Uvab7PnPWXgr
        ug+CHC2XcdiEN
X-Received: by 2002:a05:6402:438a:: with SMTP id o10mr4302424edc.342.1643196315162;
        Wed, 26 Jan 2022 03:25:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxImZKf6pR4oZC3qtFGS/4GlD++FABJyJ71KQ0vadXdqMog7wkfs9WYkA8tcKQSDzy+j2+lPA==
X-Received: by 2002:a05:6402:438a:: with SMTP id o10mr4302410edc.342.1643196315002;
        Wed, 26 Jan 2022 03:25:15 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id q10sm7328671ejn.3.2022.01.26.03.25.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 03:25:14 -0800 (PST)
Message-ID: <7a8940e0-499c-000e-351a-fe1825f7d9ba@redhat.com>
Date:   Wed, 26 Jan 2022 12:25:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: x86: Free kvm_cpuid_entry2 array on post-KVM_RUN
 KVM_SET_CPUID{,2}
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+be576ad7655690586eec@syzkaller.appspotmail.com
References: <20220125210445.2053429-1-seanjc@google.com>
 <875yq6iwjc.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <875yq6iwjc.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/26/22 12:08, Vitaly Kuznetsov wrote:
> Reviewed-by: Vitaly Kuznetsov<vkuznets@redhat.com>

Queued, thanks.

Paolo


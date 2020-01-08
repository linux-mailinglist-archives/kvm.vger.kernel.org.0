Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E25E7134BA3
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 20:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730380AbgAHToS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 14:44:18 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51271 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730375AbgAHToR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jan 2020 14:44:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578512656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cMRQrznsbzSjtlf0lQFDY0JtcAwrzSd+QX0zX3BOs2k=;
        b=U4R/z2wjnhpVqgExCJtBd2XJkDo7bTAjaZ8CxmxdnaVM33AyL85beHVVjieeAy9kwDcyZR
        k34pw0wi4akbthHTogyQpJgjFiUcfLU8BbuJBJVbn+aNUIf8BtgjDYWf/avy8ROLTm1yWY
        csUtglmLTI0CWUfJCOGBR884tJmjyKg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55-5mAXwX0yMbK2ycLEjpNs7A-1; Wed, 08 Jan 2020 14:44:13 -0500
X-MC-Unique: 5mAXwX0yMbK2ycLEjpNs7A-1
Received: by mail-wr1-f72.google.com with SMTP id l20so1849523wrc.13
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2020 11:44:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cMRQrznsbzSjtlf0lQFDY0JtcAwrzSd+QX0zX3BOs2k=;
        b=KsH1bkJEFqZI6wzeToY4EJcwgsMU2YlWnX6nuFI5fOiYrYp6Wtg0HzVX9TrSJDYUCm
         H+l9fyDAZLFdmsJlVMofsgMkzivH/ZCuKDBGpofFjTVxVYe1PyUHmHlInRThxvMBiEFd
         eNtbjvGX7I4r2hsrXPABTboUXalkfr7EIeiRvd6tE73nOwox3pfJKxT2cM43neshWk30
         S/bHC1CTduIFqoK7rzQv5USuHbLSkdpf5dqOiBnFu/FmlSYPHzldTZF1DFWhZqoU8wZZ
         Pn23q0gOcGKbd5FP9bdB5J1yjvk/Lyc2b2/QcMoY4s6RzEz8W2UqR7CaIdOI6/YglhkA
         rSGQ==
X-Gm-Message-State: APjAAAX6/FCSqGEB4Z+QmMbzEr1qtc43sDbuom5KOC8dvxRo7Ae7ZrZW
        S1nEA6RmKUyRpZWQa27TuuhnMurMkKdjdCvxgmJsi/TDjkvbvTsgdH35V0jHYiLCE9GrAkfFm8c
        P1CI6kFL5/oUk
X-Received: by 2002:a05:600c:248:: with SMTP id 8mr235690wmj.175.1578512652205;
        Wed, 08 Jan 2020 11:44:12 -0800 (PST)
X-Google-Smtp-Source: APXvYqx6Udq5HntGuIazbWsfw/ygAYHPKVLZ9sImXcCCWDU0SWSRt+amBVLXlg+oTsMtN3geDV3w3Q==
X-Received: by 2002:a05:600c:248:: with SMTP id 8mr235672wmj.175.1578512652012;
        Wed, 08 Jan 2020 11:44:12 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c6d:4079:b74c:e329? ([2001:b07:6468:f312:c6d:4079:b74c:e329])
        by smtp.gmail.com with ESMTPSA id m7sm127875wma.39.2020.01.08.11.44.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 11:44:11 -0800 (PST)
Subject: Re: [PATCH RESEND v2 03/17] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191221014938.58831-1-peterx@redhat.com>
 <20191221014938.58831-4-peterx@redhat.com>
 <cf232ce8-bc07-0192-580f-d08736980273@redhat.com>
 <20191223172737.GA81196@xz-x1>
 <851bd9ed-3ff3-6aef-725c-b586d819211c@redhat.com>
 <20191223201024.GB90172@xz-x1>
 <e56d4157-1a0a-3f45-0e02-ac7c10fccf96@redhat.com>
 <20200108191512.GF7096@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <649c77ba-94a7-d0bf-69e7-fa0276f536d1@redhat.com>
Date:   Wed, 8 Jan 2020 20:44:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200108191512.GF7096@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/01/20 20:15, Peter Xu wrote:
> But you seemed to have fixed that already? :)

Perhaps. :)

> 3898da947bba ("KVM: avoid using rcu_dereference_protected", 2017-08-02)
> 
> And this path is after kvm_destroy_vm() so kvm->users_count should be 0.
> Or I feel like we need to have more places to take the lock..

Yeah, it should be okay assuming you test with lockdep.

Paolo


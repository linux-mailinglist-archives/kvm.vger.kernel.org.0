Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8CD40CF57
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 00:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhIOWey (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 18:34:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21871 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232866AbhIOWes (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Sep 2021 18:34:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631745208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fDx/Hr0zc1j4NXN/rU1ooxqT+kr9dmLC76FBxnVhemM=;
        b=SVHebgT+o/jk+1jy8zPXh5kIuVUAus2ZPKrzdqieeAx5n1WB1xEL3XJVeMzIxAHWb938vi
        F0/pXY8LOxmxFXnmfUpdxdZFICj3v1p3P5BkgVilORin9RR92/QH+ypcdtcraIDVwYNG6K
        y/N1ZfJafu09MphvoOoxn2wX/VCZtJ4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-WX9IZRcLP2-BT6tpGPJFow-1; Wed, 15 Sep 2021 18:33:27 -0400
X-MC-Unique: WX9IZRcLP2-BT6tpGPJFow-1
Received: by mail-ed1-f69.google.com with SMTP id b8-20020a056402350800b003c5e3d4e2a7so3152988edd.2
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 15:33:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fDx/Hr0zc1j4NXN/rU1ooxqT+kr9dmLC76FBxnVhemM=;
        b=tv1ug2baj1qxXuqI2XpRTLcsTzdLqtSUe6MP+hEB0UAFR+RzXxvAbCTnTbNNdnVFoG
         3acMNnBUpqk/ZfdsFfXaJz8+pcO94WE3GoXIs8H9BH7z11R6Pai7QPrZz0dMQBmF4SRS
         pNsik14nWjpWHJ1SOZv6IU6vj67LBLhTsIp4GDl1V7BWO0X7l/lDTYyiWeS1CVwzcxzX
         m/ZWGtUCZLaGNZ3D05ruB/ZrTxigF8ZbgegWqDuLYfgTNUv3mzYrA9vGD0M2lIv/AZ2f
         SesyXduVfNAYlUQ2vwZ8xflyix0xyDd9g+3W5EiqEEqeaGV9D0GWDY9ZqUF9o2rp+6QZ
         NJyQ==
X-Gm-Message-State: AOAM531pnLXODtYFBU0+COvMkFnSy+mZe7Y7y+OeKhTzEPL/vQdTDtDm
        tzu2HmKfAhbFL9KOIlyqFPBTDe2HxYmvhwctjI66ws0/xFM4SeR+61N01UljA8BAxI2ktLKPFhj
        baL/rCV2ERao7
X-Received: by 2002:a05:6402:1428:: with SMTP id c8mr2269619edx.128.1631745206103;
        Wed, 15 Sep 2021 15:33:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxUJFtYM9G6+R9bGG1vMz7osgEWwyPrwk4Z98OZ0Q4jPrnjDELrmFauFLB3m0vrCnBTkdhmGw==
X-Received: by 2002:a05:6402:1428:: with SMTP id c8mr2269599edx.128.1631745205935;
        Wed, 15 Sep 2021 15:33:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id w25sm580072edi.22.2021.09.15.15.33.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 15:33:25 -0700 (PDT)
Subject: Re: [PATCH] KVM: SEV: Disable KVM_CAP_VM_COPY_ENC_CONTEXT_FROM for
 SEV-ES
To:     Peter Gonda <pgonda@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>, Marc Orr <marcorr@google.com>,
        Nathan Tempelman <natet@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org
References: <20210914171551.3223715-1-pgonda@google.com>
 <YUDcvRB3/QOXSi8H@google.com>
 <CAMkAt6opZoFfW_DiyJUREBAtd8503C6j+ZbjS9YL3z+bhqHR8Q@mail.gmail.com>
 <YUDsy4W0/FeIEJDr@google.com>
 <CAMkAt6r9W=bTzLkojjAuc5VpwJnSzg7+JUp=rnK-jO88hSKmxw@mail.gmail.com>
 <YUDuv1aTauPz9aqo@google.com>
 <8d58d4cb-bc0b-30a9-6218-323c9ffd1037@redhat.com>
 <CAMkAt6oPijfkPjT4ARpVmXfdczChf2k3ACBwK0YZeuGOxMAE8Q@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9feed4e4-937e-2f11-bb56-0da5959c7dbd@redhat.com>
Date:   Thu, 16 Sep 2021 00:33:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAMkAt6oPijfkPjT4ARpVmXfdczChf2k3ACBwK0YZeuGOxMAE8Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/09/21 18:10, Peter Gonda wrote:
> svm_vm_copy_asid_from() {
> 
>     asid = to_kvm_svm(source_kvm)->sev_info.asid;
> + handle = to_kvm_svm(source_kvm)->sev_info.handle;
> + fd = to_kvm_svm(source_kvm)->sev_info.fd;
> + es_active = to_kvm_svm(source_kvm)->sev_info.es_active;
> 
> ...
> 
>      /* Set enc_context_owner and copy its encryption context over */
>      mirror_sev = &to_kvm_svm(kvm)->sev_info;
>      mirror_sev->enc_context_owner = source_kvm;
>      mirror_sev->asid = asid;
>      mirror_sev->active = true;
> +  mirror_sev->handle = handle;
> +  mirror_sev->fd = fd;
> + mirror_sev->es_active = es_active;
> 
> Paolo would you prefer a patch to enable ES mirroring or continue with
> this patch to disable it for now?

If it's possible to enable it, it would be better.  The above would be a 
reasonable patch for 5.15-rc.

Paolo


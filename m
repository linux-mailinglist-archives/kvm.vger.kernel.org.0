Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB8541C332
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 13:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245648AbhI2LPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 07:15:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31639 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245643AbhI2LPw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Sep 2021 07:15:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632914050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t2qm0hCzWxCCkmN0krux7HAVAkutvn7TaWklAankZlA=;
        b=KK89QK7VIX1EDWh9/WyFGtptF4lwUqR3DpyiQVBLysd2BcMKQm10shUsshZ4vbOxeBP5JX
        VJAfXLOBdEoT3ycG14Juf7PZUMwkJpYJbDoCuayRKrqYsHfruObRKJ6NaUzDUWLGAKLPqW
        87vHfy3joooqBZryqmfzzgg8fIA8ZKo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-Bu4lqmt9Pw-4Li2__gCN4w-1; Wed, 29 Sep 2021 07:14:09 -0400
X-MC-Unique: Bu4lqmt9Pw-4Li2__gCN4w-1
Received: by mail-ed1-f70.google.com with SMTP id c7-20020a05640227c700b003d27f41f1d4so2002877ede.16
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 04:14:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=t2qm0hCzWxCCkmN0krux7HAVAkutvn7TaWklAankZlA=;
        b=7SQ5YFQnFSLd4q9XTNxsljdcjIxC8a+bS59b4pBtb8UbDAIYVkNUDmzznqIgdrdzyZ
         8siR/jK4qju2R8MVQotPVhSeupEWW+ck2MkdTlHRk2gBbZ1WjWFULgWKCb9JBmYhoTrY
         UAa19H5ep95eeNqpBy9l9loWap/pYituUNAmKvkLNfvOJcLH8C2dNGJwrOmIUc4f34tF
         q9Wg0VxPLl1qTvZ/9B7QbAS+Rb6gVIEqqJ2r4dsVM/ZfO/X+ZCDML6tDTYsw/PIjVn/9
         NbjTVplcgV0kfLHyf9svVRqOlZIj7hIFEAcGwsa1pTmgSq3gIAyvy6421xgkfaB1o40N
         ZSBw==
X-Gm-Message-State: AOAM531p1E11vVVZSatpkSn1BOzZwOSh14PMwy9M6PzHELahdBPpoYbC
        qsCQm48c3Bw1rXZEQlk5QZwYN1nCP7U2nwk75IetGh6wMDtgG04b4oH089N2T/n0Z2r+mUphYHV
        VmujR5F9yi68p
X-Received: by 2002:a17:906:1706:: with SMTP id c6mr13420346eje.343.1632914048400;
        Wed, 29 Sep 2021 04:14:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0xzNd3p3tUScVs7zgoHxcssecqfrmDnLfZ9bb6/8V3tpSWfOP7Z4wDUQW7OXzcoz/ymHWmQ==
X-Received: by 2002:a17:906:1706:: with SMTP id c6mr13420322eje.343.1632914048184;
        Wed, 29 Sep 2021 04:14:08 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b27sm1219844ejq.34.2021.09.29.04.14.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 04:14:07 -0700 (PDT)
Message-ID: <2ecaca21-fa8f-f4c1-db2b-8eee86719f6f@redhat.com>
Date:   Wed, 29 Sep 2021 13:13:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 02/31] KVM: MMU: Introduce struct kvm_page_fault
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, Isaku Yamahata <isaku.yamahata@intel.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
 <20210924163152.289027-3-pbonzini@redhat.com> <YVOkcn+PzZOpGRMA@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YVOkcn+PzZOpGRMA@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/09/21 01:25, David Matlack wrote:
>> +struct kvm_page_fault {
>> +	/* arguments to kvm_mmu_do_page_fault.  */
>> +	const gpa_t addr;
>> +	const u32 error_code;
>> +	const bool prefault;
> This is somewhat tangential to your change but... I notice KVM uses
> "prefetch" and "prefault" interchangably. If we changed prefault to
> prefetch here and in kvm_mmu_do_page_fault then that would make the
> naming consistent throughout KVM ("prefetch" for everything).
> 

Sounds good.

Paolo


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15FA330DB99
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 14:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbhBCNpk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 08:45:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31423 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231191AbhBCNpb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 08:45:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612359843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rMTxFGzrVtGEGdHLyMJ6IG139/h72tFVSylD4K14Tow=;
        b=Kdg9mlH04IyUsHnKROjNOR5djVvgKS17BwoKtDwS3skkq/8Xm8/KdDn9seyUTo64hlHgIh
        JFFemveDw9de10bWCvZvF8tX5yJJ/NyGw2ZaCW57jWBihoa+pgVQ/+cObBsq4sBDNK2DNP
        2BFhOoUmTkrdl30yt6jxSrqc/RpHTx8=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-lQRn4gi-Pra4ntCwI_MXdg-1; Wed, 03 Feb 2021 08:44:01 -0500
X-MC-Unique: lQRn4gi-Pra4ntCwI_MXdg-1
Received: by mail-ej1-f69.google.com with SMTP id p1so12009054ejo.4
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 05:44:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rMTxFGzrVtGEGdHLyMJ6IG139/h72tFVSylD4K14Tow=;
        b=j0xO6oZcZv1Ow+t0JKgJoKBZWyzgmNcbseb62N2PaqS+Dw2iKPVivSkCYh8RfqoLA+
         +OsJbFH2aDhTchOWzto8hDKWF3Sa8UzOs6O0y9WRlIIWwSoXVw248pSdT8be6JpUxmIG
         1Zz8oMXbhjprk+9bYDrlv+0LfdDx3f+FC9mBH76w1+WNKB0GRt6o0pU+fnUiv+Ro62N4
         gEjbE95+d23TsZLSD/Qph0ya3dcM2rUEu0OI3oZZs2nVxn0UXFFqeJaYM53wpqJ8gg3h
         xhD91KMif4QgcVWeXggsYx2MphDINVAOChWHFghmnw6au3SKQ/S1x6hkLGJRBFZvIHbf
         nvpg==
X-Gm-Message-State: AOAM532JsucvAKwun2ehNm76zlqyZsNHHn4MXT771Do+WSsHInDUAhpR
        HTnrNosmbmSexlILJWH6/jJmWNbCzQI6L0fyrY4HETL06faHXuCRRqW66u6/mP3aMAxgTUuwm33
        kH23u2R8Hqsgi
X-Received: by 2002:a05:6402:190a:: with SMTP id e10mr3036506edz.110.1612359839994;
        Wed, 03 Feb 2021 05:43:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwRuu7HF/4XTgCJqXg8PsMsQx9zKJmyCz6inusCYsZiiUnhXheDvQ4JIut13HEEy3SnuPt6yQ==
X-Received: by 2002:a05:6402:190a:: with SMTP id e10mr3036488edz.110.1612359839798;
        Wed, 03 Feb 2021 05:43:59 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id hr31sm998395ejc.125.2021.02.03.05.43.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 05:43:58 -0800 (PST)
Subject: Re: [PATCH 2/2] KVM: Scalable memslots implementation
To:     Sean Christopherson <seanjc@google.com>,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <ceb96527b6f7bb662eec813f05b897a551ebd0b2.1612140117.git.maciej.szmigiero@oracle.com>
 <4d748e0fd50bac68ece6952129aed319502b6853.1612140117.git.maciej.szmigiero@oracle.com>
 <YBisBkSYPoaOM42F@google.com>
 <9e6ca093-35c3-7cca-443b-9f635df4891d@maciej.szmigiero.name>
 <YBnjso2OeX1/r3Ls@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9caed824-a3ab-cd23-457e-cb35bb913f91@redhat.com>
Date:   Wed, 3 Feb 2021 14:43:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YBnjso2OeX1/r3Ls@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/21 00:43, Sean Christopherson wrote:
>> But overall, this solution (and the one with id_to_index moved into the
>> main array, too) is still O(n) per memslot operation as you still need to
>> copy the array to either make space for the new memslot or to remove the
>> hole from the removed memslot.
> 
> Yes, but that problem that can be solved separately from the performance issue
> with hva lookups.

I know the world is not just QEMU, but I'll note that in QEMU all 
memslot operations are roughly O(n) anyway.

> Dumping everything into a single patch makes bisecting nearly worthless, e.g. if
> fast hva lookups breaks a non-x86 architecture, we should able to bisect to
> exactly that, not a massive patch that completely rewrites all of the memslot
> code in one fell swoop.
> 
> Mega patches with multiple logical changes are also extremely difficult to
> review.

Indeed.  This patch does get a +1 for having associated selftests, but 
the diffstat puts it back at the bottom of the pile. :)

Paolo


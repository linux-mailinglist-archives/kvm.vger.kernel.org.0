Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F09263479
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 19:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgIIRVB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 13:21:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31990 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725772AbgIIRUv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Sep 2020 13:20:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599672049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SQhMq/j8wv9M8NJ35HTtp9bCIMUSj7eRfqejEmxcMqo=;
        b=cLeWxLFHejbF+RskiKFjQm/8TACiJfE7HL2FSTzU/7GRTmlV3MV+oAB+NQJ9pLAA/+tGzP
        ydIkRKQ6HxMRE0ClcPVE6bOnqvOpdjN8371zvmnxK4aiW3N8NrEO959vnq8ffnuIVT2GhF
        utAPRMgXM9mfYz1DexaoRUGycNf0z+Q=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-XhkHZIIDMxiWou3VSwcqGQ-1; Wed, 09 Sep 2020 13:20:47 -0400
X-MC-Unique: XhkHZIIDMxiWou3VSwcqGQ-1
Received: by mail-ed1-f71.google.com with SMTP id d13so1294768edz.18
        for <kvm@vger.kernel.org>; Wed, 09 Sep 2020 10:20:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SQhMq/j8wv9M8NJ35HTtp9bCIMUSj7eRfqejEmxcMqo=;
        b=pCUOFmrbDokntcFsArvpA2+Zskbs4Oqpdbnv6cVLBR0lU8DPcFE8SS9Dy1MWQRr5eh
         yXdkIElibpsdPVz0acli1+qewywxj7OcEhDkkqKK/+8CLU8+TO0pZBA4mWFtJtLDFmRA
         IP1GhJif2QoBYiPCS4S4iFzNHC3Kj7xSIsS4pH8cGL/SaY2MIp41dHf9bJTUArpgaIsi
         zAcswsBP0gslQiN2dXpvukk20hAAtckYRCJ0BxmjSLbwJCBekLk84DAwzlTYQ52A8Sk4
         MYp7gwO6MaJal18OseGHW8ii9UMBKFDXDdZTUn+bToBHfp17gSAAJJ0aotIb2BQHBdkZ
         ONHg==
X-Gm-Message-State: AOAM530LVdTIvq6BdF06+AkmFsOHXLetgHlAUOwKQtqQnDvvqGXvYc/2
        vTRVWPs2JDohE/VSHxNNwg9aCGJJl7YO0YaHAtXJc8lJZZqnbQRmdwVzamjiwMx8eVZlXQXi/Hj
        KpzEBdSYhr6DG
X-Received: by 2002:a17:906:341b:: with SMTP id c27mr4649988ejb.286.1599672045702;
        Wed, 09 Sep 2020 10:20:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyR0JhfniAOR3Q+4CaV0GSjjn8Qc/IDCqbAtZUAVgDJOvsx1CXOnPyuh1xtlTC2wLiQ4Me5wg==
X-Received: by 2002:a17:906:341b:: with SMTP id c27mr4649973ejb.286.1599672045510;
        Wed, 09 Sep 2020 10:20:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:37de:1d96:8ea2:b59a? ([2001:b07:6468:f312:37de:1d96:8ea2:b59a])
        by smtp.gmail.com with ESMTPSA id b13sm3229274edf.89.2020.09.09.10.20.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 10:20:44 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.9
To:     Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Steven Price <steven.price@arm.com>, kernel-team@android.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
References: <20200904104530.1082676-1-maz@kernel.org>
 <f7afbf0f-2e14-2720-5d23-2cd01982e4d1@redhat.com>
 <fea2e35a29967075e46d25220044c109@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8cba9da1-d2f4-efad-358d-92c510e9d05f@redhat.com>
Date:   Wed, 9 Sep 2020 19:20:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <fea2e35a29967075e46d25220044c109@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/09/20 19:15, Marc Zyngier wrote:
> On 2020-09-09 16:20, Paolo Bonzini wrote:
>> On 04/09/20 12:45, Marc Zyngier wrote:
>>> Hi Paolo,
>>>
>>> Here's a bunch of fixes for 5.9. The gist of it is the stolen time
>>> rework from Andrew, but we also have a couple of MM fixes that have
>>> surfaced as people have started to use hugetlbfs in anger.
>>
>> Hi Marc,
>>
>> I'll get to this next Friday.
> 
> Thanks. I may have another one for you by then though...

Sure, you can choose whether to send a separate tag or update this one.

Paolo


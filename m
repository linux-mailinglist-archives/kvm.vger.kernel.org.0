Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E017527582E
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 14:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgIWMrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 08:47:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33032 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726565AbgIWMrT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 08:47:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600865237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KJsdXhDDqjRHS8t5tnX7yDDdZ5IGSJuOwOp+o1xOXrs=;
        b=Q/vEisISeC+CyxX1KIvFjqXatYh5MOH+G+qp0ABDOlFzT/y0iuNvKsht1ZEbhKnm1rRvhK
        32FaRDN5pBGUij2jM3GoPVpLg1/L5fCOPb9Drk+YfB+o2tL/TT/1gz1VVlQ/kDd1WI+8Hd
        2udwp2CrrNEdhAks+eHQpR4QdF7mfRA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-44D_p_xkM_CdvFV2VqrOGQ-1; Wed, 23 Sep 2020 08:47:16 -0400
X-MC-Unique: 44D_p_xkM_CdvFV2VqrOGQ-1
Received: by mail-wr1-f72.google.com with SMTP id s8so8754771wrb.15
        for <kvm@vger.kernel.org>; Wed, 23 Sep 2020 05:47:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KJsdXhDDqjRHS8t5tnX7yDDdZ5IGSJuOwOp+o1xOXrs=;
        b=gSvRNJb5PnheV8WSoLzCxRXsDuDkZNm2F/ftkkPytuHAqeN2N2fzMvdo0nq9nf8vOA
         WfoAOS0LI6tIgoDpIQDWpM9grX5u0WlA4iZx/+nG0Ws8A0YJsTX+XC3R1KF7HT4S+pev
         v8bN9Cj6whNTTP+hykwQ0FNc70DN9hDWLZmDTX7Rac0XQLc9yzYyU9fStRI/pl+edZxy
         sH9L1/oSHjPy726UFinyWOye9GNPUDwUjJOEPvOIT8Urb/uTY9vjZ22rGoroCV42EwiE
         jkVW4oGVPFlo/1kQrIUfAB9PRCefw8BfRV8cbCZ7r9iR+QIX/jv5ZBolf5RYuiBqaS1K
         tLvQ==
X-Gm-Message-State: AOAM531wMxf0IwJ2/mC+wW9Qa/y2gD35NU97+bllfPGec36HslMqbn9e
        s79+jFnOokfT6ZhfTFx7ut/nJAmxewuk0DidmnT+S6B5Ms9dSH+7UesYta7F3eKbKMUYk+Qh8AE
        BEOLYnh+zaJgX
X-Received: by 2002:a1c:f008:: with SMTP id a8mr6589347wmb.155.1600865234994;
        Wed, 23 Sep 2020 05:47:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygMVZid/MgX577mwoVfMTNg9cNIn89ro/qoGlGEac8toW1CeFDKmxTyu+mTjjfoo4HJnuGAg==
X-Received: by 2002:a1c:f008:: with SMTP id a8mr6589323wmb.155.1600865234757;
        Wed, 23 Sep 2020 05:47:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:15f1:648d:7de6:bad9? ([2001:b07:6468:f312:15f1:648d:7de6:bad9])
        by smtp.gmail.com with ESMTPSA id z19sm7903333wmi.3.2020.09.23.05.47.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 05:47:14 -0700 (PDT)
Subject: Re: [RFC Patch 0/2] KVM: SVM: Cgroup support for SVM SEV ASIDs
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vipin Sharma <vipinsh@google.com>
Cc:     thomas.lendacky@amd.com, tj@kernel.org, lizefan@huawei.com,
        joro@8bytes.org, corbet@lwn.net, brijesh.singh@amd.com,
        jon.grimm@amd.com, eric.vantassell@amd.com, gingell@google.com,
        rientjes@google.com, kvm@vger.kernel.org, x86@kernel.org,
        cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20200922004024.3699923-1-vipinsh@google.com>
 <20200922014836.GA26507@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <45117fcc-d6b8-fab9-11dc-79181058ed62@redhat.com>
Date:   Wed, 23 Sep 2020 14:47:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200922014836.GA26507@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/20 03:48, Sean Christopherson wrote:
> This should be genericized to not be SEV specific.  TDX has a similar
> scarcity issue in the form of key IDs, which IIUC are analogous to SEV ASIDs
> (gave myself a quick crash course on SEV ASIDs).  Functionally, I doubt it
> would change anything, I think it'd just be a bunch of renaming.  The hardest
> part would probably be figuring out a name :-).
> 
> Another idea would be to go even more generic and implement a KVM cgroup
> that accounts the number of VMs of a particular type, e.g. legacy, SEV,
> SEV-ES?, and TDX.  That has potential future problems though as it falls
> apart if hardware every supports 1:MANY VMs:KEYS, or if there is a need to
> account keys outside of KVM, e.g. if MKTME for non-KVM cases ever sees the
> light of day.

Or also MANY:1 (we are thinking of having multiple VMs share the same
SEV ASID).

It might even be the same on s390 and PPC, in which case we probably
want to implement this in virt/kvm.  Paul, Janosch, do you think this
would make sense for you?  The original commit message is below.

Paolo

> On Mon, Sep 21, 2020 at 05:40:22PM -0700, Vipin Sharma wrote:
>> Hello,
>>
>> This patch series adds a new SEV controller for tracking and limiting
>> the usage of SEV ASIDs on the AMD SVM platform.
>>
>> SEV ASIDs are used in creating encrypted VM and lightweight sandboxes
>> but this resource is in very limited quantity on a host.
>>
>> This limited quantity creates issues like SEV ASID starvation and
>> unoptimized scheduling in the cloud infrastructure.
>>
>> SEV controller provides SEV ASID tracking and resource control
>> mechanisms.


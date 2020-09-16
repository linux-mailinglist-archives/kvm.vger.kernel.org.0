Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B0F26C934
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 21:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbgIPTEa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 15:04:30 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47712 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727424AbgIPRqU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Sep 2020 13:46:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600278367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XRO16mMg5GaRKPmGz8IPQMX7zD3Ci0CVQkdQAp+eeDU=;
        b=GuDZ+YxuF5l38LkZfbJZtRHWLQ8tiMs3hYS8g12tGmPtbPrRiATDB5XY1jOMHwikHsW7T8
        dG8Xf4EKtaT9KqEa9H/gtNhGW2QboVwKedmpqK/VeGzgGBFibabvEOnsJP5lyltLquBiHU
        0RJVGrNemdpyPuGR28bc33OwKwNV1IE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-SdYUPXIiPmSvXL1sJj8WjA-1; Wed, 16 Sep 2020 07:04:47 -0400
X-MC-Unique: SdYUPXIiPmSvXL1sJj8WjA-1
Received: by mail-wm1-f71.google.com with SMTP id m125so885569wmm.7
        for <kvm@vger.kernel.org>; Wed, 16 Sep 2020 04:04:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=XRO16mMg5GaRKPmGz8IPQMX7zD3Ci0CVQkdQAp+eeDU=;
        b=gb417o4epVuCwTf1sTVYqJH5PcFQ48SMPtAeSKaU/D2XoSSRwgF1RE5NmY7NaDTVZR
         Zn0PCQoiuJncuTX1TGqzNtdjiwW+A6FyJi35oA/8H9vSq/0rqz9ygPoj0Y/14wxNda6g
         pBR/4O8WQhrJ0fdXHvNfo1Ne5GBgS7zEv29+gV/qlt+tJQY4qNBPOjzjL8qjKXDQjDQg
         T5M1nHyyIzUgPP9AoyQu21g+/vBhpZ+H43ZW8Djm5FqKhsAb1F6lt9tNEn2mafDoU5+K
         5XrsnVcGNDHre5cVSG9BcNcwqL5LfqEGOQX3Pqk1bdTsY4+Qq+uHim7oLDtOby16Mfpv
         /NYQ==
X-Gm-Message-State: AOAM532eDkvv/MBH50g+bpql2t6IZMQr5CNWsyk6+A9JlQBuL4tUyfjX
        aJcXgv2wTxLj2DNG/bgDj5QZDNhWTWBs8ZaqtOGlDtQKdRFDUR6EW1fKxosZuQQbmUPODge/lWT
        0kO0geZNET0gG
X-Received: by 2002:a1c:4886:: with SMTP id v128mr4176306wma.139.1600254285984;
        Wed, 16 Sep 2020 04:04:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXOwHgcuX4ilwFSwurcSnFqefL8bUg1Iqgl1HlBLU/S03zKb0qDPImdtVb99TfNdUw7AXySw==
X-Received: by 2002:a1c:4886:: with SMTP id v128mr4176289wma.139.1600254285795;
        Wed, 16 Sep 2020 04:04:45 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id l4sm4640990wme.43.2020.09.16.04.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 04:04:44 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Haiwei Li <lihaiwei.kernel@gmail.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Haiwei Li <lihaiwei@tencent.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH] Revert "KVM: Check the allocation of pv cpu mask"
In-Reply-To: <6c2204ad-590b-025d-f728-0e6e67bf24ba@gmail.com>
References: <20200916090342.748452-1-vkuznets@redhat.com> <6c2204ad-590b-025d-f728-0e6e67bf24ba@gmail.com>
Date:   Wed, 16 Sep 2020 13:04:43 +0200
Message-ID: <87een2htis.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Haiwei Li <lihaiwei.kernel@gmail.com> writes:

> On 20/9/16 17:03, Vitaly Kuznetsov wrote:
>> The commit 0f990222108d ("KVM: Check the allocation of pv cpu mask") we
>> have in 5.9-rc5 has two issue:
>> 1) Compilation fails for !CONFIG_SMP, see:
>>     https://bugzilla.kernel.org/show_bug.cgi?id=209285
>> 
>> 2) This commit completely disables PV TLB flush, see
>>     https://lore.kernel.org/kvm/87y2lrnnyf.fsf@vitty.brq.redhat.com/
>> 
>> The allocation problem is likely a theoretical one, if we don't
>> have memory that early in boot process we're likely doomed anyway.
>> Let's solve it properly later.
>
> Hi, i have sent a patchset to fix this commit.
>
> https://lore.kernel.org/kvm/20200914091148.95654-1-lihaiwei.kernel@gmail.com/T/#m6c27184012ee5438e5d91c09b1ba1b6a3ee30ee4
>
> What do you think?

Saw it, looks good to me. We are, however, already very, very late in 5.9
release cycle and the original issue you were addressing (allocation
failure) is likely a theoretical only I suggest we just revert it before
5.9 is released. For 5.9 we can certainly take your PATCH2 merged with
0f99022210.

This Paolo's call anyway)

-- 
Vitaly


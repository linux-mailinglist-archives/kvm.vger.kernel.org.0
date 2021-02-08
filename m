Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210CD313A08
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 17:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234646AbhBHQtn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 11:49:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26123 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234598AbhBHQsy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 11:48:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612802848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t6RPd2ztOuA6u1y6nTE2cHYvRbwTN8GogXecBm/aQ8w=;
        b=eNUQo+hJkLZAzRfFyQpLB8V+PeSerESZuRjqff5zgESdPYtxShTvhROP4+DgXM1xDpuqAn
        /7o+ZQT5tLPuBEBLB6p6I30DATIiwv61uq0stg2aJLrmVhc2aEUNrPbrmxpS+BBfsCSG/P
        hmmYZ5F1+frqc6no2qa2IURj+YaOElw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-Dz2_vgY1OxC4ZugtAnV3hA-1; Mon, 08 Feb 2021 11:47:26 -0500
X-MC-Unique: Dz2_vgY1OxC4ZugtAnV3hA-1
Received: by mail-wr1-f70.google.com with SMTP id u15so13569729wrn.3
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 08:47:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t6RPd2ztOuA6u1y6nTE2cHYvRbwTN8GogXecBm/aQ8w=;
        b=q35rEbXIozHQzUJkVPoM7onNEETg8C/VHLaoc57ZU12zPrxed7sPBWma99tIXeHUmI
         i1mctgV1xyYzFSm9oU3xNn+p/jTqGydVZMqqqfCYJ81adgM+JoWpo2+RFI080bWNLB5H
         9GusvK17aAWcU2JaeVlE9IwxG1nLxPhDn+tGxWLPeHlMQC+ZDr2TiuK8TFLlsxB21/iq
         RqytxDhJdiWgEB5IAcGgtXFOHUAfFcaoOKzTuACA1psFsTCAToreKF/DyT5gypJJoj0U
         nSiJhy0H2MYJUGhOK90mPzbFw8LktFpz3kWr5ALOeIemaLKeVyBrp7oj2NfsJwRMmcWj
         fPAg==
X-Gm-Message-State: AOAM533SRLX56x0AEgjeceT2Jcii57bST/4jGdkBJJyVUkjxBnomlXRg
        K9FnyNxiaZmI9vCmF5rK9XsYgv2opALZlTSsgYmtCjlP+AS+ovN2sJ4j5h2sLHr/hmkF5/iXk10
        9yv1Kg5UuDL2i
X-Received: by 2002:adf:f8cf:: with SMTP id f15mr6396823wrq.121.1612802845138;
        Mon, 08 Feb 2021 08:47:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz+x7o5xONPZbz4q96RSAQzdfp8ymrj0EcG2WRO3iNA0jt/1S8UBV/y5+iSpzqEDfITi9k07w==
X-Received: by 2002:adf:f8cf:: with SMTP id f15mr6396796wrq.121.1612802844823;
        Mon, 08 Feb 2021 08:47:24 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id 143sm21181798wmb.47.2021.02.08.08.47.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 08:47:23 -0800 (PST)
Subject: Re: [PATCH v2] KVM: x86/MMU: Do not check unsync status for root SP.
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     seanjc@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
References: <20210207122254.23056-1-yu.c.zhang@linux.intel.com>
 <671ae214-22b9-1d89-75cb-0c6da5230988@redhat.com>
 <20210208134923.smtvzeonvwxzdlwn@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <404bce5c-19ef-e103-7b68-5c81697d2a1f@redhat.com>
Date:   Mon, 8 Feb 2021 17:47:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210208134923.smtvzeonvwxzdlwn@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/02/21 14:49, Yu Zhang wrote:
> On Mon, Feb 08, 2021 at 12:36:57PM +0100, Paolo Bonzini wrote:
>> On 07/02/21 13:22, Yu Zhang wrote:
>>> In shadow page table, only leaf SPs may be marked as unsync.
>>> And for non-leaf SPs, we use unsync_children to keep the number
>>> of the unsynced children. In kvm_mmu_sync_root(), sp->unsync
>>> shall always be zero for the root SP, , hence no need to check
>>> it. Instead, a warning inside mmu_sync_children() is added, in
>>> case someone incorrectly used it.
>>>
>>> Also, clarify the mmu_need_write_protect(), by moving the warning
>>> into kvm_unsync_page().
>>>
>>> Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>
>> This should really be more of a Co-developed-by, and there are a couple
>> adjustments that could be made in the commit message.  I've queued the patch
>> and I'll fix it up later.
> 
> Indeed. Thanks for the remind, and I'll pay attention in the future. :)

Also:

arch/x86/kvm/mmu/mmu.c: In function ‘mmu_sync_children’:
arch/x86/kvm/mmu/mmu.c:2002:17: error: ‘sp’ is used uninitialized in 
this function [-Werror=uninitialized]
   WARN_ON_ONCE(sp->unsync);

so how was this tested?

Paolo


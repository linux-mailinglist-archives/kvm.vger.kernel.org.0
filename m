Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7487B456D4F
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 11:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234556AbhKSKcj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 05:32:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55286 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234378AbhKSKcj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Nov 2021 05:32:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637317777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7VVfU7MoxGcDgca+a4FR3TmIq0TVABKMELw1cCVOhzA=;
        b=LeKkPpvKeAOLW2R4Mz5UYUjlJe6xfxQa9bTTl2And8E6CZ5NTm7gxwivueBviebZVXfNkl
        Tlqrx7p/CzrGzbHR6Z25KLqO10UsCNVkMYVzY2hlU5yV7+uL7YYTNXh7SZt8VsWas8xkzm
        7FurZU61TdHDd4aYURwZfYJQtLFfG1U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-409-NCWidOJTNCu-XXZJ16An0w-1; Fri, 19 Nov 2021 05:29:36 -0500
X-MC-Unique: NCWidOJTNCu-XXZJ16An0w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2C7F100CCC0;
        Fri, 19 Nov 2021 10:29:34 +0000 (UTC)
Received: from [10.39.194.192] (unknown [10.39.194.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4105519811;
        Fri, 19 Nov 2021 10:29:30 +0000 (UTC)
Message-ID: <50caf3b7-3f06-10ec-ab65-e3637243eb09@redhat.com>
Date:   Fri, 19 Nov 2021 11:29:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 3/4] KVM: x86/pmu: Reuse find_perf_hw_id() and drop
 find_fixed_event()
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>
References: <20211116122030.4698-1-likexu@tencent.com>
 <20211116122030.4698-4-likexu@tencent.com>
 <85286356-8005-8a4d-927c-c3d70c723161@redhat.com>
 <e3b3ad6f-b48a-24fa-a242-e28d2422a7f3@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <e3b3ad6f-b48a-24fa-a242-e28d2422a7f3@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/19/21 08:16, Like Xu wrote:
> 
> It's proposed to get [V2] merged and continue to review the fixes from 
> [1] seamlessly,
> and then further unify all fixed/gp stuff including 
> intel_find_fixed_event() as a follow up.

I agree and I'll review it soon.  Though, why not add the

+            && (pmc_is_fixed(pmc) ||
+            pmu->available_event_types & (1 << i)))

version in v2 of this patch? :)

Paolo

> [1] https://lore.kernel.org/kvm/20211112095139.21775-1-likexu@tencent.com/
> [V2] https://lore.kernel.org/kvm/20211119064856.77948-1-likexu@tencent.com/


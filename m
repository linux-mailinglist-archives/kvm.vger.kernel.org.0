Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E596D455CAB
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 14:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbhKRNcN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 08:32:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:33153 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229766AbhKRNcM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 08:32:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637242152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=njoqnXi1Y+ahJG13c1yltMsCX6FPLO+2uCw7fBWbFyw=;
        b=gxNlow6A6nz3YepxeVAOm+b/fiCwKFHyKkldl5adFCUcrHfcWPE0b5/FyJ/6FNkCl2Zx13
        /eH04pGCinJqlg6ePGLNLhz58+ZOcpBL3aTOuKROhXpY1vMrZE6BlxIhqK4DSZjyW3Io2R
        ybSQjufiwqs3YENzEMu1pGebaXuIw7g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-5-azRiy2maO_mLwDQRTiKjdA-1; Thu, 18 Nov 2021 08:29:06 -0500
X-MC-Unique: azRiy2maO_mLwDQRTiKjdA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A02AD81C85E;
        Thu, 18 Nov 2021 13:29:04 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B7E4210495BA;
        Thu, 18 Nov 2021 13:29:02 +0000 (UTC)
Message-ID: <dfa8acd3-4ca2-927d-cd35-59ce28ade26a@redhat.com>
Date:   Thu, 18 Nov 2021 14:29:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 2/4] KVM: x86/pmu: Refactoring find_arch_event() to
 find_perf_hw_id()
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211116122030.4698-1-likexu@tencent.com>
 <20211116122030.4698-3-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211116122030.4698-3-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 13:20, Like Xu wrote:
> From: Like Xu<likexu@tencent.com>
> 
> The find_arch_event() returns a "unsigned int" value,
> which is used by the pmc_reprogram_counter() to
> program a PERF_TYPE_HARDWARE type perf_event.
> 
> The returned value is actually the kernel defined gernic
> perf_hw_id, let's rename it to find_perf_hw_id() with simpler
> incoming parameters for better self-explanation.

Since the argument is a pmc, let's rename it to pmc_perf_hw_id().

Paolo


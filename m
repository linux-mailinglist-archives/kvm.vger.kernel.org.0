Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B547455CA3
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 14:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbhKRN1G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 08:27:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:37547 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230513AbhKRN1G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 08:27:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637241845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QrxxznNzmdFG9Iw5SijS8z54/22KfVbH3Sfpi1p0Le4=;
        b=ZZj6RLx8asVdXyj1Fh1sxu6u0ZpOVbw7VNS8olG2Sa1UfeSRzYCzW2TLJq6n1UzZPf+DcQ
        RmeXSumycroBKpA+7ALSsF1lLZ84uIcGbhKTQ0LB7PGFV7evxVHJvw/BlgpO3Q169tG+UP
        Oe9Fr579v1rIW2D8d+r9tPeM4Ln3JqM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137--P_wrwQTOF6kcGev5iqINg-1; Thu, 18 Nov 2021 08:24:02 -0500
X-MC-Unique: -P_wrwQTOF6kcGev5iqINg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8E20802E62;
        Thu, 18 Nov 2021 13:24:00 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6C715C1D0;
        Thu, 18 Nov 2021 13:23:57 +0000 (UTC)
Message-ID: <d029d5e6-5b32-972d-943e-64264e599c3d@redhat.com>
Date:   Thu, 18 Nov 2021 14:23:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] KVM: x86/pmu: Fix reserved bits for AMD PerfEvtSeln
 register
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211118130320.95997-1-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211118130320.95997-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/18/21 14:03, Like Xu wrote:
> 
> This is because according to APM (Revision: 4.03) Figure 13-7,
> the bits [35:32] of AMD PerfEvtSeln register is a part of the
> event select encoding, which extends the EVENT_SELECT field
> from 8 bits to 12 bits.

Queued, thanks.

Paolo


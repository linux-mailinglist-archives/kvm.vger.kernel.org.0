Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0238345EEE8
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 14:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242080AbhKZNPm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 08:15:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:42925 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240222AbhKZNNl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Nov 2021 08:13:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637932227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PZES8D7Poy0DqzKfMkUuWcd49HA4pFsS42pgSE0hH14=;
        b=faYAWRCLtB+dL5HvQfmC6nRD4TNp5/0/vZN7T1fliNJq9CV3NqMmzOygZFxQpnnsoDPKta
        HVyoOy9xV6AeXvsaTl69JAkuUKyyf9zcxB8c/YqhKCBHKJmTeUaLJ19yJPnmA1XiKeHi/+
        C0WvEKioj6MIcpdR6PZL9taTQMBB+C4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-403-Iokdj43yO1yVe4M3MosZig-1; Fri, 26 Nov 2021 08:10:24 -0500
X-MC-Unique: Iokdj43yO1yVe4M3MosZig-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75DC71006AA4;
        Fri, 26 Nov 2021 13:10:21 +0000 (UTC)
Received: from [10.39.195.16] (unknown [10.39.195.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6965E5C1CF;
        Fri, 26 Nov 2021 13:10:18 +0000 (UTC)
Message-ID: <07f67369-a921-09d4-019d-d4141f970c1c@redhat.com>
Date:   Fri, 26 Nov 2021 14:10:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] KVM: x86/mmu: Handle "default" period when selectively
 waking kthread
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Junaid Shahid <junaids@google.com>
References: <20211120015706.3830341-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211120015706.3830341-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/20/21 02:57, Sean Christopherson wrote:
> +/*
> + * Calculate the effective recovery period, accounting for '0' meaning "let KVM
> + * select a period of ~1 hour per page".  Returns true if recovery is enabled.
> + */

Slightly better: "let KVM select a halving time of ~1 hour".  Queued 
with this change, thanks.

Paolo


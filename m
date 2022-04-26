Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC23850F145
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 08:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245523AbiDZGpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 02:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245492AbiDZGpJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 02:45:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8D9081B784
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 23:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650955321;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7abwP0OsWtbN83lK5y79QzB8uIny3w43c2wo+0VTZhQ=;
        b=KTBB4f4JF+q/JVB+V8oJf4r0UFT4BHLj7RV+29ZvkBmiWndWhWniUNKTyKXj7Rf3EGg98K
        9KgdyAo/8HZZtSotT9u3BASXN89ENHAx6ebH03ik2GeyFwGeA33XOEJ5naEaMOAIgChs61
        gXlW4G+2bvF82BbqdTLLZHWCGaVpznU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-328-Rnrn1RSFNQSPcBQeg6zhLQ-1; Tue, 26 Apr 2022 02:41:57 -0400
X-MC-Unique: Rnrn1RSFNQSPcBQeg6zhLQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B8AD18A658A;
        Tue, 26 Apr 2022 06:41:35 +0000 (UTC)
Received: from [10.72.13.230] (ovpn-13-230.pek2.redhat.com [10.72.13.230])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 63FAC40470C2;
        Tue, 26 Apr 2022 06:41:26 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v6 5/9] Docs: KVM: Rename psci.rst to hypercalls.rst
To:     Raghavendra Rao Ananta <rananta@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
References: <20220423000328.2103733-1-rananta@google.com>
 <20220423000328.2103733-6-rananta@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <8e67bc1b-05c9-f2d3-1580-2c1f3118a769@redhat.com>
Date:   Tue, 26 Apr 2022 14:41:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20220423000328.2103733-6-rananta@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/23/22 8:03 AM, Raghavendra Rao Ananta wrote:
> Since the doc also covers general hypercalls' details,
> rather than just PSCI, and the fact that the bitmap firmware
> registers' details will be added to this doc, rename the file
> to a more appropriate name- hypercalls.rst.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Oliver Upton <oupton@google.com>
> ---
>   Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} | 0
>   1 file changed, 0 insertions(+), 0 deletions(-)
>   rename Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} (100%)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/Documentation/virt/kvm/arm/psci.rst b/Documentation/virt/kvm/arm/hypercalls.rst
> similarity index 100%
> rename from Documentation/virt/kvm/arm/psci.rst
> rename to Documentation/virt/kvm/arm/hypercalls.rst
> 


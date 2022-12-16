Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C54AF64EB53
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 13:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiLPMUw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 07:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiLPMUt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 07:20:49 -0500
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2AFD11463
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 04:20:47 -0800 (PST)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1p69hi-003pU0-Ue; Fri, 16 Dec 2022 13:20:42 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:
        Cc:To:Subject:From:MIME-Version:Date:Message-ID;
        bh=0uZn7d4gZ4EqdEVCvygCdA65vjTjUVBGQY6EnF5fSDk=; b=MZCJoqxlZUWNNtfjbK400zdyRN
        9IUV7/Kft0uE7e+SQ5WaapAQMd18kHWkJq7zJgIg2V8c5yPltivNCJu8tsH+YM0UX8GERCDHrpE9J
        6SVJhlC3LVQk5paoXtOYPIA38yDql4lQq6ks2hDjoEU+1W073osvQD9Hq6rVZE8AQmKs6Z6YRQY0P
        zA3AS8KRd6RwR5UGcnnD7VI/FL9kAtTR8c0w6N4b+75t5Rmd5Ok6O9cUVVgido7yN+RAhvVJ+lIs3
        xAXybMq1+eFd6HkeVVJl1v4W7tCRn5/eApDxbLZp/N0CG1cP4QVZLaSK5wSRWowTtBbrXl51l4+bf
        wj2Z4cBQ==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1p69hh-0007vI-2x; Fri, 16 Dec 2022 13:20:41 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1p69hX-0008SY-Uw; Fri, 16 Dec 2022 13:20:32 +0100
Message-ID: <f2fbe2ec-cf8e-7cb3-748d-b7ad753cc455@rbox.co>
Date:   Fri, 16 Dec 2022 13:20:30 +0100
MIME-Version: 1.0
User-Agent: Thunderbird
From:   Michal Luczaj <mhal@rbox.co>
Subject: Re: [PATCH v4 1/2] KVM: MMU: Introduce 'INVALID_GFN' and use it for
 GFN values
To:     Yu Zhang <yu.c.zhang@linux.intel.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, oliver.upton@linux.dev,
        catalin.marinas@arm.com, will@kernel.org, dwmw2@infradead.org,
        paul@xen.org
References: <20221216085928.1671901-1-yu.c.zhang@linux.intel.com>
 <20221216085928.1671901-2-yu.c.zhang@linux.intel.com>
Content-Language: pl-PL
In-Reply-To: <20221216085928.1671901-2-yu.c.zhang@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/16/22 09:59, Yu Zhang wrote:
> +++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
> @@ -20,7 +20,7 @@
>  #include <sys/eventfd.h>
>  
>  /* Defined in include/linux/kvm_types.h */
> -#define GPA_INVALID		(~(ulong)0)
> +#define INVALID_GFN		(~(ulong)0)


Thank you for fixing the selftest!

Regarding xen_shinfo_test.c, a question to maintainers, would it be ok if I
submit a simple patch fixing the misnamed cache_init/cache_destroy =>
cache_activate/cache_deactivate or it's just not worth the churn now?

Michal


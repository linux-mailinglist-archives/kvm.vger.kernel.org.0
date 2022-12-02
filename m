Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5170064061B
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 12:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbiLBLvy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 06:51:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233127AbiLBLvk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 06:51:40 -0500
X-Greylist: delayed 3247 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 02 Dec 2022 03:51:37 PST
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F570D755C;
        Fri,  2 Dec 2022 03:51:37 -0800 (PST)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1p13jS-002eeL-Iu; Fri, 02 Dec 2022 11:57:26 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=OGkreSo0YX+cdGW4kA6nzm27MlH5HOxobnNvIbNdlmA=; b=iyFtcan4oi8kRjbxXsIhXEBQPD
        xCB6hZq8XTiX1DvR9FkAI2K9mefDJkbRtyM1GVfYce/4Q/jnQ2rfv6gCUD4pM9LdGdOWDwFeHenBg
        8KsdMHFBS41vohhxKx9V1PR+tH3dqTETennoaf0IAzB/Qjq21Hf+XrnmRSzAUMN4pedxqmJakCKfU
        qyty9Tp/ULjyrFcg7rAkxolnrweDb5bH9tZRIQm44J2zvVjoP0hHaZZua28ySpCSi3fneFYuWNJTO
        QE5OSjaOSG0O+BigIWKKvyAT5mH7uHEEhz+dT7WBUUpv8SOO3IkKmabk99TMJ4QNaWSuVCaKw1Z2R
        vVnuB6lw==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1p13jK-0004G0-KR; Fri, 02 Dec 2022 11:57:18 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1p13j7-0005kg-0v; Fri, 02 Dec 2022 11:57:05 +0100
Message-ID: <6a984015-cacc-b8e9-d834-9d6827be5832@rbox.co>
Date:   Fri, 2 Dec 2022 11:57:03 +0100
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [PATCH v2 05/16] KVM: x86: Remove unused argument in
 gpc_unmap_khva()
Content-Language: pl-PL, en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20221013211234.1318131-1-seanjc@google.com>
 <20221013211234.1318131-6-seanjc@google.com>
 <544d854f-e980-c7bf-39e9-425202760cc5@gmail.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <544d854f-e980-c7bf-39e9-425202760cc5@gmail.com>
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

On 12/2/22 10:28, Like Xu wrote:
> On 14/10/2022 5:12 am, Sean Christopherson wrote:
>> Remove the unused @kvm argument from gpc_unmap_khva().
> 
> Nit: the caller kvm_gpc_unmap() can also get rid of the unused @kvm argument.

Right, the initial series cleaned up kvm_gpc_unmap() in a separate patch.
Current iteration removes kvm_gpc_unmap() later in the series:
https://lore.kernel.org/kvm/20221013211234.1318131-12-seanjc@google.com/

Michal


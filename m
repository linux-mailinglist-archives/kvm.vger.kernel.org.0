Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64DBE4532A2
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 14:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236578AbhKPNNw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 08:13:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41484 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232753AbhKPNNs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 08:13:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637068251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0JTeqDrAw5OSlo519nYzgdogJNVBSL/XQjztENai/vE=;
        b=MxvaevUL3p6SjtbZZunLWF1sWZGKyF3i2npGgH7BHwZFlvG7HJEmtU71cGl3G021+zaG/9
        DWudAd4APtGSTYvsCPfV3mNMTicp1I98eafAM0DivzRc/lqVhsrIF4p/ju6snzF/LTmu3k
        57vTrkvU3LcwIQBXBvLerM7/Tr8d/Vw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-FLoWqczMO0y4Kw475UVk_Q-1; Tue, 16 Nov 2021 08:10:45 -0500
X-MC-Unique: FLoWqczMO0y4Kw475UVk_Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C82A8804140;
        Tue, 16 Nov 2021 13:10:43 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6640310016F5;
        Tue, 16 Nov 2021 13:10:41 +0000 (UTC)
Message-ID: <4e6df304-a5a5-fd33-1b6a-59eec905101f@redhat.com>
Date:   Tue, 16 Nov 2021 14:10:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] riscv: kvm: fix non-kernel-doc comment block
Content-Language: en-US
To:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>,
        Atish Patra <atish.patra@wdc.com>,
        Anup Patel <anup.patel@wdc.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>
References: <20211107034706.30672-1-rdunlap@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211107034706.30672-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/7/21 04:47, Randy Dunlap wrote:
> Don't use "/**" to begin a comment block for a non-kernel-doc comment.
> 
> Prevents this docs build warning:
> 
> vcpu_sbi.c:3: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>   * Copyright (c) 2019 Western Digital Corporation or its affiliates.
> 
> Fixes: dea8ee31a039 ("RISC-V: KVM: Add SBI v0.1 support")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Atish Patra <atish.patra@wdc.com>
> Cc: Anup Patel <anup.patel@wdc.com>
> Cc: kvm@vger.kernel.org
> Cc: kvm-riscv@lists.infradead.org
> Cc: linux-riscv@lists.infradead.org
> Cc: Paul Walmsley <paul.walmsley@sifive.com>
> Cc: Palmer Dabbelt <palmer@dabbelt.com>
> Cc: Albert Ou <aou@eecs.berkeley.edu>
> ---
>   arch/riscv/kvm/vcpu_sbi.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20211106.orig/arch/riscv/kvm/vcpu_sbi.c
> +++ linux-next-20211106/arch/riscv/kvm/vcpu_sbi.c
> @@ -1,5 +1,5 @@
>   // SPDX-License-Identifier: GPL-2.0
> -/**
> +/*
>    * Copyright (c) 2019 Western Digital Corporation or its affiliates.
>    *
>    * Authors:
> 

Queued, thanks.

Paolo


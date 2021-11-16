Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E2645327A
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 13:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236477AbhKPM5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 07:57:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23589 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236466AbhKPM50 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 07:57:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637067269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/0y6UIC7JS4DrSgUctiWMoMp6BrqTnX+XpY7WDypp8c=;
        b=VnPsAKz4zSWbTSwMrNlYLI2h6a3PFkblVPjO3mB/KK6Leer3R5bSaQygcqq95JBNtsrEAD
        5vrVtWopiPaUVwbqpBodIPH30cvzS5Za5xLqQs6hO+QDlomz4/RMLNeYFA+Jfab2x+E8eO
        C/8cWxN5lsw50YM7SXShMUklY0kt5lY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-VMadE4eGMQeAOlfdA3X1IA-1; Tue, 16 Nov 2021 07:54:24 -0500
X-MC-Unique: VMadE4eGMQeAOlfdA3X1IA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1046A57241;
        Tue, 16 Nov 2021 12:54:22 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB9E05C1D5;
        Tue, 16 Nov 2021 12:54:18 +0000 (UTC)
Message-ID: <34e691ec-a58d-c86b-a2ef-6fa4f0385b69@redhat.com>
Date:   Tue, 16 Nov 2021 13:54:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 3/4] Documentation: update vcpu-requests.rst reference
Content-Language: en-US
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Albert Ou <aou@eecs.berkeley.edu>, Anup Patel <anup.patel@wdc.com>,
        Atish Patra <atish.patra@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
References: <cover.1637064577.git.mchehab+huawei@kernel.org>
 <32b3693314f3914f10a42dea97ad6e06292fcd4a.1637064577.git.mchehab+huawei@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <32b3693314f3914f10a42dea97ad6e06292fcd4a.1637064577.git.mchehab+huawei@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 13:11, Mauro Carvalho Chehab wrote:
> Changeset 2f5947dfcaec ("Documentation: move Documentation/virtual to Documentation/virt")
> renamed: Documentation/virtual/kvm/vcpu-requests.rst
> to: Documentation/virt/kvm/vcpu-requests.rst.
> 
> Update its cross-reference accordingly.
> 
> Fixes: 2f5947dfcaec ("Documentation: move Documentation/virtual to Documentation/virt")
> Reviewed-by: Anup Patel <anup.patel@wdc.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
> 
> To mailbombing on a large number of people, only mailing lists were C/C on the cover.
> See [PATCH 0/4] at: https://lore.kernel.org/all/cover.1637064577.git.mchehab+huawei@kernel.org/
> 
>   arch/riscv/kvm/vcpu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index e3d3aed46184..fb84619df012 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -740,7 +740,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>   		 * Ensure we set mode to IN_GUEST_MODE after we disable
>   		 * interrupts and before the final VCPU requests check.
>   		 * See the comment in kvm_vcpu_exiting_guest_mode() and
> -		 * Documentation/virtual/kvm/vcpu-requests.rst
> +		 * Documentation/virt/kvm/vcpu-requests.rst
>   		 */
>   		vcpu->mode = IN_GUEST_MODE;
>   
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Thanks,

Paolo


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45B8522AD0C
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 12:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbgGWK4H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 06:56:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38077 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726867AbgGWK4H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 06:56:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595501766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b6X8qFJx/IqTp02I2ZdrYezF4P3ZtRQwnPIjjdbJG+Y=;
        b=jQbbNOQ+PqVQJCd0nhRcRFs7I8kv0FVPOQeYMH7xl2bzfVfvUILme5ffkpFSOBERFPodAE
        0grmE/0F3lwAS894EIBS2rf2XEBS+a6kVrbbPZjQymaNzQPQ/Yc+aDpK1nMGC31hP3+1eg
        B8J22mR6bK2ob8nV2+0MospDgvuT2wI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-VkCUSjLVP7y93x5vWloqMg-1; Thu, 23 Jul 2020 06:56:04 -0400
X-MC-Unique: VkCUSjLVP7y93x5vWloqMg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55A82800460;
        Thu, 23 Jul 2020 10:56:02 +0000 (UTC)
Received: from gondolin (ovpn-112-228.ams2.redhat.com [10.36.112.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C499B8FA23;
        Thu, 23 Jul 2020 10:55:54 +0000 (UTC)
Date:   Thu, 23 Jul 2020 12:55:52 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Cc:     mpe@ellerman.id.au, paulus@samba.org, david@gibson.dropbear.id.au,
        mikey@neuling.org, npiggin@gmail.com, pbonzini@redhat.com,
        christophe.leroy@c-s.fr, jniethe5@gmail.com, pedromfc@br.ibm.com,
        rogealve@br.ibm.com, mst@redhat.com, clg@kaod.org,
        qemu-ppc@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] ppc: Rename current DAWR macros
Message-ID: <20200723125552.7668d946.cohuck@redhat.com>
In-Reply-To: <20200723104220.314671-2-ravi.bangoria@linux.ibm.com>
References: <20200723104220.314671-1-ravi.bangoria@linux.ibm.com>
        <20200723104220.314671-2-ravi.bangoria@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Jul 2020 16:12:19 +0530
Ravi Bangoria <ravi.bangoria@linux.ibm.com> wrote:

> Power10 is introducing second DAWR. Use real register names (with
> suffix 0) from ISA for current macros.
> 
> Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
> ---
>  include/hw/ppc/spapr.h          | 2 +-
>  linux-headers/asm-powerpc/kvm.h | 4 ++--
>  target/ppc/cpu.h                | 4 ++--
>  target/ppc/translate_init.inc.c | 8 ++++----
>  4 files changed, 9 insertions(+), 9 deletions(-)
> 

(...)

> diff --git a/linux-headers/asm-powerpc/kvm.h b/linux-headers/asm-powerpc/kvm.h
> index 264e266a85..38d61b73f5 100644
> --- a/linux-headers/asm-powerpc/kvm.h
> +++ b/linux-headers/asm-powerpc/kvm.h
> @@ -608,8 +608,8 @@ struct kvm_ppc_cpu_char {
>  #define KVM_REG_PPC_BESCR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xa7)
>  #define KVM_REG_PPC_TAR		(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xa8)
>  #define KVM_REG_PPC_DPDES	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xa9)
> -#define KVM_REG_PPC_DAWR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xaa)
> -#define KVM_REG_PPC_DAWRX	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xab)
> +#define KVM_REG_PPC_DAWR0	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xaa)
> +#define KVM_REG_PPC_DAWRX0	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xab)
>  #define KVM_REG_PPC_CIABR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xac)
>  #define KVM_REG_PPC_IC		(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xad)
>  #define KVM_REG_PPC_VTB		(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xae)

Changes here need to come in via a proper headers sync, so this needs
to be split out into a separate patch (either one doing a headers sync,
or a placeholder if the Linux changes are not upstream yet.)


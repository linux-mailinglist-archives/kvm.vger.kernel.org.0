Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28AA62833D5
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 12:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgJEKKm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 06:10:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57857 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725843AbgJEKKm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Oct 2020 06:10:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601892641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dm0igQAQvI7XslKb8JHZiAODfgUY1aNHN2/XyeedTYs=;
        b=ZK0aajXK08oODzI6sbxzZiLyVHruzFugm3a4IE1UURlWeacOr/tBYk8lbY9WIe6so7L+Bg
        oQLSJrT07Q1nBNRBw27FL5j6fuyqJpG4TKMb6vO6JX1VFHB1lUAImTRKx/TIzg+bRd421+
        bLpZSM3ry6G3xs2V/n4hn8wof6CZRCA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-YquK7uNwP4-fBQl7nLeGUA-1; Mon, 05 Oct 2020 06:10:39 -0400
X-MC-Unique: YquK7uNwP4-fBQl7nLeGUA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5EFAC800E23;
        Mon,  5 Oct 2020 10:10:38 +0000 (UTC)
Received: from starship (unknown [10.35.206.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 745A31045EB3;
        Mon,  5 Oct 2020 10:10:34 +0000 (UTC)
Message-ID: <e08f5bd788888c7957893eb43c0d78118213f0d4.camel@redhat.com>
Subject: Re: [PATCH 3/3] KVM: x86: bump KVM_MAX_CPUID_ENTRIES
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Wei Huang <whuang2@amd.com>, linux-kernel@vger.kernel.org
Date:   Mon, 05 Oct 2020 13:10:33 +0300
In-Reply-To: <20201001130541.1398392-4-vkuznets@redhat.com>
References: <20201001130541.1398392-1-vkuznets@redhat.com>
         <20201001130541.1398392-4-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-10-01 at 15:05 +0200, Vitaly Kuznetsov wrote:
> As vcpu->arch.cpuid_entries is now allocated dynamically, the only
> remaining use for KVM_MAX_CPUID_ENTRIES is to check KVM_SET_CPUID/
> KVM_SET_CPUID2 input for sanity. Since it was reported that the
> current limit (80) is insufficient for some CPUs, bump
> KVM_MAX_CPUID_ENTRIES and use an arbitrary value '256' as the new
> limit.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 7d259e21ea04..f6d6df64e63a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -133,7 +133,7 @@ static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
>  #define KVM_NUM_MMU_PAGES (1 << KVM_MMU_HASH_SHIFT)
>  #define KVM_MIN_FREE_MMU_PAGES 5
>  #define KVM_REFILL_PAGES 25
> -#define KVM_MAX_CPUID_ENTRIES 80
> +#define KVM_MAX_CPUID_ENTRIES 256
>  #define KVM_NR_FIXED_MTRR_REGION 88
>  #define KVM_NR_VAR_MTRR 8
>  

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE74F18170A
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 12:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729067AbgCKLtU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 07:49:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36929 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725834AbgCKLtU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 07:49:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583927359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F5OgNaYAikVgpZYOSNk5y2jqMOtP53edDDqZVD/pDRE=;
        b=RYu1tv+QbJaZlAuU5XuoKwZiYxM/hJbhRqklnpmWshRELnoL5dHaF041C+xE7mXqqrx+Lc
        8wnWdA/54zISNbi+yfl6huFpSwX9wPJ19K9ACS66VWr0yxcmGkKAJq4125SeAYNDnJpQQK
        85qAMaV7QvGRvjzvCyZBT6C15ApwCBY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-EzhzE16mOACWoHK2hrEDwg-1; Wed, 11 Mar 2020 07:49:17 -0400
X-MC-Unique: EzhzE16mOACWoHK2hrEDwg-1
Received: by mail-wm1-f72.google.com with SMTP id t2so564812wmj.2
        for <kvm@vger.kernel.org>; Wed, 11 Mar 2020 04:49:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=F5OgNaYAikVgpZYOSNk5y2jqMOtP53edDDqZVD/pDRE=;
        b=VSnUgnu9b+ceVJfaGUgHiWTTOv61umi0fTXCA+t+MAqoUigd194eaHFR2fnMne0f7D
         tPPaX3qgmS2kL77iHjocyml2Oe1JGZ8rkn0u4qUUykvq6mEwDLV+QG3xOzUgvbwJr0ex
         r6ldQcTT88WomNlrzRSd7ML2/85T+l5QEAQlIvTIy5dNoQjqWQy9uYL18pRdqGNpIQV1
         AORZg5KHIAH0bNewGDtVqwRmMmRjPu6AOmtd6o36sidCOYTk0hKmoqHWVJd1clTAL1dT
         tEYu8ZNZkGRKeiFwsHqCdIP0O+7f58OPRoUp3Sm+Jkv5NMpOaC1CMRAPigqHG2PEzNqK
         q5/A==
X-Gm-Message-State: ANhLgQ0tRGiloWuZd68a1y1sqe9tLigYuWSgCdNHQXCCfjEujORINQdJ
        I7gT73R4TowcoKJlUeMpCfC/WHE9LlTbPAEMVu42El4vd2UkS1Y94e8YCFibOmS5JEuR0/2hSft
        PsX3xImk85LyO
X-Received: by 2002:a5d:6a4d:: with SMTP id t13mr4127281wrw.344.1583927356341;
        Wed, 11 Mar 2020 04:49:16 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsLTPh5QjDF4BVIWhl7Hz6t3aq6gMtSaIcj8l84Z5nkZqsVtENlcA0VXwUD8mRF8pmkrPvYTA==
X-Received: by 2002:a5d:6a4d:: with SMTP id t13mr4127247wrw.344.1583927356118;
        Wed, 11 Mar 2020 04:49:16 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id c4sm8261810wml.7.2020.03.11.04.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 04:49:14 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liran Alon <liran.alon@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>
Subject: Re: [RFC PATCH] KVM: nVMX: nested_vmx_handle_enlightened_vmptrld() can be static
In-Reply-To: <20200310200830.GA84412@69fab159caf3>
References: <20200309155216.204752-4-vkuznets@redhat.com> <20200310200830.GA84412@69fab159caf3>
Date:   Wed, 11 Mar 2020 12:49:13 +0100
Message-ID: <87d09jaz7q.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kbuild test robot <lkp@intel.com> writes:

> Fixes: e3fd8bda412e ("KVM: nVMX: properly handle errors in nested_vmx_handle_enlightened_vmptrld()")
> Signed-off-by: kbuild test robot <lkp@intel.com>
> ---
>  nested.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 65df8bcbb9c86..1d9ab1e9933fb 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1910,7 +1910,7 @@ static int copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
>   * This is an equivalent of the nested hypervisor executing the vmptrld
>   * instruction.
>   */
> -enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
> +static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
>  	struct kvm_vcpu *vcpu, bool from_launch)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>

Yea,

I accidentially dropped 'static' in PATCH3, will restore it in v2.

Thanks!

-- 
Vitaly


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53119449B6B
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 19:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234899AbhKHSJ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 13:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234893AbhKHSJz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 13:09:55 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF6AAC061714
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 10:07:10 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id n85so12299163pfd.10
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 10:07:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7eQ8ia+dB2T87S9K7CaWuiJBvCWc/a1PJeN9BRnks1o=;
        b=Gj9i4t4iknOQDeZ7YeT2+v0YHX74Zso9nysBAufKMqGIV7zyEIHSvbUUDZKOQffn4k
         zLLOaNilf04ex9tsUxHrf/6q5gWV7GWII8Squu/FEs+tcKXsmVnS0kAwpZsnYbgqnf5P
         AcsMmGaUg2xzwL4qg0u/Ew8NtJ8krFcKZ16sMkr1tTUfKJSgwaZl2HoxzSf4ArOGQPJI
         GBV52ZtiOWcrSDI7JZ4u+QCmG2mxWaJLd584Jn4Y41tOKnI88GPpqsIilhVQ6Pworgn4
         /fXBDpMB3h1FY3ZGpJjp/Apm2O0dq5yNdOD5WG2UT4X//wgSROSa367BVXlCM0xYRm7J
         qgKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7eQ8ia+dB2T87S9K7CaWuiJBvCWc/a1PJeN9BRnks1o=;
        b=t8rpoAgMQKNNT+KYWKmaJak9gNL1H9hvKicVLcYszntd4HbTRr2vJvHHBNqETzX0cm
         IveH6Oq0Nz5gSNy3/MJ18wkJDVYh/oeseNnQLq3OMLDoRXu0At7KWKqSjExPi4nvpAp5
         NpXp2pwj1RWzL+8OHfEQbp2stp/PgcWYks//hTXW7Ectl7QkDBHZ0tm3jCJJyvpsjRfT
         +rT7P6oGmV9MFpqSlkZ0z5FNQhiMTqopEQRRWwVe78xRtbMOnfKFhBIdZV7f3ZKnmcPR
         aA0dVWxQMIttRgaIzcgP59DxtZmEu/L8EDSCA10MVn2uYZftT7cfFuKJaJJYPyJHCeAL
         47rQ==
X-Gm-Message-State: AOAM532X7Kllv998zjeGzjkE7vByCI273lMnF5fbv2yspYDZux/U174V
        q0pi/Z8pQv8a6gTB1T0jQgLtcT7EIMCkRg==
X-Google-Smtp-Source: ABdhPJxB1IdhseSV2aMwiBhebF4HV8tfAj7mXNlBpBQ+qWtDW/wYH1isLDJp19sxu4fmJWlVmAiumw==
X-Received: by 2002:a05:6a00:2146:b0:44c:2922:8abf with SMTP id o6-20020a056a00214600b0044c29228abfmr1079633pfk.27.1636394830113;
        Mon, 08 Nov 2021 10:07:10 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mv22sm43754pjb.36.2021.11.08.10.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 10:07:09 -0800 (PST)
Date:   Mon, 8 Nov 2021 18:07:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/7] KVM: VMX: Add proper cache tracking for PKRS
Message-ID: <YYlnSdw+3dY/lJ25@google.com>
References: <20210811101126.8973-1-chenyi.qiang@intel.com>
 <20210811101126.8973-3-chenyi.qiang@intel.com>
 <YYlaw6v6GOgFUQ/Z@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYlaw6v6GOgFUQ/Z@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 08, 2021, Sean Christopherson wrote:
> On Wed, Aug 11, 2021, Chenyi Qiang wrote:
> > +			vcpu->arch.pkrs = vmcs_read64(GUEST_IA32_PKRS);
> 
> Hrm.  I agree that it's extremely unlikely that IA32_PKRS will ever allow software
> to set bits 63:32, but at the same time there's no real advantage to KVM it as a u32,
> e.g. the extra 4 bytes per vCPU is a non-issue, and could be avoided by shuffling
> kvm_vcpu_arch to get a more efficient layout.  On the flip side, using a 32 means
> code like this _looks_ buggy because it's silently dropping bits 63:32, and if the
> architecture ever does get updated, we'll have to modify a bunch of KVM code.
> 
> TL;DR: I vote to track PRKS as a u64 even though the kernel tracks it as a u32.

Rats, I forgot that the MMU code for PKRU is going to be reused for PKRS.  I withdraw
my vote :-)

Maybe have this code WARN on bits 63:32 being set in the VMCS field?  E.g. to
detect if hardware ever changes and KVM fails to update this path, and to document
that KVM intentionally drops those bits.

	case VCPU_EXREG_PKRS: {
		u64 ia32_pkrs;

		ia32_pkrs = vmcs_read64(GUEST_IA32_PKRS);
		WARN_ON_ONCE(ia32_pkrs >> 32);
		vcpu->arch.pkrs = (u32)ia32_pkrs;
	}

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E2D30E35D
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 20:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhBCThb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 14:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbhBCTh1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 14:37:27 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4E5C0613D6
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 11:36:47 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id o63so448558pgo.6
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 11:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=NrShce5CeQihuw+RJ6QvGhKCf7BiqjoCzi6UhE41Zc4=;
        b=RuPqQBpZ3pH7EHT479YU/kt0CgaeWzVCGT9rOR6W6Q2XAivJYbegzasAdL4ugacLj/
         sgX5UfNaP1hiv2kQxsCm0IGZmnckDRnCT7RXy3Bh+6mx9rN4vB3VqymOWf9kglk48fVO
         8qUuhPylLotr6k0cCP4jIaAkQfY0+RMpjHWgxNv7gXrDnCXBt+LTVrHNHnHeeaJqgzb2
         i7ezNAwBj3Gx6E2hnM0POAbd/Cfuw0TjUrzhvTMSBxwoz2yrgHM9ABL6Mzk+rWreRKtI
         aOHulUrsdlhMpLqXXRK6dm9oVB+AcMphiXYf4AYrgwBXKPV1t634Z8kIg8agQnWl6SMk
         Z/TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=NrShce5CeQihuw+RJ6QvGhKCf7BiqjoCzi6UhE41Zc4=;
        b=Z7h7kO8DD5kmrOAz+7/RlmDUt1RE1UN4n2mvFOOIt4wSVUGmwMvr/Z79NNIFoT5U0Z
         wQf5/dKmbcq43as6SzJWRqs/2DzynzYFroU8ZMt9nBaq1jn/u3//8SCIE0swlgQKrA3c
         zmllCwCDjWbI0k9SpW14+rfu9o3K8nhZyHT9eLJ83w0TV0jcOt9WRpPTtbYYoUtpFNI2
         kBtMSrV6mMYcC50eHZwBYYorYwxGeOefCA4YRQumV75dLW9q4EFqrj+XdEBCXcc6xPSv
         E4IS+JmBlEIDe4cd+xW8wHvHwBMD01OCComp7p9hAYWHqNiJIa4DjIaI/Gzfej4WEqN0
         wqgw==
X-Gm-Message-State: AOAM533Mu9+/oKbZkRM1vIz3e2h65eHgVzJIXrntKTfdVe+F+YaqPOXI
        4DM9UUuA3NH6X4W1FP/kPNrUug==
X-Google-Smtp-Source: ABdhPJxgR/k6Mlkr9D72r/RYLnZkVk+FhgMhriy5vSKTvoCD7bwYdls+0fzWExFKdyUKOxXFox3zmA==
X-Received: by 2002:aa7:8215:0:b029:1d2:8d22:a4af with SMTP id k21-20020aa782150000b02901d28d22a4afmr2768366pfi.67.1612381006757;
        Wed, 03 Feb 2021 11:36:46 -0800 (PST)
Received: from google.com ([2620:15c:f:10:a9a0:e924:d161:b6cb])
        by smtp.gmail.com with ESMTPSA id f13sm6590598pjj.1.2021.02.03.11.36.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 11:36:45 -0800 (PST)
Date:   Wed, 3 Feb 2021 11:36:39 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>
Subject: Re: [RFC PATCH v3 23/27] KVM: VMX: Add SGX ENCLS[ECREATE] handler to
 enforce CPUID restrictions
Message-ID: <YBr7R0ns79HB74XD@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
 <d68c01baed78f859ac5fce4519646fc8a356c77d.1611634586.git.kai.huang@intel.com>
 <c235e9ca6fae38ae3a6828218cb1a68f2a0c3912.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c235e9ca6fae38ae3a6828218cb1a68f2a0c3912.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 03, 2021, Edgecombe, Rick P wrote:
> On Tue, 2021-01-26 at 22:31 +1300, Kai Huang wrote:
> > +       /* Exit to userspace if copying from a host userspace address
> > fails. */
> > +       if (sgx_read_hva(vcpu, m_hva, &miscselect,
> > sizeof(miscselect)) ||
> > +           sgx_read_hva(vcpu, a_hva, &attributes,
> > sizeof(attributes)) ||
> > +           sgx_read_hva(vcpu, x_hva, &xfrm, sizeof(xfrm)) ||
> > +           sgx_read_hva(vcpu, s_hva, &size, sizeof(size)))
> > +               return 0;
> > +
> > +       /* Enforce restriction of access to the PROVISIONKEY. */
> > +       if (!vcpu->kvm->arch.sgx_provisioning_allowed &&
> > +           (attributes & SGX_ATTR_PROVISIONKEY)) {
> > +               if (sgx_12_1->eax & SGX_ATTR_PROVISIONKEY)
> > +                       pr_warn_once("KVM: SGX PROVISIONKEY
> > advertised but not allowed\n");
> > +               kvm_inject_gp(vcpu, 0);
> > +               return 1;
> > +       }
> > +
> > +       /* Enforce CPUID restrictions on MISCSELECT, ATTRIBUTES and
> > XFRM. */
> > +       if ((u32)miscselect & ~sgx_12_0->ebx ||
> > +           (u32)attributes & ~sgx_12_1->eax ||
> > +           (u32)(attributes >> 32) & ~sgx_12_1->ebx ||
> > +           (u32)xfrm & ~sgx_12_1->ecx ||
> > +           (u32)(xfrm >> 32) & ~sgx_12_1->edx) {
> > +               kvm_inject_gp(vcpu, 0);
> > +               return 1;
> > +       }
> 
> Don't you need to deep copy the pageinfo.contents struct as well?
> Otherwise the guest could change these after they were checked.
> 
> But it seems it is checked by the HW and something is caught that would
> inject a GP anyway? Can you elaborate on the importance of these
> checks?

Argh, yes.  These checks are to allow migration between systems with different
SGX capabilities, and more importantly to prevent userspace from doing an end
around on the restricted access to PROVISIONKEY.

IIRC, earlier versions did do a deep copy, but then I got clever.  Anyways, yeah,
sadly the entire pageinfo.contents page will need to be copied.

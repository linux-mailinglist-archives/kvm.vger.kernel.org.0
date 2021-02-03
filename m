Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B1A30E776
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 00:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233558AbhBCXhI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 18:37:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233475AbhBCXhF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 18:37:05 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EDEC061573
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 15:36:25 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id z21so848396pgj.4
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 15:36:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=76G54f6sJWsu15QYylVfOu++BsYY3hbFeGQqJ4hzuLg=;
        b=nLEWuqxk0NWDBcaR9SMLBdTSfC7S8qi+Q1xaPS9VipZekTbQe2QwwU7iMDbHMBQBQb
         VzxGoCcRAHlnQfzUqxJhhkSG77J+Hd/xf2yuOMI1Tj9wB/PMgr3ndAvmCZrEynl5ESgr
         ZSdFkwc6vznOvgSxFAye5RMEw0z8/yg5RXhNRC4Rm+R1WIKbA8RPZ4iiQrkUWbXKiYCD
         EhEg33ZsZF7vYi00+Nf6cTO00RvFxJthx3iLWw1P2fAKDVBW1NpESO11Nvi29edLe2Ld
         7KGICU9swgJU4Rx8xuirvgF4eAzYisYaaku2zoWYUROsXXyJb+WHab5Cta9au9x/0+QV
         FhEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=76G54f6sJWsu15QYylVfOu++BsYY3hbFeGQqJ4hzuLg=;
        b=mV2cbxC6Br0FHEfnEDHXIQAKO0NlTJETYsBsIPbrmRdb+YaMAFlfaQXTGJmRp2zHqy
         LweuVO+EjukLfrm2IeLuNPVQ5XhBsSxYx8Ve4DmmjEN5KhX7RUSHrLbv3t/64C5S3zlz
         VRaDvzNc1dZuJGgyt1wzAqrSog7/cEvzSBMfAu4s4Rv6mu286i0mgCtBAzrWLLFz7McA
         +34tyf8bgkNgxymg/9E/0JI9dCRQyVjcGev8p1XnPl5raRuuphU6zYEP8+qkmqe7CX95
         EZOeP8sz+s4tq+dQLz++HwHgXXftgGU3dZrbanAT83vPu+5+qPtPJVi0Svrckv7TeTCl
         EZ7g==
X-Gm-Message-State: AOAM530BylzIItw8ggEJgsWlV1bDa2qf7EhEruZQ4MzSILs1gLgZa83v
        TNaX+7Jw7lX3gMRaMAk1BJY/zQ==
X-Google-Smtp-Source: ABdhPJydmOHQttFLpllcibwrt3u2xaTHO6SNoLPJowkzmbhOESVK0cwp1BpL1ptzz93Qb41lLJ1xhQ==
X-Received: by 2002:a62:79d8:0:b029:1bf:1fdb:4ae8 with SMTP id u207-20020a6279d80000b02901bf1fdb4ae8mr5418883pfc.58.1612395384356;
        Wed, 03 Feb 2021 15:36:24 -0800 (PST)
Received: from google.com ([2620:15c:f:10:a9a0:e924:d161:b6cb])
        by smtp.gmail.com with ESMTPSA id b6sm3371571pgt.69.2021.02.03.15.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 15:36:23 -0800 (PST)
Date:   Wed, 3 Feb 2021 15:36:17 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
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
Message-ID: <YBszcbHsIlo4I8WC@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
 <d68c01baed78f859ac5fce4519646fc8a356c77d.1611634586.git.kai.huang@intel.com>
 <c235e9ca6fae38ae3a6828218cb1a68f2a0c3912.camel@intel.com>
 <YBr7R0ns79HB74XD@google.com>
 <b8b57360a1b4c0fa4486cd4c3892c7138e972fff.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b8b57360a1b4c0fa4486cd4c3892c7138e972fff.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 04, 2021, Kai Huang wrote:
> On Wed, 2021-02-03 at 11:36 -0800, Sean Christopherson wrote:
> > On Wed, Feb 03, 2021, Edgecombe, Rick P wrote:
> > > On Tue, 2021-01-26 at 22:31 +1300, Kai Huang wrote:
> > > > +       /* Exit to userspace if copying from a host userspace address
> > > > fails. */
> > > > +       if (sgx_read_hva(vcpu, m_hva, &miscselect,
> > > > sizeof(miscselect)) ||
> > > > +           sgx_read_hva(vcpu, a_hva, &attributes,
> > > > sizeof(attributes)) ||
> > > > +           sgx_read_hva(vcpu, x_hva, &xfrm, sizeof(xfrm)) ||
> > > > +           sgx_read_hva(vcpu, s_hva, &size, sizeof(size)))
> > > > +               return 0;
> > > > +
> > > > +       /* Enforce restriction of access to the PROVISIONKEY. */
> > > > +       if (!vcpu->kvm->arch.sgx_provisioning_allowed &&
> > > > +           (attributes & SGX_ATTR_PROVISIONKEY)) {
> > > > +               if (sgx_12_1->eax & SGX_ATTR_PROVISIONKEY)
> > > > +                       pr_warn_once("KVM: SGX PROVISIONKEY
> > > > advertised but not allowed\n");
> > > > +               kvm_inject_gp(vcpu, 0);
> > > > +               return 1;
> > > > +       }
> > > > +
> > > > +       /* Enforce CPUID restrictions on MISCSELECT, ATTRIBUTES and
> > > > XFRM. */
> > > > +       if ((u32)miscselect & ~sgx_12_0->ebx ||
> > > > +           (u32)attributes & ~sgx_12_1->eax ||
> > > > +           (u32)(attributes >> 32) & ~sgx_12_1->ebx ||
> > > > +           (u32)xfrm & ~sgx_12_1->ecx ||
> > > > +           (u32)(xfrm >> 32) & ~sgx_12_1->edx) {
> > > > +               kvm_inject_gp(vcpu, 0);
> > > > +               return 1;
> > > > +       }
> > > 
> > > Don't you need to deep copy the pageinfo.contents struct as well?
> > > Otherwise the guest could change these after they were checked.
> > > 
> > > But it seems it is checked by the HW and something is caught that would
> > > inject a GP anyway? Can you elaborate on the importance of these
> > > checks?
> > 
> > Argh, yes.  These checks are to allow migration between systems with different
> > SGX capabilities, and more importantly to prevent userspace from doing an end
> > around on the restricted access to PROVISIONKEY.
> > 
> > IIRC, earlier versions did do a deep copy, but then I got clever.  Anyways, yeah,
> > sadly the entire pageinfo.contents page will need to be copied.
> 
> I don't fully understand the problem. Are you worried about contents being updated by
> other vcpus during the trap? 
> 
> And I don't see how copy can avoid this problem. Even you do copy, the content can
> still be modified afterwards, correct? So what's the point of copying?

The goal isn't correctness, it's to prevent a TOCTOU bug.  E.g. the guest could
do ECREATE w/ SECS.SGX_ATTR_PROVISIONKEY=0, and simultaneously set
SGX_ATTR_PROVISIONKEY to bypass the above check.

> Looks a better solution is to kick all vcpus and put them into block state
> while KVM is doing ENCLS for guest.

No.  (a) it won't work, as the memory is writable from host userspace.  (b) that
does not scale, at all.

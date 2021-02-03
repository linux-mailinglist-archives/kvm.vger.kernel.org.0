Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B0830E822
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbhBCX76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 18:59:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbhBCX75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 18:59:57 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11EE8C061573
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 15:59:17 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id z9so674117pjl.5
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 15:59:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=zmrd5KcSYIfn0biCYVep+WpTsWUWPvSKkfiB987XO40=;
        b=ZuDzv+YoRLxZMI72Jj8issHjuiZqto53Qb0wMJ2VjD1jbxa8QtpuzGu6yIy3r0hj/j
         J6LkdwBJs/M/JblPgaJJaRA7dcj2Wa2ALN4CS0tLdA12CnYKb0JRd1njRydkslzr0oYW
         EzfJokRZNHV4stdJvXG94IwMf+DAyHxKlrb2WlI9xM4OMat6IOBJDUkNCPdMG6CrkqyO
         SEVNiNIZt/HHexyRWPP5e0E0jbuLvdMzeK7YnPikDp3kogHR5cZzOKLfT3/uhtNvmpJB
         JN+QyciQaoLP+JKG3cO/YvSNLSwpiOFFro/5HUVNu0SBdDstFmdzzyrSKRrzU3fSC5Y5
         8yGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=zmrd5KcSYIfn0biCYVep+WpTsWUWPvSKkfiB987XO40=;
        b=UwkmLQq97JY1mj2kyj3NSWI/mKkWYnkHPrlw6b/hISa0+Z5orNT+3V3Te1IKaZPvFr
         +INGhxJTlneimZQjZcBNJ5iqcw2K2ywzhXwNrcY9D+OR/SBgWq8o243i46MskvwZl2Ko
         Zq+rwB9nllHEsY68TZi8IaLUvQuCl9YOHtUbRx3mpafx/MrfQKGU9uDQw7uzskVzLMfF
         Diuot02e3x3XKHJ6ljDx2q8TEJhyfTsR0L13k21x+ZfbRWUCzFAjCNg4mlLWVocE4opB
         +M9gowFCYN5jFQVDgpZ2Zhg64vCSzOZigMCXKFty2jnKBUHh1DDxJPviUr/lUouSr9N/
         6U1w==
X-Gm-Message-State: AOAM531XlBI5At80eQ73nLioAkAkWT+tMtfCArk7a8W81Uuoe+0nQRul
        bn+oc4YIUYZndNjvK3KEpWcqGQ==
X-Google-Smtp-Source: ABdhPJyeXrAxFwJuSQA0Ec8fcaRsxDqEi++4Y+YYPhQxfKwmF0m3UNLX7uSmcsuI1wSK+eyKqAH/ZA==
X-Received: by 2002:a17:902:a412:b029:db:cf5a:8427 with SMTP id p18-20020a170902a412b02900dbcf5a8427mr5148909plq.48.1612396756424;
        Wed, 03 Feb 2021 15:59:16 -0800 (PST)
Received: from google.com ([2620:15c:f:10:a9a0:e924:d161:b6cb])
        by smtp.gmail.com with ESMTPSA id s18sm3231457pjr.14.2021.02.03.15.59.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 15:59:15 -0800 (PST)
Date:   Wed, 3 Feb 2021 15:59:09 -0800
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
Message-ID: <YBs4zeRxudvNem44@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
 <d68c01baed78f859ac5fce4519646fc8a356c77d.1611634586.git.kai.huang@intel.com>
 <c235e9ca6fae38ae3a6828218cb1a68f2a0c3912.camel@intel.com>
 <YBr7R0ns79HB74XD@google.com>
 <b8b57360a1b4c0fa4486cd4c3892c7138e972fff.camel@intel.com>
 <YBszcbHsIlo4I8WC@google.com>
 <d5dd889484f6b8c3786ffe75c1505beb944275b3.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d5dd889484f6b8c3786ffe75c1505beb944275b3.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 04, 2021, Kai Huang wrote:
> On Wed, 2021-02-03 at 15:36 -0800, Sean Christopherson wrote:
> > On Thu, Feb 04, 2021, Kai Huang wrote:
> > > On Wed, 2021-02-03 at 11:36 -0800, Sean Christopherson wrote:
> > > > On Wed, Feb 03, 2021, Edgecombe, Rick P wrote:
> > > > > On Tue, 2021-01-26 at 22:31 +1300, Kai Huang wrote:
> > > > > Don't you need to deep copy the pageinfo.contents struct as well?
> > > > > Otherwise the guest could change these after they were checked.
> > > > > 
> > > > > But it seems it is checked by the HW and something is caught that would
> > > > > inject a GP anyway? Can you elaborate on the importance of these
> > > > > checks?
> > > > 
> > > > Argh, yes.  These checks are to allow migration between systems with different
> > > > SGX capabilities, and more importantly to prevent userspace from doing an end
> > > > around on the restricted access to PROVISIONKEY.
> > > > 
> > > > IIRC, earlier versions did do a deep copy, but then I got clever.  Anyways, yeah,
> > > > sadly the entire pageinfo.contents page will need to be copied.
> > > 
> > > I don't fully understand the problem. Are you worried about contents being updated by
> > > other vcpus during the trap? 
> > > 
> > > And I don't see how copy can avoid this problem. Even you do copy, the content can
> > > still be modified afterwards, correct? So what's the point of copying?
> > 
> > The goal isn't correctness, it's to prevent a TOCTOU bug.  E.g. the guest could
> > do ECREATE w/ SECS.SGX_ATTR_PROVISIONKEY=0, and simultaneously set
> > SGX_ATTR_PROVISIONKEY to bypass the above check.
> 
> Oh ok. Agreed.
> 
> However, such attack would require precise timing. Not sure whether it is feasible in
> practice.

It's very feasible.  XOR the bit in a tight loop, build the enclave on a
separate thread.  Do that until EINIT succeeds.  Compared to other timing
attacks, I doubt it'd take all that long to get a successful result.

Regardless, the difficulty in exploiting the bug is irrelevant, it's a glaring
flaw that needs to be fixed.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8E266AA59
	for <lists+kvm@lfdr.de>; Sat, 14 Jan 2023 10:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjANJQ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Jan 2023 04:16:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjANJQ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Jan 2023 04:16:27 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FAE446A0;
        Sat, 14 Jan 2023 01:16:26 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id f34so36290258lfv.10;
        Sat, 14 Jan 2023 01:16:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XdiofrC+ATWa4bXfwZPlfeQteX2qmyBDEfYiwPvOT2M=;
        b=bf7r8yphtF/ory3pQEKwACVU/WJB8QYbpm7A5skYKK8nMbG3ufoSXAG+OC5Z/FXZap
         3ylOwVXPzzi0jQiYDC9Ssd5sQeWRN9eAFhu8w1hLP1lpvbymiioKt1+V7pvnHynflC7H
         NBKppxPzZfaXBQ8XdJHtaZK1a7ijFrsfnFmjJrYZFo49FXiZMDTpsVSR3yW3w+2lxIZz
         1edx8vaYtb+GkFd3KUNxylK5HHHwFmm0iwVPUk7eyeQvT5BHZi6VPgj4OCGyntZaH+ic
         KvuVOcxh8UP5FjElc47rYjLKmx5GtSlrrPaEW7SYpseJxarSvVL9+YkOs6ua6JmxAcrd
         /zGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XdiofrC+ATWa4bXfwZPlfeQteX2qmyBDEfYiwPvOT2M=;
        b=VUfZDHJ7A6G5vhwWlUW6ETgQEdHJ4VfAI2/5hSyChsfrwF5pRw3rv/i7efnpdOYJ08
         3vzkrYGhbap1NIypGsCW7RKJeIYmq4w4cZ8nUh2m+PXTRbcrp+8PnokkY1EQnPLrrD33
         MxMmRTWPv31g3ujCBv6etY2uWGUVj9H9LtcHhicdcWOg5J6j85rMwBFNPs+vinP4+l+U
         E/L7zWhcpsxfcCNkWbFYJmm9/QEgrTGBwaPmE3BIKtdntwVQ59094DlIae1xkY2jDwP8
         hvvsTHl5Svt8ChM3+XRI9YdUJbl6qlrQ6i/8xcXwXth+dEjEWd3jgmorEV/+gAo/7tDg
         Q3Eg==
X-Gm-Message-State: AFqh2kr69msdTIn+MFUrBnxeMfmbrsQE/jknqEbw3zaEDst3jB2H+QZc
        fGu6+U/ZQ+7KhcM4niLN3LU=
X-Google-Smtp-Source: AMrXdXu25Vj0070/Gb/nYu42EBGKOKSz3fL9sJYyNE1qbJeXlVDfxQm5X6g/GWym3aWuPKUdiCscqg==
X-Received: by 2002:a05:6512:6d0:b0:4c8:d65:da85 with SMTP id u16-20020a05651206d000b004c80d65da85mr7034362lff.2.1673687784229;
        Sat, 14 Jan 2023 01:16:24 -0800 (PST)
Received: from localhost (88-113-32-99.elisa-laajakaista.fi. [88.113.32.99])
        by smtp.gmail.com with ESMTPSA id j11-20020a056512344b00b004cafd4cc1fdsm4240267lfr.5.2023.01.14.01.16.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 01:16:24 -0800 (PST)
Date:   Sat, 14 Jan 2023 11:16:21 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Message-ID: <20230114111621.00001840@gmail.com>
In-Reply-To: <Y8F1uPsW56fVdhmC@google.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
        <68fa413e61d7471657174bc7c83bde5c842e251f.1673539699.git.isaku.yamahata@intel.com>
        <20230113151258.00006a6d@gmail.com>
        <Y8F1uPsW56fVdhmC@google.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 Jan 2023 15:16:08 +0000
Sean Christopherson <seanjc@google.com> wrote:

> On Fri, Jan 13, 2023, Zhi Wang wrote:
> > On Thu, 12 Jan 2023 08:31:26 -0800 isaku.yamahata@intel.com wrote:
> > > +static void tdx_reclaim_td_page(unsigned long td_page_pa)
> > > +{
> > > +	if (!td_page_pa)
> > > +		return;
> > > +	/*
> > > +	 * TDCX are being reclaimed.  TDX module maps TDCX with HKID
> > > +	 * assigned to the TD.  Here the cache associated to the TD
> > > +	 * was already flushed by TDH.PHYMEM.CACHE.WB before here,
> > > So
> > > +	 * cache doesn't need to be flushed again.
> > > +	 */
> > > +	if (WARN_ON(tdx_reclaim_page(td_page_pa, false, 0)))
> 
> The WARN_ON() can go, tdx_reclaim_page() has WARN_ON_ONCE() +
> pr_tdx_error() in all error paths.
> 
> > > +		/* If reclaim failed, leak the page. */
> > 
> > Better add a FIXME: here as this has to be fixed later.
> 
> No, leaking the page is all KVM can reasonably do here.  An improved
> comment would be helpful, but no code change is required.
> tdx_reclaim_page() returns an error if and only if there's an
> unexpected, fatal error, e.g. a SEAMCALL with bad params, incorrect
> concurrency in KVM, a TDX Module bug, etc.  Retrying at a later point is
> highly unlikely to be successful.

Hi:

The word "leaking" sounds like a situation left unhandled temporarily.

I checked the source code of the TDX module[1] for the possible reason to
fail when reviewing this patch:

tdx-module-v1.0.01.01.zip\src\vmm_dispatcher\api_calls\tdh_phymem_page_reclaim.c
tdx-module-v1.0.01.01.zip\src\vmm_dispatcher\api_calls\tdh_phymem_page_wbinvd.c

a. Invalid parameters. For example, page is not aligned, PA HKID is not zero...

For invalid parameters, a WARN_ON_ONCE() + return value is good enough as
that is how kernel handles similar situations. The caller takes the
responsibility.
 
b. Locks has been taken in TDX module. TDR page has been locked due to another
SEAMCALL, another SEAMCALL is doing PAMT walk and holding PAMT lock... 

This needs to be improved later either by retry or taking tdx_lock to avoid
TDX module fails on this.

[1] https://www.intel.com/content/www/us/en/download/738875/738876/intel-trust-domain-extension-intel-tdx-module.html

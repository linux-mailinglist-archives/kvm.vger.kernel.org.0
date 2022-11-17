Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C7B62E38E
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 18:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234925AbiKQRzM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 12:55:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234871AbiKQRzE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 12:55:04 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF80F10569;
        Thu, 17 Nov 2022 09:55:03 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id k22so2505109pfd.3;
        Thu, 17 Nov 2022 09:55:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bh54jNDFnig7JAcsJlJeqxMS4yaPT+ROniDWtmjRz/0=;
        b=OQeNSI0swHxoFMK4q+SqZ+hIf6tBxEZIYGnlgG19tF/4yvclewkAY9xjZZCWojR4kc
         sCH5jXT4wO1N1y1XMCQVUR4vZ5PJQpfztiCzKOHhYU7WphGCogg0OVJa+rIjqb9zqHsh
         XFONJUnqIOoOkYXlYU07btyx1mzMqu+q6qZ5sFgjWzL79jMg1+aJbJSixpldNCSgnM5N
         CZVyv6F4MLed4V2UvdPI1cVrbYrmtUjyApxseGwWyWicFPrKuuIYHHd7qgbvLmHf6gcd
         DCP6kuIfXuiN6MoQFco+SzLALslrAsPEUeMAmkpBA7GWCWkalF0bpL8iBxEFM5H06Dmi
         q4MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bh54jNDFnig7JAcsJlJeqxMS4yaPT+ROniDWtmjRz/0=;
        b=z1K9HkeUndM9RVgrVRd3HAWk/c71IvxonJLs/wN2unROGn2IMtVOTTtlknDI7zeGz6
         oOoLgKh3V9TInPPQpupXRn5g2L7Qen4+GkM7bT9PYuQP63WybSdcYlQhdM5PQaBSOZrv
         ivVxuZJSQGCyvGHPDBpIzrDcNPFOD+HsTB1nnEKdwqRtuZZfW4+HarkRm8MlCSsxQnmI
         eiO9eC7D/MJDRcQSHKpnn5e7VopQzz0m1Z7X2L9rEb270B8AVe/m7o7UF90Dw899luJq
         m0iT5Prd0Kbpef/VvdStQW4byiurZlMOq2bCMcgqIEfGHZxzDngmQVVQ5J8NIH4pfrRw
         ly0A==
X-Gm-Message-State: ANoB5pl9jO0I3gAds+r7lDt950so92wmWnXULSgcPU9uSWUHQGujbsWS
        Evf+HUfNAYqsqrpFznLo24U=
X-Google-Smtp-Source: AA0mqf4AkixFl4ufZPvhz0n80dubVtNTlrpq1umkovlemXx/zdsPOlvTSpBRgwsOcxN5Koi4x/AvGg==
X-Received: by 2002:a63:5b47:0:b0:437:e9f3:8add with SMTP id l7-20020a635b47000000b00437e9f38addmr3044478pgm.438.1668707703229;
        Thu, 17 Nov 2022 09:55:03 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id q3-20020a17090311c300b00186a6b63525sm1717826plh.120.2022.11.17.09.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 09:55:02 -0800 (PST)
Date:   Thu, 17 Nov 2022 09:55:02 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v10 031/108] KVM: x86/mmu: Replace hardcoded value 0 for
 the initial value for SPTE
Message-ID: <20221117175502.GG2350331@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <0de1d5dfbce49b5e9d4f93289296b726180b8dd0.1667110240.git.isaku.yamahata@intel.com>
 <eab804a34b96dfdd74a816b92039fca9a81475f0.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <eab804a34b96dfdd74a816b92039fca9a81475f0.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 08, 2022 at 11:33:12AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Sat, 2022-10-29 at 23:22 -0700, isaku.yamahata@intel.com wrote:
> > The plan is to unconditionally set the "suppress #VE" bit for both AMD and
> > Intel as: 1) AMD hardware doesn't use this bit; 2) for conventional VMX
> > guests, KVM never enables the "EPT-violation #VE" in VMCS control and
> > "suppress #VE" bit is ignored by hardware.
> 
> Hi Isaku,
> 
> "AMD hardware doesn't use this bit" is wrong:
> 
> https://lore.kernel.org/lkml/cover.1659854790.git.isaku.yamahata@intel.com/T/#m5ed59404da43677e99ac51dd1360dc22b964bcbb

Oops. I'll update the commit message.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

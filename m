Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42176726840
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 20:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbjFGSQQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 14:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbjFGSQL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 14:16:11 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23F626A1;
        Wed,  7 Jun 2023 11:15:48 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-6532671ccc7so6831622b3a.2;
        Wed, 07 Jun 2023 11:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686161739; x=1688753739;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I1Bdx56ELbJV6dVhyhR5X8oZi1hZNlzrjaEbVK43zt0=;
        b=n+4h+HLEv7EtmjMbv4XFFywlwFrltstBuM8BlVU6O6baPWbwsPuzB8CIDradodZ9sk
         oovi1r+vTq+81F5PPTMSE7Pk+xfLqed6d8UntW66P5fxjDpqZzkmqcG7h1PBjpeO0+Hd
         4bksgwvv/ULOalVkUPeZM5m/Jp3SQiHOekKOaFQdzGNzCTkgE8LO2soreHroIBOxRUlC
         Nr5H+zrh1ndKXPxNTdFeMAeqNn1wCpgmF1uqP11eZD3JEkGfSs/QrmEUO6UNZ71jDoUm
         Da0uv69LcxBjL3PbCo87IVTkgOJXB+O8t8mHAcSU3lPMRQv+j+utjBNcU37uU9Y2mzTL
         W53Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686161739; x=1688753739;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I1Bdx56ELbJV6dVhyhR5X8oZi1hZNlzrjaEbVK43zt0=;
        b=A9TDFy6tkL82jdXHXF+OyFSkh9FFq5x/CEgH5/+ogeH4vSkfS9XkRLQwumjPCs6d9q
         gDr/UcSpirIWTx+s5oZBHJFUCYYwu7/oWSAMBQXOx01QaT2FOnD/SR+vskIuJ65OqXf0
         Rq4KUhv9XqizxYMOPrpgu1AyG0dGhAu3R2viDai0ObtxcALgS4vkog3KiidI2y1G5K0k
         36hRaK7jVsTQz3KuVbiJRqlbClRUk0QH2yj0e0DmFJHg/IJ7PkDIdn1zmtZSVywiFtAT
         AxavCqGBhQxvClMrISM6Nk7b2KC21obHmxI3clHEnVNyparp15kS7fEm5ZOryEDv8VjM
         L08Q==
X-Gm-Message-State: AC+VfDwqHoOhTowKnDJ/nK7cferX0WywTStZhaZMFo48yQYewbOzEDPg
        puenZfWP2yt1TpV8CpP5l3zTgB75AozANQ==
X-Google-Smtp-Source: ACHHUZ5/l4PYL/diZnBXO47WKC1iNZQbpyhoKSRt8h8KKmprcUXYCD2dnCbnJWNxoM6wWCRQ43cCyg==
X-Received: by 2002:a05:6a00:180f:b0:663:13a9:9504 with SMTP id y15-20020a056a00180f00b0066313a99504mr162246pfa.10.1686161739462;
        Wed, 07 Jun 2023 11:15:39 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id b17-20020aa78111000000b0064dbf805ff7sm2587545pfi.72.2023.06.07.11.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 11:15:38 -0700 (PDT)
Date:   Wed, 7 Jun 2023 11:15:37 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Wang, Wei W" <wei.w.wang@intel.com>
Cc:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        "Chen, Bo2" <chen.bo@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v14 011/113] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Message-ID: <20230607181537.GG2244082@ls.amr.corp.intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
 <37b118268ccf73d8e9cc1ef8f9fb7376fb732d60.1685333727.git.isaku.yamahata@intel.com>
 <DS0PR11MB6373872D1536D6469B29159CDC4DA@DS0PR11MB6373.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DS0PR11MB6373872D1536D6469B29159CDC4DA@DS0PR11MB6373.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 03:20:19PM +0000,
"Wang, Wei W" <wei.w.wang@intel.com> wrote:

> > diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
> > new file mode 100644 index 000000000000..893cc6c25f3b
> > --- /dev/null
> > +++ b/arch/x86/kvm/vmx/tdx_ops.h
> > @@ -0,0 +1,202 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/* constants/data definitions for TDX SEAMCALLs */
> > +
> > +#ifndef __KVM_X86_TDX_OPS_H
> > +#define __KVM_X86_TDX_OPS_H
> > +
> > +#include <linux/compiler.h>
> > +
> > +#include <asm/cacheflush.h>
> > +#include <asm/asm.h>
> > +#include <asm/kvm_host.h>
> > +
> > +#include "tdx_errno.h"
> > +#include "tdx_arch.h"
> > +#include "x86.h"
> > +
> > +static inline u64 kvm_seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
> > +			       struct tdx_module_output *out) {
> > +	u64 ret;
> > +
> > +	ret = __seamcall(op, rcx, rdx, r8, r9, out);
> > +	if (unlikely(ret == TDX_SEAMCALL_UD)) {
> > +		/*
> > +		 * TDX requires VMXON or #UD.  In the case of reboot or
> > kexec,
> > +		 * VMX is made off (VMXOFF) by kvm reboot notifier,
> > +		 * kvm_reboot(), while TDs are still running.  The callers
> > check
> > +		 * the returned error and complain.  Suppress it by returning 0.
> > +		 */
> 
> Curious how do the callers check the returned error when " Suppress
> it by returning 0" here.

It doesn't make sense for the caller to check the error and warn when
kvm_rebooting = true.
Let's make it "return kvm_rebooting ? 0 : ret;" instread of "return 0;".
Does it make sense?
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

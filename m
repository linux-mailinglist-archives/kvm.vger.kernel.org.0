Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B5671F70B
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 02:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233083AbjFBAPI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 20:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjFBAPG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 20:15:06 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2970C12C;
        Thu,  1 Jun 2023 17:15:06 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id 006d021491bc7-541f4ee6f89so1055784eaf.2;
        Thu, 01 Jun 2023 17:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685664905; x=1688256905;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lZoO4kRichS2zxccTSqMieJokAHBxiDEurxplxjeSpo=;
        b=DCAbpoRMxIVbOpnsaG9vlDWF6vxI0ZuKoJvsPqsclYD4OOtVN64fSHST9sJymuEaGr
         vrZ6/S0THbeCrqHP/AuwysQzbPRcl4ov7MT/Gp7wOfZy5bVGuJ+zYzksbCfAQ+IB3N9Z
         ZXmghJNvTAjMzcZQ2N4hETTBtEq490Ubrb84M9827mCI8mgkRt6+vmzFUQWsOFlcV9XV
         /a0PtKP2qxj97/cqTGJWGZ5qHiuO/n4WXvNEZ2TnB6yr0BftWh0NClXGiTLbced6sB41
         2b4fu/sYH9yFfHyZABcVAT5qbtj0P3sfW8gy14RBh5xNdFmlyaU2449Pj/ob3FdQ0KeN
         Pq6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685664905; x=1688256905;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lZoO4kRichS2zxccTSqMieJokAHBxiDEurxplxjeSpo=;
        b=ZiQB3JYBFiGshatvqZdYyO/b/yGV+5FTBSs0fg/ty9EXvLIkxtv+vp6nIpeVwuQ68Y
         V4vfpnvsygvGjR8twhAr7WfeBJzh7SJQ9kO26snjKtDxhMm1LSFybze6filI5/sb0SYm
         E+q+LuW90yDlOVOufRQv+2ghLfQEKhbUxylyNncu7EiILiuBwrSOyAwPx9w0YKwrVCqn
         tA0q6m2kx9cqZdHNeHjBRNI6LLFiKJyjTZ/1CFOx9v2eOLd4H/zO4Q/0UYH2Ppzaz/J5
         ly02was0+ORhHHiRGRQ7l8ujC7SBd0qO29ERAD+g0niMHgtHNid+RkFLRmKK3Elr4g+B
         5Clg==
X-Gm-Message-State: AC+VfDyB+6+awfDyqvArumZ+/YndGbsfGoEbIVRa4oCp17OIWAbIQ7jv
        QL3HjkH2F+RGkZW1V3GxSVs=
X-Google-Smtp-Source: ACHHUZ6yjBcvEkrtugxUO4HIiOG6YluU7DgTZTKviOwpM19PM7jHGijJn0nZH8PDi8q7R+IMIL32yA==
X-Received: by 2002:a05:6358:5e01:b0:117:ffb1:dfa8 with SMTP id q1-20020a0563585e0100b00117ffb1dfa8mr5113373rwn.19.1685664905223;
        Thu, 01 Jun 2023 17:15:05 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id c13-20020aa7880d000000b0063d46ec5777sm5603608pfo.158.2023.06.01.17.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 17:15:04 -0700 (PDT)
Date:   Thu, 1 Jun 2023 17:15:02 -0700
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
Message-ID: <20230602001502.GI1234772@ls.amr.corp.intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
 <37b118268ccf73d8e9cc1ef8f9fb7376fb732d60.1685333727.git.isaku.yamahata@intel.com>
 <DS0PR11MB63736AAA616C74E5F8316B1ADC499@DS0PR11MB6373.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DS0PR11MB63736AAA616C74E5F8316B1ADC499@DS0PR11MB6373.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 01, 2023 at 01:24:35PM +0000,
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
> 
> As discussed somewhere before, kvm_* is more common to be labelled for the
> generic code. Would it be better to be named tdx_seamcall here?

Ok, let's rename it to tdx_seamcall(), that's more consistent in this file.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

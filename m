Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9CC5353E7
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 21:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344987AbiEZT2t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 15:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiEZT2r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 15:28:47 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264164BB83;
        Thu, 26 May 2022 12:28:47 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id gk22so2632887pjb.1;
        Thu, 26 May 2022 12:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=e2aEm4l6aQr3oyoHBVOR4pb/mJNPMjNtRn+Wn2MyTwA=;
        b=EdtWl4YeWlWe+aiDrDmZt95xVF5e7EjM+NBkReFonToKJgrFNJLE3x/tuqUMaODDgH
         z175s4+g8lqca6vSC7CVBRpJaXrAkW01gCIufNnytrPpa849e8stRLKgH6x7gXteQ6WO
         O7gvDHPsdgduLwbYEAlJFOwg+9KD3sNtMFy7TaMd8Gxr15HAwKxuxIgMBqwaUB9VbmpH
         oIBev9rEz6TpNhzBejXGAsgFLT/HHxayi41K/pH1RjhOuTn0OPQDXb8GMJtb7qJiHJlc
         JK7+qEDJckDhFPioqvtycQZXRCED2zkOe+7t9PW6KRQKfdRRxco3SfbG9mNsgSnhTpXW
         yD2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e2aEm4l6aQr3oyoHBVOR4pb/mJNPMjNtRn+Wn2MyTwA=;
        b=KKjPr9dVKSeaRiKrvD0ezp6BBItZRSDOj93phmhrVceEOLLQXah7pYEZBGEjESm8dM
         HdxBIlSV0n1vVZZdc35NwL6jCGhkjGd8Ka8ar78YlVroVpOcxdIVx7FDj00iVY79PKDq
         RFj6l/gk32UahmW2VvsO7kwYUcUx/1jXwSqmB9ybKgALtqDLV2Dug0EG4oqbPtkF76+K
         ZmM6Z9leavPA0S3rS4u+lAxdeYewI170cJl1HfDuqivNEHaF4mkAjS8u+BbI3SN9fNob
         0RsvxED2OIkPmLfDkIIiD4diQZh+Kn3gwSn6WpAFXqTtnsTTiG5cR2zHl4mdQRxddQsq
         1q9w==
X-Gm-Message-State: AOAM532yp/Pcl0TkHoLtfHywG25H58A8tCpdYEG4y0tFxjAK8M2eoMZq
        XfXT7XNW1SujEwE6GQPPhFc=
X-Google-Smtp-Source: ABdhPJwj53C01uVXrjQ9FlROcibjKde9Rip8NxhpfVv986KX1k4tmge6DJyoTptUkaw/7dmkKrjD+A==
X-Received: by 2002:a17:902:f78d:b0:14d:522e:deb3 with SMTP id q13-20020a170902f78d00b0014d522edeb3mr39151166pln.173.1653593326637;
        Thu, 26 May 2022 12:28:46 -0700 (PDT)
Received: from localhost ([192.55.54.49])
        by smtp.gmail.com with ESMTPSA id i67-20020a625446000000b0050dc76281bbsm1891209pfb.149.2022.05.26.12.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 12:28:46 -0700 (PDT)
Date:   Thu, 26 May 2022 12:28:44 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sagi Shahar <sagis@google.com>
Cc:     "Yamahata, Isaku" <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v6 006/104] KVM: TDX: Detect CPU feature on kernel
 module initialization
Message-ID: <20220526192844.GC3413287@ls.amr.corp.intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
 <eb5d2891a3ff55d88545221c588ba87e4c811878.1651774250.git.isaku.yamahata@intel.com>
 <CAAhR5DFWo6KjBO_0QtT71S2ZmKc-kAo6Kqcwc2M4-kFc-PkmyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAAhR5DFWo6KjBO_0QtT71S2ZmKc-kAo6Kqcwc2M4-kFc-PkmyA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 23, 2022 at 04:47:59PM -0700,
Sagi Shahar <sagis@google.com> wrote:

> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > new file mode 100644
> > index 000000000000..9e26e3fa60ee
> > --- /dev/null
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -0,0 +1,39 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <linux/cpu.h>
> > +
> > +#include <asm/tdx.h>
> > +
> > +#include "capabilities.h"
> > +#include "x86_ops.h"
> > +
> > +#undef pr_fmt
> > +#define pr_fmt(fmt) "tdx: " fmt
> > +
> > +static u64 hkid_mask __ro_after_init;
> > +static u8 hkid_start_pos __ro_after_init;
> > +
> > +int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> > +{
> > +       u32 max_pa;
> > +
> > +       if (!enable_ept) {
> > +               pr_warn("Cannot enable TDX with EPT disabled\n");
> > +               return -EINVAL;
> > +       }
> > +
> > +       if (!platform_has_tdx()) {
> > +               if (__seamrr_enabled())
> > +                       pr_warn("Cannot enable TDX with SEAMRR disabled\n");
> 
> So if we fail for another reason (e.g. tdx_keyid_sufficient returns
> false) we are going to fail silently and disable TDX without any log
> saying what happened. This will make it difficult to debug TDX
> initialization issues.

Agreed.  I've updated it as follows.

+int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
+{
+       u32 max_pa;
+
+       if (!enable_ept) {
+               pr_warn("Cannot enable TDX with EPT disabled\n");
+               return -EINVAL;
+       }
+
+       if (!platform_has_tdx()) {
+               if (__seamrr_enabled())
+                       pr_warn("Cannot enable TDX with SEAMRR disabled\n");
+               else
+                       pr_warn("Cannot enable TDX on TDX disabled platform.\n");
+               return -ENODEV;
+       }
+
+       /* Safe guard check because TDX overrides tlb_remote_flush callback. */
+       if (WARN_ON_ONCE(x86_ops->tlb_remote_flush))
+               return -EIO;
+
+       max_pa = cpuid_eax(0x80000008) & 0xff;
+       hkid_start_pos = boot_cpu_data.x86_phys_bits;
+       hkid_mask = GENMASK_ULL(max_pa - 1, hkid_start_pos);
+       pr_info("kvm: TDX is supported. hkid start pos %d mask 0x%llx\n",
+               hkid_start_pos, hkid_mask);
+
+       return 0;
+}
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

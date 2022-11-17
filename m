Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0D5062E328
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 18:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235023AbiKQRe7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 12:34:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbiKQRe6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 12:34:58 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA04532EB;
        Thu, 17 Nov 2022 09:34:57 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id k22so2452450pfd.3;
        Thu, 17 Nov 2022 09:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GpTmGyle5XHjW7gvyvHxuCwQpZoXDUrLr0aG4rFAVf8=;
        b=Z2kCiadhuB3UXfJf81kDm8ji1v9Db3bAW+nVpWQopH+ASUM3NfA2hLMB/YGHkEZdkj
         +g+o3hYtU9dUSCMVdnRK+oHtUwfCPt6kFPzXPDvsIUCw8qHXHnHXhnBN/VkZ69BukmPT
         nb7+YZGkny0COiexyK2R25oFBkSkp3kvGVibjiDBEuDU9bUwhfhkjp5jLglRb3ehdrw1
         /Vs3oTvkjusQ6BxYV3Ylybh5tNCzw3hXVmV4qZrcCPOzAi0+3mp9GCWhD6lACAXJ4WH0
         zTK0YJiTYXWOp2I/zdR/00DEEm4lzl2HM7vIyqNvRKKCtySsgVjIMRbrITvnqsXkrlBe
         vnoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GpTmGyle5XHjW7gvyvHxuCwQpZoXDUrLr0aG4rFAVf8=;
        b=0XgZwGUi0aAuBp9/+BLeKPnmx4roEcB+xFEUrPp2tDT8pCM6JouMOA4+yD2M0YGzgl
         9cwPFiJISPx7QtYKJ15NhGQaJSnVzl4oApLf/36Lqj4pxWMtc0GBAL5OejdIzKloO783
         fraxBpaIT6XiPKXavwxvGFBuZPiWUqJct+g07gSScS4CfL+qYRSeUOY8UFC4rsj1I8iE
         bQOXYfHvSVorgQ4+XpNf5KJr2a0ZyLuDW4RpR0YQ9g9YO9Q148j09LdZkjTko1fmfCvS
         Qpl6JrN5vR/AQA34boY3ypj9s1ZKEdblfvND4coS8sL0iFGzQ3bsjxy8DBY6pfJgvjdX
         dLHw==
X-Gm-Message-State: ANoB5pmIYZST8ORoYw8zJJz/aGGvRXyx6DHbKuKCF0OdYp0wB0/8TKi1
        cIp1zJ9ATddu01SL1TpXaeg=
X-Google-Smtp-Source: AA0mqf4mDGFMkETNV6xTkG2tIql5IjvogN6f5ZCJXhrC9IFX+o4zoBBKUshmOBUicaEJ5PV0JbcmBQ==
X-Received: by 2002:a65:6a55:0:b0:470:2c92:13da with SMTP id o21-20020a656a55000000b004702c9213damr3005461pgu.298.1668706496897;
        Thu, 17 Nov 2022 09:34:56 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id t15-20020a170902b20f00b00188ef2314b0sm1667673plr.39.2022.11.17.09.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 09:34:56 -0800 (PST)
Date:   Thu, 17 Nov 2022 09:34:55 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v10 015/108] x86/cpu: Add helper functions to
 allocate/free TDX private host key id
Message-ID: <20221117173455.GC2350331@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <5ee7c6dc4ba03b5d5166e015c148ef534ee53f8e.1667110240.git.isaku.yamahata@intel.com>
 <b145dc3fcf5b2fd29241f4c8b5286b71402c7d7e.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b145dc3fcf5b2fd29241f4c8b5286b71402c7d7e.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 08, 2022 at 09:16:57AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Sat, 2022-10-29 at 23:22 -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > TDX private host key id is assigned to guest TD.  The memory controller
> > encrypts guest TD memory with the assigned TDX private host key id (HIKD).
> 								     ^
> 								     HKID.
> 
> And since you already mentioned in the first sentence, you can put (HKID) part
> there.  And I think you can just use HKID in the rest places to save some typing
> as this is the purpose of using (HKID) I suppose.
> 
> [...]
> 
> >  
> > +/* TDX KeyID pool */
> > +static DEFINE_IDA(tdx_keyid_pool);
> > +
> > +int tdx_keyid_alloc(void)
> > +{
> > +	if (WARN_ON_ONCE(!tdx_keyid_start || !tdx_keyid_num))
> > +		return -EINVAL;
> > +
> > +	/* The first keyID is reserved for the global key. */
> > +	return ida_alloc_range(&tdx_keyid_pool, tdx_keyid_start + 1,
> > +			       tdx_keyid_start + tdx_keyid_num - 1,
> > +			       GFP_KERNEL);
> > +}
> > +EXPORT_SYMBOL_GPL(tdx_keyid_alloc);
> > +
> > +void tdx_keyid_free(int keyid)
> > +{
> > +	/* keyid = 0 is reserved. */
> > +	if (!keyid || keyid <= 0)
> > +		return;
> 
> Double check of keyid == 0.
> 
> I think you can just use:
> 
> 	if (keyid <= tdx_keyid_start)
> 		return;
> 
> And/or add a WARN() as it's a bug if above happens.

Ok. Will fix it with WARN().
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

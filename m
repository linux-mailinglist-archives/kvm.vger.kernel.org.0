Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46D6962E3B1
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 19:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240350AbiKQSCc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 13:02:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240305AbiKQSC0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 13:02:26 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8358C7FF2D;
        Thu, 17 Nov 2022 10:02:23 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id g62so2500726pfb.10;
        Thu, 17 Nov 2022 10:02:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Kwxlz1AmXAtPcO1rVSt3eussQ6+izoYEkg/AX9BJfYU=;
        b=Ksaqo8E43RJMDBliYXRVMKZoWfLY7JfNsyU8BXRXmzpQKOC2mQAX0q/BVeLrQaD91g
         cdD54MimRT8ad53edx4wp74W+H3O2ZU7KanDMuUuHUrhgvIc4PRNrwCDNUl/hQF4mNjJ
         nk5m8Y2s1FSFMOW+9Spa23qH5sl2v9x/K4+izVz8ZKvzAeXHnGpy42IMq/advNn1zVg9
         HfvwUp+ijIJHZDCOuiPIy7OW/Mc1yNBWrmdyfB1B1r0V8MEMeiMWsBjoloItb+hu4KVm
         r9fygq/JPRCl5ZsrOfQTEORDPoSYvvXt7Lz/m8KVysR6BgPqaBacp8/AxMQdfDABvUKJ
         +cOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kwxlz1AmXAtPcO1rVSt3eussQ6+izoYEkg/AX9BJfYU=;
        b=nbJvdldYHJcFTtSJ/NG5FWVlRrN9zKwGnKZc0lP3HtME0mnWGYHv34/ADVOr/6dcQF
         yO7mubrBuay0yk/H3Gg5Ft8cBOEUjlORXBcY0tnARBEXmTAqx0apafygYm6T/J0sZpbU
         rQM4omre8auu5eb9mVDfWI3dGnNsTy6aZjp6vMV6P0JIIM6FP+wmU2ID7wv/ybznBOW/
         RtUYPT+JF8VbZiFu0Z45acNLoaIokeeWHZcYmZ6iNhs4GtcJvxGjAZRdLNCXpusbE7EQ
         uyLgE/RdCjiT28DtJWCsM/tec1plkJJ4Yci9AOtteV5Ot7jCL8eKtuTDGzXQ8f23Cwll
         chfg==
X-Gm-Message-State: ANoB5pmhljgk/0rShvjLMbVpbkyIW46tEGwRlh3mW2QClXLMyOgLcOIN
        b9IARRgMsMtgd0QTc3dfQXs=
X-Google-Smtp-Source: AA0mqf75986yBrDL+6lNm+Cy3z2sUUygZRQQscGc3X4RtZmEz/gpKiqNlFMDrQPrE2JqzU4fQmP7Xg==
X-Received: by 2002:a63:f04d:0:b0:470:5d17:a62e with SMTP id s13-20020a63f04d000000b004705d17a62emr2883764pgj.620.1668708141449;
        Thu, 17 Nov 2022 10:02:21 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id b29-20020aa7951d000000b00561382a5a25sm1471555pfp.26.2022.11.17.10.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 10:02:21 -0800 (PST)
Date:   Thu, 17 Nov 2022 10:02:20 -0800
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
Subject: Re: [PATCH v10 034/108] KVM: x86/mmu: Add Suppress VE bit to
 shadow_mmio_{value, mask}
Message-ID: <20221117180220.GJ2350331@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <1c480a48c2697054b1cfe068fa073f4035648f9a.1667110240.git.isaku.yamahata@intel.com>
 <a0d5878b7280372fa2de49156d58f69fa07659cc.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a0d5878b7280372fa2de49156d58f69fa07659cc.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 09, 2022 at 11:48:30AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Sat, 2022-10-29 at 23:22 -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Because TDX will need shadow_mmio_mask to be VMX_SUPPRESS_VE | RWX	
> > shadow_mmio_value to be 0, make VMX EPT case use same value for TDX
> > shadow_mmio_mask.  
> > 
> 
> TDX need to use different mmio_mask/value doesn't mean they need to be changed
> for VMX guest.  I think the true purpose here is to still be able to use a
> global shadow_mmio_mask for both TDX and VMX guests.  So please explicitly call
> out.  

That's right. With this change, per-VM shadow_mmio_{value, mask} can be avoided.
The common value can be used for both VMX and TDX.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

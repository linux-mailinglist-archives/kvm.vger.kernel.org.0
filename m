Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12FC94F9EF0
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 23:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239786AbiDHVNs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 17:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239129AbiDHVNr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 17:13:47 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7272184B66;
        Fri,  8 Apr 2022 14:11:42 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id k13so3752420plk.12;
        Fri, 08 Apr 2022 14:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=foN+znjNsM8Dv5GG5QumEF5L4dA6jEDJmOc3EsCSs7A=;
        b=Fg6djJJF1vpX9BIUkzLnoEQyMYbzsC2lKM2Gvzu/xJypypof1mfAGQBnWxylv9TMOe
         SsBI8YmWTpxsbSfZAcKaPeJ0Nqg2OKwbXgQ1JGt4t67/egLcz07MS3TVumiHfrjaBAFI
         Y0eDPHPPV+uI49yyRV2CAZfw7Jxg6phzu27n7sJ25la1WA4+qbXxsjfJAD5YisB3rYvV
         jkSR484ou09PQqMfXlayOZ6VDFqPjeVnkoR1/SLwkoyezIy3r4hQAo1kyaalmr+xxLkt
         yihtS6Bq4e7poWs39oZ0IvZacvaXSBhX/a21Eg6AZ1eeFZ6aP55A1jeyPGeO5H0WYOEX
         /Tgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=foN+znjNsM8Dv5GG5QumEF5L4dA6jEDJmOc3EsCSs7A=;
        b=abgimLwY+fc37BCQgDksRzRG+X7pFBK5Mebv7zXyLaRz/TXnAx3RdpQZgcpueO/ZJu
         i7VFQ2V7l9yzKIqlMItl/3unyL3qfrx9BCj9SLH8vRALmZiFS/kJtfJ6Hl7DGYJjmWxZ
         TnFxGTdzEewoz9izB6uy4KCvmVz7/GVpzOLEwlQzUVlZtvbJps01SVRGVWtQuDM53HiF
         F5d0QE19qBNvVozjPmorqTCw5HryBTAzRCqWEUNnoaYvR7CF6bUAeKSLyqGzCAAunqVe
         IgmHT0I73uW9SJWSr3VmD36jVMKnjQd1dwhf8oaQOfg6O36digFFKUH8yATGS6Wk6M+H
         SU5Q==
X-Gm-Message-State: AOAM531iVgiCU9nMtOhy70hm38zJMZU4VlmJKSMoksU5TeGanYsLbEjW
        oJh4ol/7+roSyQlAIcOx29U=
X-Google-Smtp-Source: ABdhPJwuyKDp8x2YcNc2jp/QykaM+ri2Vg9UJJEGuE+XzAzacSJY8FSl4T7gxhghAcyG1UuNGduAyw==
X-Received: by 2002:a17:903:281:b0:14c:f3b3:209b with SMTP id j1-20020a170903028100b0014cf3b3209bmr21223265plr.87.1649452302275;
        Fri, 08 Apr 2022 14:11:42 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id u9-20020a056a00158900b004faad3ae570sm27996158pfk.189.2022.04.08.14.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 14:11:41 -0700 (PDT)
Date:   Fri, 8 Apr 2022 14:11:40 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     SU Hang <darcy.sh@antgroup.com>
Cc:     seanjc@google.com, kvm@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Kr???m?????? <rkrcmar@redhat.com>,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com
Subject: Re: [PATCH v2 2/2] KVM: x86/mmu: Derive EPT violation RWX bits from
 EPTE RWX bits
Message-ID: <20220408211140.GE857847@ls.amr.corp.intel.com>
References: <20220329030108.97341-1-darcy.sh@antgroup.com>
 <20220329030108.97341-3-darcy.sh@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220329030108.97341-3-darcy.sh@antgroup.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 29, 2022 at 11:01:07AM +0800,
SU Hang <darcy.sh@antgroup.com> wrote:

> From: Sean Christopherson <seanjc@google.com>
> 
> Derive the mask of RWX bits reported on EPT violations from the mask of
> RWX bits that are shoved into EPT entries; the layout is the same, the
> EPT violation bits are simply shifted by three.  Use the new shift and a
> slight copy-paste of the mask derivation instead of completely open
> coding the same to convert between the EPT entry bits and the exit
> qualification when synthesizing a nested EPT Violation.
> 
> No functional change intended.
> 
> Cc: SU Hang <darcy.sh@antgroup.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/vmx.h     | 7 +------
>  arch/x86/kvm/mmu/paging_tmpl.h | 8 +++++++-
>  arch/x86/kvm/vmx/vmx.c         | 4 +---
>  3 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 3586d4aeaac7..46bc7072f6a2 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -543,17 +543,12 @@ enum vm_entry_failure_code {
>  #define EPT_VIOLATION_ACC_READ_BIT	0
>  #define EPT_VIOLATION_ACC_WRITE_BIT	1
>  #define EPT_VIOLATION_ACC_INSTR_BIT	2
> -#define EPT_VIOLATION_READABLE_BIT	3
> -#define EPT_VIOLATION_WRITABLE_BIT	4
> -#define EPT_VIOLATION_EXECUTABLE_BIT	5
>  #define EPT_VIOLATION_GVA_IS_VALID_BIT	7
>  #define EPT_VIOLATION_GVA_TRANSLATED_BIT 8
>  #define EPT_VIOLATION_ACC_READ		(1 << EPT_VIOLATION_ACC_READ_BIT)
>  #define EPT_VIOLATION_ACC_WRITE		(1 << EPT_VIOLATION_ACC_WRITE_BIT)
>  #define EPT_VIOLATION_ACC_INSTR		(1 << EPT_VIOLATION_ACC_INSTR_BIT)
> -#define EPT_VIOLATION_READABLE		(1 << EPT_VIOLATION_READABLE_BIT)
> -#define EPT_VIOLATION_WRITABLE		(1 << EPT_VIOLATION_WRITABLE_BIT)
> -#define EPT_VIOLATION_EXECUTABLE	(1 << EPT_VIOLATION_EXECUTABLE_BIT)
> +#define EPT_VIOLATION_RWX_MASK		(VMX_EPT_RWX_MASK << EPT_VIOLATION_RWX_SHIFT)


"#define EPT_VIOLATION_RWX_SHIFT 3" is missing.
It fails to compile.

  CC [M]  arch/x86/kvm/vmx/vmx.o
In file included from linux/arch/x86/include/asm/virtext.h:18,
                 from /linux/arch/x86/kvm/vmx/vmx.c:49:
/linux/arch/x86/kvm/vmx/vmx.c: In function 'handle_ept_violation':
/linux/arch/x86/include/asm/vmx.h:551:54: error: 'EPT_VIOLATION_RWX_SHIFT' undeclared (first use in this function); did you mean 'EPT_VIOLATION_RWX_MASK'?
  551 | #define EPT_VIOLATION_RWX_MASK  (VMX_EPT_RWX_MASK << EPT_VIOLATION_RWX_SHIFT)
      |                                                      ^~~~~~~~~~~~~~~~~~~~~~~

Thanks,
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

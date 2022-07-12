Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0669571232
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 08:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiGLGVE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 02:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiGLGVC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 02:21:02 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B6F27CDD;
        Mon, 11 Jul 2022 23:21:02 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id y141so6658029pfb.7;
        Mon, 11 Jul 2022 23:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bx3MPpelMzbitGLIyxLDh2fGMbGWVYznWb1v2pR0G4g=;
        b=K7sx4HpQOnZ2tqwecKJciEPZ+Sq6Keos+O2P8HBMjqT1WNzlnJ3m7GTR+7fxeNOZ5g
         kFqIjrpYPo79Ou580X83Oja84/LatkO95IWEgpR3DpmYmz+A7z0lmdgIbosZdtw7Ug09
         pQ9DDUpEWuE8SoqHaHYC7/JRpMPKMEEAPu1PWay14Zg9OJhaOIaSKe7+YwGuwoorbF2q
         eVlQrQkjq6amXqrzC4RSn3tjRdFGppR9PY968YMyc/1gtlbaV6isJfWMW9r6q/WQLdz8
         37/T+JEOocrKc/M/vI9gyxJrssae/5EHCHitfPpwbA15ECSMY/qIYZwA45vrAkLWHmnU
         8n7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bx3MPpelMzbitGLIyxLDh2fGMbGWVYznWb1v2pR0G4g=;
        b=C4odZtBSzZEhDp7CdJD89GEsYPLva+39GmtiuSS2eD0ToN6Ehx9vDIe4fwKul6zkJR
         xMueTGhdFyaPHt9xaqeOoHD5rstplyoMkefO/qnEfH8wyP8MWnCUT5QEVV0Zwgn3nSVn
         zEgUtG8lJBm7Mu/SXsQpB7kikvluZUkbsTSGufem7w4vAQHHcMdHLjdv757d4ekxKmzg
         keQYSqXopi/B+UfzsxqxhAMo4XsOia9oOSeqtaVw25CbR3VpdvG3TwzCspflGuPIlz8z
         twq4dp2t96hhA2s6X8MhCBTYaC4dXZiWfC+dV56aCpOGg/Wn3DX09KjEy179KmbtKmCS
         x9xA==
X-Gm-Message-State: AJIora/szpZOUEkvgyuZURHu/NCzVQ13XM2jQAiOu7p+2BICCGZg76y6
        BtmsV/ETwyiOY/mv6ypsVMM=
X-Google-Smtp-Source: AGRyM1syDquBiOAq3UmONWV8b17cnwWp272YV1Lku4eMV4qQsY8d7In4xlOwTzBdbx9t6SnMZegHgQ==
X-Received: by 2002:a05:6a00:10d3:b0:4fe:5d:75c8 with SMTP id d19-20020a056a0010d300b004fe005d75c8mr22612479pfu.6.1657606861395;
        Mon, 11 Jul 2022 23:21:01 -0700 (PDT)
Received: from localhost (fmdmzpr02-ext.fm.intel.com. [192.55.54.37])
        by smtp.gmail.com with ESMTPSA id t13-20020a1709027fcd00b0016c09e23b21sm5813138plb.215.2022.07.11.23.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 23:21:00 -0700 (PDT)
Date:   Mon, 11 Jul 2022 23:21:00 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v7 022/102] KVM: TDX: create/destroy VM structure
Message-ID: <20220712062100.GG1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <aa3b9b81f257d4d177ab25cb78a222d6297de97f.1656366338.git.isaku.yamahata@intel.com>
 <20220707061629.io5mf3riswn3fwvr@yy-desk-7060>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220707061629.io5mf3riswn3fwvr@yy-desk-7060>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 07, 2022 at 02:16:29PM +0800,
Yuan Yao <yuan.yao@linux.intel.com> wrote:

> On Mon, Jun 27, 2022 at 02:53:14PM -0700, isaku.yamahata@intel.com wrote:
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 3675f7de2735..63f3c7a02cc8 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
...
> >  int __init tdx_module_setup(void)
> >  {
> >  	const struct tdsysinfo_struct *tdsysinfo;
> > @@ -48,6 +406,8 @@ int __init tdx_module_setup(void)
> >  		return ret;
> >  	}
> >
> > +	tdx_global_keyid = tdx_get_global_keyid();
> 
> I remember there's another static variable also named
> "tdx_global_keyid" in arch/x86/virt/vmx/tdx/tdx.c ?
> We can just use tdx_get_global_keyid() here without introducing
> another static variable.

Hmm, it can be done by exporting the variable itself.

 static inline int tdx_keyid_alloc(void) { return -EOPNOTSUPP; }
 static inline void tdx_keyid_free(int keyid) { }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index c1d41350e021..71f6d026bfd2 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -43,14 +43,6 @@ struct tdx_capabilities {
        struct tdx_cpuid_config cpuid_configs[TDX_MAX_NR_CPUID_CONFIGS];
 };
 
-/*
- * Key id globally used by TDX module: TDX module maps TDR with this TDX global
- * key id.  TDR includes key id assigned to the TD.  Then TDX module maps other
- * TD-related pages with the assigned key id.  TDR requires this TDX global key
- * id for cache flush unlike other TD-related pages.
- */
-static u32 tdx_global_keyid __read_mostly;
-
 /* Capabilities of KVM + the TDX module. */
 static struct tdx_capabilities tdx_caps;
 
@@ -3572,8 +3564,6 @@ int __init tdx_module_setup(void)
                return ret;
        }
 
-       tdx_global_keyid = tdx_get_global_keyid();
-
        tdsysinfo = tdx_get_sysinfo();
        if (tdsysinfo->num_cpuid_config > TDX_MAX_NR_CPUID_CONFIGS)
                return -EIO;
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index ea35230f0814..68ddcb06c7f1 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -65,13 +65,8 @@ static struct cmr_info tdx_cmr_array[MAX_CMRS] __aligned(CMR_INFO_ARRAY_ALIGNMEN
 static int tdx_cmr_num;
 
 /* TDX module global KeyID.  Used in TDH.SYS.CONFIG ABI. */
-static u32 __read_mostly tdx_global_keyid;
-
-u32 tdx_get_global_keyid(void)
-{
-       return tdx_global_keyid;
-}
-EXPORT_SYMBOL_GPL(tdx_get_global_keyid);
+u32 tdx_global_keyid __ro_after_init;
+EXPORT_SYMBOL_GPL(tdx_global_keyid);
 
 u32 tdx_get_num_keyid(void)
 {

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

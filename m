Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6105E4D8BD2
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 19:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243889AbiCNSgO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 14:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235005AbiCNSgN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 14:36:13 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A91D3E0EC;
        Mon, 14 Mar 2022 11:35:02 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id mr24-20020a17090b239800b001bf0a375440so66614pjb.4;
        Mon, 14 Mar 2022 11:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CTRcPEvohEbkBJBhxX5YwvL7VuGghtI6YMapSuVpqPw=;
        b=VinnD8Jg80xGV8LsRbx1iP3bZvs5Lp7/9ZRAP6d+uSEnGALRihy8zJ6imCP2Mp+SRK
         L4JV7OvTOQ4otZb4TiUustePMczBp6npjPhP78X3nUSe0jEUgxzFNchItUF12gO8cEVj
         Axe8IIXctJxNsoS4tqZkpu4P4ZYB5pNXhFZkauLTWh9lK0gj8Cq14tx0StgFgr9NlFK/
         p6qdVQNHToE8pCNMWtDkvupqwGaVUacqEAUOKFBh5V3rwYy1w5KjryNHfMscq/QDVe0R
         y7rVeRUgIVpLHMyPr1NlVcusN5QdKza4TYVQNlkzsx9mnBHsOfRzxIeQMsjV0N8vDaMB
         qemw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CTRcPEvohEbkBJBhxX5YwvL7VuGghtI6YMapSuVpqPw=;
        b=oGHCPFVbqkiZHWKMjxwCLTCfZaeaG3EGVhfWfyngZ1A8yDhh4zaWm2ddfeeJC0wJ0u
         by5dlECfOY+ufm1P9/C3RQt2DrK0aBJ+pScJnCwNWtHFlHswzc3oVQht7JWTds2C/QKg
         bAggNu5IxAMHVWKeryc3Tw0YMkSm0pOD0jkTIs0KjOjKev3c1QDm5LIINqm0VVWLeZEj
         c+gcA/WxTRIvbpeCGDUrdU4hdaUI3LBWfnQC/m4Uwlfl6Ko1ybPteB0wobfMKdo3/nBr
         9IeRgJHnk3qa06/kqFW9wv0HBoDo93gJxcYhY64xHjUXvgjIve1sghdxbji0kYZ4vuPP
         CPNQ==
X-Gm-Message-State: AOAM531lYSRQ5Yk7pgQJ1ucVkgoR0kwvFs+3XoVBRuGoqIU2YFHZI9gT
        hLYuuFET7kPjCzlUEhDXEfM=
X-Google-Smtp-Source: ABdhPJyW/svzuPEWOvDa0F47iV9PZrTXIh1r1s6j8tYeJPmGZtur/2wnzNONneukysoVWcHEdcs0qw==
X-Received: by 2002:a17:902:b597:b0:151:e24e:a61e with SMTP id a23-20020a170902b59700b00151e24ea61emr24932081pls.66.1647282902015;
        Mon, 14 Mar 2022 11:35:02 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id u10-20020a63b54a000000b00380ea901cd2sm13747236pgo.6.2022.03.14.11.35.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 11:35:01 -0700 (PDT)
Date:   Mon, 14 Mar 2022 11:34:59 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v5 003/104] KVM: TDX: Detect CPU feature on kernel
 module initialization
Message-ID: <20220314183459.GB1964605@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <70201fd686c6cc6e03f5af8a9f59af67bdc81194.1646422845.git.isaku.yamahata@intel.com>
 <3443ca75-0b64-1b6b-1d1d-1cbca34d14cb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3443ca75-0b64-1b6b-1d1d-1cbca34d14cb@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks for comment.

On Sun, Mar 13, 2022 at 02:49:51PM +0100,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > +static int __init __tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> > +{
> > +	u32 max_pa;
> > +
> > +	if (!enable_ept) {
> > +		pr_warn("Cannot enable TDX with EPT disabled\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (!platform_has_tdx()) {
> > +		pr_warn("Cannot enable TDX with SEAMRR disabled\n");
> > +		return -ENODEV;
> > +	}
> 
> This will cause a pr_warn in the logs on all machines that don't have TDX.
> Perhaps you can restrict the pr_warn() to machines that have
> __seamrr_enabled() == true?

Makes sense. I'll include the following change.

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 73bb472bd515..aa02c98afd11 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -134,6 +134,7 @@ struct tdsysinfo_struct {
        };
 } __packed __aligned(TDSYSINFO_STRUCT_ALIGNMENT);
 
+bool __seamrr_enabled(void);
 void tdx_detect_cpu(struct cpuinfo_x86 *c);
 int tdx_detect(void);
 int tdx_init(void);
@@ -143,6 +144,7 @@ u32 tdx_get_global_keyid(void);
 int tdx_keyid_alloc(void);
 void tdx_keyid_free(int keyid);
 #else
+static inline bool __seamrr_enabled(void) { return false; }
 static inline void tdx_detect_cpu(struct cpuinfo_x86 *c) { }
 static inline int tdx_detect(void) { return -ENODEV; }
 static inline int tdx_init(void) { return -ENODEV; }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 66dffe815e63..880d8291b380 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2625,7 +2625,8 @@ static int __init __tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
        }
 
        if (!platform_has_tdx()) {
-               pr_warn("Cannot enable TDX with SEAMRR disabled\n");
+               if (__seamrr_enabled())
+                       pr_warn("Cannot enable TDX with SEAMRR disabled\n");
                return -ENODEV;
        }
 
diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
index d99961b7cb02..bb578a72b2da 100644
--- a/arch/x86/virt/vmx/tdx.c
+++ b/arch/x86/virt/vmx/tdx.c
@@ -186,10 +186,11 @@ static const struct kernel_param_ops tdx_trace_ops = {
 module_param_cb(tdx_trace_level, &tdx_trace_ops, &tdx_trace_level, 0644);
 MODULE_PARM_DESC(tdx_trace_level, "TDX module trace level");
 
-static bool __seamrr_enabled(void)
+bool __seamrr_enabled(void)
 {
        return (seamrr_mask & SEAMRR_ENABLED_BITS) == SEAMRR_ENABLED_BITS;
 }
+EXPORT_SYMBOL_GPL(__seamrr_enabled);
 
 static void detect_seam_bsp(struct cpuinfo_x86 *c)
 {


-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966B76A4D79
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 22:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjB0Vof (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 16:44:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjB0Voe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 16:44:34 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E2C31BEA;
        Mon, 27 Feb 2023 13:44:33 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id y11so4146491plg.1;
        Mon, 27 Feb 2023 13:44:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4VtSz33GLD+p4wg7UkhXlefbcaZorfOqxp+BAmjvi2I=;
        b=eznMLdl7x08xbfR9HeOaH5vd7sgLjZyGNJnDyThy8POD0lHphHHOqQmKU3fN5Tx0y6
         aKXKZbZFfgoK1NoGYG/WTimuvbTH7XMOJDPOuoLvKlSfnCEvspEyllKXLPqJf1aI1nK8
         eKWw/Twd/EHOKUk7C/sxcMnwb2B69ZtVuAbteRbR++0QiPzEtB0/7LyknjW3HZv6sUOO
         GWVYuhWHPgz+7gRu8h36ANS9+ECMllNi0cTJfEgBXuwQCFsen1c9w95JmjEokfo0Vx9g
         Tf5BdrIDIQQKQVEtfkJ0ZDq0MGb8dv7s43CMs8S/sIgkOFc19rN3xG/YT4M7fP1Do9CS
         eGIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4VtSz33GLD+p4wg7UkhXlefbcaZorfOqxp+BAmjvi2I=;
        b=Hw/zsUT7Ryvmaay881dJJxJmALfL5TLPisGojjpcDiEazb4VjVeWlQdGZDxw0znSDZ
         4bA9ld/RGIet+Ode9gaSFqKb0SJ2v0HOJuCxu0bzfo5Qh4RfsUPKBus3fEuhYdQJ/hR/
         BfbNhJGkrlTtDKmesFjGYuG+h1/vPQRZYhXrsBGqUnLDA2NpqukS8HB/BI0Xk0oQR8v2
         emFZHzo3uXHuYvq8amVSKh/g/QQ3YUF8B2gv9wCYYppUq1PLwPqwSZ6f6traJyH40N7G
         wbVY33t+ZvPkbWQbAIqzwpdoX7aMKXE9YKn96PfBNG5js2F+MCnv6XEvannW84oNloZB
         1riw==
X-Gm-Message-State: AO0yUKWnNZsVH1FDQD4TZYqN8CXadaLgZOwsRk7sZ7A2AvPnWF8p70sE
        +0jAe189WkkbOvBTnzkHM4w=
X-Google-Smtp-Source: AK7set9fq9IWmHSlmVYZR7ZATm0HxEFxnOMAYbaGiPN7wCAwJ4OaF+6WbBouZUcb9r5DaQLmfIld+w==
X-Received: by 2002:a05:6a20:69aa:b0:cb:af96:ace7 with SMTP id t42-20020a056a2069aa00b000cbaf96ace7mr914703pzk.46.1677534272699;
        Mon, 27 Feb 2023 13:44:32 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id x18-20020a62fb12000000b0058dbd7a5e0esm4627268pfm.89.2023.02.27.13.44.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 13:44:32 -0800 (PST)
Date:   Mon, 27 Feb 2023 13:44:30 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v11 019/113] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <20230227214430.GI4175971@ls.amr.corp.intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <a0b5c459cce27c83a1275a3108f810299635d217.1673539699.git.isaku.yamahata@intel.com>
 <0c59400e6a2420b669b22972633d7b1563ccbbfb.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0c59400e6a2420b669b22972633d7b1563ccbbfb.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 17, 2023 at 12:19:15PM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> > +/*
> > + * cpuid entry lookup in TDX cpuid config way.
> > + * The difference is how to specify index(subleaves).
> 
> AFAICT you only have one caller here.  If this is the only difference, will it
> be simpler to ask caller to simply convert TDX_CPUID_NO_SUBLEAF to 0, so this
> function can perhaps be removed?

I removed the function as it turned out only one caller needs it after revise.


> > +static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
> > +			struct kvm_tdx_init_vm *init_vm)
> > +{
> > +	const struct kvm_cpuid2 *cpuid = &init_vm->cpuid;
> > +	const struct kvm_cpuid_entry2 *entry;
> > +	u64 guest_supported_xcr0;
> > +	u64 guest_supported_xss;
> > +	int max_pa;
> > +	int i;
> > +
> > +	if (kvm->created_vcpus)
> > +		return -EBUSY;
> > +	td_params->max_vcpus = kvm->max_vcpus;
> > +	td_params->attributes = init_vm->attributes;
> > +	if (td_params->attributes & TDX_TD_ATTRIBUTE_PERFMON) {
> > +		/*
> > +		 * TODO: save/restore PMU related registers around TDENTER.
> > +		 * Once it's done, remove this guard.
> > +		 */
> > +		pr_warn("TD doesn't support perfmon yet. KVM needs to save/restore "
> > +			"host perf registers properly.\n");
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	for (i = 0; i < tdx_caps.nr_cpuid_configs; i++) {
> > +		const struct tdx_cpuid_config *config = &tdx_caps.cpuid_configs[i];
> > +		const struct kvm_cpuid_entry2 *entry =
> > +			tdx_find_cpuid_entry(cpuid, config->leaf, config->sub_leaf);
> > +		struct tdx_cpuid_value *value = &td_params->cpuid_values[i];
> > +
> > +		if (!entry)
> > +			continue;
> > +
> > +		value->eax = entry->eax & config->eax;
> > +		value->ebx = entry->ebx & config->ebx;
> > +		value->ecx = entry->ecx & config->ecx;
> > +		value->edx = entry->edx & config->edx;
> > +	}
> 
> A comment to explain above would be helpful, i.e TDX requires the number and the
> order of those entries in TD_PARAMS's cpuid_values[] must be in the same number
> and order with TDSYSINFO's CPUID_CONFIG.
> 
> Also, this code depends on @td_params already being zeroed.  Perhaps also point
> it out.

Ok, I'll add a comment.


> [snip]
> 
> > +static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
> > +{
> > 
> [snip]
> 
> > +
> > +	ret = setup_tdparams(kvm, td_params, init_vm);
> > +	if (ret)
> > +		goto out;
> > +
> > +	ret = __tdx_td_init(kvm, td_params);
> > +	if (ret)
> > +		goto out;
> > +
> > +	kvm_tdx->tsc_offset = td_tdcs_exec_read64(kvm_tdx, TD_TDCS_EXEC_TSC_OFFSET);
> > +	kvm_tdx->attributes = td_params->attributes;
> > +	kvm_tdx->xfam = td_params->xfam;
> > +
> > +out:
> > +	/* kfree() accepts NULL. */
> > +	kfree(init_vm);
> > +	kfree(td_params);
> 
> So looks KVM doesn't CPUID configurations that are passed to the TDX module.  
> 
> IIUC, KVM still depends on userspace to later use KVM_SET_CPUID2 to fill the
> _same_ CPUID entries for each vcpu?  If so, what if userspace didn't provide
> consistent CPUIDs in KVM_SET_CPUID2?  Should we verify in KVM_SET_CPUID2 that
> CPUIDs are consistent?

Yes. guest might be confused, but KVM is fine with it. I don't think check is
necessary.

Because already user space is required to configure consistent CPUIDs (and MSRs)
and KVM doesn't do such consistency check for it except minimum check for KVM to
work correctly. e.g. the highest leaf number. This patch doesn't make it worse.


> I am thinking if some #VE handling requires CPUID to make some decision, then
> inconsistent CPUIDs will cause trouble, but I don't have an example now.

Do you mean TDG.VP.VMCALL<CPUID>?  Because guest TD doesn't VMM, #VE handler in
guest should sanitize the result and should be robust against attack by 
returning broken value for TDG.VP.VMCALL<CPUID>.(or other TDG.VP.VMCALL)
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08F5721177
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 20:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjFCSCl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Jun 2023 14:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjFCSCk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Jun 2023 14:02:40 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2E4132;
        Sat,  3 Jun 2023 11:02:38 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id 46e09a7af769-6af6fe73f11so3121931a34.0;
        Sat, 03 Jun 2023 11:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685815358; x=1688407358;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wJ5oIK5c4aaP2KUP+GjmtcSjBZl4zYhr31Fidljy5Rc=;
        b=JkFGVhWUBwe466ud2BX0WtTfpJiJgJ5URvXEK0eaLNpdnMzibQ7NQJ0ZI0OAi897ai
         RthPhaGNuvTfEi72MDhpcH+PynEgZQq8740yI/SgrD9G6aLsyI91z2EXo1JfLFKiiSR4
         G62BFDQ6VCCLwaUArGcAXhqdA2WqmLa/M1wvu47JIfEllNK2FCNZuYsz/AI8+VS7YWRM
         aNoRbW0XsTNhHDmk8LajfxqpdQwtFKmNO9FvkLoQZoXNcgXgLM2mjAE+y+4ffVYjGNis
         1OCw9SP2C9IMFG3qnbb/p6hfpA7rFZNQZZ7ILn74Id3zEEN94FzXyaSD3i92gDw8UO0i
         Mupg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685815358; x=1688407358;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wJ5oIK5c4aaP2KUP+GjmtcSjBZl4zYhr31Fidljy5Rc=;
        b=LKiLDUuxfKoI5Y6L62BI+G2VmhizwGbfTzhYig8ZnqVZqY7QDYTPW9xo1607eQZPPS
         gzxWrAzIhUGRfKbtqou23NZ6lzq/WomCWNY61hpDiuIYyZ1FsRxmZE0AEJnldQG0lg7r
         LMS1nSKJzDoWOf+jyNqMvXOE7KNhqc0AvTFkFZ8/tfEQiArVUvozr0Q/PdrT+UnMZIYl
         s7jKDWzzSqENDPkjZ7pM0f+5LHoZlagMlteCqLrA0WgE0UpFG8PdX6HnrmmbyiuhIooM
         vyZKtNthfeOnAWq7XB1sfH5ujOVzbTcOjmO4vTsoeYVOn9geNMRZzK+DZApJOgL+kDQc
         C8CQ==
X-Gm-Message-State: AC+VfDyUuxSxdlq2feEF2zZpd86B4IMbmLCgP8MnXFbps68C9rlcDGjV
        0qlVLT4CkrDv0clZJUua91g=
X-Google-Smtp-Source: ACHHUZ4DM50zmbAnSQ9adX7zFLIZ8c2b8VEJWlwpNSDS2hSiZtMykWUZHm0cB2o5Bu/+Oy+sSNuUDA==
X-Received: by 2002:a05:6358:2496:b0:127:9133:fb90 with SMTP id m22-20020a056358249600b001279133fb90mr16248765rwc.16.1685815357843;
        Sat, 03 Jun 2023 11:02:37 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id mv7-20020a17090b198700b0024dfb8271a4sm3135597pjb.21.2023.06.03.11.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jun 2023 11:02:37 -0700 (PDT)
Date:   Sat, 3 Jun 2023 11:02:35 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>, chen.bo@intel.com
Subject: Re: [PATCH v14 111/113] RFC: KVM: x86, TDX: Add check for setting
 CPUID
Message-ID: <20230603180235.GM1234772@ls.amr.corp.intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
 <00f3770050fb0751273a48eb17804a7a1a697e75.1685333728.git.isaku.yamahata@intel.com>
 <20230603092933.00004ada.zhi.wang.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230603092933.00004ada.zhi.wang.linux@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 03, 2023 at 09:29:33AM +0800,
Zhi Wang <zhi.wang.linux@gmail.com> wrote:

> On Sun, 28 May 2023 21:20:33 -0700
> isaku.yamahata@intel.com wrote:
> 
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Add a hook to setting CPUID for additional consistency check of
> > KVM_SET_CPUID2.
> > 
> > Because intel TDX or AMD SNP has restriction on the value of cpuid.  Some
> > value can't be changed after boot.  Some can be only set at the VM
> > creation time and can't be changed later.  Check if the new values are
> > consistent with the old values.
> >
> 
> Thanks for addressing this from the discussion. The structure looks good to me.
> I was thinking if the patch should be separated into two parts. One is the
> common part so that AMD folks can include it in their patch series. Another one
> is TDX callback which builds on top of the common-part patch. 

OK.

> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Link: https://lore.kernel.org/lkml/ZDiGpCkXOcCm074O@google.com/
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/include/asm/kvm-x86-ops.h |  1 +
> >  arch/x86/include/asm/kvm_host.h    |  1 +
> >  arch/x86/kvm/cpuid.c               | 10 ++++++
> >  arch/x86/kvm/cpuid.h               |  2 ++
> >  arch/x86/kvm/vmx/main.c            | 10 ++++++
> >  arch/x86/kvm/vmx/tdx.c             | 57 ++++++++++++++++++++++++++++--
> >  arch/x86/kvm/vmx/tdx.h             |  7 ++++
> >  arch/x86/kvm/vmx/x86_ops.h         |  4 +++
> >  8 files changed, 90 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > index c1a4d29cf4fa..5faa13a31f59 100644
> > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > @@ -20,6 +20,7 @@ KVM_X86_OP(hardware_disable)
> >  KVM_X86_OP(hardware_unsetup)
> >  KVM_X86_OP_OPTIONAL_RET0(offline_cpu)
> >  KVM_X86_OP(has_emulated_msr)
> > +KVM_X86_OP_OPTIONAL_RET0(vcpu_check_cpuid)
> >  KVM_X86_OP(vcpu_after_set_cpuid)
> >  KVM_X86_OP(is_vm_type_supported)
> >  KVM_X86_OP_OPTIONAL(max_vcpus);
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 68ddb0da31e0..4efd9770963c 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1588,6 +1588,7 @@ struct kvm_x86_ops {
> >  	void (*hardware_unsetup)(void);
> >  	int (*offline_cpu)(void);
> >  	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
> > +	int (*vcpu_check_cpuid)(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2, int nent);
> >  	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
> >  
> >  	bool (*is_vm_type_supported)(unsigned long vm_type);
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 0142a73034c4..ef7c361883d7 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -414,6 +414,9 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
> >  	}
> >  
> >  	r = kvm_check_cpuid(vcpu, e2, nent);
> > +	if (r)
> > +		return r;
> > +	r = static_call(kvm_x86_vcpu_check_cpuid)(vcpu, e2, nent);
> >  	if (r)
> >  		return r;
> 
> It would be nice to move the static_call into the kvm_check_cpuid() as it is
> part of the process of checking cpuid. It is good enough for now as
> kvm_check_cpuid() only has one caller. Think if more caller of
> kvm_check_cpuid() shows up in the future, they need to move it into
> kvm_check_cpuid anyway.
> 
> >  
> > @@ -1364,6 +1367,13 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
> >  	return r;
> >  }
> >  
> > +struct kvm_cpuid_entry2 *__kvm_find_cpuid_entry2(
> > +	struct kvm_cpuid_entry2 *entries, int nent, u32 function, u64 index)
> > +{
> > +	return cpuid_entry2_find(entries, nent, function, index);
> > +}
> > +EXPORT_SYMBOL_GPL(__kvm_find_cpuid_entry2);
> > +
> 
> If evetually, we have to open kvm_cpuid2 when searching the cpuid entries,
> I would suggest to open it in kvm_find_cpuid_entry2() instead of introducing
> a new __kvm_find_cpuid_entry2(). It would be nice to let kvm_find_cpuid_entry2
> () to take entreis and nent in the previou patch.

Makes sense. Consolidated kvm_find_cpuid_entry2(
struct kvm_cpuid_entry2 *entries, int nent, u32 function, u64 index).

> >  struct kvm_cpuid_entry2 *kvm_find_cpuid_entry2( struct kvm_cpuid2 *cpuid,
> >  						u32 function, u32 index)
> >  {

... snip...

> > +int tdx_vcpu_check_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2, int nent)
> > +{
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> > +	const struct tdsysinfo_struct *tdsysinfo;
> > +	int i;
> > +
> > +	tdsysinfo = tdx_get_sysinfo();
> > +	if (!tdsysinfo)
> > +		return -ENOTSUPP;
> > +
> > +	/*
> > +	 * Simple check that new cpuid is consistent with created one.
> > +	 * For simplicity, only trivial check.  Don't try comprehensive checks
> > +	 * with the cpuid virtualization table in the TDX module spec.
> > +	 */
> > +	for (i = 0; i < tdsysinfo->num_cpuid_config; i++) {
> > +		const struct tdx_cpuid_config *config = &tdsysinfo->cpuid_configs[i];
> > +		u32 index = config->sub_leaf == TDX_CPUID_NO_SUBLEAF ? 0: config->sub_leaf;
> > +		const struct kvm_cpuid_entry2 *old =
> > +			__kvm_find_cpuid_entry2(kvm_tdx->cpuid, kvm_tdx->cpuid_nent,
> > +						config->leaf, index);
> > +		const struct kvm_cpuid_entry2 *new =
> > +			__kvm_find_cpuid_entry2(e2, nent, config->leaf, index);
> > +
> > +		if (!!old != !!new)
> > +			return -EINVAL;
> > +		if (!old && !new)
> > +			continue;
> > +
> > +		if ((old->eax ^ new->eax) & config->eax ||
> > +		    (old->ebx ^ new->ebx) & config->ebx ||
> > +		    (old->ecx ^ new->ecx) & config->ecx ||
> > +		    (old->edx ^ new->edx) & config->edx)
> > +			return -EINVAL;
> > +	}
> > +	return 0;
> > +}
> 
> Guess checkpatch.pl will complain about the length of lines above.

By default, the line is 100 chars. Not 80.


> > +
> >  void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >  {
> >  	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > @@ -2003,10 +2044,12 @@ static void setup_tdparams_eptp_controls(struct kvm_cpuid2 *cpuid, struct td_par
> >  	}
> >  }
> >  
> > -static void setup_tdparams_cpuids(const struct tdsysinfo_struct *tdsysinfo,
> > +static void setup_tdparams_cpuids(struct kvm *kvm,
> > +				  const struct tdsysinfo_struct *tdsysinfo,
> >  				  struct kvm_cpuid2 *cpuid,
> >  				  struct td_params *td_params)
> >  {
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> >  	int i;
> >  
> >  	/*
> > @@ -2014,6 +2057,7 @@ static void setup_tdparams_cpuids(const struct tdsysinfo_struct *tdsysinfo,
> >  	 * be same to the one of struct tdsysinfo.{num_cpuid_config, cpuid_configs}
> >  	 * It's assumed that td_params was zeroed.
> >  	 */
> > +	kvm_tdx->cpuid_nent = 0;
> >  	for (i = 0; i < tdsysinfo->num_cpuid_config; i++) {
> >  		const struct tdx_cpuid_config *config = &tdsysinfo->cpuid_configs[i];
> >  		/* TDX_CPUID_NO_SUBLEAF in TDX CPUID_CONFIG means index = 0. */
> > @@ -2035,6 +2079,10 @@ static void setup_tdparams_cpuids(const struct tdsysinfo_struct *tdsysinfo,
> >  		value->ebx = entry->ebx & config->ebx;
> >  		value->ecx = entry->ecx & config->ecx;
> >  		value->edx = entry->edx & config->edx;
> > +
> > +		/* Remember the setting to check for KVM_SET_CPUID2. */
> > +		kvm_tdx->cpuid[kvm_tdx->cpuid_nent] = *entry;
> > +		kvm_tdx->cpuid_nent++;
> >  	}
> >  }
> >  
> > @@ -2130,7 +2178,7 @@ static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
> >  	td_params->tsc_frequency = TDX_TSC_KHZ_TO_25MHZ(kvm->arch.default_tsc_khz);
> >  
> >  	setup_tdparams_eptp_controls(cpuid, td_params);
> > -	setup_tdparams_cpuids(tdsysinfo, cpuid, td_params);
> > +	setup_tdparams_cpuids(kvm, tdsysinfo, cpuid, td_params);
> >  	ret = setup_tdparams_xfam(cpuid, td_params);
> >  	if (ret)
> >  		return ret;
> > @@ -2332,6 +2380,11 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
> >  	if (cmd->flags)
> >  		return -EINVAL;
> >  
> > +	kvm_tdx->cpuid = kzalloc(sizeof(init_vm->cpuid.entries[0]) * KVM_MAX_CPUID_ENTRIES,
> > +				 GFP_KERNEL);
> > +	if (!kvm_tdx->cpuid)
> > +		return -ENOMEM;
> > +
> >  	init_vm = kzalloc(sizeof(*init_vm) +
> >  			  sizeof(init_vm->cpuid.entries[0]) * KVM_MAX_CPUID_ENTRIES,
> >  			  GFP_KERNEL);
> 
> kfree(kvm_tdx->cpuid) is required in the error handling path of tdx_td_init().


No need. tdx_vm_free() frees it. Not here.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

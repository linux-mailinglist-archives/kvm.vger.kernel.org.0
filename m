Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E61721BEF
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 04:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbjFECZd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Jun 2023 22:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbjFECZa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Jun 2023 22:25:30 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1734FB8;
        Sun,  4 Jun 2023 19:25:28 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-510f866ce78so614186a12.1;
        Sun, 04 Jun 2023 19:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685931926; x=1688523926;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8b70CMXREposPfoBek1W0N6i6fjVO/Q0XjgaYplHbrs=;
        b=eQJSVitjO9YNftX5/JnH3M4xg+uLbq5Iv7XSUCmZ5rDfkW6ubzIK/bejBoMFXSIRH5
         Nu7L3iO9/XFMhG7849IiJn0+y1Xf8p2uLAMbB0lR2APEigbghfZKTewvtAnATWFs8A30
         40UPrHv85/7GA5ppcrQYDy8ydslm29O/brqbe1aLADNBmCpj2TqMXN7aIG+f/VkpFjRw
         C5Zc8fAn4D+5qoGEidjbMTRyoBgGJREgUOEkdtv9IN21ur59PnYorS5/BgydvbXnkSVW
         27NY3rTWcjeWDd/qCQtVTkrsl6hEnSGwFOxoTYmEAuuZWuGsUPnMIKUwXtF7RJ48XOKR
         zuzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685931926; x=1688523926;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8b70CMXREposPfoBek1W0N6i6fjVO/Q0XjgaYplHbrs=;
        b=RWKWf8DPjndfh7+I9HoCNDTxNRC1n6GF8p4zZ5F81dfi0+bYWaAVrzjncqB/jhnuIs
         lK2qdzYn86j3kpebOF67bkFAmDPnlYGuTid6RkAP9UnSvwnuz/cjXjhQ+aBOtwmZPaVg
         Xu7B7oXISPrOR6SOmB+WX0j+kNCBlS3BlHn3q/W+LrpZUNqhV5tqk4TfCNKE8BT6m8T4
         evZw+UegFLO5b00ML45a05z/HhojBoKhwCOglM6B22YGn5lI5pqWkIovv5BEA3+uGXDo
         XExHylq3wmbEWmFAbCuXoN3S3fW1kADQwbM28CYSU7+wR6Q/5+OaQry1q27fLCN/RphU
         IBvg==
X-Gm-Message-State: AC+VfDy4DHjoFTsoAbW8lepYTv7cthX6tfJNgybkvznvLLkNdkv3i6Uc
        8OZlFJgTah9u2VjL6TuTDxS91DSw2cSi5kx8
X-Google-Smtp-Source: ACHHUZ5f2mAXyPoOisG/zwi/jyi+KuOXlTIuOB2ZGzORlJHZH04OFhVKRLHEcNQzFeH31M9ovMQ7Jg==
X-Received: by 2002:a05:6402:84c:b0:506:c24e:667d with SMTP id b12-20020a056402084c00b00506c24e667dmr14603628edz.4.1685931926316;
        Sun, 04 Jun 2023 19:25:26 -0700 (PDT)
Received: from localhost ([134.191.220.83])
        by smtp.gmail.com with ESMTPSA id z8-20020a50eb48000000b00510da8aa2c6sm3381313edp.69.2023.06.04.19.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 19:25:25 -0700 (PDT)
Date:   Mon, 5 Jun 2023 10:25:11 +0800
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>, chen.bo@intel.com
Subject: Re: [PATCH v14 111/113] RFC: KVM: x86, TDX: Add check for setting
 CPUID
Message-ID: <20230605095129.00001b49.zhi.wang.linux@gmail.com>
In-Reply-To: <20230603180235.GM1234772@ls.amr.corp.intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
 <00f3770050fb0751273a48eb17804a7a1a697e75.1685333728.git.isaku.yamahata@intel.com>
 <20230603092933.00004ada.zhi.wang.linux@gmail.com>
 <20230603180235.GM1234772@ls.amr.corp.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 3 Jun 2023 11:02:35 -0700
Isaku Yamahata <isaku.yamahata@gmail.com> wrote:

> On Sat, Jun 03, 2023 at 09:29:33AM +0800,
> Zhi Wang <zhi.wang.linux@gmail.com> wrote:
>=20
> > On Sun, 28 May 2023 21:20:33 -0700
> > isaku.yamahata@intel.com wrote:
> >=20
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > >=20
> > > Add a hook to setting CPUID for additional consistency check of
> > > KVM_SET_CPUID2.
> > >=20
> > > Because intel TDX or AMD SNP has restriction on the value of cpuid.  =
Some
> > > value can't be changed after boot.  Some can be only set at the VM
> > > creation time and can't be changed later.  Check if the new values are
> > > consistent with the old values.
> > >
> >=20
> > Thanks for addressing this from the discussion. The structure looks goo=
d to me.
> > I was thinking if the patch should be separated into two parts. One is =
the
> > common part so that AMD folks can include it in their patch series. Ano=
ther one
> > is TDX callback which builds on top of the common-part patch.=20
>=20
> OK.
>=20
> > > Suggested-by: Sean Christopherson <seanjc@google.com>
> > > Link: https://lore.kernel.org/lkml/ZDiGpCkXOcCm074O@google.com/
> > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > ---
> > >  arch/x86/include/asm/kvm-x86-ops.h |  1 +
> > >  arch/x86/include/asm/kvm_host.h    |  1 +
> > >  arch/x86/kvm/cpuid.c               | 10 ++++++
> > >  arch/x86/kvm/cpuid.h               |  2 ++
> > >  arch/x86/kvm/vmx/main.c            | 10 ++++++
> > >  arch/x86/kvm/vmx/tdx.c             | 57 ++++++++++++++++++++++++++++=
--
> > >  arch/x86/kvm/vmx/tdx.h             |  7 ++++
> > >  arch/x86/kvm/vmx/x86_ops.h         |  4 +++
> > >  8 files changed, 90 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/as=
m/kvm-x86-ops.h
> > > index c1a4d29cf4fa..5faa13a31f59 100644
> > > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > > @@ -20,6 +20,7 @@ KVM_X86_OP(hardware_disable)
> > >  KVM_X86_OP(hardware_unsetup)
> > >  KVM_X86_OP_OPTIONAL_RET0(offline_cpu)
> > >  KVM_X86_OP(has_emulated_msr)
> > > +KVM_X86_OP_OPTIONAL_RET0(vcpu_check_cpuid)
> > >  KVM_X86_OP(vcpu_after_set_cpuid)
> > >  KVM_X86_OP(is_vm_type_supported)
> > >  KVM_X86_OP_OPTIONAL(max_vcpus);
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/k=
vm_host.h
> > > index 68ddb0da31e0..4efd9770963c 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1588,6 +1588,7 @@ struct kvm_x86_ops {
> > >  	void (*hardware_unsetup)(void);
> > >  	int (*offline_cpu)(void);
> > >  	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
> > > +	int (*vcpu_check_cpuid)(struct kvm_vcpu *vcpu, struct kvm_cpuid_ent=
ry2 *e2, int nent);
> > >  	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
> > > =20
> > >  	bool (*is_vm_type_supported)(unsigned long vm_type);
> > > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > > index 0142a73034c4..ef7c361883d7 100644
> > > --- a/arch/x86/kvm/cpuid.c
> > > +++ b/arch/x86/kvm/cpuid.c
> > > @@ -414,6 +414,9 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, s=
truct kvm_cpuid_entry2 *e2,
> > >  	}
> > > =20
> > >  	r =3D kvm_check_cpuid(vcpu, e2, nent);
> > > +	if (r)
> > > +		return r;
> > > +	r =3D static_call(kvm_x86_vcpu_check_cpuid)(vcpu, e2, nent);
> > >  	if (r)
> > >  		return r;
> >=20
> > It would be nice to move the static_call into the kvm_check_cpuid() as =
it is
> > part of the process of checking cpuid. It is good enough for now as
> > kvm_check_cpuid() only has one caller. Think if more caller of
> > kvm_check_cpuid() shows up in the future, they need to move it into
> > kvm_check_cpuid anyway.
> >=20
> > > =20
> > > @@ -1364,6 +1367,13 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 =
*cpuid,
> > >  	return r;
> > >  }
> > > =20
> > > +struct kvm_cpuid_entry2 *__kvm_find_cpuid_entry2(
> > > +	struct kvm_cpuid_entry2 *entries, int nent, u32 function, u64 index)
> > > +{
> > > +	return cpuid_entry2_find(entries, nent, function, index);
> > > +}
> > > +EXPORT_SYMBOL_GPL(__kvm_find_cpuid_entry2);
> > > +
> >=20
> > If evetually, we have to open kvm_cpuid2 when searching the cpuid entri=
es,
> > I would suggest to open it in kvm_find_cpuid_entry2() instead of introd=
ucing
> > a new __kvm_find_cpuid_entry2(). It would be nice to let kvm_find_cpuid=
_entry2
> > () to take entreis and nent in the previou patch.
>=20
> Makes sense. Consolidated kvm_find_cpuid_entry2(
> struct kvm_cpuid_entry2 *entries, int nent, u32 function, u64 index).
>=20
> > >  struct kvm_cpuid_entry2 *kvm_find_cpuid_entry2( struct kvm_cpuid2 *c=
puid,
> > >  						u32 function, u32 index)
> > >  {
>=20
> ... snip...
>=20
> > > +int tdx_vcpu_check_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_ent=
ry2 *e2, int nent)
> > > +{
> > > +	struct kvm_tdx *kvm_tdx =3D to_kvm_tdx(vcpu->kvm);
> > > +	const struct tdsysinfo_struct *tdsysinfo;
> > > +	int i;
> > > +
> > > +	tdsysinfo =3D tdx_get_sysinfo();
> > > +	if (!tdsysinfo)
> > > +		return -ENOTSUPP;
> > > +
> > > +	/*
> > > +	 * Simple check that new cpuid is consistent with created one.
> > > +	 * For simplicity, only trivial check.  Don't try comprehensive che=
cks
> > > +	 * with the cpuid virtualization table in the TDX module spec.
> > > +	 */
> > > +	for (i =3D 0; i < tdsysinfo->num_cpuid_config; i++) {
> > > +		const struct tdx_cpuid_config *config =3D &tdsysinfo->cpuid_config=
s[i];
> > > +		u32 index =3D config->sub_leaf =3D=3D TDX_CPUID_NO_SUBLEAF ? 0: co=
nfig->sub_leaf;
> > > +		const struct kvm_cpuid_entry2 *old =3D
> > > +			__kvm_find_cpuid_entry2(kvm_tdx->cpuid, kvm_tdx->cpuid_nent,
> > > +						config->leaf, index);
> > > +		const struct kvm_cpuid_entry2 *new =3D
> > > +			__kvm_find_cpuid_entry2(e2, nent, config->leaf, index);
> > > +
> > > +		if (!!old !=3D !!new)
> > > +			return -EINVAL;
> > > +		if (!old && !new)
> > > +			continue;
> > > +
> > > +		if ((old->eax ^ new->eax) & config->eax ||
> > > +		    (old->ebx ^ new->ebx) & config->ebx ||
> > > +		    (old->ecx ^ new->ecx) & config->ecx ||
> > > +		    (old->edx ^ new->edx) & config->edx)
> > > +			return -EINVAL;
> > > +	}
> > > +	return 0;
> > > +}
> >=20
> > Guess checkpatch.pl will complain about the length of lines above.
>=20
> By default, the line is 100 chars. Not 80.
>

The reason I raised this up is because: It seems there are two different ru=
les
going on in this patch. One seems respecting the 80-columns limitation. E.g.

struct kvm_cpuid_entry2 *kvm_find_cpuid_entry2( struct kvm_cpuid2 *cpuid,
  						u32 function, u32 index)

While this one respects a 100-columns rule different than others.

int tdx_vcpu_check_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2=
, int nent)

Note that 80-columns rules are still in the kernel coding style guide[1].=20

It would be better to follow it.

[1] https://docs.kernel.org/process/coding-style.html

>=20
> > > +
> > >  void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> > >  {
> > >  	struct vcpu_tdx *tdx =3D to_tdx(vcpu);
> > > @@ -2003,10 +2044,12 @@ static void setup_tdparams_eptp_controls(stru=
ct kvm_cpuid2 *cpuid, struct td_par
> > >  	}
> > >  }
> > > =20
> > > -static void setup_tdparams_cpuids(const struct tdsysinfo_struct *tds=
ysinfo,
> > > +static void setup_tdparams_cpuids(struct kvm *kvm,
> > > +				  const struct tdsysinfo_struct *tdsysinfo,
> > >  				  struct kvm_cpuid2 *cpuid,
> > >  				  struct td_params *td_params)
> > >  {
> > > +	struct kvm_tdx *kvm_tdx =3D to_kvm_tdx(kvm);
> > >  	int i;
> > > =20
> > >  	/*
> > > @@ -2014,6 +2057,7 @@ static void setup_tdparams_cpuids(const struct =
tdsysinfo_struct *tdsysinfo,
> > >  	 * be same to the one of struct tdsysinfo.{num_cpuid_config, cpuid_=
configs}
> > >  	 * It's assumed that td_params was zeroed.
> > >  	 */
> > > +	kvm_tdx->cpuid_nent =3D 0;
> > >  	for (i =3D 0; i < tdsysinfo->num_cpuid_config; i++) {
> > >  		const struct tdx_cpuid_config *config =3D &tdsysinfo->cpuid_config=
s[i];
> > >  		/* TDX_CPUID_NO_SUBLEAF in TDX CPUID_CONFIG means index =3D 0. */
> > > @@ -2035,6 +2079,10 @@ static void setup_tdparams_cpuids(const struct=
 tdsysinfo_struct *tdsysinfo,
> > >  		value->ebx =3D entry->ebx & config->ebx;
> > >  		value->ecx =3D entry->ecx & config->ecx;
> > >  		value->edx =3D entry->edx & config->edx;
> > > +
> > > +		/* Remember the setting to check for KVM_SET_CPUID2. */
> > > +		kvm_tdx->cpuid[kvm_tdx->cpuid_nent] =3D *entry;
> > > +		kvm_tdx->cpuid_nent++;
> > >  	}
> > >  }
> > > =20
> > > @@ -2130,7 +2178,7 @@ static int setup_tdparams(struct kvm *kvm, stru=
ct td_params *td_params,
> > >  	td_params->tsc_frequency =3D TDX_TSC_KHZ_TO_25MHZ(kvm->arch.default=
_tsc_khz);
> > > =20
> > >  	setup_tdparams_eptp_controls(cpuid, td_params);
> > > -	setup_tdparams_cpuids(tdsysinfo, cpuid, td_params);
> > > +	setup_tdparams_cpuids(kvm, tdsysinfo, cpuid, td_params);
> > >  	ret =3D setup_tdparams_xfam(cpuid, td_params);
> > >  	if (ret)
> > >  		return ret;
> > > @@ -2332,6 +2380,11 @@ static int tdx_td_init(struct kvm *kvm, struct=
 kvm_tdx_cmd *cmd)
> > >  	if (cmd->flags)
> > >  		return -EINVAL;
> > > =20
> > > +	kvm_tdx->cpuid =3D kzalloc(sizeof(init_vm->cpuid.entries[0]) * KVM_=
MAX_CPUID_ENTRIES,
> > > +				 GFP_KERNEL);
> > > +	if (!kvm_tdx->cpuid)
> > > +		return -ENOMEM;
> > > +
> > >  	init_vm =3D kzalloc(sizeof(*init_vm) +
> > >  			  sizeof(init_vm->cpuid.entries[0]) * KVM_MAX_CPUID_ENTRIES,
> > >  			  GFP_KERNEL);
> >=20
> > kfree(kvm_tdx->cpuid) is required in the error handling path of tdx_td_=
init().
>=20
>=20
> No need. tdx_vm_free() frees it. Not here.

=46rom a perspective of correctness, Yes. But there seems different kinds of
strategies of function error handling path going on in this patch series.
Taking __tdx_td_init() as an example, tdx_vm_free() is immediately called
in its error handling path. But, the error handling below the allocation
of cpuid will be deferred to the late VM teardown path in this patch. I am
confused of the strategy of common error handling path, what is the
preferred error handling strategy? Deferring or immediate handling?

Second, it is not graceful to defer the error handling to the teardown
path all the time even they seem work: 1) Readability. It looks like a
problematic error handling at a first glance. 2) Error handling path and
teardown path are for different purposes. Separating the concerns brings
clearer code organization and better maintainability. 3) Testability,
thinking about an error injection test for tdx_td_init(). Un-freed
kvm_tdx->cpuid will look like a memory leaking in this case and needs to
be noted as "free is in another function". It just makes the case more
complicated.

Third, I believe a static code scanner will complain about it.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C249573BF2F
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 22:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbjFWUEI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 16:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbjFWUEH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 16:04:07 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B896A271F
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 13:04:05 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-54ff7ab1e4dso803203a12.3
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 13:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687550645; x=1690142645;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EAV+u9FZn1OMDdsvLpiA8ptQ0UAVCWOU9+eOHemeZkc=;
        b=r2KqjKqvT/xeedE+Uetlyqb6JDv1xiVsWPQjpWxl++J6+bumEq73qW8Ny/MMnElmJ6
         O9O2t+XH/Ria9AnJC9poUqbrQIzuL18YDpLLO+HlnCySj9MFXVrVxzR/qRL9WemW0s8K
         3U/BXFOQch6jmpkQTR/rGoDpfz23FrESAr+lNHWLawIGMzx2fTTjcz1KpK0kxOX0sHxx
         PHZ14EwZSL9+kcmBhAgmfFWsCBqxCFGX8Kqp3FXP6iK6FOy934HbUBIYW/mYPki2JK4x
         3ykr0QYQA2hg1zzqTT7R+u+3plk5LWLv04e+GFSDnf/W5oXUa/ZF4xbNxQ1crQCdeyfB
         MhKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687550645; x=1690142645;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EAV+u9FZn1OMDdsvLpiA8ptQ0UAVCWOU9+eOHemeZkc=;
        b=HClAf9vyP+RlcHI0NmTyRuTA2gnfKN9hG9G0iBeNIziMSrCZ2o71HtmniXHqQrfD/4
         gR5LLO6R9/YN8e0K6l0afY36qR8M3Jmia1ngyVaudlxVArbCZs/pZry1B+4RoL8YiitC
         zOVC/6LfkA5SlhzgCMjNkm3idy7gH/uKqTsWNwwQpKnR70IEjhzzCeDf9xICh30cCyk7
         i3OiiG7+8wVsL6ziOoj+nERD9hcPcnepQ4KbUBg6+SsPu/anQ8MF0yDNefEesHgCCx2F
         Us+RdqJKacBrIQTahqOznyKwB/3Eq5xwmDht0bYvwUq3Efahzcm556gNKQJEvPw12aJg
         LpIA==
X-Gm-Message-State: AC+VfDytIPq0//EO8yhBeg9sRLN1xd6/lKb6fQQ5N7Q9xFFQijeDS3fS
        V++vvoIcK1IxzhdB1Lq+o0EMA+Yejq0=
X-Google-Smtp-Source: ACHHUZ6zM7Tgx4TGI3IPNASvkUDDWcbHxCnEXQz8Gh0NAaLENOYDQwmMhjGIuX7u07qjeoQlIIvfGSAVCwQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:1c12:0:b0:53f:6f7c:554e with SMTP id
 c18-20020a631c12000000b0053f6f7c554emr2532033pgc.12.1687550645192; Fri, 23
 Jun 2023 13:04:05 -0700 (PDT)
Date:   Fri, 23 Jun 2023 13:04:03 -0700
In-Reply-To: <a3a19de92c7ac6e607ac3e663d84a4312876084b.1687474039.git.isaku.yamahata@intel.com>
Mime-Version: 1.0
References: <cover.1687474039.git.isaku.yamahata@intel.com> <a3a19de92c7ac6e607ac3e663d84a4312876084b.1687474039.git.isaku.yamahata@intel.com>
Message-ID: <ZJX6s2HxbHOUMXlj@google.com>
Subject: Re: [RFC PATCH v2 4/6] KVM: x86: Introduce fault type to indicate kvm
 page fault is private
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 22, 2023, isaku.yamahata@intel.com wrote:
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_inter=
nal.h
> index 7f9ec1e5b136..0ec0b927a391 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -188,6 +188,13 @@ static inline bool is_nx_huge_page_enabled(struct kv=
m *kvm)
>  	return READ_ONCE(nx_huge_pages) && !kvm->arch.disable_nx_huge_pages;
>  }
> =20
> +enum kvm_fault_type {
> +	KVM_FAULT_MEM_ATTR,
> +	KVM_FAULT_SHARED,
> +	KVM_FAULT_SHARED_ALWAYS,
> +	KVM_FAULT_PRIVATE,

This is silly.  Just use AMD's error code bit, i.e. PFERR_GUEST_ENC_MASK as=
 per
the SNP series.

  Bit 34 (ENC): Set to 1 if the guest=E2=80=99s effective C-bit was 1, 0 ot=
herwise.

Just because Intel's ucode is too crusty to support error codes larger than=
 16
bits doesn't mean KVM can't utilize the bits :-)  KVM already translates to=
 AMD's
error codes for other things, e.g.

	error_code |=3D (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) !=3D 0=
 ?
	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;

For TDX, handle_ept_violation() can do something like:

	if (is_tdx(vcpu->kvm))
		error_code |=3D (gpa & shared) ? 0 : PFERR_GUEST_ENC_MASK;
	else if (kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(gpa)))
		error_code |=3D PFERR_GUEST_ENC_MASK;

And that's not even taking into account that TDX might have a separate entr=
y point,
i.e. the "is_tdx()" check can probably be avoided.

As for optimizing kvm_mem_is_private() to avoid unnecessary xarray lookups,=
 that
can and should be done separately, e.g.

  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
  {
	return IS_ENABLED(CONFIG_KVM_PRIVATE_MEM) &&
	       kvm_guest_has_private_mem(kvm) &&
	       kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
  }

where x86's implementation of kvm_guest_has_private_mem() can be

  #define kvm_guest_has_private_mem(kvm) (!!(kvm)->vm_type)

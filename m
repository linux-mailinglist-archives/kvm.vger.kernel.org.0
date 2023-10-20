Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0CA7D05DD
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 02:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346790AbjJTAiR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 20:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235578AbjJTAiR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 20:38:17 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA97C0
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 17:38:14 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-6b2018a11e2so291642b3a.2
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 17:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697762294; x=1698367094; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H40udxrnn6fdY9pib9PfDMy1TSaBomffUjfkk2BSewI=;
        b=uCkYPNl3tvavX87RL4G0bB5+gAcFj9MtCSa/4E50M+RmSxxDvlzuvn5GQgd7Ai1tfh
         olkBliyoBcguL9K3jiTy4D2iqi+hTyoDdV0TRfkOWju/HM31p9/eDQ+x8y8pCFv0ZevS
         TQPbm5v1KZuxeu5y5Nd+58oHbFDP3Q7pHJeNGZZRpfKEy4a6GobeuXm9F9ZU6775QiQD
         4//A+KJo8TvRdo/QR/BJawvRKOEnCsWKsBGKoJR11KFOmDn3e/bChcwUawIfGIxEoJ0o
         ljeKsbFOYyiVpWXiobNuOgt7C741Mwi2mx/FjUqoWNTK0f8+5vT9NtUJmC2P9s7JD09N
         Pa1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697762294; x=1698367094;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H40udxrnn6fdY9pib9PfDMy1TSaBomffUjfkk2BSewI=;
        b=J6tWTDadErX82klYkCjcxQCA5qJhvmB+iMLDEEXm0ZuXaNpxP80zKcx4jPUZlTY0W+
         O4V1KbC4rv7G62Pr4ccVEMOKQOckKmfrvThlnW75D0UKS3IDuwNLJjeY/nah1YHjkKgQ
         zDcCGjveQkZZmwyJeI1+AZRuEOkUdfqZ0WVcKlg5n5XHC+amyLXs1yKBs+9k5LFlGeNl
         J1vziT01fB2aSNnzewWkgLYLPDaM3/2erVmgbBCKzy5W3XyYLVFsuYYMfZ8j9yUICQFr
         M6c6xB+yn9aMY6CgHW9oHrmd6CYfaJNztA7tPb5CO9bh1U2Bm9BCoawe0demB8J3/olj
         e5HA==
X-Gm-Message-State: AOJu0YynjIX0rFXrmqC5m3NYZYjweo6zvmVZadKplxSVS/Dqtc+W6YQ4
        363pL/GMO/5f6BKibVUkXW2wBGC+8TY=
X-Google-Smtp-Source: AGHT+IELL9viuq8UdFZWvwSbupP45GkAT2WZYjJlTmGqxOPsDTd4Blod3iQrgTe1E56Y3r+imx7ll3zjC1c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:bc6:b0:6b5:a01f:f7fb with SMTP id
 x6-20020a056a000bc600b006b5a01ff7fbmr7196pfu.6.1697762294368; Thu, 19 Oct
 2023 17:38:14 -0700 (PDT)
Date:   Thu, 19 Oct 2023 17:38:12 -0700
In-Reply-To: <47c8a177d81762e0561fc47cc274076de901edbf.1696926843.git.isaku.yamahata@intel.com>
Mime-Version: 1.0
References: <cover.1696926843.git.isaku.yamahata@intel.com> <47c8a177d81762e0561fc47cc274076de901edbf.1696926843.git.isaku.yamahata@intel.com>
Message-ID: <ZTHL9NQ87LNdB8qk@google.com>
Subject: Re: [PATCH 09/12] KVM: X86: Add debugfs to inject machine check on VM exit
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-coco@lists.linux.dev, Chao Peng <chao.p.peng@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> The KVM/x86 handles machine-check in the guest specially.  It sets up the
> guest so that vcpu exits from running guests, checks the exit reason and,
> manually raises the machine check by calling do_machine_check().
> 
> To test the KVM machine check execution path, KVM wants to inject the
> machine check in the context of vcpu instead of the context of the process
> of MCE injection.  Wire up the MCE injection framework for KVM to trigger
> MCE in the vcpu context.  Add a kvm vcpu debugfs entry for an operator to
> tell KVM to inject MCE.

But this isn't "injecting" a #MC, it's just having KVM call do_machine_check()
before enabling IRQs after a VM-Exit.  I don't see how that is interesting enough
to warrant a dedicated knob and code in KVM's run loop.

> @@ -10814,6 +10823,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		fpu_sync_guest_vmexit_xfd_state();
>  
>  	static_call(kvm_x86_handle_exit_irqoff)(vcpu);
> +	if (unlikely(req_mce_inject)) {
> +		mce_call_atomic_injector_chain(smp_processor_id());
> +		kvm_machine_check();
> +		mce_inject_unlock();
> +	}
>  
>  	if (vcpu->arch.guest_fpu.xfd_err)
>  		wrmsrl(MSR_IA32_XFD_ERR, 0);
> -- 
> 2.25.1
> 

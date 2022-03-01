Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4034C937A
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 19:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237086AbiCASpF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 13:45:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237082AbiCASoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 13:44:54 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53C165421
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 10:43:50 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id f2so13274779ilq.1
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 10:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=avXnrLPk6C8Certs+81qMNb1A1PqBwld4hDSDYykLfM=;
        b=SpEqjG3fvbdOmyqRY1V7g4oG6S+0uwnJ2D/5lyz+7cGf54HPRwdI/AFvO2a5JOYTQ1
         0VYlSJYD0DgTCraxRbWtGz2dc2U91atI4GP2YthQeJJ7bJImyc1uZSvjPmDE0+l58t7y
         XTTcYHPKUHp+T2LcAoU9RnddvyfXnKER5+vycrChCPuYzN3fGIhe4hVsH08ge1BsF2dr
         z2cXo+2yl5GCfLthdyKQFNhGGPh5zmrYU1wm+BaUPWN+lF+K018OqjrIXKL+/DF1D2AL
         1+GFlk7R+EOQaC0Ib+tfGDOIimxR79c2wO/RN7YdVtKKVXrK5ByuegfuuOhlkwyQcVyC
         mdXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=avXnrLPk6C8Certs+81qMNb1A1PqBwld4hDSDYykLfM=;
        b=DKejvnP7FlQHMPiLKBtqjgdzIlpOyN9jdGQE4gKzq9Z2yv20oBG16HtSELhYV1gww9
         mp4Y4pKjxoUuioOx+GXMP4EXvCoKxanPX5eo7ov2P0PZO5wxce671KweYKfSM5j/ni0U
         2lOlsb7rnnbeRNeL7wC8btran7L5BV4yvL0PvXTxkSigcDZ4ml58XYx5zB5Ay5B/Nnx2
         zFnvBLa6N9Mh5i3RQ6fmxGFxi53RYPavEt+/WaywAf4S1ipSbaVc7O8oNHwUDPOADZNd
         BvZB+Nm/3+9yRIW6EzIekhT5ejND1H9VfLwlJAUG6MoeGcaVuVqlFUonS5+6rcQBziJU
         IWhg==
X-Gm-Message-State: AOAM532As6WdbbtB24fb0SxXkD0zxqBwCqgL1sK2bK2mc3tfEYGp4Lvi
        Hs8OCKKd8b+Vrd1b9ZOyAtjPZQ==
X-Google-Smtp-Source: ABdhPJy6VtsrAxBvGfjz/9EnSnr6NWil+PV/J0P9JEHe9HSAoq0a5WnWU5wmnEQLMnUt3dx1b16fWw==
X-Received: by 2002:a05:6e02:1645:b0:2c2:c11c:92a3 with SMTP id v5-20020a056e02164500b002c2c11c92a3mr17780208ilu.15.1646160230028;
        Tue, 01 Mar 2022 10:43:50 -0800 (PST)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id b2-20020a923402000000b002c25b16552fsm8407601ila.14.2022.03.01.10.43.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 10:43:49 -0800 (PST)
Date:   Tue, 1 Mar 2022 18:43:46 +0000
From:   Oliver Upton <oupton@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>
Subject: Re: [PATCH v4 1/8] KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits
 across MSR write
Message-ID: <Yh5pYhDQbzWQOdIx@google.com>
References: <20220301060351.442881-1-oupton@google.com>
 <20220301060351.442881-2-oupton@google.com>
 <4e678b4f-4093-fa67-2c4e-e25ec2ced6d5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e678b4f-4093-fa67-2c4e-e25ec2ced6d5@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On Tue, Mar 01, 2022 at 07:00:57PM +0100, Paolo Bonzini wrote:
> On 3/1/22 07:03, Oliver Upton wrote:
> > +
> > +	/*
> > +	 * Ensure KVM fiddling with these MSRs is preserved after userspace
> > +	 * write.
> > +	 */
> > +	if (msr_index == MSR_IA32_VMX_TRUE_ENTRY_CTLS ||
> > +	    msr_index == MSR_IA32_VMX_TRUE_EXIT_CTLS)
> > +		nested_vmx_entry_exit_ctls_update(&vmx->vcpu);
> > +
> 
> I still don't understand this patch.  You say:
> 
> > Now, the BNDCFGS bits are only ever
> > updated after a KVM_SET_CPUID/KVM_SET_CPUID2 ioctl, meaning that a
> > subsequent MSR write from userspace will clobber these values.
> 
> but I don't understand what's wrong with that.  If you can (if so inclined)
> define a VM without LOAD_BNDCFGS or CLEAR_BNDCFGS even if MPX enabled,
> commit aedbaf4f6afd counts as a bugfix.

Right, a 1-setting of '{load,clear} IA32_BNDCFGS' should really be the
responsibility of userspace. My issue is that the commit message in
commit 5f76f6f5ff96 ("KVM: nVMX: Do not expose MPX VMX controls when
guest MPX disabled") suggests that userspace can expect these bits to be
configured based on guest CPUID. Furthermore, before commit aedbaf4f6afd
("KVM: x86: Extract kvm_update_cpuid_runtime() from
kvm_update_cpuid()"), if userspace clears these bits, KVM will continue
to set them based on CPUID.

What is the userspace expectation here? If we are saying that changes to
IA32_VMX_TRUE_{ENTRY,EXIT}_CTLS after userspace writes these MSRs is a
bug, then I agree aedbaf4f6afd is in fact a bugfix. But, the commit
message in 5f76f6f5ff96 seems to indicate that userspace wants KVM to
configure these bits based on guest CPUID.

Given that there were previous userspace expectations, I attempted to
restore the old behavior of KVM (ignore userspace writes) and add a
quirk to fully back out of the mess. All this logic also applies to
Patch 2 as well.

--
Oliver

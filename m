Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2717B5ECB
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 03:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbjJCBtL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 21:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjJCBtL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 21:49:11 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9515EBD
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 18:49:08 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c6147ea811so3470715ad.2
        for <kvm@vger.kernel.org>; Mon, 02 Oct 2023 18:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696297748; x=1696902548; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/1GcFKpqQr7EgKIa2M4IfaP3m063MciWtxwAaaP9mOw=;
        b=c/a1kRFhSdBbDys7cr8giN2DUrKj+1Yn9SHmbWqcYH8VIuslaLQuTw13YsYb2dzc9u
         3+5qPo4xDEyNRMDPXBJFd8nDQ6tjbFgYhu0NRfWyIJTIlrDq//2s34OMNA9/4a83FYKj
         +36aOSd5PpfKdlN3veMG75Rg1oEBLTyWv9QgG9wXl0R4X0aRWGHTAAqzMdEJ5Z0WgzAs
         mQxSdDkeInnsek9tnCRzlE/PydfPJBDRi5pYBQPcVJaQnu5w2EGaQzZ40EjczNzLmQ/u
         SXAGbS6sjGNQZYHOfs3Q02v+NjftT4/JxqBr3bmK+GcgsrdMATYWMWf/aWFRPjeIQCyE
         sw0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696297748; x=1696902548;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/1GcFKpqQr7EgKIa2M4IfaP3m063MciWtxwAaaP9mOw=;
        b=oLvGB+2gGvyC2rqXLt7S4pOS4YvzWv2suAycZhZKd+Fbq0vuG+IxVczplJnsRfnFFQ
         lsfeZlb73gQ+duOViFQ/Yr77cOqv80wvFB/oRWMGGSK79v2zDyTnT/EIeWq8aAnYWczI
         UAKLTGWI9+y7JVdx5HOVfwjtUtKmpj1Z92DsqnWCYdrpPx5QNFWsG39nIfXrl3vcqHbq
         yrQbmyJ/PBqc/PWiPdpnQtWk0RM2Sl5c6W0Giu13qZ4J1yGthsZpLHGJnU8+3cIDyMp1
         e4bvu7Z1zqZQJiF9JHzu1Uus3OBcpuYwiEluO9yPYJ4I2BBl50XDywmhV47QHLORbT6J
         aoxg==
X-Gm-Message-State: AOJu0Yyu25uXcTm2JgolaIhTh0DjqgzT1MgEvLdvc4Rwpc003Fu/HGrf
        WCPdvV4A4l2dHbgnRGNb00KL6hiXmyg=
X-Google-Smtp-Source: AGHT+IH779ohoGLRWMPXMYUvWGxcfnj7p23KQEQLX6alwsuTnVm2xQPYG2TRBMuCX8LoH/qr1HdCXhAYg5k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:fac4:b0:1c0:d575:d25 with SMTP id
 ld4-20020a170902fac400b001c0d5750d25mr156376plb.11.1696297748072; Mon, 02 Oct
 2023 18:49:08 -0700 (PDT)
Date:   Mon, 2 Oct 2023 18:49:06 -0700
In-Reply-To: <afa70110-72dc-cf7d-880f-345a6e8a3995@oracle.com>
Mime-Version: 1.0
References: <20230926230649.67852-1-dongli.zhang@oracle.com>
 <377d9706-cc10-dfb8-5326-96c83c47338d@oracle.com> <36f3dbb1-61d7-e90a-02cf-9f151a1a3d35@oracle.com>
 <ZRWnVDMKNezAzr2m@google.com> <a461bf3f-c17e-9c3f-56aa-726225e8391d@oracle.com>
 <884aa233ef46d5209b2d1c92ce992f50a76bd656.camel@infradead.org>
 <ZRrxtagy7vJO5tgU@google.com> <52a3cea2084482fc67e35a0bf37453f84dcd6297.camel@infradead.org>
 <ZRtl94_rIif3GRpu@google.com> <afa70110-72dc-cf7d-880f-345a6e8a3995@oracle.com>
Message-ID: <ZRtzEgnRVZ7FpG3R@google.com>
Subject: Re: [PATCH RFC 1/1] KVM: x86: add param to update master clock periodically
From:   Sean Christopherson <seanjc@google.com>
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Joe Jin <joe.jin@oracle.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 02, 2023, Dongli Zhang wrote:
> > @@ -12185,6 +12203,10 @@ int kvm_arch_hardware_enable(void)
> >  	if (ret != 0)
> >  		return ret;
> >  
> > +	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
> > +		kvm_get_time_scale(NSEC_PER_SEC, tsc_khz * 1000LL,
> > +				   &host_tsc_shift, &host_tsc_to_system_mul);
> 
> I agree that to use the kvmclock to calculate the ns elapsed when updating the
> master clock.
> 
> Would you take the tsc scaling into consideration?
> 
> While the host_tsc_shift and host_tsc_to_system_mul are pre-computed, how about
> the VM using different TSC frequency?

Heh, I'm pretty sure that's completely broken today.  I don't see anything in KVM
that takes hardware TSC scaling into account.

This code:

	if (unlikely(vcpu->hw_tsc_khz != tgt_tsc_khz)) {
		kvm_get_time_scale(NSEC_PER_SEC, tgt_tsc_khz * 1000LL,
				   &vcpu->hv_clock.tsc_shift,
				   &vcpu->hv_clock.tsc_to_system_mul);
		vcpu->hw_tsc_khz = tgt_tsc_khz;
		kvm_xen_update_tsc_info(v);
	}

is recomputing the multipler+shift for the current *physical* CPU, it's not
related to the guest's TSC in any way.

__get_kvmclock() again shows that quite clearly, there's no scaling for the guest
TSC anywhere in there.

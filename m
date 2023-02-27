Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04FAB6A4DCE
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 23:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbjB0WPP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 17:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbjB0WPM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 17:15:12 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C948C2917A;
        Mon, 27 Feb 2023 14:15:10 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id m20-20020a17090ab79400b00239d8e182efso823799pjr.5;
        Mon, 27 Feb 2023 14:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yd/7Cq6SQonRclW5fSsjKrCDJc+mFVGxr8w4LVRPlHg=;
        b=iHDyQaCUPzs/wNxXh4G9VfFWF9JKM0sitaiNLTvyVwzcaHIMDHnGyBcANZbCeFRqCi
         aeLpCmmnq6AMjdinuEJ/zFauvypZ5PJfzI54euET3O7yU+3BIOg1oh8yuBAM8WuYYfo/
         O/a2yUWca3w0HqWqiEmDJVBDyxwYdCRV4rLcbMvO/JWrxlG9k+UX7Wx+JtluwWyo5FG+
         WVBfD4ZLC8IVq2UV2xRbrzzAjxoTwkGMGiOnznRBgXJwVA9fhxLcla8qtmJeRlcHBnkq
         xGDYQk1YsKSp4TlZtfCOxpajjWbpXbyCm97E9BPfFHBhAtiy1UxCdxZaXw/YLH+D8XQR
         pNbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yd/7Cq6SQonRclW5fSsjKrCDJc+mFVGxr8w4LVRPlHg=;
        b=5rCQClZhJKDaDas45HkvqxJx94hltBr6ZpbILEaeamdyRP1EBHF8Lns0EqDoGxYrsT
         cV9c9esTLPX6vu5rnrTXk56Ab9uvYCgWw752KICj/SZfRfxaMiS6FjCJYabx/o2ycG9N
         dujGd0ioLFnFmOOV102mVxEfFqOl50mF2WKFFSBwhNHlWenuKSS+P+WXuuss9DvmFpRI
         1pzPS+6/HkIDt4Cpy3z73iEk8RISfj4TmCzQ9lbb6JD+DuC59SavznC46ZZ4ZTpZzREN
         hR8aiHLLSrHoMGU3qarGBhFYr1qAzfxlS+MYnDQNhsdwRn14ItCmD5Sm2SGSwHfvcY+w
         HB5g==
X-Gm-Message-State: AO0yUKU9xc/qMKX+QU64SBTsogKvlb3qFJE/Uz2nlgUH5XljZVvEMD0l
        3yzP2bmLl8CZkaC7SqPwMIk=
X-Google-Smtp-Source: AK7set+AhMrSIziXntXX6bkcHMuEFmUPHZJDKgBFtjwuEzfLyDUsIe/uWea2VpEWhjUUp2CKTDcNsw==
X-Received: by 2002:a05:6a20:918a:b0:cd:7d01:7671 with SMTP id v10-20020a056a20918a00b000cd7d017671mr873806pzd.22.1677536110258;
        Mon, 27 Feb 2023 14:15:10 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id j63-20020a638b42000000b005030113f46dsm4567577pge.37.2023.02.27.14.15.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 14:15:09 -0800 (PST)
Date:   Mon, 27 Feb 2023 14:15:08 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v11 058/113] KVM: TDX: MTRR: implement get_mt_mask() for
 TDX
Message-ID: <20230227221508.GS4175971@ls.amr.corp.intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <21e0d94ccf2fd3d766d6aa7b45441791c04e5e4f.1673539699.git.isaku.yamahata@intel.com>
 <20230203065545.piywnc3jnxqotehv@yy-desk-7060>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230203065545.piywnc3jnxqotehv@yy-desk-7060>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 03, 2023 at 02:55:45PM +0800,
Yuan Yao <yuan.yao@linux.intel.com> wrote:
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index e68816999387..c4c5a8f786c1 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -309,6 +309,25 @@ int tdx_vm_init(struct kvm *kvm)
> >  	return 0;
> >  }
> >
> > +u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> > +{
> > +	/* TDX private GPA is always WB. */
> > +	if (gfn & kvm_gfn_shared_mask(vcpu->kvm)) {
> > +		WARN_ON_ONCE(is_mmio);
> > +		return  MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
> > +	}
> 
> This looks not clear enough, the comment says things about private GPA
> but the code returns WB for shared GPA, please align them.

It should be !(gfn & shared mask). Thanks for the catch.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

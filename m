Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5590C4CFD4D
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 12:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239673AbiCGLrU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 06:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239233AbiCGLrS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 06:47:18 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E7966221
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 03:46:24 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id u10so21162089wra.9
        for <kvm@vger.kernel.org>; Mon, 07 Mar 2022 03:46:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ktP7BnWwK23FI/t1E9zBBBCFDc5dTgq0QcDeYV/LjMs=;
        b=kE+0uWbmYfdbxJWiaFqLD8Z6RBMgUw0mvNQb3F8xOKDV/7CJKoejFmUyIuPVnKDIJj
         qWRjxdUapFNeSbt/fqvXRW3W4XKxSLB+RqbpKThmIyONg9dIL3HF2sHg+s7jORSHvwuc
         0to1Gcm3ovjq42IBsX2H5TlxY+hphMLjzVCkceBeOpSo/YEAEcOS+TbI+vi4xbCvRHfr
         ZNEWtg1s10nj5qzt7fcI/I37BrcUkYXJ6EzLrpgjp7EUYiG6GyQbtrqk6u7NcYK6JB+U
         YYwdHxf6QRIM+BRz4LR2Aw497WXwBYaSjCN43pBExfX3QCDCLE0EZ1a0OTOglrNOzxCM
         0UPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ktP7BnWwK23FI/t1E9zBBBCFDc5dTgq0QcDeYV/LjMs=;
        b=vFrcopmr83F1dow3tKpyKFYwjfdldQKTRte13em3l9qWciEAWDIa40yIuot4OkEn6/
         e/SsrbSkDzRRdM/ZVSvCj9bVnk56c1PvB0739PbJaX10WOor0yu8w7fHNk3qOpgnkD3v
         UwGLNwHUUl6N/0U9IL21fXXXQ/HKlz6sH4zHCHHXvDw/7gPukIRjP/JjPF0L32uEwwev
         LvsBOTkBHyo1w2Uc2le3YyMmS4tU4pZdRSgtEOR77GnaShd9PdWA7UJ+DJmjVNGrohcc
         VKIk6rv6G9qMtFQBVjrqLr7i2wZ0Ft+VO7EXiabAvO9iZtvROOYwb9JCG7gardoIbv7b
         2c1g==
X-Gm-Message-State: AOAM532UMXo+4wpijoGnsQgPBOXzx3nOFh+vPtjfqJQ6drjUM65oTHGE
        kRLnQe5VZ/o2LcZTriL9sSdGAg==
X-Google-Smtp-Source: ABdhPJzu2JTMxT5Ih3o+3PV6MprnxtJ8GPpbRDJb6yyFua7rCsDXpO2/KXSVydgeBOUCo+LIAt0KRQ==
X-Received: by 2002:adf:f20e:0:b0:1f0:7673:be2f with SMTP id p14-20020adff20e000000b001f07673be2fmr8029786wro.19.1646653582447;
        Mon, 07 Mar 2022 03:46:22 -0800 (PST)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id h12-20020a5d548c000000b001f1f99e7792sm2026069wrv.111.2022.03.07.03.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 03:46:22 -0800 (PST)
Date:   Mon, 7 Mar 2022 11:46:20 +0000
From:   Sebastian Ene <sebastianene@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, qperret@google.com, will@kernel.org,
        julien.thierry.kdev@gmail.com
Subject: Re: [PATCH kvmtool v7 2/3] aarch64: Add stolen time support
Message-ID: <YiXwjCjcJbgaY10x@google.com>
References: <20220302140734.1015958-1-sebastianene@google.com>
 <20220302140734.1015958-3-sebastianene@google.com>
 <8735k02z98.wl-maz@kernel.org>
 <YiCuBsKsh4TAZqTs@google.com>
 <87pmn22ac7.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pmn22ac7.wl-maz@kernel.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 03, 2022 at 05:51:36PM +0000, Marc Zyngier wrote:
> On Thu, 03 Mar 2022 12:01:10 +0000,
> Sebastian Ene <sebastianene@google.com> wrote:

Hi,

> > 
> > > > +int kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu)
> > > > +{
> > > > +	int ret;
> > > > +	bool has_stolen_time;
> > > > +	u64 pvtime_guest_addr = ARM_PVTIME_MMIO_BASE + vcpu->cpu_id *
> > > > +		ARM_PVTIME_STRUCT_SIZE;
> > > > +	struct kvm_config *kvm_cfg = NULL;
> > > > +	struct kvm_device_attr pvtime_attr = (struct kvm_device_attr) {
> > > > +		.group	= KVM_ARM_VCPU_PVTIME_CTRL,
> > > > +		.addr	= KVM_ARM_VCPU_PVTIME_IPA
> > > > +	};
> > > > +
> > > > +	kvm_cfg = &vcpu->kvm->cfg;
> > > > +	if (kvm_cfg->no_pvtime)
> > > > +		return 0;
> > > > +
> > > > +	if (!pvtime_data.is_supported)
> > > > +		return -ENOTSUP;
> > > 
> > > It is a bit odd to have this hard failure if running on a system that
> > > doesn't have pvtime. It forces the user to alter their command-line,
> > > which is a bit annoying. I'd rather have a soft-fail here.
> > > 
> > 
> > The flag 'is_supported' is set to false when we support pvtime but we
> > fail to configure it. We verify that we support pvtime by calling the check
> > extension KVM_CAP_STEAL_TIME. I think the naming is odd here for the
> > flag name. It should be : 'is_failed_cfg'.
> 
> Ah, I see. Yes, the name is misleading.
> 

I will update the name for this to: 'is_failed_cfg'.

> >
> > > > +
> > > > +	has_stolen_time = kvm__supports_extension(vcpu->kvm,
> > > > +						  KVM_CAP_STEAL_TIME);
> > > > +	if (!has_stolen_time)
> > > > +		return 0;
> 
> Here, you could force no_pvtime to 1, and avoid checking for each vcpu
> once you detected that the host is not equipped to deal with it.
> 

Good point ! I will do this.

Thanks,
Sebastian

> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

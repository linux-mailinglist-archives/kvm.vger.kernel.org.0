Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAC775882BF
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 21:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbiHBTq3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 15:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiHBTq0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 15:46:26 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E832B18B2D
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 12:46:25 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id g12so14500718pfb.3
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 12:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=X/WDXK9dhhCu2+RqKxktdTeX2bUeOW08JdNOmeWMcTs=;
        b=NL5o6kvqAp6CZUASniRtCaOagRjx+QG1iSgvPprEwPYurql8OMpuEZmOFx6m2qf6nA
         g6AMoPP/k+45Ju4Ums6yL1rIn86JnpdNTZzRB3wR92+ODN4ZDUSq9PRH/ku8m/4pc0VM
         +xxMU2EBVJ+rQ8pvBGQl+hkeiZYhooAeUMAkmmUSyzr3+oCqb+/ahr3m6x3R4vz4sDfo
         h4MWBl0XsW/uI+K2gflxhy4RJYOgnbdggtvqZpT6LvHVojnLXKm3AxY1gK65VUdw07kJ
         ewfvJ0dZJGUZybx+ifbQcyonBPrJBF+W8xZt7uYPwDz5wgP2lbjwTpeXbzIlbcZoY9TQ
         0lwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=X/WDXK9dhhCu2+RqKxktdTeX2bUeOW08JdNOmeWMcTs=;
        b=W1x5IK5T/gfRvYO7lyxg6RZAM6q6eqvVEqhvSgnxa5j5SyGkwr/3SIOQfrXVywu7In
         JQFvVs3CqrqaqONeMTWSRrrOy7VNrtddO4b/zUGYy7d8eujfIj580EGa0zoPtMGW1Yt2
         eELovwx1l5EFXjqgaDtnU9eyjbelAXZC/YwMp5wWBrKhfn/oOWvlE6gzu5+kGRxyTTAZ
         sPy8vZ+hFTvcWd2rKOsIZ4js0F0xjb6pgG5ysPq6fADMej+1vyqT3RqAo6D/+biLoFBz
         GbAmOpI/sAsLTIp6eLv+ZTVamP5LPrNFEoa22+jkx4oiBItp9ePwzWiOyDxZHAWCvsjw
         5Cgw==
X-Gm-Message-State: AJIora8BVudZoty9iSxK+elBbgVGyxkU6K8dMzdswtbo8y65hkAlymx9
        ofcCIp9bOsJVcE1KDKjYTtDGRZVceYOhPg==
X-Google-Smtp-Source: AGRyM1tcTnFkPMk+iDatakVZ7haudXkfR3vj1qEX62HpKsQWAyAaZKldn3yOWM0WYYOAHPmmfcQnZA==
X-Received: by 2002:a05:6a00:1a0e:b0:52a:cef3:b4a1 with SMTP id g14-20020a056a001a0e00b0052acef3b4a1mr22192466pfv.23.1659469585316;
        Tue, 02 Aug 2022 12:46:25 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b12-20020a17090a6acc00b001f4fb21c11asm5439377pjm.21.2022.08.02.12.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 12:46:24 -0700 (PDT)
Date:   Tue, 2 Aug 2022 19:46:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Kai Huang <kai.huang@intel.com>, Sagi Shahar <sagis@google.com>
Subject: Re: [PATCH v7 022/102] KVM: TDX: create/destroy VM structure
Message-ID: <Yul/DapNdokpeN36@google.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <aa3b9b81f257d4d177ab25cb78a222d6297de97f.1656366338.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa3b9b81f257d4d177ab25cb78a222d6297de97f.1656366338.git.isaku.yamahata@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 27, 2022, isaku.yamahata@intel.com wrote:
> +int tdx_vm_init(struct kvm *kvm)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	cpumask_var_t packages;
> +	int ret, i;
> +	u64 err;
> +
> +	/* vCPUs can't be created until after KVM_TDX_INIT_VM. */
> +	kvm->max_vcpus = 0;
> +
> +	kvm_tdx->hkid = tdx_keyid_alloc();
> +	if (kvm_tdx->hkid < 0)
> +		return -EBUSY;

We (Google) have been working through potential flows for intrahost (copyless)
migration, and one of the things that came up is that allocating the HKID during
KVM_CREATE_VM will be problematic as HKID are a relatively scarce resource.  E.g.
if all key IDs are in use, then creating a destination TDX VM will be impossible
even though intrahost migration can create succeed since the "new" would reuse
the source's HKID.

Allocating the various pages is also annoying, e.g. they'd have to be freed, but
not as directly problematic.

SEV (all flavors) has a similar problem with ASIDs.  The solution for SEV was to
not allocate an ASID during KVM_CREATE_VM and instead "activate" SEV during
KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM.

I think we should prepare for a similar future for TDX and move the HKID allocation
and all dependent resource allocation to KVM_TDX_INIT_VM.  AFAICT (and remember),
this should be a fairly simple code movement, but I'd prefer it be done before
merging TDX so that if it's not so simple, e.g. requires another sub-ioctl, then
we don't have to try and tweak KVM's ABI to enable intrahost migration.

> +
> +	ret = tdx_alloc_td_page(&kvm_tdx->tdr);
> +	if (ret)
> +		goto free_hkid;
> +
> +	kvm_tdx->tdcs = kcalloc(tdx_caps.tdcs_nr_pages, sizeof(*kvm_tdx->tdcs),
> +				GFP_KERNEL_ACCOUNT);
> +	if (!kvm_tdx->tdcs)
> +		goto free_tdr;
> +	for (i = 0; i < tdx_caps.tdcs_nr_pages; i++) {
> +		ret = tdx_alloc_td_page(&kvm_tdx->tdcs[i]);
> +		if (ret)
> +			goto free_tdcs;
> +	}

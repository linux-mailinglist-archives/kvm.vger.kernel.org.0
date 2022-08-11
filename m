Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA99590653
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 20:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235602AbiHKS3s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 14:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbiHKS3q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 14:29:46 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5629D13F;
        Thu, 11 Aug 2022 11:29:44 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id x10so17635272plb.3;
        Thu, 11 Aug 2022 11:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=W1DsqZM8Uz+AH+eZtJ7xbKnINN56HLfbtoCJbcC3YBc=;
        b=f6cWHaLY0tS45+GJvHXiSw5T1AZuQx47sK6Xh540+Y7rACTMEXk/L5FsRkSfpBNQRh
         ciSNUipNGbFvOgX3EP4OA2CKFnS+TEDyWQw709+ife7ecUdB4bmkYznoQ3esnpZBUgSq
         fVkysrJHaCSPhDms0meGCC2wIdZAH3NsTVJLEoctLL3U0NRdCjhrhPO2qsruAliRSgqA
         kPqRYuSWaw57/N6AJIPOhsLPUb/gnQ3OY0qbZN2tBoOzXWh301XboYZy77dNvVpqdbLp
         MZjZ4k0fCToHUJ0NKnqfvClCsqtcthjMs/LlTfMS4+gl3ESTV/nIGkyR/MNgsMo+eBDb
         4Baw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=W1DsqZM8Uz+AH+eZtJ7xbKnINN56HLfbtoCJbcC3YBc=;
        b=rCHKwU4w1GYdyG4ONSWpreAwOw7knOgVGrpGeVCq+oza/fcIndXe8xrvJnBzBGaeSP
         eE1MfprB3Cn5MVwA6IltQEFSihKbYn+DoEWjJdFMdwuhH26bNflo5r+I4xxmk7p8ybtz
         DMqIYvwermU5/AuQQMglGcL7iMw5vKcU5ptIHZfdyDp11yA72fSeDoXXivt/L6bmwI92
         nGrumsDkbVbV1n9NX3kABHgQagA21WmWPVgw+ReWUWCTH3e+X9IRpWWLHBQ53AA0MAq6
         C2zgx9O8gfYCY6NJ9QUjisroaCFYdepqXPWEP7ONEcLxmBgGeVlIJSpUPT29kv8/OFfz
         5naw==
X-Gm-Message-State: ACgBeo2Wfz4eBoIpAurZlkG8Z8avZ+r+UgY5SIdbhO3A5DZ/mjhB5bRf
        NoKxMqu/JFCokIuRVGKJMSQ=
X-Google-Smtp-Source: AA6agR5kvdcaaYuD7a0AtbZ5LFPEP+aJyvikiRXzKaYKa9xXTVrNIknFkUKaVATCHeTKKGuXj8n/Ow==
X-Received: by 2002:a17:90b:4b8e:b0:1f5:49bd:8b0e with SMTP id lr14-20020a17090b4b8e00b001f549bd8b0emr9846738pjb.86.1660242584119;
        Thu, 11 Aug 2022 11:29:44 -0700 (PDT)
Received: from localhost ([192.55.54.53])
        by smtp.gmail.com with ESMTPSA id d31-20020a17090a6f2200b001f4e0c71af4sm78776pjk.28.2022.08.11.11.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 11:29:43 -0700 (PDT)
Date:   Thu, 11 Aug 2022 11:29:42 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kai Huang <kai.huang@intel.com>, Sagi Shahar <sagis@google.com>
Subject: Re: [PATCH v7 022/102] KVM: TDX: create/destroy VM structure
Message-ID: <20220811182942.GD504743@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <aa3b9b81f257d4d177ab25cb78a222d6297de97f.1656366338.git.isaku.yamahata@intel.com>
 <Yul/DapNdokpeN36@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yul/DapNdokpeN36@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 02, 2022 at 07:46:21PM +0000,
Sean Christopherson <seanjc@google.com> wrote:

> On Mon, Jun 27, 2022, isaku.yamahata@intel.com wrote:
> > +int tdx_vm_init(struct kvm *kvm)
> > +{
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +	cpumask_var_t packages;
> > +	int ret, i;
> > +	u64 err;
> > +
> > +	/* vCPUs can't be created until after KVM_TDX_INIT_VM. */
> > +	kvm->max_vcpus = 0;
> > +
> > +	kvm_tdx->hkid = tdx_keyid_alloc();
> > +	if (kvm_tdx->hkid < 0)
> > +		return -EBUSY;
> 
> We (Google) have been working through potential flows for intrahost (copyless)
> migration, and one of the things that came up is that allocating the HKID during
> KVM_CREATE_VM will be problematic as HKID are a relatively scarce resource.  E.g.
> if all key IDs are in use, then creating a destination TDX VM will be impossible
> even though intrahost migration can create succeed since the "new" would reuse
> the source's HKID.
> 
> Allocating the various pages is also annoying, e.g. they'd have to be freed, but
> not as directly problematic.
> 
> SEV (all flavors) has a similar problem with ASIDs.  The solution for SEV was to
> not allocate an ASID during KVM_CREATE_VM and instead "activate" SEV during
> KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM.
> 
> I think we should prepare for a similar future for TDX and move the HKID allocation
> and all dependent resource allocation to KVM_TDX_INIT_VM.  AFAICT (and remember),
> this should be a fairly simple code movement, but I'd prefer it be done before
> merging TDX so that if it's not so simple, e.g. requires another sub-ioctl, then
> we don't have to try and tweak KVM's ABI to enable intrahost migration.

The simple code movement works here.  The TDX related initialization/allocation
can simply be moved to KVM_TDX_INIT_VM and KVM_TDX_INIT_VCPU.

I'll update them with the next respin.

Thanks,
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDE1581C9B
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 01:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239832AbiGZX6C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 19:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiGZX6B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 19:58:01 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57787286F3;
        Tue, 26 Jul 2022 16:58:00 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id g12so14645761pfb.3;
        Tue, 26 Jul 2022 16:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7vhhqdup1oTrBRtqAz1oeIK0uowylKUwvLxltZF9KMQ=;
        b=FsJ0yQA0O2hhoNSRToA55UGHf9r9Vn5a/jmg/5fGF9HFebqLSsZQEeQuufGwJYBgIt
         jB4ECrOYW7uvrY2/P7SjhDCLXuNFYtvJnPyjrQuDLHf56TpYYEtE9twpuK4NS4RpqOmy
         7cpOKphkkmhS23UF82wBYbGIOXTF8t5beGPXOOxGPQ44rnGgrrfDXl/Lo7gd39ZD66sO
         l8y7lNJYzCeI52txGuTDPe7br4FpN+9uK7F+qRZ9HF8e+Ld9pK8Oik16JIZk5R43X37d
         UhilUcY6y01ihXCJV9gQtFZ8lsGLySL14WAMb5PrSZwx4LI6JWqWox3lDhJu5vRl+/PT
         Np7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7vhhqdup1oTrBRtqAz1oeIK0uowylKUwvLxltZF9KMQ=;
        b=iQ4FJNtBlj6xMV9DaJr1GrhjRDmMeoeuHjQqGLJQj4+DAoc2s/R91XJWOzR13xyocX
         5sHPYTtpNX/HZqrRRsgaymkAjRnHnmA44WpLoHPE1ZirjJ6N1dEwK+wc02kZqHs/FveY
         xdbjIHmoH/ZTEpRtfh3m1QrQCvyU00CKeh8SUkMKZ40yq2yYTYdgI0NsimHHP2NOm3OG
         gG7CuXEmbU/QBlH8XpZgw0pp9GB36ESsMHiuh+dPNnaHbN90qE2P8JzvHtuZUNecMUtz
         aHQ9L10LutFg085ezlbPCfAf1JrLV6PcLd47ioTf/S2p3Zwd/IlvNr0/NociBHykvFuE
         Skrg==
X-Gm-Message-State: AJIora9dfs3jniR0ghO1v5dozlnMDZv8jVME4GB32/DUUPA+qHqJA+7S
        +izANxJeuAI7HxjOBadsewE=
X-Google-Smtp-Source: AGRyM1u6+KHcBHhA8RACFnwyKPEfhYWtP4sAvS5jxuS9+hMKkmgvZsiApx9P0gFL6I0lqiDzToPo6g==
X-Received: by 2002:a63:6945:0:b0:41a:5127:a477 with SMTP id e66-20020a636945000000b0041a5127a477mr16528336pgc.15.1658879879799;
        Tue, 26 Jul 2022 16:57:59 -0700 (PDT)
Received: from localhost ([192.55.54.49])
        by smtp.gmail.com with ESMTPSA id j6-20020a170902da8600b0016d763967f8sm5481807plx.107.2022.07.26.16.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 16:57:58 -0700 (PDT)
Date:   Tue, 26 Jul 2022 16:57:57 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Chao Gao <chao.gao@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [PATCH v7 002/102] Partially revert "KVM: Pass kvm_init()'s
 opaque param to additional arch funcs"
Message-ID: <20220726235757.GF1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <4566737e3c57c5ab17c0bc29d6f4758744b6eed1.1656366337.git.isaku.yamahata@intel.com>
 <e4604ad23788a6d2950c091d04b7b805684a1a01.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e4604ad23788a6d2950c091d04b7b805684a1a01.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 13, 2022 at 01:55:46PM +1200,
Kai Huang <kai.huang@intel.com> wrote:

> On Mon, 2022-06-27 at 14:52 -0700, isaku.yamahata@intel.com wrote:
> > From: Chao Gao <chao.gao@intel.com>
> > 
> > This partially reverts commit b99040853738 ("KVM: Pass kvm_init()'s opaque
> > param to additional arch funcs") remove opaque from
> > kvm_arch_check_processor_compat because no one uses this opaque now.
> > Address conflicts for ARM (due to file movement) and manually handle RISC-V
> > which comes after the commit.
> > 
> > And changes about kvm_arch_hardware_setup() in original commit are still
> > needed so they are not reverted.
> 
> I tried to dig the history to find out why we are doing this.
> 
> IMHO it's better to give a reason why you need to revert the opaque.  I guess no
> one uses this opaque now doesn't mean we need to remove it?
> 
> Perhaps you should mention this is a preparation to
> hardware_enable_all()/hardware_disable_all() during module loading time. 
> Instead of extending hardware_enable_all()/hardware_disable_all() to take the
> opaque and pass to kvm_arch_check_process_compat(), just remove the opaque.
> 
> Or perhaps just merge this patch to next one?


Here is the updated commit message.

    Partially revert "KVM: Pass kvm_init()'s opaque param to additional arch funcs"
    
    This partially reverts commit b99040853738 ("KVM: Pass kvm_init()'s opaque
    param to additional arch funcs") remove opaque from
    kvm_arch_check_processor_compat because no one uses this opaque now.
    Address conflicts for ARM (due to file movement) and manually handle RISC-V
    which comes after the commit.  The change about kvm_arch_hardware_setup()
    in original commit are still needed so they are not reverted.
    
    The current implementation enables hardware (e.g. enable VMX on all CPUs),
    arch-specific initialization for VM creation, and disables hardware (in
    x86, disable VMX on all CPUs) for last VM destruction.
    
    TDX requires its initialization on loading KVM module with VMX enabled on
    all available CPUs. It needs to enable/disable hardware on module
    initialization.  To reuse the same logic, one way is to pass around the
    unused opaque argument, another way is to remove the unused opaque
    argument.  This patch is a preparation for the latter by removing the
    argument.


-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

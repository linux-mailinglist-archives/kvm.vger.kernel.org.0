Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96AC76A4D38
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 22:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbjB0VcG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 16:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjB0VcF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 16:32:05 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698B0233FD;
        Mon, 27 Feb 2023 13:32:04 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id p20so7036916plw.13;
        Mon, 27 Feb 2023 13:32:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KoB9//B5yE19yj53mu7FgLkDEsSMqaL6dT9iqC2ncgs=;
        b=ZFuZiZJGEFILwex8MnrV3gHdW+LaSdi9X5ZZt1AsqtMFYjQwWrsabJ0QrgHZj6NNmy
         nX3zB6aTv8M1LqO7QF8Po27co/kGu3yam/z3QvG79dl2HnwcgiCZ+TwJ1Fpc4tIgiJOd
         DIAXvb/iWr/19fqCMyitUm8Ty2Mud2mKq2yq4V9jZedQsFnCvHhLB5Lu3H9Qu1xrL7S0
         j6UjS4i2SSejXqczCKzwIw/nLjozcdKPUShq9Dj+0aIBamVKAtGe/ZzAU04oV3dD75zw
         opuMeAGKkhXtiTv1atyIxevbJk9/yECGj0Ud5v0sCvIq9Bjme6jZfXMJwWjlC9OhPWLa
         uBFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KoB9//B5yE19yj53mu7FgLkDEsSMqaL6dT9iqC2ncgs=;
        b=z/CdqEisDLYCQLlpQauv/1yRVDAZlwJ8raizvumzgWGaks5jeX4l9IT64i/7+d+ypO
         i4BPV+ZkXmfyXSgv3XlSU9XaQeR1q7AzoCQNTx+/Z+3cLv9C/5H4HRARYG7hvc6laOCE
         RsMglRstPu3t9NmXTsQE0mG9mUtPj146hPssa+R7DwJNlgZT71c6QuIuIDQS/k8Ab9NC
         UbE/7jpQBKFgciI1hzOCewHEaKSddEkoaVVEzn7c5VA6TcpyVhq3md1kp/Uf//YqM1tG
         qEiGPELr7zxHqnDh85I96+LuIwg3dMIDWlvqvPDWOP1pZh0lQLUPYj83RWnmVrRdyoTB
         zzjQ==
X-Gm-Message-State: AO0yUKXDtNzQ6wzlvU9ENl8mwG2gXzkXJbLJz9dUfl8KbTfJOy0TnG9J
        12Fx5XGnwN2qpx/gR90sNL4HGDJt0uc=
X-Google-Smtp-Source: AK7set9gJUnaS8ZF/4R4Gr0hfeLQvngJllTlKjLyDo9YzBbzVmQ0b/C25fbSGo0FF7GE9iOP77Yscg==
X-Received: by 2002:a17:902:c406:b0:19a:5958:15e7 with SMTP id k6-20020a170902c40600b0019a595815e7mr880175plk.15.1677533523745;
        Mon, 27 Feb 2023 13:32:03 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id h6-20020a170902eec600b0019b089bc8d7sm5048425plb.78.2023.02.27.13.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 13:32:03 -0800 (PST)
Date:   Mon, 27 Feb 2023 13:32:01 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v11 019/113] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <20230227213201.GH4175971@ls.amr.corp.intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <a0b5c459cce27c83a1275a3108f810299635d217.1673539699.git.isaku.yamahata@intel.com>
 <426aa7c48100b4577dd107ca54896286c60b9d4e.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <426aa7c48100b4577dd107ca54896286c60b9d4e.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 16, 2023 at 10:04:19AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Thu, 2023-01-12 at 08:31 -0800, isaku.yamahata@intel.com wrote:
> > +struct kvm_tdx_init_vm {
> > +	__u64 attributes;
> > +	__u64 mrconfigid[6];	/* sha384 digest */
> > +	__u64 mrowner[6];	/* sha384 digest */
> > +	__u64 mrownerconfig[6];	/* sha348 digest */
> > +	union {
> > +		/*
> > +		 * KVM_TDX_INIT_VM is called before vcpu creation, thus before
> > +		 * KVM_SET_CPUID2.  CPUID configurations needs to be passed.
> > +		 *
> > +		 * This configuration supersedes KVM_SET_CPUID{,2}.
> 
> What does "{,2}" mean?

Both KVM_SET_CPUID and KVM_SET_CPUID2.  For comment purpose, only KVM_SET_CPUID2
suffice. I'll drop "{,2}".

> 
> > +		 * The user space VMM, e.g. qemu, should make them consistent
> > +		 * with this values.
> 
> You are already using 'struct kvm_cpuid2' below.  Isn't it enough to imply that
> userspace should organize data in the format of 'struct kvm_cpuid2'?
> 
> > +		 * sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES(256)
> > +		 * = 8KB.
> > +		 */
> 
> What does this comment try to imply?
> 
> > +		struct {
> > +			struct kvm_cpuid2 cpuid;
> > +			/* 8KB with KVM_MAX_CPUID_ENTRIES. */
> > +			struct kvm_cpuid_entry2 entries[];
> 
> I don't understand what's the purpose of the second field?
> 
> Shouldn't the 'struct kvm_cpuid2' already have all the CPUID entries?
> 
> > +		};
> > +		/*
> > +		 * For future extensibility.
> > +		 * The size(struct kvm_tdx_init_vm) = 16KB.
> > +		 * This should be enough given sizeof(TD_PARAMS) = 1024
> > +		 */
> > +		__u64 reserved[2029];
> 
> I think this is just wrong.  How can you extend something after a dynamic size
> CPUID array?
> 
> If you want extensibility, you need to put the space before the flexible array.
> 
> > +	};
> > +};

I changed the struct as follows.

struct kvm_tdx_init_vm {
        __u64 attributes;
        __u64 mrconfigid[6];    /* sha384 digest */
        __u64 mrowner[6];       /* sha384 digest */
        __u64 mrownerconfig[6]; /* sha348 digest */
        /*
         * For future extensibility to make sizeof(struct kvm_tdx_init_vm) = 8KB.
         * This should be enough given sizeof(TD_PARAMS) = 1024.
         * 8KB was chosen given because
         * sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES(=256) = 8KB.
         */
        __u64 reserved[1004];

        /*
         * KVM_TDX_INIT_VM is called before vcpu creation, thus before
         * KVM_SET_CPUID2.
         * This configuration supersedes KVM_SET_CPUID2s for VCPUs. The user
         * space VMM, e.g. qemu, should make KVM_SET_CPUID2 consistent with this
         * values.
         */
        struct kvm_cpuid2 cpuid;
};

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

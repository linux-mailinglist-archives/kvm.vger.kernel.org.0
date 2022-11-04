Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 382BF6191B7
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 08:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbiKDHSZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 03:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231374AbiKDHSW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 03:18:22 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77153F33;
        Fri,  4 Nov 2022 00:18:21 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id gw22so3785311pjb.3;
        Fri, 04 Nov 2022 00:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eA0yZupCmJu+lIFxWoscgsZofsCuVm6nQ+r3Bs4PfgM=;
        b=pMTxZL/oe6jfdbdYCNUp+Xb6WGMwDJ0tqzYjFuCFVTbU1K6LCmp38IhtqgFEtGH1Fw
         eLi3S+bCzf2+/rSdLI9BvXSs2AxVFQGLdZ/VpkCMRosDZICPg8K0E7aAi3VCg4WFPYDw
         BfmWNQys/m/eitnUWQLYZ4i97xNTJmOpokS1/YmW7+tK6sMrbeSwt/lUvRFiVPBmwrU/
         ivWuBjfa1WZ8S1UNebL0AtpJKNK0IoOPWmP7NKKqfcpMaASq0oFieIk/rtzcNf6p/IAa
         QK7q17GoUs4Yjdkmho6a4WFZ4muIgt4Uy+uR4Vu4p0vmgfomnVLk+4/4y9tD9W4Njnx3
         1t6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eA0yZupCmJu+lIFxWoscgsZofsCuVm6nQ+r3Bs4PfgM=;
        b=0fXgmSAgQp3CEAU9JiRx5zUifmpjqg5xcoqY+d31uqQBauQXzIHBGlCSxPzgQjtrAh
         jb41sMOEK05HWxSSxRYyuYZQ9FxCdzk+RrRVnYP1N4WHzgdK1Y5C3BLjn1GPN1IqJKZQ
         cp/UZ1mcjnPgUsfvLBimLK2qtegErm8JvVZj6mMtSCAA8guLxeGmNn/MEjB7yOFOcNqe
         ooyOYjWZl6kQQQtvpkv1QAYMYBWyWIf9hQfZYrBvtTRagDaUvPISAV4Lm25m2LQqwmFh
         LswyG1Da0PBarJZQVtDXOY2dMFdoHPi+o/IXBUu7jC+ein4L2nSmVGePd8EvTfopfRgC
         actw==
X-Gm-Message-State: ACrzQf3yumu0n+1uwUG1MV+UYSFLLjBHSmSjULtzYv4e+3/xprovEVnI
        GhpRl6AYGZIn5hUuEBcREWw=
X-Google-Smtp-Source: AMsMyM44DihVYXeoqfThPObIIFl16q8Fgq5Ol1s8X3KRnlnJD5T+n/qjAhXcJhbg7QI1HMtgLqbViQ==
X-Received: by 2002:a17:902:d592:b0:17a:582:4eb with SMTP id k18-20020a170902d59200b0017a058204ebmr34136415plh.40.1667546300864;
        Fri, 04 Nov 2022 00:18:20 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id y9-20020a17090322c900b00186f0f59c85sm1854838plg.235.2022.11.04.00.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 00:18:20 -0700 (PDT)
Date:   Fri, 4 Nov 2022 00:18:19 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH 36/44] KVM: x86: Do compatibility checks when onlining CPU
Message-ID: <20221104071819.GD1063309@ls.amr.corp.intel.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-37-seanjc@google.com>
 <20221103210402.GB1063309@ls.amr.corp.intel.com>
 <Y2RB4qT02EkhMjPL@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y2RB4qT02EkhMjPL@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 03, 2022 at 10:34:10PM +0000,
Sean Christopherson <seanjc@google.com> wrote:

> On Thu, Nov 03, 2022, Isaku Yamahata wrote:
> > On Wed, Nov 02, 2022 at 11:19:03PM +0000,
> > Sean Christopherson <seanjc@google.com> wrote:
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index f223c845ed6e..c99222b71fcc 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1666,7 +1666,7 @@ struct kvm_x86_nested_ops {
> > >  };
> > >  
> > >  struct kvm_x86_init_ops {
> > > -	int (*check_processor_compatibility)(void);
> > > +	int (*check_processor_compatibility)(int cpu);
> > 
> > Is this cpu argument used only for error message to include cpu number
> > with avoiding repeating raw_smp_processor_id() in pr_err()?
> 
> Yep.
> 
> > The actual check is done on the current executing cpu.
> > 
> > If cpu != raw_smp_processor_id(), cpu is wrong. Although the function is called
> > in non-preemptive context, it's a bit confusing. So voting to remove it and
> > to use.
> 
> What if I rename the param is this_cpu?  I 100% agree the argument is confusing
> as-is, but forcing all the helpers to manually grab the cpu is quite annoying.

Makes sense. Let's settle it with this_cpu.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

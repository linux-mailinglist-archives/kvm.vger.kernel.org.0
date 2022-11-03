Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABC436173F4
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 03:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbiKCCBY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 22:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiKCCBX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 22:01:23 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F53411A13;
        Wed,  2 Nov 2022 19:01:22 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id u8-20020a17090a5e4800b002106dcdd4a0so3853998pji.1;
        Wed, 02 Nov 2022 19:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vquiJlp330GDGQ6hLFumgcl1M1wOsxOvOhocZz2TmtU=;
        b=CGhLja8yZ4Z5TItbdw8gk0XdwdcZWXR+VtANUIocFbCpoNzlz8Lk/AUB1H1NumqEPQ
         aABmmiOf2E8e6mNaJ2vk2hpY7WJ4tlWZTbUubC2DvMtMXR8pjqhc3xXbD6SO4h7z0PoJ
         NGnlvRgJKqwtLMx9ChzG+umFUD1bROQpFH5PtOstt4vEjGSq1dINeZSPq2nOrk3Dnc6S
         o26QB4KlOaeWO1U8EN0dk8qXNldkz7wNThSfzz4MwBlrqCwQPbY7lTZr5qWnQQVKQ6iq
         6Cx8EgEfLWwN1ILyk3vO1/8oMGcT0+7akgQ9cawKbljBA0g7PJvRE1wDFnL366W6Kv7+
         o2qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vquiJlp330GDGQ6hLFumgcl1M1wOsxOvOhocZz2TmtU=;
        b=ocFRHwQst0MxfFWoitdXHqRw0SgVzojvpZBkB5zH0cDUdljloDhz0z6sArQ/rc3Chf
         PPRE3bjdn/ozBsuqSWt+zT2yxJJkbbLNxtFJ4Q1bjBB4GOEQ6fh+NXED76YUozTrlqPD
         TImZy9UR6KA/PhncV+VPYt1hAOtl63mrX9rRrAe80StU7Rqy8dhwFUcDo51fMhmnJvGW
         jWdAnu4OajkFtAcHxxcM2Y0889UOg5O6nnZntQH8YrwHXSnG+2oP0ge9/fVqBA7Vj9ZO
         fIlXn/HuNXodulqwi+xjCCd5X5h4xm4KY94lR0zy2BhO602NftXHRWyKCFr8wpY4wF0j
         IdcQ==
X-Gm-Message-State: ACrzQf3laTl6DaT9i8b9RqsgHQnBMo+HrVv5X4cJw42yURUim0ifx/04
        45OrtYfE04lkBzFfVBcD49w=
X-Google-Smtp-Source: AMsMyM7+ODBy3jIzyLu4/x6Mu382ezVbUjKHPIhTVz2cAXLhSGTh6RJP2yIM6vHZwYS+utaTiWTJtw==
X-Received: by 2002:a17:90a:6481:b0:212:dab0:189e with SMTP id h1-20020a17090a648100b00212dab0189emr29226089pjj.127.1667440881927;
        Wed, 02 Nov 2022 19:01:21 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id r17-20020a170902c61100b00186a6b6350esm8934187plr.268.2022.11.02.19.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 19:01:21 -0700 (PDT)
Date:   Wed, 2 Nov 2022 19:01:20 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v10 017/108] KVM: TDX: Refuse to unplug the last cpu on
 the package
Message-ID: <20221103020120.GC954260@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <de6b69781a6ba1fe65535f48db2677eef3ec6a83.1667110240.git.isaku.yamahata@intel.com>
 <5bb42920-cd17-e235-bfe0-ba05f1e2b5bc@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5bb42920-cd17-e235-bfe0-ba05f1e2b5bc@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 02, 2022 at 04:06:20PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 4b22196cb12c..25c30c8c2d9b 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -12337,16 +12337,23 @@ int kvm_arch_online_cpu(unsigned int cpu, int usage_count)
> >   int kvm_arch_offline_cpu(unsigned int cpu, int usage_count)
> >   {
> > -	if (usage_count) {
> > -		/*
> > -		 * arch callback kvm_arch_hardware_disable() assumes that
> > -		 * preemption is disabled for historical reason.  Disable
> > -		 * preemption until all arch callbacks are fixed.
> > -		 */
> > -		preempt_disable();
> > -		hardware_disable(NULL);
> > -		preempt_enable();
> > -	}
> > +	int ret;
> > +
> > +	if (!usage_count)
> > +		return 0;
> > +
> > +	ret = static_call(kvm_x86_offline_cpu)();
> 
> Use static_call_cond instead?
> Seems the new interface for x86 is only implemented for Intel.

Not needed because KVM_X86_OP_OPTIONAL_RET0(offline_cpu) is used.

Please remember
#define KVM_X86_OP_OPTIONAL_RET0(func) \
        static_call_update(kvm_x86_##func, (void *)kvm_x86_ops.func ? : \
                                           (void *)__static_call_return0);
Thanks,
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

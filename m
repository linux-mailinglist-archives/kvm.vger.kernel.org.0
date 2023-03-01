Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C716A672F
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 05:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjCAE6n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 23:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjCAE6l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 23:58:41 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A01BF22DE2;
        Tue, 28 Feb 2023 20:58:39 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id f18so16124552lfa.3;
        Tue, 28 Feb 2023 20:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677646718;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TESyg0k50ZlAWRUleVTTv6eCu7vMdxpvaGcYCgk4iKc=;
        b=ADjeduN/qHepz9YjV4fhjn/i2c2EPdm4ieVk79GCkxJlIAjJyOJSxQiwwg1oAg2EiA
         rruInesU3a0KziQ3NIRyGqp4onauqMV+wYgnoDikGb61xRJGL1kvF/4BiexA8qACCsuv
         E3tlp63GacvQlVicvVE2hPfabKArZBMaYY5eNXWvh45QxAvcDoB/3uO76S9Kvl8KeyW5
         V+YluunE3ELpG7NkYYJgF/iRqNh8ldTzkyQLeHYLFDc+Ka54aagp5UQ256ZaREsm4KL/
         iq1Q0MN/sbC0/g4HkF2PjUTqkQR364EgAjASvBYBuUl9OJ54XApNoQ0lYkYUcYFEzbG9
         vr7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677646718;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TESyg0k50ZlAWRUleVTTv6eCu7vMdxpvaGcYCgk4iKc=;
        b=g3D4ycJNS7175j5ajHXQfKhItFPk4csAFXjI1vrjQyCY0BgVNJgImzD1ueh7SFOZls
         Q0Gq7sLRMPpPjCD/JWG7PFChUMSWEdi3YfKiUsknJOgtMkmefQn8AZooqsms6X5O8jeK
         Nt7KCaPI0JDnLu4gnwPFA6ZyrP6Ha1QAZLXNLD+hP3aLEy5mLzsDPng1Azv2zf5C1+Fy
         +LAe2Cn57pub4cBDoiKXMTxigcCdxo8cLqOG7kEGcbBjD8HV3CVHJtMGU7W8IflDQvXm
         cZYiIs3vtEvhDxuYl42Oi2Qz+G0a1fyoWwGy8zS7tz2jhwI49zrqWqlp2lb9sxwJn34I
         WtrA==
X-Gm-Message-State: AO0yUKX3SDJAuoxhfU2ZIDRyCvy9khbzK+0BJ5LUXxrM4N28auzf3+6s
        NkwOnAuSib5J4CTNu/1BwpQ=
X-Google-Smtp-Source: AK7set+AHnSENp4Xs+gNCGaRmIA7kmvYrsvF5GtPZPpE2wptYg+55k0FS+Fcu+hzVpvwi+7qtM4r1g==
X-Received: by 2002:a05:6512:518:b0:4e0:2e20:b663 with SMTP id o24-20020a056512051800b004e02e20b663mr1215968lfb.6.1677646717760;
        Tue, 28 Feb 2023 20:58:37 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id m6-20020a056512014600b004b5979f9ba8sm1584668lfo.210.2023.02.28.20.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 20:58:37 -0800 (PST)
From:   Zhi Wang <zhi.wang.linux@gmail.com>
X-Google-Original-From: Zhi Wang <zhi.wang.linux@intel.com>
Date:   Wed, 1 Mar 2023 06:58:34 +0200
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Zhi Wang <zhi.wang.linux@gmail.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v11 023/113] KVM: TDX: allocate/free TDX vcpu structure
Message-ID: <20230301065834.000032f4@intel.com>
In-Reply-To: <20230228202031.GZ4175971@ls.amr.corp.intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
        <db53b2c6c7718df7df89bb36b83257a2588b58e1.1673539699.git.isaku.yamahata@intel.com>
        <20230116124606.00003872@gmail.com>
        <20230227234914.GU4175971@ls.amr.corp.intel.com>
        <20230228195509.000073da@intel.com>
        <20230228202031.GZ4175971@ls.amr.corp.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 Feb 2023 12:20:31 -0800
Isaku Yamahata <isaku.yamahata@gmail.com> wrote:

> On Tue, Feb 28, 2023 at 07:55:09PM +0200,
> Zhi Wang <zhi.wang.linux@gmail.com> wrote:
> 
> > On Mon, 27 Feb 2023 15:49:14 -0800
> > Isaku Yamahata <isaku.yamahata@gmail.com> wrote:
> 
> > > > 2) Move 
> > > > 
> > > > > +	apic_base_msr.data = APIC_DEFAULT_PHYS_BASE | LAPIC_MODE_X2APIC;
> > > > > +	if (kvm_vcpu_is_reset_bsp(vcpu))
> > > > > +		apic_base_msr.data |= MSR_IA32_APICBASE_BSP;
> > > > > +	apic_base_msr.host_initiated = true;
> > > > 
> > > > to:
> > > > 
> > > > void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
> > > > {
> > > >         struct kvm_lapic *apic = vcpu->arch.apic;
> > > >         u64 msr_val;
> > > >         int i;
> > > > 
> > > >         if (!init_event) {
> > > >                 msr_val = APIC_DEFAULT_PHYS_BASE | MSR_IA32_APICBASE_ENABLE;
> > > > 
> > > > 		/* here */
> > > > 		if (is_td_vcpu(vcpu)) 
> > > > 			msr_val = xxxx;
> > > >                 if (kvm_vcpu_is_reset_bsp(vcpu))
> > > >                         msr_val |= MSR_IA32_APICBASE_BSP;
> > > >                 kvm_lapic_set_base(vcpu, msr_val);
> > > >         }
> > > 
> > > No. Because I'm trying to contain is_td/is_td_vcpu in vmx specific and not use
> > > in common x86 code.
> > >
> > 
> > I guess so. Centeralizing the initialization would be the nice and greatly
> > improve the readablity of the code. Maybe adding a new callback in kvm x86_ops
> > like .get_default_msr_val instead.
> 
> Finally I can eliminate cpuid/APIC BASE MSR, and move it user space VMM, qemu.

Great to hear.


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 917DC6A603E
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 21:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjB1UUg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 15:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjB1UUf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 15:20:35 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8394C31E2D;
        Tue, 28 Feb 2023 12:20:34 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id d10so6413638pgt.12;
        Tue, 28 Feb 2023 12:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677615634;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9qiw9KFmwi+AizxewJZpNHTRGrhea9LVnFTbqWCbYhE=;
        b=pD69geMqNY4I8V/wg1LL2CU+/bw87HnzIjwo3YlPX3VmjDhuhDoAyHpAgbn8oMMjmA
         LczJvFvo23Aoef+GygMBOG5ksCvOmCzaPHzPnQY5zw/CcUxkCt5oQr9MENHxKQ0cGd8j
         t0mzw83BKUkiOXoWBTyPthYdWRIx4FSR2lu1F9y1xfFjWXPZEDT7Nge6nGw3LzXONyQw
         aXxEMrGydFCjHsKdXjMeI41IeQRlzLyNWQOJcByKlU5kVI7GEUlOsKZOxppjwfTAjcEo
         QsAAox5fL/7gpZ0Q7FgXxF1sU3UskFAA45yvSj5R91y9YAdU0KTlQtRc4pPjAJEHdiW6
         87Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677615634;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9qiw9KFmwi+AizxewJZpNHTRGrhea9LVnFTbqWCbYhE=;
        b=mHNtcSQOIRH+Hfhcui2gbJdbjKEuN8aBq5qzfBwHVB00vg0rep2RFZcjvRbdZhI7OX
         ih+l4+QDYhOkuYYfqZgtU6IoorMvTpeJ3LHTatwRRqntNaBtr4kEXI7RRDXVLLitlotf
         VUdTXrp/buFQeVUelGPEGTFp9wh5GVpVgSHu4FlpfWsptsLEawAGgdC3rkFOR97kpZ0A
         SYiK1Db3u1Msln9F5Xmx8fNlQecjdtahAlP5EhcQg6N0c2SKfAnu2P02Mz7sowMJHu5y
         qwtiKdb1C9K4+2akr/P5V2znGOVjjtLtgRgBad1opGIZVy1yt51vJhbHPVk47fa54Xf/
         gTAw==
X-Gm-Message-State: AO0yUKUAxp8g7f1htvVDktj6iJSp3DCkQYpGnWZfHk5NjEgu3Fh1VmYH
        y9ivhpk9VDNuPel0k+bjMvU=
X-Google-Smtp-Source: AK7set9Eyfx2VNrPtPhw9PzY6CGXwQ+MPDULxrNt0VpqCsokqV+NreWXU26Xw2KdyKnjdstGN6LfkQ==
X-Received: by 2002:a62:1bd6:0:b0:5db:ba81:dd9f with SMTP id b205-20020a621bd6000000b005dbba81dd9fmr2969677pfb.30.1677615633753;
        Tue, 28 Feb 2023 12:20:33 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id j7-20020aa79287000000b005892ea4f092sm6622711pfa.95.2023.02.28.12.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 12:20:33 -0800 (PST)
Date:   Tue, 28 Feb 2023 12:20:31 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v11 023/113] KVM: TDX: allocate/free TDX vcpu structure
Message-ID: <20230228202031.GZ4175971@ls.amr.corp.intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <db53b2c6c7718df7df89bb36b83257a2588b58e1.1673539699.git.isaku.yamahata@intel.com>
 <20230116124606.00003872@gmail.com>
 <20230227234914.GU4175971@ls.amr.corp.intel.com>
 <20230228195509.000073da@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230228195509.000073da@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28, 2023 at 07:55:09PM +0200,
Zhi Wang <zhi.wang.linux@gmail.com> wrote:

> On Mon, 27 Feb 2023 15:49:14 -0800
> Isaku Yamahata <isaku.yamahata@gmail.com> wrote:

> > > 2) Move 
> > > 
> > > > +	apic_base_msr.data = APIC_DEFAULT_PHYS_BASE | LAPIC_MODE_X2APIC;
> > > > +	if (kvm_vcpu_is_reset_bsp(vcpu))
> > > > +		apic_base_msr.data |= MSR_IA32_APICBASE_BSP;
> > > > +	apic_base_msr.host_initiated = true;
> > > 
> > > to:
> > > 
> > > void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
> > > {
> > >         struct kvm_lapic *apic = vcpu->arch.apic;
> > >         u64 msr_val;
> > >         int i;
> > > 
> > >         if (!init_event) {
> > >                 msr_val = APIC_DEFAULT_PHYS_BASE | MSR_IA32_APICBASE_ENABLE;
> > > 
> > > 		/* here */
> > > 		if (is_td_vcpu(vcpu)) 
> > > 			msr_val = xxxx;
> > >                 if (kvm_vcpu_is_reset_bsp(vcpu))
> > >                         msr_val |= MSR_IA32_APICBASE_BSP;
> > >                 kvm_lapic_set_base(vcpu, msr_val);
> > >         }
> > 
> > No. Because I'm trying to contain is_td/is_td_vcpu in vmx specific and not use
> > in common x86 code.
> >
> 
> I guess so. Centeralizing the initialization would be the nice and greatly
> improve the readablity of the code. Maybe adding a new callback in kvm x86_ops
> like .get_default_msr_val instead.

Finally I can eliminate cpuid/APIC BASE MSR, and move it user space VMM, qemu.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A58A637748
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 12:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiKXLOr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 06:14:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiKXLOp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 06:14:45 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7080713F4B9
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 03:14:44 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id ho10so3474311ejc.1
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 03:14:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QvdZHlaUeA/kpuIQxOoAXYG4uxIMkVdwq3XVOXD0WSo=;
        b=fEL+Huo3PZo+OmBMXv2J5c0oB97G5+JckioepzGtYr+NQOFGp0GBpGyozzLOwOqHDN
         yeW/xslWFHQiDkOLQ6WpkuC0zKawjyVjK534QazFVc/ePeRY41UQZqssNje5EggfXJpI
         zBBXXtwtvHLKqkojmAxVBShDEOUynvVf2yu417rmcUotM7Bo/CGU4zz6tntTRbv8b4Vw
         8sk7MUIC2tf4C2F8IVlufJkRziC/zk/bJueQW68bK1KlNhskyD4CM7NsAYjrbf1pd7KB
         GxZOJ9NsHrC8mfo8t3kJgjFiP/ahNXgrMTwNjpnq31V/cWlxGz9srgWGjc+q4n/QiXDt
         K5+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QvdZHlaUeA/kpuIQxOoAXYG4uxIMkVdwq3XVOXD0WSo=;
        b=YwCp2Pu5d6hn7S9UtXX9GFbkLM4kyA0wA5eDpPkvE0DNu/EgWVBtdscrSnLtzn+pXN
         2rSBJtTTC44O3ol1JGuVmqqbUEAD7TdjIK3oZS3/eUAyawHpKt5R+GABwCE/lbe0zq9Q
         y833yRxxhgbzeXcokn7mXB4tNBUJcG4peKxAk1S8DW97t40UXmNfUf2LT0i7TENbNNK/
         ucAvp1QEld9qgP/VN3ySie57RB1NLdGhFIhL44tOIhSTMZNcYgbQNyx1CyrgtuR+IVcn
         eN2MwT7baGz8oCMegVgStRZf+s+43O7iBzZUUO71laPKkeydfEwX8ddQe2KIRYACDvSU
         PkwA==
X-Gm-Message-State: ANoB5pldq1DeKLVV0mHrSVcvgYstyB2TeWmpnuODxRGj8+fhvSlb0Xoz
        5pHQzJiCiP8ubmM5CNOY+z0xkQ==
X-Google-Smtp-Source: AA0mqf4My+PCFrVMy9/RTm1cNg83OFY3uPJgeZtgX4OdvMlMOBdlIlcgWhQ7PRakvreWdz6sf89YCA==
X-Received: by 2002:a17:906:79c4:b0:778:e3e2:8311 with SMTP id m4-20020a17090679c400b00778e3e28311mr12814855ejo.342.1669288482935;
        Thu, 24 Nov 2022 03:14:42 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id u17-20020a1709061db100b0078128c89439sm321900ejh.6.2022.11.24.03.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 03:14:42 -0800 (PST)
Date:   Thu, 24 Nov 2022 12:14:41 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Atish Patra <atishp@atishpatra.org>
Cc:     Atish Patra <atishp@rivosinc.com>, linux-kernel@vger.kernel.org,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>, Guo Ren <guoren@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [RFC 5/9] RISC-V: KVM: Add skeleton support for perf
Message-ID: <20221124111441.oixispy6d7rit7jr@kamzik>
References: <20220718170205.2972215-1-atishp@rivosinc.com>
 <20220718170205.2972215-6-atishp@rivosinc.com>
 <20221101141329.j4qtvjf6kmqixt2r@kamzik>
 <CAOnJCULMbTp6WhVRWHxzFnUgCJJV01hcyukQxSEih-sYt5TJWg@mail.gmail.com>
 <20221123131104.zglb3osa5tsgkkkb@kamzik>
 <CAOnJCUK0PcSXxt-Qvomy-4UoP5993-bVfPvWn_Rd5=ELC9n1gA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOnJCUK0PcSXxt-Qvomy-4UoP5993-bVfPvWn_Rd5=ELC9n1gA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 24, 2022 at 01:09:03AM -0800, Atish Patra wrote:
> On Wed, Nov 23, 2022 at 5:11 AM Andrew Jones <ajones@ventanamicro.com> wrote:
> >
> > On Tue, Nov 22, 2022 at 04:46:14PM -0800, Atish Patra wrote:
> > ...
> > > > > +     kvpmu->num_hw_ctrs = num_hw_ctrs;
> > > > > +     kvpmu->num_fw_ctrs = num_fw_ctrs;
> > > >
> > > > Maybe it's coming later, but we need to give KVM userspace control over
> > > > the number of counters to allow it to migrate to a larger set of hosts.
> > > > Also, a previous patch said the virtual width must be the same as the
> > > > host width for the hw counters, so we need userspace to know what that
> > > > is in order to determine to which hosts it can migrate a guest.
> > > >
> > >
> > > Yes. The entire user space access control needs to be sketched out.
> > > We probably need another one reg interface to set/get the number of
> > > counters/width.
> > >
> > > However, Is it a common to migrate a guest between different hosts
> > > with different PMU capabilities ?
> > >
> >
> > Ideally we'd be able to define a virtual CPU+PMU which represents the
> > least common denominator of a set of hosts, allowing VMs which use that
> > VCPU model to migrate among all the hosts. x86 pulls this off pretty well,
> > but arm64 doesn't. In the least, I think a goal should be to enable
> > migration of VMs from hosts with less extensions and less PMU counters to
> > hosts with more, as that would support host upgrades without having to
> > recreate VMs.
> >
> 
> We also have hpmwidth to worry about. I guess the policy details will be
> VMM specific one. We need to think through the parameters that can be
> varied between
> hosts. As you pointed out earlier,
> 
> 1. hpmcounter wdith
> 2. Number of hpmcounters
> 3. PMU related ISA extension - this will be applicable for all the extensions.
> 
> Anything else ?

I can't think of anything at the moment. Hopefully most potential
differences (features and errata) will be in extensions or in
number, i.e. smaller sets of things which can be emulated with
larger sets.

Thanks,
drew

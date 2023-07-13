Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBBB75258A
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 16:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjGMOvh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 10:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjGMOve (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 10:51:34 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BB42719
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 07:51:32 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-cb8263615d7so88243276.1
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 07:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689259891; x=1691851891;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G9n1BXfy3astdmQugnThnoK6d9e5ksv1SVqMpQuysOY=;
        b=LXNyu/mWXlMRqS5zAmiqX8lznI1o8xrq+fq0KznSfz/OLTE0bQum+GMj6Z7Nb+vMss
         /wrRSc+3d+HnE0y1kJdaMEQNuVEoS/Y+C2yCnC3mk10mFfZSdMDYp2Xcbo7R24NiUKBp
         5I9gOaWZ1Ru0UYKMjx7A5LS8cfp/yYATcP7qpJMhLox33C8T7iL4dk4AvA7StO9tZWBb
         fTWOQ0fzultyg+PT9g8t/eNyEL9m8mjc4jvOtJHS+Ujp8gR3s+BBikbEHW/XfUm4GCFK
         DLuvruJOqbYJsGTQ4hI0qNY5m+uS+OYuUC9UYZXyJLTQj8AopH7xdVFNWZ+YU2x/wG5T
         +TCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689259891; x=1691851891;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=G9n1BXfy3astdmQugnThnoK6d9e5ksv1SVqMpQuysOY=;
        b=F0cJkT+LZ28NKcGIh2qxIqdshLgdKQKKYINxH9zlEIRnlr1AD2B2M41MrCnFKTo8SN
         TIdLZW6Hvaa1vrDndGEGakaktSnrGpYBLqGJ/iXKo2cWEPLFppSeDuLvz5T4j+WiwwgA
         ybZJ543s+wLi1Tu80Hkvaa+kDJiDhmhDEg29CJFhmnFdRUM6byjUUXzwW9qU4rs0HCDt
         jGCAfmGK8Cbs1qqtRSSMNPbRWKo1xMFAquaG2VK0qo3zrcKvFVy3vWtNZNUXNtKssoL1
         wq28KeSn7byBMZFIHQAwLa2uH1BWzxmjtT8jCIfQGrYWXDj08fqr1s3gyKMkqVaS7u78
         omtQ==
X-Gm-Message-State: ABy/qLaP/vzjx2Jf8NAzm6MPl2GsdaqoaQB2Oe8U2AuQXeu0GzR71i2o
        /1EALalvHu4XMUtZr1Y65tsZERtKvAo=
X-Google-Smtp-Source: APBJJlFP0j8rPfCNlPxkU1+28y0cxQhdjwsLwI22rM61CqxCeFdNkGGaVLC2Vb8OHW0UFnU4dQwE6DQCgzk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c089:0:b0:c39:4e0b:2f05 with SMTP id
 c131-20020a25c089000000b00c394e0b2f05mr8028ybf.6.1689259891691; Thu, 13 Jul
 2023 07:51:31 -0700 (PDT)
Date:   Thu, 13 Jul 2023 07:51:30 -0700
In-Reply-To: <d4887818532e1716b5dd8a08819c656ab4e4c5bf.camel@intel.com>
Mime-Version: 1.0
References: <cover.1689151537.git.kai.huang@intel.com> <41b7e5503a3e6057dc168b3c5a9693651c501d22.1689151537.git.kai.huang@intel.com>
 <20230712221510.GG3894444@ls.amr.corp.intel.com> <4202b26acdb3fe926dd1a9a46c2c7c35a5d85529.camel@intel.com>
 <20230713074204.GA3139243@hirez.programming.kicks-ass.net> <d4887818532e1716b5dd8a08819c656ab4e4c5bf.camel@intel.com>
Message-ID: <ZLAPck1XKN7ko7vM@google.com>
Subject: Re: [PATCH 09/10] x86/virt/tdx: Wire up basic SEAMCALL functions
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "peterz@infradead.org" <peterz@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 13, 2023, Kai Huang wrote:
> On Thu, 2023-07-13 at 09:42 +0200, Peter Zijlstra wrote:
> > On Thu, Jul 13, 2023 at 03:46:52AM +0000, Huang, Kai wrote:
> > > On Wed, 2023-07-12 at 15:15 -0700, Isaku Yamahata wrote:
> > > > > The SEAMCALL ABI is very similar to the TDCALL ABI and leverages =
much
> > > > > TDCALL infrastructure.=EF=BF=BD Wire up basic functions to make S=
EAMCALLs for
> > > > > the basic TDX support: __seamcall(), __seamcall_ret() and
> > > > > __seamcall_saved_ret() which is for TDH.VP.ENTER leaf function.
> > > >=20
> > > > Hi.=EF=BF=BD __seamcall_saved_ret() uses struct tdx_module_arg as i=
nput and output.=EF=BF=BD For
> > > > KVM TDH.VP.ENTER case, those arguments are already in unsigned long
> > > > kvm_vcpu_arch::regs[].=EF=BF=BD It's silly to move those values twi=
ce.=EF=BF=BD From
> > > > kvm_vcpu_arch::regs to tdx_module_args.=EF=BF=BD From tdx_module_ar=
gs to real registers.
> > > >=20
> > > > If TDH.VP.ENTER is the only user of __seamcall_saved_ret(), can we =
make it to
> > > > take unsigned long kvm_vcpu_argh::regs[NR_VCPU_REGS]?=EF=BF=BD Mayb=
e I can make the
> > > > change with TDX KVM patch series.
> > >=20
> > > The assembly code assumes the second argument is a pointer to 'struct
> > > tdx_module_args'.  I don't know how can we change __seamcall_saved_re=
t() to
> > > achieve what you said.  We might change the kvm_vcpu_argh::regs[NR_VC=
PU_REGS] to
> > > match 'struct tdx_module_args''s layout and manually convert part of =
"regs" to
> > > the structure and pass to __seamcall_saved_ret(), but it's too hacky =
I suppose.
> >=20
> > I suspect the kvm_vcpu_arch::regs layout is given by hardware; so the
> > only option would be to make tdx_module_args match that. It's a slightl=
y
> > unfortunate layout, but meh.
> >=20
> > Then you can simply do:
> >=20
> > 	__seamcall_saved_ret(leaf, (struct tdx_module_args *)vcpu->arch->regs)=
;
> >=20
> >=20
>=20
> I don't think the layout matches hardware, especially I think there's no
> "hardware layout" for GPRs that are concerned here.  They are just for KV=
M
> itself to save guest's registers when the guest exits to KVM, so that KVM=
 can
> restore them when returning back to the guest.

kvm_vcpu_arch::regs does follow the hardware-defined indices, and that's re=
quired
for myriad emulation flows, e.g. saving GPRs into SMRAM, anywhere KVM gets =
a GPR
index from an instruction opcode or vmcs.VMX_INSTRUCTION_INFO, etc.

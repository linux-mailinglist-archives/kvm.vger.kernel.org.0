Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48FC7591F9D
	for <lists+kvm@lfdr.de>; Sun, 14 Aug 2022 13:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236068AbiHNLGK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Aug 2022 07:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbiHNLGJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Aug 2022 07:06:09 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5242112AA3;
        Sun, 14 Aug 2022 04:06:06 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 130so4350270pfy.6;
        Sun, 14 Aug 2022 04:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=k+58/urwJaUcYVxIakH4F1mI9tASKwJznuqHNTgHGmk=;
        b=OINRhHngiG30xV6ttlY6I8ykc3WT+FbtPXMVlmexPjaa3k+zxqw5nh5zzkKFtFF49Q
         7ZiZIA1owWzjnxgu0E+PrO2vvhK+FoPb8g8KjNXeMIijGaSGgmjArVFFQmGV5v0vmrEE
         IbxedONijgo7rJ2z8dhCPwyyYmFI0cRIwJjXbHlDdZmCPpA6pUmn0fjuYb1JWV0GCxTC
         BM6SPOo9iui+HAlND1aOxwiVz1Dafwp4K2gef2BkvyNs9YIbR2PxRWeT4VPCPl2GOy4+
         b2TMAxtQaGBUKeSwBfbsq/aS+SO3aXO3f5NSi4hG/LduU4TcGVlpwXca8fyaEYh+6BgG
         GVDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=k+58/urwJaUcYVxIakH4F1mI9tASKwJznuqHNTgHGmk=;
        b=jTRKpaY05vaHs8qIP3GkgN7vwR1zzR38Rxfy7udzMZw8wjCyTLcFvyKiNn0vb/1iEf
         UAmwzstSy+4D3UOeXEKOO/4OWYns44oj/1rScibUmSjCPTKkzPo9MMz4ur28TMhyYZeF
         bJdLSbmk8YXZIhxQVSyGjx1GMroJLKloIlsMTXXia4QOe2J/79l8SFi6/xZ/JwOcuU1v
         o+ZmsZQvW1M/wYbIPoXfDXlfAawYfVBuGRKkUPq+gKHX1oY5P598Q50W2j6gMDb1R5h1
         Z2S7hHEGTXaBz7aXbugBURD5auN3xNKh5C5XNGXhe17FMr39LK0lfNeArvN0ccdrZi7y
         mukQ==
X-Gm-Message-State: ACgBeo3O2mRa3w8vbRGgLm6enH4E/Gi8pZ+Bbv2riv5FsUXfoxQV7oH+
        P3/4MiIZW7w5cO1m9WA1yH+CnBEUkVc=
X-Google-Smtp-Source: AA6agR5KAHJLNaLilnQLvJJ0TZELKBMpSSjKJATEwIs75QjQEzg7jMgzAX1cad4CgKEHkxX/MZBXpw==
X-Received: by 2002:a05:6a00:1d84:b0:52f:4a8f:7381 with SMTP id z4-20020a056a001d8400b0052f4a8f7381mr12153437pfw.52.1660475165740;
        Sun, 14 Aug 2022 04:06:05 -0700 (PDT)
Received: from localhost ([74.211.107.8])
        by smtp.gmail.com with ESMTPSA id b8-20020a170902650800b0016ed5266a5csm5158938plk.170.2022.08.14.04.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Aug 2022 04:06:05 -0700 (PDT)
Date:   Sun, 14 Aug 2022 19:06:01 +0800
From:   Yao Yuan <yaoyuan0329os@gmail.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Yuan Yao <yuan.yao@linux.intel.com>, Yuan Yao <yuan.yao@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jon Cargille <jcargill@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH 1/1] kvm: nVMX: Checks "VMCS shadowing" with VMCS link
 pointer for non-root mode VM{READ,WRITE}
Message-ID: <20220814110601.sionrszu2xh4t72u@sapienza>
References: <20220812014706.43409-1-yuan.yao@intel.com>
 <20220812020206.foknky4hghgsadby@yy-desk-7060>
 <CALMp9eRejAUVzFOsASBc-Md8KUeS1mzqOm9WCJ9dBFkc_NeOJg@mail.gmail.com>
 <20220812230758.bkpukdocsflxxrru@sapienza>
 <CALMp9eT6jSz02L89RBoKuiz3fAo-EqS-Q2B0qF3HrcE1SZ-izw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eT6jSz02L89RBoKuiz3fAo-EqS-Q2B0qF3HrcE1SZ-izw@mail.gmail.com>
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 12, 2022 at 05:30:53PM -0700, Jim Mattson wrote:
> On Fri, Aug 12, 2022 at 4:08 PM Yao Yuan <yaoyuan0329os@gmail.com> wrote:
> >
> > On Fri, Aug 12, 2022 at 12:33:05PM -0700, Jim Mattson wrote:
> > > On Thu, Aug 11, 2022 at 7:02 PM Yuan Yao <yuan.yao@linux.intel.com> wrote:
> > > >
> > > > On Fri, Aug 12, 2022 at 09:47:06AM +0800, Yuan Yao wrote:
> > > > > Add checking to VMCS12's "VMCS shadowing", make sure the checking of
> > > > > VMCS12's vmcs_link_pointer for non-root mode VM{READ,WRITE} happens
> > > > > only if VMCS12's "VMCS shadowing" is 1.
> > > > >
> > > > > SDM says that for non-root mode the VMCS's "VMCS shadowing" must be 1
> > > > > (and the corresponding bits in VMREAD/VMWRITE bitmap must be 0) when
> > > > > condition checking of [B] is reached(please refer [A]), which means
> > > > > checking to VMCS link pointer for non-root mode VM{READ,WRITE} should
> > > > > happen only when "VMCS shadowing" = 1.
> > > > >
> > > > > Description from SDM Vol3(April 2022) Chapter 30.3 VMREAD/VMWRITE:
> > > > >
> > > > > IF (not in VMX operation)
> > > > >    or (CR0.PE = 0)
> > > > >    or (RFLAGS.VM = 1)
> > > > >    or (IA32_EFER.LMA = 1 and CS.L = 0)
> > > > > THEN #UD;
> > > > > ELSIF in VMX non-root operation
> > > > >       AND (“VMCS shadowing” is 0 OR
> > > > >            source operand sets bits in range 63:15 OR
> > > > >            VMREAD bit corresponding to bits 14:0 of source
> > > > >            operand is 1)  <------[A]
> > > > > THEN VMexit;
> > > > > ELSIF CPL > 0
> > > > > THEN #GP(0);
> > > > > ELSIF (in VMX root operation AND current-VMCS pointer is not valid) OR
> > > > >       (in VMX non-root operation AND VMCS link pointer is not valid)
> > > > > THEN VMfailInvalid;  <------ [B]
> > > > > ...
> > > > >
> > > > > Fixes: dd2d6042b7f4 ("kvm: nVMX: VMWRITE checks VMCS-link pointer before VMCS field")
> > > > > Signed-off-by: Yuan Yao <yuan.yao@intel.com>
> > > > > ---
> > > > >  arch/x86/kvm/vmx/nested.c | 2 ++
> > > > >  1 file changed, 2 insertions(+)
> > > > >
> > > > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > > > index ddd4367d4826..30685be54c5d 100644
> > > > > --- a/arch/x86/kvm/vmx/nested.c
> > > > > +++ b/arch/x86/kvm/vmx/nested.c
> > > > > @@ -5123,6 +5123,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
> > > > >                */
> > > > >               if (vmx->nested.current_vmptr == INVALID_GPA ||
> > > > >                   (is_guest_mode(vcpu) &&
> > > > > +                  nested_cpu_has_shadow_vmcs(vcpu) &&
> > > >
> > > > Oops, should be "nested_cpu_has_shadow_vmcs(get_vmcs12(vcpu))".
> > > >
> > > > >                    get_vmcs12(vcpu)->vmcs_link_pointer == INVALID_GPA))
> > > > >                       return nested_vmx_failInvalid(vcpu);
> > > > >
> > > > > @@ -5233,6 +5234,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
> > > > >        */
> > > > >       if (vmx->nested.current_vmptr == INVALID_GPA ||
> > > > >           (is_guest_mode(vcpu) &&
> > > > > +          nested_cpu_has_shadow_vmcs(vcpu) &&
> > > >
> > > > Ditto.
> > > >
> > > > >            get_vmcs12(vcpu)->vmcs_link_pointer == INVALID_GPA))
> > > > >               return nested_vmx_failInvalid(vcpu);
> > > > >
> > > > > --
> > >
> > > These checks are redundant, aren't they?
> > >
> > > That is, nested_vmx_exit_handled_vmcs_access() has already checked
> > > nested_cpu_has_shadow_vmcs(vmcs12).
> >
> > Ah, you're right it does there.
> >
> > That means in L0 we handle this for vmcs12 which has shadow VMCS
> > setting and the corresponding bit in the bitmap is 0(so no vmexit to
> > L1 and the read/write should from/to vmcs12's shadow vmcs, we handle
> > this here to emulate this), so we don't need to check the shdaow VMCS
> > setting here again. Is this the right understanding ?
>
> That is correct.

I got it, Thanks a lot for your correction!

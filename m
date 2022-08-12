Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 221CF591782
	for <lists+kvm@lfdr.de>; Sat, 13 Aug 2022 01:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233675AbiHLXIF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 19:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiHLXID (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 19:08:03 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512AA9BB47;
        Fri, 12 Aug 2022 16:08:02 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id s5-20020a17090a13c500b001f4da9ffe5fso9566112pjf.5;
        Fri, 12 Aug 2022 16:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=MA77FB22CsHjZrR6X2vQKOC69kqSwrUYcyvN+zo/RVo=;
        b=pO5Pmo10KGjGEHIDsDFW62WViUHSjMtROTW9Kr1CGUvRC/iefwJ9lZ91D4fveTkkzY
         v52dvpIzsbZwj9c6WKJ7hlkJCjetGBtgHmTjkgWbxzWuKo9LXzuR15CDCNSPPV9YxfIH
         ahNy6D/Ol9DsKRP51GI8i5L/RgWwEy0YGV1EtN81aTnVIlQWgvEc9CvOUjus/eHGy1m4
         CMZfP9vwfd+CY/tD6zX6LVwVurGVhl/9oDc8ibs94PigZdDHV3xg1HoxwRn1FcwW9ULj
         wL90ht3fE9x00aihUVPjdF0d31uXoq/lchwTtXC7TL1uHORGi9j3MnVAkz4sRJCS7Dn2
         OjSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=MA77FB22CsHjZrR6X2vQKOC69kqSwrUYcyvN+zo/RVo=;
        b=BkvoDkq+YgcpLan1Y4xMuevVc0KHpxrfZ13MM4qRaWJvKtsF1Nf0P/NkpqEyYYqSAZ
         eusnJ2GLcgb1YJo7AGzhCvn4Z4h3JsUel460nTXJR7u7piD+HRPbiTZ0f3Zm+UUlniO1
         SOFh5YRoXfDn15pt/5NV9V+2763DJvgrnf7tWNmV9Mfxk/5SqIz9cgLxgsFG2dNRIezi
         nbg5gYyz9qnR/KRl+dNfopVblJMSEzKgFpK0RDubtMmHWRsR08VJY4MtSDr/ImWz50HQ
         aO4bjgrTxbWLUDc0fyPD6BNWnhIK+ZilCkT0Oi5gZTIsIWzXYWi0/llgV8MAmFizjGAj
         z31Q==
X-Gm-Message-State: ACgBeo0ROCcqp57T4YMQHae6G5WKxyfNL9bHFi1uT9zT4yxrllTg50kl
        TDMIfQkg9r0Y9/5Z+JIC3iTW24abDmQ=
X-Google-Smtp-Source: AA6agR5MjNtajWKEUmawCaSFcb7nYBg8H+bVqaG6S5LwHkulS7A09v24Zr2yFtqiDrtb2qZ5oNogag==
X-Received: by 2002:a17:90b:1e0f:b0:1f5:37f5:159c with SMTP id pg15-20020a17090b1e0f00b001f537f5159cmr6389785pjb.189.1660345681801;
        Fri, 12 Aug 2022 16:08:01 -0700 (PDT)
Received: from localhost ([74.211.107.8])
        by smtp.gmail.com with ESMTPSA id q16-20020aa79830000000b0052d36feb7fcsm2132748pfl.198.2022.08.12.16.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 16:08:01 -0700 (PDT)
Date:   Sat, 13 Aug 2022 07:07:58 +0800
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
Message-ID: <20220812230758.bkpukdocsflxxrru@sapienza>
References: <20220812014706.43409-1-yuan.yao@intel.com>
 <20220812020206.foknky4hghgsadby@yy-desk-7060>
 <CALMp9eRejAUVzFOsASBc-Md8KUeS1mzqOm9WCJ9dBFkc_NeOJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eRejAUVzFOsASBc-Md8KUeS1mzqOm9WCJ9dBFkc_NeOJg@mail.gmail.com>
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 12, 2022 at 12:33:05PM -0700, Jim Mattson wrote:
> On Thu, Aug 11, 2022 at 7:02 PM Yuan Yao <yuan.yao@linux.intel.com> wrote:
> >
> > On Fri, Aug 12, 2022 at 09:47:06AM +0800, Yuan Yao wrote:
> > > Add checking to VMCS12's "VMCS shadowing", make sure the checking of
> > > VMCS12's vmcs_link_pointer for non-root mode VM{READ,WRITE} happens
> > > only if VMCS12's "VMCS shadowing" is 1.
> > >
> > > SDM says that for non-root mode the VMCS's "VMCS shadowing" must be 1
> > > (and the corresponding bits in VMREAD/VMWRITE bitmap must be 0) when
> > > condition checking of [B] is reached(please refer [A]), which means
> > > checking to VMCS link pointer for non-root mode VM{READ,WRITE} should
> > > happen only when "VMCS shadowing" = 1.
> > >
> > > Description from SDM Vol3(April 2022) Chapter 30.3 VMREAD/VMWRITE:
> > >
> > > IF (not in VMX operation)
> > >    or (CR0.PE = 0)
> > >    or (RFLAGS.VM = 1)
> > >    or (IA32_EFER.LMA = 1 and CS.L = 0)
> > > THEN #UD;
> > > ELSIF in VMX non-root operation
> > >       AND (“VMCS shadowing” is 0 OR
> > >            source operand sets bits in range 63:15 OR
> > >            VMREAD bit corresponding to bits 14:0 of source
> > >            operand is 1)  <------[A]
> > > THEN VMexit;
> > > ELSIF CPL > 0
> > > THEN #GP(0);
> > > ELSIF (in VMX root operation AND current-VMCS pointer is not valid) OR
> > >       (in VMX non-root operation AND VMCS link pointer is not valid)
> > > THEN VMfailInvalid;  <------ [B]
> > > ...
> > >
> > > Fixes: dd2d6042b7f4 ("kvm: nVMX: VMWRITE checks VMCS-link pointer before VMCS field")
> > > Signed-off-by: Yuan Yao <yuan.yao@intel.com>
> > > ---
> > >  arch/x86/kvm/vmx/nested.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > index ddd4367d4826..30685be54c5d 100644
> > > --- a/arch/x86/kvm/vmx/nested.c
> > > +++ b/arch/x86/kvm/vmx/nested.c
> > > @@ -5123,6 +5123,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
> > >                */
> > >               if (vmx->nested.current_vmptr == INVALID_GPA ||
> > >                   (is_guest_mode(vcpu) &&
> > > +                  nested_cpu_has_shadow_vmcs(vcpu) &&
> >
> > Oops, should be "nested_cpu_has_shadow_vmcs(get_vmcs12(vcpu))".
> >
> > >                    get_vmcs12(vcpu)->vmcs_link_pointer == INVALID_GPA))
> > >                       return nested_vmx_failInvalid(vcpu);
> > >
> > > @@ -5233,6 +5234,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
> > >        */
> > >       if (vmx->nested.current_vmptr == INVALID_GPA ||
> > >           (is_guest_mode(vcpu) &&
> > > +          nested_cpu_has_shadow_vmcs(vcpu) &&
> >
> > Ditto.
> >
> > >            get_vmcs12(vcpu)->vmcs_link_pointer == INVALID_GPA))
> > >               return nested_vmx_failInvalid(vcpu);
> > >
> > > --
>
> These checks are redundant, aren't they?
>
> That is, nested_vmx_exit_handled_vmcs_access() has already checked
> nested_cpu_has_shadow_vmcs(vmcs12).

Ah, you're right it does there.

That means in L0 we handle this for vmcs12 which has shadow VMCS
setting and the corresponding bit in the bitmap is 0(so no vmexit to
L1 and the read/write should from/to vmcs12's shadow vmcs, we handle
this here to emulate this), so we don't need to check the shdaow VMCS
setting here again. Is this the right understanding ?

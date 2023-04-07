Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4E46DB511
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 22:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjDGUQu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 16:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjDGUQt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 16:16:49 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14647CA0E
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 13:16:15 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1a275cc7051so891545ad.2
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 13:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680898565;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mde69Hj9R/KQCpYyhqUMxlQ7MljgYq9pFkGZMMmzCdQ=;
        b=HWNa+X4Kboqth/qpv+qGP7/6SEJWlFOhUaG6+9Ea2pmfHn5mFek2OPQTAPu4ZX8ez1
         2wVx0MGKzRVJXcROgp7Qy3FbPTaqyflsyNUD06xDFNi7SIb1yy7he4jC8zcAYwce2Znw
         F48RpjdVJ3yrWDIYwbBhLEajtPgmqnb9dNwqvwJ8zcEurcpxh1+D9fZy/9JLsdt/EDtO
         3lF/beXBy8uDU30xeaBYyLMgQTLYCxe4ouqj9tqEKzJtHkCYab1jQtbBRyOXvPRr4Oxc
         m9en16kignQDffLXFU25jxJ74OwCr/MZkUc0xmh8XBAv7QqrtMMvjH6nkBRKYnZ4+Yhv
         spfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680898565;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mde69Hj9R/KQCpYyhqUMxlQ7MljgYq9pFkGZMMmzCdQ=;
        b=tWlotJQTs4avAuQnpwMvb60QsDhX3EAZyBHkM85UpjQCqFuOigqyCyAsQAnrLo+cHv
         8+XPFpqOnk7gMbjmez+bMRj+5V3wJbYDawge0iikayYaqQhxSOqGA1IlyOtWbS2POhxo
         PTO19NnTYVVbYukLCR7PQYmvonpD1/G3rnK1XQplj+wfPg9GAixG2J3u3SKT6YUCsSb7
         RNIQksv89UtN7CGlPcEVIA6m3chgYswJ0slm0tg64rtYVjsyjiXdKSQTUyyqpZjgoNJ6
         nJlWtdPHSNxN2EGFUJoWR75edjI8huOQBs+j/pwjV2vRHVHm/pDhS29+wHW41zoohLtv
         I07A==
X-Gm-Message-State: AAQBX9cMP2EMMgwCbWRwqLGvIdMWb9OU0/sULQYJ7i7DRgPJzLubeXwU
        f6/9yiqqnJvVFPC6/Fl2/HtHL5bFYqg=
X-Google-Smtp-Source: AKy350Y3weNQUsTbtpYXqwtEFj8XZzaGb4a9EvD8AbYueIwoAedZa/dzxiMIlNG5a+N/7oHVS8QRLsj2jr0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:b41:b0:62d:934e:6ef8 with SMTP id
 p1-20020a056a000b4100b0062d934e6ef8mr1710893pfo.5.1680898565263; Fri, 07 Apr
 2023 13:16:05 -0700 (PDT)
Date:   Fri, 7 Apr 2023 13:16:03 -0700
In-Reply-To: <684ad799-8247-9d2a-2eed-c8cb08e96633@intel.com>
Mime-Version: 1.0
References: <SA1PR11MB673463616F7B1318874D11A3A8909@SA1PR11MB6734.namprd11.prod.outlook.com>
 <684ad799-8247-9d2a-2eed-c8cb08e96633@intel.com>
Message-ID: <ZDB6A00xskB+adzu@google.com>
Subject: Re: The necessity of injecting a hardware exception reported in VMX
 IDT vectoring information
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Xin3 Li <xin3.li@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Yuan Yao <yuan.yao@intel.com>,
        Eddie Dong <eddie.dong@intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jun Nakajima <jun.nakajima@intel.com>,
        "H.Peter Anvin" <hpa@zytor.com>,
        Asit K Mallick <asit.k.mallick@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 07, 2023, Xiaoyao Li wrote:
> On 4/5/2023 5:34 PM, Li, Xin3 wrote:
> > The VMCS IDT vectoring information field is used to report basic information
> > associated with the event that was being delivered when a VM exit occurred.
> > such an event itself doesn't trigger a VM exit, however, a condition to deliver
> > the event is not met, e.g., EPT violation.
> > 
> > When the IDT vectoring information field reports a maskable external interrupt,
> > KVM reinjects this external interrupt after handling the VM exit. Otherwise,
> > the external interrupt is lost.
> > 
> > KVM handles a hardware exception reported in the IDT vectoring information
> > field in the same way, which makes nothing wrong. This piece of code is in
> > __vmx_complete_interrupts():
> > 
> >          case INTR_TYPE_SOFT_EXCEPTION:
> >                  vcpu->arch.event_exit_inst_len = vmcs_read32(instr_len_field);
> >                  fallthrough;
> >          case INTR_TYPE_HARD_EXCEPTION:
> >                  if (idt_vectoring_info & VECTORING_INFO_DELIVER_CODE_MASK) {
> >                          u32 err = vmcs_read32(error_code_field);
> >                          kvm_requeue_exception_e(vcpu, vector, err);
> >                  } else
> >                          kvm_requeue_exception(vcpu, vector);
> >                  break;
> > 
> > But if KVM just ignores any hardware exception in such a case, the CPU will
> > re-generate it once it resumes guest execution, which looks cleaner.
> > 
> > The question is, must KVM inject a hardware exception from the IDT vectoring
> > information field? Is there any correctness issue if KVM does not?
> 
> Say there is a case that, a virtual interrupt arrives when an exception is
> delivering but hit EPT VIOLATION. The interrupt is pending and recorded in
> RVI.
> - If KVM re-injects the exception on next VM entry, IDT vectoring first
> vectors exception handler and at the instruction boundary (before the first
> instruction of exception handler) to deliver the virtual interrupt (if
> allowed)
> - If KVM doesn't re-inject the exception but relies on the re-execution of
> the instruction, then the virtual interrupt can be recognized and delivered
> before the instruction causes the exception.
> 
> I'm not sure if the order of events matters or not.

It matters, e.g. if the exception occurs in an STI shadow then I believe the vIRQ
would get incorrectly delivered in the STI shadow.  That'll likely happen anyways
after the resulting IRET, but there's no guarantee the guest's exception handler
will IRET, or that it will even run, e.g. guest might triple fault first.

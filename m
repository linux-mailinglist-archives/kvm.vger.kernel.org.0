Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E574976D760
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 21:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjHBTES (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 15:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjHBTER (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 15:04:17 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1D62129
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 12:04:16 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bb8f751372so1686465ad.0
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 12:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691003055; x=1691607855;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ikYXa8mOFQDZbREjRJ8peh9ZkNJ1cnl6br63JB4vnx4=;
        b=NFWOMN10g/JUtUfNdt5wuiKKHUMDEQSw15FPK2CXKLbgVy0j6AyiBm8M+GD2V/9BsU
         e9OVtc57b90J4vIjnxWJt4PQ43IO72q6PcLQ5f2FDGbvKfMoXBD/gZ+OzunW6HP1wbfK
         WeGIG2/xnjG8jCuyBX+r0ZweTjcBWPF5jwoOtB9I77/3loebH3mojxg09s/yEuUylivn
         lGcuEI1l4AHl4Y5DLG2CaiWnZsnz7oNkygK8YfxTYLTPfbaSLtkYPg1VqTbdG6pjDayP
         Wk6PMCPh01WT0HcPceAUQ67f4iK4u8MwB0HqXCo+uWfOLG1RdTwP9cScsWpdWSZjfEPt
         aGfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691003055; x=1691607855;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ikYXa8mOFQDZbREjRJ8peh9ZkNJ1cnl6br63JB4vnx4=;
        b=G/1dy4SAhHnPhE+Mtv7YSCN/IIn13dhOr48aY74INIfummP+h1wfhmlaEFR/d2UKlX
         9qVPypf1Iwz+gNSg6gbgvaQWEFr1MiqCGQc4kztie6gwbzUSMTMq2puoL4ldaGfr7js+
         i3wLAzySNfhcYI7/K1JvTCAbP6QflPR97/IPQopWRu9Zdp3WtHeog7jk6QrfeG5DIoXg
         756cNerx3nQ+zpi4pdwL5Tbbyot4GUgiCxLZPXY8bESca1UYt3npxbQKXHMCa7REwzY3
         1807/gY/33pI+FEysioUzF12PmfTti6MO/XKuNN5HTAiit6jyo3HM3P5XuVBYeCf4eow
         29VA==
X-Gm-Message-State: ABy/qLZ/TiipRXnaBTnop4UmtSz5GBKjXKr61Nt/VmjhnQ2IV+x7Km7b
        ov29UUW6vZRXnW6UUXJfnYk+0Pasfco=
X-Google-Smtp-Source: APBJJlHCJjgZtPFZR17JiLtVe6z5T7rY0lrHPA5nBV8Wciu9MdW1wNKz/CpXGwhYO9h4Ql0UKZnVk4wbcP8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:230a:b0:1af:f80f:185d with SMTP id
 d10-20020a170903230a00b001aff80f185dmr103405plh.4.1691003055448; Wed, 02 Aug
 2023 12:04:15 -0700 (PDT)
Date:   Wed, 2 Aug 2023 12:04:13 -0700
In-Reply-To: <6bc819fd-18e4-8472-be7d-14db6e059e9a@cs.utexas.edu>
Mime-Version: 1.0
References: <7b5f626c-9f48-15e2-8f7a-1178941db048@cs.utexas.edu>
 <ZMFVLiC3YvPY3bSP@google.com> <27f998f5-748b-c356-9bb6-813573c758e5@cs.utexas.edu>
 <ZMF5O6Tq1UTQHvX0@google.com> <7d4a5084-5e1e-22dd-c203-99f46850145a@cs.utexas.edu>
 <ZMKg5WosmBu78Vgv@google.com> <6bc819fd-18e4-8472-be7d-14db6e059e9a@cs.utexas.edu>
Message-ID: <ZMqorSAyFWWTwq5Q@google.com>
Subject: Re: KVM_EXIT_FAIL_ENTRY with hardware_entry_failure_reason = 7
From:   Sean Christopherson <seanjc@google.com>
To:     Yahya Sohail <ysohail@cs.utexas.edu>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 28, 2023, Yahya Sohail wrote:
> 
> On 7/27/23 11:52, Sean Christopherson wrote:
> > Enable /sys/module/kvm_intel/parameters/dump_invalid_vmcs, then KVM will print
> > out most (all?) VMCS fields on the failed VM-Entry.  From there you'll have to
> > hunt through guest state to figure out which fields, or combinations of fields,
> > is invalid.
> 
> I get the following output in my log:
> *** Guest State ***
> CR0: actual=0x0000000080000031, shadow=0x00000000e0000011,
> gh_mask=fffffffffffffff7
> CR4: actual=0x0000000000002060, shadow=0x0000000000000020,
> gh_mask=fffffffffffef871
> CR3 = 0x0000000010000000
> PDPTR0 = 0x0000000000000000  PDPTR1 = 0x0000000000000000
> PDPTR2 = 0x0000000000000000  PDPTR3 = 0x0000000000000000
> RSP = 0x0000000002000031  RIP = 0x0000000000103c00
> RFLAGS=0x00000002         DR7 = 0x0000000000000400
> Sysenter RSP=0000000000000000 CS:RIP=0000:0000000000000000
> CS:   sel=0x0010, attr=0x0a09b, limit=0x000fffff, base=0x0000000000000000
> DS:   sel=0x0018, attr=0x08093, limit=0x000fffff, base=0x0000000000000000
> SS:   sel=0x0018, attr=0x08093, limit=0x000fffff, base=0x0000000000000000
> ES:   sel=0x0018, attr=0x08093, limit=0x000fffff, base=0x0000000000000000
> FS:   sel=0x0000, attr=0x10001, limit=0x00000000, base=0x0000000000000000
> GS:   sel=0x0000, attr=0x10001, limit=0x00000000, base=0x0000000000000000
> GDTR:                           limit=0x00001031, base=0x001f000000000200

The GDT base is non-canonical, that's likely the direct source of the consistency
check.  

> LDTR: sel=0x0000, attr=0x10000, limit=0x000003e8, base=0x000003e8000081a4
> IDTR:                           limit=0x00000000, base=0x0000000000000000
> TR:   sel=0x0000, attr=0x10021, limit=0x01211091, base=0x0000000000010304
> EFER =     0x0000000000000500  PAT = 0x0007040600070406
> DebugCtl = 0x0000000000000000  DebugExceptions = 0x0000000000000000
> BndCfgS = 0x0000000000000000
> Interruptibility = 00000000  ActivityState = 00000000
> *** Host State ***
> RIP = 0xffffffffc09a444f  RSP = 0xffffa3aa0d2fbd50
> CS=0010 SS=0018 DS=0000 ES=0000 FS=0000 GS=0000 TR=0040
> FSBase=00007feb463e9740 GSBase=ffff93bb3dd80000 TRBase=fffffe000033d000
> GDTBase=fffffe000033b000 IDTBase=fffffe0000000000
> CR0=0000000080050033 CR3=0000000547886004 CR4=00000000007726e0
> Sysenter RSP=fffffe000033d000 CS:RIP=0010:ffffffff910016e0
> EFER = 0x0000000000000d01  PAT = 0x0407050600070106
> *** Control State ***
> PinBased=0000007f CPUBased=b5986dfa SecondaryExec=00032ce2
> EntryControls=0001d3ff ExitControls=00abefff
> ExceptionBitmap=00060042 PFECmask=00000000 PFECmatch=00000000
> VMEntry: intr_info=80000044 errcode=00000000 ilen=00000000
> VMExit: intr_info=00000000 errcode=00000000 ilen=00000000
>         reason=80000021 qualification=0000000000000000
> IDTVectoring: info=00000000 errcode=00000000
> TSC Offset = 0xfffda9968024bdbc
> EPT pointer = 0x0000000103f1905e
> PLE Gap=00000080 Window=00001000
> Virtual processor ID = 0x0021
> 
> For the control registers, the value I set is shown as shadow not actual.
> What does that mean?

The "shadow" is what the guest sees, the "actual" value is what is loaded in
hardware.  VMX virtualization of CR0 and CR4, through a combination of VMCS fields
(actual + shadow + gh_mask in the above terminology), effectively allows intercepting
writes to individual CR0 and CR4 bits, and entirely avoids VM-Exits on read from
CR0/CR4.

Copying from the SDM:

  MOV from CR4. The behavior of MOV from CR4 is determined by the CR4 guest/host
  mask and the CR4 read shadow. For each position corresponding to a bit clear in
  the CR4 guest/host mask, the destination operand is loaded with the value of the
  corresponding bit in CR4. For each position corresponding to a bit set in the CR4
  guest/host mask, the destination operand is loaded with the value of the corresponding
  bit in the CR4 read shadow. Thus, if every bit is cleared in the CR4 guest/host
  mask, MOV from CR4 reads normally from CR4; if every bit is set in the CR4 guest/host
  mask, MOV from CR4 returns the value of the CR4 read shadow.  Depending on the
  contents of the CR4 guest/host mask and the CR4 read shadow, bits may be set in the
  destination that would never be set when reading directly from CR4.

 ...

  MOV to CR4. An execution of MOV to CR4 that does not cause a VM exit (see Section
  26.1.3) leaves unmodified any bit in CR4 corresponding to a bit set in the CR4
  guest/host mask. Such an execution causes a general-protection exception if it
  attempts to set any bit in CR4 (not corresponding to a bit set in the CR4
  guest/host mask) to a value not supported in VMX operation (see Section 24.8).

> Additionally, I consulted the Intel manual for the meaning of the 0x80000021
> error code, and it appears it is caused by not meeting one or more of the
> requirements for guest state set in Volume 3 Section 27.3.1 of the Intel
> manual.

Yep.

> I noticed that there are certain requirements for tr and ldtr
> registers even though they are not really used in IA-32e mode (see Volume 3
> Section 27.3.1.2). I've tried setting them as follows to meet those
> requirements, but that didn't seem to do anything:
>   state->sregs.tr.type = 0b11;
>   state->sregs.tr.s = 0;
>   state->sregs.tr.present = 1;
>   state->sregs.tr.g = 1;
>   state->sregs.tr.limit = 0xFFFFF;
>   state->sregs.tr.unusable = 0;
>   state->sregs.tr.selector = 0b100;
>   state->sregs.ldt.unusable = 1;
> 
> Does that look correct?

Maybe?  Sorry, I've essentially exhausted my bandwidth for helping this along
beyond quick comments.

> I suppose my best course of action now is to go through each check in Volume
> 3 Section 27.3.1 and check each one individually.



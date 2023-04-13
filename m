Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45B656E17A8
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 00:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjDMWsI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 18:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjDMWsG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 18:48:06 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6BA171F
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 15:48:05 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id h8-20020a170902f54800b001a1f5f00f3fso8806752plf.2
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 15:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681426085; x=1684018085;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7De+TR6k41slfMO+agxwSRrezzAt0xmZupWS+SIbKtw=;
        b=wripiq38optx0A61pEC4QlxbrXV9310O1yzg1yey6FDBM3X/3bgYqN6lxWXAho4x2Z
         b6b8/UzbX9j9h1jSPKzj89XyFovpOpw/PUeQ+0GvEyzDHVuB9wwO+dRPlFUrwpcPIhI7
         ZKFw3DZ6ofccfo/zAQ44f4r2Rnwpb31HNbaYHWZM7/iPJ8BqRh4jIGV4uQ+CkeOUZdg3
         u48pLtetbVssXKzdARwdPIHvlDYgsEuJYGdtXo6rIARliioKNY1De8ejJNY0TMvYlSp8
         h9hcvepeqxGnrQjEb7GXmqTSAyAJ2JP9Q5UDMfqYZgFhQHMz1CjlVzVpjKCaNG57B1z6
         wPYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681426085; x=1684018085;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7De+TR6k41slfMO+agxwSRrezzAt0xmZupWS+SIbKtw=;
        b=P2AWWpWsr2ny4coNz0fQxb0/xLe8AF/Tk+UdDICWghdL4SizVfWjH8cwUUstZK5jLO
         ZHnHjKSDH0zfS002q9bDxkG6ka+d6hXC1xp3YLlCB35Wdf0mWF+tABT7dHu4Wdr/PsbM
         JhNEsfMlQrHlB3putKdsxzKjq6Rx14KXqRzHqzVSU9O6Qo78X7Ed6LLMCM7Gyv8yTEq9
         SxMsz3V0X2qiXzzBhAdbweNGqFMJDMTv2b2EvO8MM8gyS/sNCqEHoIiAi0V3anbQkqxu
         XNktE8pIcgAWMNlZQcybw2BxsibhOUCgK6KjMWtsbVFrMBr3H6V9nyfrmY+dMbVJV220
         AJhA==
X-Gm-Message-State: AAQBX9fDpMToLKOQN0cJ1tGVlHp9/9OJgb18YBjZT3YSgnvgIk9KW91o
        USG8FEo9cJESzKmG8rfUss4PxSWzp6g=
X-Google-Smtp-Source: AKy350b/OBsmKfKzcv0b+1digNdsex0QQ/cOy6US20y18DtoSSeFH/BrW0XfTLmwilEqK6wAU2/PGGYKlM4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:25d3:b0:1a4:f282:91c7 with SMTP id
 jc19-20020a17090325d300b001a4f28291c7mr216045plb.6.1681426085409; Thu, 13 Apr
 2023 15:48:05 -0700 (PDT)
Date:   Thu, 13 Apr 2023 15:48:04 -0700
In-Reply-To: <ae28ce9b0c78a926c38a8c8b9694aa34b140b467.camel@intel.com>
Mime-Version: 1.0
References: <20230405005911.423699-1-seanjc@google.com> <d0af618169ebc17722e7019ca620ec22ee0b49c3.camel@intel.com>
 <ZC4qF90l77m3X1Ir@google.com> <20230406130119.000011fe.zhi.wang.linux@gmail.com>
 <e1e7a37a29c2c7ad22cd14181f24b06088eca451.camel@intel.com>
 <ZDbMuZKhAUbrkrc7@google.com> <ae28ce9b0c78a926c38a8c8b9694aa34b140b467.camel@intel.com>
Message-ID: <ZDiGpCkXOcCm074O@google.com>
Subject: Re: [PATCH 0/3] KVM: x86: SGX vs. XCR0 cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 13, 2023, Kai Huang wrote:
> On Wed, 2023-04-12 at 08:22 -0700, Sean Christopherson wrote:
> > KVM's uAPI for initiating TDH.MNG.INIT could obviously filter out
> > unsupported leafs, but doing so would lead to potential ABI breaks, e.g. if a leaf
> > that KVM filters out becomes known to the TDX Module, then upgrading the TDX Module
> > could result in previously allowed input becoming invalid.
> 
> How about only filtering out PV related CPUIDs when applying CPUIDs to
> TDH.MNG.INIT?  I think we can assume they are not gonna be known to TDX module
> anyway.

Nope, not going down that road.  Fool me once[*], shame on you.  Fool me twice,
shame on me :-)

Objections to hardware vendors defining PV interfaces aside, there exist leafs
that are neither PV related nor known to the TDX module, e.g. Centaur leafs.  I
think it's extremely unlikely (understatement) that anyone will want to expose
Centaur leafs to a TDX guest, but again I want to say out of the business of
telling userspace what is and isn't sane CPUID models.

[*] https://lore.kernel.org/all/20221210160046.2608762-6-chen.zhang@intel.com

> > Even if that weren't the case, ignoring KVM_SET_CPUID{2} would be a bad option
> > becuase it doesn't allow KVM to open behavior in the future, i.e. ignoring the
> > leaf would effectively make _everything_ valid input.  If KVM were to rely solely
> > on TDH.MNG.INIT, then KVM would want to completely disallow KVM_SET_CPUID{2}.
> 
> Right.  Disallowing SET_CPUID{2} probably is better, as it gives userspace a
> more concrete result.  
> 
> > 
> > Back to Zhi's question, the best thing to do for TDX and SNP is likely to require
> > that overlap between KVM_SET_CPUID{2} and the "trusted" CPUID be consistent.  The
> > key difference is that KVM would be enforcing consistency, not sanity.  I.e. KVM
> > isn't making arbitrary decisions on what is/isn't sane, KVM is simply requiring
> > that userspace provide a CPUID model that's consistent with what userspace provided
> > earlier.
> 
> So IIUC, you prefer to verifying the CPUIDs in SET_CPUID{2} are a super set of
> the CPUIDs provided in TDH.MNG.INIT?  And KVM manually verifies all CPUIDs for
> all vcpus are consistent (the same) in SET_CPUID{2}?

Yes, except KVM doesn't need to verify vCPUs are consistent with respect to each
other, just that each vCPU is consistent with respect to what was reported to the
TDX Module.

> Looks this is over-complicated, _if_ the "only filtering out PV related CPUIDs
> when applying CPUIDs to TDH.MNG.INIT" approach works. 

It's not complicated at all.  Walk through the leafs defined during TDH.MNG.INIT,
reject KVM_SET_CPUID if a leaf isn't present or doesn't match exactly.  Or has
the TDX spec changed and it's no longer that simple?

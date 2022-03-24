Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 973284E682F
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 18:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352405AbiCXR65 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 13:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231939AbiCXR64 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 13:58:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D98F4B6D10
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 10:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648144643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0KyPnx9P3z1WhpooutB0EWjArZTXhHvBHQ9WNGY1u90=;
        b=BwE6WF+w76Z9bTq1rP7Q+dojvIIgGHHJ8dSdb+DGkjoYgujufkAvyx75iep6wt/QO7xp4+
        fzkbfpEH49GR1qZKJPV9cPTheZAnFcoGN5sZ62ouktykVX9GJ3MUfmfoX0yTXE+H/BmdEE
        /cnBvo6j6b175rgks27dkq66U5VcMww=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-xLAvyp1uN2qYK4H2zI0YAg-1; Thu, 24 Mar 2022 13:57:21 -0400
X-MC-Unique: xLAvyp1uN2qYK4H2zI0YAg-1
Received: by mail-ed1-f69.google.com with SMTP id i22-20020a508716000000b0041908045af3so3451375edb.3
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 10:57:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0KyPnx9P3z1WhpooutB0EWjArZTXhHvBHQ9WNGY1u90=;
        b=yr1ZiQrTNR39bmMDPjMOaRLd3BbqURNzZCfj9n8UIaySkYWFx8u/i4zfknRd3gJKou
         q8ADy6en0daSWBtvAAJYWT1IYHpBmfvodcSBtouRm7CWJyk4Qq6ZRSSZJJDRlPznZZ2W
         aYd/C7d9AgK9c7AldVWItg+43j1QNRw9LoyRXdGVDaVupwOadQ0O6or0NdwB983uUXb/
         Lsy9QjaACHPQHp1PuTySzs7JfpMqjSP/w7iQaC0exngpBlZejArNxDowL6Ra1MXn0Xt2
         5c8A6hARwp28nKrhICnrdydqi5OZMWFViMoite9kRDWenvbLoDnSjoAabfCFaCeYAb7A
         N8xg==
X-Gm-Message-State: AOAM530pVGeAuzKTVWRxgyCUl/gJeQskgBe5C/LHxvyZSwjWrP5U8ivI
        ihnhDKtw6M3xqdgzPGWLCTsww7RL6h5e/qdccJmSviXf51TuMypTQAZkw8VZeZuTHhL6lwgXGUo
        KOcUS7vhuPB4Z
X-Received: by 2002:a17:907:94cd:b0:6d9:89e1:3036 with SMTP id dn13-20020a17090794cd00b006d989e13036mr6927564ejc.231.1648144640296;
        Thu, 24 Mar 2022 10:57:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwL2PFG+P0I5eAhQK9XMCqLZ3rXRd+ObJNHEDLlJveGeMtjGrOYYt4YVAH7zCYZm7r8e6O94Q==
X-Received: by 2002:a17:907:94cd:b0:6d9:89e1:3036 with SMTP id dn13-20020a17090794cd00b006d989e13036mr6927546ejc.231.1648144640065;
        Thu, 24 Mar 2022 10:57:20 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id hr13-20020a1709073f8d00b006dfcc331a42sm1373629ejc.203.2022.03.24.10.57.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Mar 2022 10:57:19 -0700 (PDT)
Message-ID: <2a438f7c-4dea-c674-86c0-9164cbad0813@redhat.com>
Date:   Thu, 24 Mar 2022 18:57:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 1/2] KVM: x86: Allow userspace to opt out of hypercall
 patching
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>,
        Peter Shier <pshier@google.com>
References: <20220316005538.2282772-1-oupton@google.com>
 <20220316005538.2282772-2-oupton@google.com> <Yjyt7tKSDhW66fnR@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yjyt7tKSDhW66fnR@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/24/22 18:44, Sean Christopherson wrote:
> On Wed, Mar 16, 2022, Oliver Upton wrote:
>> KVM handles the VMCALL/VMMCALL instructions very strangely. Even though
>> both of these instructions really should #UD when executed on the wrong
>> vendor's hardware (i.e. VMCALL on SVM, VMMCALL on VMX), KVM replaces the
>> guest's instruction with the appropriate instruction for the vendor.
>> Nonetheless, older guest kernels without commit c1118b3602c2 ("x86: kvm:
>> use alternatives for VMCALL vs. VMMCALL if kernel text is read-only")
>> do not patch in the appropriate instruction using alternatives, likely
>> motivating KVM's intervention.
>>
>> Add a quirk allowing userspace to opt out of hypercall patching.
> 
> A quirk may not be appropriate, per Paolo, the whole cross-vendor thing is
> intentional.
> 
> https://lore.kernel.org/all/20211210222903.3417968-1-seanjc@google.com

It's intentional, but the days of the patching part are over.

KVM should just call emulate_hypercall if called with the wrong opcode 
(which in turn can be quirked away).  That however would be more complex 
to implement because the hypercall path wants to e.g. inject a #UD with 
kvm_queue_exception().

All this makes me want to just apply Oliver's patch.

>> +	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_FIX_HYPERCALL_INSN)) {
>> +		ctxt->exception.error_code_valid = false;
>> +		ctxt->exception.vector = UD_VECTOR;
>> +		ctxt->have_exception = true;
>> +		return X86EMUL_PROPAGATE_FAULT;
> 
> This should return X86EMUL_UNHANDLEABLE instead of manually injecting a #UD.  That
> will also end up generating a #UD in most cases, but will play nice with
> KVM_CAP_EXIT_ON_EMULATION_FAILURE.

Hmm, not sure about that.  This is not an emulation failure in the sense 
that we don't know what to do.  We know that for this x86 vendor the 
right thing to do is to growl at the guest.

KVM_CAP_EXIT_ON_EMULATION_FAILURE would not have a way to ask KVM to 
invoke the hypercall, anyway, so it's not really possible for userspace 
to do the emulation.

Paolo


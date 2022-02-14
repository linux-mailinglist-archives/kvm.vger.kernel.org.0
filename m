Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C934B583D
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 18:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356958AbiBNROl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 12:14:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349525AbiBNROj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 12:14:39 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6EF36517B
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 09:14:31 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id y9so15211955pjf.1
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 09:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=auHdDKcE/HC+BDwZpCPvw9X/g5EzgIbYvOhoHY8/cJY=;
        b=JbvD4yatDBiI12WQDdeOK5f0z8ngSNl6pVxPJJnhEgNasmDkLcTlLZcpmzyfzAlJFa
         MetFFN9apMVPRUdfITZo7Euk4O4YzfwoPU+M2d0VQhg/3e+RF4PfjKj8SBcERdDVFUxo
         kYTP8O8GVkrjlu0Z2kYe6W1ZkVCOLGGcBuJ8WU/8CiCXyFP+pGT3zZXNmQlTEp2+9LNc
         uCtfng0MRDpXhl7s8DCo4+MPagjhhfH0v4HLXgkx/9LBDqXT6P7PuRTUGtd9usCULgyk
         ILDKui5NWOzFiO8twcW5SPuMKuaoDwaunCs6x6QkEh4np2NzN7uwC1YUcjtDfeplP+ej
         DByg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=auHdDKcE/HC+BDwZpCPvw9X/g5EzgIbYvOhoHY8/cJY=;
        b=dM574nEn2iv5aNgVTry8Cz6RjCGIazGOZN1utqjqbJf71bMUR8vsP3NFjqLiOIiQg+
         mgEcy1JkUW5+d8mT7SQa+KC+O1eyZpFlsTEXoLX7CANmEYeXhCbPvAEGyY8IsG0yuzrR
         JZjCy99wTi0KJSwgiy6ZvFhy9vHlJ1TsAa2rVee0hakv8o9fMJ5Ce60QTVi5b6zqeMog
         n+h4A3xPG3qthQjCwd0RrKXs0vFXw9tPuxYq30z5TLkwWP1hlO7Yc6wUW6JBI/Euy0+s
         z6DVgY/F+1qgY1zHGvnHP9fv2iO1Lp/8Eqe7AIQM25I7100et+0UMxWo++pUaY3odXfT
         k9tg==
X-Gm-Message-State: AOAM532cBewodDS2c2H/1avpogrY5hUUwEhwpW8lKCWIcVFKSUoZfmSC
        cxviH8od6wUXFKl5QkKbIuICow==
X-Google-Smtp-Source: ABdhPJzdzHWiOyC2Kri7/kYcALouqtq1nTXz3EXMpUbYNwNQVqhhju24GuUtyviHjqlDyupx7DWUlA==
X-Received: by 2002:a17:90b:1d84:: with SMTP id pf4mr6833277pjb.124.1644858871225;
        Mon, 14 Feb 2022 09:14:31 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k9sm34903413pfi.134.2022.02.14.09.14.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 09:14:30 -0800 (PST)
Date:   Mon, 14 Feb 2022 17:14:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Woodhouse, David" <dwmw@amazon.co.uk>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: Don't actually set a request when evicting vCPUs
 for GFN cache invd
Message-ID: <YgqN87rqc/vogbFE@google.com>
References: <d79aacb5-9069-4647-9332-86f7d74b747a@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d79aacb5-9069-4647-9332-86f7d74b747a@email.android.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 12, 2022, Woodhouse, David wrote:
> 
> (Apologies if this is HTML but I'm half-way to Austria and the laptop is
> buried somewhere in the car, and access to work email with sane email apps is
> difficult.)
> 
> On 12 Feb 2022 03:05, Sean Christopherson <seanjc@google.com> wrote:
> 
> Don't actually set a request bit in vcpu->requests when making a request
> purely to force a vCPU to exit the guest.  Logging the request but not
> actually consuming it causes the vCPU to get stuck in an infinite loop
> during KVM_RUN because KVM sees a pending request and bails from VM-Enter
> to service the request.
> 
> 
> Right, but there is no extant code which does this. The guest_uses_pa flag is
> unused.

Grr.  A WARN or something would have been nice to have.  Oh well.

> The series came with a proof-of-concept that attempted using it for
> fixing nesting UAFs but it was just that — a proof of concept to demonstrate
> that the new design of GPC was sufficient to address that problem.
> 
> IIRC, said proof of concept did also actually consume the req in question,

It did.  I saw that, but obviously didn't connect the dots to guest_uses_pa.

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9826,6 +9826,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)

                if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, vcpu))
                        static_call(kvm_x86_update_cpu_dirty_logging)(vcpu);
+               if (kvm_check_request(KVM_REQ_GPC_INVALIDATE, vcpu))
+                       ; /* Nothing to do. It just wanted to wake us */

> and one of the existing test cases did exercise it with an additional mmap
> torture added? Of course until we have kernel code that *does* this, it's
> hard to exercise it from userspace :)

Indeed.  I'll send a new version with a different changelog, that way we're not
leaving a trap for developers and each architecture doesn't need to manually handle
the request.

Thanks!

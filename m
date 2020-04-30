Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B30951BF311
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 10:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgD3Ik1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 04:40:27 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23453 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726420AbgD3Ik0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Apr 2020 04:40:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588236025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BynAcktxklIPD8PUgUO0uMVcQmlqCmJY7NgBZufPOXo=;
        b=E9NtovNwW2aAg27NmoxrsSHLb5FWDT99KBlvEU1BIHe62fk+2MuQ55z3vM8jVkI23lcxRx
        a8TkMgu9YU1egr+YLKSnlHVdooAJIz/jgbNWDEFNv4Tlr6W4/qzOxpLkYONnnlmajuuikc
        E0TV0gTHeG58JfEr3d2qyShHBhXXBVg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-A-nA1BnoOdK1VzKpwqbPKQ-1; Thu, 30 Apr 2020 04:40:21 -0400
X-MC-Unique: A-nA1BnoOdK1VzKpwqbPKQ-1
Received: by mail-wr1-f71.google.com with SMTP id r17so3503192wrg.19
        for <kvm@vger.kernel.org>; Thu, 30 Apr 2020 01:40:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=BynAcktxklIPD8PUgUO0uMVcQmlqCmJY7NgBZufPOXo=;
        b=pfvEyFU0N6gaBdePv86jQ7jDQ+XWLxAHcxxtzk62poiy1X1rbRNpv8HzGVGqPA8QC8
         WULmHaTtauiIFYg/tUGPNZY3y/Op+zepe515k3E39RSx0ubuF9AHIAbzLNplZhibQ48U
         mInY9y9qj/pzmrclxcm8VdPeyx4ZkrSo5WHyAiCshsSlbJSAiCu1pLJWcYAbZYyqHFlF
         IqUv8sFw844wEknOUNs2yc92eSbCOqG35yIIeMuerbGTal3OSZY1pIH5eXmVy2ZtH2oC
         zcc873CZ5xBhM0a3AJFRCqessMkDfarG4aIrYerJ2xnW2wobg3GuPD2bu2lBXy3Opvyq
         JtBQ==
X-Gm-Message-State: AGi0PubBPe1anwSenHu5x53oCQlUYsznfy/SrrHxHJ10tLz9voVfOCE2
        HWLe2WhjxgElGv9sYzfNZt77+zH+bwwaINdQmEaLbgcDPxZPS/gGXPeiJIfajIkBuOB7lTlPTx+
        rne1aUInPbSZa
X-Received: by 2002:a05:6000:1203:: with SMTP id e3mr2755620wrx.229.1588236020377;
        Thu, 30 Apr 2020 01:40:20 -0700 (PDT)
X-Google-Smtp-Source: APiQypLXhPodZd49TSkY6lRac/pxozL7+5BXs4yZBzqyMTsISY3o9bymKF6WlF2UNvbwnTgZcvOtRg==
X-Received: by 2002:a05:6000:1203:: with SMTP id e3mr2755594wrx.229.1588236020133;
        Thu, 30 Apr 2020 01:40:20 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id p16sm2891774wro.21.2020.04.30.01.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 01:40:19 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH RFC 4/6] KVM: x86: acknowledgment mechanism for async pf page ready notifications
In-Reply-To: <b1297936-cf69-227b-d758-c3f3ca09ae5d@redhat.com>
References: <20200429093634.1514902-1-vkuznets@redhat.com> <20200429093634.1514902-5-vkuznets@redhat.com> <b1297936-cf69-227b-d758-c3f3ca09ae5d@redhat.com>
Date:   Thu, 30 Apr 2020 10:40:18 +0200
Message-ID: <87sgglfjt9.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 29/04/20 11:36, Vitaly Kuznetsov wrote:
>> +	case MSR_KVM_ASYNC_PF_ACK:
>> +		if (data & 0x1)
>> +			kvm_check_async_pf_completion(vcpu);
>> +		break;
>
> Does this work if interrupts are turned off?
>  I think in that case
> kvm_check_async_pf_completion will refuse to make progress.
> You need to make this bit stateful (e.g. 1 = async PF in progress, 0 =
> not in progress), and check that for page ready notifications instead of
> EFLAGS.IF.  
> This probably means that;
>
> - it might be simpler to move it to the vector MSR

I didn't want to merge 'ACK' with the vector MSR as it forces the guest
to remember the setting. It doesn't matter at all for Linux as we
hardcode the interrupt number but I can imaging an OS assigning IRQ
numbers dynamically, it'll need to keep record to avoid doing rdmsr.

> - it's definitely much simpler to remove the #PF-based mechanism for
> injecting page ready notifications.

Yea, the logic in kvm_can_do_async_pf()/kvm_can_deliver_async_pf()
becomes cumbersome. If we are to drop #PF-based mechanism I'd split it
completely from the remaining synchronious #PF for page-not-present:
basically, we only need to check that the slot (which we agreed becomes
completely separate) is empty, interrupt/pending expception/... state
becomes irrelevant.

-- 
Vitaly


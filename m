Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1D4C2793B7
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 23:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbgIYVqI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 17:46:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27492 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727183AbgIYVqH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 17:46:07 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601070366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=moqh830CyEwENyrPdyv2FayOLM5NqaAIaF9WKpCRqUs=;
        b=hP1PmgdH1TtgSpUN37PHyzirUQDjsaJusePG+Pu07awq+a1Xxr54uvmplTK0OLJsx1ZzuD
        ajTF+u3gZpoedspg6MtoQ9BzmIPyojtQ9AAWz9Y8hhCUXTBdMNhGy3tRj4KFMujr19z7Cy
        rLCi/A2AXjuuvFl3lWMhkMComK3vKmY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-DljPXEaEPC-vVBo2cGYCmQ-1; Fri, 25 Sep 2020 17:46:04 -0400
X-MC-Unique: DljPXEaEPC-vVBo2cGYCmQ-1
Received: by mail-wm1-f70.google.com with SMTP id a7so153357wmc.2
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:46:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=moqh830CyEwENyrPdyv2FayOLM5NqaAIaF9WKpCRqUs=;
        b=S8DsU/M+4KmzXk+E9m3xiLchbG9IDMsqXN7gwY3GlM8PLujJPWEU07dkS+02X83FXk
         3+6EnLhZ/dq0q0/PIFJJ4rOJjJrsCcLnsF6VST7Hgq1zIM8aTZCW37xhzq6mRxONQn2d
         KWlOlKYwy1FMRLo3LysZT6mUq4luUup6U13G1836UNWjcJgkWaQDsKeDfyp0hvZtGabp
         V5YsRGUI6WSh7Wr96M//CteqYi02v85MXkN7MVqJaYXbbty75/ECiuDURXryFBU6GhHt
         RM7rnaKwL4oKbZO4Rse72+0nyszhKku0fzQjVRcyZU2PJtAK2z0TYLumYkB4PE8u/LVW
         F/DQ==
X-Gm-Message-State: AOAM532rO8NRpCUF4KzbReDiTKWGCFbga9Z1tHiRDKAngzZVc9YsaapZ
        nle/MnVCCaVYLR2jqKejAAUILHmcf+BPEbw+Ns5SS7MWg1UzmXKtfTqGw6jTGotfbl+hnowQj/v
        QymovQ1JSxqZx
X-Received: by 2002:adf:ce01:: with SMTP id p1mr6646892wrn.61.1601070362563;
        Fri, 25 Sep 2020 14:46:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwzU/MqyltqArragcC9L5onAvVzXN/xJmb+Ltos1CJZ+Nu0lAEEFXtBinwL7HWfEFeIb6QEVA==
X-Received: by 2002:adf:ce01:: with SMTP id p1mr6646881wrn.61.1601070362339;
        Fri, 25 Sep 2020 14:46:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id g8sm353985wmd.12.2020.09.25.14.46.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 14:46:01 -0700 (PDT)
Subject: Re: [PATCH v2 0/7] KVM: x86: Tracepoint improvements and fixes
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
References: <20200923201349.16097-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c169b328-c14b-d427-d8c9-02eb8278ec75@redhat.com>
Date:   Fri, 25 Sep 2020 23:46:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200923201349.16097-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/20 22:13, Sean Christopherson wrote:
> As noted by Vitaly, these changes break trace-cmd[*].  I hereby pinky
> swear that, if this series is merged, I will send patches to update
> trace-cmd.
> 
> [*] git://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git

Actually I think we should just retire the kvm plugin of libtraceevent.
 I do use the plugin myself, but really only because it's enabled by
default.  There's very little that the plugin does better than the
tracepoints and could not be fixed in Linux.

The role in particular is printed better by the plugin, some fields are
missing in KVM_MMU_PAGE_PRINTK().  The only real functionality would be
the disassembling of emulated instructions.

Paolo

> v2:
>   - Fixed some goofs in the changelogs.
>   - Rebased to kvm/queue, commit e1ba1a15af73 ("KVM: SVM: Enable INVPCID
>     feature on AMD").
> 
> Sean Christopherson (7):
>   KVM: x86: Add RIP to the kvm_entry, i.e. VM-Enter, tracepoint
>   KVM: x86: Read guest RIP from within the kvm_nested_vmexit tracepoint
>   KVM: VMX: Add a helper to test for a valid error code given an intr
>     info
>   KVM: x86: Add intr/vectoring info and error code to kvm_exit
>     tracepoint
>   KVM: x86: Add macro wrapper for defining kvm_exit tracepoint
>   KVM: x86: Use common definition for kvm_nested_vmexit tracepoint
>   KVM: nVMX: Read EXIT_QUAL and INTR_INFO only when needed for nested
>     exit
> 
>  arch/x86/include/asm/kvm_host.h |   7 ++-
>  arch/x86/kvm/svm/svm.c          |  16 ++---
>  arch/x86/kvm/trace.h            | 107 +++++++++++++-------------------
>  arch/x86/kvm/vmx/nested.c       |  14 ++---
>  arch/x86/kvm/vmx/vmcs.h         |   7 +++
>  arch/x86/kvm/vmx/vmx.c          |  18 +++++-
>  arch/x86/kvm/x86.c              |   2 +-
>  7 files changed, 86 insertions(+), 85 deletions(-)
> 

Nice.  Queued, thanks.

Paolo


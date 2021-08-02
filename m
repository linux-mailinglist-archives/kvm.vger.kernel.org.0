Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7746B3DD13D
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 09:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbhHBHdX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 03:33:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29043 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232499AbhHBHdW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 03:33:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627889593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oKwm+VrriTnIjZjtBTh8lfiPTFsXfXUu+LiwuOKDUz4=;
        b=HNkpsTzEORCLdhKa6H0GOyrnOrPDoisJyha2RhOn6aioXqLqMY8dAC9JTKZq7ljPljMfhJ
        5aRK+2zORdCh4rVrIZ3qxoGYovx2nuqSpqfjiL7ZvN8746TXbxa4M5XBiv7JpyodSmm+fh
        3UhMCQ+UDQOQHz9BhgxUPg6pAZMoqXU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-TkTdPYCgPF-FiXVvI3cIHw-1; Mon, 02 Aug 2021 03:33:12 -0400
X-MC-Unique: TkTdPYCgPF-FiXVvI3cIHw-1
Received: by mail-ej1-f69.google.com with SMTP id q19-20020a170906b293b029058a1e75c819so4272304ejz.16
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 00:33:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oKwm+VrriTnIjZjtBTh8lfiPTFsXfXUu+LiwuOKDUz4=;
        b=qdcviwhzTozbO78V1FJmdeWt5qjiddaSDQ1BVDj3WSkKcx6Srins0LnBPU9Lz92fsg
         O0TTirCeVqz1CxFpigKWjNmi9Q0UY8S4UNj5qA0iT0FNuELuG2BLIHFXAswOy562O0Xv
         IwVlieChDhkO/NujaDZbaZGVvq6anR7/LsZuBnnE189nhMb1P0RBZ30poQ2lGfZ/CgI2
         doMFyy7CuvKp2GOwx9evRjFWMwW7Q28RdxKNHpdyLvYY9m1CWNj5L6n2hWMQHUwNa0Ws
         xHOz/7CXfbkR+bSuSeOopXUyfAKR4b2wRVMdYlse4UXU+aoB+tWDQL9mQ3ugHAKrC9lt
         pImA==
X-Gm-Message-State: AOAM532Lr+87ngzQGWf7N2Hm7eaQ8w1/JKUBNX8Verfxhp2gZDWxzpz2
        wiWAKl69uVbPPdjTTjltyBl48PVXpKYoF0+TWh6qkcpB4A9Q02PvTmIiy3OJQiCgSjQmEowXIpz
        nXOyqtrXSxKRc
X-Received: by 2002:a17:906:948f:: with SMTP id t15mr14341828ejx.85.1627889590831;
        Mon, 02 Aug 2021 00:33:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzbsCOdlvVMel6wSv3vdUOaqGxihvei3PtY062A1Soqa5gEZO0krjA811OYtz6iN03PfgjegQ==
X-Received: by 2002:a17:906:948f:: with SMTP id t15mr14341804ejx.85.1627889590666;
        Mon, 02 Aug 2021 00:33:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n15sm5436746edw.70.2021.08.02.00.33.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 00:33:09 -0700 (PDT)
Subject: Re: [RFC PATCH v2 00/69] KVM: X86: TDX support
To:     Sean Christopherson <seanjc@google.com>
Cc:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <0d453d76-11e7-aeb9-b890-f457afbb6614@redhat.com>
 <YQGLJrvjTNZAqU61@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dc4c3fce-4d10-349c-7b21-00a64eaa9f71@redhat.com>
Date:   Mon, 2 Aug 2021 09:33:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YQGLJrvjTNZAqU61@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/07/21 18:51, Sean Christopherson wrote:
> I strongly object to merging these two until we see the new SEAMLDR code:
> 
>    [RFC PATCH v2 02/69] KVM: X86: move kvm_cpu_vmxon() from vmx.c to virtext.h
>    [RFC PATCH v2 03/69] KVM: X86: move out the definition vmcs_hdr/vmcs from kvm to x86
> 
> If the SEAMLDR code ends up being fully contained in KVM, then this is unnecessary
> churn and exposes code outside of KVM that we may not want exposed (yet).  E.g.
> setting and clearing CR4.VMXE (in the fault path) in cpu_vmxon() may not be
> necessary/desirable for SEAMLDR, we simply can't tell without seeing the code.

Fair enough (though, for patch 2, it's a bit weird to have vmxoff in 
virtext.h and not vmxon).

Paolo


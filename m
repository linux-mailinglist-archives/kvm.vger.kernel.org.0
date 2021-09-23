Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0FD7415DEC
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 14:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240797AbhIWMK5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 08:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240713AbhIWMKz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 08:10:55 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6DEC061574;
        Thu, 23 Sep 2021 05:09:23 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id eg28so22961491edb.1;
        Thu, 23 Sep 2021 05:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7FNpljz891PYGt4hpcoO6CG6SoftxC4uPB0i1upIek8=;
        b=ibVmWXzu1aD8kMpJYIOpTRXb3me3E5LR6UwoOCsWvNvNnF+uIa9MOqneeVmeAC4jSy
         u8iQVfjlyzy5Bot3fiB87O9Z8hYaLgKQhvn6dxxsD1CX47rf9hISIJ1FG2OVCo/6Fddc
         GQT6KyMm8LlzTqPvHDJb/59hVBNw0N2ASXsnyaSoFmzWYtPUU1hx4/7/DI2JXhRNMvSQ
         0OrJh/l7+rxuEIjnY2dM/JEf2FcdxhTKRphIayPivMRwr0GAv+egSx5bYbVEC6KgshFG
         XtkJarqgWDuAL3T/xdct4cEYsTlbxSjQ6Ka0mjnnB4qpsH+kcIbaRzprqrzwNDLiPoEL
         csrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7FNpljz891PYGt4hpcoO6CG6SoftxC4uPB0i1upIek8=;
        b=Irx1rxTq/qVuup12U29s5b4IEOn06p7wwOF0gFAxROS3eScmwEWAGjXYT/BqALwPxq
         ohMTaUCtwMXZyTNsIYX1M93kK71NeGpxAvmGfXCm2Kbf+f6nRycXv/jTyjmUP+gfxeRX
         g1wDz9/coI4Udzwh28DOuLh8c7zrOR6MU6CzzooMyobCxRijAioVXBfnaJaH//9byXhO
         0WYfnLMLI0zNSbB55aFnLj9npaprZQX0taLQQHpsSXpb5w4sv9lbDzTYBu9qb2Yl7A40
         EMn2AacmdfQ8krYtQuGvJj1CEAzfVwRRKHgMUmaC7KRP2o4VT0bCECuctlcQEuf70/al
         simQ==
X-Gm-Message-State: AOAM533CWNySewh2ppvgW3FvaUg5t2lmBeAXoSfD3rhSit6GmCOqtsq/
        QABgwCTgKbI3KEAFoV0fTQo=
X-Google-Smtp-Source: ABdhPJz+2RmFRrOTPX9HlyA2A1fEmvS7RoZtYawSlfMhJiIBX2b2m3juOof3jON/2RoPWBdfvvAyYg==
X-Received: by 2002:a50:9d83:: with SMTP id w3mr5043356ede.305.1632398962313;
        Thu, 23 Sep 2021 05:09:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id ck10sm3353455edb.43.2021.09.23.05.09.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 05:09:21 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Subject: Re: [PATCH 1/2] x86: sgx_vepc: extract sgx_vepc_remove_page
To:     Jarkko Sakkinen <jarkko@kernel.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        dave.hansen@linux.intel.com, yang.zhong@intel.com
References: <20210920125401.2389105-1-pbonzini@redhat.com>
 <20210920125401.2389105-2-pbonzini@redhat.com>
 <060cfbbaa2c7a1a0643584aa79e6d6f3ab7c8f64.camel@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a0a2a628-62c5-d620-7714-2c28e4429e71@redhat.com>
Date:   Thu, 23 Sep 2021 14:08:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <060cfbbaa2c7a1a0643584aa79e6d6f3ab7c8f64.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/09/21 21:44, Jarkko Sakkinen wrote:
> "On bare-metal SGX, start of a power cycle zeros all of its reserved 
> memory. This happens after every reboot, but in addition to that 
> happens after waking up from any of the sleep states."
> 
> I can speculate and imagine where this might useful, but no matter
> how trivial or complex it is, this patch needs to nail a concrete
> usage example. I'd presume you know well the exact changes needed for
> QEMU, so from that knowledge it should be easy to write the
> motivational part.

Assuming that it's obvious that QEMU knows how to reset a machine (which 
includes writes to the ACPI reset register, or wakeup from sleep 
states), the question of "why does userspace reuse vEPC" should be 
answered by this paragraph:

"One way to do this is to simply close and reopen the /dev/sgx_vepc file
descriptor and re-mmap the virtual EPC.  However, this is problematic
because it prevents sandboxing the userspace (for example forbidding
open() after the guest starts, or running in a mount namespace that
does not have access to /dev; both are doable with pre-opened file
descriptors and/or SCM_RIGHTS file descriptor passing)."

> Even to a Linux guest, since EPC should stil be represented in the
> state that matches the hardware.  It'd be essentially a corrupted
> state, even if there was measures to resist this. Windows guests
> failing is essentially a side-effect of an issue, not an issue in the
> Windows guests.

Right, Linux is more liberal than it needs to be and ksgxd does the 
EREMOVE itself at the beginning (__sgx_sanitize_pages).  Windows has 
stronger expectations of what can and cannot happen before it boots, 
which are entirely justified.

Paolo

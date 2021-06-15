Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D1A3A86FA
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 18:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhFORBE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 13:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhFORBD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 13:01:03 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A84C061574
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 09:58:58 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 5-20020a9d01050000b02903c700c45721so14960682otu.6
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 09:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UkGJXL+GTQkh7H3nrFB3tS+ygNeWaZvPpf0tnRNocaw=;
        b=AohZER67WgtyGArH1Q7bwaR3sQ8nqyDPqgCtvJAXHVNSQzuTq6QdRIs0V23MxpwqvW
         y5sLlhB+fDxtxXQldXJ96m+qOdJWI3tQzFjYRMH37zeZNt76Roshd9mpGWRm84Xx+VPK
         YeqONMtoQT0XTUCsfANaGQwe+gCBRcvBEHsINU+3JGONnB2FBtHE0y5NOaTLTics2bYE
         vCQvkAQqCW/lBQB0nFSr4tfDF0U7QBwGjiCcAA091HF818oc1Ns1ETU773Hh2/RNuOOV
         hVKDWEx4w5Gtoyll6SlkiTpKuwXyKwDkZX6+lup42Ln11MMV2PmyMWU+7CAIGbQGaSca
         P8/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UkGJXL+GTQkh7H3nrFB3tS+ygNeWaZvPpf0tnRNocaw=;
        b=MpUWypu4ODa+ZZVT2M75nxEVbbWJy1rYg9N2FEHnAPrMBaKBbLWNm8f5lD70NHyL6k
         AiSTOVjID1oX6R5cl4AYBpw3hWVOKVIbr+YzLpZWbx0ckIq7p91IynIWdJZNzrfSw2IP
         2KgB4ePuINjhNwcHxXuWe8HEdSosLLGCcBqeZODZbVsPWEFKZzsSFMAe0oonsjoHSjrl
         sIle+CYSie3wQmAHN9neo8NT4ud0jz6koO7b5LLHDd6uG6Sv0mbKgwqzyvm84MFU9dhu
         2gsaaD2aZDW0driQZ61WiP6HkAGuVgpcs548ZxDAtj4+egAR27y/Lx8QUhUUE+HlOoXT
         634w==
X-Gm-Message-State: AOAM530stoTmxhSc50cTy+/TX1DUjuVfB1zPmExGrXT2nQ8gDqHYuTgU
        5k9Y/7JxkjxPQmG9Ut1tCrjLWBbyAi4qt/M/ptH/Caes9Nk=
X-Google-Smtp-Source: ABdhPJxtR2ssOCDDwx1yrdElVxu4R2O70EmnAsfBd0KbQmtX7Vq88D2HE/2840Jz67ULHsQH+cNQFezdIDSCLpvSyTU=
X-Received: by 2002:a05:6830:124d:: with SMTP id s13mr176712otp.241.1623776337919;
 Tue, 15 Jun 2021 09:58:57 -0700 (PDT)
MIME-Version: 1.0
References: <DM4PR12MB52648CB3F874AC3B7C41A19DB1309@DM4PR12MB5264.namprd12.prod.outlook.com>
 <DM4PR12MB52646AE63A2FAEAD4DAE76D7B1309@DM4PR12MB5264.namprd12.prod.outlook.com>
In-Reply-To: <DM4PR12MB52646AE63A2FAEAD4DAE76D7B1309@DM4PR12MB5264.namprd12.prod.outlook.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 15 Jun 2021 09:58:46 -0700
Message-ID: <CALMp9eTOAzr7jCWD_h39uZe7_d6bozvS1YmrASptgcw1fwLN8Q@mail.gmail.com>
Subject: Re: Controlling the guest TSC on x86
To:     Stephan Tobies <Stephan.Tobies@synopsys.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 15, 2021 at 5:20 AM Stephan Tobies
<Stephan.Tobies@synopsys.com> wrote:
>
> Good afternoon!
>
> We are looking at the use of KVM on x86 to emulate an x86 processor in a =
Virtual Prototyping/SystemC context. The requirements are such that the gue=
st OS should be ideally run unmodified (i.e., in this case ideally without =
any drivers that know and exploit the fact that the guest is not running on=
 real HW but as a KVM guest).
>
> For this, we also would like to control the TSC (as observed by the guest=
 via rdtsc and related instructions) in such a way that time is apparently =
stopped whenever the guest is not actively executing in KVM_RUN.
>
> I must admit that I am confused by the multitude of mechanism and MSRs th=
at are available in this context. So, how would one best achieve to (approx=
imately) stop the increment of the TSC when the guest is not running. If th=
is is important, we are also not using the in-chip APIC but are using our o=
wn SystemC models. Also, are there extra considerations when running multip=
le virtual processors?
>
> Any pointers would be greatly appreciated!
>
> Thanks and best regards
>
> Stephan Tobies

You can use the VM-exit MSR-save list to save the value of the TSC on
VM-exit, and then you can adjust the TSC offset field in the VMCS just
before VM-entry to subtract any time the vCPU wasn't in VMX non-root
operation. There will be some slop here, since the guest TSC will run
during VM-entry and part of VM-exit. However, this is just the
beginning of your troubles. It will be impossible to keep the TSCs
synchronized across multiple vCPUs this way. Moreover, the TSC time
domain will get out of sync with other time domains, such as the APIC
time domain and the RTC time domain. Maybe it's enough to report to
the guest that CPUID.80000007H:EDX.INVARIANT_TSC[bit 8] is zero, but I
suspect you are in for a lot of headaches.

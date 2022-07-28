Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0AE2584835
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 00:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbiG1WZX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 18:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232400AbiG1WZU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 18:25:20 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F021A39C;
        Thu, 28 Jul 2022 15:25:19 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id i8so3935798wro.11;
        Thu, 28 Jul 2022 15:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zhQMD8WNvOQjT/U1dXD2LRPZHwffkL9Bm1xxBkXDodc=;
        b=UR6fLSV9vHafCaddO1Qk21OI1NeVq6haLG9wZ0SD/mGCjSdUmOlvQQz5Tqis8R9IAL
         LxFqQEH6nKTGDHk9DT7mM7KvTA61mQ2BrECGwWZgnbSNA43v8m6AxKK1R2AfzPhbEwg6
         hIK1Uh0OK5St9g1NqYpVoO4AApEDIYvsp0GvpC1fnbD2VLZhbdAeW7prfxPYwDVwMiFT
         W2ktKd1pksDRQmJfkeAH1fB4wzFfhGTa3cJ2uF8Vj8VqnTqQWoVGF8EqK3Dhn8pzapvR
         +ybMC/qI3j0cctXbsIajI5jAl5dArUaYnStdywKPJlJHJ1MXPNeDsCCJYtnb44tSoF+v
         y4/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zhQMD8WNvOQjT/U1dXD2LRPZHwffkL9Bm1xxBkXDodc=;
        b=nKjdAT0bzv3xR+6k4iuzR34IyKanSxEYufphOue+GQRaynMQp18B2b03WoPdYg6oPz
         St2skFNRvpCksOoufz4KprkInM6W/+eXMA++pz3RRgKTF2iSfph2MlNIUkYBKC5EEz8R
         FHGAuEYk7YLUK3UmAqndpeIVzKb/uI9mfsHdmC9+RdOWI4sgehsRvfoU32Ej5eFJOqQ7
         +SP6/eJHN65dcc5NHfrzSOqOhALqjhXpHY7QWvRjhLnsRAvHMf/h3Gv0sPaERniPdB39
         Cta8HzVWB3NmAdIRkgRFRYVRk1op/yvkP7CeZrlEFhV3E/YA1UQJcqEYlmXajQJpUdJ3
         O7+A==
X-Gm-Message-State: ACgBeo0XZ0hGzVzZ0NeIIt9d8eMgIcw8W8FQKrn9TJMFbQCSUzYDxlMz
        RER74V3mJX8VgSkGVOQAx9Y=
X-Google-Smtp-Source: AA6agR5IDyzx1VeN0I77IjxK+eNJN7uyVZguAUOlCxa5sIyHOoL8qoXoewHvdsgsb7jgJXbMfIs7qQ==
X-Received: by 2002:a5d:6b10:0:b0:21e:4bbd:e893 with SMTP id v16-20020a5d6b10000000b0021e4bbde893mr544856wrw.613.1659047118137;
        Thu, 28 Jul 2022 15:25:18 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id s7-20020adfeb07000000b0021d6d9c0bd9sm1997314wrn.82.2022.07.28.15.25.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 15:25:17 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <2e60bd73-e4da-eb4e-4eae-e43be7fd5bcd@redhat.com>
Date:   Fri, 29 Jul 2022 00:25:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4 21/25] KVM: VMX: Move LOAD_IA32_PERF_GLOBAL_CTRL errata
 handling out of setup_vmcs_config()
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220714091327.1085353-1-vkuznets@redhat.com>
 <20220714091327.1085353-22-vkuznets@redhat.com> <YtnZmCutdd5tpUmz@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YtnZmCutdd5tpUmz@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/22/22 00:56, Sean Christopherson wrote:
> Except the errata are based on FMS and the FMS exposed to the L1 hypervisor may
> not be the real FMS.
> 
> But that's moot, because they_should_  be fully emulated by KVM anyways; KVM
> runs L2 with a MSR value modified by perf, not the raw MSR value requested by L1.
> 
> Of course KVM screws things up and fails to clear the flag in entry controls...
> All exit controls are emulated so at least KVM gets those right.

Can you send this as a separate patch?

Paolo

> Untested, but I believe KVM the fix is:
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index d0e781c7ac72..76926147b672 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2357,7 +2357,8 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
>           * we can avoid VMWrites during vmx_set_efer().
>           */
>          exec_control = __vm_entry_controls_get(vmcs01);
> -       exec_control |= vmcs12->vm_entry_controls;
> +       exec_control |= (vmcs12->vm_entry_controls &
> +                        ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
>          exec_control &= ~(VM_ENTRY_IA32E_MODE | VM_ENTRY_LOAD_IA32_EFER);
>          if (cpu_has_load_ia32_efer()) {
>                  if (guest_efer & EFER_LMA)


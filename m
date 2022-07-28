Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5185E584421
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 18:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbiG1Q1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 12:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiG1Q1Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 12:27:16 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FB4422C9;
        Thu, 28 Jul 2022 09:27:16 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id m8so2819444edd.9;
        Thu, 28 Jul 2022 09:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YOEJPh6TjX4+rdwbsuFqKjnIwbvJGoiCO+qrSCNH7/c=;
        b=EmAN8zUTC/RcMAMhlOeO6A1XGZj6g3APe8FINVKGhWUVR2UjsUgk+548tNO3o60HW9
         oLE9YJpSdqzyViCfi7lAhnlYnv2h/ntyVexwtW3J76EvQOTUIRvkuiaqZGYXCl0yXn+Z
         UQNIrxXSFw2u2wq2DEqn1MtD4IepoMbP5F0z6dPMV+XCkAgqth+eEtC4zKLosEWlVkwG
         sPklG+ya6uCzEoYfPYhD0eWPu1SSqTRLB8Gu3RkMEyxAdR/8t5vVAiKz1M+ak9wwJ2zl
         HtgDu4na5FodmymQpEEAOi/aJbixFwukmidVqr8TBbB5JymtFBohwx/Ejlhak9cm++Ik
         ERKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YOEJPh6TjX4+rdwbsuFqKjnIwbvJGoiCO+qrSCNH7/c=;
        b=RPCcwOvOLFMsY1zzk7mSK5sB9tWgyNxtLM6X4oBKo00fuFnapIULf5yaT+5VE4n4ND
         iK9fAY4D09pLNaJkIzKp2vgICdwLmrFSzXDNz59wvA5CDmpNGvtcSh9IDXRLTqD4OqHE
         jg1Z6aJrL/unZUCQIjtu9/KlfYAXEa9KVRoT5w4ekfdLp/95faEzDEIoqUyDlG3p9N4x
         YobPeVXb/P1X+NyWIP8iurK8/lc+U169SYF141duFRwg2fUrlLpCX647uYiXaYD1TEvm
         iIhEP/Qjpa1Q9IB5igyClPlIPel/4m4M1QxtP2LzlaugucQOoST3mcKdeG5bdFTfAFaa
         ONjw==
X-Gm-Message-State: AJIora9Yhzv1ZfrCHfx2zwbKPYh5k3xLC8H1F9Ak96EwZY9jmTuMnPMi
        cWDuMCDLl4J670HFRl/ZCspSeC7Lm+7plw==
X-Google-Smtp-Source: AGRyM1vFtPGWmN+sAVtBi/AwjeTOY50tUUaNB9efIW6I2I9HPw/gBRpK66cqbLv/POjcciE30ByREg==
X-Received: by 2002:a05:6402:388b:b0:42b:5f20:c616 with SMTP id fd11-20020a056402388b00b0042b5f20c616mr27667421edb.50.1659025634492;
        Thu, 28 Jul 2022 09:27:14 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id p6-20020a170906b20600b0072b1cc543fasm574793ejz.130.2022.07.28.09.27.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 09:27:13 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <58bc1828-57ef-8b08-b12f-679ab2a9f9c9@redhat.com>
Date:   Thu, 28 Jul 2022 18:27:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4 15/25] KVM: VMX: Extend VMX controls macro shenanigans
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
 <20220714091327.1085353-16-vkuznets@redhat.com> <YtrtdylmyolAHToz@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YtrtdylmyolAHToz@google.com>
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

On 7/22/22 20:33, Sean Christopherson wrote:
> ERROR: modpost: "__compiletime_assert_533" [arch/x86/kvm/kvm-intel.ko] undefined!
> ERROR: modpost: "__compiletime_assert_531" [arch/x86/kvm/kvm-intel.ko] undefined!
> ERROR: modpost: "__compiletime_assert_532" [arch/x86/kvm/kvm-intel.ko] undefined!
> ERROR: modpost: "__compiletime_assert_530" [arch/x86/kvm/kvm-intel.ko] undefined!
> make[2]: *** [scripts/Makefile.modpost:128: modules-only.symvers] Error 1
> make[1]: *** [Makefile:1753: modules] Error 2
> make[1]: *** Waiting for unfinished jobs....

I think it comes from

static void add_atomic_switch_msr_special(struct vcpu_vmx *vmx,
                 unsigned long entry, unsigned long exit,
                 unsigned long guest_val_vmcs, unsigned long host_val_vmcs,
                 u64 guest_val, u64 host_val)
{
         vmcs_write64(guest_val_vmcs, guest_val);
         if (host_val_vmcs != HOST_IA32_EFER)
                 vmcs_write64(host_val_vmcs, host_val);
         vm_entry_controls_setbit(vmx, entry);
         vm_exit_controls_setbit(vmx, exit);
}


and it can be fixed just with __always_inline.

Paolo

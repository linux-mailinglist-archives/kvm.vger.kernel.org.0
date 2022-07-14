Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18B43574A25
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 12:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238017AbiGNKIG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 06:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237938AbiGNKIE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 06:08:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 106F3509D7
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 03:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657793283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5yLJ2bZUwPbEJHKaSwHhV1p/EnBfuuZT7nkMtiX7CVI=;
        b=RT6fYEdGKjh30LkaDYUUh1KK1LAHmRBbqoA+Ysc2hUInLc4jbpvrLxcNZw+fkA4u0p7Qts
        vGSB7+kEH+gAMQKZDeeFQc5864wnSQ7TZdqamkujeiSl9Yd5Zu8FlMbOhH8+D8LJUTEKBO
        99uk2VBjWcjRJA4rbXcPc+EPxLuHnCI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-182-yIixtHxxNwm7yFXOykF4rQ-1; Thu, 14 Jul 2022 06:08:02 -0400
X-MC-Unique: yIixtHxxNwm7yFXOykF4rQ-1
Received: by mail-wm1-f69.google.com with SMTP id n21-20020a7bc5d5000000b003a2ff4d7a9bso538083wmk.9
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 03:08:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=5yLJ2bZUwPbEJHKaSwHhV1p/EnBfuuZT7nkMtiX7CVI=;
        b=eC7lug0KjWBPDuRcDEBKWGMK2zBPkS8eVbdzq6Dw+8q061MTOXxNMwIgmYNmHJ1lVa
         awl9qiiRin3ttLQUXYAdEmkAEIhGfKXOR05yRstUzFTYXfCu66Ttm14r3pBTM59+dMUY
         It9V3sOMHdME/jKJaF+pUWB5TaB6KQQpbnrhVqrRxu/VNbYYYIBNkwYmKCHKNV6nwXFR
         Oh9T1cVNkFlWQ3mtBaH+0Yw7jCrJtoJeK89N/6vaxep31+nrlCfjL+ZXp+C5bjowo/YZ
         Dmiy9WWApUVdoMiifQywlc8Ely3Bbw1flThl/1ib9ROx4Vl7l2jD9xJSv8FYrkfA7PwC
         +LJA==
X-Gm-Message-State: AJIora+cW7sKe7UsQQ8ECv4rcKqJDPQRC46aqKeJCI3S0c7zKhn8idEj
        hA//6/7XmVy/tVbHnH33JgE4b8u9ngIASKSkTjgcpfwKPxfElye1LlhaRiaXk2m+vu1cgCFWkAu
        gByZDkLYYfBwA
X-Received: by 2002:a5d:5311:0:b0:21d:656b:807e with SMTP id e17-20020a5d5311000000b0021d656b807emr7337462wrv.521.1657793280642;
        Thu, 14 Jul 2022 03:08:00 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1spOrGYWP6gQ8F45DcZ+A44Aq18Wu0zW2WhwkrP140A8f4VGuWYv5/Pa7tkvvSjMmUb46z+eg==
X-Received: by 2002:a5d:5311:0:b0:21d:656b:807e with SMTP id e17-20020a5d5311000000b0021d656b807emr7337443wrv.521.1657793280463;
        Thu, 14 Jul 2022 03:08:00 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id o3-20020adfeac3000000b0021d6ac977fasm1042092wrn.69.2022.07.14.03.07.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 03:07:59 -0700 (PDT)
Message-ID: <3f4ff61979116c502663ab8b49ce869100f53e2a.camel@redhat.com>
Subject: Re: [PATCH v4 08/25] KVM: selftests: Switch to updated eVMCSv1
 definition
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 14 Jul 2022 13:07:58 +0300
In-Reply-To: <20220714091327.1085353-9-vkuznets@redhat.com>
References: <20220714091327.1085353-1-vkuznets@redhat.com>
         <20220714091327.1085353-9-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-07-14 at 11:13 +0200, Vitaly Kuznetsov wrote:
> Update Enlightened VMCS definition in selftests from KVM.
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  .../selftests/kvm/include/x86_64/evmcs.h      | 45 +++++++++++++++++--
>  1 file changed, 42 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/evmcs.h b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
> index 3c9260f8e116..58db74f68af2 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/evmcs.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
> @@ -203,14 +203,25 @@ struct hv_enlightened_vmcs {
>                 u32 reserved:30;
>         } hv_enlightenments_control;
>         u32 hv_vp_id;
> -
> +       u32 padding32_2;
>         u64 hv_vm_id;
>         u64 partition_assist_page;
>         u64 padding64_4[4];
>         u64 guest_bndcfgs;
> -       u64 padding64_5[7];
> +       u64 guest_ia32_perf_global_ctrl;
> +       u64 guest_ia32_s_cet;
> +       u64 guest_ssp;
> +       u64 guest_ia32_int_ssp_table_addr;
> +       u64 guest_ia32_lbr_ctl;
> +       u64 padding64_5[2];
>         u64 xss_exit_bitmap;
> -       u64 padding64_6[7];
> +       u64 encls_exiting_bitmap;
> +       u64 host_ia32_perf_global_ctrl;

Fixed here as well, thanks!

Best regards,
	Maxim Levitsky

> +       u64 tsc_multiplier;
> +       u64 host_ia32_s_cet;
> +       u64 host_ssp;
> +       u64 host_ia32_int_ssp_table_addr;
> +       u64 padding64_6;
>  };
>  
>  #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE                     0
> @@ -656,6 +667,18 @@ static inline int evmcs_vmread(uint64_t encoding, uint64_t *value)
>         case VIRTUAL_PROCESSOR_ID:
>                 *value = current_evmcs->virtual_processor_id;
>                 break;
> +       case HOST_IA32_PERF_GLOBAL_CTRL:
> +               *value = current_evmcs->host_ia32_perf_global_ctrl;
> +               break;
> +       case GUEST_IA32_PERF_GLOBAL_CTRL:
> +               *value = current_evmcs->guest_ia32_perf_global_ctrl;
> +               break;
> +       case ENCLS_EXITING_BITMAP:
> +               *value = current_evmcs->encls_exiting_bitmap;
> +               break;
> +       case TSC_MULTIPLIER:
> +               *value = current_evmcs->tsc_multiplier;
> +               break;
>         default: return 1;
>         }
>  
> @@ -1169,6 +1192,22 @@ static inline int evmcs_vmwrite(uint64_t encoding, uint64_t value)
>                 current_evmcs->virtual_processor_id = value;
>                 current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_XLAT;
>                 break;
> +       case HOST_IA32_PERF_GLOBAL_CTRL:
> +               current_evmcs->host_ia32_perf_global_ctrl = value;
> +               current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1;
> +               break;
> +       case GUEST_IA32_PERF_GLOBAL_CTRL:
> +               current_evmcs->guest_ia32_perf_global_ctrl = value;
> +               current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1;
> +               break;
> +       case ENCLS_EXITING_BITMAP:
> +               current_evmcs->encls_exiting_bitmap = value;
> +               current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2;
> +               break;
> +       case TSC_MULTIPLIER:
> +               current_evmcs->tsc_multiplier = value;
> +               current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2;
> +               break;
>         default: return 1;
>         }
>  



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F195C4E6894
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 19:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352606AbiCXSXW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 14:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345513AbiCXSXV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 14:23:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 75225B7C4C
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 11:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648146107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jx4V2wxX0/qgtx/m0U79f5yalNTUlq6NfBUVWoihxXY=;
        b=P7MKhsfnYcwq5baRVpu0Vek2giSzFEsQliqHJxoTHC1TOP0aHwvj4eggT6lHdDMhToCwic
        uXR4oxkv9RbktWcLbWMAplM6epl4ScW+THT1EIaba7W0lriyTmdNURrj7Kz33pd/4RPdnR
        /LWYOWcQRuOkwedh+1pItwY809d5luk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-578-MWXTyasmORejIcA_mcEJqA-1; Thu, 24 Mar 2022 14:21:46 -0400
X-MC-Unique: MWXTyasmORejIcA_mcEJqA-1
Received: by mail-ed1-f69.google.com with SMTP id q25-20020a50aa99000000b004192a64d410so3494636edc.16
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 11:21:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jx4V2wxX0/qgtx/m0U79f5yalNTUlq6NfBUVWoihxXY=;
        b=6W3AkL6WYHBlEn32SuP6N3CoDWvjK/FpQION/VtTzzF5DryEtuM2mV1ymoLNVHuUu9
         xfVvuQ2/+5Em7BUDkY37ixeMDsD7P99gpE8luxndUhRUB/al4GrIDQdaQb03lSU0uenm
         1onpLwz01fVeyRcTtLAEPhq5uhNJWJ/xqh5bX9uCYRETNnRHuw9gEEy5pRwife1z3Za8
         7aMUA4wdnnwltk9imfVgJHFCVENAsiEVqaVg2VeMvPKsW/Z/KXjaQEkzzmMOXyoGffsV
         bEiqpC6QEPC7SZadiqoc8ok6apdhRQT95264P1C6eXDO75ZNHvQcug8X+0hVXlh4BRnf
         l3Yw==
X-Gm-Message-State: AOAM533Ihc0vOVC99FqZgkfsJdQKPkmvrLWwqf6wL8TOjyGfCirxmPzp
        SNered6WkDHhmKKD9N3+xeSw7lqxq/WZwYqb6Xow26RoKbwSYSjBEMfy6QDjMo6wKPIMt0F9hKh
        tXZwr4YiV4dAz
X-Received: by 2002:a17:906:dc8b:b0:6df:7a71:1321 with SMTP id cs11-20020a170906dc8b00b006df7a711321mr7049196ejc.476.1648146105028;
        Thu, 24 Mar 2022 11:21:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxDJNNSRrjK7Lgg/RLpymf9jwIYm6k6R7n6IMcLdk01mcX+Q3G/grO2M8oglFuwDl63xcDuOg==
X-Received: by 2002:a17:906:dc8b:b0:6df:7a71:1321 with SMTP id cs11-20020a170906dc8b00b006df7a711321mr7049168ejc.476.1648146104761;
        Thu, 24 Mar 2022 11:21:44 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id c11-20020a056402120b00b004196059efd1sm1706961edw.75.2022.03.24.11.21.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Mar 2022 11:21:43 -0700 (PDT)
Message-ID: <fca4a420-bdb4-0b46-c346-bee5500be43a@redhat.com>
Date:   Thu, 24 Mar 2022 19:21:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v4 2/6] KVM: x86: nSVM: implement nested LBR
 virtualization
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>
References: <20220322174050.241850-1-mlevitsk@redhat.com>
 <20220322174050.241850-3-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220322174050.241850-3-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/22/22 18:40, Maxim Levitsky wrote:
> +		/* Copy LBR related registers from vmcb12,
> +		 * but make sure that we only pick LBR enable bit from the guest.
> +		 */
> +		svm_copy_lbrs(vmcb02, vmcb12);
> +		vmcb02->save.dbgctl &= LBR_CTL_ENABLE_MASK;

I still do not understand why it is not copying all bits outside
DEBUGCTL_RESERVED_BITS.  That is:

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index c1baa3a68ce6..f1332d802ec8 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -589,11 +589,12 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
  	}
  
  	if (unlikely(svm->lbrv_enabled && (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
-		/* Copy LBR related registers from vmcb12,
-		 * but make sure that we only pick LBR enable bit from the guest.
+		/*
+		 * Reserved bits of DEBUGCTL are ignored.  Be consistent with
+		 * svm_set_msr's definition of reserved bits.
  		 */
  		svm_copy_lbrs(vmcb02, vmcb12);
-		vmcb02->save.dbgctl &= LBR_CTL_ENABLE_MASK;
+		vmcb02->save.dbgctl &= ~DEBUGCTL_RESERVED_BITS;
  		svm_update_lbrv(&svm->vcpu);
  
  	} else if (unlikely(vmcb01->control.virt_ext & LBR_CTL_ENABLE_MASK)) {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 54fa048069b2..a6282be4e419 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -62,8 +62,6 @@ MODULE_DEVICE_TABLE(x86cpu, svm_cpu_id);
  #define SEG_TYPE_LDT 2
  #define SEG_TYPE_BUSY_TSS16 3
  
-#define DEBUGCTL_RESERVED_BITS (~(0x3fULL))
-
  static bool erratum_383_found __read_mostly;
  
  u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index cade032520cb..b687393e86ad 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -487,6 +487,8 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
  /* svm.c */
  #define MSR_INVALID				0xffffffffU
  
+#define DEBUGCTL_RESERVED_BITS (~(0x3fULL))
+
  extern bool dump_invalid_vmcb;
  
  u32 svm_msrpm_offset(u32 msr);


> +		svm_update_lbrv(&svm->vcpu);
> +
> +	} else if (unlikely(vmcb01->control.virt_ext & LBR_CTL_ENABLE_MASK)) {
>   		svm_copy_lbrs(vmcb02, vmcb01);


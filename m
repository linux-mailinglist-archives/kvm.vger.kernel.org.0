Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0493054B7A6
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 19:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356601AbiFNR2x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 13:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350986AbiFNR2V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 13:28:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B404DE03D
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 10:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655227699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iSH+DYmRkKMqWyNjrkzYbk9as1pR1wnvGMJve2jezd4=;
        b=Fddv88dl71o8JAFh98sK4zBBqoyqBXpdYid+1oPgsEl9uDeuOBSRuelwqunjgb8M90X0qA
        l0jI8VhQPp4cwhxi+yyhzssy993+d8N7mZOQn8avZEBfX4bOu/zZfar5GSeEcmOCv7tXTj
        E5TQKDPYJWA7v5XMOU3luW4SP0Rlxt8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-578-iIkxMeqDNXSks0zNyY2_nQ-1; Tue, 14 Jun 2022 13:28:16 -0400
X-MC-Unique: iIkxMeqDNXSks0zNyY2_nQ-1
Received: by mail-wm1-f70.google.com with SMTP id k5-20020a05600c0b4500b003941ca130f9so4091382wmr.0
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 10:28:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=iSH+DYmRkKMqWyNjrkzYbk9as1pR1wnvGMJve2jezd4=;
        b=RPNdlpmr4YQ82mmpSUZbwTHDMmYKg5ZKoh8FWtosr9zmQHRlHBgoKKQAUiCSp/sG9c
         DHnEv+3jqXnwN2Nq3Re4M1J3OW/hxcmcHK6fZU//RuGmkf6l7vfR7KZBzGG7Tleieyx5
         pPJILy2gSBE2IET2+zio+2CIdaP9u7hfJnUemVoseqMaMEPfesoEA0LopK31oW8f3TEI
         rrOXdO+8jLI7pVQND+xLswP2fdqW3qKWiWiVu6Ny6An+v2dir3kZzfg1GcJ5b/fAeiwJ
         B/Gsqcal64kY4DORvI6OsGgu4dPK6eVZ86WaMPORLvge5JSZLfa6xrC3D+g/5S0GlU0Y
         ZsfQ==
X-Gm-Message-State: AJIora+nKL7oqBGikgyedvVFcPkWtPDrzXGbZMj9ka/NtGkoLTkTErFJ
        BBfFG/cTgbwoHVH84wuMesmU57/huWmoZ6yQXQ+xPPj1FOKsHDF261pnty2zJFr7vW8lFw2Rmif
        wdrSyX7DK7PPB
X-Received: by 2002:adf:f592:0:b0:213:711d:55ad with SMTP id f18-20020adff592000000b00213711d55admr5953663wro.540.1655227694677;
        Tue, 14 Jun 2022 10:28:14 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uQsWCeMjHo+6+u2IAR6pHNgMgtPft3WHP6rzOx3d8cYaac9V2retUEhAye0AAUBrEJgsnZXg==
X-Received: by 2002:adf:f592:0:b0:213:711d:55ad with SMTP id f18-20020adff592000000b00213711d55admr5953651wro.540.1655227694453;
        Tue, 14 Jun 2022 10:28:14 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id v22-20020a7bcb56000000b0039482d95ab7sm13632257wmj.24.2022.06.14.10.28.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 10:28:13 -0700 (PDT)
Message-ID: <ec63cf3c-d312-01b7-671b-02729bddfa32@redhat.com>
Date:   Tue, 14 Jun 2022 19:28:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ilias Stamatis <ilstam@amazon.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, mail@anirudhrb.com,
        kumarpraveen@linux.microsoft.com, wei.liu@kernel.org,
        robert.bradford@intel.com, liuwe@microsoft.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220613161611.3567556-1-anrayabh@linux.microsoft.com>
 <592ab920-51f3-4794-331f-8737e1f5b20a@redhat.com>
 <YqgU2KfFCqawbTkW@anrayabh-desk>
 <75bdc7ee-bac5-ae05-dffb-cb749c9005e1@redhat.com>
 <YqilhAnxLMoQu1Ou@anrayabh-desk>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: nVMX: Don't expose TSC scaling to L1 when on Hyper-V
In-Reply-To: <YqilhAnxLMoQu1Ou@anrayabh-desk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/14/22 17:13, Anirudh Rayabharam wrote:
>>> Sanitize at the end might not work because I see some cases in
>>> nested_vmx_setup_ctls_msrs() where we want to expose some things to L1
>>> even though the hardware doesn't support it.
>>
>> Yes, but these will never include eVMCS-unsupported features.
>
> How are you so sure?
> 
> For example, SECONDARY_EXEC_SHADOW_VMCS is unsupported in eVMCS but in
> nested_vmx_setup_ctls_msrs() we do:
> 
> 6675         /*
> 6676          * We can emulate "VMCS shadowing," even if the hardware
> 6677          * doesn't support it.
> 6678          */
> 6679         msrs->secondary_ctls_high |=
> 6680                 SECONDARY_EXEC_SHADOW_VMCS;
> 
> If we sanitize this out it might cause some regression right?

Yes, you're right, shadow VMCS is special: it is not supported by 
enlightened VMCS, but it is emulated rather than virtualized. 
Therefore, if L1 does not use the enlightened VMCS, it can indeed use 
shadow VMCS.

Paolo


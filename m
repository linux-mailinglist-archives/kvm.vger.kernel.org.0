Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118BF49B716
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 16:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377639AbiAYPAd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 10:00:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54635 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1449561AbiAYO43 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jan 2022 09:56:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643122586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lGL2/NjefHhyINykRNyB07vGQwioJ1sjJSOwSvg1S6Y=;
        b=dwuVxIxb6rnEKWi01oFa0jw2gYOamVyObqTIUH+Q7iQKqDh/XkBYd5yTrkbQdaccsCDcSo
        Ez+FDTFk8/7TJnhmcxyiCvM6OcnUAruB6OxTYCaxAZl7nqo/4hyKpdZ7mSPOy8X0l2fygG
        LSpUerVemYZ7ssspXeGQucfogcmPB4E=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-193-sI9OkCbxO6u7Zd7ZaZKm8Q-1; Tue, 25 Jan 2022 09:56:25 -0500
X-MC-Unique: sI9OkCbxO6u7Zd7ZaZKm8Q-1
Received: by mail-ed1-f72.google.com with SMTP id j1-20020aa7c341000000b0040417b84efeso15054152edr.21
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 06:56:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lGL2/NjefHhyINykRNyB07vGQwioJ1sjJSOwSvg1S6Y=;
        b=LRFvWxdQUpwrdtsXEfW1FUTdAcPA4epIRxmyW1mLtOhPYherkSTPVdOU7x3eqk9IsW
         PqE03sil5Ht4aadly4zSc/V7zX5mt8ODtiBToOD9BVYRagxxZtGcGsXeGRRgY806up12
         nuCeoC+0EDRRUETf/kV81w3XQ94iPlbiHuBUKWSZ6K/VtFRHaGQv/xeM98F5qXo/hysX
         vPmONoBV6yTkEhjGcs7V1GwlXq840WIRBlS2vB4AiHVH3x3aUF0hrd5soVO/wsa7xnHX
         6RLviCD8BAiukvtmJvicm5FUvAHPpO81SMnOS+9ppQAW+oN/71eUuM72p5o6mJwUmiYP
         jzXg==
X-Gm-Message-State: AOAM531tJC/B2lXbPJnbV5DS/V70o1pNaz/ynjJvZbp7OamL72uggi5e
        zdbzGPE5VOI0puDk8JlkVBagownfSEK51gSC7yfWgbTPohmzr0saiSSnhFUnbwin8W3NrJq20vX
        c0tp5K81OiuJi
X-Received: by 2002:a05:6402:195:: with SMTP id r21mr20572176edv.174.1643122584285;
        Tue, 25 Jan 2022 06:56:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyVGauajL/pyWmlWy8fSIPc8ZX2dsHxs6NAmP9jhUXsGReDypI2HiaL16DWhDfC4d1IpPkbIw==
X-Received: by 2002:a05:6402:195:: with SMTP id r21mr20572161edv.174.1643122584118;
        Tue, 25 Jan 2022 06:56:24 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id g4sm8419999edl.50.2022.01.25.06.56.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 06:56:23 -0800 (PST)
Message-ID: <23c80e45-856c-b188-44a4-08a97d5e5ba3@redhat.com>
Date:   Tue, 25 Jan 2022 15:56:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 6/9] KVM: SVM: WARN if KVM attempts emulation on #UD or
 #GP for SEV guests
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Liam Merwick <liam.merwick@oracle.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20220120010719.711476-1-seanjc@google.com>
 <20220120010719.711476-7-seanjc@google.com>
 <483ed34e-3125-7efb-1178-22f02173667a@oracle.com>
 <YemWCwhQ8aYcqUw9@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YemWCwhQ8aYcqUw9@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/20/22 18:04, Sean Christopherson wrote:
>>> +	WARN_ON_ONCE(emul_type & (EMULTYPE_TRAP_UD | EMULTYPE_VMWARE_GP));
>> What about EMULTYPE_TRAP_UD_FORCED?
> Hmm, yeah, it's worth adding, there's no additional cost.  I was thinking it was
> a modifier to EMULTYPE_TRAP_UD, but it's a replacement specifically to bypass
> the EmulateOnUD check (which I should have remembered since I added the type...).
> 

Added on top:

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d5fe71862bcb..85bbfba1fa07 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4269,7 +4269,9 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
  		return true;
  
  	/* #UD and #GP should never be intercepted for SEV guests. */
-	WARN_ON_ONCE(emul_type & (EMULTYPE_TRAP_UD | EMULTYPE_VMWARE_GP));
+	WARN_ON_ONCE(emul_type & (EMULTYPE_TRAP_UD |
+				  EMULTYPE_TRAP_UD_FORCED |
+				  EMULTYPE_VMWARE_GP));
  
  	/*
  	 * Emulation is impossible for SEV-ES guests as KVM doesn't have access


Paolo


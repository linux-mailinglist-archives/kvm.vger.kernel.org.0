Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE174FC395
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 19:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348961AbiDKRm6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 13:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348974AbiDKRmn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 13:42:43 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCDF23168;
        Mon, 11 Apr 2022 10:40:27 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id t1so6414438wra.4;
        Mon, 11 Apr 2022 10:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4ivQhWEzq6X6JM0iImOYzzpeGiLK4rWSbQZzZkOjImc=;
        b=bI1xid7tiQrX4zd5Nj73bxPYQAG/YY2NOIje3xFLTs+QnT4L1GY2rATZ+FGFPMvX4+
         Q8FKeps2sPEO1yekXoE5nZrnkvaqN8pp+NM8dttXUVZRsoWPNSw7UEJXVV/sfmCKd6MV
         b0a+xxIIImoko1fAR8ucP20NQVk21/bjCRzZkSkuI1DPd3KNli6vscJdi2HgVEA1OCSp
         Fb7pmQJfgrRYKOaswgd9SDg6W5Pf7vRhylQoFaGQU1P8ZQV14yKO/ZoU9a7tK40S5yT5
         qYWGbkz/kvDl8x+3P4IOAMUuBZVtW6BhMyqIlKt8zv4NV+eHt/EYzqDVTHvqWPO8SOxn
         Qumw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4ivQhWEzq6X6JM0iImOYzzpeGiLK4rWSbQZzZkOjImc=;
        b=nc1/77uwk8tvAAQXioQLUnJRFCmnAGBEivxIfCDm8OOvgmfbD3n9Xubvk5H3psUxJb
         /dgkoDqmWUpSkxjW7XWu7wa87loImgYbRUxy/qcBZ9xSeRNLroLfbOiuqldACDglZJOR
         EWRHXsrz2nXrpm3mRilz3xE0tVfoNmLe9q+qA+lJjpqvvFR8saaydkckSYjOuXIzxSBM
         kj0GCNQ/zNZ8s9GHsh6r3TNsU7IOQ0+cgMH6ixggEoEqyN5Hzoth86alE6tFAdRmoI9b
         Bq2uNfjKI5g8n4SkCdLwkkyucvJkIBrmBZDV8gUYviDJcRfXTtylSoQdyb6cnIPNWcHB
         1cAg==
X-Gm-Message-State: AOAM530WmYd3oyc/4oWwqDPMrtSGJkXskAHEmh609nZ8sHvvU83wSZe6
        9rBYc3v8NzV1mXrW2W6f4KU=
X-Google-Smtp-Source: ABdhPJxs2IGhtxSJfey8fh4t8P7MmC/11nqyVMpiEKpkRDi2bx+8V2KP+doLY1n4O5yPgFLbfq7wBA==
X-Received: by 2002:a5d:47a1:0:b0:204:9f5:e72f with SMTP id 1-20020a5d47a1000000b0020409f5e72fmr26919305wrb.656.1649698826395;
        Mon, 11 Apr 2022 10:40:26 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id e9-20020a5d6d09000000b00203ecdca5b7sm30055582wrq.33.2022.04.11.10.40.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 10:40:26 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <a7d28775-2dbe-7d97-7053-e182bd5be51c@redhat.com>
Date:   Mon, 11 Apr 2022 19:40:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 092/104] KVM: TDX: Handle TDX PV HLT hypercall
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <6da55adb2ddb6f287ebd46aad02cfaaac2088415.1646422845.git.isaku.yamahata@intel.com>
 <282d4cd1-d1f7-663c-a965-af587f77ee5a@redhat.com>
 <Yk79A4EdiZoVQMsV@google.com>
 <8e0280ab-c7aa-5d01-a36f-93d0d0d79e25@redhat.com>
 <20220408045842.GI2864606@ls.amr.corp.intel.com>
 <27a59f1a-ea74-2d75-0739-5521e7638c68@redhat.com>
 <YlBL+0mDzuTMYGV9@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YlBL+0mDzuTMYGV9@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/8/22 16:51, Sean Christopherson wrote:
>> It also documents how it has to be used.  So this looks more or less okay,
>> just rename "vmxip" to "interrupt_pending_delivery".
> 
> If we're keeping the call back into SEAM, then this belongs in the path of
> apic_has_interrupt_for_ppr(), not in the HLT-exit path.  To avoid multiple SEAMCALLS
> in a single exit, VCPU_EXREG_RVI can be added.

But apic_has_interrupt_for_ppr takes a PPR argument and that is not 
available.

So I suppose you mean kvm_apic_has_interrupt?  You would change that to 
a callback, like

         if (!kvm_apic_present(vcpu))
                 return -1;

	return static_call(kvm_x86_apic_has_interrupt)(vcpu);
}

and the default version would also be inlined in kvm_get_apic_interrupt, 
like

-       int vector = kvm_apic_has_interrupt(vcpu);
         struct kvm_lapic *apic = vcpu->arch.apic;
         u32 ppr;

-       if (vector == -1)
+       if (!kvm_apic_present(vcpu))
                 return -1;
+       __apic_update_ppr(apic, &ppr);
+	vector = apic_has_interrupt_for_ppr(apic, ppr);

Checking the SEAM state (which would likewise not be VCPU_EXREG_RVI, but 
more like VCPU_EXREG_INTR_PENDING) would be done in the tdx case of 
kvm_x86_apic_has_interrupt.

Paolo

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3BED4D1DA2
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 17:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244470AbiCHQoP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 11:44:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237545AbiCHQoM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 11:44:12 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4057A24BDA;
        Tue,  8 Mar 2022 08:43:12 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id d10so40510097eje.10;
        Tue, 08 Mar 2022 08:43:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qCwmsr6oXjLssymqT/qnNYZlcUrE07F4Pfsz9zDexWY=;
        b=AsJ3ni/sXixNRzUwef/sZOye7j1wWGf96xnlH+VbPvzisqEpn6pZ5H6dZ72D/a4jWU
         KNw5mnRYWCF++dTjqZ/2wqL9H9PONtPzg1NpC4gp+jiFPudTFzyNOzbVxczx3x/Dipip
         CmtYUJJRefXGzQBgicVm5Fn4Gtuz21jAdsV9qhjmJXa1/Y519SJjwe3pwYbZ8GCJU6Bl
         7jXM0rJjflCooB8sMKu0cSHvMlM71PqBMxtEnlcStaeU8eJp1jJXKpUPHoX/e438AYtX
         MuFSYvO5Ph1dCaKTm7ogdV7olUr+MgYh3PeEtwSV/Ed3WzJ0bMBy2/+GWe4S/Fj1LA4C
         dOcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qCwmsr6oXjLssymqT/qnNYZlcUrE07F4Pfsz9zDexWY=;
        b=JI/C3ZhgFIhosxOLHhNXPJtInBbw70kcx0JiCoTHZCeGrAlzfhXRN4vukZXbQ6Bb4d
         e+xRqQ1xU4UhI2NRjdNa4Wx2+rMtZ8uF8R2sdT1kh4lbm5tbATLde0FJSKfkb9GtnrE0
         5pA//lA3yxaDDBCS10NZ0JQfD4eI16Q5tBQSvn4jB9oaKgBUxLFq4q+UYeRctkjnM+ZL
         IPrU031oF9e5IL1wyMPVzu9kfXeS2JEK06ZfcR9T8guqfCWRNb8erK8QBwdHrFaRHKZr
         K0qA4xjwCjcnb2F+Tc3yMxhxhu/zzrczVJoaSp5hOIqcQxZb7+i3Wmx6ymfia6DzdiZe
         AfHQ==
X-Gm-Message-State: AOAM531+P+0WcnQq4ZPTljsrpvWRDfVmtyxu1rPpLKQFPFl8bXgF8kMi
        y1i7MxiOlBBN1ufJbKXJQJ4=
X-Google-Smtp-Source: ABdhPJwgvxEvidx9EZtknDVlSJ3dOKj3gRaE5pH3wsPsth2fTUjpxQdHXLLhuz+5Pbw6cDus3dw5aw==
X-Received: by 2002:a17:907:9495:b0:6da:9602:3ec6 with SMTP id dm21-20020a170907949500b006da96023ec6mr14198272ejc.589.1646757790664;
        Tue, 08 Mar 2022 08:43:10 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id v4-20020a170906338400b006d5aca9fc80sm6027445eja.106.2022.03.08.08.43.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 08:43:09 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <96ff1628-eeb2-4d12-f4eb-287dd8fc9948@redhat.com>
Date:   Tue, 8 Mar 2022 17:43:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 01/25] KVM: x86/mmu: avoid indirect call for get_cr3
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-2-pbonzini@redhat.com> <YieBXzkOkB9SZpyp@google.com>
 <2652c27e-ce8c-eb40-1979-9fe732aa9085@redhat.com>
 <YieFKfjrgTTnYkL7@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YieFKfjrgTTnYkL7@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/8/22 17:32, Sean Christopherson wrote:
> 
> Aha!  An idea that would provide line of sight to avoiding retpoline in all cases
> once we use static_call() for nested_ops, which I really want to do...  Drop the
> mmu hook entirely and replace it with:
> 
> static inline kvm_mmu_get_guest_pgd(struct kvm_vcpu *vcpu)
> {
> 	if (!mmu_is_nested(vcpu))
> 		return kvm_read_cr3(vcpu);
> 	else
> 		return kvm_x86_ops.nested_ops->get_guest_pgd(vcpu);
> }

Makes sense, but I think you mean

static inline unsigned long kvm_mmu_get_guest_pgd(struct kvm_vcpu *vcpu,
						  struct kvm_mmu *mmu)
{
	if (unlikely(vcpu == &vcpu->arch.guest_mmu))
		return kvm_x86_ops.nested_ops->get_guest_pgd(vcpu);
	else
		return kvm_read_cr3(vcpu);
}

?

Paolo

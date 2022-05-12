Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 794B9524E0F
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 15:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354273AbiELNSs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 09:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354268AbiELNSr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 09:18:47 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF49250E8E;
        Thu, 12 May 2022 06:18:46 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id be20so6151421edb.12;
        Thu, 12 May 2022 06:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=V2JNCP+HsfCN+EYLETrCl+Q2QImYlR/SvAjA8iddPzo=;
        b=evK7+Zcvz2xVuylTV6weOBTX9rOxmYedGbk9SMQuehhsEWlXsR1jHtd4FcUGAj47WB
         Hzk7jbG3PmoXiy3L9SfBDVuVXBNLP/g6qViO8Ixjbz5q/sv8pcILCK3e1AZWf/KcvFHo
         jOHXn8w61z1bnQbZW0IWXfaRYjUT62sKTUuxQ2qAQ7U1gk4G0yVAzD/0flUAbSo8p7O6
         58JlQTZhiNsIGmYDPDUWAT1OLZOL+1tGvocVtmLFSPILQXSPADQmzpERboQtrZczyAod
         zhFR7j6njZvfmCOS4FXdA7OwKw/yKgYVimcIwhk/2yYjB2nQ10Cqi2HOBVG9u9pBNNBT
         Y7Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=V2JNCP+HsfCN+EYLETrCl+Q2QImYlR/SvAjA8iddPzo=;
        b=6M2hhIIh6eQqNMZ6nEIdboStbZvLIk1kXDiRRtonT+y4FgS7srW22bb6OAdAgaArxn
         eQmZZmlmzS7EYR+AT5NwNsUIfGFnN9obZVluZyKvVJhwGGilaztVrkmrq9er69WxcF+u
         2lehEZ94UL3SALETA6aMYHCGkL4Ifkyj4saXxJmm2IHRNlI1VNAMflxNJAqYWdUUQ+lF
         HwV04hguC7W4DOsqiAg+uiPpnu309s8fRiL9k4TAQZWiovfSy83NDdPbWcUGiUTdydkx
         u50X0ramdJMdK0yCPxZL7V4Y/ZdnGUbtQjDZwP2yPxGPFH6OMt1vGziKWm6+y26xw/Ai
         iSyQ==
X-Gm-Message-State: AOAM53210QyLb3R56dQELU5lQtIINfN4mQbEhg7SyjKUjUnuq8Bfb1qU
        /uPqPk+r6d6YI52W1IMwovU=
X-Google-Smtp-Source: ABdhPJxOpJ1Ehy5Z/UEMu9MD6Lq5Gh2Lb+BAQDVB8F7/0zk71rTur/33E6WTKe2v8JQLR/F+W+OlZQ==
X-Received: by 2002:a05:6402:4301:b0:427:c8e4:4acd with SMTP id m1-20020a056402430100b00427c8e44acdmr35297088edc.230.1652361524776;
        Thu, 12 May 2022 06:18:44 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id r2-20020a056402234200b0042617ba63besm2538718eda.72.2022.05.12.06.18.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 06:18:44 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <8a15c4b4-cabe-7bc3-bd98-bd669d586616@redhat.com>
Date:   Thu, 12 May 2022 15:18:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v11 14/16] KVM: x86/vmx: Flip Arch LBREn bit on guest
 state change
Content-Language: en-US
To:     "Yang, Weijiang" <weijiang.yang@intel.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220506033305.5135-1-weijiang.yang@intel.com>
 <20220506033305.5135-15-weijiang.yang@intel.com>
 <9f19a5eb-3eb0-58a2-e4ee-612f3298ba82@redhat.com>
 <9e2b5e9f-25a2-b724-c6d7-282dc987aa99@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <9e2b5e9f-25a2-b724-c6d7-282dc987aa99@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/11/22 09:43, Yang, Weijiang wrote:
>>
>> Instead of using flip_arch_lbr_ctl, SMM should save the value of the MSR
>> in kvm_x86_ops->enter_smm, and restore it in kvm_x86_ops->leave_smm
>> (feel free to do it only if guest_cpuid_has(vcpu, X86_FEATURE_LM), i.e.
>> the 32-bit case can be ignored).
> 
> In the case of migration in SMM, I assume kvm_x86_ops->enter_smm() 
> called in source side
> 
> and kvm_x86_ops->leave_smm() is called at destination, then should the 
> saved LBREn be transferred
> 
> to destination too? The destination can rely on the bit to defer setting 
> LBREn bit in

Hi, it's transferred automatically if the MSR is saved in the SMM save 
state area.  Both enter_smm and leave_smm can access the save state area.

The enter_smm callback is called after saving "normal" state, and it has 
to save the state + clear the bit; likewise, the leave_smm callback is 
called before saving "normal" state and will restore the old value of 
the MSR.

Thanks,

Paolo

> VMCS until kvm_x86_ops->leave_smm() is called. is it good? thanks!


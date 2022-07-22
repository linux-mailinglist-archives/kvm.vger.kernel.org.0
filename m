Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850C057E559
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 19:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235855AbiGVRWc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 13:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232706AbiGVRWc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 13:22:32 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2149854642;
        Fri, 22 Jul 2022 10:22:31 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id b11so9611315eju.10;
        Fri, 22 Jul 2022 10:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YkC3eY7Vl6bSmPtjcXgP6cjyIo/TnsfJzy20Et5wz7c=;
        b=KN5yd+53sH4Wb8HPNnZgi8AEjMBzBJZ2b0S99H1pJSSGFaXJ5zhfd3Yct+FeSd08g4
         DRP86PSFIY+OF7m4l51JNbIb3qM1rWn2atS6imjcTzB9Gecg63D9PqJfnmlBh8Z82HpX
         Qee1NLvmL+kiMW4EkgFLZgWGjRsExUoFQ2OH3EKwTTwmb2es8bvaKAv7fQzH3jfuZITt
         CHDL+XfVc6Qzb/+525qvwryYxfoBJcBdQCg73/z3r6vydOqYKYBv+C2KftA4L/1hp79X
         Lo94Rmj5clKKZFn1Y3eyWsZbtxw6KUYmPesRNrwIwGFtZ1fdFvzt4Gi4TY/vy2cSjuE2
         t3cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YkC3eY7Vl6bSmPtjcXgP6cjyIo/TnsfJzy20Et5wz7c=;
        b=yCzN3LyWSEdhTPqnGjTJuqyS0fWYXBwrMYKbBYvTxo0O/wKjYBDlwQckwjT8UpfaTS
         saMybCv6TMAQ2SqYl7fGPKOhM1ZvO1fQZASAriQpsDGTXjr64Qs2zdLB3dG6WrprpuK7
         umtme8XVlreU9kEC7J9U2B/ZzSaucHQtUcAehQpQZkMg29PCz2K6DjMSe74tyLrYgWJn
         2z6oLCfPRR/lrVR/6VeApWgxV+P/TZFc0ItQlUgDSVJ8eaIUa9Gf05X3KXB5iu6K/++7
         S72I34Z9NN5PTU4o2NN8gRAwVqNCWk7nc1xxedit53KX1+GPF/q+ciFdCSkZqhQmpbvv
         gzng==
X-Gm-Message-State: AJIora8IAacT7nWLav8nZnco1d2sN2l6WCefQF4kLgTMqTxXACzulu/Q
        zjpFBCCK1pQ0jLSryLlNLDs=
X-Google-Smtp-Source: AGRyM1swhtBRtCTeArxoepNlVydfAHn99mPfz+udv+1XrqoqrvjzL6vRX3Y19KQPBHuFjWxdmjpCFA==
X-Received: by 2002:a17:906:9be4:b0:72b:cf9:99d8 with SMTP id de36-20020a1709069be400b0072b0cf999d8mr665118ejc.747.1658510549556;
        Fri, 22 Jul 2022 10:22:29 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id ej22-20020a056402369600b00437d3e6c4c7sm2816248edb.53.2022.07.22.10.22.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jul 2022 10:22:29 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <0741719d-17b4-96fe-1ee8-5f22cf3e255b@redhat.com>
Date:   Fri, 22 Jul 2022 19:22:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v4 01/25] KVM: x86: hyper-v: Expose access to debug MSRs
 in the partition privilege flags
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
 <20220714091327.1085353-2-vkuznets@redhat.com> <YtnIgQOPbcZOQK2D@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YtnIgQOPbcZOQK2D@google.com>
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

On 7/21/22 23:43, Sean Christopherson wrote:
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index c284a605e453..ca91547034e4 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1282,7 +1282,7 @@ static bool hv_check_msr_access(struct kvm_vcpu_hv *hv_vcpu, u32 msr)
>          case HV_X64_MSR_SYNDBG_OPTIONS:
>          case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
>                  return hv_vcpu->cpuid_cache.features_edx &
> -                       HV_FEATURE_DEBUG_MSRS_AVAILABLE;
> +                       HV_ACCESS_DEBUG_MSRS;
>          default:
>                  break;
>          }
> 

Yes, and this will need some kind of hack in QEMU to expose both CPUID 
bits.  Fortunately hv-syndbg shouldn't be in much use in the wild, so I 
think we can avoid quirks etc.

Paolo

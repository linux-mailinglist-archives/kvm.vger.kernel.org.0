Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188B759731F
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 17:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235611AbiHQPbe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 11:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239257AbiHQPbc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 11:31:32 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0E897527;
        Wed, 17 Aug 2022 08:31:30 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id gk3so25169276ejb.8;
        Wed, 17 Aug 2022 08:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc;
        bh=z1aJBy61pKsmi7DsBWXmsHxdHZaFFcBnXJYk4XAypGg=;
        b=cmQBMvKoe+hWgLi7Mzf7f7yDn/weXp4UrP8rxdelGiYcgaagrrhowYSbp2U09qsMie
         Wubhh+nawXcGx+FExyyVYGKJQhQb28bia0sc5QIMhkmCDbUKTGMAkZ8LNdWTmfy580Vf
         EquC9QuSaYO1SJJnx9uK0O0gHvbobDfMPQ9RUuwmtNI8o6XZJzIoqQNmDNNhYd7ylpDX
         vVI/fo/5P+/2IuRfzBVDv5PuxasHMuM+9/nDI3mEds3pTGyT9pZpLwnJnxC7AN/JLjMf
         JWdHgVh7bfSbfW78U0yKRptkwbwEHo5Oiit18z5P5Y8oZFcBDBVCTwZru7GEuwgwghvb
         TVJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc;
        bh=z1aJBy61pKsmi7DsBWXmsHxdHZaFFcBnXJYk4XAypGg=;
        b=LQF0lvBQSVEbXIMGxydmXPFCovLEy2e+etzCLvQxX8MC/5vks1ztfS1ex3WIpCX6v/
         nQGyeUZ1waFss3IpWDpzuTIQBu/BUMjufMNm8+ZiGC6LqemRWtqGN3aB20OZ+99mXJfK
         qesGbWuwkf888uQFglKycwcFlGdpq+tanjd77VmHR2Je21UAFNxYkSJ9zMk/hNGm+xLG
         MDgtgl6EGFeU8UjdruGWeXjtbulOH/XJQKT0UmORg48WzKekqkO3DSfrAkV/ZW51pgG7
         uHUScNchMMZybLJId8Wjo7Fpkb70KrSmvco+y1JccChzb4DCrT564Z9Zj7cEgqwroIGH
         ViVw==
X-Gm-Message-State: ACgBeo2s3BZjROobhVC680e2TasulGnBbiLqJtbhUSWrjB9QzBb3qc8Z
        DcK2rFZPRSK2Z2Kq0ubmVT32KD7GjVQ=
X-Google-Smtp-Source: AA6agR7+8fHm3wLN3RFBtwSunNJjGZ5BTF5U5j/Hgd07GODYjFWUA+Hha5jLHqEhDqwGQv+FeJkBFA==
X-Received: by 2002:a17:907:8317:b0:731:2189:7f4d with SMTP id mq23-20020a170907831700b0073121897f4dmr16595667ejc.468.1660750288851;
        Wed, 17 Aug 2022 08:31:28 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id t16-20020a056402021000b0043be16f5f4csm10896850edv.52.2022.08.17.08.31.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Aug 2022 08:31:28 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <78616cf8-2693-72cc-c2cc-5a849116ffc7@redhat.com>
Date:   Wed, 17 Aug 2022 17:31:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2 2/9] KVM: x86: remove return value of kvm_vcpu_block
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mlevitsk@redhat.com, vkuznets@redhat.com
References: <20220811210605.402337-1-pbonzini@redhat.com>
 <20220811210605.402337-3-pbonzini@redhat.com> <Yvwpb6ofD1S+Rqk1@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yvwpb6ofD1S+Rqk1@google.com>
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

On 8/17/22 01:34, Sean Christopherson wrote:
> Isn't freeing up the return from kvm_vcpu_check_block() unnecessary?  Can't we
> just do:
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9f11b505cbee..ccb9f8bdeb18 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10633,7 +10633,7 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
>                  if (hv_timer)
>                          kvm_lapic_switch_to_hv_timer(vcpu);
> 
> -               if (!kvm_check_request(KVM_REQ_UNHALT, vcpu))
> +               if (!kvm_arch_vcpu_runnable(vcpu))
>                          return 1;
>          }
> 
> 
> which IMO is more intuitive and doesn't require reworking halt-polling (again).

This was my first idea indeed.  However I didn't like calling 
kvm_arch_vcpu_runnable() again and "did it schedule()" seemed to be a 
less interesting result from kvm_vcpu_block() (and in fact 
kvm_vcpu_halt() does not bother passing it up the return chain).

Paolo

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46E3E554BF6
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 15:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357788AbiFVN7f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 09:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358032AbiFVN7W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 09:59:22 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4F12E9CB;
        Wed, 22 Jun 2022 06:59:21 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id e40so11489600eda.2;
        Wed, 22 Jun 2022 06:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9Lavx5c1gZGH6D19ZXIDMtTZay0309C+BWs9+IAVz0I=;
        b=Pj1n1a6fbgdD2JeIQGM58CL7RsalreWUtHsGCU6D1ZjemWs0ZfzXSLEdP/dMMesiZn
         hY1rXd7843yfVEk3mAY0zfLNQh40yrzCep28FkRHNG/uBCQaQ/5mWytO8MKKdwp6q7Re
         zoGphS0sbXIYKyBV8AzDpNHKybdct5XnI4vTid5duW2+0G4DnV9n6dDzvM8bgaT2mEv/
         MucCglOUu1rkCKJaZQtD5BPYBRuUhhh+S9WocEYQSzaOiGxooa6NWWXds1ODiv25LklV
         XgQfP9ElgoKCTxZfWrAoEh8fKKmi52gUd75QiD9OkDiNaJ5RQQYubd8x/LJY4z5Rt5Z3
         e94g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9Lavx5c1gZGH6D19ZXIDMtTZay0309C+BWs9+IAVz0I=;
        b=iDb4Vhx+ANVrkBZ7Fg/hn5v0MhZdYdCGhsAQZ7sl3Eis9SJEWExdigjPe9IT1VUwaF
         dF2NfPGpMngkZiyOkJOCweJGt093R4BN7m17+l62y1nvwbtDKa0Gwo1RDdSW1BsVNLTz
         koMwB8vvZnk6cul/zSgGAjAjhWpb8hfolqziADXck7ddFUxW7JegqCDoCQTHbXQaa0j/
         9uoqnhgeWxpK3vg55LobQRWE/R9NOVAysFFqmoegfmJhLLHfL2nBsDbPgSOJaNnUn5zC
         M39OEmxAOqhOgBQg2Z92kh2Qr4NuB7Sh8WyGQ5cIe8GRf0RDq60uSAy+y6rSfWq0mCpI
         rRVg==
X-Gm-Message-State: AJIora/miX+HLRA4bmCzuPEOFt/TJY7XGoYxVaiz8uOwlx2lTOdWhLCZ
        YoWkzynb/FHtU75mhmtRQ1k93LNjzTg=
X-Google-Smtp-Source: AGRyM1v64YQr6UsDXpYkeHRqSDu6hX5yxgearHX++4CYzFqTvST+homTskG1nEoq7V91mig6yhGEuw==
X-Received: by 2002:aa7:de1a:0:b0:435:7d11:9717 with SMTP id h26-20020aa7de1a000000b004357d119717mr4295116edv.148.1655906360105;
        Wed, 22 Jun 2022 06:59:20 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id 9-20020a170906310900b0071cbc7487e1sm8744079ejx.69.2022.06.22.06.59.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jun 2022 06:59:19 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <36f2de4e-43fe-7280-8cac-f44de89b2b98@redhat.com>
Date:   Wed, 22 Jun 2022 15:59:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v7 10/39] KVM: x86: hyper-v: Don't use
 sparse_set_to_vcpu_mask() in kvm_hv_send_ipi()
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220613133922.2875594-1-vkuznets@redhat.com>
 <20220613133922.2875594-11-vkuznets@redhat.com>
 <17a2e85a-a1f2-99e1-fc69-1baed2275bd5@redhat.com> <87zgi640mm.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87zgi640mm.fsf@redhat.com>
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

On 6/21/22 15:17, Vitaly Kuznetsov wrote:
>>
>> Just to be clear, PV IPI does*not*  support the VP_ID, right?
> Hm, with Hyper-V PV IPI hypercall vCPUs are also addressed by their
> VP_IDs, not by their APIC ids so similar to Hyper-V PV TLB flush we need
> to convert the supplied set (either flat u64 bitmask of VP_IDs for
> non-EX hypercall or a sparse set for -EX).
> 

So this means the series needs a v8, right?

Paolo

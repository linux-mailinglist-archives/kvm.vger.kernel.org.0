Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5DD534D84
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 12:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347045AbiEZKkE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 06:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239697AbiEZKkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 06:40:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1A231CC174
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 03:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653561599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+r8IRfW0aiu0JceyLx2VcCldtR76oQiy6OB80vh4MBU=;
        b=IphLSvFnpo89iOFo324K67EfRAQ8O/hPK9Ey5G3fQJgil0IBUXQZxBz7v0+iJN+LOsQXrK
        SjO8wsZMhseMIHJfilxIXNHdFEjR2lmzUo5P8CbPQAqzBGaDJhWSN5Pt/8T8A+eVRmYTbk
        rPqsuUCCuOsiGQp61VgJz/wSdHE0vAo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-266-xajD1Aj5NQ6kk1s8lMQZbg-1; Thu, 26 May 2022 06:39:55 -0400
X-MC-Unique: xajD1Aj5NQ6kk1s8lMQZbg-1
Received: by mail-ed1-f70.google.com with SMTP id j22-20020aa7ca56000000b0042bd3527f2aso898663edt.0
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 03:39:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+r8IRfW0aiu0JceyLx2VcCldtR76oQiy6OB80vh4MBU=;
        b=fVpRcvGxjkzR2vu9NMkQMvgEHfI6Rc0ncv635uwIp92PVmgYV9yb/cfB6iLMOLyWN5
         srRMotaJ4+yCLd1rPfOo0UP43CGqnPAl5uXj9bgWG3ozagAHro4yzyTy9DHtu64+RLeD
         1W1qt1YTfzbT8xEpbrDTd67Z1fsABRLZJ2iQKI+JtT2rYwTWyDvCZjAytjVRIkQ8uTwg
         M7HPCj/FW5tFj30g7xBqLosLTbQ5UnKGebKNgMTuoH+gxA6IteHBTBz6X5F24uOHpXHO
         xOoakzDOvIzkp/RzhriEWExbbtb84Tp4H4mKXzUZ8QUKYGStnjiL14SXFLHFgDSIkeBB
         NLSw==
X-Gm-Message-State: AOAM530gvDa3MhkN8+rQvMaDKhK9DL+SrrmQGDSDOXsIwx1sqPWkPL/f
        PS4opJqhIHTP+IfoWV9Epa7sP8iR2ccq8wWfAYP8kimJ42ElqHRe0iCZvJN96KQ8383bFNCo8Cw
        rTKCh1VkOAtAV
X-Received: by 2002:a17:906:f17:b0:6fe:94f6:cb8a with SMTP id z23-20020a1709060f1700b006fe94f6cb8amr31800181eji.456.1653561594742;
        Thu, 26 May 2022 03:39:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyUSYGuJiw8tlBQEs9M1/lLmuEsmHtBEs/SiLz744J3SQye6+zzJi4pp7socx6vuf4BRlOQcA==
X-Received: by 2002:a17:906:f17:b0:6fe:94f6:cb8a with SMTP id z23-20020a1709060f1700b006fe94f6cb8amr31800168eji.456.1653561594551;
        Thu, 26 May 2022 03:39:54 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id c10-20020a05640227ca00b0042ab9da73e6sm633908ede.94.2022.05.26.03.39.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 May 2022 03:39:53 -0700 (PDT)
Message-ID: <8288b833-68f0-9fd2-d4d4-21cc9aff5ec2@redhat.com>
Date:   Thu, 26 May 2022 12:39:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 2/2] KVM: VMX: Add knob to allow rejecting kvm_intel on
 inconsistent VMCS config
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Lei Wang <lei4.wang@intel.com>
References: <20220525210447.2758436-1-seanjc@google.com>
 <20220525210447.2758436-3-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220525210447.2758436-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/25/22 23:04, Sean Christopherson wrote:
> Add an off-by-default module param, reject_inconsistent_vmcs_config, to
> allow rejecting the load of kvm_intel if an inconsistent VMCS config is
> detected.  Continuing on with an inconsistent, degraded config is
> undesirable when the CPU is expected to support a given set of features,
> e.g. can result in a misconfigured VM if userspace doesn't cross-check
> KVM_GET_SUPPORTED_CPUID, and/or can result in poor performance due to
> lack of fast MSR switching.
> 
> Signed-off-by: Sean Christopherson<seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 20 +++++++++++++++++---
>   1 file changed, 17 insertions(+), 3 deletions(-)

Yeah let's do this by default.

Paolo


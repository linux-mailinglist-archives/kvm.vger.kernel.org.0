Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85839434EB8
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 17:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhJTPNn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 11:13:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32476 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230349AbhJTPNm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 11:13:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634742687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GOYfInL+R09Jr/3grGwySWrsCmTDAjA+a7Ga2IIQs4I=;
        b=KBDMtUGw69eYnWvKyAB9E3UDuf0uqJZ2gTSF6mtjxW96IZmCoAeLiQWrNDAjAplON0lQYq
        woKjTjE2jtkuu9CInwUPsvdO/Xv/bcJuBfSMqXLp3hu4RPFV3gKjB6SkDa4+QeO4eZ8v76
        ta1aAZUAoKAyud3QCgsnBSgYe6elvRg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-eUS2hm6QNoqIxJdRL5MM_A-1; Wed, 20 Oct 2021 11:11:25 -0400
X-MC-Unique: eUS2hm6QNoqIxJdRL5MM_A-1
Received: by mail-ed1-f72.google.com with SMTP id t18-20020a056402021200b003db9e6b0e57so21306835edv.10
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 08:11:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GOYfInL+R09Jr/3grGwySWrsCmTDAjA+a7Ga2IIQs4I=;
        b=iZ05Id8OZPRSWUNBTk7geiH6eorvX36FUor5xZTAysAufm+xNiGOW0gqS9mmSnX9Lh
         N9h1v9plIAP0CZTq9fzWQdDnIz6dzUKmMghXi1tCyogMj0BDZH3ECd46ms4UktKKAUgY
         J7G2TV01BZsdZOt0LtGer5cWcTlzKir2iZH+GPv+1EUpAQUXgvJJFTOnvKuTwj8p2SHJ
         jDXba8Twocr9RxNt/rXf0Gas2bin2GLSVDII6bVp/FvR3yNovXknx3uiZybrqqOD4B+I
         lAQQ+Tth3k7sCVORwddqN/e4a9ayl0nMLQaOs7zIfZU3Mhjdev1pahsUyL8/pzlXBeS7
         8epA==
X-Gm-Message-State: AOAM5323PVDA3Do41G1HI0OcVGvnDUeBI7YOmZWsOsBFgWnDIXcZM+LZ
        tRLbieIyK8TohUIV6/4aT2MDHxSVWg6wri6wRfP/D823oi6IB9A0IRLj6DseyqEwzvTHXIJwPEb
        LeWesN8vLzJoj
X-Received: by 2002:a17:906:9b46:: with SMTP id ep6mr189496ejc.226.1634742684665;
        Wed, 20 Oct 2021 08:11:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwdeN5qQWOCw/apNli222nhXI/ouf8NYxOHZox6BRrfy9DcoMQO5en5TGPq0wDQ2cVjgc307Q==
X-Received: by 2002:a17:906:9b46:: with SMTP id ep6mr189472ejc.226.1634742684420;
        Wed, 20 Oct 2021 08:11:24 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p26sm1311726edu.57.2021.10.20.08.11.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 08:11:23 -0700 (PDT)
Message-ID: <cbe5d411-ba9b-0600-2c69-1f73f1d941df@redhat.com>
Date:   Wed, 20 Oct 2021 17:11:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v1 2/5] KVM: x86: nVMX: Update VMCS12 fields existence
 when nVMX MSRs are set
Content-Language: en-US
To:     Robert Hoo <robert.hu@linux.intel.com>, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
Cc:     kvm@vger.kernel.org, yu.c.zhang@linux.intel.com
References: <1629192673-9911-1-git-send-email-robert.hu@linux.intel.com>
 <1629192673-9911-3-git-send-email-robert.hu@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1629192673-9911-3-git-send-email-robert.hu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/08/21 11:31, Robert Hoo wrote:
> +		vmcs12_field_update_by_vmexit_ctrl(vmx->nested.msrs.entry_ctls_high,
> +				*highp, data >> 32,
> +				vmx->nested.vmcs12_field_existence_bitmap);
> +		break;
> +	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
> +		vmcs12_field_update_by_vmentry_ctrl(vmx->nested.msrs.exit_ctls_high,
> +				*highp, data >> 32,
> +				vmx->nested.vmcs12_field_existence_bitmap);

These two functions maybe could be merged into just one, since there are 
going to be duplicate checks.

Paolo


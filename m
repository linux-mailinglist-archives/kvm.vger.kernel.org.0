Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E78A547238D
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 10:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233607AbhLMJM3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 04:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbhLMJM2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 04:12:28 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F68AC061574;
        Mon, 13 Dec 2021 01:12:27 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id g14so48951681edb.8;
        Mon, 13 Dec 2021 01:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jE23hOGGMXfQnw7eakglQriYDVVH915+aNMUdML9el8=;
        b=U7LUj+XcvfWLiiWwwAnSmLyg36fvbssgMowsfmTzWUOTAaxcp/XKgqAxQuQZIVUTkj
         Ozd5VlAwDQvY7OeYTsiycAiHNfukcV27U8d5jK1vLjz7yr0PYOYdUXf8FgB+YR5mJ9gR
         l3Q0gwMYOJW2qPARh/v56hcmgKkF2Q9ugwaNBKYxSsBX4aVBdnznGkp6PZGXBKEKscoE
         B+5PDlHJtLN0aChP4FzvM/bLfoObj2+gEOsj9+ZSpjMPuAzL+jVMUlttJTOBQF9Rkqap
         5ql7ZKtLWOqsojnrF43Su9w6t+JB5x6nX83bl8mmORUMjgoZ5zvzYHffqXKXJfSnxrTp
         zEtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jE23hOGGMXfQnw7eakglQriYDVVH915+aNMUdML9el8=;
        b=ZxJWsmYFxvpvR2/9hPCVHowdmcfZlB/cjAyjBAHo49aMoK8fc/jvlseAUKlrG1a2JW
         yN/ETFGQWa1CKD8wejYg1UBvmaPzx8YVarePFHfRQF29V5jBDaXkPUS+BeQuUA4YJ10a
         DTH0V31PP2emLSwIllB+7v1fz1eeSnJArD0jsQW1ZJnV42jjVFT8T2zvfQnnV8+YnPkX
         b+gHgHaCZ0jgVY7PcnTpbsq/k4e5oV5O694L4VMnfweN1FqaOhgz11ww/w0+NAv+kZL4
         syFZT5E7iMQnZoVGdw+Op5v7sDqYGTuu3QEbVTArS6b1zznwe7fs6ruTCShI2pAC+HRq
         YRLw==
X-Gm-Message-State: AOAM532qx7t8oD4zngdtODYhdONt5iCmJR8YsAaU//nFNNGZJK2VCP/3
        On0I/VkhGtDA0ST/6zZEJRs=
X-Google-Smtp-Source: ABdhPJzPz1znjhAfgXCUgd9me7ue2LBb988VFI8w3zM4nE/5G3PIEC/9JmxIFOFM7qsaNRV7TVoYpA==
X-Received: by 2002:a17:906:f43:: with SMTP id h3mr42878311ejj.414.1639386745942;
        Mon, 13 Dec 2021 01:12:25 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:48f9:bea:a04c:3dfe? ([2001:b07:6468:f312:48f9:bea:a04c:3dfe])
        by smtp.googlemail.com with ESMTPSA id ht7sm5646986ejc.27.2021.12.13.01.12.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 01:12:25 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <dae6cc09-2464-f1f5-c909-2374d33c75b5@redhat.com>
Date:   Mon, 13 Dec 2021 10:12:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 02/19] x86/fpu: Prepare KVM for dynamically enabled states
Content-Language: en-US
To:     Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-3-yang.zhong@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211208000359.2853257-3-yang.zhong@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/21 01:03, Yang Zhong wrote:
>    - user_xfeatures
> 
>      Track which features are currently enabled for the vCPU

Please rename to alloc_xfeatures

>    - user_perm
> 
>      Copied from guest_perm of the group leader thread. The first
>      vCPU which does the copy locks the guest_perm

Please rename to perm_xfeatures.

>    - realloc_request
> 
>      KVM sets this field to request dynamically-enabled features
>      which require reallocation of @fpstate

This field should be in vcpu->arch, and there is no need for 
fpu_guest_realloc_fpstate.  Rename __xfd_enable_feature to 
fpu_enable_xfd_feature and add it to the public API, then just do

	if (unlikely(vcpu->arch.xfd_realloc_request)) {
		u64 request = vcpu->arch.xfd_realloc_request;
		ret = fpu_enable_xfd(request, enter_guest);
	}

to kvm_put_guest_fpu.

Paolo

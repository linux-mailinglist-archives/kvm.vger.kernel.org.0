Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6746447AA41
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 14:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232816AbhLTNUK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 08:20:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbhLTNUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Dec 2021 08:20:10 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D68C061574;
        Mon, 20 Dec 2021 05:20:09 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id m21so11023734edc.0;
        Mon, 20 Dec 2021 05:20:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KPcdrfLKkxhOvPXWy6bq391b76cEL5bWLUG4OI0ap0U=;
        b=pUZLH/gRRsns4SZK3MVzCImWQYzN5LDb1Ix9/cuKjEcKBiMcDzFmxfPHWUv4gOXY4M
         QYTizXBTcvDSL4xHlO5sHFvB41b3Q7XJY/H4yiODTytdQufSX/vHe+xDoblMGzw5+NFk
         AKiJ8FULmSM+Xs0++6fS88sLzL1azjBJMOSvfut3l6fv//JQkcquylYPEYmg81n1Gq/U
         QtH2V7PvK5NZEbvO8KX977MjMYuqvl95Ub08bGArwE7tEWk0O3kvAxyzE+FzRSOaXt3X
         oOagw4X0QM0L+UrfZID2Xd1g84gevX2mzimfkd6hANY/NfYF//KCtf316oKN+pAmjLS6
         lABw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KPcdrfLKkxhOvPXWy6bq391b76cEL5bWLUG4OI0ap0U=;
        b=uVxtLEiFwSMWqmH93o11I9df0F3iBIL6J9y/WABmUqILqhkRBD9yx82/s/+YEYguT1
         Hu18FaCsL0UonRZNbZ9tnJCpJvdTKA6IJnxypD+wrtQemL0mP/TgMXjvMLY7xN7rm3HA
         qHH6fvFqG9JsjrqNaO1MQoRY3wCBWAJrl5oQ615CBpwHMyVftpQQYubla7/527ASkOfo
         clYCoyzSjoTzQN8bj1mcHjR6iBBWJYqKNpvaxHFjbW5zoRin4eAePfE/GT1j627Jv0bF
         HApeiVBy3kWjIIXCStSKenaTNavnMeWur6XxebC8JmaDjU7cVsTxNc1utrgs0W9myQfd
         7ojA==
X-Gm-Message-State: AOAM531wfrU+ZIjMemA/mwAQ7h8uCXDeVgbq6qZmXjWdpdhMW2XU+cu9
        eJYrpfs5LmurrAbDxKAm6SA=
X-Google-Smtp-Source: ABdhPJwp0q/5CsMXETdbjw47y2ioci+s6vdPbblFj/X6wh0r9+AVIIQMwNrjZcvSypDA2RGhMYV8zw==
X-Received: by 2002:a17:906:9b8e:: with SMTP id dd14mr13407697ejc.337.1640006408406;
        Mon, 20 Dec 2021 05:20:08 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id gb10sm365983ejc.49.2021.12.20.05.20.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 05:20:08 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <da09e079-23c3-4414-0c45-16413f704dbc@redhat.com>
Date:   Mon, 20 Dec 2021 14:20:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 04/23] kvm: x86: Exclude unpermitted xfeatures at
 KVM_GET_SUPPORTED_CPUID
Content-Language: en-US
To:     Jing Liu <jing2.liu@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, guang.zeng@intel.com,
        wei.w.wang@intel.com, yang.zhong@intel.com
References: <20211217153003.1719189-1-jing2.liu@intel.com>
 <20211217153003.1719189-5-jing2.liu@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211217153003.1719189-5-jing2.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/17/21 16:29, Jing Liu wrote:
>   
> +Permissions must be set via prctl() for dynamically-enabled XSAVE
> +features before calling this ioctl. Otherwise those feature bits are
> +excluded.
> +

Dynamically-enabled feature bits need to be requested with 
``arch_prctl()`` before calling this ioctl.  Feature bits that have not 
been requested are excluded from the result.

Thanks,

Paolo

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8EA03107D5
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 10:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhBEJ1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 04:27:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23179 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229978AbhBEJZP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Feb 2021 04:25:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612517029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FkGj7z//CzVWjRN9C2HYvXgeUqNsaA9YYrEEEvxeE5U=;
        b=EJ8lSCgQ2psfPTLUm8lFpvxkVNLMT5QkXHMOz0FELnrRfSNLbZkzUTVenaM6hk50g4yf+u
        owVPpGvEttkqhSctfmEvYit0jLCs+II55KqsKnsWDi11ofe9n53PCHN7LHuzOicxfJmaCz
        l7vwdafUVhw3um/dUjR+EcYoMKCb8Ws=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-mG0EOxt7PEuG9lvVfSpm5w-1; Fri, 05 Feb 2021 04:23:47 -0500
X-MC-Unique: mG0EOxt7PEuG9lvVfSpm5w-1
Received: by mail-ed1-f72.google.com with SMTP id ck25so6510632edb.16
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 01:23:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FkGj7z//CzVWjRN9C2HYvXgeUqNsaA9YYrEEEvxeE5U=;
        b=mPJmp2xlirkGE8K909hFbIkNEM/ZrgeoqfQoZQDjry8suwdSBRCFPRNItOenf0tcBh
         OlhgCKxp4H5DV5bKE5RRcX+YFNy1UHSqhqi42Ha2yPL+shlf3w+Qpe9ZlyBvE7LMIMrD
         D5LJEsTaUTyfUiihzCccoXS/SrFCzscWrKyj2GJsTOB1NjWWIMa4Ik3JKLDEuDI8qgCk
         i2UJV0OP0TvRPFmLJkbkMuIKsH8ON/3NeO0CfEbcgooL3/S3R+WKYXxM8pxx+UpAuYBs
         mRAJNLgxdJmBmWM7XzN8EhZLi+OW8HiZw8MTKrsN4ZyREq1LVQi9uYh2P9k2iTa8CuKl
         c4jQ==
X-Gm-Message-State: AOAM530qv6EPm49TiTpWSptKd3Ytp2D+7sF32U9kv6kBaIvVraZN39WC
        q7AxKZVlxY9qEZRgMXhsiczCL0P9mWU+jhIr1nd/w4fQGGDVPGNTB8TbPpbJ44UaggdsAqTLxEh
        0Qmx8o4YtWzL/
X-Received: by 2002:a05:6402:31ae:: with SMTP id dj14mr2679096edb.364.1612517026080;
        Fri, 05 Feb 2021 01:23:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxwaOxnMgmRd1FH9QlvhwcxYAbQQGCrlD28vpdIaD0/S1MV/imltd7xAXtWyCQ5A8RzkVZZrw==
X-Received: by 2002:a05:6402:31ae:: with SMTP id dj14mr2679084edb.364.1612517025966;
        Fri, 05 Feb 2021 01:23:45 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k3sm3645996ejv.121.2021.02.05.01.23.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 01:23:45 -0800 (PST)
Subject: Re: [PATCH v4 2/5] KVM: X86: Expose PKS to guest
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210205083706.14146-1-chenyi.qiang@intel.com>
 <20210205083706.14146-3-chenyi.qiang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <89c82d11-8206-1ad9-9dfd-666d34685109@redhat.com>
Date:   Fri, 5 Feb 2021 10:23:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210205083706.14146-3-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/02/21 09:37, Chenyi Qiang wrote:

> +	/*
> +	 * PKS is not yet implemented for shadow paging.
> +	 * If not support VM_{ENTRY, EXIT}_LOAD_IA32_PKRS,
> +	 * don't expose the PKS as well.
> +	 */
> +	if (enable_ept && cpu_has_load_ia32_pkrs())
> +		kvm_cpu_cap_check_and_set(X86_FEATURE_PKS);

This piece should be a separate patch, added after patch 4.

Paolo


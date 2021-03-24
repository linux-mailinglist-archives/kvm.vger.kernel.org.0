Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CE1348563
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 00:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238797AbhCXXjZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 19:39:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58297 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234894AbhCXXjH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Mar 2021 19:39:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616629147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IwWYUWbH/O+ZLyF6/ulGgJAuRE4t3ADflrWSsYnyfOo=;
        b=ShUVOlFY9epW9ETZpmaefWAT8X0iDk4ijnQIROyYMXicAUS1sIw+bxdLwhDLv1JO1F5KfV
        5SPuih9Xm99lh2kxUT0bDZVVVsqfmjTWex8lUCpAhurMdvhsHuCRDDlIQrwyMqPs3twRg1
        0HH9eQUU9yYSZz6wMgZgTRgTP69buuY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-nMrS_klkO0yr0i8gZIXCog-1; Wed, 24 Mar 2021 19:39:05 -0400
X-MC-Unique: nMrS_klkO0yr0i8gZIXCog-1
Received: by mail-wr1-f72.google.com with SMTP id i5so1749998wrp.8
        for <kvm@vger.kernel.org>; Wed, 24 Mar 2021 16:39:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IwWYUWbH/O+ZLyF6/ulGgJAuRE4t3ADflrWSsYnyfOo=;
        b=o8LHDgjFjpwMWoduK6jm1wQoc7Qo01FIg6r4WQkPOH92j0hKqkbJpVH/y92aJuPz17
         NE9GobwgFd23BHC+zBVCHpwH9E06fPSUNlg3xg+5KvQczflMDS3MAuPtjydiWHaUUzQY
         B6zNSHSkreGL7qN0Er8vqq7T5Si0XAimdF/99dWggz6SWK32GpYPXPHTR46GDm3doLLz
         uzEDKxQLyf9JUU4jiQexyx9R2siEKp5IegoVU50XGANrfMS1kECiZ96XeNMCcC0ojHaC
         Qx7g9emyztNiBMmExXpoCaTg82i87WLtrAYCeRqBo/bJ1I5xEG2OtxqRy6p0hJyGlVFF
         QnaQ==
X-Gm-Message-State: AOAM530GKP8jC+xIXoMeijGNjIWznMecy3jM9V36fwjR2/7McpK5z6t3
        0tDpMME97wQhW7HSDr4y4r/UaBehepHDcC5VK/P4mPbI2PqHS2zhxWnTg6IV8+/ij2qvXlkqddD
        8YN6PNLOG/wvB
X-Received: by 2002:a7b:c399:: with SMTP id s25mr5003490wmj.124.1616629144398;
        Wed, 24 Mar 2021 16:39:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxXwn0MoeyxCDyz8NSf8yX5IpbArGpPL9aZKH6/X67zK8iNOQIaVxgtrIvPshMsUd92GFsCIA==
X-Received: by 2002:a7b:c399:: with SMTP id s25mr5003479wmj.124.1616629144189;
        Wed, 24 Mar 2021 16:39:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id 21sm4308042wme.6.2021.03.24.16.39.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 16:39:03 -0700 (PDT)
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
To:     Kai Huang <kai.huang@intel.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
References: <YFjoZQwB7e3oQW8l@google.com> <20210322191540.GH6481@zn.tnic>
 <YFjx3vixDURClgcb@google.com> <20210322210645.GI6481@zn.tnic>
 <20210323110643.f29e214ebe8ec7a4a3d0bc2e@intel.com>
 <20210322223726.GJ6481@zn.tnic>
 <20210323121643.e06403a1bc7819bab7c15d95@intel.com>
 <YFoNCvBYS2lIYjjc@google.com> <20210323160604.GB4729@zn.tnic>
 <YFoVmxIFjGpqM6Bk@google.com> <20210323163258.GC4729@zn.tnic>
 <b35f66a10ecc07a1eecb829912d5664886ca169b.camel@intel.com>
 <236c0aa9-92f2-97c8-ab11-d55b9a98c931@redhat.com>
 <20210325122343.008120ef70c1a1b16b5657ca@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8e833f7c-ea24-1044-4c69-780a84b47ce1@redhat.com>
Date:   Thu, 25 Mar 2021 00:39:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210325122343.008120ef70c1a1b16b5657ca@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/03/21 00:23, Kai Huang wrote:
> I changed to below (with slight modification on Paolo's):
> 
> /* Error message for EREMOVE failure, when kernel is about to leak EPC page */
> #define EREMOVE_ERROR_MESSAGE \
>          "EREMOVE returned %d (0x%x) and an EPC page was leaked.  SGX may become unusuable.  " \
>          "This is likely a kernel bug.  Refer to Documentation/x86/sgx.rst for more information."
> 
> I got a checkpatch warning however:
> 
> WARNING: It's generally not useful to have the filename in the file
> #60: FILE: Documentation/x86/sgx.rst:223:
> +This is likely a kernel bug.  Refer to Documentation/x86/sgx.rst for more

Yeah, this is more or less a false positive.

Paolo


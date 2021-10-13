Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7232842B8B5
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 09:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238364AbhJMHRu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 03:17:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43010 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238347AbhJMHRt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 03:17:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634109345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=35PL8mBr5TTmUiVi2XJDDdVJheYoEo4drXok79snLSY=;
        b=cS8zFzO9RUTy7lU1tcvz8VSxspa78vjADQOLJ9+TMNi9vPJgq32duz9sTzomaVH9Ahg4Va
        okfybFWB6f7L+NXKBkOhIV2bdhB3JCGGt2UDaChQab36ODACEaap3GIWsjYRx7W8/ASFYp
        YyZepoZrkVLYPHWfJncHsb5YhCMqWwg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-93-aaCBZSHBMsee9tR4E9qi9w-1; Wed, 13 Oct 2021 03:15:43 -0400
X-MC-Unique: aaCBZSHBMsee9tR4E9qi9w-1
Received: by mail-ed1-f72.google.com with SMTP id c30-20020a50f61e000000b003daf3955d5aso1420193edn.4
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 00:15:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=35PL8mBr5TTmUiVi2XJDDdVJheYoEo4drXok79snLSY=;
        b=D82Knkpyxa30m6PeoHEJPRuqm110Ib07dXGmKAIWwuiEqnlsncnu1sgJXpr0/bBqv5
         1MqO0x6nsqkB1PUMAJBA6ibv+Qe2YpekatPBqzRQBXpLX6At2o6efJWyv0a+L2VAlZyx
         XDOtoH9qJzp41OtFdCwcdhuYE40VthQ5ITcoToao5jVwLM7ZQpnRkZ1PfQd4HEeapWr0
         rIz/QplNeweDMLjASaxn7BgKXegU1CBHaERAeS0UaYLm9+OuCggwtZvLPdGsHiRSaa1W
         4eCgl7I9Bc8fp+9FM1XZHx2I09NWoEkl9nEU4mM393UVz0VP9SYmF3Zhc9X0eQMO4YGx
         Fayw==
X-Gm-Message-State: AOAM533hfTElKVpG3IY7vwY5PqnGBOwh2rNo0Av4DrxnXeO1Fk47i9fJ
        CL6P2SLLRyS3MIBzLg3yMaUREE4MiaIO/XT8TMkHZi6b0GGwk+MNyFL+88LY026u8buYYgSQFzZ
        Rc4oc6Znxovem
X-Received: by 2002:a17:906:4452:: with SMTP id i18mr37328487ejp.374.1634109342797;
        Wed, 13 Oct 2021 00:15:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzyWbF0GMWHEf+lA7ZzCQD8G6e2mMqmfRefQt6KvjaEIKm26V95VJZw/dpzrSxAsfIz2JWHqA==
X-Received: by 2002:a17:906:4452:: with SMTP id i18mr37328452ejp.374.1634109342533;
        Wed, 13 Oct 2021 00:15:42 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v13sm7451288edl.69.2021.10.13.00.15.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 00:15:41 -0700 (PDT)
Message-ID: <a99ed8a3-249d-5cf5-1567-56c4014678f1@redhat.com>
Date:   Wed, 13 Oct 2021 09:15:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 0/2] x86: sgx_vepc: implement ioctl to EREMOVE all
 pages
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dave.hansen@linux.intel.com, seanjc@google.com, x86@kernel.org,
        yang.zhong@intel.com, jarkko@kernel.org
References: <20211012105708.2070480-1-pbonzini@redhat.com>
 <YWaCu2Us+H+BSbYW@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YWaCu2Us+H+BSbYW@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/21 08:54, Borislav Petkov wrote:
> On Tue, Oct 12, 2021 at 06:57:06AM -0400, Paolo Bonzini wrote:
>> If possible, I would like these patches to be included in 5.15 through
>> either the x86 or the KVM tree.
> 
> You mean here 5.16, right?

No, I mean 5.15 because it literally cannot break anything that was 
working previously and the functionality provided by the ioctl 
(resetting VMs) is important.  But it wouldn't be a big issue if it was 
5.16 only.

Paolo


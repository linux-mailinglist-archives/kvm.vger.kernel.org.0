Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53994096DA
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 17:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhIMPQK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 11:16:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60272 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347040AbhIMPP2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Sep 2021 11:15:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631546052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qLiPuLulR0KEA9PC+ni4AmJzEqtKLqvlUOW8UTnUXUA=;
        b=HYS2THED2ZdQRmXugH6N8vIFfj97hWGef8eHvkPFT/185xTu7/0M1ORz//x/DcEkNZ7j25
        KVXfWTauN8EtHPMdmo8kBuBCkDE5Gam45CaMI06peXuxoubGO0GaItJim8q1bPaBJ4KNGo
        T70+dkR8rTUqXfp07EoF+i6xzlzNIK8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-wJlm2M4KM1Wj-c6Y5QD1iA-1; Mon, 13 Sep 2021 11:14:11 -0400
X-MC-Unique: wJlm2M4KM1Wj-c6Y5QD1iA-1
Received: by mail-ej1-f70.google.com with SMTP id bx10-20020a170906a1ca00b005c341820edeso3825239ejb.10
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 08:14:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qLiPuLulR0KEA9PC+ni4AmJzEqtKLqvlUOW8UTnUXUA=;
        b=nyputlornnCjQPkhQ+kqYFO5Jw27pujlIOSIQUm53o+xuHt9D9Wf2Diy9gX3ZNhDy/
         qXKaM4ajI9IzE0pFQZq8In3pX6yk+DssdgtBBV1aP5HV1erVTtQRJY4QHDp6vf9BSpdX
         2/5AcX0Bi6+Bww8LE5sPLA/ahsVXxd2gaMrzEvy5Dd7g9C64o4dWO5ygA/cXnK05ASs6
         H2gi1BKhIGTGKJSqNs2NRLrp1ejvpcvQAV+SUPBQh0J4W3uDZozW3jg5yVdzbrX15PgL
         udGsh8smQQg9AMr6/K1vixCkGMQH/nVNpu3wTILc+40JEnbU5yjrqJ8ms/Yzfa4JKK3+
         q2Ug==
X-Gm-Message-State: AOAM532zq9JqqrH+Qpj8INm4jte3cOwa0yg/czbQ0HJ+CtMJF3LhH27P
        Uxo/DHpzFpAESu1et35/j6z8patUujurLToIGOXxcsTWq/Y1JDT3tOyLSjvGRFcqnrJwET3JSC7
        Rr+i/5iPSq0Kj
X-Received: by 2002:a05:6402:26c4:: with SMTP id x4mr10020103edd.95.1631546050204;
        Mon, 13 Sep 2021 08:14:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXlKwyLGX/MszHYats7cUI5Peb1wU+RRlbm432xsjeZYS7I2KrziDTrcT1CMh7Kk82MNf3XA==
X-Received: by 2002:a05:6402:26c4:: with SMTP id x4mr10020087edd.95.1631546050016;
        Mon, 13 Sep 2021 08:14:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id eg14sm4193586edb.64.2021.09.13.08.14.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 08:14:09 -0700 (PDT)
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, yang.zhong@intel.com
References: <20210913131153.1202354-1-pbonzini@redhat.com>
 <20210913131153.1202354-2-pbonzini@redhat.com>
 <dc628588-3030-6c05-0ba4-d8fc6629c0d2@intel.com>
 <8105a379-195e-8c9b-5e06-f981f254707f@redhat.com>
 <06db5a41-3485-9141-10b5-56ca57ed1792@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] x86: sgx_vepc: extract sgx_vepc_remove_page
Message-ID: <34632ea9-42d3-fdfa-ae47-e208751ab090@redhat.com>
Date:   Mon, 13 Sep 2021 17:14:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <06db5a41-3485-9141-10b5-56ca57ed1792@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/09/21 16:55, Dave Hansen wrote:
>> By "Windows startup" I mean even after guest reboot.  Because another
>> process could sneak in and steal your EPC pages between a close() and an
>> open(), I'd like to have a way to EREMOVE the pages while keeping them
>> assigned to the specific vEPC instance, i.e.*without*  going through
>> sgx_vepc_free_page().
> Oh, so you want fresh EPC state for the guest, but you're concerned that
> the previous guest might have left them in a bad state.  The current
> method of getting a new vepc instance (which guarantees fresh state) has
> some other downsides.
> 
> Can't another process steal pages via sgxd and reclaim at any time?

vEPC pages never call sgx_mark_page_reclaimable, don't they?

> What's the extra concern here about going through a close()/open()
> cycle?  Performance?

Apart from reclaiming, /dev/sgx_vepc might disappear between the first 
open() and subsequent ones.

Paolo


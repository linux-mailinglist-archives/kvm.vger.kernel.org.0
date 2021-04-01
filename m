Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32A5351C19
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237273AbhDASM7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:12:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38559 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238811AbhDASKL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 14:10:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617300610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xv+Pbo9BsDaxHEPqTaSp/17FWyhcUzyTO3hRFKXF7lA=;
        b=J4S8SI8I93fw2dAuBIkNSxZh/kbf2TzFzawIi3ILYYyi1ZmW0VX7mdYGL0yKEtX/7HO0EE
        LsxoDsdUNCmlVPYDPmFgM3ix+dgLj/MV4ZgmPPmTXVno+7k4AWEH3l1qE1t7ajg67czrYh
        IJAejqETwkK7TuwQZ2B3yKmnfMX7+0k=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-1CGGiDYyN9Gb_NvXu4_krQ-1; Thu, 01 Apr 2021 12:09:38 -0400
X-MC-Unique: 1CGGiDYyN9Gb_NvXu4_krQ-1
Received: by mail-ed1-f71.google.com with SMTP id i19so3086906edy.18
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 09:09:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xv+Pbo9BsDaxHEPqTaSp/17FWyhcUzyTO3hRFKXF7lA=;
        b=LuRJUAGRaYlTERzYwploY7848nuI3CPO5IugFeeEJnbk64fkHmCkrA0jTbxRdNdHY0
         wZm+1PcODd4HYQ6Pj4+gbGHuVwWRnsgYNMcjZFaOTAQOLdGN6kIkI1ss8lw7ap4i5G++
         DkGe319JNmjT/mjxCYjuBbxxE/EDv8uCHWlonmVsywdWqhnmwq3HnMhmdSRItOj5cAjb
         dTgxI7o+K8KBJxzT7bTxwa7ey4Ge7VKInU43lXZzoKBZUp9K1tf44dAdkQQGIuGiyyNp
         VVlAl+B2ZzdH72/XmDI334kSQhxeRZx+ybqMuZQtFPWIr//I1FoAtOpuqbSOeiGL9E/n
         gmeQ==
X-Gm-Message-State: AOAM530ROfcUA3Bw38Br83edWyVXtMsbR1rSljZbt8zaWeRR/P3kTP9w
        Sr0c5tw8ghE/nYdgQsQ/ikIcPKkfHUUAZkmEbgI7AS+hz9SSOI//O0Ck2crh1lNuVMCHy774hPR
        rlJSPnt+Ykn1A
X-Received: by 2002:a17:907:2642:: with SMTP id ar2mr9862361ejc.145.1617293377248;
        Thu, 01 Apr 2021 09:09:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6ppL5P4P36VnMm3WCMH3+54G3YlZIPmCnjq1u92MAzaaE8C+iDAmQ6kDVnaAmAvTAyAJtqQ==
X-Received: by 2002:a17:907:2642:: with SMTP id ar2mr9862335ejc.145.1617293377065;
        Thu, 01 Apr 2021 09:09:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s20sm3805227edu.93.2021.04.01.09.09.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 09:09:36 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: use KVM_{GET|SET}_SREGS2 when supported by kvm.
To:     Maxim Levitsky <mlevitsk@redhat.com>, qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>
References: <20210401144545.1031704-1-mlevitsk@redhat.com>
 <20210401144545.1031704-3-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d221fa13-8e3b-0666-ff15-8c86d4e08237@redhat.com>
Date:   Thu, 1 Apr 2021 18:09:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210401144545.1031704-3-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/04/21 16:45, Maxim Levitsky wrote:
> +
> +    for (i = 0; i < 4; i++) {
> +        sregs.pdptrs[i] = env->pdptrs[i];
> +    }
> +
> +    sregs.flags = 0;
> +    sregs.padding = 0;
> +
> +    return kvm_vcpu_ioctl(CPU(cpu), KVM_SET_SREGS2, &sregs);
> +}
> +

This breaks when migrating from old to new kernel, because in that case 
the PDPTRs are not initialized.

Paolo


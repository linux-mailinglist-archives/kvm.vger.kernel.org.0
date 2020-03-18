Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E29EA189A15
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 11:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgCRK7T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 06:59:19 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:31589 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726550AbgCRK7T (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 06:59:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584529157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CMtZ4jmJycvgiYeU4inzJpOO5pgYuaE53x0jqDSCJMY=;
        b=ABwYvkSKjrJTN9oVCeWZYqL1mDj7yumgWiQgFNoz+07clDA1rrhV3ruynqEW8Xpi3hI4T5
        s1hjT3djUcNOR94cGbPIFPsTN/AuF/SI9rloALkCrA3kql1WPZm2D9DHv3wTNR0yybpyL4
        ihCfMdVLrXpS2XLa/KNBnJZuRyukGCs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-W4YU0OgeNf-e8GmNVLWHCw-1; Wed, 18 Mar 2020 06:59:16 -0400
X-MC-Unique: W4YU0OgeNf-e8GmNVLWHCw-1
Received: by mail-wm1-f71.google.com with SMTP id 20so855116wmk.1
        for <kvm@vger.kernel.org>; Wed, 18 Mar 2020 03:59:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CMtZ4jmJycvgiYeU4inzJpOO5pgYuaE53x0jqDSCJMY=;
        b=pCIsDBFTDg7gAoGmdVT2ju3lud3Le/FqPRvEg/8uDDUcT6iavp6aXiHL4Sk9dm8m8q
         ILDZPBGjmLtF43IjEj1OF22u67I9Hk7Bq5xDvgSoQO2jSD96/rVCE0nJiAN6Vb8burYz
         tkHQbiqy4iHir/Cf7gqnYRhel9DhLy/MuhGPsAmrduq115AWGEj7vZtjiqczWAWsiUf8
         mW0GYPACn4GgiIeDS2zKv6fKEFboqrayiUUkjtydXxBCRE/ahd/vlJH04jJkgpBM7tO9
         dJ9Zatwf+15zIgoYmb2pXKbJ6NtFkGZgtRJiBrdYDv/YghkyE5ikr5ePC28ATV3sZcu8
         gfrw==
X-Gm-Message-State: ANhLgQ2zggJERVxyWIbpcY0gUV8F6weIIUmd2bjdU3bGrvZqaBtC4/Sa
        eSfcPhgYW5tZY2aodSFeK9iymDO/MQ0FSmAIbWG54Z2tjS8FRTcBXuHvzDuo1nKNH2FwV20lTTF
        haohwRj5j8ZZ4
X-Received: by 2002:a5d:4088:: with SMTP id o8mr5101800wrp.144.1584529154939;
        Wed, 18 Mar 2020 03:59:14 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsqJPtOCO7Bop1hF8dkWynp+0emhgYuxiGeDzjWNh+m03OZOuGNFzkn+9eJ8E5YITVCMV0eaQ==
X-Received: by 2002:a5d:4088:: with SMTP id o8mr5101782wrp.144.1584529154751;
        Wed, 18 Mar 2020 03:59:14 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.43])
        by smtp.gmail.com with ESMTPSA id 19sm3498623wma.3.2020.03.18.03.59.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 03:59:14 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: remove side effects from
 nested_vmx_exit_reflected
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     sean.j.christopherson@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <1584468059-3585-1-git-send-email-pbonzini@redhat.com>
 <87tv2m2av4.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <803177a8-c5ef-ac5e-087b-52b09398d78c@redhat.com>
Date:   Wed, 18 Mar 2020 11:59:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <87tv2m2av4.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/03/20 11:52, Vitaly Kuznetsov wrote:
> The only functional difference seems to be that we're now doing
> nested_mark_vmcs12_pages_dirty() in vmx->fail case too and this seems
> superfluous: we failed to enter L2 so 'special' pages should remain
> intact (right?) but this should be an uncommon case.
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

I'm not entirely sure if the PID could be written before the processor
decrees a vmfail.  It doesn't really hurt anyway as you say though.
Thanks for the review!

Paolo


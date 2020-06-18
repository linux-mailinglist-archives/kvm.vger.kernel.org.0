Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DA81FF015
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 12:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbgFRK7h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 06:59:37 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55398 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727805AbgFRK7g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Jun 2020 06:59:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592477976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JKYDHbOIwakxAk9gU87oflPaq58X99KzHMMUU7Bumwg=;
        b=gTiPlpWoTkyl4uM3SNdmb99amQ14K7tBgwVzkY+YEJ70VuNSRe5vdojq/w9EDcTAobdfte
        uSncfYyKav7aMnNgWFnXDCukD5Ilx5rR2/n94Rvm2pNYYcO40MSo1k8Oh9rox+c2hhW46G
        gpEjjePg/YRZC5UWsFiz81sM+FguMb8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-kPRe5aYPMUeQdCs2Hoip3g-1; Thu, 18 Jun 2020 06:59:34 -0400
X-MC-Unique: kPRe5aYPMUeQdCs2Hoip3g-1
Received: by mail-wm1-f71.google.com with SMTP id p24so2435134wmc.1
        for <kvm@vger.kernel.org>; Thu, 18 Jun 2020 03:59:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JKYDHbOIwakxAk9gU87oflPaq58X99KzHMMUU7Bumwg=;
        b=OWl0yglk4mtU/4SZt92qT1pri0gZhnXYCL9XZi6jLz2O/d4iV0fA8gWjfDWyy1LUuU
         e4IylUCDMnbkSHmQ5BGjBgnt3jvXbDbzqy6rLGWnP375jplQ+rjKakB19m+TB+yRJG+c
         yFXnTHj+SN8W/8RmsP/j9lfjzeaP6aimBJYYch0foGoefboa98plOZV4cgtQumWOC4F7
         iAmaXTOd4LBRyh1EZlz9qloEqvsIlOcWuEfE/u60Pr21IjL+eKepfert6SKzNwiYXzGy
         o1TNwFAh6yVGQDa9AhGEIjkfVFidgDw6zFZ+DIlZr73pTQVNVLZWqGyZzMQvM0mL4JqY
         vwjQ==
X-Gm-Message-State: AOAM531u/Bo2VpgAYvmiwOriKhcYC4MBJE6cWx79uS+8Il4HGb1YNngm
        jTVDXpQozD7thpBPceNSXobdWKtGLrqOo8XT0NRqJehdRaTXryTSk5KUGfw75drCZwmzWMNSs/M
        +nVmSHMCVb54Y
X-Received: by 2002:a1c:4189:: with SMTP id o131mr3222177wma.183.1592477973141;
        Thu, 18 Jun 2020 03:59:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy6Iih798uLkV/EDQFj/uqQutOMqIF5xyoZeaOIzY7zBzemZa0ofo2dsNv7mBsvFwbVMwztmw==
X-Received: by 2002:a1c:4189:: with SMTP id o131mr3222158wma.183.1592477972957;
        Thu, 18 Jun 2020 03:59:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e1d2:138e:4eff:42cb? ([2001:b07:6468:f312:e1d2:138e:4eff:42cb])
        by smtp.gmail.com with ESMTPSA id y16sm3081659wro.71.2020.06.18.03.59.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2020 03:59:32 -0700 (PDT)
Subject: Re: [PATCH] target/arm/kvm: Check supported feature per accelerator
 (not per vCPU)
To:     Andrew Jones <drjones@redhat.com>
Cc:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        Haibo Xu <haibo.xu@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20200617130800.26355-1-philmd@redhat.com>
 <20200617152319.l77b4kdzwcftx7by@kamzik.brq.redhat.com>
 <69f9adc8-28ec-d949-60aa-ba760ea210a9@redhat.com>
 <20200618085726.ti2hny6554l4l5kt@kamzik.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <38dc2adb-d567-cd45-21bd-f68cebbab98a@redhat.com>
Date:   Thu, 18 Jun 2020 12:59:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200618085726.ti2hny6554l4l5kt@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/06/20 10:57, Andrew Jones wrote:
>> If it's a test that the feature is enabled (e.g. via -cpu) then I agree.  
>> For something that ends up as a KVM_CHECK_EXTENSION or KVM_ENABLE_CAP on 
>> the KVM fd, however, I think passing an AccelState is better.
> I can live with that justification as long as we don't support
> heterogeneous VCPU configurations. And, if that ever happens, then I
> guess we'll be reworking a lot more than just the interface of these
> cpu feature probes.

Yes, and anyway configuring "what is allowed" would be separate from
checking "what is supported".

Thanks,


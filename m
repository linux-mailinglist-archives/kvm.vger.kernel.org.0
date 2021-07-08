Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2E5E3C15E0
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 17:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbhGHPYt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 11:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbhGHPYs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jul 2021 11:24:48 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A9FC061574
        for <kvm@vger.kernel.org>; Thu,  8 Jul 2021 08:22:06 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 62so6366844pgf.1
        for <kvm@vger.kernel.org>; Thu, 08 Jul 2021 08:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Z3+Q9ODZjlDSPdw6IBnWtOgaR7okcL3u6WMzL8uhktM=;
        b=TK+EvJmx8qRhfYKj98Cx+gUzBDcQ+DyHGcsppJeLx++a6IHg4CURREFfoE5XgtsG6J
         bQR1o+K2lONhQzWuiYhBSB6D6EKjcgKS57cK32WcZpbgh+RZNVp2jxZOGe+jk/YMdPnb
         pvakJYdPz7bpsoa30EyU2U8rvchu14NymqWjL0Q8sx4y/gg2QFb/QM1vcXngf0Skg+7r
         cETAWDe0CY5Hp3iU6HS+LZYaM7NtsV+BYpg/c4lJ2aMfaMsh+rfw2RLx1HmPRkKi/hzz
         ShnL5A6+j+d8bzKZ/03SiicXnelu0tvYuOdBBk4DbK5/iTwzmWg5zBEiWAEU3sdE0HBO
         e+cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z3+Q9ODZjlDSPdw6IBnWtOgaR7okcL3u6WMzL8uhktM=;
        b=nyxQ5IOH+zBKNzjKy6pQH1fySyrv5NsNFZ5UTVtZ6WxuzLQB1dnEu8sT9uB8jSdsh9
         ppXJBiK8kED8nwBAuTE9T2UZC7FhUoMTbUUjomcPewOutc+IY6aRjOWEgdbFfitMV0MU
         5cUQhYRIhwdcdHh0m6Z/Os2iy4tnlAb47z2hRJQOP3Bg5WrgCdeNyB4o2o3Xg/K4IRfu
         rtWCz2OcKeNKCidRPYscNnvOnn1sMllp1tlFVmSgFnNOqYaVeb38L/0g1xH2cdBnG8XA
         UDTDXvfy143oynFP3LzPZ5/mIp9HC8eC1wp8GcUvczUeXtWCOJskjuAVfgv32c6gkbPy
         RQ2g==
X-Gm-Message-State: AOAM533Kf9+e2GtHXYINOFoLgYkU99a61Zbx9jsBTDkhH2DftEJdFfCE
        T1JEu9WhcTs7aBOKr+tThLZDaA==
X-Google-Smtp-Source: ABdhPJzWKTHnsttocosGQjtRPjfaTz1zKUbtbCwB3uWhuMfWcpm51tAxUa03Ml/Fb/HwBoANJSJr4Q==
X-Received: by 2002:a65:68c1:: with SMTP id k1mr32443829pgt.335.1625757726261;
        Thu, 08 Jul 2021 08:22:06 -0700 (PDT)
Received: from [192.168.1.11] ([71.212.149.176])
        by smtp.gmail.com with ESMTPSA id k5sm3110066pfu.202.2021.07.08.08.22.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 08:22:05 -0700 (PDT)
Subject: Re: [RFC PATCH 8/8] target/i386: Move X86XSaveArea into TCG
To:     David Edmondson <dme@dme.org>, qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Cameron Esfahani <dirty@apple.com>, babu.moger@amd.com,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20210705104632.2902400-1-david.edmondson@oracle.com>
 <20210705104632.2902400-9-david.edmondson@oracle.com>
 <0d75c3ab-926b-d4cd-244a-8c8b603535f9@linaro.org> <m2czru4epe.fsf@dme.org>
 <m24kd5p7uf.fsf@dme.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <e4a048f5-cc6d-7bbe-6659-54075cafb9c6@linaro.org>
Date:   Thu, 8 Jul 2021 08:22:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <m24kd5p7uf.fsf@dme.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/8/21 12:45 AM, David Edmondson wrote:
> Actually, that's nonsense. With KVM or HVF we have to use the offsets of
> the host CPU, as the hardware won't do anything else, irrespective of
> the general CPU model chosen.
> 
> To have KVM -> TCG migration work it would be necessary to pass the
> offsets in the migration stream and have TCG observe them, as you
> originally said.
> 
> TCG -> KVM migration would only be possible if TCG was configured to use
> the same offsets as would later required by KVM (meaning, the host CPU).

And kvm -> kvm migration, with the same general cpu model chosen, but with different host 
cpus with different offsets?

It seems like we must migrate then and verify the offsets in that case, so that we can 
fail the migration.


r~

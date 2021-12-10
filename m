Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F9F4705C0
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 17:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243521AbhLJQea (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 11:34:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243506AbhLJQea (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 11:34:30 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A965FC0617A1;
        Fri, 10 Dec 2021 08:30:54 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id r25so31204889edq.7;
        Fri, 10 Dec 2021 08:30:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QyyEZSg62CUGQrR/JY1N25k8MMdyiG5r1T7BESy/8iU=;
        b=l6YUCAjLA0ZPxv9qpax9/tkyAgQuL0jB36tdFk+BWQ5VYbRmUgk75sQyxWOpCWl6QG
         bq7C5x4V0MekpTrUDv3Bf1ndMAa1gwmaHJIg+m8mWMvL/lsbTU/85H7qjwGPhw3OXx1M
         uLX/Shp7YbHWWzgXJVpUZ3WXD2R2fjisOjfuXhn/eewlOYMGAHV9BPgJ9Ay3qL/xrpoE
         cqwjiBxW+gyty/mg8l++aE5c0R4C8ERpTedWmj8A47kANjsdOHkzI1llWmuZxSF9mamX
         aSoITmYsrcWfXXYKreTi17r+4te/zvbS+HumkJGyiTdYAUrmNCgig4LcTEX+Cj1o9tKy
         uhRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QyyEZSg62CUGQrR/JY1N25k8MMdyiG5r1T7BESy/8iU=;
        b=7LySGFsWUpBmR7jaM630SqJMIDbbPxA9tVeg6xo20PASach++3vKJT7X+p0BOkkAcZ
         ETMcB0Ap3yrFvi8w9WMwV7RcI854tc8/qvSdKSrxMi4BHsTmuulJTHHNmxWFx4C0CSD8
         uoPFA3923osJYCb2Fc3Wt8OJwLZlZXbopwMMyHwCuFBr/YfHk3JWCGJ2rHW41y8RPkxJ
         NJq9CFrnWXwLijSt2RKyez1nstQSd/826oS91hKFnbX4AUieMHUtaljUTlKXADoPtHFt
         LNQ/a96LeCUU7KtWmdCFJ7bQ5rtMgx9enaRJIci2FVVavySPg6HO/D2mXPVl9mzJsZ+Y
         PHnQ==
X-Gm-Message-State: AOAM530ImJpy3JrccTdu1Ru9L4wFxQw+6sUXJEnVevLy+MMhyYarTNU4
        05aC85FUxrmO5c7PQE75SmQ=
X-Google-Smtp-Source: ABdhPJxq9AxXtWpYm551ltAU4ryJ1RnS7IMBXGfsGYuQLfT6QiuQXGtxD7iJYJdlWWn+sAzdrOiibw==
X-Received: by 2002:a17:906:7e44:: with SMTP id z4mr24276540ejr.539.1639153852631;
        Fri, 10 Dec 2021 08:30:52 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:48f9:bea:a04c:3dfe? ([2001:b07:6468:f312:48f9:bea:a04c:3dfe])
        by smtp.googlemail.com with ESMTPSA id oz11sm1747169ejc.81.2021.12.10.08.30.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 08:30:52 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <fe3eaea3-5dc7-f727-7c1b-5149c83a2bc9@redhat.com>
Date:   Fri, 10 Dec 2021 17:30:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 18/19] kvm: x86: AMX XCR0 support for guest
Content-Language: en-US
To:     Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-19-yang.zhong@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211208000359.2853257-19-yang.zhong@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/21 01:03, Yang Zhong wrote:
> +
> +#ifdef CONFIG_X86_64
> +	if ((xcr0 & XFEATURE_MASK_XTILE) &&
> +	    ((xcr0 & XFEATURE_MASK_XTILE) != XFEATURE_MASK_XTILE))
> +		return 1;
> +#else
> +	/*
> +	 * Intel AMX instructions can be executed only in 64-bit mode but
> +	 * XSAVE can operate on XTILECFG and XTILEDATA in any mode.
> +	 * Since the FPU core follows SDM recommendation to set
> +	 * XCR[18:17] only in 64-bit environment, here also prevent any
> +	 * guest OS from setting the two bits when host is 32-bit.
> +	 *
> +	 * XFEATURE_MASK_XTILE cannot be used since it is 0 in this case.
> +	 */
> +	xcr0 &= ~(XFEATURE_MASK_XTILE_DATA | XFEATURE_MASK_XTILE_CFG);
> +#endif

This should not be necessary, because on a 32-bit system the bits won't 
be part of supported_xcr0.

Paolo

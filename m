Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765D3234416
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 12:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732484AbgGaKbR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 06:31:17 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23621 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732371AbgGaKbR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jul 2020 06:31:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596191476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CJSBXUFrdCM5TndrvSRo8Fs138MbvjvWCbgK7xvxags=;
        b=h95l92Yn+Gy0D8UcaOtnVorUCYirCkrq4mP6DrE9wevk3yrD5WtKi4aw118ft0h+kmGGpJ
        GkiF3xATAwFp+hXYw2ng4kn3Zw4xO+GGMpmk/eSAuAUtyUKVJCGgZHHLcy+1H9yEaZZ5MP
        qwNTTldA50nwR8UCFeH+LieH7AarXBg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-749nyEvfPEm-rAKQ1B_K2g-1; Fri, 31 Jul 2020 06:31:13 -0400
X-MC-Unique: 749nyEvfPEm-rAKQ1B_K2g-1
Received: by mail-wm1-f71.google.com with SMTP id p23so2007305wmc.2
        for <kvm@vger.kernel.org>; Fri, 31 Jul 2020 03:31:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CJSBXUFrdCM5TndrvSRo8Fs138MbvjvWCbgK7xvxags=;
        b=gRNcGDUxIpwhq4V0WhEH44KCQW+kT5mOb0A306F7FmeRUd3rLcg49H6VASwcBzvqd+
         V2OmXQEikjlAhA/gSNwpStkJGEZUzfQNZkKwtBxoLJaNSbbRa7mZfZGEPAKw+GHO/twK
         74ayYh+WH4RT+6eBtW/PE2C5TJ1ZfQHc7c0McdSSXhoC5xnGXOgnJuxBOssGqzNYcZj2
         eWtV/xFhu9ICmS0TTVKOhjpYngWpm/p0nlF6AqIR5ykuz7yG7nBWyUL+Eyu5yc/myolN
         l7PDlhwUwmtBiJ9IRwB2qSvgXLWMfC4Dnim5KZqmPS3F2a22C3OaL7mPypEg8Qae0JmK
         H6aQ==
X-Gm-Message-State: AOAM530hfh6Jm3gtTCANuGDm/Xp+CxRpVXNuB9s3fH1q9l3R5D01VlL0
        pfEwfmNfQZwinPcnNXBnBnhABR3l4dUIZwpEbE3rv8wkv0hfBRv7le3ozJtiHsdg5aY0U55qa6f
        4aiIWse12c0ox
X-Received: by 2002:a05:600c:2157:: with SMTP id v23mr3184593wml.38.1596191471834;
        Fri, 31 Jul 2020 03:31:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwAk54fcZLnkutyZ4lX9DRT11vUuBTupcPXiC6WHDu3DDohZJqB74vqGolh54pFZwDp0t0cMw==
X-Received: by 2002:a05:600c:2157:: with SMTP id v23mr3184576wml.38.1596191471641;
        Fri, 31 Jul 2020 03:31:11 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id p8sm14046645wrq.9.2020.07.31.03.31.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2020 03:31:11 -0700 (PDT)
Subject: Re: [kvm-unit-tests GIT PULL 00/11] s390x patches
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.vnet.ibm.com, david@redhat.com,
        thuth@redhat.com, pmorel@linux.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com
References: <20200731094607.15204-1-frankja@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dfce14f4-5e7b-9060-6520-06e7dd69cfa4@redhat.com>
Date:   Fri, 31 Jul 2020 12:31:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200731094607.15204-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/07/20 11:45, Janosch Frank wrote:
>   https://github.com/frankjaa/kvm-unit-tests.git tags/s390x-2020-31-07

Pulled, thanks.  FWIW you may want to gitlab in order to get the CI.

Paolo


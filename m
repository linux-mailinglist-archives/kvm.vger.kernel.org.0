Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A82A4A888A
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 17:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352196AbiBCQ1v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 11:27:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:26705 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234500AbiBCQ1t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Feb 2022 11:27:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643905669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TvtoUbTjDWkqI18DOGkApjx8cbtiG9lIMb6LYKtu3MM=;
        b=cMTjpwuWMX1gO33zC6pXZvQUjE824xnGO+DW2nSTF4SXXFTVJipRtBc2hXg0HRKerQNGnQ
        J+fSa3+Azh0MdSFKM2uTEwE5eBSQJ6u6EEcmdQg5RjKLer++xhIR/vFnhEtbY6c3E3u9rd
        GxmwcHhWpNpC1W26d3jJQ7798Q7OnPw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-byIqYunNNIuvVS3UVL0WdQ-1; Thu, 03 Feb 2022 11:27:46 -0500
X-MC-Unique: byIqYunNNIuvVS3UVL0WdQ-1
Received: by mail-wm1-f69.google.com with SMTP id m18-20020a7bca52000000b003552c4e2550so1402031wml.0
        for <kvm@vger.kernel.org>; Thu, 03 Feb 2022 08:27:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=TvtoUbTjDWkqI18DOGkApjx8cbtiG9lIMb6LYKtu3MM=;
        b=vlRfEZO0dUHmgqeEsjr9uIZfwMK4lzHYhaZ4OrZH4HH2dO6RJi5w9b6INfqd6GR8rO
         yBkzbBKU40Jrx3JQWwo7AuD+Glyl7R3PKr/GsDNSm7O8qBkQA9Ri1BWdCfm8KTRCugmb
         JIc1LO/EiqaRtmAczHbHuF6L9yVClbh4kC2RejFX48H+A9iRz+fjtrssFTMigwwNyxMi
         yQXrQzO+s2Q3JpyLa7ck3pcpUD7HAA/JLVtVu/K9Cp6RTq5Aoc78gclBuOQUZRHWhonL
         Z7hjjb2yPEhhNyh+b4YQ43vDL6+Z73oOYcO4/sGZHYO240ftahECvGnQYtzzs3wkukl4
         227w==
X-Gm-Message-State: AOAM533AsGNzQrTa0hu/e9yHWMP0ysUHSvT6qQlQttg0sik0u7RuTpOq
        sDOS/mZ0MS8RVS11AdZRiu51WqMOT7/2tClchAwSvO+ii1gXz2EpTISu/0+Y4BoTpolV8D4s4Vr
        pTW5utXtvvf/0
X-Received: by 2002:adf:d239:: with SMTP id k25mr29618589wrh.164.1643905665002;
        Thu, 03 Feb 2022 08:27:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyiJdiRN8GtIAr6m4aq4/8VRRQ6ZTZ6gbGHI7WZE8kgsesDh9XlkR6FQy2a7DtO56Poz/EfzA==
X-Received: by 2002:adf:d239:: with SMTP id k25mr29618568wrh.164.1643905664608;
        Thu, 03 Feb 2022 08:27:44 -0800 (PST)
Received: from ?IPV6:2003:d8:2f11:9700:838c:3860:6500:5284? (p200300d82f119700838c386065005284.dip0.t-ipconnect.de. [2003:d8:2f11:9700:838c:3860:6500:5284])
        by smtp.gmail.com with ESMTPSA id f12sm20405102wrs.1.2022.02.03.08.27.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 08:27:44 -0800 (PST)
Message-ID: <8bdae11c-845d-99a0-a448-87c4cdd11a2a@redhat.com>
Date:   Thu, 3 Feb 2022 17:27:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [kvm-unit-tests PATCH v1 1/1] s390x: firq: fix running in PV
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com
References: <20220203161834.52472-1-imbrenda@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220203161834.52472-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03.02.22 17:18, Claudio Imbrenda wrote:
> If using the qemu CPU type, Protected Virtualization is not available,
> and the test will fail to start when run in PV. If specifying the host
> CPU type, the test will fail to start with TCG because the host CPU
> type requires KVM. In both cases the test will show up as failed.
> 
> This patch adds a copy of the firq test definitions for KVM, using the
> host CPU type, and specifying that KVM is to be used. The existing
> firq tests are then fixed by specifying that TCG is to be used.
> 
> When running the tests normally, both variants will be run. If an
> accelerator is specified explicitly when running the tests, only one
> variant will run and the other will be skipped (and not fail).
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Fixes: 8b98745d ("s390x: firq: floating interrupt test")

If only I would have hardware to run PV and it would be easy to setup
for development purposes .... :)

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb


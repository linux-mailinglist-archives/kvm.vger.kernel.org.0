Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19CB435C66
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2019 14:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbfFEMPY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jun 2019 08:15:24 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35091 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727341AbfFEMPY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jun 2019 08:15:24 -0400
Received: by mail-wm1-f67.google.com with SMTP id c6so2050759wml.0
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2019 05:15:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/7xBh2yrx9momm4xAatlxfqPneZhcNcA9/eCD2/Xr5k=;
        b=VH0Zm09zpYRcuCEv5pqA9f1AOSGSSKCYSA1Bew9u/L+gzyD5L9lezxLd43oTBJnWbk
         CrT7I9WpyBSFmPqEoQtMDIcJ+UjaSQQ0Tfo6sK1sZMii99PaNQLNcWCLKqA+XxvxKDe6
         4U8Nq8jNkLZ/5ZEtaegfriecSLekL1RhYBQAYHaGWopPFeasalUN9A1Iz/6j5QlCJxh2
         3gNP+sDjVWolULqeFadk3fZcBRE4EQzYLQchtKrZiALGZaHYBkpZ5wyumXCpKjjwtS6C
         tir5AnRV2BlHUq6PCVugBigiNrmcKLKpXOr4O3zuhziCOBBJmWcqpicz59/xAjUvYvAh
         lzHg==
X-Gm-Message-State: APjAAAXeQd1OolaZCmuEEbX24Zo+ntdNQvBGnuifXep3galsKETwf8LE
        fAUxrlxMjd4SBlMCa3LIK90WyoZhtEA=
X-Google-Smtp-Source: APXvYqxOjEAwWl3iGC+4QY71LZxu161gGOGa32l2xZaHn0zYRfNZ2h95HIBvAr7kZ6rX8Ji2kAtupA==
X-Received: by 2002:a1c:c2d5:: with SMTP id s204mr22694874wmf.174.1559736921366;
        Wed, 05 Jun 2019 05:15:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id n4sm13647472wmk.41.2019.06.05.05.15.20
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 05:15:20 -0700 (PDT)
Subject: Re: [PATCH v2 0/4] kvm: selftests: aarch64: use struct kvm_vcpu_init
To:     Peter Xu <peterx@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
        rkrcmar@redhat.com, thuth@redhat.com
References: <20190527143141.13883-1-drjones@redhat.com>
 <ab872d9d-acb2-09cf-3cd2-c5340bcc2387@redhat.com>
 <20190605072626.GI15459@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0a2a03ec-31da-52a0-d5ba-f13f979ca6b1@redhat.com>
Date:   Wed, 5 Jun 2019 14:15:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190605072626.GI15459@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/06/19 09:26, Peter Xu wrote:
> Do we need a vcpu_setup() here?
> 
> There're functional changes below too but they seem all good but I'm
> not sure about this one.  I noticed that in kvm/queue patch 4 added
> this with the new function by Drew so at last it should be fine, but
> it might affect bisection a bit on ARM.

Yes, I'll fix this and post a tested version.

Paolo

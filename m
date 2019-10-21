Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2A4DF191
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 17:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbfJUPbB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 11:31:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56200 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727680AbfJUPbA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 11:31:00 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 85BC2883C2
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 15:31:00 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id k184so6141673wmk.1
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 08:31:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HXpSYYKAOP8qmSkuN9OQPmoeggjz/B9bVdloCHt7b9Q=;
        b=sfZ59/DGFKg7cnsehReri3Btnp6R71gEFplDJ2YNRJjOy2LIPyo7B21MF5a2ueguvQ
         XFMs+EfHM28pIx/hwdh1TFJTzhDRYQBNpTcRiJFNTJGFW18GYtTMvvnC1pSNtC8DnZQv
         Qun0W1uHNaAVUJpUxlaRXnHh2R4H30TWFhJ5BrWMHz1trrWcO5wqulszzcf7rp4xr/O2
         zyfGGIiwhxyPhTnwihqXmZf+Ndv8pIoNsgoZnHdxFhnJHJzipuyLEU/M/gWZ4dRMzz6I
         WDYmtSbTSt7hn0ypkjvdDoBti3L/+CeR/9XY+lOKzKRuXGrL7ylD5WMwuijn8zvyO8kR
         kkcA==
X-Gm-Message-State: APjAAAWWHBIMLjLaOir+h8r3/EwnuQc8EGqwvOZXq8i9YQHGZAVLCdBq
        QDdOxCGXAEEj1F5PsSzuUmI5XalRIJSfn300ssgIiXuUsaMTet3BzW7zs/oogJ9Ss+vysBrZT4x
        5LgEZcZ260yrh
X-Received: by 2002:a7b:cf30:: with SMTP id m16mr19967239wmg.89.1571671859148;
        Mon, 21 Oct 2019 08:30:59 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxTZ/lUVjW3sj3DfIBV7IL+Q0e6WVIFdjwvrO+qO4Vf7KPNSe2KjsRG/pv34P9t+UFKRzKAvw==
X-Received: by 2002:a7b:cf30:: with SMTP id m16mr19967224wmg.89.1571671858896;
        Mon, 21 Oct 2019 08:30:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:847b:6afc:17c:89dd? ([2001:b07:6468:f312:847b:6afc:17c:89dd])
        by smtp.gmail.com with ESMTPSA id d8sm2174955wrr.71.2019.10.21.08.30.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 08:30:58 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] Switch the order of the parameters in
 report() and report_xfail()
To:     Andrew Jones <drjones@redhat.com>, Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Bill Wendling <morbo@google.com>, kvm-ppc@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Laurent Vivier <lvivier@redhat.com>
References: <20191017131552.30913-1-thuth@redhat.com>
 <20191017133031.wmc7y26nsd63zle6@kamzik.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b6982589-33ff-db3f-d6f2-941a70cd0783@redhat.com>
Date:   Mon, 21 Oct 2019 17:30:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191017133031.wmc7y26nsd63zle6@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/10/19 15:30, Andrew Jones wrote:
> Paolo, do you want me to do PULL
> requests for all the arm-related patches?

Yes, that's why it's not merged. :)

This patch is mostly automatically generated, so Thomas can send me v2
after your pull request is in, and I'll apply it.

Paolo

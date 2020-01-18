Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B180141912
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2020 20:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgARTQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jan 2020 14:16:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33052 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727029AbgARTQR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Jan 2020 14:16:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579374976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ljqOMFUPHs2CCa3CqBiwq1O29UCmL1/e4RbgY//lTro=;
        b=EjIuYPjq2Pr7JmjDyn8bmOBtK7wnw8ryponXg4/f7VEJUsPj1zF2PoTLPfR+o9+b1HWWvV
        VW3n8Vi3ZzZCb26SbOIBkkT6q+hqdALTbnFP9etQjtklgjSS7y+ALZS89QWGn2NFitQyBX
        bBZu+8EaijYNLJVQz4CWlGxUMOpByOg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-qHjlGN7bMxegQdXsqZfMyQ-1; Sat, 18 Jan 2020 14:16:15 -0500
X-MC-Unique: qHjlGN7bMxegQdXsqZfMyQ-1
Received: by mail-wm1-f70.google.com with SMTP id l11so3619966wmi.0
        for <kvm@vger.kernel.org>; Sat, 18 Jan 2020 11:16:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ljqOMFUPHs2CCa3CqBiwq1O29UCmL1/e4RbgY//lTro=;
        b=cM8vGpeATHK+euRXpqeDmra+CKbtZepFoikaVKCEzZ2/pmENdOn4ixy8CKscBqIl+s
         4ZvpHYki6G8+oByQL/KLZVTt56gYFLkMRDzJjVJ3pkZgJSALwQVu+J8cWN/VzqHs4G8L
         5QCpPrtid7FZwqqDEhQF5mmFHttjUKzqFzn92nag2cZh9wwI8Dm9Qs/4YMsOA7jioIwU
         +PsaCD9px/f0ps4AADGjTdtGtsaXSbJ+SmVNqPxXVeXjVq+G61aENi3Z5pB/pFEE3FGv
         6brKKCdM68QBO1u/l81Dx+t+8sb04pUJZXIWDSnvjlxiKIN6blsGX+o0SHbk6OjtiTuX
         CGXQ==
X-Gm-Message-State: APjAAAX8YokKg0+MvzQc4LHoLlajxvhyG17YqmD91W8/XNugajzfh1Dq
        yzxk4f7O3uOoxWoO0Mxu4gwQxTbv8m0EUSFv5yUGXuBN1yfP223GzrBUOc2ssjy8CRtw5XuYVRD
        TTQfT5MmgOu87
X-Received: by 2002:adf:a746:: with SMTP id e6mr9758542wrd.329.1579374974193;
        Sat, 18 Jan 2020 11:16:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqw5QRfOWE3Saqe+2JYXaXDB1bYLoIBngxxNQGuhd2prIT+LsyoASSay1qcd/9PORzaYHGoLCw==
X-Received: by 2002:adf:a746:: with SMTP id e6mr9758523wrd.329.1579374973932;
        Sat, 18 Jan 2020 11:16:13 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e0d6:d2cd:810b:30a9? ([2001:b07:6468:f312:e0d6:d2cd:810b:30a9])
        by smtp.gmail.com with ESMTPSA id q6sm41752357wrx.72.2020.01.18.11.16.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jan 2020 11:16:13 -0800 (PST)
Subject: Re: [PATCH 0/3] Standardize kvm exit reason field
To:     Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, paulus@ozlabs.org, maz@kernel.org,
        jhogan@kernel.org, drjones@redhat.com, vkuznets@redhat.com
References: <20191212024512.39930-1-gshan@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c88e75a7-3347-7bb4-2da7-a08467fd0e54@redhat.com>
Date:   Sat, 18 Jan 2020 20:16:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191212024512.39930-1-gshan@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/12/19 03:45, Gavin Shan wrote:
> Some utilities (e.g. kvm_stat) have the assumption that same filter
> field "exit_reason" for kvm exit tracepoint. However, they're varied
> on different architects. It can be fixed for the utilities to pick
> different filter names, or standardize it to have unified name "exit_reason",
> The series takes the second approach, suggested by Vitaly Kuznetsov.
> 
> I'm not sure which git tree this will go, so I have one separate patch
> for each architect in case they are merged to different git tree.
> 
> Gavin Shan (3):
>   kvm/mips: Standardize kvm exit reason field
>   kvm/powerpc: Standardize kvm exit reason field
>   kvm/aarch64: Standardize kvm exit reason field
> 
>  arch/mips/kvm/trace.h          | 10 +++++-----
>  arch/powerpc/kvm/trace_booke.h | 10 +++++-----
>  arch/powerpc/kvm/trace_pr.h    | 10 +++++-----
>  virt/kvm/arm/trace.h           | 14 ++++++++------
>  4 files changed, 23 insertions(+), 21 deletions(-)
> 

Queued, thanks (patches 1-2).

Paolo


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B911DC11D
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 23:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgETVNo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 17:13:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47257 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727018AbgETVNn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 17:13:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590009222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9q+MVTxOqNCDfm1aFUF9Xo/SKnt2cacs55IlEoGNHvA=;
        b=BxCzdY+3MbA1RUT5qin0HMzJCjVDoKY1np0AuXMNEOEajskwKVXo3wD9aGivEgX30qsIHR
        GyvNkXpxOcVIJxsuNRKuhVakEggnC82tnc3Rb4oNfWg4Uzw1dbXAw9iHos9zSThdiuBo06
        FXkAe+TnPqXay7+xZ3L+EKxr89esOaM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-4trkXZHsP0mRT_0ub-M1wQ-1; Wed, 20 May 2020 17:13:38 -0400
X-MC-Unique: 4trkXZHsP0mRT_0ub-M1wQ-1
Received: by mail-ed1-f71.google.com with SMTP id x11so1795809edj.21
        for <kvm@vger.kernel.org>; Wed, 20 May 2020 14:13:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9q+MVTxOqNCDfm1aFUF9Xo/SKnt2cacs55IlEoGNHvA=;
        b=VkGXdSifb+YVt/4sRQYkfI3/d/IEsCjJ2Nb+YWHnKxEa3dxhXkA3nT8eNqJCgrap2s
         546Yh+lcaexqKJ5DseKXgXOW1EOsA49dMk2IldBKXw3F3K61/SKB45kPf+kQUD1KhSeb
         afhr7kS+oFh+zOFkywnX8BiboSJcANJoUyXrDiNPFR6xeXdLjf2exnoOUpTgJfCjeGfQ
         04RZIz6cGhVMYuUuraeO8lW0qFtNg129l6+1uJOA5iAci7QytJFMcblybNO/tv1ZYRmB
         NaFjunn72cHLmrKVLq9deW251s7fsQGSI2NnqcZWA0MS5ZcYGsBRuWkQGVC7LXG73t5r
         v1wA==
X-Gm-Message-State: AOAM531DCwIzuuTdYSmULI7zAmtn0BsCgliLlzXLta9opkKLm/qFxePm
        Z7Ilj2nZhLmYzj75aALwnKWZge1HTIDf4e1XgZrdVenr4h9kDtODaYMmvotBJiZ8uKKEqTjbDFN
        0IC9DRd5Wt6Aq
X-Received: by 2002:a17:906:4886:: with SMTP id v6mr932539ejq.11.1590009217557;
        Wed, 20 May 2020 14:13:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQQ/ymyohkomsuFQ61gv/edSNt58FILtFnlIurwiVtnbBAEtNk/6YFqAQpcZtu96ld+iDlDQ==
X-Received: by 2002:a17:906:4886:: with SMTP id v6mr932525ejq.11.1590009217375;
        Wed, 20 May 2020 14:13:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1c48:1dd8:fe63:e3da? ([2001:b07:6468:f312:1c48:1dd8:fe63:e3da])
        by smtp.gmail.com with ESMTPSA id g20sm2820206edp.31.2020.05.20.14.13.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 14:13:36 -0700 (PDT)
Subject: Re: [PATCH 22/24] uaccess: add memzero_user
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
References: <20200520172145.23284-1-pbonzini@redhat.com>
 <20200520172145.23284-23-pbonzini@redhat.com>
 <20200520204036.GA1335@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e2e23a99-f682-1556-dad0-408e78233eb6@redhat.com>
Date:   Wed, 20 May 2020 23:13:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200520204036.GA1335@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/20 22:40, Christoph Hellwig wrote:
> On Wed, May 20, 2020 at 01:21:43PM -0400, Paolo Bonzini wrote:
>> +			unsafe_put_user(val, (unsigned long __user *) from, err_fault);
> This adds a way too long line.  In many ways it would be much nicer if
> you used an unsigned long __user * variable internally, a that would
> remove all these crazy casts and actually make the code readable.
> 

Good idea, thanks.

Paolo


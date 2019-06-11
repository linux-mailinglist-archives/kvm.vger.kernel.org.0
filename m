Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6403C9FD
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 13:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389546AbfFKL3s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 07:29:48 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:38176 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389269AbfFKL3s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 07:29:48 -0400
Received: by mail-wr1-f43.google.com with SMTP id d18so12602541wrs.5
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2019 04:29:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8qwW4QLFfBtKgDafCW+DM4bjjPQdr1v0w8rEMFQF8Nc=;
        b=MMAVuyk/JO9uwMuwoLnCVe07m3Hn5bw+s4ZKbVSnEHy19XII9+0KCp/LiKdBzRKwhn
         uFnjaUe0CbuOFu94/k67MHJZV24eUHGuh4f3TJSTT1CNYeY8jeT6Hw3UByYgYRFfetWy
         b5ytAfgj4k4/B8SA0iORwrIYNOTtdVvtu0kIGNd0Ztk8Ce+lX0JPDlpfiVVoxY1KkSmj
         xmlTvyVZHqsegNepx07AxJoGT0XAq589HsxbuIw/djwNDL4qEAsqFQq2nOhuUUVb8Lf4
         ihE4vOs8pmJ5Q55UPOKYXMWIIKjQgLdflEa7SGqsSrxZKMbX2kZXLwRchESwhJFYN48g
         ZUMg==
X-Gm-Message-State: APjAAAXuHLMyYm2Ft6bUPB+YvVi7OH1cIw5nQNhtmggZ3li9S69VHa6R
        xXn2px2ElcVshRWVSaUUP4rE9g==
X-Google-Smtp-Source: APXvYqxRkhZhFVuzHilj+D+oNIN0jm/MbCPNStvK6j2mqgYSwuEvx4QZFVySkwECNpCx/N73T3wteA==
X-Received: by 2002:adf:e9cc:: with SMTP id l12mr1943923wrn.29.1560252586574;
        Tue, 11 Jun 2019 04:29:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8cc3:8abd:4519:2cd6? ([2001:b07:6468:f312:8cc3:8abd:4519:2cd6])
        by smtp.gmail.com with ESMTPSA id n1sm13073990wrx.39.2019.06.11.04.29.45
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 04:29:45 -0700 (PDT)
Subject: Re: Reference count on pages held in secondary MMUs
To:     Christoffer Dall <christoffer.dall@arm.com>
Cc:     kvm@vger.kernel.org, aarcange@redhat.com,
        kvmarm@lists.cs.columbia.edu
References: <20190609081805.GC21798@e113682-lin.lund.arm.com>
 <3ca445bb-0f48-3e39-c371-dd197375c966@redhat.com>
 <20190611112158.GA5318@e113682-lin.lund.arm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bb04c637-24a6-220e-e596-299be5b1c503@redhat.com>
Date:   Tue, 11 Jun 2019 13:29:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190611112158.GA5318@e113682-lin.lund.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/06/19 13:21, Christoffer Dall wrote:
>> If I understand correctly, I think the MMU notifier would not fire if
>> you took an actual reference; the page would be pinned in memory and
>> could not be swapped out.
>>
> That was my understanding too, but I can't find the code path that would
> support this theory.

Yeah, as Andrea said you could drop the reference in the invalidate
callback too.

Paolo

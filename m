Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 337FE232DF
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 13:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731457AbfETLnK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 07:43:10 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35815 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730955AbfETLnK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 07:43:10 -0400
Received: by mail-wm1-f67.google.com with SMTP id q15so12691793wmj.0
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 04:43:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G1u4ZppYbcoEuueSwRN5YCnorqFZq5YrL/+Ds+I8To0=;
        b=DjIVEfHpyOGer4UfIXHybgxqSaXfg4Fcd6j4rHyBQ9ATvsMdGbCqlcZRz4Y5iwKt5m
         OS9INN9eWSraD3tFkBLxSFczwGuhwjXIVFyuxefuGpj+Bvpdru/mywqXEHXAbqK+N55m
         Ylymxy/BLLVTD/s7rMbARn38xN7ITKHuMbOmvsSfHQHysN2lCoQbCnH589QPOId1Fv0c
         WPu40I3Op5mvdq7BiyKJigo8uHVXgKQtfGjKQSrJoGOEMiUsu8krfnBPC3Fl6+1seSNl
         wP4EKKjj2yXu6BeTUtiULSX8XHc7AQNa+w0GC6dyaDv4+R5ionVQ7CbIRVl4YZ5ZK3KG
         N3Lg==
X-Gm-Message-State: APjAAAV6SrqPyI8VEfFU31ZBuZFptI1iH/X9htC35qUxHmPbkW/RPloG
        q/5nS8zZwW+meMpb4ePMi1gMmg==
X-Google-Smtp-Source: APXvYqzZBz9QemEl63iCXdzmTjif6qFuE24Mx6zVZQGgrH5jcNqVUAO0UG/FYPTQ4w9XTheIJ+Bo8A==
X-Received: by 2002:a05:600c:2289:: with SMTP id 9mr27711966wmf.106.1558352588686;
        Mon, 20 May 2019 04:43:08 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id w13sm19021118wmk.0.2019.05.20.04.43.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 04:43:08 -0700 (PDT)
Subject: Re: [RFC PATCH 0/4] KVM selftests for s390x
To:     Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        Andrew Jones <drjones@redhat.com>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-s390@vger.kernel.org, Andrew Jones <drjones@redhat.com>
References: <20190516111253.4494-1-thuth@redhat.com>
 <b412e591-3983-ebef-510b-43f9b7be4147@redhat.com>
 <9423ba89-b10e-5e6e-3cc8-8088f3088233@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4d94124e-00f6-aa65-3a4a-bd8910480329@redhat.com>
Date:   Mon, 20 May 2019 13:43:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <9423ba89-b10e-5e6e-3cc8-8088f3088233@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/19 13:30, Thomas Huth wrote:
>> No objections at all, though it would be like to have ucall plumbed in
>> from the beginning.
> I'm still looking at the ucall interface ... what I don't quite get yet
> is the question why the ucall_type there is selectable during runtime?
> 
> Are there plans to have test that could either use UCALL_PIO or
> UCALL_MMIO? If not, what about moving ucall_init() and ucall() to
> architecture specific code in tools/testing/selftests/kvm/lib/aarch64/
> and tools/testing/selftests/kvm/lib/x86_64 instead, and to remove the
> ucall_type stuff again (so that x86 is hard-wired to PIO and aarch64
> is hard-wired to MMIO)? ... then I could add a DIAG-based ucall
> on s390x more easily, I think.

Yes, that would work.  I think Andrew wanted the flexibility to use MMIO
on x86, but it's not really necessary to have it.

Paolo

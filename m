Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277DE312F04
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 11:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbhBHKaa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 05:30:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34570 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232149AbhBHK0m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 05:26:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612779914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZLTt/jNc10VT6gCbdoD+Af1czjbyy0IIAwPBoEn8bfI=;
        b=Gzoe/nWEu/zKQetsKtVYsXKcimC17Nj91A6k+JaIHGH28T2FIEz5fsZgCqc+nRHjTctwRj
        c3IGHSDKe5rW9NzhAKEA388fqKj7aHT3T00KMHgu4kalbBthaQzEU6s3WTxCAs+nc/SzqD
        VVQA5hXJ8siemwltCw0NyCR5NGLxft0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-O1j8I9gXOpyJombkDPR4LA-1; Mon, 08 Feb 2021 05:25:10 -0500
X-MC-Unique: O1j8I9gXOpyJombkDPR4LA-1
Received: by mail-wr1-f69.google.com with SMTP id x7so12574717wrp.9
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 02:25:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZLTt/jNc10VT6gCbdoD+Af1czjbyy0IIAwPBoEn8bfI=;
        b=EJOuNOqg5GZ01IVIC1h1cxbArGZ8FXAdUfTK2Zfm34KSKeHNGzLH2TdcK5cw0CWwG/
         mMIbqpEZGxCARKGI2yutbqF7MD0TLlYHg1REz71ndMwp9nXjIH9cMkAB422q0zGXqWpW
         MWkPFvvAFpo4BVw7ih9jau1eEmojM+lHHkyBUg9woMGG6b5E58K/vK7Z+gjFnSb7fyVm
         EmkT4QZew98rxqEkAc5H8rT0tLMs5sUx1rS5tDnvmiMcOxNGQv7ASH3a/DaLwejVSepl
         H+h7mj6QsxenndhOk4uVGVfIONz+JykD7YDabHRp+3FmoyqIYf+l49AaK75lynsI0O7m
         s7gQ==
X-Gm-Message-State: AOAM530GKboqi12hKjvF65NtS3+TKizLiKKcPPDkaluzfryBp2ZxCuoT
        Ltmt6Ve0J/snJb08Ssd7VNMR22r+KZTCZdAYZhbe8xYt8GWGfpSwpYmXQ9ddjkisk283+zS+yo2
        oei6oMbqETPPa
X-Received: by 2002:a05:600c:4a22:: with SMTP id c34mr11448625wmp.167.1612779909300;
        Mon, 08 Feb 2021 02:25:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyDJbuA+bT9BWr/82QdoxgeJVD7iz8YuJ2/fpkdBD9z6cfpfXGhTBk0ggBKywLZGIhZPyDfTw==
X-Received: by 2002:a05:600c:4a22:: with SMTP id c34mr11448613wmp.167.1612779909131;
        Mon, 08 Feb 2021 02:25:09 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id t2sm14392608wru.53.2021.02.08.02.25.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 02:25:08 -0800 (PST)
To:     Jing Liu <jing2.liu@linux.intel.com>, seanjc@google.com,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jing2.liu@intel.com
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
 <20210207154256.52850-4-jing2.liu@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH RFC 3/7] kvm: x86: XSAVE state and XFD MSRs context switch
Message-ID: <ae5b0195-b04f-8eef-9e0d-2a46c761d2d5@redhat.com>
Date:   Mon, 8 Feb 2021 11:25:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210207154256.52850-4-jing2.liu@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/21 16:42, Jing Liu wrote:
> |In KVM, "guest_fpu" serves for any guest task working on this vcpu 
> during vmexit and vmenter. We provide a pre-allocated guest_fpu space 
> and entire "guest_fpu.state_mask" to avoid each dynamic features 
> detection on each vcpu task. Meanwhile, to ensure correctly 
> xsaves/xrstors guest state, set IA32_XFD as zero during vmexit and vmenter.|

Most guests will not need the whole xstate feature set.  So perhaps you 
  could set XFD to the host value | the guest value, trap #NM if the 
host XFD is zero, and possibly reflect the exception to the guest's XFD 
and XFD_ERR.

In addition, loading the guest XFD MSRs should use the MSR autoload 
feature (add_atomic_switch_msr).

Paolo


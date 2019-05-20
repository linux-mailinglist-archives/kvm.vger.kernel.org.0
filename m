Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 033CF230DC
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 12:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731342AbfETKAs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 06:00:48 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37599 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730039AbfETKAs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 06:00:48 -0400
Received: by mail-wm1-f68.google.com with SMTP id 7so12373961wmo.2
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 03:00:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cggXkXw7KMDRmClqjubkrp+u9dEPf8Y4XlImClCNB9M=;
        b=lcpZujFU1GbrAldQYELomwMJ6Hn3esZow/7+qT7b7NBvxeyXWIR/DSX3zzQTMs7VeA
         94/tXQG6QfTryp0dR9Pum2fLF3QwqJDvKo+Nz4avreFWOq56A1IH/DgMTQ8VtkyYsk0B
         EJomymV/MURz9EPdWxTecVuufR98ycOm+ZD1Hx1d0TY/DfO2i6BAuDrUlYjGoo514xCU
         CLgrHYLVXNWXml8G+cWP/Cc+NiPRXDAs8waWZBafxk2KY6eC9mUYme6Pb8coJ51AsAsY
         okdIaaGZ5Rc8VMGimJ0HxQ79reyXELURWy3g9jhuFpClLM9P3tR6i0gFHHXxI6Bwty5I
         6lBg==
X-Gm-Message-State: APjAAAVFPckMVyB0ozNKRTZl269NQSxwrJZTcusfvZxvZ95p0YlPzpXN
        TQmeTX0pL5r5QUJPGKCyiJNzyw==
X-Google-Smtp-Source: APXvYqwJSh8pgNUluibV031iwlxskI3nkF4L+TZgKSMcM4ttcWA9XnyT5FF+LnqIc27hKgoLwSjwUw==
X-Received: by 2002:a1c:7dcf:: with SMTP id y198mr10603176wmc.94.1558346446594;
        Mon, 20 May 2019 03:00:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id b206sm17195897wmd.28.2019.05.20.03.00.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 03:00:45 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: selftests: Compile code with warnings enabled
To:     Thomas Huth <thuth@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
References: <20190517090445.4502-1-thuth@redhat.com>
 <20190517093000.GO16681@xz-x1> <8736ldquyw.fsf@vitty.brq.redhat.com>
 <1834df0f-b377-2231-0e5c-c5acd3298973@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <505274ec-e73f-f362-8130-5f70673bfc80@redhat.com>
Date:   Mon, 20 May 2019 12:00:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1834df0f-b377-2231-0e5c-c5acd3298973@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/05/19 12:07, Thomas Huth wrote:
> 
> lib/ucall.c: In function ‘get_ucall’:
> lib/ucall.c:145:3: warning: dereferencing type-punned pointer will break
> strict-aliasing rules [-Wstrict-aliasing]
>    gva = *(vm_vaddr_t *)run->mmio.data;
> 
> x86_64/vmx_set_nested_state_test.c: In function
> ‘set_revision_id_for_vmcs12’:
> x86_64/vmx_set_nested_state_test.c:78:2: warning: dereferencing
> type-punned pointer will break strict-aliasing rules [-Wstrict-aliasing]
>   *(u32 *)(state->data) = vmcs12_revision;
> 
> ... how do we want to handle such spots in the kvm selftest code?
> Compile with -fno-strict-aliasing? Or fix it with type-punning through
> unions?

I would use memcpy.  I'll send a patch shortly.

Paolo

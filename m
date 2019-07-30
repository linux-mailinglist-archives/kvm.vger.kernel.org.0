Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECEA7A712
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 13:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730507AbfG3LgT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 07:36:19 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53215 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730320AbfG3LgT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 07:36:19 -0400
Received: by mail-wm1-f66.google.com with SMTP id s3so56795810wms.2
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 04:36:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aNOl1k50pzAnfJwnSRhABd5Qe/PCJp3I0jRZ3rwELUQ=;
        b=gq/1egW28fYREUKZwE2SqEd1h42RghoYYqbLr6iKiuHr3g/wtw/3R7wMIODA1uIdjd
         UY5HhKx+M4WS9n2lSvHQw80KLlIWcrhOMQ+SR7QMF+KJ4ajUK0XKTNRhMhhsgXXp/oFN
         E54kSJBvnm47hUR0ca7zK7ZgYkpmGwREQ58H90xvnkyXIxZqE+dvuyvFYBHpH5fk9myf
         tkc8wCIRY7MIkRGTpyjzEN3djv6qmMckR2L/AyrbzusdT4Ttb584bVSjJQNzSXNa+SWd
         0mFrheSQYKeJ3dhkmEaquiRtS89tJgY1Xa01U3nMr022Zki8IxZurxXMVBSLBEqyz5rc
         AL+Q==
X-Gm-Message-State: APjAAAWq5kKkDtizn+Gt8HqN9WbL0Yg66DkSL6shGSsdPF4RM+pEYDPO
        rSGMTZ3TNRZb6MhQwy6jsRr3YQ==
X-Google-Smtp-Source: APXvYqz//H7WkU/sutEFkJcU6PS182g28f6mHHGiq7ODzVo9lb5F/uD9FQKY6gEBAwRpWHWEtNuWpQ==
X-Received: by 2002:a1c:e009:: with SMTP id x9mr103345453wmg.5.1564486576687;
        Tue, 30 Jul 2019 04:36:16 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id 4sm146630460wro.78.2019.07.30.04.36.15
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 04:36:16 -0700 (PDT)
Subject: Re: [PATCH 0/2] KVM: selftests: Enable ucall and dirty_log_test on
 s390x
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Shuah Khan <shuah@kernel.org>, Peter Xu <peterx@redhat.com>
References: <20190730100112.18205-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d35baab0-8a31-f686-8302-950e4fb9c07d@redhat.com>
Date:   Tue, 30 Jul 2019 13:36:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190730100112.18205-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/07/19 12:01, Thomas Huth wrote:
> Implement the ucall() interface on s390x to be able to use the
> dirty_log_test KVM selftest on s390x, too.
> 
> Thomas Huth (2):
>   KVM: selftests: Implement ucall() for s390x
>   KVM: selftests: Enable dirty_log_test on s390x
> 
>  tools/testing/selftests/kvm/Makefile          |  1 +
>  tools/testing/selftests/kvm/dirty_log_test.c  | 70 +++++++++++++++++--
>  .../testing/selftests/kvm/include/kvm_util.h  |  2 +-
>  tools/testing/selftests/kvm/lib/ucall.c       | 34 +++++++--
>  .../selftests/kvm/s390x/sync_regs_test.c      |  6 +-
>  5 files changed, 98 insertions(+), 15 deletions(-)
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

(apart from the small review comment on patch 2).

Paolo

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 910C086688
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2019 18:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404027AbfHHQAd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Aug 2019 12:00:33 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41369 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390180AbfHHQAd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Aug 2019 12:00:33 -0400
Received: by mail-wr1-f66.google.com with SMTP id c2so92228222wrm.8
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2019 09:00:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HfUGKxoVg/Y5/HOrGuXxnrqxgohjqDijjBO+JOIgh3c=;
        b=Vy5eFrM/W0/T44UL6GthgZC7ykpzQFdEhGvuMAueQi1flMpekxM5QiAPl3DHD/f2rO
         UFMUdPpZbXeYzTeYBx9VgTmnlJjhmRZeXQMFVQ5WYkaFRe6xPiUhHiitVr/MeD3q24vi
         nQ4YNYBg6GCvpax8e/raAaHhRMsWs/dgNXAhl0ECsqR0pBOTCwFoX9nRHmbAI8DkTGJw
         /reC8GA5ZxwW57KQTrbcfajhRNe/BA7n6kmU1nvbb90pbnmNGYmt95WugE7X7rNQ3tmu
         U1X+R+DaIaOhQ6za16adAl1sTw+X/M4PYuZkRHIkxjxHd/UPycQx1UHcDIwJS25BCUZp
         Z1Qg==
X-Gm-Message-State: APjAAAVnde2GrsdTwaXQN+Vmlcl1qkhqRjAy9LbPG9qvJkj8FqmAVy2+
        c+sLpSz7RCTQyuFt4BrRP0P0WMu30V8LEA==
X-Google-Smtp-Source: APXvYqxtqFM9caIZn5rTW8wOofJ1xUSKrKa/bUvYhMgKj7LVB0oV7/nRwWPsVNruybr30NfBnztZ6w==
X-Received: by 2002:adf:e2c1:: with SMTP id d1mr18729920wrj.283.1565280030781;
        Thu, 08 Aug 2019 09:00:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b42d:b492:69df:ed61? ([2001:b07:6468:f312:b42d:b492:69df:ed61])
        by smtp.gmail.com with ESMTPSA id c1sm212065701wrh.1.2019.08.08.09.00.29
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 09:00:30 -0700 (PDT)
Subject: Re: [PATCH v2] selftests: kvm: Adding config fragments
To:     Andrew Jones <drjones@redhat.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     shuah@kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, linux-kselftest@vger.kernel.org,
        kvm@vger.kernel.org
References: <20190808123140.25583-1-naresh.kamboju@linaro.org>
 <20190808151010.ktbqbfevgcs3bkjy@kamzik.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b34e8232-ccfd-898c-49de-afef4168a165@redhat.com>
Date:   Thu, 8 Aug 2019 18:00:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190808151010.ktbqbfevgcs3bkjy@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/08/19 17:10, Andrew Jones wrote:
>>
> What does the kselftests config file do? I was about to complain that this
> would break compiling on non-x86 platforms, but 'make kselftest' and other
> forms of invoking the build work fine on aarch64 even with this config
> file. So is this just for documentation? If so, then its still obviously
> wrong for non-x86 platforms. The only config that makes sense here is KVM.
> If the other options need to be documented for x86, then should they get
> an additional config file? tools/testing/selftests/kvm/x86_64/config?

My understanding is that a config file fragment requires some kind of
kconfig invocation to create a full .config file.  When you do that,
unknown configurations are dropped silently.

Paolo

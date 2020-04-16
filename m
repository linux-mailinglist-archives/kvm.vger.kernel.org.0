Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E15941ABEEE
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 13:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632811AbgDPLPR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 07:15:17 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48223 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2632785AbgDPLOW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 07:14:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587035661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uMhEZOoHAJnjG/UJiypTrpHYCbpZgvJbU4bT3L0FKI4=;
        b=Hh7rete3ARXQJJ6CQij9vn+QxSdXsHjWC8oi8jSs6rzA1Bo6BZ2ApYJOMUvKM+MbCg6zAJ
        QM8pYpo2Yg35TtcxOUkWUsF7G9xOwLfcpSMCTOZfjxUP3Is/OwTYYk3fcJRQd6GHaApqkn
        0+F3K8P2RGAKHX3TT/n9s8s9UEPpSAg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-Vr-Zylq8OHilFh4vGW5Irw-1; Thu, 16 Apr 2020 07:14:19 -0400
X-MC-Unique: Vr-Zylq8OHilFh4vGW5Irw-1
Received: by mail-wm1-f69.google.com with SMTP id h22so1274375wml.1
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 04:14:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uMhEZOoHAJnjG/UJiypTrpHYCbpZgvJbU4bT3L0FKI4=;
        b=ifFijsLIRKdAIPMooyvgsa9doMZJzrBhPTOdpS+oNHCAuv96jVvMzb97JD7SZspq7r
         tk7VddLShED11rtTYf10swb+okwPoLN6HxMe9nvSEbqkwaS/T23nXmB4jvuabpzmUT/j
         j2GvhuQUS8u/ueA+wEUIpsMbPPU4RirXcRc7cfmDRu6x8yHUHonu/RcVoa57R60KMWIp
         Xgc0kdaP2wxMvYYnWkXb0MA7mXXofyL38noly3Q3606pZC5MpL+EdYQ5ijP6UKFyMrDT
         hOx+xOEskGSvyzHsv4ZeRJamu3XZEDZVFpJ8MMinR55CtB7zB3DDr0r0iCnbzuaFJK9p
         W8pQ==
X-Gm-Message-State: AGi0PuaCf8991FKPyL2vYNegpmLUTGR2T8nUGXoN6CiR4NBiYATyysAm
        WpBtjWz3+5+GMAgWEPgiDK6JlgKVzxUIyF/m9JVNkTaT0rM7xX8iSagVNIkmwwhSSHk7wmV3FSb
        e7+9t3hwMqfMT
X-Received: by 2002:a5d:408a:: with SMTP id o10mr14651245wrp.163.1587035658169;
        Thu, 16 Apr 2020 04:14:18 -0700 (PDT)
X-Google-Smtp-Source: APiQypIhCbY4Z2dk2GyzeI5Yi3sRn1ddz4I0YHF5eNgOdzfpIeQMINfj7YSC5j77R84e3b7mkneo+w==
X-Received: by 2002:a5d:408a:: with SMTP id o10mr14651234wrp.163.1587035657963;
        Thu, 16 Apr 2020 04:14:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:399d:3ef7:647c:b12d? ([2001:b07:6468:f312:399d:3ef7:647c:b12d])
        by smtp.gmail.com with ESMTPSA id h5sm8397012wrp.97.2020.04.16.04.14.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2020 04:14:17 -0700 (PDT)
Subject: Re: [PATCH] x86/kvm: make steal_time static
To:     Jason Yan <yanaijie@huawei.com>, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Hulk Robot <hulkci@huawei.com>
References: <20200415084939.6367-1-yanaijie@huawei.com>
 <d1700173-29c1-2e7c-46bd-471876d96762@redhat.com>
 <35c3890e-0c45-0dac-e9f0-f2a9446a387d@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bd77af4b-1e08-af7a-3167-eeb03dfbd1d6@redhat.com>
Date:   Thu, 16 Apr 2020 13:14:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <35c3890e-0c45-0dac-e9f0-f2a9446a387d@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/04/20 04:15, Jason Yan wrote:
>>
> 
> Sorry that I found 14e581c381b9 ("x86/kvm: Make steal_time visible")
> said that it is used by assembler code but I didn't find where.
> Please drop this patch if it's true.
> 
> Sorry to make this trouble again.

Here:

arch/x86/kernel/kvm.c:"cmpb	$0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax);"

The __visible argument shouldn't be needed, __used should be enough.  I'll take a look.

Paolo


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D223AF0949
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 23:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730140AbfKEW0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 17:26:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48796 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729680AbfKEW0k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 17:26:40 -0500
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0078DC057F23
        for <kvm@vger.kernel.org>; Tue,  5 Nov 2019 22:26:40 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id z5so339974wma.5
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 14:26:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OzIlqC4IvfN8DuZvjiiv7hFGOZvskq8g+LoumBgxFeo=;
        b=lm+L+yPjHcRp0QGflZ2VNc82tI5J9mVqFAM7J3KULOZK1eV7ES/8WesXpwBqz6R7I8
         i9RBHaa56E6O04QMFgOmJsfLUtkgZbBJvdvJ5IondOnt0fnfyuvBK841aYNjq0RyYjCE
         xbAQkXCZxhabDM23EJgAdg2ToYOvgo/esqfFCD4WKuDUFiga6c8lb/r9POsn16VoQmSa
         LKf2lbWwQGQ6owPHuqYuC3s9tVUkMit1iuRf9uTUIwEW+TeuXDj0CJLOhOAPfBuLXEbu
         5M7ReHvRsJIUG34+br6b6DBOBeaXEj9GYtorNKbh/RuVBG+veF3kyZxBaXhJiPxnIiyw
         Qr2w==
X-Gm-Message-State: APjAAAVegLRwU+RA3JyurME6dX+6zynQilBg01BHZ4Hpx5QnePGmKsRt
        SyIGgy+19u+NOc3U2apzsb9sQYOKZI2otTwG2sxjSyUnJi/AzLyD85DciBE40xNQ2B1X41qgyu7
        k7lFgr4lvlp1B
X-Received: by 2002:a5d:5591:: with SMTP id i17mr28783712wrv.151.1572992798493;
        Tue, 05 Nov 2019 14:26:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqw4OZ+Lpo2ngMUT/3RbmTOvLaRXzjq3nAcu7llOyQmVes00mcotaieUNdeq8zMDHArIZPV+bg==
X-Received: by 2002:a5d:5591:: with SMTP id i17mr28783697wrv.151.1572992798200;
        Tue, 05 Nov 2019 14:26:38 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id 62sm26716406wre.38.2019.11.05.14.26.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2019 14:26:37 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v3 1/2] x86: realmode: save and restore %es
To:     Jim Mattson <jmattson@google.com>
Cc:     Bill Wendling <morbo@google.com>, kvm list <kvm@vger.kernel.org>,
        thuth@redhat.com, alexandru.elisei@arm.com
References: <20191101203353.150049-1-morbo@google.com>
 <20191101203353.150049-2-morbo@google.com>
 <119b3e09-1907-5c7f-7c47-753ce7effe23@redhat.com>
 <CALMp9eTUgxB5+K-eun-NXKdQbaObBFJDaL6r5=A3myoW4ZH4hA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <1f1f35dd-11cc-ca87-10c4-f67a01f1e91c@redhat.com>
Date:   Tue, 5 Nov 2019 23:26:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eTUgxB5+K-eun-NXKdQbaObBFJDaL6r5=A3myoW4ZH4hA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/11/19 19:07, Jim Mattson wrote:
> On Mon, Nov 4, 2019 at 4:08 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 01/11/19 21:33, Bill Wendling wrote:
>>> Some of the code test sequences (e.g. push_es) clobber ES. That causes
>>> trouble for future rep string instructions. So save and restore ES
>>> around the test code sequence in exec_in_big_real_mode.
>>
>> You mean pop_es.  Applied with that change.
> 
> I think push_es and pop_es are both guilty of clobbering %es:
> 
> MK_INSN(push_es, "mov $0x231, %bx\n\t" //Just write a dummy value to
> see if it gets overwritten
> "mov $0x123, %ax\n\t"
> "mov %ax, %es\n\t"   <======= Here
> "push %es\n\t"
> "pop %bx \n\t"
> );
> 
> MK_INSN(pop_es, "push %ax\n\t"
> "pop %es\n\t"          <======== Here
> "mov %es, %bx\n\t"
> );

Intel vs AT&T always gets me...

Paolo


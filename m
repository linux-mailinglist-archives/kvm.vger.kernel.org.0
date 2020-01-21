Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02DDF143C3A
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 12:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbgAULrF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 06:47:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26978 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727817AbgAULrF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 06:47:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579607224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uX1VzSMfdN4ap89a7gOpBGNu3Gszqn3pc1p3J0UV56o=;
        b=d0l6JDBgm41wlXtswPD/hUVioPwMlMgs2onIl0ymmkC1s8QT4zeUYW1bFPfrCSB6YSqooS
        4owTxM4/v+IH6gEFU4uje33ZM1b89opxZG6AwWa9Vrwh7N8akvEQ2YjyvPcMJLpHhoks8G
        TAh9T0fWR1Tgqfxsb2S29vlu38moZCQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-04b_PEmhMLumNL7YfHn80Q-1; Tue, 21 Jan 2020 06:47:00 -0500
X-MC-Unique: 04b_PEmhMLumNL7YfHn80Q-1
Received: by mail-wr1-f70.google.com with SMTP id b13so1178409wrx.22
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 03:47:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=uX1VzSMfdN4ap89a7gOpBGNu3Gszqn3pc1p3J0UV56o=;
        b=RhRIZ0B1vrXQtJPT07bpyH9p8LmM/YDDhhKks2aSUaBYE68+5NRdfZqIP0+pr1Hc9G
         hIdht1tmoyfV6xdfi4PudW50Bk9rM15f2weojbaTmtChzaGcJ2HMtL/TE3JeeGujwMpN
         xzRdstFdCLPZRQUjkpa3t9jmjVKLEjPXVdxuAAnNoU/xBKqs3udgi7rOmxhZZmWNbKCV
         15dTp1tedjQSxadmQOcCvYWu36+6LNWrpMb5WJe/z5O5rC5OjWWsHKUju+/qNRKaT2Sl
         slMcVRbdtYGhDw4gtGOBh8JAF/fU+wcE6UqtUJjysQIoUBLQltLnwYkP9B+Va1fpSbU5
         c2rg==
X-Gm-Message-State: APjAAAX8kLzNmQHN6SKoZizwIOXTOrIsRjTtBTNtiz/I8VsE9lRLfoaG
        rjJRslSShxwXeSOWr0/Ll377elGTTh1/+zqt8O49tH5+aezu1u00GShD6cZ/csVLZHuLcjfhK0L
        Otm34+pyACh4T
X-Received: by 2002:a7b:cd11:: with SMTP id f17mr3920167wmj.48.1579607219486;
        Tue, 21 Jan 2020 03:46:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqwknGcoXUhKfXzpud+5Jv20G9KzAXp8anNgnJUjFXlYSeOq0W7o0EzOmF8juuVPnn+gIzE65g==
X-Received: by 2002:a7b:cd11:: with SMTP id f17mr3920145wmj.48.1579607219287;
        Tue, 21 Jan 2020 03:46:59 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id b21sm3865365wmd.37.2020.01.21.03.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 03:46:58 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     thuth@redhat.com, drjones@redhat.com, eric.auger.pro@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com
Subject: Re: [PATCH] selftests: KVM: AMD Nested SVM test infrastructure
In-Reply-To: <a288001b-56a6-363b-18c0-18a1e1876ccc@redhat.com>
References: <20200117173753.21434-1-eric.auger@redhat.com> <87pnfeflgb.fsf@vitty.brq.redhat.com> <a288001b-56a6-363b-18c0-18a1e1876ccc@redhat.com>
Date:   Tue, 21 Jan 2020 12:46:57 +0100
Message-ID: <877e1lf2vi.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Auger Eric <eric.auger@redhat.com> writes:

> Hi Vitaly,
>
> On 1/20/20 11:53 AM, Vitaly Kuznetsov wrote:
>> Eric Auger <eric.auger@redhat.com> writes:
>> 

...

>>> +
>>> +static struct test tests[] = {
>>> +	/* name, supported, custom setup, l2 code, exit code, custom check, finished */
>>> +	{"vmmcall", NULL, NULL, l2_vmcall, SVM_EXIT_VMMCALL},
>>> +	{"vmrun", NULL, NULL, l2_vmrun, SVM_EXIT_VMRUN},
>>> +	{"CR3 read intercept", NULL, prepare_cr3_intercept, l2_cr3_read, SVM_EXIT_READ_CR3},
>>> +};
>> 
>> selftests are usualy not that well structured :-) E.g. we don't have
>> sub-tests and a way to specify which one to run so there is a single
>> flow when everything is being executed. I'd suggest to keep things as
>> simple as possibe (especially in the basic 'svm' test).
> In this case the differences between the tests is very tiny. One line on
> L2 and one line on L1 to check the exit status. I wondered whether it
> deserves to have separate test files for that. I did not intend to run
> the subtests separately nor to add many more subtests but rather saw all
> of them as a single basic test. More complex tests would be definitively
> separate.
>
> But if the consensus is to keep each tests separate, I will do.
>

No, I wasn't asking for that, it's just that the 'tests' array looks
like we're going to add more and more here (like we do in
kvm-unit-tests). If it's not the case you can probably simplify the code
by executing these three checks consequently without defining any
'sub-test' stuctures (like we do for other selftests). But I don't have
a strong opinion on this so we can keep things the way they are.

-- 
Vitaly


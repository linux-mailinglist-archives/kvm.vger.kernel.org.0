Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE90143CA0
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 13:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbgAUMRX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 07:17:23 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22824 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728760AbgAUMRU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jan 2020 07:17:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579609038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C9ocdms8YQdaluyA27aUHa1CM8I9Y3XHULzORwIWhX4=;
        b=csT5DPkBfQOI1vRiQGYCf4hqOVec/OxEQKsuDD7Siz/QwMvlNY7Z5yXixfE87diev+DiZ7
        hf+VdN+zPQFTTHBs+20sIBeQzer45Fcl9yeY24BJlVq1vl2wIlbU0K8z1i+HwvbFxvLT+w
        fTHKaA9OGZSPZ/9Z/fPBp/mdMAqev+I=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-snx_aib1N2moKDB8uK7KbA-1; Tue, 21 Jan 2020 07:17:17 -0500
X-MC-Unique: snx_aib1N2moKDB8uK7KbA-1
Received: by mail-wr1-f69.google.com with SMTP id h30so1232001wrh.5
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 04:17:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C9ocdms8YQdaluyA27aUHa1CM8I9Y3XHULzORwIWhX4=;
        b=rykIUf3UqYRhv1c05YjvXr8UvG8DFO+806Z1Vzn0W8TcKhjMVYNjsf2tVizc286m9L
         XhRxll18Gaa2HSNmd1zwbo47NysrjEWormhIyQuvlZzN9Y4XTTjAaBcuNF0k7pco/1zR
         LW9gC4M+n0Ut2mb2cuSwhiBjjgpuyiAYJmS7em3htUUrC2t3qZZ/lTuwNX8jXEE/G3fr
         aMwUJJPszzlj66p72qQhTZcw8oa7OjxlLcWjYZl9bLowBUybUgf6GMU1zXCcw7R11kdP
         5M/GnccSS5i5PcEpy+McAWF+dvkgAokHCj5oDcxof+LIcz63U3W1AipT8rbAO/U2tQd9
         6Nmw==
X-Gm-Message-State: APjAAAW7N4r3jhBNsufta6piAEY6MncnBgPA19wBiSDb6/xmBhPhTvti
        QhCiMZUnYsZw7SHMvZg29YgUSGzfQzMi4J8Ugxw6BCnkKyNw4EFfKBhivTtIB6Uuw4NRsd855lY
        /z0MXUBNsBlgX
X-Received: by 2002:a05:600c:210e:: with SMTP id u14mr4006437wml.28.1579609035980;
        Tue, 21 Jan 2020 04:17:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqyjBmRSqaH7Hafu7I3Qvl9yQQESxj6q6oJyTXTzXfCwxSIMyeZy0TLITSzLFAXsYe6bR+nUbQ==
X-Received: by 2002:a05:600c:210e:: with SMTP id u14mr4006409wml.28.1579609035662;
        Tue, 21 Jan 2020 04:17:15 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a? ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
        by smtp.gmail.com with ESMTPSA id j12sm53192472wrt.55.2020.01.21.04.17.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 04:17:15 -0800 (PST)
Subject: Re: [PATCH] selftests: KVM: AMD Nested SVM test infrastructure
To:     Auger Eric <eric.auger@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     thuth@redhat.com, drjones@redhat.com, eric.auger.pro@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200117173753.21434-1-eric.auger@redhat.com>
 <87pnfeflgb.fsf@vitty.brq.redhat.com>
 <a288001b-56a6-363b-18c0-18a1e1876ccc@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f156e2e0-6c75-30c2-c295-b87ee1b36600@redhat.com>
Date:   Tue, 21 Jan 2020 13:17:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <a288001b-56a6-363b-18c0-18a1e1876ccc@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/01/20 12:12, Auger Eric wrote:
>>> +
>>> +static struct test tests[] = {
>>> +	/* name, supported, custom setup, l2 code, exit code, custom check, finished */
>>> +	{"vmmcall", NULL, NULL, l2_vmcall, SVM_EXIT_VMMCALL},
>>> +	{"vmrun", NULL, NULL, l2_vmrun, SVM_EXIT_VMRUN},
>>> +	{"CR3 read intercept", NULL, prepare_cr3_intercept, l2_cr3_read, SVM_EXIT_READ_CR3},
>>> +};
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

I would just leave this deeper kind of test to kvm-unit-tests and keep
selftests for API tests.  So this would mean basically only keep (and
inline) the vmmcall test.

Paolo


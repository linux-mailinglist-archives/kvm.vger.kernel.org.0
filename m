Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A12714F986
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgBASvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:51:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32509 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726335AbgBASvr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:51:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580583106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tB9Flr5JK1dOLBjqc7BgpGrNDesYmTAkGtr8sueGsTM=;
        b=fit1T3gWF2PGaGFtcUdvob2AgMQnKaZ0lH9Gwx7EVyEAtMPK1IJiXmnpo09IeDBfgELrmw
        AhdWmOhjD6cFH0lGfWFVwtnm6TpvTrClzh1qJevf+drMXjRNyLxxbDhXF91G4SNmPyGvfN
        LDwBBg+sz51lzWWuG3TxrHy/RcX+sCA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-NRTZm2OVNnegyEf7AAoJ1Q-1; Sat, 01 Feb 2020 13:51:44 -0500
X-MC-Unique: NRTZm2OVNnegyEf7AAoJ1Q-1
Received: by mail-wr1-f70.google.com with SMTP id d15so1989221wru.1
        for <kvm@vger.kernel.org>; Sat, 01 Feb 2020 10:51:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tB9Flr5JK1dOLBjqc7BgpGrNDesYmTAkGtr8sueGsTM=;
        b=JhULoSSw0IpVMqs/uTT/Rv464KBgJicuiuKBSvVE46/xyxkdWVUKV5xi1y6pkP1Qng
         va1QAqwP/yKIcMy50cBsKBi3jSU/9KhxVz7pYadsZdhGSARtaO2da8c+G1rGgU/rmpWX
         9Y/BGKu8y0WmyYkE2iz6I/B3G2/hwpXgaw8G0dUmxEXC0nQOXzthSEx+0Im/z1TimEnX
         XVwedqtmdoUwt9frTb4adpblQWqVyjUo0pA7wNYk3qkp2V54zzkZ2VhLKZ/E7in068SV
         HwUQJyvKdaXXC0h8KuBbhN3CQioHQDiUJHfBpNGHIW4p3kAeGrtUayfWVxaPq1zC1Nne
         TzyQ==
X-Gm-Message-State: APjAAAU+Fu3Zqh5p3qL5FCBwc3O9tShHDUDjhVuietcNta3nZdh7TNcq
        RLmqXkzZUk2DlUQ5KRZj+69duFsguCWlfWQ4pXXSz021YkrM/DtyH4zfFCTjyDyrNp3lhQsjbiD
        l3mbggqZIm0Ez
X-Received: by 2002:a1c:df09:: with SMTP id w9mr18132175wmg.143.1580583102813;
        Sat, 01 Feb 2020 10:51:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqwtrcXwlNs8N5xVK7R4JMHvfTqKW8jsp2y194o5nU+n5b3kfGYl/Ti0Cx6Ye68n+xpLiX6iEA==
X-Received: by 2002:a1c:df09:: with SMTP id w9mr18132164wmg.143.1580583102550;
        Sat, 01 Feb 2020 10:51:42 -0800 (PST)
Received: from [192.168.42.104] (93-33-54-106.ip43.fastwebnet.it. [93.33.54.106])
        by smtp.gmail.com with ESMTPSA id e8sm17306814wrt.7.2020.02.01.10.51.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2020 10:51:42 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: Fix perfctr WRMSR for running counters
To:     Eric Hankland <ehankland@google.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200127212256.194310-1-ehankland@google.com>
 <2a394c6d-c453-6559-bf33-f654af7922bd@redhat.com>
 <CAOyeoRVaV3Dh=M4ioiT3DU+p5ZnQGRcy9_PssJZ=a36MhL-xHQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c1cec3c8-570f-d824-cb20-6641cf686981@redhat.com>
Date:   Sat, 1 Feb 2020 19:51:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CAOyeoRVaV3Dh=M4ioiT3DU+p5ZnQGRcy9_PssJZ=a36MhL-xHQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/01/20 02:09, Eric Hankland wrote:
> Sorry - I forgot to switch to plain text mode on my first reply.
> 
>> I think this best written as it was before commit 2924b52117:
>>
>>                         if (!msr_info->host_initiated)
>>                                 data = (s64)(s32)data;
>>                         pmc->counter += data - pmc_read_counter(pmc);
> Sounds good to me.
> 
>> Do you have a testcase?
> I added a testcase to kvm-unit-tests/x86/pmu.c that fails without this
> patch and passes with it. Should I send out that patch now?

Yes, please send it!  Thanks,

Paolo


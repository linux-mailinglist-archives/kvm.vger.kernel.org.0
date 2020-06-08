Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84A11F1748
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 13:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729555AbgFHLLK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 07:11:10 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45916 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729545AbgFHLLJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jun 2020 07:11:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591614668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6UtZMmgd9hnL+iwknrZAm1Gp605OoCu4kNlweeMxR6w=;
        b=AKkTRRkplfryGJvJn6iZigBYbsx93Vs4kRQPT9PhioEu4e4OTG76K8bIaLyFD+5wIYI+Zs
        J5k3egdf9H/ovjXMvdBvqzLG7UaZwNTe8TfABZJJmtqWqnrojLFtj99XiWnnaxP3xLgSlF
        e3mu8FQE1g2W08qK1zQg5nIEQxmUffA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-4-HbnUTGOiGQo2MV6dpRJA-1; Mon, 08 Jun 2020 07:11:07 -0400
X-MC-Unique: 4-HbnUTGOiGQo2MV6dpRJA-1
Received: by mail-wr1-f71.google.com with SMTP id z10so7062354wrs.2
        for <kvm@vger.kernel.org>; Mon, 08 Jun 2020 04:11:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6UtZMmgd9hnL+iwknrZAm1Gp605OoCu4kNlweeMxR6w=;
        b=cbJd1fREN/XjnR6+PeFkHKsHOYLoPHxQa4HvYANgurPU5+q4hSJVIYNgfETThWFfX0
         16RyBxcGizTLLRPHHYfhxwrKtB1Ucnb2/9KaR/lTc3zlRDAV0wu/tKRRH1tKotWtQzEb
         IMBH+eiUbrnPgNncTx4QfT5guYKtYEbGdzZt5SwyO20SFWa4oku+2Q2XkWZLQzlnXlXv
         M5P1TDjS7DEsrSqHv1Ndn85y2zN3LoRrpoAaSXcJo1b4gwGiWGB3T3nOsLsP3ItqRnJp
         QKZbnTz+OLTB7/gsmAtJqmUeeYRwLPqL7RxefCKSvoK3WN46385e+Rm0wOa3Vgw6dR7a
         Pstg==
X-Gm-Message-State: AOAM532vILJ0VEJ6dSsWqBuOFWvFWQJ7zaNz9AMb//EAXa+M/VexG8im
        1sfznwd7RhZxWISwVWQe9XkUaUZuMIsAO2T9j0GcgYOm5mU2h3W7JRXnbUXkZ8m/ZwSiFsV5a9V
        3XdD7EsY/0ow1
X-Received: by 2002:a7b:c1ce:: with SMTP id a14mr14798179wmj.144.1591614665751;
        Mon, 08 Jun 2020 04:11:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzv5u6HDK1/x+RarSMh01GURLAzTYLbxMBVZTOhO0ZDSZmDyVGktQuM1b3EGK6O2JN7nu/vVw==
X-Received: by 2002:a7b:c1ce:: with SMTP id a14mr14798158wmj.144.1591614665568;
        Mon, 08 Jun 2020 04:11:05 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.87.23])
        by smtp.gmail.com with ESMTPSA id y66sm22490920wmy.24.2020.06.08.04.11.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2020 04:11:04 -0700 (PDT)
Subject: Re: [PATCH 19/30] KVM: nSVM: extract svm_set_gif
To:     Qian Cai <cai@lca.pw>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        torvalds@linux-foundation.org
References: <20200529153934.11694-1-pbonzini@redhat.com>
 <20200529153934.11694-20-pbonzini@redhat.com> <20200605203356.GC5393@lca.pw>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2a798f4c-5782-2e7c-7c87-ca7a3c576ff8@redhat.com>
Date:   Mon, 8 Jun 2020 13:11:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200605203356.GC5393@lca.pw>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/06/20 22:33, Qian Cai wrote:
>> +	if (value) {
>> +		/*
>> +		 * If VGIF is enabled, the STGI intercept is only added to
>> +		 * detect the opening of the SMI/NMI window; remove it now.
>> +		 * Likewise, clear the VINTR intercept, we will set it
>> +		 * again while processing KVM_REQ_EVENT if needed.
>> +		 */
>> +		if (vgif_enabled(svm))
>> +			clr_intercept(svm, INTERCEPT_STGI);
>> +		if (is_intercept(svm, SVM_EXIT_VINTR))
> A simple qemu-kvm will trigger the warning. (Looks like the patch had
> already been pulled into the mainline quickly.)

You're right, that should have been INTERCEPT_VINTR.  I'll post a fix.

Thanks,

Paolo


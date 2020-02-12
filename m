Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32B4015A5CE
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 11:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbgBLKKx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 05:10:53 -0500
Received: from mail-wr1-f53.google.com ([209.85.221.53]:39593 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727608AbgBLKKu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 05:10:50 -0500
Received: by mail-wr1-f53.google.com with SMTP id y11so1472525wrt.6
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 02:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=BRjPfJMR3gBxSakZef/gb/VnG6S48JJMLp21pszTisM=;
        b=oIYghL86GjmBaZilXF+NzQT9lOVQeHyGOnfORubKlbqH2iHU7BCSA111X2860O0xpd
         xGNHdmxZssKmctutn4kX661YkGatIdrzulNTw7wbyOgnXjJjXnhcoDiqHmgBqN3Ny9qJ
         ASsAGoV/RF1dmxCblipJbc6Gxfea7uFhHmL2kqEy/A44EZkxHGKQjf5FXxfE8psVl7Tj
         i307gSCqJmhW5OidVecNv1TqhoGOh+Z4wLmmImlIG5ttGqK51zDwKXnXGIXYwCvrrVmk
         75Sf94b7eU3ePGeBV0al97ts/xD+tIZCvOkPK1Qb+DlFEBF/GcSGKLYjRwSahwT32uPt
         YYsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=BRjPfJMR3gBxSakZef/gb/VnG6S48JJMLp21pszTisM=;
        b=ePM082Tz1LBKssVa+Z5rqmKZ7PDvmK01fd5W63vkQHqhCONCSAiHDuk4WqJwsOk8hi
         UA0GdvAVy5IKAbITK2fSr7B2GalCpq8taW8yaTNlqUCoUTTeH6I5PhGDi5s9jZT9N3Tq
         PybE6+a6j0QdbQRjm4QQHsPBFL12Ou9mZwEI1rzce0av5LrrQRhhwc5VVRIkWjRT6wPi
         yMGnDnecEhjkKnyf/qWAQ5aVzeRk9Nz8ucEclZzTurBnjhA1I41GmkGZOPWKcdt99Z01
         8xBL3lKjYxk1PB3mLu4QpPHu2wCwt4679kRe3hLXKT7t0ddpotHB6hTio0FAGJHzdVfQ
         bwlQ==
X-Gm-Message-State: APjAAAXktEx7RoFDiTXEwm8eeiwvHQvTjJQo2BO9YXsFY2jEyS5BaBuS
        8FGqwm8ia/JEB3lASd6gaqwT6w==
X-Google-Smtp-Source: APXvYqyWd2HdsaijUMG4L8+DcCi4FCuU37UJqFhSImYWBPcv+G2F0q676xQm6nEE4PLfYcclMx8kEA==
X-Received: by 2002:adf:f012:: with SMTP id j18mr14411599wro.314.1581502248098;
        Wed, 12 Feb 2020 02:10:48 -0800 (PST)
Received: from [10.0.0.1] (system.cloudius-systems.com. [199.203.229.89])
        by smtp.gmail.com with ESMTPSA id x6sm37396wmi.44.2020.02.12.02.10.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 02:10:46 -0800 (PST)
Subject: Re: [RFC] eventfd: add EFD_AUTORESET flag
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-fsdevel@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Davide Libenzi <davidel@xmailserver.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
References: <20200129172010.162215-1-stefanha@redhat.com>
 <66566792-58a4-bf65-6723-7d2887c84160@redhat.com>
From:   Avi Kivity <avi@scylladb.com>
Organization: ScyllaDB
Message-ID: <a5299230-4e86-43d1-7f99-cc1f455a39c7@scylladb.com>
Date:   Wed, 12 Feb 2020 12:10:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <66566792-58a4-bf65-6723-7d2887c84160@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/02/2020 10.31, Paolo Bonzini wrote:
> On 29/01/20 18:20, Stefan Hajnoczi wrote:
>> +	/* Semaphore semantics don't make sense when autoreset is enabled */
>> +	if ((flags & EFD_SEMAPHORE) && (flags & EFD_AUTORESET))
>> +		return -EINVAL;
>> +
> I think they do, you just want to subtract 1 instead of setting the
> count to 0.  This way, writing 1 would be the post operation on the
> semaphore, while poll() would be the wait operation.


poll() is usually idempotent. Both resetting to zero and subtracting one 
goes against the grain.


Better to use uring async read. This way you get the value just as you 
do with with poll+read, and the syscall cost is amortized away by uring.


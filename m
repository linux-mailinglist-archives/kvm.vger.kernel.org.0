Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33C5400EC1
	for <lists+kvm@lfdr.de>; Sun,  5 Sep 2021 11:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236603AbhIEJDe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 05:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhIEJDd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Sep 2021 05:03:33 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1822EC061575;
        Sun,  5 Sep 2021 02:02:31 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id w7so3532134pgk.13;
        Sun, 05 Sep 2021 02:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=4PoXRNgI5FUMo22oE+bYgf8B1WYPKZxe6VaFiQnWWWs=;
        b=e4+4MNt1UGeo60Ovr4Fb70JTLLE73UMT6lxx7BtcpFHAVleTBMEVAUu9kezJz15X5Z
         WDXVJw4IjyNFDZ5Xd+w0lzJIAcswGnb8lx+If0jlCVL0CRDn6hiwvI09eWfIT72YFK8U
         4rEt48eJ59cMSc7LFkWe7KPYi5MfD8iDpfWKkB4eZi2hiwhndp7PVIdqaVJSJOm3ESzz
         VojQkJMp0YNihXPYWqmjQQ/madvqzy51+VDmcJ6gZogd7wcppWfLeoK+It/otPqKXJjL
         oVn910yCdGJeIe8NM+ZvGFhAtOffJOexC1EBTxUEAlHPb9hBh52Z8gd5H0EX+DzeVRs3
         t3bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4PoXRNgI5FUMo22oE+bYgf8B1WYPKZxe6VaFiQnWWWs=;
        b=hzElNmD5NKIX1TkXPvBiJ/fzAyRO+MZe3newdZMRz/lMRfBLB4s5WLZj4ahMt+RyDt
         Mev9QqXzKmE/2NRgjM8+D4JAOd7g710xXyKUqm7ThqCrERGqOtrunV49AzOdumdYkyNH
         1MG44z3z1MiBJ9rEBGjrh02kll30mdvHW66kGG1EPUiNqIOMwsv7S6IwbjgM/q99hKcz
         0c24T3M5Z+O+I8TVWh+7eU6wtuwmR6vz+8L1CGuSkIAHW8YzaCGs7FdRi2SauifjiZQr
         wXUaUa1Y9IUKNw38mhYE0glh/SxmUUROMBYkuAPfcj0W2kjXoj+d336Jzuxd2YBrCo8N
         wJHg==
X-Gm-Message-State: AOAM5306+LOtAC7aYAi8XwaXx1I9+5tngdS+vUITvhKo8invaSSpbBR1
        4olZMz1SOgg9g7wq3JjqJEo=
X-Google-Smtp-Source: ABdhPJw0T9g+hzvcQ1YkfFdhbE3AvvLt1/OkBObvUuTBLZicbf4TmBm2QAzVn1C7zaKqdCPO7LMrPw==
X-Received: by 2002:aa7:8bcf:0:b0:412:44ab:750f with SMTP id s15-20020aa78bcf000000b0041244ab750fmr6684415pfd.83.1630832550540;
        Sun, 05 Sep 2021 02:02:30 -0700 (PDT)
Received: from ?IPV6:2600:8802:380b:9e00:d428:5ab0:1311:1fab? ([2600:8802:380b:9e00:d428:5ab0:1311:1fab])
        by smtp.gmail.com with ESMTPSA id a10sm4105643pfn.48.2021.09.05.02.02.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Sep 2021 02:02:30 -0700 (PDT)
Message-ID: <db95700b-3620-9162-368a-4bc3b94cd84e@gmail.com>
Date:   Sun, 5 Sep 2021 02:02:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH v2 1/1] virtio-blk: remove unneeded "likely" statements
Content-Language: en-US
To:     Max Gurtovoy <mgurtovoy@nvidia.com>, mst@redhat.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        stefanha@redhat.com
Cc:     linux-block@vger.kernel.org, axboe@kernel.dk
References: <20210905085717.7427-1-mgurtovoy@nvidia.com>
From:   Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
In-Reply-To: <20210905085717.7427-1-mgurtovoy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/5/2021 1:57 AM, Max Gurtovoy wrote:
> Usually we use "likely/unlikely" to optimize the fast path. Remove
> redundant "likely/unlikely" statements in the control path to simplify
> the code and make it easier to read.
>
> Reviewed-by: Stefan Hajnoczi<stefanha@redhat.com>
> Signed-off-by: Max Gurtovoy<mgurtovoy@nvidia.com>


Reviewed-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>




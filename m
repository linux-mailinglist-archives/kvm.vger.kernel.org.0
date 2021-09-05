Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C45D400EBD
	for <lists+kvm@lfdr.de>; Sun,  5 Sep 2021 10:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236579AbhIEIuv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 04:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236559AbhIEIuu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Sep 2021 04:50:50 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05080C061575;
        Sun,  5 Sep 2021 01:49:47 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id s29so3119480pfw.5;
        Sun, 05 Sep 2021 01:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=a7Wcp955CGJ0L24LohQteFwpupRJGfRgxJ4ktfBknf8=;
        b=UvquMxUhKbh4lSi4Z0gmWFmrpWPij1dsRQi/kuuj041q/d4wdRfBa8j0w74mQrCSj/
         PaxRn+84n+D0TEX4v4CBowH1eUNBK+fkqz91nmHNE95zWL2lqh5YUnpjfm8lOrcl7UIG
         XuEzh0J/+cr7csZO5IfdTB3XnQf6zCPMJEE8XHip4iwDSlYFKo+Y5GnCv3l9w516fRDK
         slU+9Mr1rb9FRBe75M5g37xjMQGn4+h3RX4BjRWkIGMbjKkY3UXXDqcjUn8wJgg1iliR
         AGBK1kYC7PNvr0PDKKSzk4G+BzrCTjshdAedgcTp85pFdi8TBbH5LCjI5+CHt4brPOqD
         1KfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=a7Wcp955CGJ0L24LohQteFwpupRJGfRgxJ4ktfBknf8=;
        b=qNyZpE7AmRTtC4gXjNWN/JiRQI28FNwMPQssLoUgxhqDfLONiQbXU6VQ6Dywh7viuF
         alz6HqXfyrCAInZ0McWZhm5n4D27JvtzF48e4RO/w33V5MWN3CNS5OB20uS+H8+VhD/C
         nZnRp7isVf7tPQAXrYto8FwGvPmenjEq1O5tNFjhvizQIYvUaxhaPivLaHN4hrZ+UJTK
         f9wFz04naVssADm9kSFSDaUmIO2O6hzwkEK2PLKMJjN2BEhHWuh08jHFBLfjBFL/affL
         FpBTqRzPzZ6bmv/T5MvddK0e0neX7ub02DjR1rtmbhq2O73m0vZZ2eq6JJuhDtg/FG0f
         T3Iw==
X-Gm-Message-State: AOAM530tQPMHXTaV304W9BmPaj6Uhn6OznXJFLwpRYRMeivvwKyLhACp
        tkuF5HOjcOyR4EcKDFhKYM0=
X-Google-Smtp-Source: ABdhPJzSU3DPzxHenGlocBhi9gdbIEdK1AdF7yvcJhgWGSmdvqGITXdE+Y2DMVLSMo5KCDETSuOtbw==
X-Received: by 2002:aa7:98c1:0:b0:3f5:e53e:119a with SMTP id e1-20020aa798c1000000b003f5e53e119amr10956502pfm.43.1630831787421;
        Sun, 05 Sep 2021 01:49:47 -0700 (PDT)
Received: from ?IPV6:2600:8802:380b:9e00:d428:5ab0:1311:1fab? ([2600:8802:380b:9e00:d428:5ab0:1311:1fab])
        by smtp.gmail.com with ESMTPSA id c24sm5072700pgj.63.2021.09.05.01.49.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Sep 2021 01:49:47 -0700 (PDT)
Message-ID: <b2e60035-2e63-3162-6222-d8c862526a28@gmail.com>
Date:   Sun, 5 Sep 2021 01:49:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH v3 1/1] virtio-blk: add num_request_queues module
 parameter
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     hch@infradead.org, mst@redhat.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        stefanha@redhat.com, israelr@nvidia.com, nitzanc@nvidia.com,
        oren@nvidia.com, linux-block@vger.kernel.org, axboe@kernel.dk
References: <20210902204622.54354-1-mgurtovoy@nvidia.com>
 <YTR12AHOGs1nhfz1@unreal>
From:   Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
In-Reply-To: <YTR12AHOGs1nhfz1@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/5/2021 12:46 AM, Leon Romanovsky wrote:
>> +static unsigned int num_request_queues;
>> +module_param_cb(num_request_queues, &queue_count_ops, &num_request_queues,
>> +		0644);
>> +MODULE_PARM_DESC(num_request_queues,
>> +		 "Number of request queues to use for blk device. Should > 0");
>> +
> Won't it limit all virtio block devices to the same limit?
>
> It is very common to see multiple virtio-blk devices on the same system
> and they probably need different limits.
>
> Thanks


Without looking into the code, that can be done adding a configfs

interface and overriding a global value (module param) when it is set from

configfs.



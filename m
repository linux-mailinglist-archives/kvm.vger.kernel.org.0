Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 729CA73A884
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 20:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbjFVSqj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 14:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbjFVSqh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 14:46:37 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A5B2103;
        Thu, 22 Jun 2023 11:46:30 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f8fb0e7709so75151545e9.2;
        Thu, 22 Jun 2023 11:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687459589; x=1690051589;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bPXpGa9jfvplqLyUF1fKF2LVSy/7Wa6tdzEbo3m24+4=;
        b=nuZ6XntxCEqRkeej37RLEv64b5NxPJAhPbyionQG1zuttFqIw4iqd6bAyZS4CvBhM2
         Tu8VCWPjrufKrBLybTXIJvxFM334JkE0VmLo+bBjlKFAfm31bDOGQOVWlKxE+HJ1VgD6
         e9xRtbtLnRzoat4eRtyifWvBUcYOkEpTTYLPgRA03cuczlnb80SdUMLD5XJqStD3dtN1
         8pyrBfNIbnwYaStG6CPLAgNUiHbvyVWI6WB//qTPRSzTSaF38HKsh6YI8Xwag3hh9vOm
         haMIgsF1a3LR9gpScqWKobKRNUZG5Mm42J3z9HaD0aR6gYqlZZhLJQ6j8LIecle/H8Z+
         WHvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687459589; x=1690051589;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bPXpGa9jfvplqLyUF1fKF2LVSy/7Wa6tdzEbo3m24+4=;
        b=O4O0I5XxjyYWFSYwuCCS37L8gzUHKQ7eVX2fmH5b2ew/YUC67GnRg2ekBHk33aqL+K
         bU8D9+Bw0fEGW1hKU++ecYRalnPUQRlI+xgvAE0XjHuMZ+Pmp+XWUi28Yjjk2C/qdM/q
         jNycz0nQT5ya8Wm4FVOEcxUS3Wpr95ZgxE/cuYEA3+kigMTVh1LBGvl2ZuCDm6kX42Sh
         WwTZSDRQTypc54Krxybh8bJ045vU66KVxV9oJku97Yd0oPbqylJXXuBjePJLjRjm06Tr
         nMzD/651olEg872ZcHXecys+dxtUxTRQVlRJylRsbn/73pinvRlQcXU8lKDiLMAqXgRB
         DMRA==
X-Gm-Message-State: AC+VfDypH3nAn71lCNzqlVg9geH3OcFDMkfOOI45HKfwAScnrHglBB50
        Y3JWVHD0G90o/xk5WI/xn/uPFpNMyb6wqQ==
X-Google-Smtp-Source: ACHHUZ7wH9qHBX81FAbtBvr0POaf7xSsPESlkJ3r2wQNrXUPW6zbsx0ZYaHHpcBIUBjThvYl1O5Tdw==
X-Received: by 2002:adf:ef12:0:b0:306:3912:a7f0 with SMTP id e18-20020adfef12000000b003063912a7f0mr14197642wro.50.1687459588851;
        Thu, 22 Jun 2023 11:46:28 -0700 (PDT)
Received: from [192.168.0.112] ([77.220.140.242])
        by smtp.gmail.com with ESMTPSA id x14-20020adfec0e000000b0030aee3da084sm7627849wrn.49.2023.06.22.11.46.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jun 2023 11:46:28 -0700 (PDT)
Message-ID: <9f0b6bba-701c-a95d-d326-bb207e319f2a@gmail.com>
Date:   Thu, 22 Jun 2023 21:46:26 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH RFC net-next v4 6/8] virtio/vsock: support dgrams
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Dan Carpenter <dan.carpenter@linaro.org>,
        Simon Horman <simon.horman@corigine.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        bpf@vger.kernel.org
References: <20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com>
 <20230413-b4-vsock-dgram-v4-6-0cebbb2ae899@bytedance.com>
 <92b3a6df-ded3-6470-39d1-fe0939441abc@gmail.com>
 <ppx75eomyyb354knfkwbwin3il2ot7hf5cefwrt6ztpcbc3pps@q736cq5v4bdh>
From:   Arseniy Krasnov <oxffffaa@gmail.com>
In-Reply-To: <ppx75eomyyb354knfkwbwin3il2ot7hf5cefwrt6ztpcbc3pps@q736cq5v4bdh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22.06.2023 19:09, Stefano Garzarella wrote:
> On Sun, Jun 11, 2023 at 11:49:02PM +0300, Arseniy Krasnov wrote:
>> Hello Bobby!
>>
>> On 10.06.2023 03:58, Bobby Eshleman wrote:
>>> This commit adds support for datagrams over virtio/vsock.
>>>
>>> Message boundaries are preserved on a per-skb and per-vq entry basis.
>>
>> I'm a little bit confused about the following case: let vhost sends 4097 bytes
>> datagram to the guest. Guest uses 4096 RX buffers in it's virtio queue, each
>> buffer has attached empty skb to it. Vhost places first 4096 bytes to the first
>> buffer of guests RX queue, and 1 last byte to the second buffer. Now IIUC guest
>> has two skb in it rx queue, and user in guest wants to read data - does it read
>> 4097 bytes, while guest has two skb - 4096 bytes and 1 bytes? In seqpacket there is
>> special marker in header which shows where message ends, and how it works here?
> 
> I think the main difference is that DGRAM is not connection-oriented, so
> we don't have a stream and we can't split the packet into 2 (maybe we
> could, but we have no guarantee that the second one for example will be
> not discarded because there is no space).
> 
> So I think it is acceptable as a restriction to keep it simple.

Ah, I see, idea is that any "corruptions" of data could be considered as
"DGRAM is not reliable anyway, so that's it" :)

> 
> My only doubt is, should we make the RX buffer size configurable,
> instead of always using 4k?

I guess this is useful only for DGRAM usage, when we want to tune buffers
for some specific case - may be for exact length of messages (for example if we have
4096 buffers, while senders wants to send 5000 bytes always by each 'send()' - I think it
will be really strange that reader ALWAYS dequeues 4096 and 4 bytes as two packets).
For stream types of socket I think size of rx buffers is not big deal in most of cases.

Thanks, Arseniy

> 
> Thanks,
> Stefano
> 

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCFC77007A
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 14:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjHDMsE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 08:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjHDMsC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 08:48:02 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4124C4C32;
        Fri,  4 Aug 2023 05:47:22 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id ffacd0b85a97d-317c1845a07so1631304f8f.2;
        Fri, 04 Aug 2023 05:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691153216; x=1691758016;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wyle6zQg15EGkVkIlS4jefoWw9QxB01b4K54vZBJjOg=;
        b=Yyc8Sp1p9IVzT32iJAol18DxBG9H0BwKA4CVh/SGDZH246+RxgT8NjkDV2YxDa7R3U
         ynZsWaWr66UBnif3PXxum3JOR6dU7nga1x3zmsvVPzzJJnOi8P7ixuA/BegLMyZ3IINK
         ITmudgr9goTwkcikmKi/E7Qits2wXWMPpMLWqIpheOyiM/Qnjz17OtX3IQpNSqsBbr82
         EORuLaSTrb/vs4m1e/TtrV5Z/HHHgbeBzUyfVHasC6WtuY1hYOZtUDNRb6RzZoSbyAwp
         0vBclBLzHpxxtZgp9WXLR2r2D9bkOfmf9+/fBvW/OTm8gpeMpKrUAapgy1wdVi2Mmj+v
         ZDSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691153216; x=1691758016;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wyle6zQg15EGkVkIlS4jefoWw9QxB01b4K54vZBJjOg=;
        b=CErgsxDC0YzUOjRUhgmkAgPb58MvH9F5qPSGdTe+RGFkbCOH72uI5/sjx9IyuYdkxT
         gx4i4Ca5wCj5Fuo17uDhnHszuW2m5eE8Vn1mIMIF4wMfmrTKQd/52ru/VG4wRSRBWyeV
         TbfA6cMoGJRrZXJVgSdaJ4dIHV2U9X76ED1JLwi6yfkMrRkVPx32f3xOEVD8w689IE17
         aGjVoCjS7RKf0Wx0Axy0bHqAFosRy5wM5YEewnHq7qhmg4H2RDZJwo2T2BVnL2SDwSGg
         iCKV0ayQl104rdLgLmDu//WLhn0yGA00OJAAqhyt5f1scVlg1awtEn8bP2smMgnMdVpj
         YYag==
X-Gm-Message-State: AOJu0YwJXXmwFShMGVvsvDsz3dMMKgYH7Fn03GLO9t0pJEQC8/96+22I
        8/qY5Wa31lE7fG6fodeSUtY=
X-Google-Smtp-Source: AGHT+IEbCtNRCj3SxUDLskfuUV8UuzZzyebK8hr8aMM1RE1gLZLRnT77kxuiEvKXJELYGneT34l/AA==
X-Received: by 2002:adf:dd0d:0:b0:314:1443:7fbe with SMTP id a13-20020adfdd0d000000b0031414437fbemr1173135wrm.36.1691153216239;
        Fri, 04 Aug 2023 05:46:56 -0700 (PDT)
Received: from [10.9.105.115] ([41.86.56.122])
        by smtp.gmail.com with ESMTPSA id z2-20020adff1c2000000b002c70ce264bfsm2435962wro.76.2023.08.04.05.46.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Aug 2023 05:46:55 -0700 (PDT)
Message-ID: <44fef482-579a-fed6-6e8c-d400546285fc@gmail.com>
Date:   Fri, 4 Aug 2023 15:46:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [RFC PATCH v1 1/2] vsock: send SIGPIPE on write to shutdowned
 socket
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru
References: <20230801141727.481156-1-AVKrasnov@sberdevices.ru>
 <20230801141727.481156-2-AVKrasnov@sberdevices.ru>
 <qgn26mgfotc7qxzp6ad7ezkdex6aqniv32c5tvehxh4hljsnvs@x7wvyvptizxx>
From:   Arseniy Krasnov <oxffffaa@gmail.com>
In-Reply-To: <qgn26mgfotc7qxzp6ad7ezkdex6aqniv32c5tvehxh4hljsnvs@x7wvyvptizxx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Stefano,

On 02.08.2023 10:46, Stefano Garzarella wrote:
> On Tue, Aug 01, 2023 at 05:17:26PM +0300, Arseniy Krasnov wrote:
>> POSIX requires to send SIGPIPE on write to SOCK_STREAM socket which was
>> shutdowned with SHUT_WR flag or its peer was shutdowned with SHUT_RD
>> flag. Also we must not send SIGPIPE if MSG_NOSIGNAL flag is set.
>>
>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>> ---
>> net/vmw_vsock/af_vsock.c | 3 +++
>> 1 file changed, 3 insertions(+)
>>
>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> index 020cf17ab7e4..013b65241b65 100644
>> --- a/net/vmw_vsock/af_vsock.c
>> +++ b/net/vmw_vsock/af_vsock.c
>> @@ -1921,6 +1921,9 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
>>             err = total_written;
>>     }
>> out:
>> +    if (sk->sk_type == SOCK_STREAM)
>> +        err = sk_stream_error(sk, msg->msg_flags, err);
> 
> Do you know why we don't need this for SOCK_SEQPACKET and SOCK_DGRAM?

Yes, here is my explanation:

This function checks that input error is SIGPIPE, and if so it sends SIGPIPE to the 'current' thread
(except case when MSG_NOSIGNAL flag is set). This behaviour is described in POSIX:

Page 367 (description of defines from sys/socket.h):
MSG_NOSIGNAL: No SIGPIPE generated when an attempt to send is made on a stream-
oriented socket that is no longer connected.

Page 497 (description of SOCK_STREAM):
A SIGPIPE signal is raised if a thread sends on a broken stream (one that is
no longer connected).

Page 1802 (description of 'send()' call):
MSG_NOSIGNAL

Requests not to send the SIGPIPE signal if an attempt to
send is made on a stream-oriented socket that is no
longer connected. The [EPIPE] error shall still be
returned

And the same for 'sendto()' and 'sendmsg()'

Link to the POSIX document:
https://www.open-std.org/jtc1/sc22/open/n4217.pdf

TCP (I think we must rely on it), KCM, SMC sockets (all of them are stream) work in the same
way by calling this function. AF_UNIX also works in the same way, but it implements SIGPIPE handling
without this function.

The only thing that confused me a little bit, that sockets above returns EPIPE when
we have only SEND_SHUTDOWN set, but for AF_VSOCK EPIPE is returned for RCV_SHUTDOWN
also, but I think it is related to this patchset.


Thanks, Arseniy

> 
> Thanks,
> Stefano
> 
>> +
>>     release_sock(sk);
>>     return err;
>> }
>> -- 
>> 2.25.1
>>
> 

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C0477032B
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 16:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbjHDOeg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 10:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjHDOef (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 10:34:35 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6D946B1;
        Fri,  4 Aug 2023 07:34:33 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-3178fa77b27so1861128f8f.2;
        Fri, 04 Aug 2023 07:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691159672; x=1691764472;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gnhR6SqlKyDtfBKJC4hNeKHd23FEMdH8MGwQaGtGRdI=;
        b=jAVLI8CesXmbCkwfHUEQ7nlVPwVVPpZ17eac7OEK4AGytdty7Ue5rFx1iL4gI80Cyh
         qRRccNopZyDI0/uixBpnI72bvA1U7YshZK0MxVs3hqovUQD7JANmLBs6IR1n75WVcnbP
         aFFX1/J0T7ir6Md0RtqZIq79WRxCgKjV9B+nh3M3Uj2w14jI/LmYeGByf1Jg+XV7XIkT
         0gcXxIK9wfWmY+A82lMMnt5EbQ02btBWu9ueGa12WI3fs/XUMl39DMOYMs0XN1nwNIUF
         VLTjGxSxOYecZbj7zlMjYkRinSlPlScdVLqD3qB0NVqMGQtLeWv/6IEVDwbwLvx5e/Az
         F0HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691159672; x=1691764472;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gnhR6SqlKyDtfBKJC4hNeKHd23FEMdH8MGwQaGtGRdI=;
        b=DpLrq7fR3N+/tjyTR1QP1iTh+BOmka+utf4C0wvUd//KTGa6HLKtPMIIoeIWFJdPGe
         UXxeDmiwtxSJGrVyt+ctI6/SCQ2mC53RPh/20uoYyN16+1qhnOr7h6tEfTZxLowjgELH
         Ww5xvrNdwkhfavugMmRyz0rt4/yEcbaEp+xpO/MTh/eKFme7Iy+000/JCnw+ig9Y0T11
         j138F8WtSMFHZPi1qNjol61Si8IPe5t/Sx2APd+mcsOn/hj/fbEh+YwhTvyoaKiiqGdQ
         hcCVIEWJy5CHPpXBzyPOQxT2rLDpD1cfka432w4NPMBWCu74W4sVeIuQIBk9DzL9cTnR
         XVZQ==
X-Gm-Message-State: AOJu0Yzk43UZAH5yNcn/pRgKEtKem35U3gX+Tm7FC+vnM35oYYfO4jxA
        +YXh74pyqCXgTvejcwVzTbw=
X-Google-Smtp-Source: AGHT+IEtCU4yB/eEUU3/q/nAeiU30tSC/qjpFrK1WeBDTdo/eu542EPuiVzE/9hJyK/GDrCa9u5DbA==
X-Received: by 2002:adf:ea42:0:b0:313:e741:1caa with SMTP id j2-20020adfea42000000b00313e7411caamr1440426wrn.25.1691159672151;
        Fri, 04 Aug 2023 07:34:32 -0700 (PDT)
Received: from [10.9.105.115] ([41.86.56.122])
        by smtp.gmail.com with ESMTPSA id s9-20020adfecc9000000b0031416362e23sm2715524wro.3.2023.08.04.07.34.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Aug 2023 07:34:31 -0700 (PDT)
Message-ID: <140bb8ec-f443-79f9-662b-0c4e972c8dd6@gmail.com>
Date:   Fri, 4 Aug 2023 17:34:20 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [RFC PATCH v1 1/2] vsock: send SIGPIPE on write to shutdowned
 socket
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Stefan Hajnoczi <stefanha@redhat.com>,
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
 <44fef482-579a-fed6-6e8c-d400546285fc@gmail.com>
 <bzkwqp26joyzgvqyoypyv43wv7t3b6rzs3v5hkch45yggmrzp6@25byvzqwiztb>
From:   Arseniy Krasnov <oxffffaa@gmail.com>
In-Reply-To: <bzkwqp26joyzgvqyoypyv43wv7t3b6rzs3v5hkch45yggmrzp6@25byvzqwiztb>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 04.08.2023 17:28, Stefano Garzarella wrote:
> On Fri, Aug 04, 2023 at 03:46:47PM +0300, Arseniy Krasnov wrote:
>> Hi Stefano,
>>
>> On 02.08.2023 10:46, Stefano Garzarella wrote:
>>> On Tue, Aug 01, 2023 at 05:17:26PM +0300, Arseniy Krasnov wrote:
>>>> POSIX requires to send SIGPIPE on write to SOCK_STREAM socket which was
>>>> shutdowned with SHUT_WR flag or its peer was shutdowned with SHUT_RD
>>>> flag. Also we must not send SIGPIPE if MSG_NOSIGNAL flag is set.
>>>>
>>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>>> ---
>>>> net/vmw_vsock/af_vsock.c | 3 +++
>>>> 1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>>>> index 020cf17ab7e4..013b65241b65 100644
>>>> --- a/net/vmw_vsock/af_vsock.c
>>>> +++ b/net/vmw_vsock/af_vsock.c
>>>> @@ -1921,6 +1921,9 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
>>>>             err = total_written;
>>>>     }
>>>> out:
>>>> +    if (sk->sk_type == SOCK_STREAM)
>>>> +        err = sk_stream_error(sk, msg->msg_flags, err);
>>>
>>> Do you know why we don't need this for SOCK_SEQPACKET and SOCK_DGRAM?
>>
>> Yes, here is my explanation:
>>
>> This function checks that input error is SIGPIPE, and if so it sends SIGPIPE to the 'current' thread
>> (except case when MSG_NOSIGNAL flag is set). This behaviour is described in POSIX:
>>
>> Page 367 (description of defines from sys/socket.h):
>> MSG_NOSIGNAL: No SIGPIPE generated when an attempt to send is made on a stream-
>> oriented socket that is no longer connected.
>>
>> Page 497 (description of SOCK_STREAM):
>> A SIGPIPE signal is raised if a thread sends on a broken stream (one that is
>> no longer connected).
> 
> Okay, but I think we should do also for SEQPACKET:
> 
> https://pubs.opengroup.org/onlinepubs/009696699/functions/xsh_chap02_10.html
> 
> In 2.10.6 Socket Types:
> 
> "The SOCK_SEQPACKET socket type is similar to the SOCK_STREAM type, and
> is also connection-oriented. The only difference between these types is
> that record boundaries ..."
> 
> Then in  2.10.14 Signals:
> 
> "The SIGPIPE signal shall be sent to a thread that attempts to send data
> on a socket that is no longer able to send. In addition, the send
> operation fails with the error [EPIPE]."
> 
> It's honestly not super clear, but I assume the problem is similar with
> seqpacket since it's connection-oriented, or did I miss something?
> 
> For example in sctp_sendmsg() IIUC we raise a SIGPIPE regardless of
> whether the socket is STREAM or SEQPACKET.

Hm, yes, you're right. Seems check for socket type is not needed in this case,
as this function is only for connection oriented sockets.

> 
>>
>> Page 1802 (description of 'send()' call):
>> MSG_NOSIGNAL
>>
>> Requests not to send the SIGPIPE signal if an attempt to
>> send is made on a stream-oriented socket that is no
>> longer connected. The [EPIPE] error shall still be
>> returned
>>
>> And the same for 'sendto()' and 'sendmsg()'
>>
>> Link to the POSIX document:
>> https://www.open-std.org/jtc1/sc22/open/n4217.pdf
>>
>> TCP (I think we must rely on it), KCM, SMC sockets (all of them are stream) work in the same
>> way by calling this function. AF_UNIX also works in the same way, but it implements SIGPIPE handling
>> without this function.
> 
> I'm okay calling this function.
> 
>>
>> The only thing that confused me a little bit, that sockets above returns EPIPE when
>> we have only SEND_SHUTDOWN set, but for AF_VSOCK EPIPE is returned for RCV_SHUTDOWN
>> also, but I think it is related to this patchset.
> 
> Do you mean that it is NOT related to this patchset?

Yes, **NOT**

> 
> Thanks,
> Stefano
>


Thanks, Arseniy
 

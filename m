Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC3F57705DE
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 18:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjHDQYT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 12:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbjHDQYP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 12:24:15 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EE249E8;
        Fri,  4 Aug 2023 09:24:13 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3fb4146e8deso22275395e9.0;
        Fri, 04 Aug 2023 09:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691166252; x=1691771052;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FxMm48ji9JaXht0N1EMlGEYOgbLi8EFkhDxDgGDkG90=;
        b=OqOngvzkp89AvEQTuNEUTPPWut/Q2x4cPfcqFK0zK1t/KmCMIi8QZdsZfKpJM39efr
         ROy3euPpsM8STbsN3Jpb8hXjzF2XH7xeYut7XooeMsM4Zx26sqD4tz7ycj28NaameeYi
         lrVaBVsS4BzDMQA0byIyioQpI1cpfb1e9B4mz5N6cKDFlJMx06Ii0z5DBuIEvEAP3mf3
         O8eUwc1FLLIKMAO3LQNyOIRUR52TA26+TKn4IQJ+Gp2T2aIOmaX/8qoaL/GF0qVE44Qd
         bytSekj+Tq1xLTCXO2qDpTLusF1z3JB23/l59GfDur5iynpyt0ZRu8r6VLhPr0ozrQrv
         Zkhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691166252; x=1691771052;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FxMm48ji9JaXht0N1EMlGEYOgbLi8EFkhDxDgGDkG90=;
        b=k9h2Xqp86rjZmaX/TRkXKgIwqy+IPB0cTuKTKrmi2VkX4RMnQ6A7cdfq9SVbrlwQ94
         B/FzRklTZEI5sGSlcObK2zrlnXu4pI5CR0hrVy3mDT3RK9+BpmENEPH90CToC8z7yajl
         ho3GxCbei6qztSIVl43ifMc1sRytTdiMqdi9z/XORtTG368C3GwTiEm39HhQqiKKcEAg
         d1CgYzmne+Qc9JcahHqir1lEcxG7CSVFwQt2HLNiFIFW5PTTSYQ6MET80KZIs3sheifS
         rRITxpgc386f9+PG+GlQrF33Lo9EHsiD+KWoMkNZ/ZA65jBDNFVN0v0/S/QoUw3RvNP2
         0xWg==
X-Gm-Message-State: AOJu0YzjhszjgGkqspJKbYp4W51tlvvctBLaU9VssYVBXMXmDbHDJliW
        lG+dhKNhCIjEQ1kd68RcjrQ=
X-Google-Smtp-Source: AGHT+IECDxewontQLHmMI2qTcWM8S95By9HkjaTJVwRMBKauDrG4/fFkniE0oSaRp4tF+Ixz/OgWrQ==
X-Received: by 2002:a05:600c:3791:b0:3fe:10d8:e7ef with SMTP id o17-20020a05600c379100b003fe10d8e7efmr1764124wmr.19.1691166251632;
        Fri, 04 Aug 2023 09:24:11 -0700 (PDT)
Received: from [10.9.105.115] ([41.86.56.122])
        by smtp.gmail.com with ESMTPSA id d18-20020adfe892000000b003143cdc5949sm2922562wrm.9.2023.08.04.09.24.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Aug 2023 09:24:11 -0700 (PDT)
Message-ID: <15ba8dc5-0bab-1829-16f5-54de14cef5a7@gmail.com>
Date:   Fri, 4 Aug 2023 19:24:02 +0300
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
 <140bb8ec-f443-79f9-662b-0c4e972c8dd6@gmail.com>
 <e2ytj5asmxnyb7oebxpzfuithtidwzcwxki7aao2q344sg3yru@ezqk5iezf3i4>
From:   Arseniy Krasnov <oxffffaa@gmail.com>
In-Reply-To: <e2ytj5asmxnyb7oebxpzfuithtidwzcwxki7aao2q344sg3yru@ezqk5iezf3i4>
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



On 04.08.2023 18:02, Stefano Garzarella wrote:
> On Fri, Aug 04, 2023 at 05:34:20PM +0300, Arseniy Krasnov wrote:
>>
>>
>> On 04.08.2023 17:28, Stefano Garzarella wrote:
>>> On Fri, Aug 04, 2023 at 03:46:47PM +0300, Arseniy Krasnov wrote:
>>>> Hi Stefano,
>>>>
>>>> On 02.08.2023 10:46, Stefano Garzarella wrote:
>>>>> On Tue, Aug 01, 2023 at 05:17:26PM +0300, Arseniy Krasnov wrote:
>>>>>> POSIX requires to send SIGPIPE on write to SOCK_STREAM socket which was
>>>>>> shutdowned with SHUT_WR flag or its peer was shutdowned with SHUT_RD
>>>>>> flag. Also we must not send SIGPIPE if MSG_NOSIGNAL flag is set.
>>>>>>
>>>>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>>>>> ---
>>>>>> net/vmw_vsock/af_vsock.c | 3 +++
>>>>>> 1 file changed, 3 insertions(+)
>>>>>>
>>>>>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>>>>>> index 020cf17ab7e4..013b65241b65 100644
>>>>>> --- a/net/vmw_vsock/af_vsock.c
>>>>>> +++ b/net/vmw_vsock/af_vsock.c
>>>>>> @@ -1921,6 +1921,9 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
>>>>>>             err = total_written;
>>>>>>     }
>>>>>> out:
>>>>>> +    if (sk->sk_type == SOCK_STREAM)
>>>>>> +        err = sk_stream_error(sk, msg->msg_flags, err);
>>>>>
>>>>> Do you know why we don't need this for SOCK_SEQPACKET and SOCK_DGRAM?
>>>>
>>>> Yes, here is my explanation:
>>>>
>>>> This function checks that input error is SIGPIPE, and if so it sends SIGPIPE to the 'current' thread
>>>> (except case when MSG_NOSIGNAL flag is set). This behaviour is described in POSIX:
>>>>
>>>> Page 367 (description of defines from sys/socket.h):
>>>> MSG_NOSIGNAL: No SIGPIPE generated when an attempt to send is made on a stream-
>>>> oriented socket that is no longer connected.
>>>>
>>>> Page 497 (description of SOCK_STREAM):
>>>> A SIGPIPE signal is raised if a thread sends on a broken stream (one that is
>>>> no longer connected).
>>>
>>> Okay, but I think we should do also for SEQPACKET:
>>>
>>> https://pubs.opengroup.org/onlinepubs/009696699/functions/xsh_chap02_10.html
>>>
>>> In 2.10.6 Socket Types:
>>>
>>> "The SOCK_SEQPACKET socket type is similar to the SOCK_STREAM type, and
>>> is also connection-oriented. The only difference between these types is
>>> that record boundaries ..."
>>>
>>> Then in  2.10.14 Signals:
>>>
>>> "The SIGPIPE signal shall be sent to a thread that attempts to send data
>>> on a socket that is no longer able to send. In addition, the send
>>> operation fails with the error [EPIPE]."
>>>
>>> It's honestly not super clear, but I assume the problem is similar with
>>> seqpacket since it's connection-oriented, or did I miss something?
>>>
>>> For example in sctp_sendmsg() IIUC we raise a SIGPIPE regardless of
>>> whether the socket is STREAM or SEQPACKET.
>>
>> Hm, yes, you're right. Seems check for socket type is not needed in this case,
>> as this function is only for connection oriented sockets.
> 
> Ack!
> 
>>
>>>
>>>>
>>>> Page 1802 (description of 'send()' call):
>>>> MSG_NOSIGNAL
>>>>
>>>> Requests not to send the SIGPIPE signal if an attempt to
>>>> send is made on a stream-oriented socket that is no
>>>> longer connected. The [EPIPE] error shall still be
>>>> returned
>>>>
>>>> And the same for 'sendto()' and 'sendmsg()'
>>>>
>>>> Link to the POSIX document:
>>>> https://www.open-std.org/jtc1/sc22/open/n4217.pdf
>>>>
>>>> TCP (I think we must rely on it), KCM, SMC sockets (all of them are stream) work in the same
>>>> way by calling this function. AF_UNIX also works in the same way, but it implements SIGPIPE handling
>>>> without this function.
>>>
>>> I'm okay calling this function.
>>>
>>>>
>>>> The only thing that confused me a little bit, that sockets above returns EPIPE when
>>>> we have only SEND_SHUTDOWN set, but for AF_VSOCK EPIPE is returned for RCV_SHUTDOWN
>>>> also, but I think it is related to this patchset.
>>>
>>> Do you mean that it is NOT related to this patchset?
>>
>> Yes, **NOT**
> 
> Got it, so if you have time when you're back, let's check also that
> (not for this series as you mentioned).

Sure!

Thanks, Arseniy

> 
> Thanks,
> Stefano
> 

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D7D7BD7EC
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 12:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346036AbjJIKF2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 06:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346029AbjJIKF1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 06:05:27 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437B599
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 03:05:25 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id 5614622812f47-3ae5ce4a4ceso3166096b6e.1
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 03:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1696845924; x=1697450724; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tU1LzqCUZS3h8pX7+UKm34RoTSScep7fx/DPCoe38tw=;
        b=BK+39T5yy4phl4G/9d9cDalQbZaRXrtX8+wNINltCQsBkDF9Fzsv1q107gGFyDbnBA
         TVXlTSPK0Ho+HJq6gd2YstKKmMM5U6QoGoBAX3oANf7yPA4drbmoVdAR2inQVpsCMxAV
         lQfzI9TgHAAOsTCRuhJkms+ODpex6oLKMdhVJRwd7D4YD1BDJyFDimMLjJnkKz25dJSr
         /jSVY3eQczLNFIT1IFI6t/oEKExn3oXv7IpFsmvPypbqMlYT0QSc+Rec5A2uqqdzHA5m
         mb2G+5hY3w3WGdacxUbq4PbDsxGBSPmyXSy2BiKjCEoyND87o7wMlDfspTDvitAfb7E8
         XrcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696845924; x=1697450724;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tU1LzqCUZS3h8pX7+UKm34RoTSScep7fx/DPCoe38tw=;
        b=q94a2iv3FcGZcyezu2hkqCwnoHDSXesgBF+N0N51fSk4yBVGV4V/Geucn5kZJWSd9A
         FQKyON3GCs03wEIz7dIl6ZPFqcvb/8AmuR5rw2leGKeK+epPr47reaQvdJCC7+mAT6gS
         /4Y4xAXwcoBGy/GRxIsEftBYzW7PT4pT5iGOuIzb1yrrN7/Hmu78kmYDJ5hGm4RqPcWL
         8mROwM++dp11Cyv7af6GhkN8yzYdH3+4aIm5gcnhB1XxNHRHn8Z0CjcJJVWYvtDE+11X
         4bQ5PpCzi211iphZ9Pn58CklHwGAojViiRqEGxDYVRl6U5pUBGNNWzK2wF1pLWuQTWBs
         osZA==
X-Gm-Message-State: AOJu0YxMmtQx3nhfsiI8PI3hMDm6almmtj5a6kVQsfcINfIz2V8vf55R
        HEbDmfzQvmY3nAlhq3vh5uOLIw==
X-Google-Smtp-Source: AGHT+IF4H0eU7CwZ4mrgQw3oNKjHU7YW8wcOMrp8fQqVCgy+nOlf1B9uoA+rslI3PUuYyMWBGQ6e4w==
X-Received: by 2002:a05:6808:2a43:b0:3a0:41d4:b144 with SMTP id fa3-20020a0568082a4300b003a041d4b144mr13646173oib.1.1696845924629;
        Mon, 09 Oct 2023 03:05:24 -0700 (PDT)
Received: from ?IPV6:2400:4050:a840:1e00:78d2:b862:10a7:d486? ([2400:4050:a840:1e00:78d2:b862:10a7:d486])
        by smtp.gmail.com with ESMTPSA id c6-20020a633506000000b0058579ef9577sm7860030pga.79.2023.10.09.03.05.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Oct 2023 03:05:24 -0700 (PDT)
Message-ID: <6a698c99-6f02-4cfb-a709-ba02296a05f7@daynix.com>
Date:   Mon, 9 Oct 2023 19:05:17 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 5/7] tun: Introduce virtio-net hashing feature
Content-Language: en-US
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org, bpf@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, rdunlap@infradead.org, willemb@google.com,
        gustavoars@kernel.org, herbert@gondor.apana.org.au,
        steffen.klassert@secunet.com, nogikh@google.com,
        pablo@netfilter.org, decui@microsoft.com, cai@lca.pw,
        jakub@cloudflare.com, elver@google.com, pabeni@redhat.com,
        Yuri Benditovich <yuri.benditovich@daynix.com>
References: <20231008052101.144422-1-akihiko.odaki@daynix.com>
 <20231008052101.144422-6-akihiko.odaki@daynix.com>
 <CAF=yD-K2MQt4nnfwJrx6h6Nii_rho7j1o6nb_jYaSwcWY45pPw@mail.gmail.com>
 <48e20be1-b658-4117-8856-89ff1df6f48f@daynix.com>
 <CAF=yD-K4bCBpUVtDR_cv=bagRL+vM4Rusez+uHFTb4_kR8XkpA@mail.gmail.com>
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <CAF=yD-K4bCBpUVtDR_cv=bagRL+vM4Rusez+uHFTb4_kR8XkpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2023/10/09 18:54, Willem de Bruijn wrote:
> On Mon, Oct 9, 2023 at 3:44 AM Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>
>> On 2023/10/09 17:13, Willem de Bruijn wrote:
>>> On Sun, Oct 8, 2023 at 12:22 AM Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>>>
>>>> virtio-net have two usage of hashes: one is RSS and another is hash
>>>> reporting. Conventionally the hash calculation was done by the VMM.
>>>> However, computing the hash after the queue was chosen defeats the
>>>> purpose of RSS.
>>>>
>>>> Another approach is to use eBPF steering program. This approach has
>>>> another downside: it cannot report the calculated hash due to the
>>>> restrictive nature of eBPF.
>>>>
>>>> Introduce the code to compute hashes to the kernel in order to overcome
>>>> thse challenges. An alternative solution is to extend the eBPF steering
>>>> program so that it will be able to report to the userspace, but it makes
>>>> little sense to allow to implement different hashing algorithms with
>>>> eBPF since the hash value reported by virtio-net is strictly defined by
>>>> the specification.
>>>>
>>>> The hash value already stored in sk_buff is not used and computed
>>>> independently since it may have been computed in a way not conformant
>>>> with the specification.
>>>>
>>>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>>>
>>>> @@ -2116,31 +2172,49 @@ static ssize_t tun_put_user(struct tun_struct *tun,
>>>>           }
>>>>
>>>>           if (vnet_hdr_sz) {
>>>> -               struct virtio_net_hdr gso;
>>>> +               union {
>>>> +                       struct virtio_net_hdr hdr;
>>>> +                       struct virtio_net_hdr_v1_hash v1_hash_hdr;
>>>> +               } hdr;
>>>> +               int ret;
>>>>
>>>>                   if (iov_iter_count(iter) < vnet_hdr_sz)
>>>>                           return -EINVAL;
>>>>
>>>> -               if (virtio_net_hdr_from_skb(skb, &gso,
>>>> -                                           tun_is_little_endian(tun), true,
>>>> -                                           vlan_hlen)) {
>>>> +               if ((READ_ONCE(tun->vnet_hash.flags) & TUN_VNET_HASH_REPORT) &&
>>>> +                   vnet_hdr_sz >= sizeof(hdr.v1_hash_hdr) &&
>>>> +                   skb->tun_vnet_hash) {
>>>
>>> Isn't vnet_hdr_sz guaranteed to be >= hdr.v1_hash_hdr, by virtue of
>>> the set hash ioctl failing otherwise?
>>>
>>> Such checks should be limited to control path where possible
>>
>> There is a potential race since tun->vnet_hash.flags and vnet_hdr_sz are
>> not read at once.
> 
> It should not be possible to downgrade the hdr_sz once v1 is selected.

I see nothing that prevents shrinking the header size.

tun->vnet_hash.flags is read after vnet_hdr_sz so the race can happen 
even for the case the header size grows though this can be fixed by 
reordering the two reads.

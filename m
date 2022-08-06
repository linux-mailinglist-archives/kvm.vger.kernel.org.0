Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F81D58B51B
	for <lists+kvm@lfdr.de>; Sat,  6 Aug 2022 12:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbiHFKwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Aug 2022 06:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiHFKwh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Aug 2022 06:52:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 59C6BE008
        for <kvm@vger.kernel.org>; Sat,  6 Aug 2022 03:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659783155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0/qh9jmfLwd9OiFNoPZvZ2ai/xbAjj6lvYqq0LiV4GY=;
        b=cSp0sGQWv9Y8ZIZJFPcVUwuCnhxKAlSlu6VPZWZO859DtX5l4K2FGnZLF6K6LZ6OfAUs4r
        O2dP2gOot/PjI82QCGQYC4GD/fBFvrP2/h1VZmrPAtfdJh0eOiDQhttTbqUepswo65/gC1
        kGnEENt4hKoO3ly8/kjftSQyO7XXYvk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-Nc6Qe3vvPQiXinLBNTYX2Q-1; Sat, 06 Aug 2022 06:52:31 -0400
X-MC-Unique: Nc6Qe3vvPQiXinLBNTYX2Q-1
Received: by mail-ed1-f72.google.com with SMTP id r12-20020a05640251cc00b00440647ec649so604854edd.21
        for <kvm@vger.kernel.org>; Sat, 06 Aug 2022 03:52:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=0/qh9jmfLwd9OiFNoPZvZ2ai/xbAjj6lvYqq0LiV4GY=;
        b=GITcrBpel/VjfDcWBSI9Sw/Gf4Cr4Uln2vDM0BaRTzRA+tyovBvO0UBuBCSBG2UO/4
         YuB9ZldI/DEFiKGsw1/yno3IAaraXL/nNVqPXgFG10PF8J4M4i5Y/Wr3Tq1PlLzSgGes
         /yMSo1girHk3+k68dHuBlhMz1+cHW9kNBEoD1WQniXdBhfBSdnJdqC8PHGgnUSMg5krA
         Rj//kzZVU3hIPL6FE4Jcbo3O/vWQFWaWwDbe2PjX679yI4Hfo55RUiEK7rcW7O7gdI66
         te6FVdx6ITnfFfSnHz81BsQP6V4Eabj8xh7NBZBRX01EZjalS8nlQ80vEN1OHG/2/VQe
         SrkA==
X-Gm-Message-State: ACgBeo0DbvNO/GQjG6lC8ndb8F5x67e2yHLfCmKP1U2Cx2mVz/CZd/bL
        C1DZqSleH37qzKSSH6hP4g456MsnSWTa5+5S0I1MZM5nhVcms9M3J9bdGScp2GZoxmB5mHtxAdR
        Cd7e83FRtkOXh
X-Received: by 2002:a17:906:9bc9:b0:730:6595:dfc8 with SMTP id de9-20020a1709069bc900b007306595dfc8mr7963488ejc.286.1659783150511;
        Sat, 06 Aug 2022 03:52:30 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7HQzhwXQO5W/vBjDoNvbpv3Lfd+BpG+2vIUeviBxP2TGtghFHSnafgjrZHJe1Foup75+pBNA==
X-Received: by 2002:a17:906:9bc9:b0:730:6595:dfc8 with SMTP id de9-20020a1709069bc900b007306595dfc8mr7963477ejc.286.1659783150311;
        Sat, 06 Aug 2022 03:52:30 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id kx11-20020a170907774b00b00730df07629fsm2358448ejc.174.2022.08.06.03.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Aug 2022 03:52:29 -0700 (PDT)
Date:   Sat, 6 Aug 2022 12:52:25 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Will Deacon <will@kernel.org>
Cc:     mst@redhat.com, stefanha@redhat.com, jasowang@redhat.com,
        torvalds@linux-foundation.org, ascull@google.com, maz@kernel.org,
        keirf@google.com, jiyong@google.com, kernel-team@android.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: IOTLB support for vhost/vsock breaks crosvm on Android
Message-ID: <20220806105225.crkui6nw53kbm5ge@sgarzare-redhat>
References: <20220805181105.GA29848@willie-the-truck>
 <20220806074828.zwzgn5gj47gjx5og@sgarzare-redhat>
 <20220806094239.GA30268@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220806094239.GA30268@willie-the-truck>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Aug 06, 2022 at 10:42:40AM +0100, Will Deacon wrote:
>Hi Stefano,
>
>On Sat, Aug 06, 2022 at 09:48:28AM +0200, Stefano Garzarella wrote:
>> On Fri, Aug 05, 2022 at 07:11:06PM +0100, Will Deacon wrote:
>> > The fundamental issue is, I think, that VIRTIO_F_ACCESS_PLATFORM is
>> > being used for two very different things within the same device; for the
>> > guest it basically means "use the DMA API, it knows what to do" but for
>> > vhost it very specifically means "enable IOTLB". We've recently had
>> > other problems with this flag [3] but in this case it used to work
>> > reliably and now it doesn't anymore.
>> >
>> > So how should we fix this? One possibility is for us to hack crosvm to
>> > clear the VIRTIO_F_ACCESS_PLATFORM flag when setting the vhost
>>
>> Why do you consider this a hack?
>
>I think it's a hack for two reasons:
>
>  (1) We're changing userspace to avoid a breaking change in kernel behaviour
>  (2) I think that crosvm's approach is actually pretty reasonable
>
>To elaborate on (2), crosvm has a set of device features that it has
>negotiated with the guest. It then takes the intersection of these features
>with those advertised by VHOST_GET_FEATURES and calls VHOST_SET_FEATURES
>with the result. If there was a common interpretation of what these features
>do, then this would work and would mean we wouldn't have to opt-in on a
>per-flag basis for vhost. Since VIRTIO_F_ACCESS_PLATFORM is being overloaded
>to mean two completely different things, then it breaks and I think masking
>out that specific flag is a hack because it's basically crosvm saying "yeah,
>I may have negotiated this with the driver but vhost _actually_ means
>'IOTLB' when it says it supports this flag so I'll mask it out because I
>know better".

Thanks for elaborating, now I think I get your point!

If I understand you correctly, what you would like is that GET_FEATURES 
should return only the data path features (thus exposed to the guest) 
and not the features for the VMM, right?

In that case, since we also negotiate backend features (with
SET|GET_BACKEND_FEATURES ioctls) for IOTLB messages to work, maybe we 
could only expose that feature if VHOST_BACKEND_F_IOTLB_MSG_V2 has been 
negotiated

@Michael, @Jason, do you think this could be doable?

>
>> If the VMM implements the translation feature, it is right in my opinion
>> that it does not enable the feature for the vhost device. Otherwise, if it
>> wants the vhost device to do the translation, enable the feature and send
>> the IOTLB messages to set the translation.
>>
>> QEMU for example masks features when not required or supported.
>> crosvm should negotiate only the features it supports.
>>
>> @Michael and @Jason can correct me, but if a vhost device negotiates
>> VIRTIO_F_ACCESS_PLATFORM, then it expects the VMM to send IOTLB messages to
>> set the translation.
>
>As above, the issue is that vhost now unconditionally advertises this in
>VHOST_GET_FEATURES and so a VMM with no knowledge of IOTLB can end up
>enabling it by accident.

I honestly don't know what the initial design was, though, from what
I've seen in QEMU, it only enables the known features, in fact for
example when we added F_SEQPACKET for vhost-vsock, we had to update QEMU
to pass the feature to the guest, so I think the initial idea was to not
unconditionally accept all the features exposed by the vhost device.

Maybe this part should be clarified.

Thanks,
Stefano


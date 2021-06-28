Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1603B586C
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 06:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbhF1Em4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 00:42:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35531 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230366AbhF1Emx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 00:42:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624855227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AHA+LCiynBinIcwBex84PZFjkFyKiA5ldfw47X4q5zo=;
        b=XEmpiDo0AGOPA8jMZyl0Pxe8y6IEpHAzegq/jALcVN4tqeidsHKJgXqK7GmYbeYDpZGR0a
        DekUa1GgA4AImOtWhtdcysWpKzCyKY7hARoEuiuk5y8k+no66nT6gPwMRdG/rXngA+j+xj
        ZWZ14iv+68EEarUOHhoLg8e+MhwR2yw=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-NrbYtdAkM1iVRnun-imttw-1; Mon, 28 Jun 2021 00:40:24 -0400
X-MC-Unique: NrbYtdAkM1iVRnun-imttw-1
Received: by mail-pl1-f199.google.com with SMTP id a6-20020a1709027d86b02901019f88b046so5184115plm.21
        for <kvm@vger.kernel.org>; Sun, 27 Jun 2021 21:40:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=AHA+LCiynBinIcwBex84PZFjkFyKiA5ldfw47X4q5zo=;
        b=YB+WNYZu42czHLLVnnMhfHQQx6GhCIrVKMy2DEjJ0KoofqaprNrwRTlmzeJoFr/9/+
         ZhPsCEqPbIp3Gh+PJt7AJVxzuEbjCG1ojc6JmLNEdbA2p7wiCU9ZF7O/CvP3hJ+tq8Ej
         iDamDNk6e4+eUXiQ27Q2q0NbjO8HwHVgTtlmH7fmE1wBkhapCAPkwIQ68TukP+9svHcY
         j+elNtfiBmD/OpNQocN74ExMfpL3lEld31zgmh4duwjJjndkyxu34gGTIrePSKOLca3S
         VUG7DVijoyIR63cyBwMQCNCU0KB40GsRMd72mo5pRy0/JoHFBSLEZMcGwaQULBx/7FFA
         uA5w==
X-Gm-Message-State: AOAM531BIFGyKHQjHbwfFiO4eQN1NOQqxCwRQ/c3XEAYOWNz4lgu5gTW
        1Qg8IxBf3yJFvPBlbjpzW4lOG0nLLYWYCfOT+AnS1HqR+ScMlLyA3gyxjmPEQLtLqu6XjLurGVp
        FLhtvcXypZ6rL
X-Received: by 2002:a17:90a:73ca:: with SMTP id n10mr35061287pjk.16.1624855223792;
        Sun, 27 Jun 2021 21:40:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwo0o1s5KBYLlDLTqUhWl2FmmtFdw3BbxmCq5oGFB7ob0lz6rjRGdc+HVA7kjdSm4QccHUIRQ==
X-Received: by 2002:a17:90a:73ca:: with SMTP id n10mr35061255pjk.16.1624855223625;
        Sun, 27 Jun 2021 21:40:23 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x143sm12654203pfc.6.2021.06.27.21.40.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Jun 2021 21:40:23 -0700 (PDT)
Subject: Re: [PATCH v8 09/10] vduse: Introduce VDUSE - vDPA Device in
 Userspace
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        Greg KH <gregkh@linuxfoundation.org>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20210615141331.407-1-xieyongji@bytedance.com>
 <20210615141331.407-10-xieyongji@bytedance.com>
 <adfb2be9-9ed9-ca37-ac37-4cd00bdff349@redhat.com>
 <CACycT3tAON+-qZev+9EqyL2XbgH5HDspOqNt3ohQLQ8GqVK=EA@mail.gmail.com>
 <1bba439f-ffc8-c20e-e8a4-ac73e890c592@redhat.com>
 <CACycT3uzMJS7vw6MVMOgY4rb=SPfT2srV+8DPdwUVeELEiJgbA@mail.gmail.com>
 <0aeb7cb7-58e5-1a95-d830-68edd7e8ec2e@redhat.com>
 <CACycT3uuooKLNnpPHewGZ=q46Fap2P4XCFirdxxn=FxK+X1ECg@mail.gmail.com>
 <e4cdee72-b6b4-d055-9aac-3beae0e5e3e1@redhat.com>
 <CACycT3u8=_D3hCtJR+d5BgeUQMce6S7c_6P3CVfvWfYhCQeXFA@mail.gmail.com>
 <d2334f66-907c-2e9c-ea4f-f912008e9be8@redhat.com>
 <CACycT3uCSLUDVpQHdrmuxSuoBDg-4n22t+N-Jm2GoNNp9JYB2w@mail.gmail.com>
 <48cab125-093b-2299-ff9c-3de8c7c5ed3d@redhat.com>
 <CACycT3tS=10kcUCNGYm=dUZsK+vrHzDvB3FSwAzuJCu3t+QuUQ@mail.gmail.com>
 <b10b3916-74d4-3171-db92-be0afb479a1c@redhat.com>
 <CACycT3vpMFbc9Fzuo9oksMaA-pVb1dEVTEgjNoft16voryPSWQ@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d7e42109-0ba6-3e1a-c42a-898b6f33c089@redhat.com>
Date:   Mon, 28 Jun 2021 12:40:14 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CACycT3vpMFbc9Fzuo9oksMaA-pVb1dEVTEgjNoft16voryPSWQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/6/25 下午12:19, Yongji Xie 写道:
>> 2b) for set_status(): simply relay the message to userspace, reply is no
>> needed. Userspace will use a command to update the status when the
>> datapath is stop. The the status could be fetched via get_stats().
>>
>> 2b looks more spec complaint.
>>
> Looks good to me. And I think we can use the reply of the message to
> update the status instead of introducing a new command.
>

Just notice this part in virtio_finalize_features():

         virtio_add_status(dev, VIRTIO_CONFIG_S_FEATURES_OK);
         status = dev->config->get_status(dev);
         if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {

So we no reply doesn't work for FEATURES_OK.

So my understanding is:

1) We must not use noreply for set_status()
2) We can use noreply for get_status(), but it requires a new ioctl to 
update the status.

So it looks to me we need synchronize for both get_status() and 
set_status().

Thanks



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9165B1977DB
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 11:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgC3J1v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 05:27:51 -0400
Received: from foss.arm.com ([217.140.110.172]:48238 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728257AbgC3J1v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 05:27:51 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 75DBE31B;
        Mon, 30 Mar 2020 02:27:50 -0700 (PDT)
Received: from [192.168.3.111] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 818BA3F52E;
        Mon, 30 Mar 2020 02:27:49 -0700 (PDT)
Subject: Re: [PATCH v2 kvmtool 15/30] virtio: Don't ignore initialization
 failures
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
 <20200123134805.1993-16-alexandru.elisei@arm.com>
 <20200130145120.0cad4a14@donnerap.cambridge.arm.com>
 <ad0199a8-bd18-4031-3489-eca9865b68fb@arm.com>
From:   =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Autocrypt: addr=andre.przywara@arm.com; prefer-encrypt=mutual; keydata=
 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
 i4aIXCH3Wv6K
Organization: ARM Ltd.
Message-ID: <bd381d17-66d5-4a08-9883-c67b29d7de2e@arm.com>
Date:   Mon, 30 Mar 2020 10:27:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <ad0199a8-bd18-4031-3489-eca9865b68fb@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/03/2020 11:20, Alexandru Elisei wrote:

Hi,

replying here after reviewing the v3 patch, and still seeing the problem.

> On 1/30/20 2:51 PM, Andre Przywara wrote:
>> On Thu, 23 Jan 2020 13:47:50 +0000
>> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>>
>> Hi,
>>
>>> Don't ignore an error in the bus specific initialization function in
>>> virtio_init; don't ignore the result of virtio_init; and don't return 0
>>> in virtio_blk__init and virtio_scsi__init when we encounter an error.
>>> Hopefully this will save some developer's time debugging faulty virtio
>>> devices in a guest.
>> Seems like the right thing to do, but I was wondering how you triggered this? AFAICS virtio_init only fails when calloc() fails or you pass an illegal transport, with the latter looking like being hard coded to one of the two supported.
> 
> I haven't triggered it. I found it by inspection. The transport-specific
> initialization functions can fail for various reasons (ioport_register or
> kvm__register_mmio can fail because some device emulation claimed all the MMIO
> space or the MMIO space was configured incorrectly in the kvm-arch.h header file;
> or memory allocation failed, etc) and this is the reason they return an int.
> Because of this, virtio_init can fail and this is the reason it too returns an
> int. It makes sense to check that the protocol that your device uses is actually
> working.
> 
>>
>> One minor thing below ...
> 
> [..]
> 
>>> diff --git a/virtio/net.c b/virtio/net.c
>>> index 091406912a24..425c13ba1136 100644
>>> --- a/virtio/net.c
>>> +++ b/virtio/net.c
>>> @@ -910,7 +910,7 @@ done:
>>>  
>>>  static int virtio_net__init_one(struct virtio_net_params *params)
>>>  {
>>> -	int i, err;
>>> +	int i, r;
>>>  	struct net_dev *ndev;
>>>  	struct virtio_ops *ops;
>>>  	enum virtio_trans trans = VIRTIO_DEFAULT_TRANS(params->kvm);
>>> @@ -920,10 +920,8 @@ static int virtio_net__init_one(struct virtio_net_params *params)
>>>  		return -ENOMEM;
>>>  
>>>  	ops = malloc(sizeof(*ops));
>>> -	if (ops == NULL) {
>>> -		err = -ENOMEM;
>>> -		goto err_free_ndev;
>>> -	}
>>> +	if (ops == NULL)
>>> +		return -ENOMEM;
>> Doesn't that leave struct net_dev allocated? I am happy with removing the goto, but we should free(ndev) before we return, I think.
> 
> Nope, the cleanup routine in virtio_net__exit takes care of deallocating it (you
> get there from virtio_net__init if virtio_net__init_one fails).

First, I don't see where we actually deallocate the struct net_dev
storage for each network device in __exit() - it seems to only call the
downscript, if needed, but frees nothing.

But more importantly, even that would only happen if this structure
would be already part of the list, which happens only *after* the check
for the ops malloc() return value. If we return prematurely due to this
malloc() failing, the ndev pointer is lost on the stack.

So I guess you need to free this here. As mentioned, you should still
drop the goto, since there is only one user.

Cheers,
Andre.

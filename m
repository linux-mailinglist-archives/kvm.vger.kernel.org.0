Return-Path: <kvm+bounces-61769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B730EC2937B
	for <lists+kvm@lfdr.de>; Sun, 02 Nov 2025 18:17:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A5090188CACC
	for <lists+kvm@lfdr.de>; Sun,  2 Nov 2025 17:17:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3463C2DEA8C;
	Sun,  2 Nov 2025 17:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V03Vo1/d"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB6B27466D;
	Sun,  2 Nov 2025 17:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762103816; cv=none; b=Dq++4sZzs0Dn52ONlLHqINdyCnZran4jwSoq0gCq7ArScA3KMqzfi+40tnJ0QpGs6xZ+JMSviY+Z0AeQ8nIu6AcxvYMSryiswBB03Rrv3dCtvMVDCD//EcUGOqA3dAevMsfs1NzBmfCrsvzup73pGNM2RDVORVn4Aa/BLStUvsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762103816; c=relaxed/simple;
	bh=6J4RYbNE7xRGZGzVZmTnvJ17pocxZEQO9XjI2jSDlH8=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=OmZugtpLyNngQU+f/VywByUftt5N5nZSnUA8B/DF0zwLWJ1petebWHiYqnjAtVBBQ7IEwPgvOSxKs9oBdjQ8yVTj7qeyxBnxaPl4obbxyCQYI5JoLO/5gcdlNnBUenpmfa3nagK0AAin9spX2lsnuSkzqwUPWHBf+9iHBKEXomI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V03Vo1/d; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BFA9C4CEFB;
	Sun,  2 Nov 2025 17:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762103816;
	bh=6J4RYbNE7xRGZGzVZmTnvJ17pocxZEQO9XjI2jSDlH8=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=V03Vo1/dFUnMI+5BbeSpvmGBru6UCgp+YG0p5jilNDNsgR6zk8AYE4Sblf2BQ/bmA
	 cwy3eyQaMO+EuVUbooSLshXM976UQjawj+Ks6mqjWBaUB+CAlbyIgVxwCdCMkAKxYp
	 /HBNlc5NLl4m/uj0f4TeVd72fT8gO0tmDfib3DZ5YBd3Om1uOIeawLXje9HbXc620U
	 kqnPHWsvnXiUA91+P8VXbtE0lge0OGtdlmuyh0rZHlqktQeWsNfJZUAXjNiD8QvVOy
	 YdufGRB2UCgVyoaJiWQvRy3FWCM4jD4Z+pQvl+iQSpogn0oQ+cs9QrXkDLFTviP1Ot
	 /EgcUFdL+Re7Q==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 0463EF40066;
	Sun,  2 Nov 2025 12:16:53 -0500 (EST)
Received: from phl-imap-08 ([10.202.2.84])
  by phl-compute-04.internal (MEProxy); Sun, 02 Nov 2025 12:16:54 -0500
X-ME-Sender: <xms:BZIHaYuDYmBjtG7IxUKfvEjba2RKlTl6PZHc9IqGhy7j_jG9gMTxwg>
    <xme:BZIHaQS40zUxhPV_fDp3AqrkIE7bV3DYAqxEVG9VTMoSNhTnkeM8e4NmeRVOn9bh6
    C0ttUUKruiqlA23NausYNPjUtH2T_MmINiNR9Ge9obYEtgqTuQOXog>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddujeehkeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedfnfgvohhn
    ucftohhmrghnohhvshhkhidfuceolhgvohhnsehkvghrnhgvlhdrohhrgheqnecuggftrf
    grthhtvghrnhepjeevffelgfelvdfgvedvteelhefhvdffheegffekveelieevfeejteei
    leeuuedvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eplhgvohhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduvdeftdehfeel
    keegqddvjeejleejjedvkedqlhgvohhnpeepkhgvrhhnvghlrdhorhhgsehlvghonhdrnh
    hupdhnsggprhgtphhtthhopeefgedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohep
    jhhorhhoseeksgihthgvshdrohhrghdprhgtphhtthhopegthhhrihhsthhirghnrdhkoh
    gvnhhighesrghmugdrtghomhdprhgtphhtthhopehrohgsihhnrdhmuhhrphhhhiesrghr
    mhdrtghomhdprhgtphhtthhopehlohhgrghnghesuggvlhhtrghtvggvrdgtohhmpdhrtg
    hpthhtohepsghhvghlghgrrghssehgohhoghhlvgdrtghomhdprhgtphhtthhopehkvghv
    ihhnrdhtihgrnhesihhnthgvlhdrtghomhdprhgtphhtthhopehvihhvvghkrdhkrghsih
    hrvgguugihsehinhhtvghlrdgtohhmpdhrtghpthhtoheprgigsghovgeskhgvrhhnvghl
    rdgukhdprhgtphhtthhopehguhhsthgrvhhorghrsheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:BZIHaR-tvJBh8-mgAOYUGdkn8s8kLulP-EWIIyk8S5GtuaFeBTZsdA>
    <xmx:BZIHaaYTJL4Te_4Fw1GF_JCGz90x2YjX8VH8icEpsxwlFdW8L1BOyw>
    <xmx:BZIHafTp-dL-74eqOB1FVVTeUq8Z5EEatKsfbiYGKBXPZYMUUjiokA>
    <xmx:BZIHaZkRSqwn6yV6mfCDZEPERqhJEoAAI8EBR8iho6RnbORQMwbAEA>
    <xmx:BZIHabI8zmEQV1j8o_hMlt7NB4IWeKKppSR-0yCNW9noFRUXSASJvZ-B>
Feedback-ID: i927946fb:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id AD0F62CE0067; Sun,  2 Nov 2025 12:16:53 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A48325OsNhe3
Date: Sun, 02 Nov 2025 19:16:34 +0200
From: "Leon Romanovsky" <leon@kernel.org>
To: "Alex Williamson" <alex@shazbot.org>
Cc: "Bjorn Helgaas" <bhelgaas@google.com>,
 "Logan Gunthorpe" <logang@deltatee.com>, "Jens Axboe" <axboe@kernel.dk>,
 "Robin Murphy" <robin.murphy@arm.com>, "Joerg Roedel" <joro@8bytes.org>,
 "Will Deacon" <will@kernel.org>,
 "Marek Szyprowski" <m.szyprowski@samsung.com>,
 "Jason Gunthorpe" <jgg@ziepe.ca>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Jonathan Corbet" <corbet@lwn.net>,
 "Sumit Semwal" <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 "Alex Williamson" <alex.williamson@redhat.com>,
 "Kees Cook" <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 "Ankit Agrawal" <ankita@nvidia.com>, "Yishai Hadas" <yishaih@nvidia.com>,
 "Shameer Kolothum" <skolothumtho@nvidia.com>,
 "Kevin Tian" <kevin.tian@intel.com>,
 "Krishnakant Jaju" <kjaju@nvidia.com>, "Matt Ochs" <mochs@nvidia.com>,
 linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 kvm@vger.kernel.org, linux-hardening@vger.kernel.org,
 "Vivek Kasireddy" <vivek.kasireddy@intel.com>
Message-Id: <d757cbcb-866a-4af4-b4fd-0ba27f706e74@app.fastmail.com>
In-Reply-To: <20251102101158.6d2c36c6@shazbot.org>
References: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
 <20251102-dmabuf-vfio-v6-10-d773cff0db9f@nvidia.com>
 <20251102080137.209aa567@shazbot.org> <20251102151253.GA50752@unreal>
 <20251102101158.6d2c36c6@shazbot.org>
Subject: Re: [PATCH v6 10/11] vfio/pci: Add dma-buf export support for MMIO regions
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Sun, Nov 2, 2025, at 19:11, Alex Williamson wrote:
> On Sun, 2 Nov 2025 17:12:53 +0200
> Leon Romanovsky <leon@kernel.org> wrote:
>> On Sun, Nov 02, 2025 at 08:01:37AM -0700, Alex Williamson wrote: 
>> > We don't need the separate loop or flag, and adding it breaks the
>> > existing reverse list walk.  Thanks,  
>> 
>> Do you want me to send v7? I have a feeling that v6 is good to be merged.
>
> Let's hold off, if this ends up being the only fixup I can roll it in.
> Thanks,

Thanks 

>
> Alex
> 
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index 24204893e221..51a3bcc26f8b 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -2403,7 +2403,6 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>>                                       struct iommufd_ctx *iommufd_ctx)
>>  {
>>         struct vfio_pci_core_device *vdev;
>> -       bool restore_revoke = false;
>>         struct pci_dev *pdev;
>>         int ret;
>>  
>> @@ -2473,7 +2472,6 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>>                 }
>>  
>>                 vfio_pci_dma_buf_move(vdev, true);
>> -               restore_revoke = true;
>>                 vfio_pci_zap_bars(vdev);
>>         }
>>  
>> @@ -2501,15 +2499,12 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>>                                struct vfio_pci_core_device, vdev.dev_set_list);
>>  
>>  err_undo:
>> -       if (restore_revoke) {
>> -               list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list)
>> -                       if (__vfio_pci_memory_enabled(vdev))
>> -                               vfio_pci_dma_buf_move(vdev, false);
>> -       }
>> -
>>         list_for_each_entry_from_reverse(vdev, &dev_set->device_list,
>> -                                        vdev.dev_set_list)
>> +                                        vdev.dev_set_list) {
>> +               if (__vfio_pci_memory_enabled(vdev))
>> +                       vfio_pci_dma_buf_move(vdev, false);
>>                 up_write(&vdev->memory_lock);
>> +       }
>>  
>>         list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list)
>>                 pm_runtime_put(&vdev->pdev->dev);
>> 
>> 
>> > 
>> > Alex
>> >   
>>


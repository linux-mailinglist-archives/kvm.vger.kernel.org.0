Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3E251FD16
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 14:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234732AbiEIMoh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 08:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234744AbiEIMoe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 08:44:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 173F6630B
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 05:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652100039;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SUadK35yMNXsZHcgs6kL1o+WcgWzTvpYsG0KVUtggWM=;
        b=RpzW2ckxg2enpj0sYnQ6PBfwAEYP5USkLeM9y8Stmo5eJRahSavalzeXtSqO/6CBbrLSyw
        XKRa6J8ClT+m+NAvSAn9pqu5N61lTFqNBI8iC3TOtIebFO+UlZcwi5DQv0STKko7Hhk5Zr
        nEVY+vVFgNHIR/F3ncfk5DbI+vP87fA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-660-cnA7PO4uNd2Xf7AIhxd-wQ-1; Mon, 09 May 2022 08:40:37 -0400
X-MC-Unique: cnA7PO4uNd2Xf7AIhxd-wQ-1
Received: by mail-wr1-f69.google.com with SMTP id s8-20020adf9788000000b0020adb01dc25so5733184wrb.20
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 05:40:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SUadK35yMNXsZHcgs6kL1o+WcgWzTvpYsG0KVUtggWM=;
        b=kLDITFA1oVl9R8lPlWmVjLzBvcvDdBmxSSmYUTOmImrhMmmsgkx2++2kAnG1E9F+hn
         Q23qP1ztHFEXh7i6J1Fi49/a3gDAbxRQX9xSjibl+qFTIHWrwsiZEUTmbsfjMWO5DUi7
         RAYrEcKbTa1ZHQ9AmPGVf1Lz8ebkhOMR/mnpMST3GCVJyuzmFG7eb2e0yufVsvaWzEGA
         2S3d2D5LuGNH2l590bvrza5Kn5yFO/qt/k7O+SofNmuAzUHq9npyZacwuLDoxH9pMR38
         q0YEnc766Z7e4NFdOEwe9w59++Sz199PEKs9c6E9+y9+cs7C/Mb7jDujpS8s09GHacnT
         ivrg==
X-Gm-Message-State: AOAM531skihqRXTibWW7jdoPwBGcHIS3XceenW/VaKLngbtGryzLbXnM
        mtoPxOMUa8eXslUXvUARzoVjWNXzd4VQKwxtLjs6S06lC2LKd8CMQ2iqCoW5cUPupULuTo6Ri1G
        Ow0J27izWzU96
X-Received: by 2002:a5d:47ca:0:b0:20c:72c9:d3be with SMTP id o10-20020a5d47ca000000b0020c72c9d3bemr13474738wrc.114.1652100036409;
        Mon, 09 May 2022 05:40:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJysvm3jkrqazePjRtdEnYu3kQ2p9NT6qTIcb4srvAfJimbVAhgFFtMASqJqwQfcuURt7qkeXg==
X-Received: by 2002:a5d:47ca:0:b0:20c:72c9:d3be with SMTP id o10-20020a5d47ca000000b0020c72c9d3bemr13474718wrc.114.1652100036144;
        Mon, 09 May 2022 05:40:36 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id b15-20020a7bc24f000000b003942a244ecfsm12770414wmj.20.2022.05.09.05.40.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 05:40:35 -0700 (PDT)
Message-ID: <20a4ca70-0dd5-75eb-0d09-234e3dceea40@redhat.com>
Date:   Mon, 9 May 2022 14:40:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 2/4] KVM: arm64: vgic: Add more checks when restoring
 ITS tables
Content-Language: en-US
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, andre.przywara@arm.com,
        drjones@redhat.com, alexandru.elisei@arm.com, oupton@google.com,
        reijiw@google.com, pshier@google.com
References: <20220427184814.2204513-1-ricarkol@google.com>
 <20220427184814.2204513-3-ricarkol@google.com>
 <b29fcba7-2599-bf1b-0720-26b05cc37fd4@redhat.com>
 <YnKxbNuf4U1Zgjx5@google.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <YnKxbNuf4U1Zgjx5@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On 5/4/22 19:01, Ricardo Koller wrote:
> On Tue, May 03, 2022 at 07:14:19PM +0200, Eric Auger wrote:
>> Hi Ricardo,
>>
>> On 4/27/22 20:48, Ricardo Koller wrote:
>>> Try to improve the predictability of ITS save/restores (and debuggability
>>> of failed ITS saves) by failing early on restore when trying to read
>>> corrupted tables.
>>>
>>> Restoring the ITS tables does some checks for corrupted tables, but not as
>>> many as in a save: an overflowing device ID will be detected on save but
>>> not on restore.  The consequence is that restoring a corrupted table won't
>>> be detected until the next save; including the ITS not working as expected
>>> after the restore.  As an example, if the guest sets tables overlapping
>>> each other, which would most likely result in some corrupted table, this is
>>> what we would see from the host point of view:
>>>
>>> 	guest sets base addresses that overlap each other
>>> 	save ioctl
>>> 	restore ioctl
>>> 	save ioctl (fails)
>>>
>>> Ideally, we would like the first save to fail, but overlapping tables could
>>> actually be intended by the guest. So, let's at least fail on the restore
>>> with some checks: like checking that device and event IDs don't overflow
>>> their tables.
>>>
>>> Signed-off-by: Ricardo Koller <ricarkol@google.com>
>>> ---
>>>  arch/arm64/kvm/vgic/vgic-its.c | 13 +++++++++++++
>>>  1 file changed, 13 insertions(+)
>>>
>>> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
>>> index e14790750958..fb2d26a73880 100644
>>> --- a/arch/arm64/kvm/vgic/vgic-its.c
>>> +++ b/arch/arm64/kvm/vgic/vgic-its.c
>>> @@ -2198,6 +2198,12 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
>>>  	if (!collection)
>>>  		return -EINVAL;
>>>  
>>> +	if (find_ite(its, dev->device_id, event_id))
>>> +		return -EINVAL;
>> Unsure about that. Nothing in the arm-vgic-its.rst doc says that the
>> KVM_DEV_ARM_ITS_RESTORE_TABLES ioctl cannot be called several times
>> (although obviously useless)
> In that case, maybe we could ignore the new repeated entry? or
Maybe you can fail only in the case the ITE to be restored is different
from the existing one? otherwise ignore.

Eric
> overwrite the old one?  find_ite() only returns the first (device_id,
> event_id) match. So, it's like the new one is ignored already.  The
> arm arm says this about MAPI commands in this situation:
>
>     If there is an existing mapping for the EventID-DeviceID
>     combination, behavior is UNPREDICTABLE.
>
> And, just in case, the main reason for adding this check was to avoid
> failing the next ITS save. The idea is to try to fail as soon as
> possible, not in possibly many days during the next migration attempt.
>
>>> +
>>> +	if (!vgic_its_check_event_id(its, dev, event_id))
>>> +		return -EINVAL;
>>> +
>>>  	ite = vgic_its_alloc_ite(dev, collection, event_id);
>>>  	if (IS_ERR(ite))
>>>  		return PTR_ERR(ite);
>>> @@ -2319,6 +2325,7 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
>>>  				void *ptr, void *opaque)
>>>  {
>>>  	struct its_device *dev;
>>> +	u64 baser = its->baser_device_table;
>>>  	gpa_t itt_addr;
>>>  	u8 num_eventid_bits;
>>>  	u64 entry = *(u64 *)ptr;
>>> @@ -2339,6 +2346,12 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
>>>  	/* dte entry is valid */
>>>  	offset = (entry & KVM_ITS_DTE_NEXT_MASK) >> KVM_ITS_DTE_NEXT_SHIFT;
>>>  
>>> +	if (find_its_device(its, id))
>>> +		return -EINVAL;
>> same here.
>>> +
>>> +	if (!vgic_its_check_id(its, baser, id, NULL))
>>> +		return -EINVAL;
>>> +
>>>  	dev = vgic_its_alloc_device(its, id, itt_addr, num_eventid_bits);
>>>  	if (IS_ERR(dev))
>>>  		return PTR_ERR(dev);
>> Thanks
>>
>> Eric
>>
> Thanks,
> Ricardo
>


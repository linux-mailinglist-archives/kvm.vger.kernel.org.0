Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E356493AA7
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 13:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240742AbiASMxo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 07:53:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53782 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232897AbiASMxn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jan 2022 07:53:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642596822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SwkPmMBPZm2f8iJU9JjWAPgSwc2rs82HeO8OQaaXdTM=;
        b=aLDS6/P8XXHlv8NBX27L2bhO16Y3WDEH43L+RKCyb7Q5eBEt+r5Mlhj09dBIaMbFr/YxH0
        lfOAMWEf2FenExb4VqcESg1hSkZkjg7L03OeQZ9W+EMqZ0r3+fQ+QuU7yiIP990+YEzwZB
        M1QeSYCv667UZcTWcMOAAk1CZ+DCoDI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-18-qMQDbJr_PimaHRYvVYTkig-1; Wed, 19 Jan 2022 07:53:41 -0500
X-MC-Unique: qMQDbJr_PimaHRYvVYTkig-1
Received: by mail-wm1-f71.google.com with SMTP id j6-20020a05600c1c0600b0034c02775da7so1227517wms.3
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 04:53:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SwkPmMBPZm2f8iJU9JjWAPgSwc2rs82HeO8OQaaXdTM=;
        b=lJaedi0K9P0D6UAAJtfDup9X9rbJ8YPbm65bMpqR7BVcGb+F/5zJvwPnQ6eACh9x56
         VwUKnWrcebKgqPTdSq9eca1m/+cfN2FbHQamq+ygEG/nTiEp0wsN1iRTk7lvHhbIunaL
         hTF+PhabavWORcq6m/jSEDku/dAKB5ZjkBgvE1uixkcxe2UM6twqjuvDO9emSIky4HF0
         DUWEGXn+AU7g0DaH3Q0saPZS2TTTFgGYSEwOhA6Mx82pTgdzHtU2Da609GfTrJg+c5ve
         1Y8+OI49lmF9+2335u5SASI94MVL/0hmf8iNdqg4ndNA+aXYpnzSrPJTH91V0+P3Pmus
         WJ6w==
X-Gm-Message-State: AOAM531m48B41jOCciqBQf1yXE20RM36/rZwd1kHM1BCmOK0qRnmaE15
        a0iJwAzzQaYaGtqFCVFhBwaESohAvnU1CWbh6qSasZGh+kE8s6V35Cjiq+8pCeHzT5Zm53JLEpQ
        uLGToFtvn6ILx
X-Received: by 2002:a05:600c:6013:: with SMTP id az19mr3437728wmb.53.1642596820169;
        Wed, 19 Jan 2022 04:53:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzl2LhxxLXcQ3l1w+0b9fNtM4mTDLYNCleWpHbCvPchbFDiCFpgnulBIbXALU2MHPtkg5nlPw==
X-Received: by 2002:a05:600c:6013:: with SMTP id az19mr3437714wmb.53.1642596819996;
        Wed, 19 Jan 2022 04:53:39 -0800 (PST)
Received: from [192.168.8.100] (tmo-096-151.customers.d1-online.com. [80.187.96.151])
        by smtp.gmail.com with ESMTPSA id i12sm18158062wrf.100.2022.01.19.04.53.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jan 2022 04:53:39 -0800 (PST)
Message-ID: <cd79f893-c711-1a60-47d6-7c392e02fc6a@redhat.com>
Date:   Wed, 19 Jan 2022 13:53:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC PATCH v1 06/10] KVM: s390: Add vm IOCTL for key checked
 guest absolute memory access
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220118095210.1651483-1-scgl@linux.ibm.com>
 <20220118095210.1651483-7-scgl@linux.ibm.com>
 <a3a143f8-8fd5-49bf-9b2b-2f7cb04732de@redhat.com>
 <8d09dc2e-2d2d-e5f6-8cc7-eecfc94a17b2@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <8d09dc2e-2d2d-e5f6-8cc7-eecfc94a17b2@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/01/2022 13.46, Christian Borntraeger wrote:
> 
> 
> Am 19.01.22 um 12:52 schrieb Thomas Huth:
>> On 18/01/2022 10.52, Janis Schoetterl-Glausch wrote:
>>> Channel I/O honors storage keys and is performed on absolute memory.
>>> For I/O emulation user space therefore needs to be able to do key
>>> checked accesses.
>>
>> Can't we do the checking in userspace? We already have functions for 
>> handling the storage keys there (see hw/s390x/s390-skeys-kvm.c), so why 
>> can't we do the checking in QEMU?
> 
> That would separate the key check from the memory operation. Potentially for 
> a long time.
> Wenn we piggy back on access_guest_abs_with_key we use mvcos in the host and 
> thus do the key check in lockstep with the keycheck which is the preferrable 
> solution.

Ok, makes sense - Janis, could you please add this rationale to the patch 
description?

  Thomas


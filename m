Return-Path: <kvm+bounces-6317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD54982E96F
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 07:19:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A04B91C22BF3
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 06:19:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73D69101EB;
	Tue, 16 Jan 2024 06:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N+RulMwt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6F3D2FC
	for <kvm@vger.kernel.org>; Tue, 16 Jan 2024 06:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705385955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dv3YKC3c8DPTgoEFA32x0UGDsvE1JRMlM1qKabmoCgU=;
	b=N+RulMwtAgTszNobZuA5LgDYcfFOEuCR3/p1cvRtXO86xkrmp2gcOuYYzUy4NoNxcQmwIa
	zzo9v5hUGJLAlp/joKQgrBHOyVtdUM/IzNmY5sRfp1fvt11OOlxXLs4pUEAs4wfsfhypTB
	D2J/+KlxnqRobfeWhvtGmuByUByozyQ=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-257-aD_e4xkZNpSn302MjUhgrA-1; Tue, 16 Jan 2024 01:19:13 -0500
X-MC-Unique: aD_e4xkZNpSn302MjUhgrA-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-360d69b2a47so3133725ab.1
        for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 22:19:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705385952; x=1705990752;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dv3YKC3c8DPTgoEFA32x0UGDsvE1JRMlM1qKabmoCgU=;
        b=Kz0AL6PRN6tWGxkwF9bcb3GUF1ZyOB1IQI79VHJYp8lPBZnfT2Y+XvmjTMgqPOHQzi
         bTCALjYh3EaoymAKoySUyqg405DcQOQWLF/+uG+XanfQvhEzpbKwZzQJbLFRYmA/1tiD
         XHs+/Q3i5DIu1AoiYmRubCRHsRGeczAwF41rbWQDJk9fZDrHwaIRjDb+b0NyprFS+eKM
         DOTe+70YYJClTxPuuUST51E/wO/lig6Dvk7Os/YQxGqk9Ah+Ld48hcRa83vYCfDML/0a
         gscX7o6dT9b/IVYgrjDCjVGDMcgdIM9xR+CoS1J6Q3K7mqs2fkanuRUM0qMDMVY30hBH
         Zkzg==
X-Gm-Message-State: AOJu0YwEzDnqKDlDeM1xee1p+kc79Xg/cws6wtx+SOcdOz+QRijNVfGR
	62SQTUDdV1SuVkmkbGhCQh76ZQWv//KA6HFpAAoiZ65LZykLHkrP9WJwV8fLbs/Hw+WjIbaW0aa
	BuQNTFCIR/PAZ4s+v9Sdx
X-Received: by 2002:a92:c561:0:b0:35f:fa79:644 with SMTP id b1-20020a92c561000000b0035ffa790644mr12233617ilj.3.1705385952611;
        Mon, 15 Jan 2024 22:19:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHI3QmE1AD6Z+nAbVNM3OMCvfP7YDFhM98TU6JD0h2wwcYA9GNa4rUkzp3YjnsgmsSb1OQfOQ==
X-Received: by 2002:a92:c561:0:b0:35f:fa79:644 with SMTP id b1-20020a92c561000000b0035ffa790644mr12233612ilj.3.1705385952371;
        Mon, 15 Jan 2024 22:19:12 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id t1-20020a02b181000000b0046e759037f4sm1510591jah.33.2024.01.15.22.19.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jan 2024 22:19:11 -0800 (PST)
Message-ID: <16c774cc-090e-4a81-8d49-1c2a369adb8c@redhat.com>
Date: Tue, 16 Jan 2024 14:19:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 2/3] runtime: arm64: Skip the migration
 tests when run on EFI
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev, Thomas Huth <thuth@redhat.com>,
 Nico Boehr <nrb@linux.ibm.com>, Colton Lewis <coltonlewis@google.com>,
 Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org
References: <20231130032940.2729006-1-shahuang@redhat.com>
 <20231130032940.2729006-3-shahuang@redhat.com>
 <20240115-92ecda86253ec8b52f348eda@orel>
Content-Language: en-US
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20240115-92ecda86253ec8b52f348eda@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/15/24 20:25, Andrew Jones wrote:
> On Wed, Nov 29, 2023 at 10:29:39PM -0500, Shaoqin Huang wrote:
>> When running the migration tests on EFI, the migration will always fail
>> since the efi/run use the vvfat format to run test, but the vvfat format
>> does not support live migration. So those migration tests will always
>> fail.
>>
>> Instead of waiting for fail everytime when run migration tests on EFI,
>> skip those tests if running on EFI.
>>
>> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
>> ---
>>   scripts/runtime.bash | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
>> index c73fb024..64d223e8 100644
>> --- a/scripts/runtime.bash
>> +++ b/scripts/runtime.bash
>> @@ -156,6 +156,10 @@ function run()
>>   
>>       cmdline=$(get_cmdline $kernel)
>>       if find_word "migration" "$groups"; then
>> +        if [ "{CONFIG_EFI}" == "y" ]; then
>> +            print_result "SKIP" $testname "" "migration tests are not supported with efi"
>> +            return 2
>> +        fi
>>           cmdline="MIGRATION=yes $cmdline"
>>       fi
>>       if find_word "panic" "$groups"; then
>> -- 
>> 2.40.1
>>
> 
> This isn't arm-specific, so we should drop the arm64 prefix from the patch
> summary and get an ack from x86 people.
> 

Ok, I can fix it and respin.

> Thanks,
> drew
> 

-- 
Shaoqin



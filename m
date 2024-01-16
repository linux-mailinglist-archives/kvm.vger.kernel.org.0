Return-Path: <kvm+bounces-6318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 10B7882E99A
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 07:38:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CB741F236B5
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 06:38:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89B0F10A1C;
	Tue, 16 Jan 2024 06:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JzkE5QOz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44AFD10A05
	for <kvm@vger.kernel.org>; Tue, 16 Jan 2024 06:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705387086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oie7qG3hD/4YNZrrfNMQFt0VD8dTSSeIYaAsFoCMhlU=;
	b=JzkE5QOz8HI63SN2S7t5bX+geW5DSmsw8O4Om4Wjz8Oz0whVB3chO4JvwFauoIKeCwR+k5
	9wrLVe3puE7l61uIfvE08pLkuQ1LjcKQFfzrRKVJitTSzcDiTyoYTapKxOE9ss0nAN/feH
	j7NgiagDI0rnmPjKMrGbq6weTzeOuLY=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-BOHwETf3PbanEHQq7VtBRA-1; Tue, 16 Jan 2024 01:37:59 -0500
X-MC-Unique: BOHwETf3PbanEHQq7VtBRA-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-6d724647a7fso1616550b3a.0
        for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 22:37:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705387078; x=1705991878;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Oie7qG3hD/4YNZrrfNMQFt0VD8dTSSeIYaAsFoCMhlU=;
        b=gWRa7uRMyB6GK2e0gm4YhO258y7XqqmBXcnSkDAjrTgQBi4P49fF6rAUd8GXD+SHai
         FQpWVf+e4sX1swkq4jTsXGRLjuwqzlUvw0lxa7NtQvb1c7uPQOv7kclDiZ1iWXQMH5ot
         IhsT87uMYmLcf5j+hPPZJd29EibhkF+tLx9+Ij//KBnSPVvmtFKPqCYhWnkDNo+7wzHK
         guPUgxSFFVyMlHi7vg7oMUBIOct9Msojs/Psmj8WR0U691+omQwEFePMpo2EvomVlALd
         2oBcv/2vn1T46Phji+FeK2V7oUXfe5Jw/pnZEZVl8iYzSfjxlqzMZyEgpcSGs6D3QiPm
         CsEw==
X-Gm-Message-State: AOJu0Yx4Hq4Kd94IqIfm6hcHDI4ddbUgf6AxhZp6Zw/7EfkboVUZrpZj
	gi1o8agNRd2Dz6frDpVs2mcX3KFLubQnvZwQDk1HqoGSqMLj0LU14sSagV7oNNAWsFxxxurF69X
	QuebLMqOnyi4n1RVmOreF
X-Received: by 2002:a05:6a00:2e20:b0:6d9:6081:602d with SMTP id fc32-20020a056a002e2000b006d96081602dmr10766066pfb.3.1705387077478;
        Mon, 15 Jan 2024 22:37:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGAOaeR+nDphUQp1lsgsm9WsHGd+j85kuwZ0giUcI57OxeUtDgrOf4Rx+WCGIeJ3ColfZE+JA==
X-Received: by 2002:a05:6a00:2e20:b0:6d9:6081:602d with SMTP id fc32-20020a056a002e2000b006d96081602dmr10766056pfb.3.1705387077141;
        Mon, 15 Jan 2024 22:37:57 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id lc26-20020a056a004f5a00b006d9330a934dsm8590269pfb.64.2024.01.15.22.37.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jan 2024 22:37:56 -0800 (PST)
Message-ID: <553b55a9-f6d1-4c37-99bf-ccdc16326196@redhat.com>
Date: Tue, 16 Jan 2024 14:37:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 3/3] arm64: efi: Make running tests on
 EFI can be parallel
Content-Language: en-US
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev, Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>, Nikos Nikoleris
 <nikos.nikoleris@arm.com>, Ricardo Koller <ricarkol@google.com>,
 kvm@vger.kernel.org
References: <20231130032940.2729006-1-shahuang@redhat.com>
 <20231130032940.2729006-4-shahuang@redhat.com>
 <20240115-df5b09a3501c04572a54416d@orel>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20240115-df5b09a3501c04572a54416d@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/15/24 20:23, Andrew Jones wrote:
> On Wed, Nov 29, 2023 at 10:29:40PM -0500, Shaoqin Huang wrote:
>> Currently running tests on EFI in parallel can cause part of tests to
>> fail, this is because arm/efi/run script use the EFI_CASE to create the
>> subdir under the efi-tests, and the EFI_CASE is the filename of the
>> test, when running tests in parallel, the multiple tests exist in the
>> same filename will execute at the same time, which will use the same
>> directory and write the test specific things into it, this cause
>> chaotic and make some tests fail.
>>
>> For example, if we running the pmu-sw-incr and pmu-chained-counters
>> and other pmu tests on EFI at the same time, the EFI_CASE will be pmu.
>> So they will write their $cmd_args to the $EFI/TEST/pmu/startup.nsh
>> at the same time, which will corrupt the startup.nsh file.
>>
>> And we can get the log which outputs:
>>
>> * pmu-sw-incr.log:
>>    - ABORT: pmu: Unknown sub-test 'pmu-mem-acce'
>> * pmu-chained-counters.log
>>    - ABORT: pmu: Unknown sub-test 'pmu-mem-access-reliab'
>>
>> And the efi-tests/pmu/startup.nsh:
>>
>> @echo -off
>> setvar fdtfile -guid 97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823 -rt =L"dtb"
>> pmu.efi pmu-mem-access-reliability
>> setvar fdtfile -guid 97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823 -rt =L"dtb"
>> pmu.efi pmu-chained-sw-incr
>>
>> As you can see, when multiple tests write to the same startup.nsh file,
>> it causes the issue.
>>
>> To Fix this issue, use the testname instead of the filename to create
>> the subdir under the efi-tests. We use the EFI_TESTNAME to replace the
>> EFI_CASE in script. Since every testname is specific, now the tests
>> can be run parallel. It also considers when user directly use the
>> arm/efi/run to run test, in this case, still use the filename.
>>
>> Besides, replace multiple $EFI_TEST/$EFI_CASE to the $EFI_CASE_DIR, this
>> makes the script looks more clean and we don'e need to replace many
>> EFI_CASE to EFI_TESTNAME.
>>
>> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
>> ---
>>   arm/efi/run | 16 +++++++++-------
>>   1 file changed, 9 insertions(+), 7 deletions(-)
>>
>> diff --git a/arm/efi/run b/arm/efi/run
>> index 6872c337..03bfbef4 100755
>> --- a/arm/efi/run
>> +++ b/arm/efi/run
>> @@ -24,6 +24,8 @@ fi
>>   : "${EFI_SRC:=$TEST_DIR}"
>>   : "${EFI_UEFI:=$DEFAULT_UEFI}"
>>   : "${EFI_TEST:=efi-tests}"
>> +: "${EFI_TESTNAME:=$TESTNAME}"
>> +: "${EFI_TESTNAME:=$(basename $1 .efi)}"
>>   : "${EFI_CASE:=$(basename $1 .efi)}"
> 
> We can write it the above like the following to avoid duplicating the
> basename call
> 
> : "${EFI_CASE:=$(basename $1 .efi)}"
> : "${EFI_TESTNAME:=$TESTNAME}"
> : "${EFI_TESTNAME:=$EFI_CASE}"

Yep. It actually looks good. I will use that format.

> 
> 
>>   : "${EFI_VAR_GUID:=97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823}"
>>   
>> @@ -56,20 +58,20 @@ if [ "$EFI_CASE" = "_NO_FILE_4Uhere_" ]; then
>>   	EFI_CASE=dummy
>>   fi
>>   
>> -: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_CASE"}"
>> +: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_TESTNAME"}"
>>   mkdir -p "$EFI_CASE_DIR"
>>   
>> -cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_TEST/$EFI_CASE/"
>> -echo "@echo -off" > "$EFI_TEST/$EFI_CASE/startup.nsh"
>> +cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_DIR/"
>> +echo "@echo -off" > "$EFI_CASE_DIR/startup.nsh"
>>   if [ "$EFI_USE_DTB" = "y" ]; then
>>   	qemu_args+=(-machine acpi=off)
>>   	FDT_BASENAME="dtb"
>> -	$(EFI_RUN=y $TEST_DIR/run -machine dumpdtb="$EFI_TEST/$EFI_CASE/$FDT_BASENAME" "${qemu_args[@]}")
>> -	echo "setvar fdtfile -guid $EFI_VAR_GUID -rt =L\"$FDT_BASENAME\""  >> "$EFI_TEST/$EFI_CASE/startup.nsh"
>> +	$(EFI_RUN=y $TEST_DIR/run -machine dumpdtb="$EFI_CASE_DIR/$FDT_BASENAME" "${qemu_args[@]}")
>> +	echo "setvar fdtfile -guid $EFI_VAR_GUID -rt =L\"$FDT_BASENAME\""  >> "$EFI_CASE_DIR/startup.nsh"
>>   fi
>> -echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_TEST/$EFI_CASE/startup.nsh"
>> +echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_CASE_DIR/startup.nsh"
>>   
>>   EFI_RUN=y $TEST_DIR/run \
>>          -bios "$EFI_UEFI" \
>> -       -drive file.dir="$EFI_TEST/$EFI_CASE/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
>> +       -drive file.dir="$EFI_CASE_DIR/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
>>          "${qemu_args[@]}"
>> -- 
>> 2.40.1
>>
> 
> Otherwise
> 
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> 

-- 
Shaoqin



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63AFF1408CE
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2020 12:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgAQLU4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jan 2020 06:20:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31409 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726371AbgAQLU4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jan 2020 06:20:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579260054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VJ0nYIT6yhxd6M+kh3bKnXFh5D4k4gQhd0i0eGOHsl8=;
        b=DF5DOKpCT4wfzvRVDBLBe21cJjGMw5gQRKERrPraBnQrTGrXnyqs+FEkpVkZEorNxruM7j
        AU8q/+SfnagBSLIj3vPVSipQr7F7lYB1SwvGNTl2ofWS55HCDt/8LQaBSzKniVx5lCgF5y
        ZhyPTCV9fpqDBq6Q5eKMinbYy/mGbUQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-MmikiiLuN-G80nNacxEvwQ-1; Fri, 17 Jan 2020 06:20:52 -0500
X-MC-Unique: MmikiiLuN-G80nNacxEvwQ-1
Received: by mail-wm1-f70.google.com with SMTP id n17so1112414wmk.1
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2020 03:20:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VJ0nYIT6yhxd6M+kh3bKnXFh5D4k4gQhd0i0eGOHsl8=;
        b=RbtD2Y2UtHtfAEU0cdyh+3uTD5qAq3HlWQ/+jNA0ORTV3JhQIBzwPORcEcjjCnOBJB
         rY6ufwMJQSQ9uEonndfTlq6ZiIeuu/Ummhgj76GvJ0GvZI7DOTmK6G6b5KjxPJR4jZgA
         jPrHsKY1YPhaBkY/wNdxSKvmk5lARQdQ7bbszuXby5ENjcDaz5bZQJEJKsampW92WtFw
         kjA1wImi/yEXOLrxx+AAqQzFmNHeipjdijdnb66zhQVNtfJlGO3MuR/19WnPm0vqHOXN
         6tI/b+QAkfA8XoCOD+Z3JY0caqGBxXQJbEK1ryU9ZZg9Bq57Rd/zVw16L7MHhW190gx6
         KOIQ==
X-Gm-Message-State: APjAAAVLTnn5Ks8oA6AffGPzNGvfWx89XwcYkCgYVh7iwVbhZC7MAFwh
        KnSFhHbxw/NreYaM/pxosOlfN/8KSBQ87TpngANF9+CT3i3IybJ51LaH/jgpvIUNVlr7WsDynMF
        IZAnU3BP2SbUw
X-Received: by 2002:a5d:6ca1:: with SMTP id a1mr2497895wra.36.1579260050980;
        Fri, 17 Jan 2020 03:20:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqzPtoRLTxRLbjJbwIsWYdE5olFrOaGUCCU7lOaYXQKHPrY66Xj8i1zfubM2IJckPew0SxOfZw==
X-Received: by 2002:a5d:6ca1:: with SMTP id a1mr2497874wra.36.1579260050752;
        Fri, 17 Jan 2020 03:20:50 -0800 (PST)
Received: from [192.168.1.35] (113.red-83-57-172.dynamicip.rima-tde.net. [83.57.172.113])
        by smtp.gmail.com with ESMTPSA id u16sm7059167wmj.41.2020.01.17.03.20.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2020 03:20:50 -0800 (PST)
Subject: Re: [PATCH v22 5/9] ACPI: Record the Generic Error Status Block
 address
To:     gengdongjiu <gengdongjiu@huawei.com>, pbonzini@redhat.com,
        mst@redhat.com, imammedo@redhat.com, shannon.zhaosl@gmail.com,
        peter.maydell@linaro.org, fam@euphon.net, rth@twiddle.net,
        ehabkost@redhat.com, mtosatti@redhat.com, xuwei5@huawei.com,
        jonathan.cameron@huawei.com, james.morse@arm.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org
Cc:     zhengxiang9@huawei.com, linuxarm@huawei.com
References: <1578483143-14905-1-git-send-email-gengdongjiu@huawei.com>
 <1578483143-14905-6-git-send-email-gengdongjiu@huawei.com>
 <11c62b51-7a94-5e34-39c6-60c5e989a63b@redhat.com>
 <de0dbaaa-01aa-aba7-df9a-ddfb9a2164b0@huawei.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <86db126c-cfec-6057-3724-a52eecb6c681@redhat.com>
Date:   Fri, 17 Jan 2020 12:20:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <de0dbaaa-01aa-aba7-df9a-ddfb9a2164b0@huawei.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/17/20 11:47 AM, gengdongjiu wrote:
> On 2020/1/17 15:39, Philippe Mathieu-Daudé wrote:
>>>          table_offsets = g_array_new(false, true /* clear */,
>>>                                            sizeof(uint32_t));
>>> @@ -831,7 +832,9 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
>>>        acpi_add_table(table_offsets, tables_blob);
>>>        build_spcr(tables_blob, tables->linker, vms);
>>>    -    if (vms->ras) {
>>> +    acpi_ged_state = ACPI_GED(object_resolve_path_type("", TYPE_ACPI_GED,
>>> +                                                       NULL));
>>
>> Testing vms->ras first is cheaper than calling object_resolve_path_type(). Since some people are spending lot of time to reduce VM boot time, it might be worth considering.
> Thanks Philippe's comments.
> 
> Do you think it should be written to below[1]? right?
> 
> [1]:
> if (vms->ras && acpi_ged_state)

No, as:

   if (vms->ras) {
     AcpiGedState *acpi_ged_state;

     acpi_ged_state = ACPI_GED(object_resolve_path_type("", 
TYPE_ACPI_GED, NULL));
     if (acpi_ged_state) {
       acpi_add_table(table_offsets, tables_blob);
       ...

Maybe I'm wrong and there is not much impact in VM boot time here, 
reviews welcomed :)

>>
>>> +    if (acpi_ged_state &&  vms->ras) {
>>>            acpi_add_table(table_offsets, tables_blob);
>>>            build_ghes_error_table(tables->hardware_errors, tables->linker);
>>>            acpi_build_hest(tables_blob, tables->hardware_errors,
>>> @@ -925,6 +928,7 @@ void virt_acpi_setup(VirtMachineState *vms)
>>>    {
> 


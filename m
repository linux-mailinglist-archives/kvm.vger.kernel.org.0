Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68DE91A5A3
	for <lists+kvm@lfdr.de>; Sat, 11 May 2019 01:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbfEJXyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 May 2019 19:54:03 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37164 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbfEJXyD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 May 2019 19:54:03 -0400
Received: by mail-pg1-f194.google.com with SMTP id e6so3725244pgc.4
        for <kvm@vger.kernel.org>; Fri, 10 May 2019 16:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Svi2hY/4Fr3G+7H1zc/Iy6stZcJ5hnOIc4eke2F0YMc=;
        b=CQt1NUC0+UVisWj0aeqS3HCMh2e83MdQI41pf8vNM4fq1FhpAbKhv4NKg7azOmeAXY
         QOiouY/yoXP6DMT9PJBPoNyffyDcpjP63WC1rwnr0N9YNWB0OEFB//Gt3Om7myH3gyJx
         DXyEwzkUMqpf2CpK5+V6fIehNLhqQ+SzFm6N7V9s1SGMBC3ktk+7ZqP+pdP59xLXRoKy
         MgTgca4/UQzSU2ZGfPG8ZQRXmSBo+FMYFKDHwBa4WbpEmycLJRTUAo3L5HavGr45iN5V
         7zouGkCUIT7XRuGNgHzlRxFIe7NpXgNapYXDEFLc1c7P7G5BxRp++d0ggbYp162PUYAu
         0s+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Svi2hY/4Fr3G+7H1zc/Iy6stZcJ5hnOIc4eke2F0YMc=;
        b=WByM2QfTLpBTkkF15SC+OgPN+TaR9UDkEUVzVH/UYhaS4vE5dqLY/SsKHmE6j2wh3c
         n5LNlSjT31ClpszTMVdnVHELc6viFPa8l8XpyiWfnEptXDrQ5GsabTw5PsMmGRkJJBJa
         e3j4LKVu28FZms6XpY1F7af5Z0tjT9zjJCL4Jvkrwpqvu7eRnWES4ZJp98EXl5j9ecWz
         oVzwsjNLIQg21oB2LEJ3WlL+59QnvSwJ6Nqz9Ji6rfzo9PK//cRSFIVh4ru43v0a1khl
         wYZm+AzaCB6BlwmJiPx+Bdnv/aUAIglm1tSv6FKXW5d78Vc6GHBjwHVMsM7Iwh/pGna+
         HF+Q==
X-Gm-Message-State: APjAAAUIoY2Em4UpnXGKIY2pEurOsuTEDITZ176eq0T47bCPYxZcl4MI
        BCsMCpotLJPShEjorchawK4AX9bP9iE=
X-Google-Smtp-Source: APXvYqwLNez1XAfarTfYFIM3vz6KnBdktgEO7WpE6cPRknW43q9HSd1Gd1C7PgxuYvk0ligGUaXUvQ==
X-Received: by 2002:a63:224a:: with SMTP id t10mr16957032pgm.271.1557532442666;
        Fri, 10 May 2019 16:54:02 -0700 (PDT)
Received: from [10.2.189.129] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id f87sm10091410pff.56.2019.05.10.16.54.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 May 2019 16:54:01 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Subject: Re: [kvm-unit-tests PATCH] x86: Restore VMCS state when
 test_vmcs_addr() is done
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <a9417280-db71-4e24-02d6-abc00f96c402@oracle.com>
Date:   Fri, 10 May 2019 16:54:00 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <4296149D-7351-48E4-B9F9-EA358AAE1D63@gmail.com>
References: <20190502145741.7863-1-nadav.amit@gmail.com>
 <a9417280-db71-4e24-02d6-abc00f96c402@oracle.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
X-Mailer: Apple Mail (2.3445.104.8)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On May 10, 2019, at 4:49 PM, Krish Sadhukhan =
<krish.sadhukhan@oracle.com> wrote:
>=20
>=20
>=20
> On 05/02/2019 07:57 AM, nadav.amit@gmail.com wrote:
>> From: Nadav Amit <nadav.amit@gmail.com>
>>=20
>> The VMCS fields of APIC_VIRT_ADDR and TPR_THRESHOLD are modified by
>> test_vmcs_addr() but are not restored to their original value. Save =
and
>> restore them.
>>=20
>> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
>> ---
>>  x86/vmx_tests.c | 12 +++++++-----
>>  1 file changed, 7 insertions(+), 5 deletions(-)
>>=20
>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>> index e9010af..2d6b12d 100644
>> --- a/x86/vmx_tests.c
>> +++ b/x86/vmx_tests.c
>> @@ -4432,6 +4432,8 @@ static void test_tpr_threshold_values(void)
>>  static void test_tpr_threshold(void)
>>  {
>>  	u32 primary =3D vmcs_read(CPU_EXEC_CTRL0);
>> +	u64 apic_virt_addr =3D vmcs_read(APIC_VIRT_ADDR);
>> +	u64 threshold =3D vmcs_read(TPR_THRESHOLD);
>>  	void *virtual_apic_page;
>>    	if (!(ctrl_cpu_rev[0].clr & CPU_TPR_SHADOW))
>> @@ -4451,11 +4453,8 @@ static void test_tpr_threshold(void)
>>  	report_prefix_pop();
>>    	if (!((ctrl_cpu_rev[0].clr & CPU_SECONDARY) &&
>> -	    (ctrl_cpu_rev[1].clr & (CPU_VINTD  | =
CPU_VIRT_APIC_ACCESSES)))) {
>> -		vmcs_write(CPU_EXEC_CTRL0, primary);
>> -		return;
>> -	}
>> -
>> +	    (ctrl_cpu_rev[1].clr & (CPU_VINTD  | =
CPU_VIRT_APIC_ACCESSES))))
>> +		goto out;
>>  	u32 secondary =3D vmcs_read(CPU_EXEC_CTRL1);
>>    	if (ctrl_cpu_rev[1].clr & CPU_VINTD) {
>> @@ -4505,6 +4504,9 @@ static void test_tpr_threshold(void)
>>  	}
>>    	vmcs_write(CPU_EXEC_CTRL1, secondary);
>> +out:
>> +	vmcs_write(TPR_THRESHOLD, threshold);
>> +	vmcs_write(APIC_VIRT_ADDR, apic_virt_addr);
>>  	vmcs_write(CPU_EXEC_CTRL0, primary);
>>  }
>> =20
>=20
> The function name in the commit message (both header and body) is
> incorrect. It should be =E2=80=9Ctest_tpr_threshold=E2=80=9D.

Too many patches=E2=80=A6 Will fix.=

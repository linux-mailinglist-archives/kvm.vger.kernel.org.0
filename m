Return-Path: <kvm+bounces-39843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA579A4B629
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 03:37:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA9F516C13B
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 02:37:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97BD5188CDB;
	Mon,  3 Mar 2025 02:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OnosDGgX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7611662F1
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 02:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740969418; cv=none; b=vCFj2ZeR9kM4dZmHhFEfT/TD+PH8AkcEaSiMUCF1DJxuZdo7ZwERc88Aw2TEHqBpXr3Ig/mGKu8aunzALER1rd05esVDhaIHFZX4ahNf20ZLIz6Ax18ElUkdUk96kiUXnrE3L5z897ATe8xto+viOcsTl/1IRnslwCbtCpLMZKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740969418; c=relaxed/simple;
	bh=yXnkXkENrzb8r1gN4wtDU6veXvrITTCGm0kyhoR+UK4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IoYSUwow2+2njtPyPJns1km77PKVYZkbaktUYAKs77vgQxCh+1prGvYjdQnsRGW7FEu7OD0Pz94K8o4cRtPL3AyoAK3UbyRvR18Bis5jN0FxJgnGhbldfQSvNmUHz69SCLXUu9xf9NceYfHnOxqb4o5XfhgwcDm/BhctwVUwuZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OnosDGgX; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740969417; x=1772505417;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yXnkXkENrzb8r1gN4wtDU6veXvrITTCGm0kyhoR+UK4=;
  b=OnosDGgXX6h7UcsuNZuOvEEUx9aHYEqaGilBKR6r3UndNKaMkQVzdbuV
   aOLlVnH1GfZ92NTry6kHlgfgESID0e6XeswFBMFvcMzwHzvwPDPI2ETkU
   5WtYW9ge1VD0IoFP7XX96uLnC4wtbTAUovOxgNl3DUrmKJUJ2NTcx+ira
   sGYqVgFtDAinQnOfiakzXAzjaSzh+OHBfaT9jFIGxrsAKWe4eFtgRsLAq
   1QmjajGeGvEAUDvX7ydinGtKAT7HQBLhcWH1e65aHbBSeLihsEocI3mHn
   6PYLMS96YdOXm4wDIE3STHeY1jxWU5HPikjY9/sWY517sF73Y7Sn/jouB
   Q==;
X-CSE-ConnectionGUID: jS/6aJUVTCKexRftnDe36w==
X-CSE-MsgGUID: rldIsPRFQbic3qFXbqhRMA==
X-IronPort-AV: E=McAfee;i="6700,10204,11361"; a="59375813"
X-IronPort-AV: E=Sophos;i="6.13,328,1732608000"; 
   d="scan'208";a="59375813"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 18:36:56 -0800
X-CSE-ConnectionGUID: RMIqGMMkQy6G/jfM1Jvlog==
X-CSE-MsgGUID: ulreb2OpRz+uPvfHaiqJLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,328,1732608000"; 
   d="scan'208";a="122468717"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 18:36:52 -0800
Message-ID: <d686aa93-3207-4129-bf70-08406e2d6df9@intel.com>
Date: Mon, 3 Mar 2025 10:36:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 28/52] i386/tdx: Wire TDX_REPORT_FATAL_ERROR with
 GuestPanic facility
To: Francesco Lavra <francescolavra.fl@gmail.com>,
 Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>,
 Marcelo Tosatti <mtosatti@redhat.com>, Huacai Chen <chenhuacai@kernel.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
 <20250124132048.3229049-29-xiaoyao.li@intel.com>
 <c5418f363998a7416bf3667de7a9f3536634d3ad.camel@gmail.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <c5418f363998a7416bf3667de7a9f3536634d3ad.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/28/2025 12:30 AM, Francesco Lavra wrote:
> On Fri, 2025-01-24 at 08:20 -0500, Xiaoyao Li wrote:
>> diff --git a/system/runstate.c b/system/runstate.c
>> index 272801d30769..c4244c8915c6 100644
>> --- a/system/runstate.c
>> +++ b/system/runstate.c
>> @@ -565,6 +565,60 @@ static void qemu_system_wakeup(void)
>>       }
>>   }
>>   
>> +static char *tdx_parse_panic_message(char *message)
>> +{
>> +    bool printable = false;
>> +    char *buf = NULL;
>> +    int len = 0, i;
>> +
>> +    /*
>> +     * Although message is defined as a json string, we shouldn't
>> +     * unconditionally treat it as is because the guest generated it
>> and
>> +     * it's not necessarily trustable.
>> +     */
>> +    if (message) {
>> +        /* The caller guarantees the NULL-terminated string. */
>> +        len = strlen(message);
>> +
>> +        printable = len > 0;
>> +        for (i = 0; i < len; i++) {
>> +            if (!(0x20 <= message[i] && message[i] <= 0x7e)) {
>> +                printable = false;
>> +                break;
>> +            }
>> +        }
>> +    }
>> +
>> +    if (len == 0) {
>> +        buf = g_malloc(1);
>> +        buf[0] = '\0';
>> +    } else {
>> +        if (!printable) {
>> +            /* 3 = length of "%02x " */
>> +            buf = g_malloc(len * 3);
>> +            for (i = 0; i < len; i++) {
>> +                if (message[i] == '\0') {
>> +                    break;
>> +                } else {
>> +                    sprintf(buf + 3 * i, "%02x ", message[i]);
>> +                }
>> +            }
>> +            if (i > 0) {
>> +                /* replace the last ' '(space) to NULL */
>> +                buf[i * 3 - 1] = '\0';
>> +            } else {
>> +                buf[0] = '\0';
>> +            }
>> +
>> +        } else {
>> +            buf = g_malloc(len);
>> +            memcpy(buf, message, len);
> 
> This fails to null-terminate the message string in buf.
> 

will just use g_strdup(message);


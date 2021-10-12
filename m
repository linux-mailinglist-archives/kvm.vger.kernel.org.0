Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D646429D8D
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 08:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbhJLGRy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 02:17:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47250 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232254AbhJLGRx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Oct 2021 02:17:53 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19C3aRQU004363;
        Tue, 12 Oct 2021 02:15:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=NMIaYgIWaa2mEFGRjAVpgl+cOJ7az3sdVVNdN20k24A=;
 b=SqCew9PY0LLEeRW5mc4GDdfEmVHUvshVKa/bGyw/oPRFz3dV4lL/S9hC40bKopvkssY5
 z7Ksxqa0wvZOG2PzWUzNGauU2wknhTPj7V927/nA2bV6wWzHyKPE2XISzKX50QyulpXE
 I0Z0c0vrg1/7LlfPvCivMSStV6LfD2JBMOjHqhD8psFOzng7ti1qQfLjXXDOO+rUcZBZ
 BHlCYEtUR39njNN1RA5Vr3Q4s4IWPtdeFO+wAJgBBhkMcx6jC/An+kk0Gdx7Jkj4roVU
 Ruh7EfDLArTEzFvJJTqas7rY/yMxsvqooLancHKiGyG788Rkc+pFHebwuIltAnaKvjrS Ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bmx9pepks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 02:15:46 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19C6FjhP030967;
        Tue, 12 Oct 2021 02:15:45 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bmx9pepkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 02:15:45 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19C5vPlB007098;
        Tue, 12 Oct 2021 06:15:44 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02wdc.us.ibm.com with ESMTP id 3bk2qavd34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 06:15:44 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19C6FhXT45220242
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 06:15:43 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51D0B13604F;
        Tue, 12 Oct 2021 06:15:43 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8DA2136069;
        Tue, 12 Oct 2021 06:15:40 +0000 (GMT)
Received: from [9.65.95.104] (unknown [9.65.95.104])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 12 Oct 2021 06:15:40 +0000 (GMT)
Subject: Re: [PATCH v4 12/23] target/i386/sev: Use g_autofree in
 sev_launch_get_measure()
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sergio Lopez <slp@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>
References: <20211007161716.453984-1-philmd@redhat.com>
 <20211007161716.453984-13-philmd@redhat.com>
 <73fbdf51-411c-71da-56bf-644ee45a1cbe@linux.ibm.com>
From:   Dov Murik <dovmurik@linux.ibm.com>
Message-ID: <4fe7f260-7aa3-9b86-20df-f8dc4f841929@linux.ibm.com>
Date:   Tue, 12 Oct 2021 09:15:39 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <73fbdf51-411c-71da-56bf-644ee45a1cbe@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fOWabils-SRXqnCzGKrPpKHCgsrGQHeI
X-Proofpoint-ORIG-GUID: OJrXmRet3GW0vf_DytRG_gmYM4OBDybh
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-12_01,2021-10-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0 impostorscore=0
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110120033
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 07/10/2021 19:28, Dov Murik wrote:
> 
> 
> On 07/10/2021 19:17, Philippe Mathieu-Daudé wrote:
>> Use g_autofree to remove a pair of g_free/goto.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>> ---
>>  target/i386/sev.c | 13 ++++---------
>>  1 file changed, 4 insertions(+), 9 deletions(-)
>>
>> diff --git a/target/i386/sev.c b/target/i386/sev.c
>> index 3a30ba6d94a..5cbbcf0bb93 100644
>> --- a/target/i386/sev.c
>> +++ b/target/i386/sev.c
>> @@ -685,8 +685,8 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
>>  {
>>      SevGuestState *sev = sev_guest;
>>      int ret, error;
>> -    guchar *data;
>> -    struct kvm_sev_launch_measure *measurement;
>> +    g_autofree guchar *data = NULL;
>> +    g_autofree struct kvm_sev_launch_measure *measurement = NULL;
> 
> Sorry for joining so late, but why do we allocate struct
> kvm_sev_launch_measure on the heap (even before this patch)? It's only
> 12 bytes. Might be simpler to have a local (stack) variable and not care
> about memory management.
> 

I sent another series [1] with this fix (and a similar fix in
launch_start); it can be added as part of this housekeeping series.

[1] https://lore.kernel.org/qemu-devel/20211011173026.2454294-1-dovmurik@linux.ibm.com/

-Dov

> -Dov
> 
> 
>>  
>>      if (!sev_check_state(sev, SEV_STATE_LAUNCH_UPDATE)) {
>>          return;
>> @@ -708,7 +708,7 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
>>      if (!measurement->len) {
>>          error_report("%s: LAUNCH_MEASURE ret=%d fw_error=%d '%s'",
>>                       __func__, ret, error, fw_error_to_str(errno));
>> -        goto free_measurement;
>> +        return;
>>      }
>>  
>>      data = g_new0(guchar, measurement->len);
>> @@ -720,7 +720,7 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
>>      if (ret) {
>>          error_report("%s: LAUNCH_MEASURE ret=%d fw_error=%d '%s'",
>>                       __func__, ret, error, fw_error_to_str(errno));
>> -        goto free_data;
>> +        return;
>>      }
>>  
>>      sev_set_guest_state(sev, SEV_STATE_LAUNCH_SECRET);
>> @@ -728,11 +728,6 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
>>      /* encode the measurement value and emit the event */
>>      sev->measurement = g_base64_encode(data, measurement->len);
>>      trace_kvm_sev_launch_measurement(sev->measurement);
>> -
>> -free_data:
>> -    g_free(data);
>> -free_measurement:
>> -    g_free(measurement);
>>  }
>>  
>>  char *
>>

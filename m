Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9987436B434
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 15:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbhDZNnn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 09:43:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1778 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230250AbhDZNnm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Apr 2021 09:43:42 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13QDYlqh016376;
        Mon, 26 Apr 2021 09:43:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mP/zjKInFsmpowkRxiaTTxiPvYDgs3ieiiCTSc1HyA4=;
 b=GC4oaIIkL7ms16inCPSnXM1qHqqcVtZpE8Z2C0wBT5b8eSb58vNEqVd+9zQI428s5FR/
 f0Fhga3F6f1D8gsyNOF8llD4HlZO0ICUMsN1rmMyjglYOLtp3OM0CKVfJvTBRVGqzB7l
 jvfzHmjNzZ7eti+0uhDtFv+GvZvre2GpSeH4ym8YC0GRCgRMCih2fN6OM2xJF6zsrFWs
 2IhDXjuP5QHC1q1EAQHq1lP7CFNpdHI9s/ScfVzuttZjAmpnk7kSkYeIAKqeCJA/pbyf
 da3ZnKp3AqLJip8nHf/Pt5UxzaPKD1zs2L9aJ0RprBDufKINnJXlD+SY8S8YDK2sbfSL Fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 385xg10c79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Apr 2021 09:43:00 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13QDYqUX016812;
        Mon, 26 Apr 2021 09:43:00 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 385xg10c63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Apr 2021 09:43:00 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13QDghuT003339;
        Mon, 26 Apr 2021 13:42:58 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 384akh8u35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Apr 2021 13:42:58 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13QDe8Lu20513212
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Apr 2021 13:40:08 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E57B852050;
        Mon, 26 Apr 2021 13:40:07 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.12.8])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 90B8D52067;
        Mon, 26 Apr 2021 13:40:07 +0000 (GMT)
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com
References: <20210316091654.1646-1-frankja@linux.ibm.com>
 <20210316091654.1646-6-frankja@linux.ibm.com>
 <20210420162649.4f9b77a6@ibm-vm>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 5/6] s390x: uv-guest: Test invalid commands
Message-ID: <6a059cd0-cc31-7430-b62d-529fd72f1c9b@linux.ibm.com>
Date:   Mon, 26 Apr 2021 15:40:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210420162649.4f9b77a6@ibm-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: g2pcUCwV-N1ijVSp9DdP3rLcXZlITaAt
X-Proofpoint-ORIG-GUID: XRObRJybYvJ4ojhaD-Jiil_CMdvG8J4P
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-26_07:2021-04-26,2021-04-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104260105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/20/21 4:26 PM, Claudio Imbrenda wrote:
> On Tue, 16 Mar 2021 09:16:53 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> Let's check if the commands that are not indicated as available
>> produce a invalid command error.
> 
> you say this, but you don't actually check that the commands are
> actually reported as unavailable

I'm a bit torn about this.

It is a UV guest test after all and we check that we are a UV guest in
main() so we are not able to accidentally run as a host. So those
indication bits and their associated calls should never be available.

> 
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  s390x/uv-guest.c | 44 +++++++++++++++++++++++++++++++++++++-------
>>  1 file changed, 37 insertions(+), 7 deletions(-)
>>
>> diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
>> index 8915b2f1..517e3c66 100644
>> --- a/s390x/uv-guest.c
>> +++ b/s390x/uv-guest.c
>> @@ -120,16 +120,46 @@ static void test_sharing(void)
>>  	report_prefix_pop();
>>  }
>>  
>> +static struct {
>> +	const char *name;
>> +	uint16_t cmd;
>> +	uint16_t len;
>> +} invalid_cmds[] = {
>> +	{ "bogus", 0x4242, sizeof(struct uv_cb_header) },
>> +	{ "init", UVC_CMD_INIT_UV, sizeof(struct uv_cb_init) },
>> +	{ "create conf", UVC_CMD_CREATE_SEC_CONF, sizeof(struct
>> uv_cb_cgc) },
>> +	{ "destroy conf", UVC_CMD_DESTROY_SEC_CONF, sizeof(struct
>> uv_cb_nodata) },
>> +	{ "create cpu", UVC_CMD_CREATE_SEC_CPU, sizeof(struct
>> uv_cb_csc) },
>> +	{ "destroy cpu", UVC_CMD_DESTROY_SEC_CPU, sizeof(struct
>> uv_cb_nodata) },
>> +	{ "conv to", UVC_CMD_CONV_TO_SEC_STOR, sizeof(struct
>> uv_cb_cts) },
>> +	{ "conv from", UVC_CMD_CONV_FROM_SEC_STOR, sizeof(struct
>> uv_cb_cfs) },
>> +	{ "set sec conf", UVC_CMD_SET_SEC_CONF_PARAMS, sizeof(struct
>> uv_cb_ssc) },
>> +	{ "unpack", UVC_CMD_UNPACK_IMG, sizeof(struct uv_cb_unp) },
>> +	{ "verify", UVC_CMD_VERIFY_IMG, sizeof(struct uv_cb_nodata)
>> },
>> +	{ "cpu reset", UVC_CMD_CPU_RESET, sizeof(struct
>> uv_cb_nodata) },
>> +	{ "cpu initial reset", UVC_CMD_CPU_RESET_INITIAL,
>> sizeof(struct uv_cb_nodata) },
>> +	{ "conf clear reset", UVC_CMD_PERF_CONF_CLEAR_RESET,
>> sizeof(struct uv_cb_nodata) },
>> +	{ "cpu clear reset", UVC_CMD_CPU_RESET_CLEAR, sizeof(struct
>> uv_cb_nodata) },
>> +	{ "cpu set state", UVC_CMD_CPU_SET_STATE, sizeof(struct
>> uv_cb_cpu_set_state) },
>> +	{ "pin shared", UVC_CMD_PIN_PAGE_SHARED, sizeof(struct
>> uv_cb_cfs) },
>> +	{ "unpin shared", UVC_CMD_UNPIN_PAGE_SHARED, sizeof(struct
>> uv_cb_cts) },
>> +	{ NULL, 0, 0 },
>> +};
>> +
>>  static void test_invalid(void)
>>  {
>> -	struct uv_cb_header uvcb = {
>> -		.len = 16,
>> -		.cmd = 0x4242,
>> -	};
>> -	int cc;
>> +	struct uv_cb_header *hdr = (void *)page;
>> +	int cc, i;
>>  
>> -	cc = uv_call(0, (u64)&uvcb);
>> -	report(cc == 1 && uvcb.rc == UVC_RC_INV_CMD, "invalid
>> command");
>> +	report_prefix_push("invalid");
> 
> here you just blindly loop over all the commands, without checking
> their actual availability
> 
>> +	for (i = 0; invalid_cmds[i].name; i++) {
> 
> maybe you can add another field for the availability bit (or even put
> them in the right order so the bit is the index) and here add something
> like
> 
> if (uv_query_test_feature(i))
> 	continue;
> 
> so you will be sure the command is not available
> 
>> +		hdr->cmd = invalid_cmds[i].cmd;
>> +		hdr->len = invalid_cmds[i].len;
>> +		cc = uv_call(0, (u64)hdr);
>> +		report(cc == 1 && hdr->rc == UVC_RC_INV_CMD, "%s",
>> +		       invalid_cmds[i].name);
>> +	}
>> +	report_prefix_pop();
>>  }
>>  
>>  int main(void)
> 


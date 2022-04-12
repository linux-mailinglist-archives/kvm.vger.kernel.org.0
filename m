Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE124FE4CA
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 17:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357034AbiDLPfU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 11:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiDLPfT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 11:35:19 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CB62F390;
        Tue, 12 Apr 2022 08:33:01 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23CF0655028572;
        Tue, 12 Apr 2022 15:33:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=oqIEVjX9SgFTQ31YIXsdpm+ZPO6dGjZU48Q1D4MBjjo=;
 b=EtDAhjz1DRFUg3rDXmzLXfdaK3Ya49iA86cKHnz++9+NAcKmfN5fobQTFkQkFlpAio1I
 d2WU8wwZvwF6P084Hzvbe66pSzIF6Ca7qqovLSkiA9R4AQ/ZCeicDaGsgHfxkJPCubvp
 DmmXlgzi3mHJidM7j0Vrk6MKz+jrnCNUKfU7AWkPBcDNxQs+6PR6LhavClXeaj5BZ/KE
 kD1IA71b/KYbUpVHqMQMALffgit64TgXdPg/lcCW8Jt8MYSe3VJUNf7AL8RH9x+3J64c
 FhDT6gjRGaYqKAnR6TE6McWECvDKQULPnzy0vI+mOQiKnwdNHTeuLJ9I698mjpxl0QtL rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fdbp30sgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 15:32:57 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23CFDRmE024718;
        Tue, 12 Apr 2022 15:32:56 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fdbp30sfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 15:32:56 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23CFHxdK011767;
        Tue, 12 Apr 2022 15:32:55 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3fb1s8w4jg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 15:32:54 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23CFWpiT40173968
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 15:32:51 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6EFEE11C050;
        Tue, 12 Apr 2022 15:32:51 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30CDD11C04A;
        Tue, 12 Apr 2022 15:32:51 +0000 (GMT)
Received: from [9.145.83.15] (unknown [9.145.83.15])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Apr 2022 15:32:51 +0000 (GMT)
Message-ID: <19e481fb-9804-b42c-7554-8388889dbf73@linux.ibm.com>
Date:   Tue, 12 Apr 2022 17:32:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com
References: <20220411100750.2868587-1-nrb@linux.ibm.com>
 <20220411100750.2868587-2-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/4] lib: s390x: add support for SCLP
 console read
In-Reply-To: <20220411100750.2868587-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RMlRtWEtY8J94R-BSc8YDD8lrBEpKYMd
X-Proofpoint-ORIG-GUID: RdOHQjVz1sFV9EHpdDrL6mBvzjqqDiYt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_05,2022-04-12_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1015
 mlxlogscore=999 phishscore=0 impostorscore=0 priorityscore=1501
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120073
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/11/22 12:07, Nico Boehr wrote:
> Add a basic implementation for reading from the SCLP ACII console. The goal of
> this is to support migration tests on s390x. To know when the migration has been
> finished, we need to listen for a newline on our console.
> 
> Hence, this implementation is focused on the SCLP ASCII console of QEMU and
> currently won't work under e.g. LPAR.

How much pain would it be to add the line mode read?

> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
[..]
>   
> +static void sclp_console_enable_read(void)
> +{
> +	sclp_write_event_mask(SCLP_EVENT_MASK_MSG_ASCII, SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_MSG);
> +}
> +
> +static void sclp_console_disable_read(void)
> +{
> +	sclp_write_event_mask(0, SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_MSG);
> +}
> +
>   void sclp_console_setup(void)
>   {
> -	sclp_set_write_mask();
> +	/* We send ASCII and line mode. */
> +	sclp_write_event_mask(0, SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_MSG);
>   }
>   
>   void sclp_print(const char *str)
> @@ -227,3 +240,59 @@ void sclp_print(const char *str)
>   	sclp_print_ascii(str);
>   	sclp_print_lm(str);
>   }
> +
> +#define SCLP_EVENT_ASCII_DATA_STREAM_FOLLOWS 0

-> sclp.h

> +
> +static int console_refill_read_buffer(void)
> +{
> +	const int MAX_EVENT_BUFFER_LEN = SCCB_SIZE - offsetof(ReadEventDataAsciiConsole, ebh);
> +	ReadEventDataAsciiConsole *sccb = (void *)_sccb;
> +	const int EVENT_BUFFER_ASCII_RECV_HEADER_LEN = sizeof(sccb->ebh) + sizeof(sccb->type);
> +	int ret = -1;

Reverse Christmas tree
The const int variables are all caps because they are essentially constants?

> +
> +	sclp_console_enable_read();
> +
> +	sclp_mark_busy();
> +	memset(sccb, 0, 4096);

sizeof(*sccb)

> +	sccb->h.length = PAGE_SIZE;
> +	sccb->h.function_code = SCLP_UNCONDITIONAL_READ;
> +	sccb->h.control_mask[2] = 0x80;
> +
> +	sclp_service_call(SCLP_CMD_READ_EVENT_DATA, sccb);
> +
> +	if ((sccb->h.response_code == SCLP_RC_NO_EVENT_BUFFERS_STORED) ||
> +	    (sccb->ebh.type != SCLP_EVENT_ASCII_CONSOLE_DATA) ||
> +	    (sccb->type != SCLP_EVENT_ASCII_DATA_STREAM_FOLLOWS)) {
> +		ret = -1;
> +		goto out;
> +	}
> +
> +	assert(sccb->ebh.length <= MAX_EVENT_BUFFER_LEN);
> +	assert(sccb->ebh.length > EVENT_BUFFER_ASCII_RECV_HEADER_LEN);
> +
> +	read_buf_end = sccb->ebh.length - EVENT_BUFFER_ASCII_RECV_HEADER_LEN;
> +
> +	assert(read_buf_end <= sizeof(read_buf));
> +	memcpy(read_buf, sccb->data, read_buf_end);
> +
> +	read_index = 0;
> +
> +out:
> +	sclp_console_disable_read();
> +
> +	return ret;
> +}
> +
> +int __getchar(void)
> +{
> +	int ret;
> +
> +	if (read_index >= read_buf_end) {
> +		ret = console_refill_read_buffer();
> +		if (ret < 0) {
> +			return ret;
> +		}
> +	}
> +
> +	return read_buf[read_index++];
> +}
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index fead007a6037..5bd1741d721d 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -313,6 +313,13 @@ typedef struct ReadEventData {
>   	uint32_t mask;
>   } __attribute__((packed)) ReadEventData;
>   
> +typedef struct ReadEventDataAsciiConsole {
> +	SCCBHeader h;
> +	EventBufferHeader ebh;
> +	uint8_t type;
> +	char data[];
> +} __attribute__((packed)) ReadEventDataAsciiConsole;
> +
>   extern char _sccb[];
>   void sclp_setup_int(void);
>   void sclp_handle_ext(void);
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 53b0fe044fe7..62e197cb93d7 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -71,6 +71,7 @@ cflatobjs += lib/alloc_phys.o
>   cflatobjs += lib/alloc_page.o
>   cflatobjs += lib/vmalloc.o
>   cflatobjs += lib/alloc_phys.o
> +cflatobjs += lib/getchar.o
>   cflatobjs += lib/s390x/io.o
>   cflatobjs += lib/s390x/stack.o
>   cflatobjs += lib/s390x/sclp.o


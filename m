Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC3350A283
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 16:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388943AbiDUOdM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 10:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389505AbiDUOcc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 10:32:32 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558423DA72;
        Thu, 21 Apr 2022 07:29:38 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23LCsabS010784;
        Thu, 21 Apr 2022 14:29:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=IokaGkRSLXq+PysOzu/2QhCGFnBqRQkjRuJlc68saV8=;
 b=aYtMc8mvRKKT1p2zAxa4ZLlpdo0TWxK+MhmQC0d3obB/eo9Dew0Od+0AVcQukAPRwj2J
 ZcgPCvBrukSxJoFaYsQaDwBbed0lM66QsLiwA6SLyTmT+Svna+4eiN1pol8eg3k96hbF
 c8uDzkhdas26d2EcktvtDwSwYzsw+yZZi3LHzWmkoHpBAnNatQ8/11NPHMAQ50PN9wT0
 9bokYK8tB7+5KgRZJvkYef+Nw4TlTloDWLanccghdzUcX7vTDO/0wZkGanrj+Xq1W4XL
 WztHDNtezRAIyiGm8rYOqtX6Zp9OhMdnLn3mKdqld2sLwjUdWvp28anhq5KZjLOtuUC4 tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjswesmne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 14:29:36 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23LERfnO022347;
        Thu, 21 Apr 2022 14:29:35 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjswesmm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 14:29:35 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23LEDENl024177;
        Thu, 21 Apr 2022 14:29:32 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3ffne8xcej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 14:29:31 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23LETSTH25297380
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 14:29:28 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BAAB942042;
        Thu, 21 Apr 2022 14:29:28 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D62142041;
        Thu, 21 Apr 2022 14:29:28 +0000 (GMT)
Received: from [9.145.69.75] (unknown [9.145.69.75])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Apr 2022 14:29:28 +0000 (GMT)
Message-ID: <d8e6d465-3a8a-db75-1244-ed574efd9f59@linux.ibm.com>
Date:   Thu, 21 Apr 2022 16:29:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com
References: <20220420134557.1307305-1-nrb@linux.ibm.com>
 <20220420134557.1307305-2-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 1/4] lib: s390x: add support for SCLP
 console read
In-Reply-To: <20220420134557.1307305-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: X0m011a03PonXSUnuINqnJIZtoZdXtmj
X-Proofpoint-GUID: bvgyUBwAKMTUVvypKxwBWO_ZAknti7Uj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-21_01,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=0 adultscore=0 clxscore=1015 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210077
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/20/22 15:45, Nico Boehr wrote:
> Add a basic implementation for reading from the SCLP ASCII console. The goal of
> this is to support migration tests on s390x. To know when the migration has been
> finished, we need to listen for a newline on our console.
> 
> Hence, this implementation is focused on the SCLP ASCII console of QEMU and
> currently won't work under e.g. LPAR.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>   lib/s390x/sclp-console.c | 79 +++++++++++++++++++++++++++++++++++++---
>   lib/s390x/sclp.h         |  8 ++++
>   s390x/Makefile           |  1 +
>   3 files changed, 82 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
> index fa36a6a42381..8c4bf68cbbab 100644
> --- a/lib/s390x/sclp-console.c
> +++ b/lib/s390x/sclp-console.c
> @@ -89,6 +89,10 @@ static char lm_buff[120];
>   static unsigned char lm_buff_off;
>   static struct spinlock lm_buff_lock;
>   
> +static char read_buf[4096];
> +static int read_index = sizeof(read_buf) - 1;
> +static int read_buf_end = 0;
> +
>   static void sclp_print_ascii(const char *str)
>   {
>   	int len = strlen(str);
> @@ -185,7 +189,7 @@ static void sclp_print_lm(const char *str)
>    * indicating which messages the control program (we) want(s) to
>    * send/receive.
>    */
> -static void sclp_set_write_mask(void)
> +static void sclp_write_event_mask(int receive_mask, int send_mask)
>   {
>   	WriteEventMask *sccb = (void *)_sccb;
>   
> @@ -195,18 +199,27 @@ static void sclp_set_write_mask(void)
>   	sccb->h.function_code = SCLP_FC_NORMAL_WRITE;
>   	sccb->mask_length = sizeof(sccb_mask_t);
>   
> -	/* For now we don't process sclp input. */
> -	sccb->cp_receive_mask = 0;
> -	/* We send ASCII and line mode. */
> -	sccb->cp_send_mask = SCLP_EVENT_MASK_MSG_ASCII | SCLP_EVENT_MASK_MSG;
> +	sccb->cp_receive_mask = receive_mask;
> +	sccb->cp_send_mask = send_mask;
>   
>   	sclp_service_call(SCLP_CMD_WRITE_EVENT_MASK, sccb);
>   	assert(sccb->h.response_code == SCLP_RC_NORMAL_COMPLETION);
>   }
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
> @@ -227,3 +240,57 @@ void sclp_print(const char *str)
>   	sclp_print_ascii(str);
>   	sclp_print_lm(str);
>   }
> +
> +static int console_refill_read_buffer(void)
> +{
> +	const int max_event_buffer_len = SCCB_SIZE - offsetof(ReadEventDataAsciiConsole, ebh);
> +	ReadEventDataAsciiConsole *sccb = (void *)_sccb;
> +	const int event_buffer_ascii_recv_header_len = sizeof(sccb->ebh) + sizeof(sccb->type);
> +	int ret = -1;
> +
> +	sclp_console_enable_read();
> +
> +	sclp_mark_busy();
> +	memset(sccb, 0, SCCB_SIZE);
> +	sccb->h.length = PAGE_SIZE;
> +	sccb->h.function_code = SCLP_UNCONDITIONAL_READ;
> +	sccb->h.control_mask[2] = SCLP_CM2_VARIABLE_LENGTH_RESPONSE;
> +
> +	sclp_service_call(SCLP_CMD_READ_EVENT_DATA, sccb);
> +
> +	if (sccb->h.response_code == SCLP_RC_NO_EVENT_BUFFERS_STORED ||
> +	    sccb->ebh.type != SCLP_EVENT_ASCII_CONSOLE_DATA ||
> +	    sccb->type != SCLP_EVENT_ASCII_TYPE_DATA_STREAM_FOLLOWS) {
> +		ret = -1;
> +		goto out;
> +	}
> +
> +	assert(sccb->ebh.length <= max_event_buffer_len);
> +	assert(sccb->ebh.length > event_buffer_ascii_recv_header_len);
> +
> +	read_buf_end = sccb->ebh.length - event_buffer_ascii_recv_header_len;

Isn't this more like a length of the current read buffer contents?

> +
> +	assert(read_buf_end <= sizeof(read_buf));
> +	memcpy(read_buf, sccb->data, read_buf_end);
> +
> +	read_index = 0;
> +	ret = 0;
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
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return read_buf[read_index++];
> +}
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index fead007a6037..e48a5a3df20b 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -313,6 +313,14 @@ typedef struct ReadEventData {
>   	uint32_t mask;
>   } __attribute__((packed)) ReadEventData;
>   
> +#define SCLP_EVENT_ASCII_TYPE_DATA_STREAM_FOLLOWS 0

Hrm, I'm not completely happy with the naming here since I confused it 
to the ebh->type when looking up the constants. But now I understand why 
you chose it.

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
> index c11f6efbd767..f38f442b9cb1 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -75,6 +75,7 @@ cflatobjs += lib/alloc_phys.o
>   cflatobjs += lib/alloc_page.o
>   cflatobjs += lib/vmalloc.o
>   cflatobjs += lib/alloc_phys.o
> +cflatobjs += lib/getchar.o
>   cflatobjs += lib/s390x/io.o
>   cflatobjs += lib/s390x/stack.o
>   cflatobjs += lib/s390x/sclp.o


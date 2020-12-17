Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 493302DD36D
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 15:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbgLQO7Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 09:59:25 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43928 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726291AbgLQO7Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Dec 2020 09:59:24 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BHElQFD169441;
        Thu, 17 Dec 2020 09:58:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=eWGuN9OPhj6gOxeXPNeDD3XYYlV1HyUbm/WUfI8+Oq4=;
 b=F0Py2X3emxPZJ24SQ+298M1BB808uXy4sIo5iIyqPwmGrLaFdNVO0zIXjZoKLziKd48N
 OzCl1h39DWZPo37ha2ciHXu6W6yxU0FT7BU2FquzsEM/lLLb4see1/AbcvMskJnziBu0
 RI5FKcyqlV8S43SOLI07dABsmbfKQrYj4mOXbIJS0NEvTleQY+26tC6AGYRi5R8M/Xdw
 0yW12ituT87gKpBW8/7HtM9eRLSEh4MVVMxsi2a/e+dncZfM6Dv/w+ZPIdAaJeaHiUYI
 fDil5oS2oK2AAGav6RjoKmrSXRFFidblaUxph3B4a8+v32eyKQGbVKpwMu4duVo1QbMV pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35g9degb6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 09:58:43 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BHElW75169768;
        Thu, 17 Dec 2020 09:58:42 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35g9degb5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 09:58:42 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BHEvRer006446;
        Thu, 17 Dec 2020 14:58:40 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 35cng85fj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 14:58:40 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BHEwbcu36635090
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 14:58:37 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98C53A4060;
        Thu, 17 Dec 2020 14:58:37 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33D85A4054;
        Thu, 17 Dec 2020 14:58:37 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.12.102])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Dec 2020 14:58:37 +0000 (GMT)
Date:   Thu, 17 Dec 2020 15:55:30 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 8/8] s390x: Fix sclp.h style issues
Message-ID: <20201217155530.67922937@ibm-vm>
In-Reply-To: <20201211100039.63597-9-frankja@linux.ibm.com>
References: <20201211100039.63597-1-frankja@linux.ibm.com>
        <20201211100039.63597-9-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_09:2020-12-15,2020-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012170099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 11 Dec 2020 05:00:39 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> Fix indentation
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Acked-by: Thomas Huth <thuth@redhat.com>m>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/sclp.h | 172
> +++++++++++++++++++++++------------------------ 1 file changed, 86
> insertions(+), 86 deletions(-)
> 
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index 58f8e54..dccbaa8 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -79,10 +79,10 @@
>  #define SCCB_SIZE 4096
>  
>  typedef struct SCCBHeader {
> -    uint16_t length;
> -    uint8_t function_code;
> -    uint8_t control_mask[3];
> -    uint16_t response_code;
> +	uint16_t length;
> +	uint8_t function_code;
> +	uint8_t control_mask[3];
> +	uint16_t response_code;
>  } __attribute__((packed)) SCCBHeader;
>  
>  #define SCCB_DATA_LEN (SCCB_SIZE - sizeof(SCCBHeader))
> @@ -90,15 +90,15 @@ typedef struct SCCBHeader {
>  
>  /* CPU information */
>  typedef struct CPUEntry {
> -    uint8_t address;
> -    uint8_t reserved0;
> -    uint8_t : 4;
> -    uint8_t feat_sief2 : 1;
> -    uint8_t : 3;
> -    uint8_t features_res2 [SCCB_CPU_FEATURE_LEN - 1];
> -    uint8_t reserved2[6];
> -    uint8_t type;
> -    uint8_t reserved1;
> +	uint8_t address;
> +	uint8_t reserved0;
> +	uint8_t : 4;
> +	uint8_t feat_sief2 : 1;
> +	uint8_t : 3;
> +	uint8_t features_res2 [SCCB_CPU_FEATURE_LEN - 1];
> +	uint8_t reserved2[6];
> +	uint8_t type;
> +	uint8_t reserved1;
>  } __attribute__((packed)) CPUEntry;
>  
>  extern struct sclp_facilities sclp_facilities;
> @@ -110,77 +110,77 @@ struct sclp_facilities {
>  };
>  
>  typedef struct ReadInfo {
> -    SCCBHeader h;
> -    uint16_t rnmax;
> -    uint8_t rnsize;
> -    uint8_t  _reserved1[16 - 11];       /* 11-15 */
> -    uint16_t entries_cpu;               /* 16-17 */
> -    uint16_t offset_cpu;                /* 18-19 */
> -    uint8_t  _reserved2[24 - 20];       /* 20-23 */
> -    uint8_t  loadparm[8];               /* 24-31 */
> -    uint8_t  _reserved3[48 - 32];       /* 32-47 */
> -    uint64_t facilities;                /* 48-55 */
> -    uint8_t  _reserved0[76 - 56];       /* 56-75 */
> -    uint32_t ibc_val;
> -    uint8_t  conf_char[99 - 80];        /* 80-98 */
> -    uint8_t mha_pow;
> -    uint32_t rnsize2;
> -    uint64_t rnmax2;
> -    uint8_t  _reserved6[116 - 112];     /* 112-115 */
> -    uint8_t  conf_char_ext[120 - 116];   /* 116-119 */
> -    uint16_t highest_cpu;
> -    uint8_t  _reserved5[124 - 122];     /* 122-123 */
> -    uint32_t hmfai;
> -    uint8_t reserved7[134 - 128];
> -    uint8_t byte_134_diag318 : 1;
> -    uint8_t : 7;
> -    struct CPUEntry entries[0];
> +	SCCBHeader h;
> +	uint16_t rnmax;
> +	uint8_t rnsize;
> +	uint8_t  _reserved1[16 - 11];       /* 11-15 */
> +	uint16_t entries_cpu;               /* 16-17 */
> +	uint16_t offset_cpu;                /* 18-19 */
> +	uint8_t  _reserved2[24 - 20];       /* 20-23 */
> +	uint8_t  loadparm[8];               /* 24-31 */
> +	uint8_t  _reserved3[48 - 32];       /* 32-47 */
> +	uint64_t facilities;                /* 48-55 */
> +	uint8_t  _reserved0[76 - 56];       /* 56-75 */
> +	uint32_t ibc_val;
> +	uint8_t  conf_char[99 - 80];        /* 80-98 */
> +	uint8_t mha_pow;
> +	uint32_t rnsize2;
> +	uint64_t rnmax2;
> +	uint8_t  _reserved6[116 - 112];     /* 112-115 */
> +	uint8_t  conf_char_ext[120 - 116];   /* 116-119 */
> +	uint16_t highest_cpu;
> +	uint8_t  _reserved5[124 - 122];     /* 122-123 */
> +	uint32_t hmfai;
> +	uint8_t reserved7[134 - 128];
> +	uint8_t byte_134_diag318 : 1;
> +	uint8_t : 7;
> +	struct CPUEntry entries[0];
>  } __attribute__((packed)) ReadInfo;
>  
>  typedef struct ReadCpuInfo {
> -    SCCBHeader h;
> -    uint16_t nr_configured;         /* 8-9 */
> -    uint16_t offset_configured;     /* 10-11 */
> -    uint16_t nr_standby;            /* 12-13 */
> -    uint16_t offset_standby;        /* 14-15 */
> -    uint8_t reserved0[24-16];       /* 16-23 */
> -    struct CPUEntry entries[0];
> +	SCCBHeader h;
> +	uint16_t nr_configured;         /* 8-9 */
> +	uint16_t offset_configured;     /* 10-11 */
> +	uint16_t nr_standby;            /* 12-13 */
> +	uint16_t offset_standby;        /* 14-15 */
> +	uint8_t reserved0[24-16];       /* 16-23 */
> +	struct CPUEntry entries[0];
>  } __attribute__((packed)) ReadCpuInfo;
>  
>  typedef struct ReadStorageElementInfo {
> -    SCCBHeader h;
> -    uint16_t max_id;
> -    uint16_t assigned;
> -    uint16_t standby;
> -    uint8_t _reserved0[16 - 14]; /* 14-15 */
> -    uint32_t entries[0];
> +	SCCBHeader h;
> +	uint16_t max_id;
> +	uint16_t assigned;
> +	uint16_t standby;
> +	uint8_t _reserved0[16 - 14]; /* 14-15 */
> +	uint32_t entries[0];
>  } __attribute__((packed)) ReadStorageElementInfo;
>  
>  typedef struct AttachStorageElement {
> -    SCCBHeader h;
> -    uint8_t _reserved0[10 - 8];  /* 8-9 */
> -    uint16_t assigned;
> -    uint8_t _reserved1[16 - 12]; /* 12-15 */
> -    uint32_t entries[0];
> +	SCCBHeader h;
> +	uint8_t _reserved0[10 - 8];  /* 8-9 */
> +	uint16_t assigned;
> +	uint8_t _reserved1[16 - 12]; /* 12-15 */
> +	uint32_t entries[0];
>  } __attribute__((packed)) AttachStorageElement;
>  
>  typedef struct AssignStorage {
> -    SCCBHeader h;
> -    uint16_t rn;
> +	SCCBHeader h;
> +	uint16_t rn;
>  } __attribute__((packed)) AssignStorage;
>  
>  typedef struct IoaCfgSccb {
> -    SCCBHeader header;
> -    uint8_t atype;
> -    uint8_t reserved1;
> -    uint16_t reserved2;
> -    uint32_t aid;
> +	SCCBHeader header;
> +	uint8_t atype;
> +	uint8_t reserved1;
> +	uint16_t reserved2;
> +	uint32_t aid;
>  } __attribute__((packed)) IoaCfgSccb;
>  
>  typedef struct SCCB {
> -    SCCBHeader h;
> -    char data[SCCB_DATA_LEN];
> - } __attribute__((packed)) SCCB;
> +	SCCBHeader h;
> +	char data[SCCB_DATA_LEN];
> +} __attribute__((packed)) SCCB;
>  
>  /* SCLP event types */
>  #define SCLP_EVENT_ASCII_CONSOLE_DATA           0x1a
> @@ -195,13 +195,13 @@ typedef struct SCCB {
>  #define SCLP_SELECTIVE_READ                     0x01
>  
>  typedef struct WriteEventMask {
> -    SCCBHeader h;
> -    uint16_t _reserved;
> -    uint16_t mask_length;
> -    uint32_t cp_receive_mask;
> -    uint32_t cp_send_mask;
> -    uint32_t send_mask;
> -    uint32_t receive_mask;
> +	SCCBHeader h;
> +	uint16_t _reserved;
> +	uint16_t mask_length;
> +	uint32_t cp_receive_mask;
> +	uint32_t cp_send_mask;
> +	uint32_t send_mask;
> +	uint32_t receive_mask;
>  } __attribute__((packed)) WriteEventMask;
>  
>  #define MDBTYP_GO               0x0001
> @@ -254,25 +254,25 @@ struct mdb {
>  } __attribute__((packed));
>  
>  typedef struct EventBufferHeader {
> -    uint16_t length;
> -    uint8_t  type;
> -    uint8_t  flags;
> -    uint16_t _reserved;
> +	uint16_t length;
> +	uint8_t  type;
> +	uint8_t  flags;
> +	uint16_t _reserved;
>  } __attribute__((packed)) EventBufferHeader;
>  
>  typedef struct WriteEventData {
> -    SCCBHeader h;
> -    EventBufferHeader ebh;
> -    union {
> -	char data[0];
> -	struct mdb mdb;
> -    } msg;
> +	SCCBHeader h;
> +	EventBufferHeader ebh;
> +	union {
> +		char data[0];
> +		struct mdb mdb;
> +	} msg;
>  } __attribute__((packed)) WriteEventData;
>  
>  typedef struct ReadEventData {
> -    SCCBHeader h;
> -    EventBufferHeader ebh;
> -    uint32_t mask;
> +	SCCBHeader h;
> +	EventBufferHeader ebh;
> +	uint32_t mask;
>  } __attribute__((packed)) ReadEventData;
>  
>  extern char _sccb[];


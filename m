Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99EA25D67E
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 12:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730043AbgIDKkG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 06:40:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37234 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728118AbgIDKjs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Sep 2020 06:39:48 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 084AXARt022868;
        Fri, 4 Sep 2020 06:39:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=EKhnpv9wxrvOlJoMiXqzMLcXq/h+4zHfeTIHNE45mGA=;
 b=QiQz4ZsLDIxP2bBftKK+R2Z5YWH3tMqiCwzTiqPSERWZWqeoHaOeAqxEjY4bqrE7dpDv
 aRCGtphZlRABCjuyNJc1zg6xwENoSi+mekx5h4tjmWyP1Lh2AHaeoajtK7kZIUvTV8Z2
 AkUxwrqgGNzfVMX2ZRl4JHbZt9M9TjQCOLgPMopYdohVxzDRyjfs/+gRyBFYXNGvytF5
 gaE7OEiV+sbBn1JULKXgCO1vEEte81+d4j/GR83ml2CzDYrDExOvsU57jBPdqS3WZlix
 ILQzGaayGradP0a1Gnl5gnbHE8D0AWNVvXnvM3YfK7ojAiTswWUifQgpjobcJMpMkO72 HA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33bj4n3ba0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Sep 2020 06:39:47 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 084AXJWY023772;
        Fri, 4 Sep 2020 06:39:46 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33bj4n3b8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Sep 2020 06:39:46 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 084AXTUs016433;
        Fri, 4 Sep 2020 10:39:44 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 33b8s60h38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Sep 2020 10:39:44 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 084Adf8O20251080
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Sep 2020 10:39:41 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B180CA4062;
        Fri,  4 Sep 2020 10:39:41 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6111AA406B;
        Fri,  4 Sep 2020 10:39:41 +0000 (GMT)
Received: from osiris (unknown [9.171.25.186])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  4 Sep 2020 10:39:41 +0000 (GMT)
Date:   Fri, 4 Sep 2020 12:39:39 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        gor@linux.ibm.com, imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        david@redhat.com
Subject: Re: [PATCH 1/2] s390x: uv: Add destroy page call
Message-ID: <20200904103939.GE6075@osiris>
References: <20200903131435.2535-1-frankja@linux.ibm.com>
 <20200903131435.2535-2-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903131435.2535-2-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-04_05:2020-09-04,2020-09-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 adultscore=0 clxscore=1015 phishscore=0 mlxlogscore=999
 suspectscore=1 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009040097
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 03, 2020 at 09:14:34AM -0400, Janosch Frank wrote:
> +int uv_destroy_page(unsigned long paddr)
> +{
> +	struct uv_cb_cfs uvcb = {
> +		.header.cmd = UVC_CMD_DESTR_SEC_STOR,
> +		.header.len = sizeof(uvcb),
> +		.paddr = paddr
> +	};
> +
> +	if (uv_call(0, (u64)&uvcb))
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +
>  /*
>   * Requests the Ultravisor to encrypt a guest page and make it
>   * accessible to the host for paging (export).
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index 373542ca1113..cfb0017f33a7 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -2679,7 +2679,7 @@ static int __s390_reset_acc(pte_t *ptep, unsigned long addr,
>  	pte_t pte = READ_ONCE(*ptep);
>  
>  	if (pte_present(pte))
> -		WARN_ON_ONCE(uv_convert_from_secure(pte_val(pte) & PAGE_MASK));
> +		WARN_ON_ONCE(uv_destroy_page(pte_val(pte) & PAGE_MASK));

Why not put the WARN_ON_ONCE() into uv_destroy_page() and make that
function return void?

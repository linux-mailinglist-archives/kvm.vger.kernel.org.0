Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF634845EF
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 17:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235275AbiADQW5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 11:22:57 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59940 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230389AbiADQW4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Jan 2022 11:22:56 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 204FMt1K001843;
        Tue, 4 Jan 2022 16:22:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : reply-to : subject : to : cc : references : from :
 in-reply-to : content-type : content-transfer-encoding; s=pp1;
 bh=Ql8RA90aOTIqFTbRlZizKwaJjGs9gw0ddh+sGz09gEM=;
 b=jNqjHYUz74Zgio1A09PcACQwMkk5Cf6CNDbusML+yvLM9/feok0glGQ3CVkk3zrx32Qh
 nkkT3RPzW67mh3ICxOPa8rv5MyZGGqLRPKSYJ0+deW5d2nUquRPXokiUUGKAcLZjMVU8
 sdqE0x+FG8MUfIWY6MvWp6fIU+wdY/zdsLF64htP2WszoAborrZ0qdQXcPv7AqFOkBA8
 0vNIL83yB5wuY0nrooC9Mn1rI6Jj46jBD2sR6NiIePb8Sta5efsjxtHlhWuGE4eKKfMn
 RcNpNfXJocdiFIFKeywGT/fu2jT2pQtsaic6+eTBFniof1ViKMJ6VJ1+xVB9d0OakRAk sA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dcpk9c2c1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Jan 2022 16:22:53 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 204Fbbln011883;
        Tue, 4 Jan 2022 16:22:53 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dcpk9c2bs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Jan 2022 16:22:53 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 204GMpRk025469;
        Tue, 4 Jan 2022 16:22:52 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01wdc.us.ibm.com with ESMTP id 3daekae918-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Jan 2022 16:22:52 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 204GMpV519595684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Jan 2022 16:22:51 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9274DB2065;
        Tue,  4 Jan 2022 16:22:51 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB06BB2068;
        Tue,  4 Jan 2022 16:22:50 +0000 (GMT)
Received: from [9.160.188.198] (unknown [9.160.188.198])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  4 Jan 2022 16:22:50 +0000 (GMT)
Message-ID: <47dc7326-b802-6023-6144-7bf4309756b4@linux.ibm.com>
Date:   Tue, 4 Jan 2022 11:22:50 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Reply-To: jjherne@linux.ibm.com
Subject: Re: [PATCH v17 01/15] s390/vfio-ap: Set pqap hook when vfio_ap module
 is loaded
Content-Language: en-US
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
 <20211021152332.70455-2-akrowiak@linux.ibm.com>
From:   "Jason J. Herne" <jjherne@linux.ibm.com>
Organization: IBM
In-Reply-To: <20211021152332.70455-2-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _ru8ZU_yxg5p2cCjNyADkuM8aPpUJfXD
X-Proofpoint-ORIG-GUID: zuut13pR7E_ACVYIS7lYugj4En_nkP1F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-04_07,2022-01-04_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 spamscore=0 impostorscore=0 adultscore=0 mlxscore=0 clxscore=1011
 malwarescore=0 suspectscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201040108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/21/21 11:23, Tony Krowiak wrote:

> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index a604d51acfc8..05569d077d7f 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -799,16 +799,17 @@ struct kvm_s390_cpu_model {
>   	unsigned short ibc;
>   };
>   
> -typedef int (*crypto_hook)(struct kvm_vcpu *vcpu);
> +struct kvm_s390_crypto_hook {
> +	int (*fcn)(struct kvm_vcpu *vcpu);
> +};

Why are we storing a single function pointer inside a struct? Seems simpler to just use a 
function pointer. What was the problem with the typedef that you are replacing?

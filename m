Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441D34920D5
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 09:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343833AbiARICh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 03:02:37 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46406 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245613AbiARICg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 03:02:36 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20I7MMcl032049;
        Tue, 18 Jan 2022 08:02:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=10se6Aqvbfw0sDkV4IUfil+TrlNUWAPPd2ya6I0SG4Y=;
 b=PduyMxBt1pb9mBf41E33RgbQi60s3lBKKbrSG0soc1yMRfvzX9AuR9iYCP3+n2RCmsY9
 TOcYRwyWXJtf+EETPHhZpaGyWdb+iRGFjfCUhAX4Cu58D0ovIjmgfPBq76nhj1KHJQDO
 lwYCPlwUJ/Xiv8K/T5yzSv00BcYNjWaUrBZJRuHaFbkuaNxG5A0Qxn3v08q+zDZK7zfx
 MedUvgSZ6wGus8CZW1Lkibac88YARsJ8y9o48q3hdjUxh3xVYIFaxA5A2bQ7o9quz/zU
 Dqs9rPEJhR8CzvPvAw6pCBYYL0epFxn/s3k91+1Ve1JZIbdDn316RYlnEqQilpg8IFCE nA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnf304hjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 08:02:30 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20I7vkTS027517;
        Tue, 18 Jan 2022 08:02:29 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnf304hjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 08:02:29 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20I7vKpM002736;
        Tue, 18 Jan 2022 08:02:28 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3dknw98pbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 08:02:27 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20I7r9FC28770660
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 07:53:09 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BFCF4204C;
        Tue, 18 Jan 2022 08:02:25 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E80C342054;
        Tue, 18 Jan 2022 08:02:24 +0000 (GMT)
Received: from [9.171.87.85] (unknown [9.171.87.85])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 08:02:24 +0000 (GMT)
Message-ID: <2f11f3c7-a940-013d-31df-9fbaf230308a@linux.ibm.com>
Date:   Tue, 18 Jan 2022 09:02:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] kvm: selftests: conditionally build vm_xsave_req_perm()
Content-Language: en-US
To:     Wei Wang <wei.w.wang@intel.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, guang.zeng@intel.com,
        jing2.liu@intel.com, yang.zhong@intel.com, tglx@linutronix.de,
        kevin.tian@intel.com
References: <20220118014817.30910-1-wei.w.wang@intel.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <20220118014817.30910-1-wei.w.wang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PcW4MYRptHQPPMmPV8CzlLxcoYCQvY-l
X-Proofpoint-ORIG-GUID: DBoadfJXjfmwZik9o2em3yG6Y7IG2Xza
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_01,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 mlxlogscore=999 suspectscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180048
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/18/22 02:48, Wei Wang wrote:
> vm_xsave_req_perm() is currently defined and used by x86_64 only.
> Make it compiled into vm_create_with_vcpus() only when on x86_64
> machines. Otherwise, it would cause linkage errors, e.g. on s390x.
> 
> Fixes: 415a3c33e8 ("kvm: selftests: Add support for KVM_CAP_XSAVE2")
> Reported-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> ---

[...]

Tested-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

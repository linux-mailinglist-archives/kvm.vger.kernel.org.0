Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57EA445693
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 16:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbhKDPxP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 11:53:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57686 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231526AbhKDPxO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Nov 2021 11:53:14 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4ElRta038690;
        Thu, 4 Nov 2021 15:50:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=x0KUkG6BcdlagTXstLcAl3xTTJoNQ1kCQFucy1bxlGE=;
 b=PRJcdujkNXB4Inohk05l9D001lE34tjMwVYsS/as5TxODTnyK/f3TDNtmBu1s+Hgp7A2
 hFZGpO5jy9P1QYRfwbkuTCCUrq3E2OYIFuDYHk/8KzIruBYYB6JCoyEGgO+XGNsuwWNd
 V376HmfrjhMjspOn7Ot7z7nfYFYjVHMNxCMOjeFgWAisCPhIKDLU73SjWorxKRlGCB8G
 vANxQMo3+d2o47C/QblFfbUg2mj0opIRzj1UpWc/iuFdKj6H9IJ5GZrb8dKZLMjGjrDI
 Zt+FnzEUyv4sAENmHWYSH5A3jj0EVTJhmRYF40+RrQG6zVal9HcM0NTbcPYrNiEP1E8n yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c4hke1dkm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Nov 2021 15:50:34 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A4EmBZ6002377;
        Thu, 4 Nov 2021 15:50:33 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c4hke1dju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Nov 2021 15:50:33 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A4FWO7Z030336;
        Thu, 4 Nov 2021 15:50:32 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 3c0wpcm0fv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Nov 2021 15:50:32 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A4FoVOg22479252
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Nov 2021 15:50:31 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F103B6E054;
        Thu,  4 Nov 2021 15:50:30 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86E8F6E058;
        Thu,  4 Nov 2021 15:50:28 +0000 (GMT)
Received: from cpe-172-100-181-211.stny.res.rr.com (unknown [9.160.110.109])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  4 Nov 2021 15:50:28 +0000 (GMT)
Subject: Re: [PATCH v17 14/15] s390/ap: notify drivers on config changed and
 scan complete callbacks
To:     Harald Freudenberger <freude@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
 <20211021152332.70455-15-akrowiak@linux.ibm.com>
 <11b72236-34fe-4d65-0da1-033050c75a87@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <77a4b43b-940e-0321-9ebf-3249a8d8513a@linux.ibm.com>
Date:   Thu, 4 Nov 2021 11:50:26 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <11b72236-34fe-4d65-0da1-033050c75a87@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fssJIPGgbUAiG7Ev8jZxHKGf-HSvAkJO
X-Proofpoint-ORIG-GUID: uUj2cZqf8EMAe-3rXiaKhSBi1XuYfvos
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-04_04,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 adultscore=0 spamscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111040058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/4/21 8:06 AM, Harald Freudenberger wrote:
>
> Tony as this is v17, if you may do jet another loop, I would pick the ap parts of your patch series and
> apply them to the devel branch as separate patches.

Are you suggesting I do this now, or when this is finally ready to go 
upstream?



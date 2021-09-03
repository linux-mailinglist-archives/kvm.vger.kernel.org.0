Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 163674006B5
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 22:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236039AbhICUiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 16:38:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2954 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233044AbhICUiA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 16:38:00 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 183KXUlu151746;
        Fri, 3 Sep 2021 16:36:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=SHCF9kaKpBdG1ELzfbO6UQiT/emEledCkG3c7e0G4yA=;
 b=UBGc+gdMga2Q3xBg5eho0So7JJ0/JxpBBNbwY93RJQWQ0u91AvgQgFS1ilpqsB6DJh2b
 /tVtEEYb2BnL7VdGIuApKnulNqXbQ8M1Z4XRXpANUQt3IbDSL1ILdID9gtK7XM3bYVaI
 6zz1V4ReAXpZXQpOfGnibjhw80DhpPEZZbg9tXILeWY3Odt9Mb+0BCM0Vnt0hcsbCNGR
 gmARt8Shrios9Jmiu8kd56je8B0t0y/mZiVerT3xGnX2UxfwsntSiX4JCyGRgDRLjBrV
 qAbPRmoPNKY1WE+S0XlUKxzL6KXw79i1JpdSj0sVPt8awbmIX5RwaA3az3COpX0bnN7X MA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3autt1g2q3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Sep 2021 16:36:52 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 183KapER167337;
        Fri, 3 Sep 2021 16:36:51 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3autt1g2px-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Sep 2021 16:36:51 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 183KYUBZ030503;
        Fri, 3 Sep 2021 20:36:51 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03dal.us.ibm.com with ESMTP id 3au6pn3dsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Sep 2021 20:36:51 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 183Kan7Y16122318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Sep 2021 20:36:49 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE363C6055;
        Fri,  3 Sep 2021 20:36:49 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F10A3C6057;
        Fri,  3 Sep 2021 20:36:45 +0000 (GMT)
Received: from [9.65.84.185] (unknown [9.65.84.185])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  3 Sep 2021 20:36:45 +0000 (GMT)
Subject: Re: [RFC PATCH v2 02/12] linux-header: add the SNP specific command
To:     Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org
Cc:     Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
 <20210826222627.3556-3-michael.roth@amd.com>
From:   Dov Murik <dovmurik@linux.ibm.com>
Message-ID: <b398a4b5-cd8a-c6e8-d30a-ddac3de97393@linux.ibm.com>
Date:   Fri, 3 Sep 2021 23:36:43 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210826222627.3556-3-michael.roth@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mv4rXzHxpvVj471UBfqO_ZHKG3nWjqcU
X-Proofpoint-ORIG-GUID: MLxWan5IU_6v2k7l-dB3QGyGuhRuQo2E
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-03_07:2021-09-03,2021-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 clxscore=1015 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109030119
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Michael,

On 27/08/2021 1:26, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Sync the kvm.h with the kernel to include the SNP specific commands.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  linux-headers/linux/kvm.h | 50 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
> 

In previous review round I commented:

------
What about psp-sev.h ? I see that kernel patch "[PATCH Part2 RFC v4
11/40] crypto:ccp: Define the SEV-SNP commands" adds some new PSP return
codes.

The QEMU user-friendly string list sev_fw_errlist (in sev.c) should be
updated accordingly.
-------


-Dov

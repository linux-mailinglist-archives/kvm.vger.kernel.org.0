Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9AA25F560B
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 16:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiJEOBX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 10:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiJEOBU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 10:01:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DEF7C1F4;
        Wed,  5 Oct 2022 07:01:18 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 295DQnS9018646;
        Wed, 5 Oct 2022 14:01:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+IGTMgJ8jy5rhbEwRiRd7lOakt7+3P2DK0dHbNVtI/A=;
 b=QEHK59NlK4lDpXQS9N7y8VAhmyrNj36Zi4hSLCenl5Do17zFZwuNOlYTSHguIiiK8MTS
 nceM+qjCU8P7v5E5NZ2PhCnjqaYozQKBJKQWJGC/EGtFZnR7VHw4SRTx2on1Z5VIhMti
 Um+Bbg7gnqYXeaV8EM3+lJnDq2IIV+ZwuHBMpSPwr+DtW/6EcxMsGDit7qiLxJXx0SfE
 oWP1SNWWKbBi4rBze82GMkzjV3tFFe+KtdVf+R/QeEQQ+rbGHZEQvNaFrJu7cbvgFMCe
 DsDaj4B7gXT/EXyHqHzldQom0ZuCBOMlITxECyVrwFx1cgBy/gF6mdFN3rdsXl5ES6uI AQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k1atnh8ka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Oct 2022 14:01:12 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 295DSs16031638;
        Wed, 5 Oct 2022 14:01:11 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k1atnh8jc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Oct 2022 14:01:11 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 295Dpkg8016825;
        Wed, 5 Oct 2022 14:01:11 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02dal.us.ibm.com with ESMTP id 3jxd6aatyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Oct 2022 14:01:10 +0000
Received: from smtpav02.wdc07v.mail.ibm.com ([9.208.128.114])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 295E19OE65274160
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Oct 2022 14:01:09 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6DB558067;
        Wed,  5 Oct 2022 14:01:08 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E0E35805E;
        Wed,  5 Oct 2022 14:01:07 +0000 (GMT)
Received: from [9.160.167.172] (unknown [9.160.167.172])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  5 Oct 2022 14:01:07 +0000 (GMT)
Message-ID: <27b53ed5-62dd-fcc1-948f-e9837f31f3c1@linux.ibm.com>
Date:   Wed, 5 Oct 2022 10:01:06 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2] vfio: Follow a strict lifetime for struct iommu_group
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        "Jason J . Herne" <jjherne@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <0-v2-a3c5f4429e2a+55-iommu_group_lifetime_jgg@nvidia.com>
 <4cb6e49e-554e-57b3-e2d3-bc911d99083f@linux.ibm.com>
 <20220927140541.6f727b01.alex.williamson@redhat.com>
 <52545d8b-956b-8934-8a7e-212729ea2855@linux.ibm.com>
 <YzxT6Suu+272gDvP@nvidia.com>
 <1aebfa84-8310-5dff-1862-3d143878d9dd@linux.ibm.com>
 <YzxfK/e14Bx9yNyo@nvidia.com>
 <0a0d7937-316a-a0e2-9d7d-df8f3f8a38e3@linux.ibm.com>
 <33bc5258-5c95-99ee-a952-5b0b2826da3a@linux.ibm.com>
 <8982bc22-9afa-dde4-9f4e-38948db58789@linux.ibm.com>
 <Yz2NSDa3E6LpW1c5@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <Yz2NSDa3E6LpW1c5@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mvimmrzMixwmx53k9BnT6F-4Z0hL_PKa
X-Proofpoint-GUID: pTAff7UkESRxs0eRVhRuR-J2X1HEAshS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-05_03,2022-10-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 bulkscore=0 clxscore=1015 mlxlogscore=781 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210050088
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/5/22 9:57 AM, Jason Gunthorpe wrote:
> On Wed, Oct 05, 2022 at 09:46:45AM -0400, Matthew Rosato wrote:
> 
>  
>> (again, with the follow-up applied) Besides the panic above I just
>> noticed there is also this warning that immediately precedes and is
>> perhaps more useful.  Re: what triggers the WARN, both group->owner
>> and group->owner_cnt are already 0
> 
> And this is after the 2nd try that fixes the locking?

Maybe I missed that email?  I've only seen one version, happy to try another.  Please resend?

> 
> This shows that vfio_group_detach_container() is called twice (which
> was my guess), hoever this looks to be impossible as both calls are
> protected by 'if (group->container)' and the function NULL's
> group->container and it is all under the proper lock.
> 
> My guess was that missing locking caused the two cases to race and
> trigger WARN, but the locking should fix that.
> 
> So I'm at a loss, can you investigate a bit?
> 
> Jason


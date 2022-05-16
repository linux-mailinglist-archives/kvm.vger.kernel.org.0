Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8C3529341
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 23:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349502AbiEPV7N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 17:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238657AbiEPV7K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 17:59:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EF846150;
        Mon, 16 May 2022 14:59:09 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GLi0V1019350;
        Mon, 16 May 2022 21:59:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=JnK/MfOUk7bOHMz+YFhvU/1hnQiz5Cgwb3eibBD0jTc=;
 b=dTvcd0mq9jolvsc0zQ6S6L6UKgdXW2NaxSNlsq9cdJQKR+EO0tD3KDIDnSt6NAn5hknN
 59VCPaBkXqXLZS45ddKvmnT70rT7hs2wYeX1I7l9XLEu/oIRkL4bDf03yc7de4LCQAv3
 cBiau468/tHkDPV++Pb6rVlxKcKwPSnyH7c7/JHptSwcnebHRX0xAzQr+YcCZyuFsAxq
 hp8M+EcoB8BDjiDGhEVmGAjG8w/Grl/G3Y3hCbwiKB0K1rCoQfyrn0kg9kkMsq4XY1jH
 8Qlox0PtwTJpiQra8dlZFT7scu5aFq/Hbaoba0q9a+Vc/GOcuRaQls+LcuZvLtzf4ovc vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3xsn86c8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 21:59:07 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24GLtsKb023222;
        Mon, 16 May 2022 21:59:07 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3xsn86c2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 21:59:06 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24GLqWsC030888;
        Mon, 16 May 2022 21:59:06 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01dal.us.ibm.com with ESMTP id 3g242aw8m3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 21:59:05 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24GLx4YH31523300
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 21:59:04 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 607D1BE053;
        Mon, 16 May 2022 21:59:04 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55AF8BE051;
        Mon, 16 May 2022 21:59:02 +0000 (GMT)
Received: from [9.211.37.97] (unknown [9.211.37.97])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 21:59:02 +0000 (GMT)
Message-ID: <305208c4-db8a-5751-2ffc-753751a70815@linux.ibm.com>
Date:   Mon, 16 May 2022 17:59:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v7 17/22] vfio-pci/zdev: add open/close device hooks
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     alex.williamson@redhat.com, linux-s390@vger.kernel.org,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220513191509.272897-1-mjrosato@linux.ibm.com>
 <20220513191509.272897-18-mjrosato@linux.ibm.com>
 <20220516172734.GE1343366@nvidia.com>
 <7a31ec36-ceaf-dcef-8bd0-2b4732050aed@linux.ibm.com>
 <20220516183558.GN1343366@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220516183558.GN1343366@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 30vzLlm2jfEQCdAcYolnWjE_hD2_ye-R
X-Proofpoint-ORIG-GUID: fIATfKPX76OaK45AxglriohR6Kt7GXwL
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_15,2022-05-16_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 impostorscore=0
 mlxlogscore=864 suspectscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2205160121
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/16/22 2:35 PM, Jason Gunthorpe wrote:
> On Mon, May 16, 2022 at 02:30:46PM -0400, Matthew Rosato wrote:
> 
>> Conceptually I think this would work for QEMU anyway (it always sets the kvm
>> before we open the device).  I tried to test the idea quickly but couldn't
>> get the following to apply on vfio-next or your vfio_group_locking -- but I
>> understand what you're trying to do so I'll re-work and try it out.
> 
> I created it on 8c9350e9bf43de1ebab3cc8a80703671e6495ab4 which is the
> vfio_group_locking.. I can send you a github if it helps
> https://github.com/jgunthorpe/linux/commits/vfio_group_lockin
> 
Thanks -- I was able to successfully test your proposed idea (+ some 
changes to make it compile :)) on top of vfio_group_locking along with a 
modified version of my zdev series.  I also tried it out with vfio-ap 
successfully, but have nothing to test GVT with.

That said, this has caused me to realize that 'iommu: 
iommu_group_claim_dma_owner() must always assign a domain' breaks s390x 
vfio-pci :( I wonder if it is due to the way s390x PCI currently 
switches between dma ops and iommu ops.  It looks like it breaks vfio-ap 
mdevs too, but I know less about that --  I will have to investigate 
both more tomorrow.

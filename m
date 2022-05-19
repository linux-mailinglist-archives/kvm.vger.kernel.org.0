Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D25F752DCD7
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 20:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243959AbiESSal (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 14:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243952AbiESSah (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 14:30:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACBE8EBE86;
        Thu, 19 May 2022 11:30:36 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24JHUXuZ023718;
        Thu, 19 May 2022 18:30:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=LcS2r++TsW+vpe9fwQY3x789QIPynw1iDTlAkCOTmB0=;
 b=IsTvY1G4oBnTKZ8RY8YqDuKO4DcqdEYKC3iYRsI92l0c/51mv/7/r63tHddEpTJjsuIb
 pT2kTggZnsivl6yCoI+OB6fTA7bW4endFl2POqermtrRLQnZ2QhUW+tf+Dp1hlP6zrRM
 6D6bLDzer8OzmennKayNwAcwjmsjdBI9O58O6kCxaZl72sHJKAaEsEejRmObOTJaGOCz
 6Lg4UjW3520kQiwW2C/KZPt1vYdABfvrOBYpHKhrw/ojiXAmMZcXytkFkfGnaDchoaVX
 Z2gZTFFJiXZD8vMFL8vqV4/w9bA1FaTWpc1RivQ4hAZcCbVyDaigGk62g8hHlfX5gArO Mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g5tbws6ug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 18:30:29 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24JIN4sk003354;
        Thu, 19 May 2022 18:30:28 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g5tbws6u5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 18:30:28 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24JISem1024369;
        Thu, 19 May 2022 18:30:27 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02dal.us.ibm.com with ESMTP id 3g242axyfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 18:30:27 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24JIUQAG63439192
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 18:30:26 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CBA73124052;
        Thu, 19 May 2022 18:30:26 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4615712405A;
        Thu, 19 May 2022 18:30:24 +0000 (GMT)
Received: from [9.211.37.97] (unknown [9.211.37.97])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 19 May 2022 18:30:24 +0000 (GMT)
Message-ID: <c9b89cd9-081b-6f35-7076-02c20e26e172@linux.ibm.com>
Date:   Thu, 19 May 2022 14:30:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] iommu/s390: tolerate repeat attach_dev calls
Content-Language: en-US
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     jgg@nvidia.com, joro@8bytes.org, alex.williamson@redhat.com
Cc:     will@kernel.org, cohuck@redhat.com, borntraeger@linux.ibm.com,
        schnelle@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        farman@linux.ibm.com, iommu@lists.linux-foundation.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220519182929.581898-1-mjrosato@linux.ibm.com>
In-Reply-To: <20220519182929.581898-1-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VVke5jIjT5Yhmg5xSK9NLVrRwPSeCoe9
X-Proofpoint-GUID: pljNt4nS3bHJXYoAG5Dlj8VD8b-QzrdE
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-19_05,2022-05-19_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 spamscore=0 clxscore=1015 bulkscore=0
 mlxscore=0 adultscore=0 mlxlogscore=864 impostorscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205190103
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/19/22 2:29 PM, Matthew Rosato wrote:
> Since commit 0286300e6045 ("iommu: iommu_group_claim_dma_owner() must
> always assign a domain") s390-iommu will get called to allocate multiple
> unmanaged iommu domains for a vfio-pci device -- however the current
> s390-iommu logic tolerates only one.  Recognize that multiple domains can
> be allocated and handle switching between DMA or different iommu domain
> tables during attach_dev.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---

Tested in conjuction with

https://lore.kernel.org/kvm/0-v1-9cfc47edbcd4+13546-vfio_dma_owner_fix_jgg@nvidia.com/

Along with that patch, vfio{-pci,-ap,-ccw} on s390x for -next seem happy 
again.


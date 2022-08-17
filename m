Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A763596A08
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 09:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238760AbiHQHFg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 03:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238755AbiHQHF2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 03:05:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9072E558E2;
        Wed, 17 Aug 2022 00:05:27 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27H5jMYg014793;
        Wed, 17 Aug 2022 07:05:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Fvrph7+fB7+8f66rcFNwOv+0RLU9j/hSNnlVTriy0n0=;
 b=bmSig+R5JO9Ok76srObyO5PwtjWkEDYQI5oIA4nwABUwYQ3DcK1a7MefsiUj0C4KJlhF
 gx95qMPiGzuC7/abTsg90/IMSKHgCFXDDFvwTHpFZITvzmMPdxIgelKObID4qpUlARzT
 k+D6z3sm2rk3XAR+9jAdzRAI0t8eTOeC7zoPBKZyL0od+f/PBr1c9NJA9LQK8rjqhHe+
 tr4TjbKIHxMsxA+ApcwIrfztVBcxDISqxmEGYiyVFNAq2zC2w/DmpXMDYeyIIqeo6Fq1
 AliY+OxQVCCGoymKQjd0hsDxeeiujYGGsRtqhHVnKnsMxt1t0IAICi/5XPdwIkCPNvkz EA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j0tfbsw8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Aug 2022 07:05:15 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27H6oJTE011995;
        Wed, 17 Aug 2022 07:05:13 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3hx3k8v411-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Aug 2022 07:05:13 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27H759Gc30540116
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Aug 2022 07:05:09 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE6C4A4059;
        Wed, 17 Aug 2022 07:05:09 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65DB2A4051;
        Wed, 17 Aug 2022 07:05:09 +0000 (GMT)
Received: from [9.171.94.247] (unknown [9.171.94.247])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 17 Aug 2022 07:05:09 +0000 (GMT)
Message-ID: <c7a094e9-7c36-a21d-8f7a-82a8b94f8044@linux.ibm.com>
Date:   Wed, 17 Aug 2022 09:10:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] KVM: s390: pci: VFIO_PCI ZDEV configuration fix
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     rdunlap@infradead.org, linux-kernel@vger.kernel.org, lkp@intel.com,
        borntraeger@linux.ibm.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <1f2dd65e-b79b-44df-cc6a-8b3aa8fd61af@linux.ibm.com>
 <20220816202855.189410-1-pmorel@linux.ibm.com>
 <b03be97f-cc03-cb58-bd1b-5eda3abd249a@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <b03be97f-cc03-cb58-bd1b-5eda3abd249a@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WvAS6J0p17BK9pRr6TBJpNge8JPYMzzS
X-Proofpoint-GUID: WvAS6J0p17BK9pRr6TBJpNge8JPYMzzS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-17_04,2022-08-16_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=899 spamscore=0
 clxscore=1015 phishscore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208170029
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/17/22 00:15, Matthew Rosato wrote:
> On 8/16/22 4:28 PM, Pierre Morel wrote:
>> Fixing configuration for VFIO PCI interpretation.
>>

> 4)
> CONFIG_KVM=m
> CONFIG_VFIO_PCI_CORE=y
> CONFIG_VFIO_PCI=y
> CONFIG_VFIO_PCI_ZDEV_KVM=m
> 
> fails with:
> 
> ld: drivers/vfio/pci/vfio_pci_core.o: in function `vfio_pci_core_enable':
> /usr/src/linux/drivers/vfio/pci/vfio_pci_core.c:320: undefined reference to `vfio_pci_zdev_open_device'
> ld: /usr/src/linux/drivers/vfio/pci/vfio_pci_core.c:349: undefined reference to `vfio_pci_zdev_close_device'
> ld: drivers/vfio/pci/vfio_pci_core.o: in function `vfio_pci_core_disable':
> /usr/src/linux/drivers/vfio/pci/vfio_pci_core.c:428: undefined reference to `vfio_pci_zdev_close_device'
> ld: drivers/vfio/pci/vfio_pci_core.o: in function `vfio_pci_core_ioctl':
> /usr/src/linux/drivers/vfio/pci/vfio_pci_core.c:712: undefined reference to `vfio_pci_info_zdev_add_caps'
> 
> 
> 5)
> CONFIG_KVM=m
> CONFIG_VFIO_PCI_CORE=y
> CONFIG_VFIO_PCI=y
> CONFIG_VFIO_PCI_ZDEV_KVM=y
> 
> This forces CONFIG_VFIO_PCI_ZDEV_KVM to 'm' and fails as above.
> 
> 
> 

yes right
I was really too stupid yesterday
I think you are right and you should go as you proposed or use some 
pointer hook inside S390 to register with KVM.

-- 
Pierre Morel
IBM Lab Boeblingen

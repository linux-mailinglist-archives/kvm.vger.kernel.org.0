Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60124D8D76
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244483AbiCNTys (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239865AbiCNTyn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:54:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C252BDC;
        Mon, 14 Mar 2022 12:53:17 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22EJlVow009230;
        Mon, 14 Mar 2022 19:52:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Nz145SLyNi28nDypmA/G+HJQLmQB+0wmYqr6hIhwoeo=;
 b=Xl6RztJu3Wk/XCcQ9rhrBfHBcvmqiy4Txi/m07WzBWDFp4/Q4klXql9AxKZf+4cdw0v+
 gzsB6DpqGCNPmmOtoR5MfqD8wHtqHsXqMUP8O68pq0gh6ClXPIHVJ4JwoWN5/onN2F3G
 zdscp8TsabO9vPRZ8ZYbwibj6YuQBSvsnYwif4GYS13jexouscyAJB/YBrjvaqJURvVO
 Usx3zOJoPm0e7gG/mtEqZmvM2wpnkTdaNAwTPgkNFLR8i2OiJkx1IpOF/LPJkQkWi4aU
 E/RkK2PsXPERG4ZWUzxVoi/H36SCNJQSyUaA8QkungXdE0Rut5xFXeNqVfrSq3OjhBSW FQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6mer52x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:52:45 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22EJlocI010076;
        Mon, 14 Mar 2022 19:52:44 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6mer52m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:52:44 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22EJl9Jg010220;
        Mon, 14 Mar 2022 19:52:43 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma05wdc.us.ibm.com with ESMTP id 3erk59rb4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:52:43 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22EJqfYf28443130
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 19:52:41 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B87A46E053;
        Mon, 14 Mar 2022 19:52:41 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0CA76E050;
        Mon, 14 Mar 2022 19:52:38 +0000 (GMT)
Received: from [9.211.32.184] (unknown [9.211.32.184])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 14 Mar 2022 19:52:38 +0000 (GMT)
Message-ID: <681190b6-487f-ca4a-ba67-0ade2b20501b@linux.ibm.com>
Date:   Mon, 14 Mar 2022 15:52:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v4 00/32] KVM: s390: enable zPCI for interpretive
 execution
Content-Language: en-US
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, joro@8bytes.org, will@kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, jgg@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-doc@vger.kernel.org
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
In-Reply-To: <20220314194451.58266-1-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 21ijjdY1juiR5jFmwFjvzgJY7ymU_E62
X-Proofpoint-ORIG-GUID: _BV1xKNxlXflt-dk1w49L0lWqpgQQT-R
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_13,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 mlxlogscore=593 suspectscore=0 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203140116
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/14/22 3:44 PM, Matthew Rosato wrote:
> Note: A few patches in this series are dependent on Baolu's IOMMU domain ops
> split, which is currently in the next branch of linux-iommu. This series
> applies on top:
> https://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git
> 
> Enable interpretive execution of zPCI instructions + adapter interruption
> forwarding for s390x KVM vfio-pci.  This is done by introducing a new IOMMU
> domain for s390x (KVM-managed), indicating via vfio that this IOMMU domain
> should be used instead of the default, with subsequent management of the
> hardware assists being handled via a new KVM ioctl for zPCI management.
> 
> By allowing intepretation of zPCI instructions and firmware delivery of
> interrupts to guests, we can significantly reduce the frequency of guest
> SIE exits for zPCI.  We then see additional gains by handling a hot-path
> instruction that can still intercept to the hypervisor (RPCIT) directly
> in kvm via the new IOMMU domain, whose map operations update the host
> DMA table with pinned guest entries over the specified range.
> 
>  From the perspective of guest configuration, you passthrough zPCI devices
> in the same manner as before, with intepretation support being used by
> default if available in kernel+qemu.
> 
> Will reply with a link to the associated QEMU series.

QEMU series:
https://lore.kernel.org/kvm/20220314194920.58888-1-mjrosato@linux.ibm.com/


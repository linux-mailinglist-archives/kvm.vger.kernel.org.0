Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BADF34D9C9B
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 14:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348812AbiCONup (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 09:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244349AbiCONuo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 09:50:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4931C3136D;
        Tue, 15 Mar 2022 06:49:32 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22FDca95012141;
        Tue, 15 Mar 2022 13:49:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TxfgcTKc07nlrXFUhSC30L72jD1k5H4V5HcijoyEaSc=;
 b=fpUVMqS0JTWVhHylY9Yere5Ajpkei7TOhIYmdc9V/mvb2xaNyLReQGa61qsTXj4/zE40
 X9aEwzKYSahadMxlZsbrAjXwfHnH/7XmXK83a6wc8VgHFTMeFsve/RutpSEM4pWt8TMh
 Vi/kYxPwyLn2aXJqxkoKz4Nz5cNbzl10Ng6PFgbcjePCiYEKKG5wVFTuawqcxbuG+YHI
 CGqN90o81G5MPY7WZZ8SMQGSoMRpCmC90gBI73rrNZWsUkGjwbiNr3afxvTBPrSIdUVe
 fACxOREUa1yyNcTLdgCX2ChanlDyv+sW4RulYVyAFFfUHqQHmxvF95SUoxvJv23vDuMO kQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etscykwpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 13:49:19 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22FCuwWs018942;
        Tue, 15 Mar 2022 13:49:19 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etscykwnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 13:49:19 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22FDnCZr017782;
        Tue, 15 Mar 2022 13:49:17 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01dal.us.ibm.com with ESMTP id 3erk59jxnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 13:49:17 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22FDnFA341681242
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 13:49:15 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B32F8AC062;
        Tue, 15 Mar 2022 13:49:15 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A17FBAC05E;
        Tue, 15 Mar 2022 13:49:03 +0000 (GMT)
Received: from [9.211.32.184] (unknown [9.211.32.184])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 15 Mar 2022 13:49:03 +0000 (GMT)
Message-ID: <decc5320-eb3e-af25-fd2b-77fabe56a897@linux.ibm.com>
Date:   Tue, 15 Mar 2022 09:49:01 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v4 15/32] vfio: introduce KVM-owned IOMMU type
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-s390@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, joro@8bytes.org, will@kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-doc@vger.kernel.org
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
 <20220314194451.58266-16-mjrosato@linux.ibm.com>
 <20220314213808.GI11336@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220314213808.GI11336@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -HG82bqFxwKpGAenjEvaj6JEYqh38rKE
X-Proofpoint-ORIG-GUID: NOD6qgg6fWSwIgyRDPz07n5dLRz0WJeN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_03,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 impostorscore=0 mlxlogscore=999 mlxscore=0 clxscore=1015
 spamscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150089
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/14/22 5:38 PM, Jason Gunthorpe wrote:
> On Mon, Mar 14, 2022 at 03:44:34PM -0400, Matthew Rosato wrote:
> 
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 9394aa9444c1..0bec97077d61 100644
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -77,6 +77,7 @@ struct vfio_iommu {
>>   	bool			nesting;
>>   	bool			dirty_page_tracking;
>>   	bool			container_open;
>> +	bool			kvm;
>>   	struct list_head	emulated_iommu_groups;
>>   };
>>   
>> @@ -2203,7 +2204,12 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>>   		goto out_free_group;
>>   
>>   	ret = -EIO;
>> -	domain->domain = iommu_domain_alloc(bus);
>> +
>> +	if (iommu->kvm)
>> +		domain->domain = iommu_domain_alloc_type(bus, IOMMU_DOMAIN_KVM);
>> +	else
>> +		domain->domain = iommu_domain_alloc(bus);
>> +
>>   	if (!domain->domain)
>>   		goto out_free_domain;
>>   
>> @@ -2552,6 +2558,9 @@ static void *vfio_iommu_type1_open(unsigned long arg)
>>   	case VFIO_TYPE1v2_IOMMU:
>>   		iommu->v2 = true;
>>   		break;
>> +	case VFIO_KVM_IOMMU:
>> +		iommu->kvm = true;
>> +		break;
> 
> Same remark for this - but more - this is called KVM but it doesn't
> accept a kvm FD or any thing else to link the domain to the KVM
> in-use.

Right...  The name is poor, but with the current design the KVM 
association comes shortly after.  To summarize, with this series, the 
following relevant steps occur:

1) VFIO_SET_IOMMU: Indicate we wish to use the alternate IOMMU domain
	-> At this point, the IOMMU will reject any maps (no KVM, no guest 
table anchor)
2) KVM ioctl "start":
	-> Register the KVM with the IOMMU domain
	-> At this point, IOMMU will still reject any maps (no guest table anchor)
3) KVM ioctl "register ioat"
	-> Register the guest DMA table head with the IOMMU domain
	-> now IOMMU maps are allowed

The rationale for splitting steps 1 and 2 are that VFIO_SET_IOMMU 
doesn't have a mechanism for specifying more than the type as an arg, 
no?  Otherwise yes, you could specify a kvm fd at this point and it 
would have some other advantages (e.g. skip notifier).  But we still 
can't use the IOMMU for mapping until step 3.

The rationale for splitting steps 2 and 3 are twofold:  1) during init, 
we simply don't know where the guest anchor will be when we allocate the 
domain and 2) because the guest can technically clear and re-initialize 
their DMA space during the life of the guest, moving the location of the 
table anchor.  We would receive another ioctl operation to unregister 
the guest table anchor and again reject any map operation until a new 
table location is provided.


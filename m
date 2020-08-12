Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58044242E61
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 20:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgHLSEM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 14:04:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58106 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726512AbgHLSEL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Aug 2020 14:04:11 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07CI2GHJ165546;
        Wed, 12 Aug 2020 14:04:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=SRzTkpxr5LdPeSrEjmAc06YCSZqbsTO5DEVlTIu4cU0=;
 b=b4ZpXqdpAH2PFfAAoDPtHG0UcBz+cEHJ6ggcX7qzNo7jsAFL34dqGN7sb62kkEvBfJdD
 dPv4SlBxymgPimGCPt6TV92Ze9d5H/A0uSKpGpsyFToE31FoKhN5sPLwa6ECOkml1k1z
 2+358E3niYhsNS8joH4WDNO0C37ZKVtIb9K0LSLjebMIzIEDeRYzlIpCJpKwxyAgKRTi
 bFQ1nxhUW8cFoZ8dE/AjxZEJgC0Tg/I6E9JwVebdKq3kCBuXj2B7MaL0Umx2AFrfjolE
 AE6PrInBUu6QQMVs4qlYWmH/FcWOSi9lC5aUoSwPL9qgXKyPwyd4iPdXk98/8b4F7e+Y aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32v83c61ne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 14:04:07 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07CI3hY0173359;
        Wed, 12 Aug 2020 14:04:07 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32v83c61kx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 14:04:06 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07CHj3ZL001961;
        Wed, 12 Aug 2020 18:04:05 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04dal.us.ibm.com with ESMTP id 32skp9cdh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 18:04:05 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07CI406h31654290
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Aug 2020 18:04:01 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9811FC6063;
        Wed, 12 Aug 2020 18:04:03 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5054C6055;
        Wed, 12 Aug 2020 18:04:01 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.7.238])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 12 Aug 2020 18:04:01 +0000 (GMT)
Subject: Re: [PATCH] PCI: Introduce flag for detached virtual functions
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     bhelgaas@google.com, schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        mpe@ellerman.id.au, oohall@gmail.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
References: <1597243817-3468-1-git-send-email-mjrosato@linux.ibm.com>
 <1597243817-3468-2-git-send-email-mjrosato@linux.ibm.com>
 <20200812104351.3668cc0f@x1.home>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <05c46459-7d00-c01c-6387-68bc7d6c4f63@linux.ibm.com>
Date:   Wed, 12 Aug 2020 14:04:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200812104351.3668cc0f@x1.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-12_13:2020-08-11,2020-08-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 impostorscore=0 phishscore=0
 malwarescore=0 clxscore=1015 suspectscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008120114
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/12/20 12:43 PM, Alex Williamson wrote:
> On Wed, 12 Aug 2020 10:50:17 -0400
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
>> s390x has the notion of providing VFs to the kernel in a manner
>> where the associated PF is inaccessible other than via firmware.
>> These are not treated as typical VFs and access to them is emulated
>> by underlying firmware which can still access the PF.  After
>> abafbc55 however these detached VFs were no longer able to work
>> with vfio-pci as the firmware does not provide emulation of the
>> PCI_COMMAND_MEMORY bit.  In this case, let's explicitly recognize
>> these detached VFs so that vfio-pci can allow memory access to
>> them again.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
>> ---
>>   arch/s390/pci/pci.c                | 8 ++++++++
>>   drivers/vfio/pci/vfio_pci_config.c | 3 ++-
>>   include/linux/pci.h                | 1 +
>>   3 files changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
>> index 3902c9f..04ac76d 100644
>> --- a/arch/s390/pci/pci.c
>> +++ b/arch/s390/pci/pci.c
>> @@ -581,6 +581,14 @@ int pcibios_enable_device(struct pci_dev *pdev, int mask)
>>   {
>>   	struct zpci_dev *zdev = to_zpci(pdev);
>>   
>> +	/*
>> +	 * If we have a VF on a non-multifunction bus, it must be a VF that is
>> +	 * detached from its parent PF.  We rely on firmware emulation to
>> +	 * provide underlying PF details.
>> +	 */
>> +	if (zdev->vfn && !zdev->zbus->multifunction)
>> +		pdev->detached_vf = 1;
>> +
>>   	zpci_debug_init_device(zdev, dev_name(&pdev->dev));
>>   	zpci_fmb_enable_device(zdev);
>>   
>> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
>> index d98843f..17845fc 100644
>> --- a/drivers/vfio/pci/vfio_pci_config.c
>> +++ b/drivers/vfio/pci/vfio_pci_config.c
>> @@ -406,7 +406,8 @@ bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev)
>>   	 * PF SR-IOV capability, there's therefore no need to trigger
>>   	 * faults based on the virtual value.
>>   	 */
>> -	return pdev->is_virtfn || (cmd & PCI_COMMAND_MEMORY);
>> +	return pdev->is_virtfn || pdev->detached_vf ||
>> +	       (cmd & PCI_COMMAND_MEMORY);
>>   }
>>   
>>   /*
> 
> Wouldn't we also want to enable the is_virtfn related code in
> vfio_basic_config_read() and at least the initial setting of the
> command register in vfio_config_init()?  Otherwise we're extending the
> incomplete emulation out to userspace.  Thanks,
> 

We had discussed doing this internally and I ultimately left it out of 
this patch to keep the changes small...  But I agree that it makes sense 
to fix the emulation for userspace.  I can add the changes you suggest + 
would also need to change vfio_restore_bar() with:

-       if (pdev->is_virtfn)
+       if (pdev->is_virtfn || pdev->detached_vf)
                 return;

to prevent the config changes from tripping the restore code.

I'll send a V2 with this included.


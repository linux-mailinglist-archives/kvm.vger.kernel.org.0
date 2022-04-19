Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD45B5067D1
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 11:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350380AbiDSJju (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 05:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344701AbiDSJjt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 05:39:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9009F1FA78;
        Tue, 19 Apr 2022 02:37:06 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23J6v9q2027973;
        Tue, 19 Apr 2022 09:37:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kBchHFFddx0ubwxodE+mu25lyI4qY8zeK88Z1KjjO5E=;
 b=AfCcDkW6ubzEwNdUAED35Cov2h+AzCdIWLiVakm+WS5An3bnSh2JygSE82SE/3rmMAwY
 ClaY98doMiXu51R2+fOIW1uwNs3hQdNqxVjO3ukI8gztImL/rhiLW2SaSGapblqK9Woh
 AzhQmILX2Jmd3t4pCz/y1PSCZx7cjKMYFsIYZ8YUIgU3Rhb2wbMf5pnh9r7Blg1f8lag
 8KZYafCKXAEnOKGHvGPHmq7ba30S5ud74TeVLkmPzifcPDL0TTnBe6+dxoKxtCpXhHXC
 uDiPqu1ERsKbCqSZIQL2/4yKSswDjswiTDYX9dvCPQSIzk56CK1hDr5PjOirYecPCvGS 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg7ct31tb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 09:37:06 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23J96vRo003352;
        Tue, 19 Apr 2022 09:37:05 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg7ct31su-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 09:37:05 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23J9DKaF016307;
        Tue, 19 Apr 2022 09:37:03 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3fgu6u1r4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 09:37:02 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23J9axms50331922
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 09:36:59 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA8B642042;
        Tue, 19 Apr 2022 09:36:59 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CEBD42041;
        Tue, 19 Apr 2022 09:36:58 +0000 (GMT)
Received: from [9.171.88.57] (unknown [9.171.88.57])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Apr 2022 09:36:58 +0000 (GMT)
Message-ID: <b885fc5c-700a-6b5f-64ef-bf4afc8fd036@linux.ibm.com>
Date:   Tue, 19 Apr 2022 11:40:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v5 17/21] vfio-pci/zdev: add function handle to clp base
 capability
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220404174349.58530-1-mjrosato@linux.ibm.com>
 <20220404174349.58530-18-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220404174349.58530-18-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: T8WIBnjWM6MvBX3_tNqyT9jVtqXKwptw
X-Proofpoint-ORIG-GUID: 84tc4MUnk6hV2oqiXeAO9Vyy9JqnvAwG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-19_03,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204190052
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/4/22 19:43, Matthew Rosato wrote:
> The function handle is a system-wide unique identifier for a zPCI
> device.  It is used as input for various zPCI operations.

The comment is a little too much obvious.
May be add something like.
"
With the legacy instruction interception the PCI instructions used to be 
executed by the host.
With PCI instruction interpretation, the guest needs to use the real 
function handle.
Let's give it to the guest.
"
Or something like that.

With a better comment:

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>

> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   drivers/vfio/pci/vfio_pci_zdev.c | 5 +++--
>   include/uapi/linux/vfio_zdev.h   | 3 +++
>   2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
> index ea4c0d2b0663..4a653ce480c7 100644
> --- a/drivers/vfio/pci/vfio_pci_zdev.c
> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
> @@ -23,14 +23,15 @@ static int zpci_base_cap(struct zpci_dev *zdev, struct vfio_info_cap *caps)
>   {
>   	struct vfio_device_info_cap_zpci_base cap = {
>   		.header.id = VFIO_DEVICE_INFO_CAP_ZPCI_BASE,
> -		.header.version = 1,
> +		.header.version = 2,
>   		.start_dma = zdev->start_dma,
>   		.end_dma = zdev->end_dma,
>   		.pchid = zdev->pchid,
>   		.vfn = zdev->vfn,
>   		.fmb_length = zdev->fmb_length,
>   		.pft = zdev->pft,
> -		.gid = zdev->pfgid
> +		.gid = zdev->pfgid,
> +		.fh = zdev->fh
>   	};
>   
>   	return vfio_info_add_capability(caps, &cap.header, sizeof(cap));
> diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
> index b4309397b6b2..78c022af3d29 100644
> --- a/include/uapi/linux/vfio_zdev.h
> +++ b/include/uapi/linux/vfio_zdev.h
> @@ -29,6 +29,9 @@ struct vfio_device_info_cap_zpci_base {
>   	__u16 fmb_length;	/* Measurement Block Length (in bytes) */
>   	__u8 pft;		/* PCI Function Type */
>   	__u8 gid;		/* PCI function group ID */
> +	/* End of version 1 */
> +	__u32 fh;		/* PCI function handle */
> +	/* End of version 2 */
>   };
>   
>   /**
> 

-- 
Pierre Morel
IBM Lab Boeblingen

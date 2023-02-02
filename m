Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2512B687DE9
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 13:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbjBBMw5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 07:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjBBMwz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 07:52:55 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D55A7;
        Thu,  2 Feb 2023 04:52:55 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 312C3gva028808;
        Thu, 2 Feb 2023 12:52:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=fOUMm9vaY0LQvEz1no9qV2e22/3sAj99TdI12zctCso=;
 b=aau+3DPTkYLZrJ/MhHlt00lxqX2MoJ77BRl4qNyWYi07HHFJcvyTggz/FyKIWXnWdLTZ
 yNlhiyrBWIfQGLr71pnvFPY6m53gUd0CZIIeG9pdf7cGI7oHPDybVHN10ePkQRXxZZd4
 ocWQ0dVDv/387PU74Aa2PgXi5wuMaT53mjNya4R4QCMGEBZTn/jkK/OAx/5tAx8Lcg/K
 bMAX0ZCf0R6TWUOFaxQuh45FDCC5BP0so6OFSwwmMvEkiDO+81Y5T3Cn6jsKBwUXJMxH
 ZBQCqhQT72b9qi9Ke/NOruwJtuK+ZEpUqt7KHjOqRKTVQ3X5YqwH4r9uiG4vChFnVdWK oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ng78h1bqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 12:52:51 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 312BJxOq019471;
        Thu, 2 Feb 2023 12:52:50 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ng78h1bq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 12:52:50 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 312A1TJN006508;
        Thu, 2 Feb 2023 12:52:49 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([9.208.129.113])
        by ppma01dal.us.ibm.com (PPS) with ESMTPS id 3ncvtmt8tf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 12:52:49 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 312CqlVL12321518
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Feb 2023 12:52:47 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29E4B58053;
        Thu,  2 Feb 2023 12:52:47 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C61315805D;
        Thu,  2 Feb 2023 12:52:44 +0000 (GMT)
Received: from [9.65.253.123] (unknown [9.65.253.123])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  2 Feb 2023 12:52:44 +0000 (GMT)
Message-ID: <ee256360-b35b-55c1-d25b-b7abb065df3a@linux.ibm.com>
Date:   Thu, 2 Feb 2023 07:52:44 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2] vfio: fix deadlock between group lock and kvm lock
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Christopherson, , Sean" <seanjc@google.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230201192010.42748-1-mjrosato@linux.ibm.com>
 <20230201162730.685b5332.alex.williamson@redhat.com>
 <BN9PR11MB5276B8F3F6735FF2616128868CD69@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <BN9PR11MB5276B8F3F6735FF2616128868CD69@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XcjC1Kt46PxL2S8wVIGhF-mMiGdE2aU3
X-Proofpoint-ORIG-GUID: o81pid3WShnfEElUozHn3d2Sh9_qJ-gl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-02_04,2023-02-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302020112
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/1/23 11:10 PM, Tian, Kevin wrote:
>> From: Alex Williamson <alex.williamson@redhat.com>
>> Sent: Thursday, February 2, 2023 7:28 AM
>>>
>>> +#ifdef CONFIG_HAVE_KVM
>>> +static bool vfio_kvm_get_kvm_safe(struct vfio_device *device, struct kvm
>> *kvm)
>>
>> I'm tempted to name these vfio_device_get_kvm_safe() and only pass the
>> vfio_device, where of course we can get the kvm pointer from the group
>> internally.
>>
> 
> I have a different thought. In the end the cdev series also need the similar
> safe get/put logic then it's better to keep it in vfio_main.c called by
> the group/cdev path individually.

Ah, I hadn't considered the cdev series - OK, I can move the functions back into vfio_main and externalize both via drivers/vfio/vfio.h so they can be called from group.c for this fix and then available to vfio_main.c already for cdev.

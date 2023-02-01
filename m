Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5F6168688C
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 15:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbjBAOlj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 09:41:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbjBAOld (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 09:41:33 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F706953B;
        Wed,  1 Feb 2023 06:41:25 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 311ELMCC012947;
        Wed, 1 Feb 2023 14:41:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Pghwgw7p54xgyN9qvh8HSRlvihxDFi0FYDGjkwN9hfQ=;
 b=KB+5oFs7D3P74ddhr0ubhPjwvgMwPNg0zmRJ/qQv81hNu8xJnBvcDZx47tDr0KeOXuIN
 7unHMwuYhGXgzAAUT+nGwXn5FPg3nd+YcRW0wItD1M7Squ4JHUmnE/P67mbAl3lxZ1Un
 JDNc601NmU7ChhDq7btkIvuw2Q/Wel5u4fUmom/PeiM8ojxs4YORjAz9GgDCWTHDZtly
 t5UpcNpWra2Z1pqyuVsrvPreZya0n2Mygg0mX/fWDr7PsgBNOxnI1BvhIqjjmg5DYGwS
 VIvLlW7kI2B1O6OmgSnb5Uypg+JoscDJlsLDinr4mTV9xOPjB5XmQc7sBgXwm2R62rBm pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nfss7gk1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 14:41:22 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 311EMqpS017781;
        Wed, 1 Feb 2023 14:41:21 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nfss7gk17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 14:41:21 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 311DBe48019159;
        Wed, 1 Feb 2023 14:41:20 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([9.208.129.120])
        by ppma02dal.us.ibm.com (PPS) with ESMTPS id 3ncvuqunpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 14:41:20 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
        by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 311EfI587340750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Feb 2023 14:41:18 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 733895805E;
        Wed,  1 Feb 2023 14:41:18 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09FDC58052;
        Wed,  1 Feb 2023 14:41:16 +0000 (GMT)
Received: from [9.65.253.123] (unknown [9.65.253.123])
        by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  1 Feb 2023 14:41:15 +0000 (GMT)
Message-ID: <7879b29d-5cf5-c9f6-cc36-fb9ce6c0d2d4@linux.ibm.com>
Date:   Wed, 1 Feb 2023 09:41:15 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] vfio: fix deadlock between group lock and kvm lock
Content-Language: en-US
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
Cc:     "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230131200635.44227-1-mjrosato@linux.ibm.com>
 <DS0PR11MB752972035A4CE4B2319A6C45C3D19@DS0PR11MB7529.namprd11.prod.outlook.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <DS0PR11MB752972035A4CE4B2319A6C45C3D19@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oWB3pJerof2Dt5aM4oiHXKVIqzotBGLN
X-Proofpoint-ORIG-GUID: BtkvJrH744mvpTcVM5fLTJoJKq6hIf8X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-01_04,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 mlxlogscore=782 clxscore=1015 impostorscore=0 phishscore=0 adultscore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302010125
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/1/23 7:42 AM, Liu, Yi L wrote:
>> From: Matthew Rosato <mjrosato@linux.ibm.com>
...
>> +	if (device->kvm) {
>> +		vfio_kvm_put_kvm(device);
>> +		device->put_kvm = NULL;
> 
> Can "device->put_kvm = NULL;" be part of vfio_kvm_put_kvm()?

Sure


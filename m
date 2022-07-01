Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8F25633AE
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 14:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236673AbiGAMsg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 08:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234131AbiGAMsf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 08:48:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C8264D6;
        Fri,  1 Jul 2022 05:48:34 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 261CcTGi026673;
        Fri, 1 Jul 2022 12:48:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=N5otmh3RWkGqEmk17omQvd7emcBe0VGnTJHTwOW3C0o=;
 b=TH9EyLBFXrIFCyQhI6jHkoqTYdOLk1cpOMXOfj5O8SnsomRopRqfzLMP/kllM04LAJES
 Jb76UP5qKQxELOVtLZklvYszF0akcgffvJwaxsO0BaVbQKKleH8K5Dls7GNsv+w7K9w/
 RU94gKo0w6gFWbh0gxqBxXMNYxel0H+XVseRjglC9FFCfLrOqelkGuPknb7u07slECz4
 h03zNMIkMg4o9M2uDrWMkzzF4YrOmGwnZK6YPlazeNhDlvEe+qbQPGuCuARKa7bMjMSd
 F12qf7izt1vLUrHxMuRV9ExmOJhY90mmlD4ERgmSeY8R7PwBWogFwfcw126Rx6zeMj7/ 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h20up8uwn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Jul 2022 12:48:32 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 261Cm9g2018685;
        Fri, 1 Jul 2022 12:48:31 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h20up8uvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Jul 2022 12:48:31 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 261CZQtC010856;
        Fri, 1 Jul 2022 12:48:29 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3gwsmj9rfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Jul 2022 12:48:28 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 261CmPth20513100
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Jul 2022 12:48:25 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2B3D5204E;
        Fri,  1 Jul 2022 12:48:25 +0000 (GMT)
Received: from [9.171.7.21] (unknown [9.171.7.21])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 54AD952050;
        Fri,  1 Jul 2022 12:48:25 +0000 (GMT)
Message-ID: <f21307d9-6490-c39d-cff0-2a50c5f1cb35@linux.ibm.com>
Date:   Fri, 1 Jul 2022 14:48:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3 00/11] s390/vfio-ccw rework
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20220630203647.2529815-1-farman@linux.ibm.com>
 <20220630234411.GM693670@nvidia.com>
 <e8f1748eb1bae3e90521b0d5d4471266f4ea7c98.camel@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <e8f1748eb1bae3e90521b0d5d4471266f4ea7c98.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZR5_WJYeDCv8aQktZaDuX1SAnSY2245D
X-Proofpoint-ORIG-GUID: Nw_VsRTrm-S7xeHzrT_-jklJGaSY0n0U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-01_07,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1011
 mlxscore=0 lowpriorityscore=0 spamscore=0 adultscore=0 mlxlogscore=931
 bulkscore=0 phishscore=0 priorityscore=1501 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2207010048
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 01.07.22 um 14:40 schrieb Eric Farman:
> On Thu, 2022-06-30 at 20:44 -0300, Jason Gunthorpe wrote:
>> On Thu, Jun 30, 2022 at 10:36:36PM +0200, Eric Farman wrote:
>>> Here's an updated pass through the first chunk of vfio-ccw rework.
>>>
>>> As with v2, this is all internal to vfio-ccw, with the exception of
>>> the removal of mdev_uuid from include/linux/mdev.h in patch 1.
>>>
>>> There is one conflict with the vfio-next branch [2], on patch 6.
>>
>> What tree do you plan to take it through?
> 
> Don't know. I know Matt's PCI series has a conflict with this same
> patch also, but I haven't seen resolution to that. @Christian,
> thoughts?


What about me making a topic branch that it being merged by Alex AND the KVM tree
so that each of the conflicts can be solved in that way?

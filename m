Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E172E5286C7
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 16:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244408AbiEPOSS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 10:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbiEPOSP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 10:18:15 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2E83AA6B;
        Mon, 16 May 2022 07:18:14 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GE252R018504;
        Mon, 16 May 2022 14:18:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=yMNOKF07RUOwX1GCechJUNCl+HJAsH8hPOrtwMkUF3w=;
 b=i6+FF2JagaDhRxk6dpZgrOngcOMkTECHhcjd/vlP13567dQA3Tf0qdQn7qvkNu+r9WRP
 Q8ftkQKXJrb+6cWkcUJZen7k52gLl8RvkT2kJbYlKYSHMthUyYUy0eWIqOp+ybLbMBRy
 vUSbYJrLbVmRs9cBYFUhvr/UGxplRgXeMudWkh4ZGbxiq86l9AR7dVVTk7NQhGOZbPr8
 O286iPFGbNsZRpA752rj+xHlMXY+oKnu+9Tq6ow0AIIfwg2EMco2/SQxow95U1Nksvuk
 OEyWTY6ku2g+jcRnK5tdvd4bT6Hwnk8A8y/IjS45ba5ukv/k7jd+lGsXXTLHmCvAlODC jQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3r150dnr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 14:18:14 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24GE2JXk019751;
        Mon, 16 May 2022 14:18:14 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3r150dmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 14:18:13 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24GEI3Cx014376;
        Mon, 16 May 2022 14:18:11 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3g23pjatnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 14:18:10 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24GEHaLp34341120
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 14:17:36 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74292A404D;
        Mon, 16 May 2022 14:18:07 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C489BA4040;
        Mon, 16 May 2022 14:18:06 +0000 (GMT)
Received: from [9.171.15.172] (unknown [9.171.15.172])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 14:18:06 +0000 (GMT)
Message-ID: <bae4e416-b0e9-31c6-c9d0-df6b5a5fd46f@linux.ibm.com>
Date:   Mon, 16 May 2022 16:21:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v9 3/3] s390x: KVM: resetting the Topology-Change-Report
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, thuth@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com, wintera@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220506092403.47406-1-pmorel@linux.ibm.com>
 <20220506092403.47406-4-pmorel@linux.ibm.com>
 <76fd0c11-5b9b-0032-183b-54db650f13b1@redhat.com>
 <20220512115250.2e20bfdf@p-imbrenda>
 <70a7d93c-c1b1-fa72-0eb4-02e3e2235f94@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <70a7d93c-c1b1-fa72-0eb4-02e3e2235f94@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: G9x7Bk-epVV11i7POlxqSnH3IOodtMW3
X-Proofpoint-ORIG-GUID: Qcb0VTL_5kUfnZA07UnfESspfT1_K6bq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_13,2022-05-16_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 phishscore=0 suspectscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=966 bulkscore=0 priorityscore=1501 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205160079
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/12/22 12:01, David Hildenbrand wrote:
>>>
>>> I think we prefer something like u16 when copying to user space.
>>
>> but then userspace also has to expect a u16, right?
> 
> Yep.
> 

Yes but in fact, inspired by previous discussion I had on the VFIO 
interface, that is the reason why I did prefer an int.
It is much simpler than a u16 and the definition of a bit.

Despite a bit in a u16 is what the s3990 achitecture proposes I thought 
we could make it easier on the KVM/QEMU interface.

But if the discussion stops here, I will do as you both propose change 
to u16 in KVM and userland and add the documentation for the interface.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen

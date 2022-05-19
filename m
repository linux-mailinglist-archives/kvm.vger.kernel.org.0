Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4071752CEDA
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 11:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235748AbiESJBj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 05:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233283AbiESJBg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 05:01:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B8C340F1;
        Thu, 19 May 2022 02:01:35 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24J8GNQD006931;
        Thu, 19 May 2022 09:01:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=hqtw9iKEIdORIKukZHNl3n2cAgbzR2rjnUa/NIrGhOs=;
 b=gc6BAGUj2LD24mYZDvaxzhpmqa3jkdw5dTXyJj31rA2B2cDwOoTCS97PghLeDgGQjuVB
 hO0NQpPpDL4R3DxQpsCYt2t0y0NZGvAlGzG+G9Caj8bhRjFsB+OIf2ineNrzt7qzYRj2
 eaIslSX4bKjuXYNDFik9D0x5fqhZJ7Hzmjsqnk6rqOFosVhw1/KswhQuzA5tMq0inzZN
 Sh2211O7XTIzlJRIQBKTUTXtgDu5chCBp7ISWYcdWwljh5ZduwvnvkQzteFoeGhUEQRV
 KRlnAYso08hsA6X42624GjKSQxKgX4Q2kJIBKibYd6W2PxLTTH/hwbSusIGQKjXR6dMz Ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g5j7xgxtx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 09:01:34 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24J8l8SZ003882;
        Thu, 19 May 2022 09:01:33 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g5j7xgxt3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 09:01:33 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24J8wiI6020848;
        Thu, 19 May 2022 09:01:31 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3g2428wmqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 09:01:31 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24J91RgX59113822
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 09:01:27 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2F334C044;
        Thu, 19 May 2022 09:01:27 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D1FB4C040;
        Thu, 19 May 2022 09:01:27 +0000 (GMT)
Received: from [9.171.62.1] (unknown [9.171.62.1])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 19 May 2022 09:01:27 +0000 (GMT)
Message-ID: <6060cfc8-6ae9-1710-3022-1edfbf53b1ca@de.ibm.com>
Date:   Thu, 19 May 2022 11:01:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v9 2/3] s390x: KVM: guest support for topology function
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        frankja@linux.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, wintera@linux.ibm.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
References: <20220506092403.47406-1-pmorel@linux.ibm.com>
 <20220506092403.47406-3-pmorel@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <20220506092403.47406-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZEhNCHMUTscsRMlEzW6Ljpk70RL7rqQE
X-Proofpoint-ORIG-GUID: fQCwIjp9idH_71e1DkTjHc-vFXVWdTAb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-19_01,2022-05-19_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 adultscore=0 suspectscore=0 clxscore=1015 impostorscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205190049
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 06.05.22 um 11:24 schrieb Pierre Morel:
> We let the userland hypervisor know if the machine support the CPU
> topology facility using a new KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
> 
> The PTF instruction will report a topology change if there is any change
> with a previous STSI_15_1_2 SYSIB.
> Changes inside a STSI_15_1_2 SYSIB occur if CPU bits are set or clear
> inside the CPU Topology List Entry CPU mask field, which happens with
> changes in CPU polarization, dedication, CPU types and adding or
> removing CPUs in a socket.
> 
> The reporting to the guest is done using the Multiprocessor
> Topology-Change-Report (MTCR) bit of the utility entry of the guest's
> SCA which will be cleared during the interpretation of PTF.
> 
> To check if the topology has been modified we use a new field of the
> arch vCPU to save the previous real CPU ID at the end of a schedule
> and verify on next schedule that the CPU used is in the same socket.
> We do not report polarization, CPU Type or dedication change.

I think we should not do this. When PTF returns with "has changed" the guest
Linux will rebuild its schedule domains. And this is a really expensive
operation as far as I can tell. And the host Linux scheduler WILL schedule
too often to other CPUs. So in essence this will result in Linux guests
rebuilding their scheduler domains all the time.
So remove the "previous CPU logic" for now and only trigger an MTCR when
userspace says so.  (eg. on config changes). The idea was to have user
defined schedule domains. Following host schedule decisions will be
nearly impossible.

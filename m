Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4D535AD698
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 17:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238981AbiIEPcH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 11:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238975AbiIEPbt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 11:31:49 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D536173C
        for <kvm@vger.kernel.org>; Mon,  5 Sep 2022 08:30:13 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 285F31j4031882;
        Mon, 5 Sep 2022 15:30:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=j9LcXrbPdt03AgWXUjW7bxocRRURAlvokntiJTbus4k=;
 b=C/ed0Cz93RqbvbDQ/6k6jQjs62QTrzssi7y5Ovof+bgaFW1ocgSYKmiN4F3uinJ06PWk
 5X1Vx9EEjPyebmdr6YEGWK39VA7hjoPvpfmZpQXi7mThQk782hTqQ/MMIcv5T9PNmNFs
 7gUYsM2lRZ8yumd/gIV+yy1ikkX2Eg8h8idOMY67q74tYfOVFHTiFZeYGoJmwYNrQUST
 o/C8GK0EUvKz4ExlH67omw2o4G1qsyW1QIW0ulBR4P/HtbOR50jJrPCQJcPPK2icPnjP
 UZJFbIndsjmMbGEVuWIgvmqrtFgQyvefrQZVIPXeynfh6t4YHVEBbIZOA1PZAvaEzuJc bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jdkdpgnau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Sep 2022 15:30:06 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 285FM31x011997;
        Mon, 5 Sep 2022 15:30:06 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jdkdpgn9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Sep 2022 15:30:06 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 285FMcCX012914;
        Mon, 5 Sep 2022 15:30:04 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3jbxj8tm16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Sep 2022 15:30:04 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 285FU1u429294868
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Sep 2022 15:30:01 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDAE05204E;
        Mon,  5 Sep 2022 15:30:00 +0000 (GMT)
Received: from [9.171.61.194] (unknown [9.171.61.194])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E1B645204F;
        Mon,  5 Sep 2022 15:29:58 +0000 (GMT)
Message-ID: <d32b462c-00f9-20e3-c901-f040d54f2fec@linux.ibm.com>
Date:   Mon, 5 Sep 2022 17:29:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v9 09/10] s390x/cpu_topology: activating CPU topology
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
 <20220902075531.188916-10-pmorel@linux.ibm.com>
In-Reply-To: <20220902075531.188916-10-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NyUho0IlnbOJiKR_GC9xZQLdcwTFEyv3
X-Proofpoint-ORIG-GUID: XSgfZyM4tYllbpGxRH3HWO_ACh_SA6jo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-05_09,2022-09-05_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 mlxlogscore=736 clxscore=1015 adultscore=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209050072
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/2/22 09:55, Pierre Morel wrote:
> Starting with a new machine, s390-virtio-ccw-7.2, the machine
> property topology-disable is set to false while it is kept to
> true for older machine.
> This allows migrating older machine without disabling the ctop
> CPU feature for older machine, thus keeping existing start scripts.
> 
> The KVM capability, KVM_CAP_S390_CPU_TOPOLOGY is used to
> activate the S390_FEAT_CONFIGURATION_TOPOLOGY feature and
> the topology facility for the guest in the case the topology
> is not disabled.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---

Sorry, forget this patch I made a stupid rebase error and lost half of 
the code.

-- 
Pierre Morel
IBM Lab Boeblingen

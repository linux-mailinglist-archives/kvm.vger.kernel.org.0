Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3EA719725
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 11:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbjFAJiz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 05:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232893AbjFAJis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 05:38:48 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDC2139;
        Thu,  1 Jun 2023 02:38:45 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3519DUQm009993;
        Thu, 1 Jun 2023 09:38:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2h6XdwlF42uVTLMo3fFibWv4lmv2RtHqmk9EUx0o8IM=;
 b=p2/+VCmBOc7K4cclIEEDqk42EPyf9cllSmH+Mxl5rPvZNsGNIhKfU7d9WjNiy9bTTh1Z
 VixmkVWil9QFrvtDNBy0P7cCmXzFx21Er1uBiVIvPxbGhVNSYv874onWjaUfgYlxnGKV
 2GvG64vrFUG0lIPWkoKsOsKvQflrbz0mUbHFj7RIsYin93j986hu5ycAp9jrfLOYyer4
 /MRHn6Lj0buX4NykMbGCp956xE5Zag0Dv9KU+Ey/EBTfeHyqBV1QrKgnuqACYn00HCc7
 svD+DLUsGUdkELc+U5u2lnlimenUnkIa6rRBrh3eOOdmzo+bFboWo2H3Qk2/u9N3xx3b 3g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxrgw0x06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 09:38:44 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3519E4TA014850;
        Thu, 1 Jun 2023 09:38:43 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxrgw0wx8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 09:38:43 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3517SEmK023405;
        Thu, 1 Jun 2023 09:38:42 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3qu94ea1j4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 09:38:41 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3519cc1V13173310
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Jun 2023 09:38:38 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4AA902004D;
        Thu,  1 Jun 2023 09:38:38 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D999E2004B;
        Thu,  1 Jun 2023 09:38:37 +0000 (GMT)
Received: from [9.171.14.211] (unknown [9.171.14.211])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  1 Jun 2023 09:38:37 +0000 (GMT)
Message-ID: <fa415627-bfff-cc18-af94-cf55632973d5@linux.ibm.com>
Date:   Thu, 1 Jun 2023 11:38:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [kvm-unit-tests PATCH v9 2/2] s390x: topology: Checking
 Configuration Topology Information
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     thuth@redhat.com, kvm@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, nrb@linux.ibm.com, nsg@linux.ibm.com
References: <20230519112236.14332-1-pmorel@linux.ibm.com>
 <20230519112236.14332-3-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230519112236.14332-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YBZfkvzYkaNcYubwRQHBqcC0eVE1niii
X-Proofpoint-GUID: HgKLQbnNHKyks-q476gNyakkrZ7CLHMH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_06,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 priorityscore=1501 clxscore=1015 spamscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2304280000 definitions=main-2306010085
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/19/23 13:22, Pierre Morel wrote:
> STSI with function code 15 is used to store the CPU configuration
> topology.
> 
> We retrieve the maximum nested level with SCLP and use the
> topology tree provided by the drawers, books, sockets, cores
> arguments.
> 
> We check :
> - if the topology stored is coherent between the QEMU -smp
>    parameters and kernel parameters.
> - the number of CPUs
> - the maximum number of CPUs
> - the number of containers of each levels for every STSI(15.1.x)
>    instruction allowed by the machine.

>   [topology]
>   file = topology.elf
> +# 3 CPUs on socket 0 with different CPU TLE (standard, dedicated, origin)
> +# 1 CPU on socket 2
> +extra_params = -smp 1,drawers=3,books=3,sockets=4,cores=4,maxcpus=144 -cpu z14,ctop=on -device z14-s390x-cpu,core-id=1,entitlement=low -device z14-s390x-cpu,core-id=2,dedicated=on -device z14-s390x-cpu,core-id=10 -device z14-s390x-cpu,core-id=20 -device z14-s390x-cpu,core-id=130,socket-id=0,book-id=0,drawer-id=0 -append '-drawers 3 -books 3 -sockets 4 -cores 4'
> +
> +[topology-2]
> +file = topology.elf
> +extra_params = -smp 1,drawers=2,books=2,sockets=2,cores=30,maxcpus=240  -append '-drawers 2 -books 2 -sockets 2 -cores 30' -cpu z14,ctop=on -device z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=2,entitlement=low -device z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=3,entitlement=medium -device z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=4,entitlement=high -device z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=5,entitlement=high,dedicated=on -device z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=65,entitlement=low -device z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=66,entitlement=medium -device z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=67,entitlement=high -device z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=68,entitlement=high,dedicated=on

Pardon my ignorance but I see z14 in there, will this work if we run on 
a z13?

Also, will this work/fail gracefully if the test is run with a quemu 
that doesn't know about topology or will it crash?

